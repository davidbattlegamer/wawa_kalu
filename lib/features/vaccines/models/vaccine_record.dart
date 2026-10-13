enum VaccineRecordStatus {
  applied,
  notApplied,
}

class VaccineRecord {
  final String id;
  final String childId;
  final String scheduleId;
  final String vaccineCode;

  // Se conserva no-null por compatibilidad con la base existente.
  // Solo representa una fecha de aplicación cuando status == applied.
  final DateTime appliedDate;

  final VaccineRecordStatus status;
  final String? healthCenter;
  final String? notes;
  final DateTime createdAt;

  const VaccineRecord({
    required this.id,
    required this.childId,
    required this.scheduleId,
    required this.vaccineCode,
    required this.appliedDate,
    this.status = VaccineRecordStatus.applied,
    this.healthCenter,
    this.notes,
    required this.createdAt,
  });

  bool get isApplied => status == VaccineRecordStatus.applied;
  bool get isNotApplied => status == VaccineRecordStatus.notApplied;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'child_id': childId,
      'schedule_id': scheduleId,
      'vaccine_code': vaccineCode,
      'applied_date': appliedDate.toIso8601String(),
      'status': status.name,
      'health_center': healthCenter,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory VaccineRecord.fromMap(Map<String, Object?> map) {
    final String rawStatus =
        (map['status'] as String?) ?? VaccineRecordStatus.applied.name;

    return VaccineRecord(
      id: map['id'] as String,
      childId: map['child_id'] as String,
      scheduleId: map['schedule_id'] as String,
      vaccineCode: map['vaccine_code'] as String,
      appliedDate: DateTime.parse(map['applied_date'] as String),
      status: rawStatus == VaccineRecordStatus.notApplied.name
          ? VaccineRecordStatus.notApplied
          : VaccineRecordStatus.applied,
      healthCenter: map['health_center'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
