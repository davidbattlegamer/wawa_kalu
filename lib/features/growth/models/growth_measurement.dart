enum GrowthMeasurementType {
  length,
  height,
}

class GrowthMeasurement {
  static const Object _unset = Object();

  final String id;
  final String childId;

  final DateTime measuredAt;

  // Siempre se almacena en kilogramos.
  final double weightKg;

  // Siempre se almacena en centímetros.
  final double heightCm;

  // Siempre se almacena en centímetros.
  // Es opcional.
  final double? headCircumferenceCm;

  // Se mantiene internamente para los cálculos OMS.
  // Ya no será seleccionado manualmente por el usuario.
  final GrowthMeasurementType measurementType;

  final String? notes;

  final DateTime createdAt;

  const GrowthMeasurement({
    required this.id,
    required this.childId,
    required this.measuredAt,
    required this.weightKg,
    required this.heightCm,
    this.headCircumferenceCm,
    required this.measurementType,
    this.notes,
    required this.createdAt,
  });

  GrowthMeasurement copyWith({
    DateTime? measuredAt,
    double? weightKg,
    double? heightCm,
    Object? headCircumferenceCm = _unset,
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
      headCircumferenceCm:
          identical(
        headCircumferenceCm,
        _unset,
      )
              ? this.headCircumferenceCm
              : headCircumferenceCm
                  as double?,
      measurementType:
          measurementType ??
              this.measurementType,
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
      'head_circumference_cm':
          headCircumferenceCm,
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
      headCircumferenceCm:
          (map['head_circumference_cm']
                  as num?)
              ?.toDouble(),
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