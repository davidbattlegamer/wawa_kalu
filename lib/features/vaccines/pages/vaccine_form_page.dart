import 'package:flutter/material.dart';

import '../../../pages/app_texts.dart';

import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';

import '../data/vaccine_repository.dart';

import '../models/vaccine.dart';
import '../models/vaccine_record.dart';

import '../services/vaccine_notification_service.dart';

class VaccineFormPage extends StatefulWidget {
  final Child child;
  final VaccineDose dose;
  final VaccineRecord? record;

  const VaccineFormPage({
    super.key,
    required this.child,
    required this.dose,
    this.record,
  });

  @override
  State<VaccineFormPage> createState() =>
      _VaccineFormPageState();
}

class _VaccineFormPageState
    extends State<VaccineFormPage> {
  late DateTime _appliedDate;

  late final TextEditingController
      _healthCenterController;

  late final TextEditingController
      _notesController;

  bool _saving = false;
  bool _deleting = false;

  bool get _editing =>
      widget.record != null;

  @override
  void initState() {
    super.initState();

    _appliedDate =
        widget.record?.appliedDate ??
            DateTime.now();

    _healthCenterController =
        TextEditingController(
      text:
          widget.record?.healthCenter ??
              '',
    );

    _notesController =
        TextEditingController(
      text:
          widget.record?.notes ??
              '',
    );
  }

  @override
  void dispose() {
    _healthCenterController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // SELECCIONAR FECHA
  // ------------------------------------------------------------

  Future<void> _selectDate() async {
    final DateTime now =
        DateTime.now();

    final DateTime? selected =
        await showDatePicker(
      context: context,

      initialDate:
          _appliedDate,

      firstDate:
          widget.child.birthDate,

      lastDate:
          now,

      helpText:
          T.txt(
        'vaccineAppliedDate',
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
      _appliedDate = selected;
    });
  }

  // ------------------------------------------------------------
  // GUARDAR
  // ------------------------------------------------------------

  Future<void> _save() async {
    if (_saving ||
        _deleting) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final String healthCenter =
          _healthCenterController
              .text
              .trim();

      final String notes =
          _notesController
              .text
              .trim();

      final VaccineRecord record =
          VaccineRecord(
        id: widget.record?.id ??
            '${widget.child.id}_${widget.dose.id}',

        childId:
            widget.child.id,

        scheduleId:
            widget.dose.id,

        vaccineCode:
            widget.dose.vaccineCode,

        appliedDate:
            _appliedDate,

        healthCenter:
            healthCenter.isEmpty
                ? null
                : healthCenter,

        notes:
            notes.isEmpty
                ? null
                : notes,

        createdAt:
            widget.record?.createdAt ??
                DateTime.now(),
      );

      await VaccineRepository.instance
          .saveRecord(
        record,
      );

      // Al marcar la vacuna como aplicada,
      // se recalculan los recordatorios.
      await VaccineNotificationService
          .instance
          .rescheduleForChild(
        widget.child,
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
          _saving = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // ELIMINAR REGISTRO
  // ------------------------------------------------------------

  Future<void> _delete() async {
    final VaccineRecord? record =
        widget.record;

    if (record == null ||
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
              'deleteVaccineRecord',
            ),
          ),

          content: Text(
            T.txt(
              'deleteVaccineRecordQuestion',
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
                foregroundColor:
                    Colors.white,
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
      await VaccineRepository.instance
          .deleteRecord(
        record.id,
      );

      // Si se elimina el registro,
      // los recordatorios vuelven a calcularse.
      await VaccineNotificationService
          .instance
          .rescheduleForChild(
        widget.child,
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

  // ------------------------------------------------------------
  // INTERFAZ
  // ------------------------------------------------------------

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool dark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    final Color childColor =
        widget.child.sex ==
                ChildSex.girl
            ? Colors.pink
            : Colors.blue;

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

        elevation: 0,

        title: Text(
          _editing
              ? T.txt(
                  'editVaccineRecord',
                )
              : T.txt(
                  'registerVaccine',
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
              tooltip:
                  T.txt('delete'),

              onPressed:
                  _deleting
                      ? null
                      : _delete,

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

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              // --------------------------------------------------
              // NIÑO
              // --------------------------------------------------

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
                  gradient:
                      LinearGradient(
                    colors: [
                      dark
                          ? const Color(
                              0xFF211B2E,
                            )
                          : Colors.white,

                      childColor
                          .withValues(
                        alpha:
                            dark
                                ? 0.15
                                : 0.07,
                      ),
                    ],
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    22,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,

                        color:
                            childColor
                                .withValues(
                          alpha:
                              0.14,
                        ),
                      ),

                      child: Icon(
                        widget.child.sex ==
                                ChildSex
                                    .girl
                            ? Icons
                                .face_3_rounded
                            : Icons
                                .face_6_rounded,

                        color:
                            childColor,

                        size: 30,
                      ),
                    ),

                    const SizedBox(
                      width: 13,
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
                                  ? Colors
                                      .white
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

                              fontSize:
                                  14,

                              color: dark
                                  ? Colors
                                      .white70
                                  : Colors
                                      .black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // --------------------------------------------------
              // VACUNA
              // --------------------------------------------------

              Text(
                T.txt(
                  widget
                      .dose
                      .nameKey,
                ),

                style: TextStyle(
                  fontFamily:
                      'Fredoka',

                  fontSize: 28,

                  fontWeight:
                      FontWeight.w800,

                  color: dark
                      ? Colors.white
                      : const Color(
                          0xFF2D2D2D,
                        ),
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                T.txt(
                  widget
                      .dose
                      .doseLabelKey,
                ),

                style:
                    const TextStyle(
                  fontFamily:
                      'Baloo2',

                  fontSize: 16,

                  fontWeight:
                      FontWeight.w600,

                  color:
                      Colors.blue,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                T.txt(
                  widget
                      .dose
                      .preventsKey,
                ),

                style: TextStyle(
                  fontFamily:
                      'Baloo2',

                  fontSize: 14.5,

                  height: 1.25,

                  color: dark
                      ? Colors.white60
                      : Colors.black54,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // --------------------------------------------------
              // FECHA DE APLICACIÓN
              // --------------------------------------------------

              Text(
                T.txt(
                  'vaccineAppliedDate',
                ),

                style:
                    const TextStyle(
                  fontFamily:
                      'Fredoka',

                  fontSize: 17,

                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Material(
                color:
                    Colors.transparent,

                borderRadius:
                    BorderRadius
                        .circular(
                  18,
                ),

                child: InkWell(
                  onTap:
                      _selectDate,

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

                      border:
                          Border.all(
                        color:
                            Colors.blue
                                .withValues(
                          alpha:
                              0.14,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .calendar_month_rounded,

                          color:
                              Colors.blue,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Text(
                            simpleDateText(
                              _appliedDate,
                            ),

                            style:
                                TextStyle(
                              fontFamily:
                                  'Fredoka',

                              fontSize:
                                  16,

                              fontWeight:
                                  FontWeight
                                      .w700,

                              color: dark
                                  ? Colors
                                      .white
                                  : const Color(
                                      0xFF2D2D2D,
                                    ),
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
              ),

              const SizedBox(
                height: 20,
              ),

              // --------------------------------------------------
              // CENTRO DE SALUD
              // --------------------------------------------------

              TextField(
                controller:
                    _healthCenterController,

                textCapitalization:
                    TextCapitalization
                        .words,

                decoration:
                    InputDecoration(
                  labelText:
                      T.txt(
                    'healthCenterOptional',
                  ),

                  prefixIcon:
                      const Icon(
                    Icons
                        .local_hospital_outlined,
                  ),

                  filled: true,

                  fillColor: dark
                      ? const Color(
                          0xFF211B2E,
                        )
                      : Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),

                    borderSide:
                        BorderSide(
                      color: Colors.blue
                          .withValues(
                        alpha:
                            0.10,
                      ),
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),

                    borderSide:
                        const BorderSide(
                      color:
                          Colors.blue,

                      width: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              // --------------------------------------------------
              // NOTAS
              // --------------------------------------------------

              TextField(
                controller:
                    _notesController,

                maxLines: 4,

                textCapitalization:
                    TextCapitalization
                        .sentences,

                decoration:
                    InputDecoration(
                  labelText:
                      T.txt(
                    'notesOptional',
                  ),

                  prefixIcon:
                      const Padding(
                    padding:
                        EdgeInsets.only(
                      bottom: 65,
                    ),

                    child: Icon(
                      Icons
                          .notes_rounded,
                    ),
                  ),

                  filled: true,

                  fillColor: dark
                      ? const Color(
                          0xFF211B2E,
                        )
                      : Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),

                    borderSide:
                        BorderSide(
                      color: Colors
                          .deepPurple
                          .withValues(
                        alpha:
                            0.10,
                      ),
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),

                    borderSide:
                        const BorderSide(
                      color:
                          Color(
                        0xFF7B2CBF,
                      ),

                      width: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // --------------------------------------------------
              // GUARDAR
              // --------------------------------------------------

              SizedBox(
                width:
                    double.infinity,

                height: 57,

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
                        const Color(
                      0xFF7B2CBF,
                    ),

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
                          width: 20,
                          height: 20,

                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2.3,

                            color:
                                Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons
                              .check_circle_rounded,
                        ),

                  label: Text(
                    _editing
                        ? T.txt(
                            'saveChanges',
                          )
                        : T.txt(
                            'saveVaccineRecord',
                          ),

                    style:
                        const TextStyle(
                      fontFamily:
                          'Fredoka',

                      fontSize: 17,

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
    );
  }
}