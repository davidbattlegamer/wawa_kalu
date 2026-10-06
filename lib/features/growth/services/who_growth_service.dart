import 'package:growth_standards/growth_standards.dart';

import '../../children/models/child.dart';
import '../models/growth_measurement.dart';

class WhoGrowthChartData {
  final Sex sex;

  final List<Result> weightForAge;
  final List<Result> lengthHeightForAge;

  final List<Result> weightForLength;
  final List<Result> weightForHeight;

  final List<Result> bmiForAge;

  final int processedMeasurements;
  final int skippedMeasurements;

  const WhoGrowthChartData({
    required this.sex,
    required this.weightForAge,
    required this.lengthHeightForAge,
    required this.weightForLength,
    required this.weightForHeight,
    required this.bmiForAge,
    required this.processedMeasurements,
    required this.skippedMeasurements,
  });

  bool get hasAnyData =>
      weightForAge.isNotEmpty ||
      lengthHeightForAge.isNotEmpty ||
      weightForLength.isNotEmpty ||
      weightForHeight.isNotEmpty ||
      bmiForAge.isNotEmpty;
}

class WhoGrowthService {
  WhoGrowthService._();

  static final WhoGrowthService instance =
      WhoGrowthService._();

  static const int _maximumWhoAgeDays = 1856;

  static const int _lengthHeightCutoffDays = 730;

  WhoGrowthChartData build({
    required Child child,
    required List<GrowthMeasurement> measurements,
  }) {
    final Sex sex = _convertSex(
      child.sex,
    );

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

    int processed = 0;
    int skipped = 0;

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

        final Age age = Age(
          birthDate,
          observedDate: observedDate,
        );

        final int ageDays =
            age.ageInTotalDaysByNow;

        // Las curvas OMS que usamos aquí son para 0–5 años.
        if (ageDays < 0 ||
            ageDays > _maximumWhoAgeDays) {
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
            _convertMeasurementPosition(
          measurement.measurementType,
        );

        // ------------------------------------------------------
        // PESO PARA LA EDAD
        // ------------------------------------------------------

        final WHOGrowthStandardsWeightForAge
            weightAgeResult =
            WHOGrowthStandardsWeightForAge(
          sex: sex,
          age: age,
          weight: weight,
        );

        weightForAge.add(
          weightAgeResult,
        );

        // ------------------------------------------------------
        // LONGITUD / TALLA PARA LA EDAD
        // ------------------------------------------------------

        final WHOGrowthStandardsLengthForAge
            lengthAgeResult =
            WHOGrowthStandardsLengthForAge(
          sex: sex,
          age: age,
          lengthHeight: lengthHeight,
          measure: measurementPosition,
        );

        lengthHeightForAge.add(
          lengthAgeResult,
        );

        // ------------------------------------------------------
        // PESO PARA LONGITUD / PESO PARA TALLA
        // ------------------------------------------------------

        if (ageDays <=
            _lengthHeightCutoffDays) {
          final WHOGrowthStandardsWeightForLength
              result =
              WHOGrowthStandardsWeightForLength(
            sex: sex,
            age: age,
            length: lengthHeight,
            weight: weight,
            measure: measurementPosition,
          );

          weightForLength.add(
            result,
          );
        } else {
          final WHOGrowthStandardsWeightForHeight
              result =
              WHOGrowthStandardsWeightForHeight(
            sex: sex,
            age: age,
            height: lengthHeight,
            weight: weight,
            measure: measurementPosition,
          );

          weightForHeight.add(
            result,
          );
        }

        // ------------------------------------------------------
        // IMC PARA LA EDAD
        // ------------------------------------------------------

        final WHOGrowthStandardsBodyMassIndexMeasurement
            bmiMeasurement =
            WHOGrowthStandardsBodyMassIndexMeasurement
                .fromMeasurement(
          lengthHeight: lengthHeight,
          weight: weight,
          measure: measurementPosition,
          age: age,
        );

        final WHOGrowthStandardsBodyMassIndexForAge
            bmiResult =
            WHOGrowthStandardsBodyMassIndexForAge(
          sex: sex,
          bodyMassIndexMeasurement:
              bmiMeasurement,
        );

        bmiForAge.add(
          bmiResult,
        );

        processed++;
      } catch (_) {
        // Un control inválido no debe impedir mostrar
        // correctamente los demás controles.
        skipped++;
      }
    }

    return WhoGrowthChartData(
      sex: sex,
      weightForAge: weightForAge,
      lengthHeightForAge:
          lengthHeightForAge,
      weightForLength:
          weightForLength,
      weightForHeight:
          weightForHeight,
      bmiForAge: bmiForAge,
      processedMeasurements:
          processed,
      skippedMeasurements:
          skipped,
    );
  }

  Sex _convertSex(
    ChildSex sex,
  ) {
    if (sex == ChildSex.girl) {
      return Sex.female;
    }

    return Sex.male;
  }

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