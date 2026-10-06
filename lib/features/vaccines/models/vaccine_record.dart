class VaccineRecord {
  final String id;
  final String childId;
  final String scheduleId;
  final String vaccineCode;
  final DateTime appliedDate;

  final String? healthCenter;
  final String? notes;

  final DateTime createdAt;

  const VaccineRecord({
    required this.id,
    required this.childId,
    required this.scheduleId,
    required this.vaccineCode,
    required this.appliedDate,
    this.healthCenter,
    this.notes,
    required this.createdAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'child_id': childId,
      'schedule_id': scheduleId,
      'vaccine_code': vaccineCode,
      'applied_date':
          appliedDate.toIso8601String(),
      'health_center': healthCenter,
      'notes': notes,
      'created_at':
          createdAt.toIso8601String(),
    };
  }

  factory VaccineRecord.fromMap(
    Map<String, Object?> map,
  ) {
    return VaccineRecord(
      id: map['id'] as String,
      childId:
          map['child_id'] as String,
      scheduleId:
          map['schedule_id'] as String,
      vaccineCode:
          map['vaccine_code'] as String,
      appliedDate: DateTime.parse(
        map['applied_date'] as String,
      ),
      healthCenter:
          map['health_center'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ),
    );
  }
}