import 'dart:convert';

import 'package:flutter/services.dart';

import '../../children/models/child.dart';

import '../models/who_growth_reference.dart';

// ============================================================================
// INDICADORES OMS
// ============================================================================

enum WhoGrowthIndicator {
  weightForAge,
  heightForAge,
  bmiForAge,
  headForAge,
  weightForLength,
  weightForHeight,
}

// ============================================================================
// LOADER DE TABLAS OMS
// ============================================================================

class WhoGrowthReferenceLoader {
  WhoGrowthReferenceLoader._();

  static final WhoGrowthReferenceLoader instance =
      WhoGrowthReferenceLoader._();

  // --------------------------------------------------------------------------
  // CACHE
  //
  // Evita leer el mismo JSON varias veces desde assets.
  // --------------------------------------------------------------------------

  final Map<String, WhoGrowthReference> _cache =
      <String, WhoGrowthReference>{};

  // ==========================================================================
  // CARGAR TABLA
  // ==========================================================================

  Future<WhoGrowthReference> load({
    required WhoGrowthIndicator indicator,
    required ChildSex sex,
  }) async {
    final String path =
        _assetPath(
      indicator: indicator,
      sex: sex,
    );

    // ------------------------------------------------------------------------
    // SI YA ESTÁ CARGADO, DEVOLVERLO
    // ------------------------------------------------------------------------

    final WhoGrowthReference? cached =
        _cache[path];

    if (cached != null) {
      return cached;
    }

    // ------------------------------------------------------------------------
    // LEER ARCHIVO
    // ------------------------------------------------------------------------

    final String raw =
        await rootBundle.loadString(
      path,
    );

    // ------------------------------------------------------------------------
    // DECODIFICAR JSON
    // ------------------------------------------------------------------------

    final dynamic decoded =
        jsonDecode(
      raw,
    );

    if (decoded is! Map<String, dynamic>) {
      throw FormatException(
        'El archivo OMS no tiene un formato JSON válido: $path',
      );
    }

    // ------------------------------------------------------------------------
    // CONVERTIR AL MODELO
    // ------------------------------------------------------------------------

    final WhoGrowthReference reference =
        WhoGrowthReference.fromJson(
      decoded,
    );

    // ------------------------------------------------------------------------
    // VALIDAR QUE TENGA DATOS
    // ------------------------------------------------------------------------

    if (reference.points.isEmpty) {
      throw FormatException(
        'La tabla OMS está vacía: $path',
      );
    }

    // ------------------------------------------------------------------------
    // VALIDAR SEXO
    // ------------------------------------------------------------------------

    final String expectedSex =
        sex == ChildSex.girl
            ? 'girls'
            : 'boys';

    if (reference.sex != expectedSex) {
      throw FormatException(
        'El sexo indicado dentro del archivo no coincide. '
        'Esperado: $expectedSex. '
        'Encontrado: ${reference.sex}. '
        'Archivo: $path',
      );
    }

    // ------------------------------------------------------------------------
    // VALIDAR INDICADOR
    // ------------------------------------------------------------------------

    final String expectedIndicator =
        _indicatorName(
      indicator,
    );

    if (reference.indicator !=
        expectedIndicator) {
      throw FormatException(
        'El indicador del archivo no coincide. '
        'Esperado: $expectedIndicator. '
        'Encontrado: ${reference.indicator}. '
        'Archivo: $path',
      );
    }

    // ------------------------------------------------------------------------
    // GUARDAR EN CACHE
    // ------------------------------------------------------------------------

    _cache[path] =
        reference;

    return reference;
  }

  // ==========================================================================
  // RUTA DEL ARCHIVO
  // ==========================================================================

  String _assetPath({
    required WhoGrowthIndicator indicator,
    required ChildSex sex,
  }) {
    final String sexName =
        sex == ChildSex.girl
            ? 'girls'
            : 'boys';

    final String fileName;

    switch (indicator) {
      case WhoGrowthIndicator.weightForAge:
        fileName =
            'weight_age_$sexName.json';
        break;

      case WhoGrowthIndicator.heightForAge:
        fileName =
            'height_age_$sexName.json';
        break;

      case WhoGrowthIndicator.bmiForAge:
        fileName =
            'bmi_age_$sexName.json';
        break;

      case WhoGrowthIndicator.headForAge:
        fileName =
            'head_age_$sexName.json';
        break;

      case WhoGrowthIndicator.weightForLength:
        fileName =
            'weight_length_$sexName.json';
        break;

      case WhoGrowthIndicator.weightForHeight:
        fileName =
            'weight_height_$sexName.json';
        break;
    }

    return 'assets/data/growth/who/$fileName';
  }

  // ==========================================================================
  // NOMBRE INTERNO DEL INDICADOR
  //
  // Debe coincidir exactamente con el campo "indicator"
  // que posteriormente pondremos dentro de los JSON.
  // ==========================================================================

  String _indicatorName(
    WhoGrowthIndicator indicator,
  ) {
    switch (indicator) {
      case WhoGrowthIndicator.weightForAge:
        return 'weight_for_age';

      case WhoGrowthIndicator.heightForAge:
        return 'height_for_age';

      case WhoGrowthIndicator.bmiForAge:
        return 'bmi_for_age';

      case WhoGrowthIndicator.headForAge:
        return 'head_circumference_for_age';

      case WhoGrowthIndicator.weightForLength:
        return 'weight_for_length';

      case WhoGrowthIndicator.weightForHeight:
        return 'weight_for_height';
    }
  }

  // ==========================================================================
  // COMPROBAR SI YA ESTÁ EN MEMORIA
  // ==========================================================================

  bool isLoaded({
    required WhoGrowthIndicator indicator,
    required ChildSex sex,
  }) {
    final String path =
        _assetPath(
      indicator: indicator,
      sex: sex,
    );

    return _cache.containsKey(
      path,
    );
  }

  // ==========================================================================
  // LIMPIAR CACHE
  //
  // Normalmente no será necesario, pero sirve para pruebas.
  // ==========================================================================

  void clearCache() {
    _cache.clear();
  }
}