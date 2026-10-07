import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/who_growth_table.dart';

class WhoGrowthTableLoader {
  WhoGrowthTableLoader._();

  static final WhoGrowthTableLoader instance =
      WhoGrowthTableLoader._();

  static const String _basePath =
      'assets/data/growth/who';

  final Map<String, WhoGrowthTable>
      _cache =
      <String, WhoGrowthTable>{};

  Future<WhoGrowthTable> load({
    required WhoGrowthIndicator indicator,
    required WhoGrowthSex sex,
  }) async {
    final String fileName =
        _fileName(
      indicator:
          indicator,
      sex:
          sex,
    );

    final String assetPath =
        '$_basePath/$fileName';

    final WhoGrowthTable? cached =
        _cache[
            assetPath];

    if (cached != null) {
      return cached;
    }

    final String jsonString;

    try {
      jsonString =
          await rootBundle
              .loadString(
        assetPath,
      );
    } catch (error) {
      throw StateError(
        'No se pudo cargar la tabla OMS: '
        '$assetPath\n'
        '$error',
      );
    }

    final dynamic decoded;

    try {
      decoded =
          jsonDecode(
        jsonString,
      );
    } catch (error) {
      throw FormatException(
        'El archivo OMS no contiene JSON válido: '
        '$assetPath\n'
        '$error',
      );
    }

    if (decoded
        is! Map<String, dynamic>) {
      throw FormatException(
        'La estructura de la tabla OMS no es válida: '
        '$assetPath',
      );
    }

    final WhoGrowthTable table =
        WhoGrowthTable.fromJson(
      decoded,
    );

    _validateIdentity(
      table:
          table,
      indicator:
          indicator,
      sex:
          sex,
      assetPath:
          assetPath,
    );

    _cache[
        assetPath] =
        table;

    return table;
  }

  Future<Map<
      WhoGrowthIndicator,
      WhoGrowthTable>> loadAgeTables({
    required WhoGrowthSex sex,
  }) async {
    final List<WhoGrowthIndicator>
        indicators =
        <WhoGrowthIndicator>[
      WhoGrowthIndicator
          .weightForAge,
      WhoGrowthIndicator
          .lengthHeightForAge,
      WhoGrowthIndicator
          .bmiForAge,
      WhoGrowthIndicator
          .headCircumferenceForAge,
    ];

    final Map<
        WhoGrowthIndicator,
        WhoGrowthTable> result =
        <WhoGrowthIndicator,
            WhoGrowthTable>{};

    for (final WhoGrowthIndicator
        indicator in indicators) {
      result[
              indicator] =
          await load(
        indicator:
            indicator,
        sex:
            sex,
      );
    }

    return result;
  }

  Future<Map<
      WhoGrowthIndicator,
      WhoGrowthTable>> loadBodySizeTables({
    required WhoGrowthSex sex,
  }) async {
    final Map<
        WhoGrowthIndicator,
        WhoGrowthTable> result =
        <WhoGrowthIndicator,
            WhoGrowthTable>{};

    result[
            WhoGrowthIndicator
                .weightForLength] =
        await load(
      indicator:
          WhoGrowthIndicator
              .weightForLength,
      sex:
          sex,
    );

    result[
            WhoGrowthIndicator
                .weightForHeight] =
        await load(
      indicator:
          WhoGrowthIndicator
              .weightForHeight,
      sex:
          sex,
    );

    return result;
  }

  Future<void> preloadAll() async {
    for (final WhoGrowthSex
        sex in WhoGrowthSex.values) {
      for (final WhoGrowthIndicator
          indicator
          in WhoGrowthIndicator.values) {
        await load(
          indicator:
              indicator,
          sex:
              sex,
        );
      }
    }
  }

  void clearCache() {
    _cache.clear();
  }

  String _fileName({
    required WhoGrowthIndicator indicator,
    required WhoGrowthSex sex,
  }) {
    final String sexName =
        sex ==
                WhoGrowthSex
                    .boys
            ? 'boys'
            : 'girls';

    switch (indicator) {
      case WhoGrowthIndicator
            .weightForAge:
        return 'weight_age_$sexName.json';

      case WhoGrowthIndicator
            .lengthHeightForAge:
        return 'height_age_$sexName.json';

      case WhoGrowthIndicator
            .bmiForAge:
        return 'bmi_age_$sexName.json';

      case WhoGrowthIndicator
            .headCircumferenceForAge:
        return 'head_age_$sexName.json';

      case WhoGrowthIndicator
            .weightForLength:
        return 'weight_length_$sexName.json';

      case WhoGrowthIndicator
            .weightForHeight:
        return 'weight_height_$sexName.json';
    }
  }

  void _validateIdentity({
    required WhoGrowthTable table,
    required WhoGrowthIndicator indicator,
    required WhoGrowthSex sex,
    required String assetPath,
  }) {
    final String expectedSex =
        sex ==
                WhoGrowthSex
                    .boys
            ? 'boys'
            : 'girls';

    if (table.sex !=
        expectedSex) {
      throw StateError(
        'Sexo incorrecto en la tabla OMS.\n'
        'Archivo: $assetPath\n'
        'Esperado: $expectedSex\n'
        'Encontrado: ${table.sex}',
      );
    }

    final String
        expectedIndicator =
        _expectedIndicatorName(
      indicator,
    );

    if (table.indicator !=
        expectedIndicator) {
      throw StateError(
        'Indicador incorrecto en la tabla OMS.\n'
        'Archivo: $assetPath\n'
        'Esperado: $expectedIndicator\n'
        'Encontrado: ${table.indicator}',
      );
    }
  }

  String _expectedIndicatorName(
    WhoGrowthIndicator indicator,
  ) {
    switch (indicator) {
      case WhoGrowthIndicator
            .weightForAge:
        return 'weight_for_age';

      case WhoGrowthIndicator
            .lengthHeightForAge:
        return 'length_height_for_age';

      case WhoGrowthIndicator
            .bmiForAge:
        return 'bmi_for_age';

      case WhoGrowthIndicator
            .headCircumferenceForAge:
        return 'head_circumference_for_age';

      case WhoGrowthIndicator
            .weightForLength:
        return 'weight_for_length';

      case WhoGrowthIndicator
            .weightForHeight:
        return 'weight_for_height';
    }
  }
}