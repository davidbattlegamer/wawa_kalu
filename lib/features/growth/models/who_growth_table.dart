enum WhoGrowthIndicator {
  weightForAge,
  lengthHeightForAge,
  bmiForAge,
  headCircumferenceForAge,
  weightForLength,
  weightForHeight,
}

enum WhoGrowthSex {
  boys,
  girls,
}

class WhoGrowthRow {
  final double x;

  final double l;
  final double m;
  final double s;

  final double sd3Negative;
  final double sd2Negative;
  final double sd1Negative;

  final double median;

  final double sd1;
  final double sd2;
  final double sd3;

  final double? ageMonthsApprox;

  const WhoGrowthRow({
    required this.x,
    required this.l,
    required this.m,
    required this.s,
    required this.sd3Negative,
    required this.sd2Negative,
    required this.sd1Negative,
    required this.median,
    required this.sd1,
    required this.sd2,
    required this.sd3,
    this.ageMonthsApprox,
  });

  factory WhoGrowthRow.fromJson(
    Map<String, dynamic> json,
  ) {
    return WhoGrowthRow(
      x: _toDouble(
        json['x'],
      ),
      l: _toDouble(
        json['l'],
      ),
      m: _toDouble(
        json['m'],
      ),
      s: _toDouble(
        json['s'],
      ),
      sd3Negative: _toDouble(
        json['sd3neg'],
      ),
      sd2Negative: _toDouble(
        json['sd2neg'],
      ),
      sd1Negative: _toDouble(
        json['sd1neg'],
      ),
      median: _toDouble(
        json['median'],
      ),
      sd1: _toDouble(
        json['sd1'],
      ),
      sd2: _toDouble(
        json['sd2'],
      ),
      sd3: _toDouble(
        json['sd3'],
      ),
      ageMonthsApprox:
          json['age_months_approx'] == null
              ? null
              : _toDouble(
                  json['age_months_approx'],
                ),
    );
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.parse(
      value.toString(),
    );
  }
}

class WhoGrowthTable {
  final String standard;
  final String standardScope;

  final String indicator;
  final String sex;

  final String unit;
  final String xUnit;

  final double xStart;
  final double xEnd;
  final double xStep;

  final int rowCount;

  final String measurementBasis;

  final String primarySource;
  final String sourcePage;

  final String dataProvenanceNote;

  final String generatedFor;
  final String generatedOn;

  final String clinicalNotice;

  final List<WhoGrowthRow> rows;

  const WhoGrowthTable({
    required this.standard,
    required this.standardScope,
    required this.indicator,
    required this.sex,
    required this.unit,
    required this.xUnit,
    required this.xStart,
    required this.xEnd,
    required this.xStep,
    required this.rowCount,
    required this.measurementBasis,
    required this.primarySource,
    required this.sourcePage,
    required this.dataProvenanceNote,
    required this.generatedFor,
    required this.generatedOn,
    required this.clinicalNotice,
    required this.rows,
  });

  factory WhoGrowthTable.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<dynamic> rowsJson =
        json['rows'] as List<dynamic>? ??
        <dynamic>[];

    final List<WhoGrowthRow> rows =
        rowsJson
            .map(
              (dynamic item) =>
                  WhoGrowthRow.fromJson(
                Map<String, dynamic>.from(
                  item as Map,
                ),
              ),
            )
            .toList();

    final WhoGrowthTable table =
        WhoGrowthTable(
      standard:
          json['standard']?.toString() ??
          '',
      standardScope:
          json['standard_scope']
                  ?.toString() ??
              '',
      indicator:
          json['indicator']
                  ?.toString() ??
              '',
      sex:
          json['sex']?.toString() ??
          '',
      unit:
          json['unit']?.toString() ??
          '',
      xUnit:
          json['x_unit']?.toString() ??
          '',
      xStart: _toDouble(
        json['x_start'],
      ),
      xEnd: _toDouble(
        json['x_end'],
      ),
      xStep: _toDouble(
        json['x_step'],
      ),
      rowCount:
          (json['row_count'] as num?)
                  ?.toInt() ??
              rows.length,
      measurementBasis:
          json['measurement_basis']
                  ?.toString() ??
              '',
      primarySource:
          json['primary_source']
                  ?.toString() ??
              '',
      sourcePage:
          json['source_page']
                  ?.toString() ??
              '',
      dataProvenanceNote:
          json['data_provenance_note']
                  ?.toString() ??
              '',
      generatedFor:
          json['generated_for']
                  ?.toString() ??
              '',
      generatedOn:
          json['generated_on']
                  ?.toString() ??
              '',
      clinicalNotice:
          json['clinical_notice']
                  ?.toString() ??
              '',
      rows: rows,
    );

    table.validate();

