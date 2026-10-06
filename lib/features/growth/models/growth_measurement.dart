enum GrowthMeasurementType {
  length,
  height,
}

class GrowthMeasurement {
  static const Object _unset = Object();

  final String id;
  final String childId;

  final DateTime measuredAt;

  final double weightKg;
  final double heightCm;

  final GrowthMeasurementType measurementType;

  final String? notes;

  final DateTime createdAt;

  const GrowthMeasurement({
    required this.id,
    required this.childId,
    required this.measuredAt,
    required this.weightKg,
    required this.heightCm,
    required this.measurementType,
    this.notes,
    required this.createdAt,
  });

  GrowthMeasurement copyWith({
    DateTime? measuredAt,
    double? weightKg,
    double? heightCm,
    GrowthMeasurementType? measurementType,
    Object? notes = _unset,
  }) {
    return GrowthMeasurement(
      id: id,
      childId: childId,
      measuredAt:
          measuredAt ?? this.measuredAt,
      weightKg:
          weightKg ?? this.weightKg,
      heightCm:
          heightCm ?? this.heightCm,
      measurementType:
          measurementType ??
              this.measurementType,

      // Ahora notes: null realmente elimina la nota.
      notes: identical(
        notes,
        _unset,
      )
          ? this.notes
          : notes as String?,

      createdAt: createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'child_id': childId,
      'measured_at':
          measuredAt.toIso8601String(),
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'measurement_type':
          measurementType.name,
      'notes': notes,
      'created_at':
          createdAt.toIso8601String(),
    };
  }

  factory GrowthMeasurement.fromMap(
    Map<String, Object?> map,
  ) {
    final String type =
        map['measurement_type']
            as String;

    return GrowthMeasurement(
      id:
          map['id'] as String,
      childId:
          map['child_id'] as String,
      measuredAt:
          DateTime.parse(
        map['measured_at']
            as String,
      ),
      weightKg:
          (map['weight_kg'] as num)
              .toDouble(),
      heightCm:
          (map['height_cm'] as num)
              .toDouble(),
      measurementType:
          type ==
                  GrowthMeasurementType
                      .length.name
              ? GrowthMeasurementType
                  .length
              : GrowthMeasurementType
                  .height,
      notes:
          map['notes'] as String?,
      createdAt:
          DateTime.parse(
        map['created_at']
            as String,
      ),
    );
  }
}