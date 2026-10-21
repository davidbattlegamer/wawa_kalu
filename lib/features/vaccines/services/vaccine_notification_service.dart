import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../pages/app_texts.dart';

import '../../children/data/child_repository.dart';
import '../../children/models/child.dart';

import '../data/vaccine_schedule_loader.dart';
import '../models/vaccine.dart';
import 'vaccine_service.dart';

class VaccineNotificationService {
  VaccineNotificationService._();

  static final VaccineNotificationService instance =
      VaccineNotificationService._();

  static const String _enabledKey =
      'vaccine_reminders_enabled';

  // 0 conserva los avisos originales: 7, 1 y 0 días antes.
  // Las opciones personalizadas repiten el aviso durante la semana
  // anterior, incluyendo siempre el mismo día de la dosis.
  static const String _intervalKey = 'vaccine_reminder_interval_days';
  static const List<int> allowedIntervals = <int>[0, 1, 2, 3, 7];

  static List<int> reminderOffsetsFor(int intervalDays) {
    if (intervalDays == 0 || !allowedIntervals.contains(intervalDays)) {
      return <int>[7, 1, 0];
    }

    final offsets = <int>[];
    for (int days = 7; days >= 0; days -= intervalDays) {
      offsets.add(days);
    }
    if (!offsets.contains(0)) offsets.add(0);
    return offsets;
  }

  Future<int> getReminderIntervalDays() async {
    final prefs = await SharedPreferences.getInstance();
    final interval = prefs.getInt(_intervalKey) ?? 0;
    return allowedIntervals.contains(interval) ? interval : 0;
  }

  Future<void> setReminderIntervalDays(int intervalDays) async {
    if (!allowedIntervals.contains(intervalDays)) {
      throw ArgumentError.value(intervalDays, 'intervalDays');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_intervalKey, intervalDays);
    if (await isEnabled()) {
      // Cancela los intervalos antiguos y agenda la nueva frecuencia.
      await rescheduleAllChildren();
    }
  }

  Future<bool> isEnabled() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          _enabledKey,
        ) ??
        false;
  }

  Future<bool> setEnabled(
    bool enabled,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    if (enabled) {
      final bool permission =
          await NotificationService.instance
              .requestPermission();

      if (!permission) {
        await prefs.setBool(
          _enabledKey,
          false,
        );

        return false;
      }

      await prefs.setBool(
        _enabledKey,
        true,
      );

      await rescheduleAllChildren();

      return true;
    }

    await prefs.setBool(
      _enabledKey,
      false,
    );

    await cancelAllChildren();

    return false;
  }

  Future<void> refreshIfEnabled() async {
    if (!await isEnabled()) {
      return;
    }

    await rescheduleAllChildren();
  }

  Future<void> rescheduleAllChildren() async {
    if (!await isEnabled()) {
      return;
    }

    for (final Child child
        in ChildRepository.instance.children.value) {
      await rescheduleForChild(
        child,
      );
    }
  }

  Future<void> rescheduleForChild(
    Child child,
  ) async {
    if (!await isEnabled()) {
      return;
    }

    await cancelForChild(
      child,
    );

    final evaluations =
        await VaccineService.instance
            .evaluateChild(
      child,
    );
    final offsets = reminderOffsetsFor(await getReminderIntervalDays());

    for (final evaluation
        in evaluations) {
      // No mandar recordatorios de vacunas
      // que ya fueron registradas.
      if (evaluation.status == VaccineStatus.applied ||
          evaluation.status == VaccineStatus.notApplied) {
        continue;
      }

      // Influenza se maneja con campañas/temporadas.
      // No debemos inventar una fecha exacta.
      if (evaluation.dose.isSeasonal) {
        continue;
      }

      final DateTime? expectedDate =
          evaluation.expectedDate;

      if (expectedDate == null) {
        continue;
      }

      // Si la fecha ya pasó, no programamos avisos.
      final DateTime today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final DateTime expected = DateTime(
        expectedDate.year,
        expectedDate.month,
        expectedDate.day,
      );

      if (expected.isBefore(today)) {
        continue;
      }

      for (final int daysBefore in offsets) {
        final DateTime reminderDate =
            expected.subtract(
          Duration(
            days: daysBefore,
          ),
        );

        final String vaccineName =
            T.txt(
          evaluation.dose.nameKey,
        );

        final String title =
            T.txt(
          'vaccineNotificationTitle',
        ).replaceAll(
          '{name}',
          child.name,
        );

        final String body =
            _notificationBody(
          child: child,
          vaccineName: vaccineName,
          daysBefore: daysBefore,
        );

        await NotificationService.instance
            .schedule(
          id: _notificationId(
            child.id,
            evaluation.dose.id,
            daysBefore,
          ),
          date: reminderDate,
          title: title,
          body: body,
          payload:
              'vaccine|${child.id}|${evaluation.dose.id}',
        );
      }
    }
  }

  Future<void> cancelForDose({
    required Child child,
    required String doseId,
  }) async {
    // Limpiar TODOS los posibles intervalos de la semana:
    // también elimina recordatorios que quedaron de otra frecuencia.
    for (int daysBefore = 0; daysBefore <= 7; daysBefore++) {
      await NotificationService.instance.cancel(
        _notificationId(child.id, doseId, daysBefore),
      );
    }
  }

  Future<void> cancelForChild(
    Child child,
  ) async {
    final List<VaccineDose> schedule =
        await VaccineScheduleLoader.instance
            .loadSchedule();

    for (final VaccineDose dose
        in schedule) {
      await cancelForDose(
        child: child,
        doseId: dose.id,
      );
    }
  }

  Future<void> cancelAllChildren() async {
    for (final Child child
        in ChildRepository.instance.children.value) {
      await cancelForChild(
        child,
      );
    }
  }

  String _notificationBody({
    required Child child,
    required String vaccineName,
    required int daysBefore,
  }) {
    if (daysBefore == 7) {
      return T.txt(
        'vaccineNotification7Days',
      )
          .replaceAll(
            '{vaccine}',
            vaccineName,
          )
          .replaceAll(
            '{name}',
            child.name,
          );
    }

    if (daysBefore == 1) {
      return T.txt(
        'vaccineNotificationTomorrow',
      )
          .replaceAll(
            '{vaccine}',
            vaccineName,
          )
          .replaceAll(
            '{name}',
            child.name,
          );
    }

    final template = daysBefore == 0
        ? T.txt('vaccineNotificationToday')
        : T.txt('vaccineNotificationInDays');

    return template
        .replaceAll('{vaccine}', vaccineName)
        .replaceAll('{name}', child.name)
        .replaceAll('{days}', daysBefore.toString());
  }

  int _notificationId(
    String childId,
    String doseId,
    int daysBefore,
  ) {
    final String input =
        '$childId|$doseId|$daysBefore';

    int hash = 17;

    for (final int code
        in input.codeUnits) {
      hash =
          ((hash * 31) + code) &
              0x7fffffff;
    }

    return hash;
  }
}