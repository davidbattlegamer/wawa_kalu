class VaccineDose {
  final String id;
  final String vaccineCode;
  final String nameKey;
  final String preventsKey;
  final String doseLabelKey;

  final String scheduleType;

  final int? targetMonths;
  final int targetDays;

  final int? minAgeMonths;
  final int? maxAgeMonths;

  final String? previousDoseId;
  final int? intervalDays;

  final String? notesKey;

  const VaccineDose({
    required this.id,
    required this.vaccineCode,
    required this.nameKey,
    required this.preventsKey,
    required this.doseLabelKey,
    required this.scheduleType,
    this.targetMonths,
    this.targetDays = 0,
    this.minAgeMonths,
    this.maxAgeMonths,
    this.previousDoseId,
    this.intervalDays,
    this.notesKey,
  });

  bool get isFixedAge =>
      scheduleType == 'fixed_age';

  bool get isSeasonal =>
      scheduleType == 'seasonal';

  bool get isInterval =>
      scheduleType == 'interval';

  factory VaccineDose.fromJson(
    Map<String, dynamic> json,
  ) {
    return VaccineDose(
      id: json['id'] as String,
      vaccineCode:
          json['vaccineCode'] as String,
      nameKey: json['nameKey'] as String,
      preventsKey:
          json['preventsKey'] as String,
      doseLabelKey:
          json['doseLabelKey'] as String,
      scheduleType:
          json['scheduleType'] as String,
      targetMonths:
          (json['targetMonths'] as num?)
              ?.toInt(),
      targetDays:
          (json['targetDays'] as num?)
                  ?.toInt() ??
              0,
      minAgeMonths:
          (json['minAgeMonths'] as num?)
              ?.toInt(),
      maxAgeMonths:
          (json['maxAgeMonths'] as num?)
              ?.toInt(),
      previousDoseId:
          json['previousDoseId']
              as String?,
      intervalDays:
          (json['intervalDays'] as num?)
              ?.toInt(),
      notesKey:
          json['notesKey'] as String?,
    );
  }
}