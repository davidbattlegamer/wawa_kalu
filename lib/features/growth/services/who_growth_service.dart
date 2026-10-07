import 'dart:math' as math;

import 'package:growth_standards/growth_standards.dart';

import '../../children/models/child.dart';

import '../data/who_growth_table_loader.dart';

import '../models/growth_measurement.dart';
import '../models/who_growth_table.dart';

// ============================================================================
// SISTEMA NUEVO
// DATOS CALCULADOS DIRECTAMENTE DESDE LAS TABLAS OMS DE ASSETS
// ============================================================================

class OfficialWhoGrowthPoint {
  final GrowthMeasurement measurement;

  // Eje X de la gráfica.
  //
  // Por edad:
  // días de vida.
  //
  // Peso/longitud:
  // longitud en cm.
  //
  // Peso/talla:
  // talla en cm.
  final double x;

  // Valor real registrado/calculado del niño.
  final double value;

  // Z-score calculado con los parámetros LMS OMS.
  final double zScore;

  // Fila OMS usada como referencia.
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
// CONJUNTO COMPLETO DE DATOS OMS
// ============================================================================

class OfficialWhoGrowthChartData {
  final WhoGrowthSex sex;

  // --------------------------------------------------------------------------
  // TABLAS OMS
  // --------------------------------------------------------------------------

  final WhoGrowthTable weightForAgeTable;

  final WhoGrowthTable lengthHeightForAgeTable;

  final WhoGrowthTable bmiForAgeTable;

  final WhoGrowthTable headCircumferenceForAgeTable;

  final WhoGrowthTable weightForLengthTable;

  final WhoGrowthTable weightForHeightTable;

  // --------------------------------------------------------------------------
  // PUNTOS DEL NIÑO
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
// SISTEMA ANTIGUO
//
// SE MANTIENE TEMPORALMENTE.
//
// growth_charts_page.dart todavía usa growth_standards.
// En la Parte 2 cambiaremos la página y después podremos eliminar
// todo este bloque antiguo.
// ============================================================================

class WhoGrowthChartData {
  final Sex sex;

  final List<Result>
      weightForAge;

  final List<Result>
      lengthHeightForAge;

  final List<Result>
      weightForLength;

  final List<Result>
      weightForHeight;

  final List<Result>
      bmiForAge;

  final List<Result>
      headCircumferenceForAge;

  final int processedMeasurements;

  final int skippedMeasurements;

  const WhoGrowthChartData({
    required this.sex,
    required this.weightForAge,
    required this.lengthHeightForAge,
    required this.weightForLength,
    required this.weightForHeight,
    required this.bmiForAge,
    required this.headCircumferenceForAge,
    required this.processedMeasurements,
    required this.skippedMeasurements,
  });

  bool get hasAnyData =>
      weightForAge.isNotEmpty ||
      lengthHeightForAge.isNotEmpty ||
      weightForLength.isNotEmpty ||
      weightForHeight.isNotEmpty ||
      bmiForAge.isNotEmpty ||
      headCircumferenceForAge.isNotEmpty;

  bool get hasHeadCircumferenceData =>
      headCircumferenceForAge.isNotEmpty;
}

// ============================================================================
// SERVICIO
// ============================================================================

class WhoGrowthService {
  WhoGrowthService._();

  static final WhoGrowthService instance =
      WhoGrowthService._();

  // ==========================================================================
  // RANGO OMS
  //
  // Los JSON actuales contienen:
  // día 0 hasta día 1856.
  // ==========================================================================

  static const int _minimumWhoAgeDays =
      0;

  static const int _maximumWhoAgeDays =
      1856;

  // ==========================================================================
  // CAMBIO LONGITUD -> TALLA
  //
  // OMS:
  // < 731 días  = longitud recostado
  // >= 731 días = talla de pie
  // ==========================================================================

  static const int _standingHeightFromDay =
      731;

  // Diferencia OMS aproximada entre
  // longitud recostado y talla de pie.
  static const double
      _lengthHeightAdjustmentCm =
      0.7;