    return table;
  }

  void validate() {
    if (rows.isEmpty) {
      throw StateError(
        'La tabla OMS no contiene datos.',
      );
    }

    if (rows.length != rowCount) {
      throw StateError(
        'Cantidad de filas OMS incorrecta. '
        'Esperadas: $rowCount. '
        'Encontradas: ${rows.length}.',
      );
    }

    if (xStep <= 0) {
      throw StateError(
        'El paso X de la tabla OMS debe ser mayor que cero.',
      );
    }

    if (xEnd < xStart) {
      throw StateError(
        'El rango X de la tabla OMS es inválido.',
      );
    }

    for (final WhoGrowthRow row in rows) {
      if (!row.x.isFinite ||
          !row.l.isFinite ||
          !row.m.isFinite ||
          !row.s.isFinite) {
        throw StateError(
          'La tabla OMS contiene valores LMS inválidos.',
        );
      }

      if (row.m <= 0) {
        throw StateError(
          'La mediana M de la tabla OMS debe ser positiva.',
        );
      }

      if (row.s <= 0) {
        throw StateError(
          'El parámetro S de la tabla OMS debe ser positivo.',
        );
      }

      if (!(row.sd3Negative <
              row.sd2Negative &&
          row.sd2Negative <
              row.sd1Negative &&
          row.sd1Negative <
              row.median &&
          row.median <
              row.sd1 &&
          row.sd1 <
              row.sd2 &&
          row.sd2 <
              row.sd3)) {
        throw StateError(
          'La tabla OMS contiene curvas DE fuera de orden.',
        );
      }
    }
  }

  WhoGrowthRow? rowAtExactX(
    double x,
  ) {
    if (x < xStart ||
        x > xEnd) {
      return null;
    }

    final double rawIndex =
        (x - xStart) / xStep;

    final int index =
        rawIndex.round();

    if (index < 0 ||
        index >= rows.length) {
      return null;
    }

    final WhoGrowthRow row =
        rows[index];

    final double difference =
        (row.x - x).abs();

    const double tolerance =
        0.000001;

    if (difference >
        tolerance) {
      return null;
    }

    return row;
  }

  WhoGrowthRow? nearestRow(
    double x,
  ) {
    if (rows.isEmpty) {
      return null;
    }

    if (x <= xStart) {
      return rows.first;
    }

    if (x >= xEnd) {
      return rows.last;
    }

    final double rawIndex =
        (x - xStart) / xStep;

    int index =
        rawIndex.round();

    if (index < 0) {
      index = 0;
    }

    if (index >= rows.length) {
      index =
          rows.length - 1;
    }

    return rows[index];
  }

  WhoGrowthRow? interpolatedRow(
    double x,
  ) {
    if (rows.isEmpty) {
      return null;
    }

    if (x < xStart ||
        x > xEnd) {
      return null;
    }

    final double rawIndex =
        (x - xStart) / xStep;

    final int lowerIndex =
        rawIndex.floor();

    final int upperIndex =
        rawIndex.ceil();

    if (lowerIndex < 0 ||
        upperIndex >= rows.length) {
      return nearestRow(
        x,
      );
    }

    if (lowerIndex ==
        upperIndex) {
      return rows[
          lowerIndex];
    }

    final WhoGrowthRow lower =
        rows[
            lowerIndex];

    final WhoGrowthRow upper =
        rows[
            upperIndex];

    final double fraction =
        rawIndex -
        lowerIndex;

    double lerp(
      double a,
      double b,
    ) {
      return a +
          ((b - a) *
              fraction);
    }

    return WhoGrowthRow(
      x: x,
      l: lerp(
        lower.l,
        upper.l,
      ),
      m: lerp(
        lower.m,
        upper.m,
      ),
      s: lerp(
        lower.s,
        upper.s,
      ),
      sd3Negative: lerp(
        lower.sd3Negative,
        upper.sd3Negative,
      ),
      sd2Negative: lerp(
        lower.sd2Negative,
        upper.sd2Negative,
      ),
      sd1Negative: lerp(
        lower.sd1Negative,
        upper.sd1Negative,
      ),
      median: lerp(
        lower.median,
        upper.median,
      ),
      sd1: lerp(
        lower.sd1,
        upper.sd1,
      ),
      sd2: lerp(
        lower.sd2,
        upper.sd2,
      ),
      sd3: lerp(
        lower.sd3,
        upper.sd3,
      ),
      ageMonthsApprox:
          lower.ageMonthsApprox !=
                      null &&
                  upper.ageMonthsApprox !=
                      null
              ? lerp(
                  lower
                      .ageMonthsApprox!,
                  upper
                      .ageMonthsApprox!,
                )
              : null,
    );
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.parse(
      value.toString(),
    );
  }
}