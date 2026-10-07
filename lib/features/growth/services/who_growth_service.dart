import 'dart:math' as math;

import '../../children/models/child.dart';

import '../data/who_growth_table_loader.dart';

import '../models/growth_measurement.dart';
import '../models/who_growth_table.dart';

// ============================================================================
// PUNTO CALCULADO CON LAS TABLAS OMS
// ============================================================================

class OfficialWhoGrowthPoint {
  final GrowthMeasurement measurement;

  // Eje X:
  //
  // Indicadores por edad:
  // días de vida.
  //
  // Peso / longitud:
  // longitud en cm.
  //
  // Peso / talla:
  // talla en cm.
  final double x;

  // Valor real del niño.
  final double value;

  // Z-score calculado con LMS OMS.
  final double zScore;

  // Referencia OMS utilizada.
  final WhoGrowthRow reference;

  const OfficialWhoGrowthPoint({
    required this.measurement,
    required this.x,
    required this.value,
    required this.zScore,
    required this.reference,
  });
}

// ============================================================================
// DATOS COMPLETOS PARA LAS GRÁFICAS
// ============================================================================

class OfficialWhoGrowthChartData {
  final WhoGrowthSex sex;

  // --------------------------------------------------------------------------
  // TABLAS OMS
  // --------------------------------------------------------------------------

  final WhoGrowthTable weightForAgeTable;

  final WhoGrowthTable lengthHeightForAgeTable;

  final WhoGrowthTable bmiForAgeTable;

  final WhoGrowthTable
      headCircumferenceForAgeTable;

  final WhoGrowthTable weightForLengthTable;

  final WhoGrowthTable weightForHeightTable;

  // --------------------------------------------------------------------------
  // MEDICIONES DEL NIÑO
  // --------------------------------------------------------------------------

  final List<OfficialWhoGrowthPoint>
      weightForAge;

  final List<OfficialWhoGrowthPoint>
      lengthHeightForAge;

  final List<OfficialWhoGrowthPoint>
      bmiForAge;

  final List<OfficialWhoGrowthPoint>
      headCircumferenceForAge;

  final List<OfficialWhoGrowthPoint>
      weightForLength;

  final List<OfficialWhoGrowthPoint>
      weightForHeight;

  final int processedMeasurements;

  final int skippedMeasurements;

  const OfficialWhoGrowthChartData({
    required this.sex,
    required this.weightForAgeTable,
    required this.lengthHeightForAgeTable,
    required this.bmiForAgeTable,
    required this.headCircumferenceForAgeTable,
    required this.weightForLengthTable,
    required this.weightForHeightTable,
    required this.weightForAge,
    required this.lengthHeightForAge,
    required this.bmiForAge,
    required this.headCircumferenceForAge,
    required this.weightForLength,
    required this.weightForHeight,
    required this.processedMeasurements,
    required this.skippedMeasurements,
  });

  bool get hasAnyData =>
      weightForAge.isNotEmpty ||
      lengthHeightForAge.isNotEmpty ||
      bmiForAge.isNotEmpty ||
      headCircumferenceForAge.isNotEmpty ||
      weightForLength.isNotEmpty ||
      weightForHeight.isNotEmpty;

  bool get hasWeightForAge =>
      weightForAge.isNotEmpty;

  bool get hasLengthHeightForAge =>
      lengthHeightForAge.isNotEmpty;

  bool get hasBmiForAge =>
      bmiForAge.isNotEmpty;

  bool get hasHeadCircumferenceForAge =>
      headCircumferenceForAge.isNotEmpty;

  bool get hasWeightForLength =>
      weightForLength.isNotEmpty;

  bool get hasWeightForHeight =>
      weightForHeight.isNotEmpty;
}

// ============================================================================
// SERVICIO OMS
// ============================================================================

class WhoGrowthService {
  WhoGrowthService._();

  static final WhoGrowthService instance =
      WhoGrowthService._();

