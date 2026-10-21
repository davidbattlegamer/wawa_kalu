import 'package:flutter_test/flutter_test.dart';
import 'package:wawa_kalu/features/vaccines/services/vaccine_notification_service.dart';

void main() {
  group('Frecuencia de avisos de vacunas', () {
    test('La opción predeterminada mantiene 7, 1 y 0 días', () {
      expect(
        VaccineNotificationService.reminderOffsetsFor(0),
        <int>[7, 1, 0],
      );
    });

    test('Avisos diarios durante los 7 días anteriores', () {
      expect(
        VaccineNotificationService.reminderOffsetsFor(1),
        <int>[7, 6, 5, 4, 3, 2, 1, 0],
      );
    });

    test('Repetición cada 2 días y aviso en la fecha prevista', () {
      expect(
        VaccineNotificationService.reminderOffsetsFor(2),
        <int>[7, 5, 3, 1, 0],
      );
    });

    test('Repetición cada 3 días y aviso en la fecha prevista', () {
      expect(
        VaccineNotificationService.reminderOffsetsFor(3),
        <int>[7, 4, 1, 0],
      );
    });

    test('Repetición semanal y aviso en la fecha prevista', () {
      expect(
        VaccineNotificationService.reminderOffsetsFor(7),
        <int>[7, 0],
      );
    });

    test('Nunca genera avisos posteriores a la dosis ni números repetidos', () {
      for (final interval in VaccineNotificationService.allowedIntervals) {
        final days = VaccineNotificationService.reminderOffsetsFor(interval);
        expect(days, contains(0));
        expect(days, everyElement(inInclusiveRange(0, 7)));
        expect(days.toSet().length, days.length);
      }
    });
  });
}