  // ==========================================================================
  // NUEVO SISTEMA OFICIAL
  //
  // ESTE ES EL MÉTODO QUE USAREMOS EN LA PARTE 2.
  //
  // Lee directamente:
  //
  // assets/data/growth/who/
  //
  // y NO utiliza growth_standards.
  // ==========================================================================

  Future<OfficialWhoGrowthChartData>
      buildOfficial({
    required Child child,
    required List<GrowthMeasurement>
        measurements,
  }) async {
    final WhoGrowthSex sex =
        _convertOfficialSex(
      child.sex,
    );

    // ------------------------------------------------------------------------
    // CARGAR LAS 6 TABLAS DEL SEXO DEL NIÑO
    // ------------------------------------------------------------------------

    final Future<WhoGrowthTable>
        weightForAgeFuture =
        WhoGrowthTableLoader.instance.load(
      indicator:
          WhoGrowthIndicator.weightForAge,
      sex:
          sex,
    );

    final Future<WhoGrowthTable>
        lengthHeightForAgeFuture =
        WhoGrowthTableLoader.instance.load(
      indicator:
          WhoGrowthIndicator
              .lengthHeightForAge,
      sex:
          sex,
    );

    final Future<WhoGrowthTable>
        bmiForAgeFuture =
        WhoGrowthTableLoader.instance.load(
      indicator:
          WhoGrowthIndicator.bmiForAge,
      sex:
          sex,
    );

    final Future<WhoGrowthTable>
        headForAgeFuture =
        WhoGrowthTableLoader.instance.load(
      indicator:
          WhoGrowthIndicator
              .headCircumferenceForAge,
      sex:
          sex,
    );

    final Future<WhoGrowthTable>
        weightForLengthFuture =
        WhoGrowthTableLoader.instance.load(
      indicator:
          WhoGrowthIndicator
              .weightForLength,
      sex:
          sex,
    );

    final Future<WhoGrowthTable>
        weightForHeightFuture =
        WhoGrowthTableLoader.instance.load(
      indicator:
          WhoGrowthIndicator
              .weightForHeight,
      sex:
          sex,
    );

    final List<WhoGrowthTable> tables =
        await Future.wait(
      <Future<WhoGrowthTable>>[
        weightForAgeFuture,
        lengthHeightForAgeFuture,
        bmiForAgeFuture,
        headForAgeFuture,
        weightForLengthFuture,
        weightForHeightFuture,
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
    // LISTAS DE PUNTOS DEL NIÑO
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
    // ORDEN CRONOLÓGICO
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
      // SOLO RANGO OMS DISPONIBLE
      // ----------------------------------------------------------------------

      if (ageDays <
              _minimumWhoAgeDays ||
          ageDays >
              _maximumWhoAgeDays) {
        skipped++;
        continue;
      }

      // ----------------------------------------------------------------------
      // VALIDACIÓN BÁSICA
      // ----------------------------------------------------------------------

      if (!measurement
              .weightKg.isFinite ||
          measurement.weightKg <=
              0 ||
          !measurement
              .heightCm.isFinite ||
          measurement.heightCm <=
              0) {
        skipped++;
        continue;
      }

      // ----------------------------------------------------------------------
      // CORREGIR LONGITUD / TALLA SI FUERA NECESARIO
      //
      // Esto es especialmente útil para controles antiguos.
      //
      // Actualmente el formulario asigna el tipo automáticamente.
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
          standardizedLengthHeightCm <=
              0) {
        skipped++;
        continue;
      }

      final double ageX =
          ageDays.toDouble();

      // ======================================================================
      // 1. PESO PARA LA EDAD
      // ======================================================================

      final WhoGrowthRow?
          weightAgeRow =
          weightForAgeTable.rowAtExactX(
        ageX,
      );

      if (weightAgeRow != null) {
        final OfficialWhoGrowthPoint?
            point =
            _createOfficialPoint(
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

      if (lengthHeightAgeRow !=
          null) {
        final OfficialWhoGrowthPoint?
            point =
            _createOfficialPoint(
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
      //
      // La talla/longitud usada aquí ya está normalizada según la posición
      // esperada por OMS para la edad.
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
            _createOfficialPoint(
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
      //
      // OPCIONAL.
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
              _createOfficialPoint(
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
      // Menores de 731 días.
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
              _createOfficialPoint(
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
              _createOfficialPoint(
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
  // CREAR PUNTO OFICIAL
  // ==========================================================================

  OfficialWhoGrowthPoint?
      _createOfficialPoint({
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
  // Z-SCORE OMS
  //
  // Dentro de -3 a +3:
  // fórmula LMS.
  //
  // Fuera de -3 / +3:
  // extensión lineal usando la distancia entre 2 DE y 3 DE.
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
          (powered - 1.0) /
              (row.l *
                  row.s);
    }

    if (!rawZ.isFinite) {
      return double.nan;
    }

    // ------------------------------------------------------------------------
    // MÁS DE +3 DE
    // ------------------------------------------------------------------------

    if (rawZ > 3) {
      final double sd23 =
          row.sd3 -
              row.sd2;

      if (sd23 > 0) {
        return 3.0 +
            ((value -
                    row.sd3) /
                sd23);
      }
    }

    // ------------------------------------------------------------------------
    // MENOS DE -3 DE
    // ------------------------------------------------------------------------

    if (rawZ < -3) {
      final double sd23 =
          row.sd2Negative -
              row.sd3Negative;

      if (sd23 > 0) {
        return -3.0 +
            ((value -
                    row.sd3Negative) /
                sd23);
      }
    }

    return rawZ;
  }

  // ==========================================================================
  // NORMALIZAR LONGITUD / TALLA
  //
  // OMS:
  //
  // < 731 días:
  // se espera longitud recostado.
  //
  // Si se midió de pie:
  // +0.7 cm.
  //
  // >= 731 días:
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

    if (ageDays <
        _standingHeightFromDay) {
      if (measurement.measurementType ==
          GrowthMeasurementType.height) {
        return value +
            _lengthHeightAdjustmentCm;
      }

      return value;
    }

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
  // SEXO PARA NUEVAS TABLAS
  // ==========================================================================

  WhoGrowthSex _convertOfficialSex(
    ChildSex sex,
  ) {
    if (sex ==
        ChildSex.girl) {
      return WhoGrowthSex.girls;
    }

    return WhoGrowthSex.boys;
  }

  // ==========================================================================
  // ==========================================================================
  //
  // SISTEMA ANTIGUO
  //
  // LO DEJAMOS TEMPORALMENTE PARA QUE
  // growth_charts_page.dart ACTUAL SIGA COMPILANDO.
  //
  // EN LA PARTE 2 LO ELIMINAREMOS.
  //
  // ==========================================================================
  // ==========================================================================

  WhoGrowthChartData build({
    required Child child,
    required List<GrowthMeasurement>
        measurements,
  }) {
    final Sex sex =
        _convertLegacySex(
      child.sex,
    );

    final List<Result> weightForAge =
        <Result>[];

    final List<Result>
        lengthHeightForAge =
        <Result>[];

    final List<Result> weightForLength =
        <Result>[];

    final List<Result> weightForHeight =
        <Result>[];

    final List<Result> bmiForAge =
        <Result>[];

    final List<Result>
        headCircumferenceForAge =
        <Result>[];

    int processed =
        0;

    int skipped =
        0;

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

    final Date birthDate =
        Date.fromDateTime(
      child.birthDate,
    );

    for (final GrowthMeasurement measurement
        in ordered) {
      try {
        final Date observedDate =
            Date.fromDateTime(
          measurement.measuredAt,
        );

        final Age age =
            Age(
          birthDate,
          observedDate:
              observedDate,
        );

        final int ageDays =
            age.ageInTotalDaysByNow;

        if (ageDays <
                _minimumWhoAgeDays ||
            ageDays >
                _maximumWhoAgeDays) {
          skipped++;
          continue;
        }

        final Mass weight =
            Mass$Kilogram(
          measurement.weightKg,
        );

        final Length lengthHeight =
            Length$Centimeter(
          measurement.heightCm,
        );

        final LengthHeightMeasurementPosition
            measurementPosition =
            _convertLegacyMeasurementPosition(
          measurement.measurementType,
        );

        // --------------------------------------------------------------------
        // PESO / EDAD
        // --------------------------------------------------------------------

        final WHOGrowthStandardsWeightForAge
            weightAgeResult =
            WHOGrowthStandardsWeightForAge(
          sex:
              sex,
          age:
              age,
          weight:
              weight,
        );

        weightForAge.add(
          weightAgeResult,
        );

        // --------------------------------------------------------------------
        // LONGITUD-TALLA / EDAD
        // --------------------------------------------------------------------

        final WHOGrowthStandardsLengthForAge
            lengthAgeResult =
            WHOGrowthStandardsLengthForAge(
          sex:
              sex,
          age:
              age,
          lengthHeight:
              lengthHeight,
          measure:
              measurementPosition,
        );

        lengthHeightForAge.add(
          lengthAgeResult,
        );

        // --------------------------------------------------------------------
        // PESO / LONGITUD O PESO / TALLA
        // --------------------------------------------------------------------

        if (ageDays <
            _standingHeightFromDay) {
          final WHOGrowthStandardsWeightForLength
              result =
              WHOGrowthStandardsWeightForLength(
            sex:
                sex,
            age:
                age,
            length:
                lengthHeight,
            weight:
                weight,
            measure:
                measurementPosition,
          );

          weightForLength.add(
            result,
          );
        } else {
          final WHOGrowthStandardsWeightForHeight
              result =
              WHOGrowthStandardsWeightForHeight(
            sex:
                sex,
            age:
                age,
            height:
                lengthHeight,
            weight:
                weight,
            measure:
                measurementPosition,
          );

          weightForHeight.add(
            result,
          );
        }

        // --------------------------------------------------------------------
        // IMC / EDAD
        // --------------------------------------------------------------------

        final WHOGrowthStandardsBodyMassIndexMeasurement
            bmiMeasurement =
            WHOGrowthStandardsBodyMassIndexMeasurement
                .fromMeasurement(
          lengthHeight:
              lengthHeight,
          weight:
              weight,
          measure:
              measurementPosition,
          age:
              age,
        );

        final WHOGrowthStandardsBodyMassIndexForAge
            bmiResult =
            WHOGrowthStandardsBodyMassIndexForAge(
          sex:
              sex,
          bodyMassIndexMeasurement:
              bmiMeasurement,
        );

        bmiForAge.add(
          bmiResult,
        );

        // --------------------------------------------------------------------
        // CABEZA / EDAD
        // --------------------------------------------------------------------

        final double? headCm =
            measurement
                .headCircumferenceCm;

        if (headCm != null &&
            headCm > 0) {
          try {
            final Length headCircumference =
                Length$Centimeter(
              headCm,
            );

            final WHOGrowthStandardsHeadCircumferenceForAge
                headResult =
                WHOGrowthStandardsHeadCircumferenceForAge(
              sex:
                  sex,
              age:
                  age,
              measurementResult:
                  headCircumference,
            );

            headCircumferenceForAge.add(
              headResult,
            );
          } catch (_) {
            // No se elimina el resto del control
            // si únicamente falla cabeza.
          }
        }

        processed++;
      } catch (_) {
        skipped++;
      }
    }

    return WhoGrowthChartData(
      sex:
          sex,
      weightForAge:
          weightForAge,
      lengthHeightForAge:
          lengthHeightForAge,
      weightForLength:
          weightForLength,
      weightForHeight:
          weightForHeight,
      bmiForAge:
          bmiForAge,
      headCircumferenceForAge:
          headCircumferenceForAge,
      processedMeasurements:
          processed,
      skippedMeasurements:
          skipped,
    );
  }

  // ==========================================================================
  // LEGACY - SEXO
  // ==========================================================================

  Sex _convertLegacySex(
    ChildSex sex,
  ) {
    if (sex ==
        ChildSex.girl) {
      return Sex.female;
    }

    return Sex.male;
  }

  // ==========================================================================
  // LEGACY - POSICIÓN
  // ==========================================================================

  LengthHeightMeasurementPosition
      _convertLegacyMeasurementPosition(
    GrowthMeasurementType type,
  ) {
    switch (type) {
      case GrowthMeasurementType.length:
        return LengthHeightMeasurementPosition
            .recumbent;

      case GrowthMeasurementType.height:
        return LengthHeightMeasurementPosition
            .standing;
    }
  }
}