  // ==========================================================================
  // RANGO DE LAS TABLAS OMS
  //
  // 0 a 1856 días.
  // ==========================================================================

  static const int _minimumWhoAgeDays =
      0;

  static const int _maximumWhoAgeDays =
      1856;

  // ==========================================================================
  // CAMBIO LONGITUD -> TALLA
  //
  // Menor de 731 días:
  // longitud acostado.
  //
  // Desde 731 días:
  // talla de pie.
  // ==========================================================================

  static const int _standingHeightFromDay =
      731;

  // ==========================================================================
  // AJUSTE LONGITUD / TALLA
  //
  // Diferencia usada cuando la posición de medición
  // no coincide con la referencia esperada.
  // ==========================================================================

  static const double
      _lengthHeightAdjustmentCm =
      0.7;

  // ==========================================================================
  // CONSTRUIR DATOS
  // ==========================================================================

  Future<OfficialWhoGrowthChartData>
      buildOfficial({
    required Child child,
    required List<GrowthMeasurement>
        measurements,
  }) async {
    final WhoGrowthSex sex =
        _convertSex(
      child.sex,
    );

    // ------------------------------------------------------------------------
    // CARGAR LAS 6 TABLAS PARA EL SEXO DEL NIÑO
    // ------------------------------------------------------------------------

    final List<WhoGrowthTable> tables =
        await Future.wait(
      <Future<WhoGrowthTable>>[
        WhoGrowthTableLoader.instance.load(
          indicator:
              WhoGrowthIndicator
                  .weightForAge,
          sex:
              sex,
        ),
        WhoGrowthTableLoader.instance.load(
          indicator:
              WhoGrowthIndicator
                  .lengthHeightForAge,
          sex:
              sex,
        ),
        WhoGrowthTableLoader.instance.load(
          indicator:
              WhoGrowthIndicator
                  .bmiForAge,
          sex:
              sex,
        ),
        WhoGrowthTableLoader.instance.load(
          indicator:
              WhoGrowthIndicator
                  .headCircumferenceForAge,
          sex:
              sex,
        ),
        WhoGrowthTableLoader.instance.load(
          indicator:
              WhoGrowthIndicator
                  .weightForLength,
          sex:
              sex,
        ),
        WhoGrowthTableLoader.instance.load(
          indicator:
              WhoGrowthIndicator
                  .weightForHeight,
          sex:
              sex,
        ),
      ],
    );

    final WhoGrowthTable
        weightForAgeTable =
        tables[0];

    final WhoGrowthTable
        lengthHeightForAgeTable =
        tables[1];

    final WhoGrowthTable
        bmiForAgeTable =
        tables[2];

    final WhoGrowthTable
        headCircumferenceForAgeTable =
        tables[3];

    final WhoGrowthTable
        weightForLengthTable =
        tables[4];

    final WhoGrowthTable
        weightForHeightTable =
        tables[5];

    // ------------------------------------------------------------------------
    // LISTAS DE RESULTADOS
    // ------------------------------------------------------------------------

    final List<OfficialWhoGrowthPoint>
        weightForAge =
        <OfficialWhoGrowthPoint>[];

    final List<OfficialWhoGrowthPoint>
        lengthHeightForAge =
        <OfficialWhoGrowthPoint>[];

    final List<OfficialWhoGrowthPoint>
        bmiForAge =
        <OfficialWhoGrowthPoint>[];

    final List<OfficialWhoGrowthPoint>
        headCircumferenceForAge =
        <OfficialWhoGrowthPoint>[];

    final List<OfficialWhoGrowthPoint>
        weightForLength =
        <OfficialWhoGrowthPoint>[];

    final List<OfficialWhoGrowthPoint>
        weightForHeight =
        <OfficialWhoGrowthPoint>[];

    int processed =
        0;

    int skipped =
        0;

    // ------------------------------------------------------------------------
    // ORDENAR CONTROLES CRONOLÓGICAMENTE
    // ------------------------------------------------------------------------

    final List<GrowthMeasurement> ordered =
        List<GrowthMeasurement>.from(
      measurements,
    )
          ..sort(
            (
              GrowthMeasurement a,
              GrowthMeasurement b,
            ) {
              return a.measuredAt.compareTo(
                b.measuredAt,
              );
            },
          );

    // ========================================================================
    // RECORRER CONTROLES
    // ========================================================================

    for (final GrowthMeasurement measurement
        in ordered) {
      // ----------------------------------------------------------------------
      // EDAD EXACTA EN DÍAS
      // ----------------------------------------------------------------------

      final int ageDays =
          _ageInDays(
        birthDate:
            child.birthDate,
        measuredAt:
            measurement.measuredAt,
      );

      // ----------------------------------------------------------------------
      // CONTROL FUERA DEL RANGO OMS
      // ----------------------------------------------------------------------

      if (ageDays <
              _minimumWhoAgeDays ||
          ageDays >
              _maximumWhoAgeDays) {
        skipped++;

        continue;
      }

      // ----------------------------------------------------------------------
      // VALIDACIÓN PESO
      // ----------------------------------------------------------------------

      if (!measurement.weightKg.isFinite ||
          measurement.weightKg <= 0) {
        skipped++;

        continue;
      }

      // ----------------------------------------------------------------------
      // VALIDACIÓN LONGITUD / TALLA
      // ----------------------------------------------------------------------

      if (!measurement.heightCm.isFinite ||
          measurement.heightCm <= 0) {
        skipped++;

        continue;
      }

      // ----------------------------------------------------------------------
      // NORMALIZAR LONGITUD / TALLA
      // ----------------------------------------------------------------------

      final double
          standardizedLengthHeightCm =
          _standardizedLengthHeightCm(
        measurement:
            measurement,
        ageDays:
            ageDays,
      );

      if (!standardizedLengthHeightCm
              .isFinite ||
          standardizedLengthHeightCm <= 0) {
        skipped++;

        continue;
      }

      final double ageX =
          ageDays.toDouble();

      // ======================================================================
      // 1. PESO PARA LA EDAD
      // ======================================================================

      final WhoGrowthRow? weightAgeRow =
          weightForAgeTable.rowAtExactX(
        ageX,
      );

      if (weightAgeRow != null) {
        final OfficialWhoGrowthPoint?
            point =
            _createPoint(
          measurement:
              measurement,
          x:
              ageX,
          value:
              measurement.weightKg,
          reference:
              weightAgeRow,
        );

        if (point != null) {
          weightForAge.add(
            point,
          );
        }
      }

      // ======================================================================
      // 2. LONGITUD / TALLA PARA LA EDAD
      // ======================================================================

      final WhoGrowthRow?
          lengthHeightAgeRow =
          lengthHeightForAgeTable
              .rowAtExactX(
        ageX,
      );

      if (lengthHeightAgeRow != null) {
        final OfficialWhoGrowthPoint?
            point =
            _createPoint(
          measurement:
              measurement,
          x:
              ageX,
          value:
              standardizedLengthHeightCm,
          reference:
              lengthHeightAgeRow,
        );

        if (point != null) {
          lengthHeightForAge.add(
            point,
          );
        }
      }

      // ======================================================================
      // 3. IMC PARA LA EDAD
      // ======================================================================

      final double heightMeters =
          standardizedLengthHeightCm /
              100.0;

      final double bmi =
          measurement.weightKg /
              (heightMeters *
                  heightMeters);

      final WhoGrowthRow? bmiRow =
          bmiForAgeTable.rowAtExactX(
        ageX,
      );

      if (bmiRow != null &&
          bmi.isFinite &&
          bmi > 0) {
        final OfficialWhoGrowthPoint?
            point =
            _createPoint(
          measurement:
              measurement,
          x:
              ageX,
          value:
              bmi,
          reference:
              bmiRow,
        );

        if (point != null) {
          bmiForAge.add(
            point,
          );
        }
      }

      // ======================================================================
      // 4. PERÍMETRO CEFÁLICO PARA LA EDAD
      // ======================================================================

      final double? headCm =
          measurement
              .headCircumferenceCm;

      if (headCm != null &&
          headCm.isFinite &&
          headCm > 0) {
        final WhoGrowthRow? headRow =
            headCircumferenceForAgeTable
                .rowAtExactX(
          ageX,
        );

        if (headRow != null) {
          final OfficialWhoGrowthPoint?
              point =
              _createPoint(
            measurement:
                measurement,
            x:
                ageX,
            value:
                headCm,
            reference:
                headRow,
          );

          if (point != null) {
            headCircumferenceForAge.add(
              point,
            );
          }
        }
      }

      // ======================================================================
      // 5. PESO PARA LONGITUD
      //
      // Antes de 731 días.
      // ======================================================================

      if (ageDays <
          _standingHeightFromDay) {
        final WhoGrowthRow? row =
            weightForLengthTable
                .interpolatedRow(
          standardizedLengthHeightCm,
        );

        if (row != null) {
          final OfficialWhoGrowthPoint?
              point =
              _createPoint(
            measurement:
                measurement,
            x:
                standardizedLengthHeightCm,
            value:
                measurement.weightKg,
            reference:
                row,
          );

          if (point != null) {
            weightForLength.add(
              point,
            );
          }
        }
      }

      // ======================================================================
      // 6. PESO PARA TALLA
      //
      // Desde 731 días.
      // ======================================================================

      else {
        final WhoGrowthRow? row =
            weightForHeightTable
                .interpolatedRow(
          standardizedLengthHeightCm,
        );

        if (row != null) {
          final OfficialWhoGrowthPoint?
              point =
              _createPoint(
            measurement:
                measurement,
            x:
                standardizedLengthHeightCm,
            value:
                measurement.weightKg,
            reference:
                row,
          );

          if (point != null) {
            weightForHeight.add(
              point,
            );
          }
        }
      }

      processed++;
    }

    // ========================================================================
    // RESULTADO
    // ========================================================================

    return OfficialWhoGrowthChartData(
      sex:
          sex,
      weightForAgeTable:
          weightForAgeTable,
      lengthHeightForAgeTable:
          lengthHeightForAgeTable,
      bmiForAgeTable:
          bmiForAgeTable,
      headCircumferenceForAgeTable:
          headCircumferenceForAgeTable,
      weightForLengthTable:
          weightForLengthTable,
      weightForHeightTable:
          weightForHeightTable,
      weightForAge:
          weightForAge,
      lengthHeightForAge:
          lengthHeightForAge,
      bmiForAge:
          bmiForAge,
      headCircumferenceForAge:
          headCircumferenceForAge,
      weightForLength:
          weightForLength,
      weightForHeight:
          weightForHeight,
      processedMeasurements:
          processed,
      skippedMeasurements:
          skipped,
    );
  }

