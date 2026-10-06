import '../../../core/database/app_database.dart';

import '../models/vaccine_record.dart';

class VaccineRepository {
  VaccineRepository._();

  static final VaccineRepository instance =
      VaccineRepository._();

  Future<List<VaccineRecord>>
      getRecordsForChild(
    String childId,
  ) {
    return AppDatabase.instance
        .getVaccineRecords(
      childId,
    );
  }

  Future<void> saveRecord(
    VaccineRecord record,
  ) {
    return AppDatabase.instance
        .saveVaccineRecord(
      record,
    );
  }

  Future<void> deleteRecord(
    String id,
  ) {
    return AppDatabase.instance
        .deleteVaccineRecord(
      id,
    );
  }
}