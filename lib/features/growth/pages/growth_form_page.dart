import 'package:flutter/material.dart';

import '../../../core/utils/age_utils.dart';

import '../../../pages/app_texts.dart';

import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';

import '../data/growth_repository.dart';
import '../models/growth_measurement.dart';

// ============================================================================
// UNIDADES
// ============================================================================

enum _WeightUnit {
  kg,
  lb,
}

enum _LengthUnit {
  cm,
  m,
}

class GrowthFormPage extends StatefulWidget {
  final Child child;

  final GrowthMeasurement? measurement;

  const GrowthFormPage({
    super.key,
    required this.child,
    this.measurement,
  });

  @override
  State<GrowthFormPage> createState() =>
      _GrowthFormPageState();
}

class _GrowthFormPageState
    extends State<GrowthFormPage> {
  static const double _poundsPerKilogram =
      2.2046226218;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      _weightController;

  late final TextEditingController
      _heightController;

  late final TextEditingController
      _headCircumferenceController;

  late final TextEditingController
      _notesController;

  late DateTime _measuredAt;

  _WeightUnit _weightUnit =
      _WeightUnit.kg;

  _LengthUnit _lengthUnit =
      _LengthUnit.cm;

  bool _saving = false;
  bool _deleting = false;

  bool get _editing =>
      widget.measurement != null;

  @override
  void initState() {
    super.initState();

    final GrowthMeasurement? current =
        widget.measurement;

    _measuredAt =
        current?.measuredAt ??
            DateTime.now();

    _weightController =
        TextEditingController(
      text: current == null
          ? ''
          : _formatInput(
              current.weightKg,
              decimals: 2,
            ),
    );

    _heightController =
        TextEditingController(
      text: current == null
          ? ''
          : _formatInput(
              current.heightCm,
              decimals: 1,
            ),
    );

    _headCircumferenceController =
        TextEditingController(
      text: current
                  ?.headCircumferenceCm ==
              null
          ? ''
          : _formatInput(
              current!
                  .headCircumferenceCm!,
              decimals: 1,
            ),
    );

    _notesController =
        TextEditingController(
      text: current?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _headCircumferenceController
        .dispose();
    _notesController.dispose();

    super.dispose();
  }

  // ==========================================================================
  // TIPO DE MEDICIÓN AUTOMÁTICO
  //
  // Menor de 2 años -> longitud acostado
  // Desde 2 años    -> talla de pie
  //
  // Ya no se muestra un selector al usuario.
  // ==========================================================================

  GrowthMeasurementType
      _automaticMeasurementType(
    DateTime date,
  ) {
    final ChildAge age =
        calculateAge(
      widget.child.birthDate,
      referenceDate: date,
    );

    if (age.totalMonths < 24) {
      return GrowthMeasurementType
          .length;
    }

    return GrowthMeasurementType
        .height;
  }

  // ==========================================================================
  // NÚMEROS
  // ==========================================================================

  double? _parseNumber(
    String text,
  ) {
    final String normalized =
        text
            .trim()
            .replaceAll(
              ',',
              '.',
            );

    return double.tryParse(
      normalized,
    );
  }

  String _formatInput(
    double value, {
    required int decimals,
  }) {
    String text =
        value.toStringAsFixed(
      decimals,
    );

    text = text.replaceFirst(
      RegExp(
        r'0+$',
      ),
      '',
    );

    text = text.replaceFirst(
      RegExp(
        r'\.$',
      ),
      '',
    );

    return text;
  }

  // ==========================================================================
  // CONVERSIÓN PESO
  // ==========================================================================

  double _weightToKg(
    double value,
  ) {
    switch (_weightUnit) {
      case _WeightUnit.kg:
        return value;

      case _WeightUnit.lb:
        return value /
            _poundsPerKilogram;
    }
  }

  double _kgToWeight(
    double kg,
    _WeightUnit unit,
  ) {
    switch (unit) {
      case _WeightUnit.kg:
        return kg;

      case _WeightUnit.lb:
        return kg *
            _poundsPerKilogram;
    }
  }

  void _changeWeightUnit(
    _WeightUnit newUnit,
  ) {
    if (newUnit == _weightUnit) {
      return;
    }

    final double? currentValue =
        _parseNumber(
      _weightController.text,
    );

    if (currentValue != null) {
      final double kilograms =
          _weightToKg(
        currentValue,
      );

      _weightController.text =
          _formatInput(
        _kgToWeight(
          kilograms,
          newUnit,
        ),
        decimals: 2,
      );
    }

    setState(() {
      _weightUnit = newUnit;
    });
  }

  // ==========================================================================
  // CONVERSIÓN LONGITUD
  // ==========================================================================

  double _lengthToCm(
    double value,
  ) {
    switch (_lengthUnit) {
      case _LengthUnit.cm:
        return value;

      case _LengthUnit.m:
        return value * 100;
    }
  }

  double _cmToLength(
    double centimeters,
    _LengthUnit unit,
  ) {
    switch (unit) {
      case _LengthUnit.cm:
        return centimeters;

      case _LengthUnit.m:
        return centimeters / 100;
    }
  }

  void _changeLengthUnit(
    _LengthUnit newUnit,
  ) {
    if (newUnit == _lengthUnit) {
      return;
    }

    // Longitud / talla
    final double? heightValue =
        _parseNumber(
      _heightController.text,
    );

    if (heightValue != null) {
      final double centimeters =
          _lengthToCm(
        heightValue,
      );

      _heightController.text =
          _formatInput(
        _cmToLength(
          centimeters,
          newUnit,
        ),
        decimals:
            newUnit == _LengthUnit.m
                ? 3
                : 1,
      );
    }

    // Perímetro cefálico
    final double? headValue =
        _parseNumber(
      _headCircumferenceController
          .text,
    );

    if (headValue != null) {
      final double centimeters =
          _lengthToCm(
        headValue,
      );

      _headCircumferenceController
          .text = _formatInput(
        _cmToLength(
          centimeters,
          newUnit,
        ),
        decimals:
            newUnit == _LengthUnit.m
                ? 3
                : 1,
      );
    }

    setState(() {
      _lengthUnit = newUnit;
    });
  }

  // ==========================================================================
  // FECHA
  // ==========================================================================

  Future<void> _pickDate() async {
    final DateTime? selected =
        await showDatePicker(
      context: context,
      initialDate:
          _measuredAt,
      firstDate:
          widget.child.birthDate,
      lastDate:
          DateTime.now(),
      helpText:
          T.txt(
        'growthControlDate',
      ),
      cancelText:
          T.txt(
        'cancel',
      ),
      confirmText:
          T.txt(
        'accept',
      ),
    );

    if (selected == null ||
        !mounted) {
      return;
    }

    setState(() {
      _measuredAt = selected;
    });
  }

  // ==========================================================================
  // GUARDAR
  // ==========================================================================

  Future<void> _save() async {
    if (_saving ||
        _deleting) {
      return;
    }

    final bool valid =
        _formKey.currentState
                ?.validate() ??
            false;

    if (!valid) {
      return;
    }

    final double enteredWeight =
        _parseNumber(
      _weightController.text,
    )!;

    final double enteredHeight =
        _parseNumber(
      _heightController.text,
    )!;

    final String headText =
        _headCircumferenceController
            .text
            .trim();

    final double? enteredHead =
        headText.isEmpty
            ? null
            : _parseNumber(
                headText,
              );

    // ------------------------------------------------------------
    // TODO SE GUARDA SIEMPRE EN KG Y CM
    // ------------------------------------------------------------

    final double weightKg =
        _weightToKg(
      enteredWeight,
    );

    final double heightCm =
        _lengthToCm(
      enteredHeight,
    );

    final double? headCm =
        enteredHead == null
            ? null
            : _lengthToCm(
                enteredHead,
              );

    final GrowthMeasurementType
        measurementType =
        _automaticMeasurementType(
      _measuredAt,
    );

    setState(() {
      _saving = true;
    });

    try {
      final String notes =
          _notesController
              .text
              .trim();

      if (_editing) {
        final GrowthMeasurement updated =
            widget.measurement!
                .copyWith(
          measuredAt:
              _measuredAt,
          weightKg:
              weightKg,
          heightCm:
              heightCm,
          headCircumferenceCm:
              headCm,
          measurementType:
              measurementType,
          notes:
              notes.isEmpty
                  ? null
                  : notes,
        );

        await GrowthRepository.instance
            .updateMeasurement(
          updated,
        );
      } else {
        final GrowthMeasurement measurement =
            GrowthMeasurement(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          childId:
              widget.child.id,
          measuredAt:
              _measuredAt,
          weightKg:
              weightKg,
          heightCm:
              heightCm,
          headCircumferenceCm:
              headCm,
          measurementType:
              measurementType,
          notes:
              notes.isEmpty
                  ? null
                  : notes,
          createdAt:
              DateTime.now(),
        );

        await GrowthRepository.instance
            .addMeasurement(
          measurement,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ==========================================================================
  // ELIMINAR
  // ==========================================================================

  Future<void> _delete() async {
    final GrowthMeasurement?
        measurement =
        widget.measurement;

    if (measurement == null ||
        _saving ||
        _deleting) {
      return;
    }

    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title: Text(
            T.txt(
              'deleteGrowthControl',
            ),
          ),
          content: Text(
            T.txt(
              'deleteGrowthControlQuestion',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                T.txt(
                  'cancel',
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    Colors.redAccent,
              ),
              child: Text(
                T.txt(
                  'delete',
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true ||
        !mounted) {
      return;
    }

    setState(() {
      _deleting = true;
    });

    try {
      await GrowthRepository.instance
          .deleteMeasurement(
        measurement.id,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool dark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    const Color growthColor =
        Color(
      0xFF00A896,
    );

    final String weightSuffix =
        _weightUnit ==
                _WeightUnit.kg
            ? 'kg'
            : 'lb';

    final String lengthSuffix =
        _lengthUnit ==
                _LengthUnit.cm
            ? 'cm'
            : 'm';

    return Scaffold(
      backgroundColor: dark
          ? const Color(
              0xFF15131A,
            )
          : const Color(
              0xFFFAF7F2,
            ),

      // ======================================================================
      // APP BAR
      // ======================================================================

      appBar: AppBar(
        backgroundColor: dark
            ? const Color(
                0xFF211B2E,
              )
            : Colors.white,
        foregroundColor: dark
            ? Colors.white
            : const Color(
                0xFF2D2D2D,
              ),
        title: Text(
          _editing
              ? T.txt(
                  'editGrowthControl',
                )
              : T.txt(
                  'registerGrowthControl',
                ),
          style:
              const TextStyle(
            fontFamily:
                'Fredoka',
            fontWeight:
                FontWeight.w700,
          ),
        ),
        actions: [
          if (_editing)
            IconButton(
              onPressed:
                  _deleting
                      ? null
                      : _delete,
              tooltip:
                  T.txt(
                'delete',
              ),
              icon:
                  const Icon(
                Icons
                    .delete_outline_rounded,
                color:
                    Colors.redAccent,
              ),
            ),
        ],
      ),

      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            35,
          ),
          child: Form(
            key:
                _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                // ============================================================
                // NIÑO
                // ============================================================

                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                      BoxDecoration(
                    color: dark
                        ? const Color(
                            0xFF211B2E,
                          )
                        : Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                      22,
                    ),
                    border:
                        Border.all(
                      color:
                          growthColor
                              .withValues(
                        alpha:
                            0.15,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .monitor_weight_outlined,
                        color:
                            growthColor,
                        size:
                            37,
                      ),
                      const SizedBox(
                        width:
                            13,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              widget
                                  .child
                                  .name,
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Fredoka',
                                fontSize:
                                    19,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color: dark
                                    ? Colors.white
                                    : const Color(
                                        0xFF2D2D2D,
                                      ),
                              ),
                            ),
                            Text(
                              childAgeText(
                                widget
                                    .child
                                    .birthDate,
                              ),
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Baloo2',
                                color: dark
                                    ? Colors.white60
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height:
                      25,
                ),

                // ============================================================
                // FECHA
                // ============================================================

                _Label(
                  text:
                      T.txt(
                    'growthControlDate',
                  ),
                ),

                const SizedBox(
                  height:
                      8,
                ),

                InkWell(
                  onTap:
                      _pickDate,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  child: Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    decoration:
                        BoxDecoration(
                      color: dark
                          ? const Color(
                              0xFF211B2E,
                            )
                          : Colors.white,
                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .calendar_month_rounded,
                          color:
                              growthColor,
                        ),
                        const SizedBox(
                          width:
                              12,
                        ),
                        Expanded(
                          child: Text(
                            simpleDateText(
                              _measuredAt,
                            ),
                            style:
                                const TextStyle(
                              fontFamily:
                                  'Fredoka',
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons
                              .chevron_right_rounded,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height:
                      22,
                ),

                // ============================================================
                // PESO + UNIDAD
                // ============================================================

                Row(
                  children: [
                    Expanded(
                      child:
                          _Label(
                        text:
                            T.txt(
                          'weight',
                        ),
                      ),
                    ),
                    _WeightUnitSelector(
                      value:
                          _weightUnit,
                      onChanged:
                          _changeWeightUnit,
                    ),
                  ],
                ),

                const SizedBox(
                  height:
                      8,
                ),

                TextFormField(
                  controller:
                      _weightController,
                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal:
                        true,
                  ),
                  decoration:
                      _inputDecoration(
                    dark:
                        dark,
                    icon:
                        Icons
                            .monitor_weight_outlined,
                    hint: _weightUnit ==
                            _WeightUnit.kg
                        ? '10.4'
                        : '22.9',
                    suffix:
                        weightSuffix,
                  ),
                  validator: (
                    value,
                  ) {
                    final double? number =
                        _parseNumber(
                      value ?? '',
                    );

                    if (number ==
                        null) {
                      return T.txt(
                        'weightRequired',
                      );
                    }

                    final double kg =
                        _weightToKg(
                      number,
                    );

                    if (kg <= 0 ||
                        kg > 150) {
                      return T.txt(
                        'weightInvalid',
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height:
                      22,
                ),

                // ============================================================
                // LONGITUD / TALLA + UNIDAD
                // ============================================================

                Row(
                  children: [
                    Expanded(
                      child:
                          _Label(
                        text:
                            T.txt(
                          'lengthOrHeight',
                        ),
                      ),
                    ),
                    _LengthUnitSelector(
                      value:
                          _lengthUnit,
                      onChanged:
                          _changeLengthUnit,
                    ),
                  ],
                ),

                const SizedBox(
                  height:
                      8,
                ),

                TextFormField(
                  controller:
                      _heightController,
                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal:
                        true,
                  ),
                  decoration:
                      _inputDecoration(
                    dark:
                        dark,
                    icon:
                        Icons
                            .straighten_rounded,
                    hint: _lengthUnit ==
                            _LengthUnit.cm
                        ? '78.3'
                        : '0.783',
                    suffix:
                        lengthSuffix,
                  ),
                  validator: (
                    value,
                  ) {
                    final double? number =
                        _parseNumber(
                      value ?? '',
                    );

                    if (number ==
                        null) {
                      return T.txt(
                        'heightRequired',
                      );
                    }

                    final double cm =
                        _lengthToCm(
                      number,
                    );

                    if (cm < 10 ||
                        cm > 200) {
                      return T.txt(
                        'heightInvalid',
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height:
                      22,
                ),

                // ============================================================
                // PERÍMETRO CEFÁLICO - OPCIONAL
                // ============================================================

                _Label(
                  text:
                      T.txt(
                    'headCircumferenceOptional',
                  ),
                ),

                const SizedBox(
                  height:
                      8,
                ),

                TextFormField(
                  controller:
                      _headCircumferenceController,
                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal:
                        true,
                  ),
                  decoration:
                      _inputDecoration(
                    dark:
                        dark,
                    icon:
                        Icons
                            .radio_button_unchecked_rounded,
                    hint: _lengthUnit ==
                            _LengthUnit.cm
                        ? '45.2'
                        : '0.452',
                    suffix:
                        lengthSuffix,
                  ),
                  validator: (
                    value,
                  ) {
                    final String text =
                        value
                                ?.trim() ??
                            '';

                    // Es opcional.
                    if (text.isEmpty) {
                      return null;
                    }

                    final double? number =
                        _parseNumber(
                      text,
                    );

                    if (number ==
                        null) {
                      return T.txt(
                        'headCircumferenceInvalid',
                      );
                    }

                    final double cm =
                        _lengthToCm(
                      number,
                    );

                    if (cm <= 0 ||
                        cm > 100) {
                      return T.txt(
                        'headCircumferenceInvalid',
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height:
                      22,
                ),

                // ============================================================
                // NOTAS
                // ============================================================

                _Label(
                  text:
                      T.txt(
                    'notesOptional',
                  ),
                ),

                const SizedBox(
                  height:
                      8,
                ),

                TextFormField(
                  controller:
                      _notesController,
                  maxLines:
                      3,
                  textCapitalization:
                      TextCapitalization
                          .sentences,
                  decoration:
                      _inputDecoration(
                    dark:
                        dark,
                    icon:
                        Icons
                            .notes_rounded,
                    hint:
                        T.txt(
                      'growthNotesHint',
                    ),
                  ),
                ),

                const SizedBox(
                  height:
                      30,
                ),

                // ============================================================
                // GUARDAR
                // ============================================================

                SizedBox(
                  width:
                      double.infinity,
                  height:
                      57,
                  child:
                      FilledButton.icon(
                    onPressed:
                        _saving ||
                                _deleting
                            ? null
                            : _save,
                    style:
                        FilledButton
                            .styleFrom(
                      backgroundColor:
                          growthColor,
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),
                    ),
                    icon: _saving
                        ? const SizedBox(
                            width:
                                20,
                            height:
                                20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.2,
                              color:
                                  Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons
                                .save_rounded,
                          ),
                    label: Text(
                      _editing
                          ? T.txt(
                              'saveChanges',
                            )
                          : T.txt(
                              'saveGrowthControl',
                            ),
                      style:
                          const TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize:
                            17,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required bool dark,
    required IconData icon,
    required String hint,
    String? suffix,
  }) {
    return InputDecoration(
      hintText:
          hint,
      suffixText:
          suffix,
      prefixIcon:
          Icon(
        icon,
      ),
      filled:
          true,
      fillColor: dark
          ? const Color(
              0xFF211B2E,
            )
          : Colors.white,
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            BorderSide.none,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            BorderSide(
          color:
              const Color(
            0xFF00A896,
          ).withValues(
            alpha:
                0.13,
          ),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            const BorderSide(
          color:
              Color(
            0xFF00A896,
          ),
          width:
              1.7,
        ),
      ),
    );
  }
}

// ============================================================================
// LABEL
// ============================================================================

class _Label extends StatelessWidget {
  final String text;

  const _Label({
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      text,
      style:
          const TextStyle(
        fontFamily:
            'Fredoka',
        fontSize:
            17,
        fontWeight:
            FontWeight.w700,
      ),
    );
  }
}

// ============================================================================
// SELECTOR KG / LB
// ============================================================================

class _WeightUnitSelector
    extends StatelessWidget {
  final _WeightUnit value;

  final ValueChanged<_WeightUnit>
      onChanged;

  const _WeightUnitSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SegmentedButton<
        _WeightUnit>(
      showSelectedIcon:
          false,
      segments:
          const [
        ButtonSegment<
            _WeightUnit>(
          value:
              _WeightUnit.kg,
          label:
              Text(
            'kg',
          ),
        ),
        ButtonSegment<
            _WeightUnit>(
          value:
              _WeightUnit.lb,
          label:
              Text(
            'lb',
          ),
        ),
      ],
      selected: {
        value,
      },
      onSelectionChanged: (
        selection,
      ) {
        onChanged(
          selection.first,
        );
      },
    );
  }
}

// ============================================================================
// SELECTOR CM / M
// ============================================================================

class _LengthUnitSelector
    extends StatelessWidget {
  final _LengthUnit value;

  final ValueChanged<_LengthUnit>
      onChanged;

  const _LengthUnitSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SegmentedButton<
        _LengthUnit>(
      showSelectedIcon:
          false,
      segments:
          const [
        ButtonSegment<
            _LengthUnit>(
          value:
              _LengthUnit.cm,
          label:
              Text(
            'cm',
          ),
        ),
        ButtonSegment<
            _LengthUnit>(
          value:
              _LengthUnit.m,
          label:
              Text(
            'm',
          ),
        ),
      ],
      selected: {
        value,
      },
      onSelectionChanged: (
        selection,
      ) {
        onChanged(
          selection.first,
        );
      },
    );
  }
}