  // ==========================================================================
  // CREAR PUNTO
  // ==========================================================================

  OfficialWhoGrowthPoint? _createPoint({
    required GrowthMeasurement measurement,
    required double x,
    required double value,
    required WhoGrowthRow reference,
  }) {
    final double zScore =
        _calculateWhoZScore(
      value:
          value,
      row:
          reference,
    );

    if (!zScore.isFinite) {
      return null;
    }

    return OfficialWhoGrowthPoint(
      measurement:
          measurement,
      x:
          x,
      value:
          value,
      zScore:
          zScore,
      reference:
          reference,
    );
  }

  // ==========================================================================
  // CALCULAR Z-SCORE
  //
  // Fórmula LMS:
  //
  // ((X / M)^L - 1) / (L * S)
  //
  // Si L = 0:
  //
  // ln(X / M) / S
  //
  // Para valores fuera de ±3 DE usamos
  // extensión lineal con el espacio entre
  // ±2 y ±3 DE de las tablas.
  // ==========================================================================

  double _calculateWhoZScore({
    required double value,
    required WhoGrowthRow row,
  }) {
    if (!value.isFinite ||
        value <= 0 ||
        !row.l.isFinite ||
        !row.m.isFinite ||
        !row.s.isFinite ||
        row.m <= 0 ||
        row.s <= 0) {
      return double.nan;
    }

    final double rawZ;

    // ------------------------------------------------------------------------
    // L = 0
    // ------------------------------------------------------------------------

    if (row.l.abs() <
        0.000000000001) {
      rawZ =
          math.log(
            value /
                row.m,
          ) /
          row.s;
    }

    // ------------------------------------------------------------------------
    // L != 0
    // ------------------------------------------------------------------------

    else {
      final double ratio =
          value /
              row.m;

      if (ratio <= 0) {
        return double.nan;
      }

      final double powered =
          math
              .pow(
                ratio,
                row.l,
              )
              .toDouble();

      rawZ =
          (powered -
                  1.0) /
              (row.l *
                  row.s);
    }

    if (!rawZ.isFinite) {
      return double.nan;
    }

    // ------------------------------------------------------------------------
    // MÁS DE +3 DE
    // ------------------------------------------------------------------------

    if (rawZ >
        3.0) {
      final double distance =
          row.sd3 -
              row.sd2;

      if (distance > 0) {
        return 3.0 +
            ((value -
                    row.sd3) /
                distance);
      }
    }

    // ------------------------------------------------------------------------
    // MENOS DE -3 DE
    // ------------------------------------------------------------------------

    if (rawZ <
        -3.0) {
      final double distance =
          row.sd2Negative -
              row.sd3Negative;

      if (distance > 0) {
        return -3.0 +
            ((value -
                    row.sd3Negative) /
                distance);
      }
    }

    return rawZ;
  }

