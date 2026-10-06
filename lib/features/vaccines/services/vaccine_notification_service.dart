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

  static const List<int> _reminderDays = [
    7,
    1,
    0,
  ];

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

    for (final evaluation
        in evaluations) {
      // No mandar recordatorios de vacunas
      // que ya fueron registradas.
      if (evaluation.status ==
          VaccineStatus.applied) {
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

      for (final int daysBefore
          in _reminderDays) {
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
    for (final int daysBefore
        in _reminderDays) {
      await NotificationService.instance
          .cancel(
        _notificationId(
          child.id,
          doseId,
          daysBefore,
        ),
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

    return T.txt(
      'vaccineNotificationToday',
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