import '../../../core/utils/age_utils.dart';
import '../../../pages/app_texts.dart';

String childAgeText(DateTime birthDate) {
  final age = calculateAge(birthDate);

  if (age.years > 0) {
    final String yearText = age.years == 1
        ? T.txt('year')
        : T.txt('years');

    if (age.months == 0) {
      return '${age.years} $yearText';
    }

    final String monthText = age.months == 1
        ? T.txt('month')
        : T.txt('months');

    return '${age.years} $yearText '
        '${age.months} $monthText';
  }

  if (age.months > 0) {
    final String monthText = age.months == 1
        ? T.txt('month')
        : T.txt('months');

    return '${age.months} $monthText';
  }

  final String dayText = age.days == 1
      ? T.txt('day')
      : T.txt('days');

  return '${age.days} $dayText';
}

String simpleDateText(DateTime date) {
  final String day =
      date.day.toString().padLeft(2, '0');

  final String month =
      date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}