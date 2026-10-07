import 'package:growth_standards/growth_standards.dart';

import '../../children/models/child.dart';
import '../models/growth_measurement.dart';

// ============================================================================
// DATOS GENERADOS PARA LAS GRÁFICAS OMS
// ============================================================================

class WhoGrowthChartData {
  final Sex sex;

  // Peso para la edad
  final List<Result> weightForAge;

  // Longitud / talla para la edad
  final List<Result> lengthHeightForAge;

  // Peso para longitud
  final List<Result> weightForLength;

  // Peso para talla
  final List<Result> weightForHeight;

  // IMC para la edad
  final List<Result> bmiForAge;

  // Perímetro cefálico para la edad
  final List<Result> headCircumferenceForAge;

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
// SERVICIO OMS
// ============================================================================

class WhoGrowthService {
  WhoGrowthService._();

  static final WhoGrowthService instance =
      WhoGrowthService._();

  // OMS:
  // Patrones de crecimiento desde nacimiento hasta aproximadamente 5 años.
  static const int _maximumWhoAgeDays =
      1856;

  // Antes de 2 años se maneja longitud acostado.
  // Desde 2 años talla de pie.
  static const int _lengthHeightCutoffDays =
      730;

  // ==========================================================================
  // CONSTRUIR DATOS
  // ==========================================================================

  WhoGrowthChartData build({
    required Child child,
    required List<GrowthMeasurement> measurements,
  }) {
    final Sex sex =
        _convertSex(
      child.sex,
    );

    // ------------------------------------------------------------------------
    // LISTAS PARA CADA INDICADOR
    // ------------------------------------------------------------------------

    final List<Result> weightForAge =
        <Result>[];

    final List<Result> lengthHeightForAge =
        <Result>[];

    final List<Result> weightForLength =
        <Result>[];

    final List<Result> weightForHeight =
        <Result>[];

    final List<Result> bmiForAge =
        <Result>[];

    final List<Result> headCircumferenceForAge =
        <Result>[];

    int processed = 0;
    int skipped = 0;

    // ------------------------------------------------------------------------
    // ORDENAR CONTROLES POR FECHA
    // ------------------------------------------------------------------------

    final List<GrowthMeasurement> ordered =
        List<GrowthMeasurement>.from(
      measurements,
    )
          ..sort(
            (
              GrowthMeasurement a,
              GrowthMeasurement b,
            ) =>
                a.measuredAt.compareTo(
              b.measuredAt,
            ),
          );

    // ------------------------------------------------------------------------
    // FECHA DE NACIMIENTO
    // ------------------------------------------------------------------------

    final Date birthDate =
        Date.fromDateTime(
      child.birthDate,
    );

    // ========================================================================
    // RECORRER CONTROLES
    // ========================================================================

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

        // --------------------------------------------------------------------
        // SOLO 0–5 AÑOS
        // --------------------------------------------------------------------

        if (ageDays < 0 ||
            ageDays >
                _maximumWhoAgeDays) {
          skipped++;
          continue;
        }

        // --------------------------------------------------------------------
        // PESO
        // --------------------------------------------------------------------

        final Mass weight =
            Mass$Kilogram(
          measurement.weightKg,
        );

        // --------------------------------------------------------------------
        // LONGITUD / TALLA
        // --------------------------------------------------------------------

        final Length lengthHeight =
            Length$Centimeter(
          measurement.heightCm,
        );

        final LengthHeightMeasurementPosition
            measurementPosition =
            _convertMeasurementPosition(
          measurement.measurementType,
        );

        // ====================================================================
        // 1. PESO PARA LA EDAD
        // ====================================================================

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

        // ====================================================================
        // 2. LONGITUD / TALLA PARA LA EDAD
        // ====================================================================

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

        // ====================================================================
        // 3. PESO PARA LONGITUD / TALLA
        // ====================================================================

        if (ageDays <=
            _lengthHeightCutoffDays) {
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

        // ====================================================================
        // 4. IMC PARA LA EDAD
        // ====================================================================

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

        // ====================================================================
        // 5. PERÍMETRO CEFÁLICO PARA LA EDAD
        //
        // Es OPCIONAL.
        //
        // Si el cuidador no registró el perímetro cefálico:
        // simplemente no se agrega ningún punto.
        // ====================================================================

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
            // Si únicamente el perímetro cefálico
            // tiene un valor inválido, no dañamos
            // las demás curvas del control.
          }
        }

        processed++;
      } catch (_) {
        // Un control incorrecto no debe impedir
        // mostrar los otros controles válidos.

        skipped++;
      }
    }

    // ========================================================================
    // RESULTADO
    // ========================================================================

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
  // SEXO
  // ==========================================================================

  Sex _convertSex(
    ChildSex sex,
  ) {
    if (sex ==
        ChildSex.girl) {
      return Sex.female;
    }

    return Sex.male;
  }

  // ==========================================================================
  // POSICIÓN DE MEDICIÓN
  // ==========================================================================

  LengthHeightMeasurementPosition
      _convertMeasurementPosition(
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