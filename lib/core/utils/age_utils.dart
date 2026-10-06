class ChildAge {
  final int years;
  final int months;
  final int days;
  final int totalMonths;

  const ChildAge({
    required this.years,
    required this.months,
    required this.days,
    required this.totalMonths,
  });
}

ChildAge calculateAge(
  DateTime birthDate, {
  DateTime? referenceDate,
}) {
  final DateTime today = referenceDate ?? DateTime.now();

  final DateTime birth = DateTime(
    birthDate.year,
    birthDate.month,
    birthDate.day,
  );

  final DateTime reference = DateTime(
    today.year,
    today.month,
    today.day,
  );

  if (birth.isAfter(reference)) {
    return const ChildAge(
      years: 0,
      months: 0,
      days: 0,
      totalMonths: 0,
    );
  }

  int years = reference.year - birth.year;
  int months = reference.month - birth.month;
  int days = reference.day - birth.day;

  if (days < 0) {
    months--;

    final DateTime previousMonth = DateTime(
      reference.year,
      reference.month,
      0,
    );

    days += previousMonth.day;
  }

  if (months < 0) {
    years--;
    months += 12;
  }

  int totalMonths =
      (reference.year - birth.year) * 12 +
          (reference.month - birth.month);

  if (reference.day < birth.day) {
    totalMonths--;
  }

  if (totalMonths < 0) {
    totalMonths = 0;
  }

  return ChildAge(
    years: years,
    months: months,
    days: days,
    totalMonths: totalMonths,
  );
}