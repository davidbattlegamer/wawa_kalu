import '../../../core/database/app_database.dart';

import '../models/growth_measurement.dart';

class GrowthRepository {
  GrowthRepository._();

  static final GrowthRepository instance =
      GrowthRepository._();

  Future<List<GrowthMeasurement>>
      getMeasurementsForChild(
    String childId,
  ) {
    return AppDatabase.instance
        .getGrowthMeasurements(
      childId,
    );
  }

  Future<GrowthMeasurement?>
      getLatestMeasurement(
    String childId,
  ) {
    return AppDatabase.instance
        .getLatestGrowthMeasurement(
      childId,
    );
  }

  Future<void> addMeasurement(
    GrowthMeasurement measurement,
  ) {
    return AppDatabase.instance
        .insertGrowthMeasurement(
      measurement,
    );
  }

  Future<void> updateMeasurement(
    GrowthMeasurement measurement,
  ) {
    return AppDatabase.instance
        .updateGrowthMeasurement(
      measurement,
    );
  }

  Future<void> deleteMeasurement(
    String id,
  ) {
    return AppDatabase.instance
        .deleteGrowthMeasurement(
      id,
    );
  }
}