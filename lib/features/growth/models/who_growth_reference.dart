class WhoGrowthReferencePoint {
  // Valor del eje X.
  //
  // Para indicadores por edad:
  // x = edad, normalmente en meses.
  //
  // Para peso/longitud o peso/talla:
  // x = longitud o talla en centímetros.
  final double x;

  // Parámetros LMS oficiales.
  final double l;
  final double m;
  final double s;

  // Líneas de desviación estándar.
  final double sd3Neg;
  final double sd2Neg;
  final double sd1Neg;

  final double median;

  final double sd1;
  final double sd2;
  final double sd3;

  const WhoGrowthReferencePoint({
    required this.x,
    required this.l,
    required this.m,
    required this.s,
    required this.sd3Neg,
    required this.sd2Neg,
    required this.sd1Neg,
    required this.median,
    required this.sd1,
    required this.sd2,
    required this.sd3,
  });

  // ==========================================================================
  // DESDE JSON
  // ==========================================================================

  factory WhoGrowthReferencePoint.fromJson(
    Map<String, dynamic> json,
  ) {
    return WhoGrowthReferencePoint(
      x: (json['x'] as num).toDouble(),

      l: (json['l'] as num).toDouble(),

      m: (json['m'] as num).toDouble(),

      s: (json['s'] as num).toDouble(),

      sd3Neg:
          (json['sd3neg'] as num)
              .toDouble(),

      sd2Neg:
          (json['sd2neg'] as num)
              .toDouble(),

      sd1Neg:
          (json['sd1neg'] as num)
              .toDouble(),

      median:
          (json['median'] as num)
              .toDouble(),

      sd1:
          (json['sd1'] as num)
              .toDouble(),

      sd2:
          (json['sd2'] as num)
              .toDouble(),

      sd3:
          (json['sd3'] as num)
              .toDouble(),
    );
  }

  // ==========================================================================
  // A JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'l': l,
      'm': m,
      's': s,
      'sd3neg': sd3Neg,
      'sd2neg': sd2Neg,
      'sd1neg': sd1Neg,
      'median': median,
      'sd1': sd1,
      'sd2': sd2,
      'sd3': sd3,
    };
  }
}

// ============================================================================
// TABLA COMPLETA DE REFERENCIA OMS
// ============================================================================

class WhoGrowthReference {
  // Ejemplos:
  //
  // weight_for_age
  // height_for_age
  // bmi_for_age
  // head_circumference_for_age
  // weight_for_length
  // weight_for_height
  final String indicator;

  // boys / girls
  final String sex;

  // kg
  // cm
  // kg/m2
  final String unit;

  // age_months
  // length_cm
  // height_cm
  final String xUnit;

  // Fuente de los datos.
  final String source;

  // Versión o referencia.
  final String? version;

  final List<WhoGrowthReferencePoint> points;

  const WhoGrowthReference({
    required this.indicator,
    required this.sex,
    required this.unit,
    required this.xUnit,
    required this.source,
    this.version,
    required this.points,
  });

  // ==========================================================================
  // DESDE JSON
  // ==========================================================================

  factory WhoGrowthReference.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<dynamic> rows =
        json['rows'] as List<dynamic>;

    return WhoGrowthReference(
      indicator:
          json['indicator'] as String,

      sex:
          json['sex'] as String,

      unit:
          json['unit'] as String,

      xUnit:
          json['x_unit'] as String,

      source:
          json['source'] as String,

      version:
          json['version'] as String?,

      points: rows
          .map(
            (
              dynamic item,
            ) =>
                WhoGrowthReferencePoint
                    .fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  // ==========================================================================
  // A JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'indicator': indicator,
      'sex': sex,
      'unit': unit,
      'x_unit': xUnit,
      'source': source,
      'version': version,
      'rows': points
          .map(
            (
              WhoGrowthReferencePoint point,
            ) =>
                point.toJson(),
          )
          .toList(),
    };
  }

  // ==========================================================================
  // VALIDACIONES ÚTILES
  // ==========================================================================

  bool get isEmpty =>
      points.isEmpty;

  bool get isNotEmpty =>
      points.isNotEmpty;

  double? get minimumX {
    if (points.isEmpty) {
      return null;
    }

    return points.first.x;
  }

  double? get maximumX {
    if (points.isEmpty) {
      return null;
    }

    return points.last.x;
  }
}