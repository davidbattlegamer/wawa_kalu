import 'package:flutter/material.dart';

import '../../../core/utils/age_utils.dart';

import '../../../pages/app_texts.dart';

import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';

import '../data/growth_repository.dart';
import '../models/growth_measurement.dart';

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
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      _weightController;

  late final TextEditingController
      _heightController;

  late final TextEditingController
      _notesController;

  late DateTime _measuredAt;

  late GrowthMeasurementType
      _measurementType;

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
          : _numberText(
              current.weightKg,
            ),
    );

    _heightController =
        TextEditingController(
      text: current == null
          ? ''
          : _numberText(
              current.heightCm,
            ),
    );

    _notesController =
        TextEditingController(
      text: current?.notes ?? '',
    );

    _measurementType =
        current?.measurementType ??
            _suggestedType(
              _measuredAt,
            );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  GrowthMeasurementType _suggestedType(
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

  String _numberText(
    double value,
  ) {
    if (value ==
        value.roundToDouble()) {
      return value
          .toStringAsFixed(0);
    }

    return value
        .toStringAsFixed(1);
  }

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
          T.txt('cancel'),

      confirmText:
          T.txt('accept'),
    );

    if (selected == null ||
        !mounted) {
      return;
    }

    setState(() {
      _measuredAt = selected;

      if (!_editing) {
        _measurementType =
            _suggestedType(
          selected,
        );
      }
    });
  }

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

    final double weight =
        _parseNumber(
      _weightController.text,
    )!;

    final double height =
        _parseNumber(
      _heightController.text,
    )!;

    setState(() {
      _saving = true;
    });

    try {
      final String notes =
          _notesController
              .text
              .trim();

      if (_editing) {
        final GrowthMeasurement
            updated =
            widget.measurement!
                .copyWith(
          measuredAt:
              _measuredAt,
          weightKg:
              weight,
          heightCm:
              height,
          measurementType:
              _measurementType,
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
        final GrowthMeasurement
            measurement =
            GrowthMeasurement(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),

          childId:
              widget.child.id,

          measuredAt:
              _measuredAt,

          weightKg:
              weight,

          heightCm:
              height,

          measurementType:
              _measurementType,

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
                T.txt('cancel'),
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
                T.txt('delete'),
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

    return Scaffold(
      backgroundColor: dark
          ? const Color(
              0xFF15131A,
            )
          : const Color(
              0xFFFAF7F2,
            ),

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
                  T.txt('delete'),

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
              const EdgeInsets
                  .fromLTRB(
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
                // CHILD

                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets
                          .all(
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

                // DATE

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
                      BorderRadius
                          .circular(
                    18,
                  ),

                  child: Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets
                            .all(
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

                // WEIGHT

                _Label(
                  text:
                      T.txt(
                    'weightKg',
                  ),
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

                    hint:
                        '10.4',

                    suffix:
                        'kg',
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

                    if (number <= 0 ||
                        number > 150) {
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

                // HEIGHT

                _Label(
                  text:
                      T.txt(
                    'heightCm',
                  ),
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

                    hint:
                        '78.3',

                    suffix:
                        'cm',
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

                    if (number < 10 ||
                        number > 200) {
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

                // TYPE

                _Label(
                  text:
                      T.txt(
                    'measurementMethod',
                  ),
                ),

                const SizedBox(
                  height:
                      7,
                ),

                Text(
                  T.txt(
                    'measurementMethodDescription',
                  ),

                  style:
                      TextStyle(
                    fontFamily:
                        'Baloo2',

                    fontSize:
                        14,

                    height:
                        1.25,

                    color: dark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),

                const SizedBox(
                  height:
                      12,
                ),

                SizedBox(
                  width:
                      double.infinity,

                  child:
                      SegmentedButton<
                          GrowthMeasurementType>(
                    segments: [
                      ButtonSegment<
                          GrowthMeasurementType>(
                        value:
                            GrowthMeasurementType
                                .length,

                        icon:
                            const Icon(
                          Icons
                              .airline_seat_flat_rounded,
                        ),

                        label:
                            Text(
                          T.txt(
                            'recumbentLength',
                          ),
                        ),
                      ),

                      ButtonSegment<
                          GrowthMeasurementType>(
                        value:
                            GrowthMeasurementType
                                .height,

                        icon:
                            const Icon(
                          Icons
                              .accessibility_new_rounded,
                        ),

                        label:
                            Text(
                          T.txt(
                            'standingHeight',
                          ),
                        ),
                      ),
                    ],

                    selected: {
                      _measurementType,
                    },

                    onSelectionChanged:
                        (
                      selection,
                    ) {
                      setState(() {
                        _measurementType =
                            selection.first;
                      });
                    },
                  ),
                ),

                const SizedBox(
                  height:
                      22,
                ),

                // NOTES

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

                    label:
                        Text(
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
          Icon(icon),

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

class _Label
    extends StatelessWidget {
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