import 'dart:math';

import '../../children/models/child.dart';

import '../data/vaccine_repository.dart';
import '../data/vaccine_schedule_loader.dart';

import '../models/vaccine.dart';
import '../models/vaccine_record.dart';

enum VaccineStatus {
  applied,
  notApplied,
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

  static final VaccineService instance = VaccineService._();

  Future<List<VaccineEvaluation>> evaluateChild(
    Child child,
  ) async {
    final List<VaccineDose> schedule =
        await VaccineScheduleLoader.instance.loadSchedule();

    final List<VaccineRecord> records =
        await VaccineRepository.instance.getRecordsForChild(child.id);

    final Map<String, VaccineRecord> recordByScheduleId = {
      for (final record in records) record.scheduleId: record,
    };

    final List<VaccineEvaluation> evaluations = [];

    for (final VaccineDose dose in schedule) {
      final VaccineRecord? record = recordByScheduleId[dose.id];

      // Un registro, sea aplicada o no aplicada, representa una decisión
      // terminada para esa dosis y por tanto habilita la siguiente.
      if (record != null) {
        evaluations.add(
          VaccineEvaluation(
            dose: dose,
            status: record.isApplied
                ? VaccineStatus.applied
                : VaccineStatus.notApplied,
            record: record,
            expectedDate: _calculateExpectedDate(
              child: child,
              dose: dose,
              records: recordByScheduleId,
            ),
          ),
        );
        continue;
      }

      final String? previousDoseId = dose.previousDoseId;

      // Solo se bloquea cuando todavía no existe ninguna decisión
      // sobre la dosis anterior.
      if (previousDoseId != null &&
          recordByScheduleId[previousDoseId] == null) {
        DateTime? expectedDate;

        if (dose.isFixedAge) {
          expectedDate = _calculateExpectedDate(
            child: child,
            dose: dose,
            records: recordByScheduleId,
          );
        }

        evaluations.add(
          VaccineEvaluation(
            dose: dose,
            status: VaccineStatus.waitingPreviousDose,
            expectedDate: expectedDate,
          ),
        );
        continue;
      }

      // Dosis cuyo calendario depende de una dosis previa.
      if (dose.isInterval) {
        if (previousDoseId == null) {
          evaluations.add(
            VaccineEvaluation(
              dose: dose,
              status: VaccineStatus.waitingPreviousDose,
            ),
          );
          continue;
        }

        final VaccineRecord previousRecord =
            recordByScheduleId[previousDoseId]!;

        // La anterior fue registrada como "No aplicada":
        // esta dosis queda habilitada, pero no inventamos una fecha
        // basada en un intervalo que nunca comenzó.
        if (previousRecord.isNotApplied) {
          evaluations.add(
            VaccineEvaluation(
              dose: dose,
              status: VaccineStatus.review,
              expectedDate: null,
            ),
          );
          continue;
        }

        final DateTime expectedDate = _addDays(
          previousRecord.appliedDate,
          dose.intervalDays ?? 0,
        );

        evaluations.add(
          VaccineEvaluation(
            dose: dose,
            expectedDate: expectedDate,
            status: _statusForDate(expectedDate),
          ),
        );
        continue;
      }

      // Vacunación estacional.
      if (dose.isSeasonal) {
        final int minAgeMonths = dose.minAgeMonths ?? 0;
        final DateTime startDate =
            _addMonths(child.birthDate, minAgeMonths);

        evaluations.add(
          VaccineEvaluation(
            dose: dose,
            expectedDate: _isTodayOrFuture(startDate) ? startDate : null,
            status: _isTodayOrFuture(startDate)
                ? VaccineStatus.upcoming
                : VaccineStatus.seasonalReview,
          ),
        );
        continue;
      }

      // Vacunas con edad fija.
      final DateTime? expectedDate = _calculateExpectedDate(
        child: child,
        dose: dose,
        records: recordByScheduleId,
      );

      if (expectedDate == null) {
        continue;
      }

      evaluations.add(
        VaccineEvaluation(
          dose: dose,
          expectedDate: expectedDate,
          status: _statusForDate(expectedDate),
        ),
      );
    }

    return evaluations;
  }

  VaccineStatus _statusForDate(DateTime expectedDate) {
    if (_isTodayOrFuture(expectedDate)) {
      return VaccineStatus.upcoming;
    }

    return VaccineStatus.review;
  }

  DateTime? _calculateExpectedDate({
    required Child child,
    required VaccineDose dose,
    required Map<String, VaccineRecord> records,
  }) {
    if (dose.isFixedAge) {
      DateTime result =
          _addMonths(child.birthDate, dose.targetMonths ?? 0);

      if (dose.targetDays > 0) {
        result = _addDays(result, dose.targetDays);
      }

      return result;
    }

    if (dose.isInterval) {
      final String? previousDoseId = dose.previousDoseId;

      if (previousDoseId == null) {
        return null;
      }

      final VaccineRecord? previous = records[previousDoseId];

      // Sin dosis aplicada no existe un punto real desde el que
      // calcular el intervalo.
      if (previous == null || previous.isNotApplied) {
        return null;
      }

      return _addDays(
        previous.appliedDate,
        dose.intervalDays ?? 0,
      );
    }

    return null;
  }

  DateTime _addMonths(DateTime date, int months) {
    final int monthIndex = date.month - 1 + months;
    final int year = date.year + (monthIndex ~/ 12);
    final int month = (monthIndex % 12) + 1;

    final int lastDay = DateTime(year, month + 1, 0).day;
    final int day = min(date.day, lastDay);

    return DateTime(year, month, day);
  }

  DateTime _addDays(DateTime date, int days) {
    return DateTime(
      date.year,
      date.month,
      date.day + days,
    );
  }

  bool _isTodayOrFuture(DateTime date) {
    final DateTime today = _dateOnly(DateTime.now());
    final DateTime target = _dateOnly(date);

    return target.isAtSameMomentAs(today) || target.isAfter(today);
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
