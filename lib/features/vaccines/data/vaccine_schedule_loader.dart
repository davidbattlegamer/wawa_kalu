import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/vaccine.dart';

class VaccineScheduleLoader {
  VaccineScheduleLoader._();

  static final VaccineScheduleLoader instance =
      VaccineScheduleLoader._();

  List<VaccineDose>? _cache;

  Future<List<VaccineDose>>
      loadSchedule() async {
    if (_cache != null) {
      return _cache!;
    }

    final String jsonString =
        await rootBundle.loadString(
      'assets/data/vaccines/ecuador_2026.json',
    );

    final Map<String, dynamic> data =
        jsonDecode(jsonString)
            as Map<String, dynamic>;

    final List<dynamic> doses =
        data['doses'] as List<dynamic>;

    _cache = doses
        .map(
          (item) =>
              VaccineDose.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return _cache!;
  }
}