  // ==========================================================================
  // NORMALIZAR LONGITUD / TALLA
  //
  // Menor de 731 días:
  // se espera longitud recostado.
  //
  // Si se midió de pie:
  // +0.7 cm.
  //
  // Desde 731 días:
  // se espera talla de pie.
  //
  // Si se midió acostado:
  // -0.7 cm.
  // ==========================================================================

  double _standardizedLengthHeightCm({
    required GrowthMeasurement measurement,
    required int ageDays,
  }) {
    final double value =
        measurement.heightCm;

    // ------------------------------------------------------------------------
    // MENOR DE 731 DÍAS
    // ------------------------------------------------------------------------

    if (ageDays <
        _standingHeightFromDay) {
      if (measurement.measurementType ==
          GrowthMeasurementType.height) {
        return value +
            _lengthHeightAdjustmentCm;
      }

      return value;
    }

    // ------------------------------------------------------------------------
    // DESDE 731 DÍAS
    // ------------------------------------------------------------------------

    if (measurement.measurementType ==
        GrowthMeasurementType.length) {
      return value -
          _lengthHeightAdjustmentCm;
    }

    return value;
  }

  // ==========================================================================
  // EDAD EXACTA EN DÍAS
  // ==========================================================================

  int _ageInDays({
    required DateTime birthDate,
    required DateTime measuredAt,
  }) {
    final DateTime birth =
        DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
    );

    final DateTime observed =
        DateTime(
      measuredAt.year,
      measuredAt.month,
      measuredAt.day,
    );

    return observed
        .difference(
          birth,
        )
        .inDays;
  }

  // ==========================================================================
  // SEXO
  // ==========================================================================

  WhoGrowthSex _convertSex(
    ChildSex sex,
  ) {
    if (sex ==
        ChildSex.girl) {
      return WhoGrowthSex.girls;
    }

    return WhoGrowthSex.boys;
  }
}