import 'dart:math';

import '../../children/models/child.dart';

import '../data/vaccine_repository.dart';
import '../data/vaccine_schedule_loader.dart';

import '../models/vaccine.dart';
import '../models/vaccine_record.dart';

enum VaccineStatus {
  applied,
  upcoming,
  review,
  seasonalReview,
  waitingPreviousDose,
}

class VaccineEvaluation {
  final VaccineDose dose;
  final VaccineStatus status;
  final DateTime? expectedDate;
  final VaccineRecord? record;

  const VaccineEvaluation({
    required this.dose,
    required this.status,
    this.expectedDate,
    this.record,
  });
}

class VaccineService {
  VaccineService._();

  static final VaccineService instance =
      VaccineService._();

  Future<List<VaccineEvaluation>> evaluateChild(
    Child child,
  ) async {
    final List<VaccineDose> schedule =
        await VaccineScheduleLoader.instance
            .loadSchedule();

    final List<VaccineRecord> records =
        await VaccineRepository.instance
            .getRecordsForChild(
      child.id,
    );

    final Map<String, VaccineRecord>
        recordByScheduleId = {
      for (final record in records)
        record.scheduleId: record,
    };

    final List<VaccineEvaluation>
        evaluations = [];

    for (final VaccineDose dose in schedule) {
      final VaccineRecord? record =
          recordByScheduleId[dose.id];

      // ==========================================================
      // VACUNA YA REGISTRADA
      // ==========================================================

      if (record != null) {
        evaluations.add(
          VaccineEvaluation(
            dose: dose,
            status:
                VaccineStatus.applied,
            record: record,
            expectedDate:
                _calculateExpectedDate(
              child: child,
              dose: dose,
              records:
                  recordByScheduleId,
            ),
          ),
        );

        continue;
      }

      // ==========================================================
      // COMPROBAR REQUISITO DE DOSIS ANTERIOR
      //
      // Esto funciona tanto para:
      // - segunda dosis
      // - tercera dosis
      // - refuerzos
      // - dosis por intervalo
      // ==========================================================

      final String? previousDoseId =
          dose.previousDoseId;

      if (previousDoseId != null) {
        final VaccineRecord?
            previousRecord =
            recordByScheduleId[
                previousDoseId];

        // --------------------------------------------------------
        // SI FALTA LA DOSIS ANTERIOR, SE BLOQUEA
        // --------------------------------------------------------

        if (previousRecord == null) {
          DateTime? expectedDate;

          // Las vacunas de edad fija sí pueden mostrar
          // su fecha de referencia aunque estén bloqueadas.
          if (dose.isFixedAge) {
            expectedDate =
                _calculateExpectedDate(
              child: child,
              dose: dose,
              records:
                  recordByScheduleId,
            );
          }

          evaluations.add(
            VaccineEvaluation(
              dose: dose,
              status:
                  VaccineStatus
                      .waitingPreviousDose,
              expectedDate:
                  expectedDate,
            ),
          );

          continue;
        }
      }

      // ==========================================================
      // DOSIS BASADA EN INTERVALO
      // ==========================================================

      if (dose.isInterval) {
        final String? previousDoseId =
            dose.previousDoseId;

        if (previousDoseId == null) {
          evaluations.add(
            VaccineEvaluation(
              dose: dose,
              status:
                  VaccineStatus
                      .waitingPreviousDose,
            ),
          );

          continue;
        }

        final VaccineRecord?
            previousRecord =
            recordByScheduleId[
                previousDoseId];

        if (previousRecord == null) {
          evaluations.add(
            VaccineEvaluation(
              dose: dose,
              status:
                  VaccineStatus
                      .waitingPreviousDose,
            ),
          );

          continue;
        }

        final DateTime expectedDate =
            _addDays(
          previousRecord.appliedDate,
          dose.intervalDays ?? 0,
        );

        evaluations.add(
          VaccineEvaluation(
            dose: dose,
            expectedDate:
                expectedDate,
            status:
                _statusForDate(
              expectedDate,
            ),
          ),
        );

        continue;
      }

      // ==========================================================
      // VACUNACIÓN ESTACIONAL
      // ==========================================================

      if (dose.isSeasonal) {
        final int minAgeMonths =
            dose.minAgeMonths ?? 0;

        final DateTime startDate =
            _addMonths(
          child.birthDate,
          minAgeMonths,
        );

        if (_isTodayOrFuture(
          startDate,
        )) {
          evaluations.add(
            VaccineEvaluation(
              dose: dose,
              expectedDate:
                  startDate,
              status:
                  VaccineStatus
                      .upcoming,
            ),
          );
        } else {
          evaluations.add(
            VaccineEvaluation(
              dose: dose,
              status:
                  VaccineStatus
                      .seasonalReview,
            ),
          );
        }

        continue;
      }

      // ==========================================================
      // VACUNAS CON EDAD FIJA
      // ==========================================================

      final DateTime? expectedDate =
          _calculateExpectedDate(
        child: child,
        dose: dose,
        records:
            recordByScheduleId,
      );

      if (expectedDate == null) {
        continue;
      }

      evaluations.add(
        VaccineEvaluation(
          dose: dose,
          expectedDate:
              expectedDate,
          status:
              _statusForDate(
            expectedDate,
          ),
        ),
      );
    }

    return evaluations;
  }

  // ============================================================
  // ESTADO SEGÚN FECHA
  // ============================================================

  VaccineStatus _statusForDate(
    DateTime expectedDate,
  ) {
    if (_isTodayOrFuture(
      expectedDate,
    )) {
      return VaccineStatus.upcoming;
    }

    return VaccineStatus.review;
  }

  // ============================================================
  // CALCULAR FECHA ESPERADA
  // ============================================================

  DateTime? _calculateExpectedDate({
    required Child child,
    required VaccineDose dose,
    required Map<String, VaccineRecord>
        records,
  }) {
    // ----------------------------------------------------------
    // EDAD FIJA
    // ----------------------------------------------------------

    if (dose.isFixedAge) {
      DateTime result =
          _addMonths(
        child.birthDate,
        dose.targetMonths ?? 0,
      );

      if (dose.targetDays > 0) {
        result =
            _addDays(
          result,
          dose.targetDays,
        );
      }

      return result;
    }

    // ----------------------------------------------------------
    // INTERVALO DESPUÉS DE DOSIS ANTERIOR
    // ----------------------------------------------------------

    if (dose.isInterval) {
      final String? previousDoseId =
          dose.previousDoseId;

      if (previousDoseId == null) {
        return null;
      }

      final VaccineRecord? previous =
          records[
              previousDoseId];

      if (previous == null) {
        return null;
      }

      return _addDays(
        previous.appliedDate,
        dose.intervalDays ?? 0,
      );
    }

    return null;
  }

  // ============================================================
  // AGREGAR MESES
  // ============================================================

  DateTime _addMonths(
    DateTime date,
    int months,
  ) {
    final int monthIndex =
        date.month - 1 + months;

    final int year =
        date.year +
            (monthIndex ~/ 12);

    final int month =
        (monthIndex % 12) + 1;

    final int lastDay =
        DateTime(
      year,
      month + 1,
      0,
    ).day;

    final int day =
        min(
      date.day,
      lastDay,
    );

    return DateTime(
      year,
      month,
      day,
    );
  }

  // ============================================================
  // AGREGAR DÍAS
  // ============================================================

  DateTime _addDays(
    DateTime date,
    int days,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day + days,
    );
  }

  // ============================================================
  // COMPARAR FECHAS
  // ============================================================

  bool _isTodayOrFuture(
    DateTime date,
  ) {
    final DateTime today =
        _dateOnly(
      DateTime.now(),
    );

    final DateTime target =
        _dateOnly(
      date,
    );

    return target.isAtSameMomentAs(
          today,
        ) ||
        target.isAfter(
          today,
        );
  }

  DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}