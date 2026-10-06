import 'dart:io';

import 'package:flutter/material.dart';

import '../../../pages/app_texts.dart';

import '../../vaccines/services/vaccine_notification_service.dart';

import '../data/child_repository.dart';
import '../models/child.dart';
import '../services/child_photo_service.dart';
import '../utils/child_display_utils.dart';

class ChildFormPage extends StatefulWidget {
  final Child? child;

  const ChildFormPage({
    super.key,
    this.child,
  });

  @override
  State<ChildFormPage> createState() =>
      _ChildFormPageState();
}

class _ChildFormPageState
    extends State<ChildFormPage> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      _nameController;

  DateTime? _birthDate;

  ChildSex? _sex;

  String? _selectedPhotoPath;

  bool _removeCurrentPhoto =
      false;

  bool _saving =
      false;

  bool get _editing =>
      widget.child != null;

  String? get _previewPhotoPath {
    if (_removeCurrentPhoto) {
      return null;
    }

    if (_selectedPhotoPath != null &&
        _selectedPhotoPath!
            .trim()
            .isNotEmpty) {
      return _selectedPhotoPath;
    }

    return widget.child?.photoPath;
  }

  @override
  void initState() {
    super.initState();

    final Child? child =
        widget.child;

    _nameController =
        TextEditingController(
      text:
          child?.name ?? '',
    );

    _birthDate =
        child?.birthDate;

    _sex =
        child?.sex;
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  // ============================================================
  // FOTO
  // ============================================================

  Future<void> _pickPhoto() async {
    final String? path =
        await ChildPhotoService
            .instance
            .pickPhoto();

    if (path == null ||
        !mounted) {
      return;
    }

    setState(() {
      _selectedPhotoPath =
          path;

      _removeCurrentPhoto =
          false;
    });
  }

  void _removePhoto() {
    setState(() {
      _selectedPhotoPath =
          null;

      _removeCurrentPhoto =
          true;
    });
  }

  Widget _defaultAvatar() {
    final Color color =
        _sex == ChildSex.girl
            ? Colors.pink
            : _sex == ChildSex.boy
                ? Colors.blue
                : const Color(
                    0xFF7B2CBF,
                  );

    return Container(
      color: color.withValues(
        alpha: 0.10,
      ),
      child: Center(
        child: Icon(
          _sex == ChildSex.girl
              ? Icons.face_3_rounded
              : _sex == ChildSex.boy
                  ? Icons.face_6_rounded
                  : Icons
                      .child_care_rounded,
          color: color,
          size: 55,
        ),
      ),
    );
  }

  // ============================================================
  // FECHA DE NACIMIENTO
  // ============================================================

  Future<void>
      _pickBirthDate() async {
    final DateTime now =
        DateTime.now();

    final DateTime firstDate =
        DateTime(
      now.year - 6,
      now.month,
      now.day,
    );

    final DateTime? selected =
        await showDatePicker(
      context: context,
      initialDate:
          _birthDate ?? now,
      firstDate:
          firstDate,
      lastDate:
          now,
      helpText:
          T.txt(
        'selectBirthDate',
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
      _birthDate =
          selected;
    });
  }

  // ============================================================
  // GUARDAR
  // ============================================================

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    final bool valid =
        _formKey.currentState
                ?.validate() ??
            false;

    if (!valid) {
      return;
    }

    if (_birthDate == null) {
      _showMessage(
        T.txt(
          'birthDateRequired',
        ),
      );

      return;
    }

    if (_sex == null) {
      _showMessage(
        T.txt(
          'sexRequired',
        ),
      );

      return;
    }

    setState(() {
      _saving = true;
    });

    String? newlySavedPhoto;

    try {
      final String name =
          _nameController.text
              .trim();

      final String childId =
          widget.child?.id ??
              DateTime.now()
                  .microsecondsSinceEpoch
                  .toString();

      final String?
          previousPhotoPath =
          widget.child?.photoPath;

      String? finalPhotoPath =
          previousPhotoPath;

      if (_removeCurrentPhoto) {
        finalPhotoPath =
            null;
      } else if (_selectedPhotoPath !=
          null) {
        newlySavedPhoto =
            await ChildPhotoService
                .instance
                .savePhoto(
          childId:
              childId,
          sourcePath:
              _selectedPhotoPath!,
        );

        finalPhotoPath =
            newlySavedPhoto;
      }

      final Child child =
          Child(
        id: childId,
        name: name,
        birthDate:
            _birthDate!,
        sex:
            _sex!,
        photoPath:
            finalPhotoPath,
        createdAt:
            widget.child
                    ?.createdAt ??
                DateTime.now(),
      );

      if (_editing) {
        await ChildRepository
            .instance
            .updateChild(
          child,
        );
      } else {
        await ChildRepository
            .instance
            .addChild(
          child,
        );
      }

      if (previousPhotoPath != null &&
          previousPhotoPath !=
              finalPhotoPath) {
        await ChildPhotoService
            .instance
            .deletePhoto(
          previousPhotoPath,
        );
      }

      // Las notificaciones no deben impedir
      // que el perfil sea guardado.
      try {
        await VaccineNotificationService
            .instance
            .rescheduleForChild(
          child,
        );
      } catch (e) {
        debugPrint(
          'No se pudieron reprogramar las vacunas: $e',
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        child,
      );
    } catch (e) {
      // Si copiamos una foto nueva pero el perfil
      // no pudo guardarse, eliminamos la copia.
      if (newlySavedPhoto !=
          null) {
        await ChildPhotoService
            .instance
            .deletePhoto(
          newlySavedPhoto,
        );
      }

      if (!mounted) {
        return;
      }

      _showMessage(
        T.txt(
          'childSaveError',
        ),
      );

      debugPrint(
        'Error guardando perfil: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving =
              false;
        });
      }
    }
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content:
            Text(
          message,
        ),
      ),
    );
  }

  // ============================================================
  // INTERFAZ
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool dark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    final Color avatarColor =
        _sex == ChildSex.girl
            ? Colors.pink
            : _sex == ChildSex.boy
                ? Colors.blue
                : const Color(
                    0xFF7B2CBF,
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
        elevation: 0,
        title: Text(
          _editing
              ? T.txt(
                  'editChild',
                )
              : T.txt(
                  'addChild',
                ),
          style:
              const TextStyle(
            fontFamily:
                'Fredoka',
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets
                  .fromLTRB(
            20,
            22,
            20,
            36,
          ),
          child: Form(
            key:
                _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                // ================================================
                // FOTO
                // ================================================

                Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior:
                            Clip.none,
                        children: [
                          Material(
                            color: Colors
                                .transparent,
                            shape:
                                const CircleBorder(),
                            child:
                                InkWell(
                              customBorder:
                                  const CircleBorder(),
                              onTap:
                                  _pickPhoto,
                              child:
                                  Container(
                                width:
                                    115,
                                height:
                                    115,
                                padding:
                                    const EdgeInsets
                                        .all(
                                  3,
                                ),
                                decoration:
                                    BoxDecoration(
                                  shape:
                                      BoxShape
                                          .circle,
                                  border:
                                      Border.all(
                                    color:
                                        avatarColor
                                            .withValues(
                                      alpha:
                                          0.40,
                                    ),
                                    width:
                                        2,
                                  ),
                                ),
                                child:
                                    ClipOval(
                                  child: _previewPhotoPath !=
                                          null
                                      ? Image.file(
                                          File(
                                            _previewPhotoPath!,
                                          ),
                                          width:
                                              109,
                                          height:
                                              109,
                                          fit:
                                              BoxFit.cover,
                                          errorBuilder:
                                              (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return _defaultAvatar();
                                          },
                                        )
                                      : _defaultAvatar(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -1,
                            bottom: -1,
                            child:
                                Material(
                              color:
                                  const Color(
                                0xFF7B2CBF,
                              ),
                              shape:
                                  const CircleBorder(),
                              child:
                                  InkWell(
                                customBorder:
                                    const CircleBorder(),
                                onTap:
                                    _pickPhoto,
                                child:
                                    const Padding(
                                  padding:
                                      EdgeInsets.all(
                                    10,
                                  ),
                                  child:
                                      Icon(
                                    Icons
                                        .camera_alt_rounded,
                                    color:
                                        Colors.white,
                                    size:
                                        21,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        T.txt(
                          'childPhoto',
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
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        T.txt(
                          'childPhotoOptional',
                        ),
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize:
                              13,
                          color: dark
                              ? Colors
                                  .white54
                              : Colors
                                  .black45,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Wrap(
                        alignment:
                            WrapAlignment
                                .center,
                        children: [
                          TextButton.icon(
                            onPressed:
                                _pickPhoto,
                            icon:
                                const Icon(
                              Icons
                                  .photo_library_outlined,
                            ),
                            label:
                                Text(
                              _previewPhotoPath ==
                                      null
                                  ? T.txt(
                                      'addPhoto',
                                    )
                                  : T.txt(
                                      'changePhoto',
                                    ),
                            ),
                          ),
                          if (_previewPhotoPath !=
                              null)
                            TextButton.icon(
                              onPressed:
                                  _removePhoto,
                              style:
                                  TextButton
                                      .styleFrom(
                                foregroundColor:
                                    Colors
                                        .redAccent,
                              ),
                              icon:
                                  const Icon(
                                Icons
                                    .delete_outline_rounded,
                              ),
                              label:
                                  Text(
                                T.txt(
                                  'removePhoto',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ================================================
                // NOMBRE
                // ================================================

                _SectionLabel(
                  text:
                      T.txt(
                    'childName',
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(
                  controller:
                      _nameController,
                  textCapitalization:
                      TextCapitalization
                          .words,
                  decoration:
                      _inputDecoration(
                    context,
                    hint:
                        T.txt(
                      'childNameHint',
                    ),
                    icon:
                        Icons
                            .badge_outlined,
                  ),
                  validator: (
                    value,
                  ) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return T.txt(
                        'childNameRequired',
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 24,
                ),

                // ================================================
                // FECHA
                // ================================================

                _SectionLabel(
                  text:
                      T.txt(
                    'birthDate',
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
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                    onTap:
                        _pickBirthDate,
                    child:
                        InputDecorator(
                      decoration:
                          _inputDecoration(
                        context,
                        hint:
                            '',
                        icon:
                            Icons
                                .calendar_month_rounded,
                      ),
                      child:
                          Row(
                        children: [
                          Expanded(
                            child:
                                Text(
                              _birthDate ==
                                      null
                                  ? T.txt(
                                      'selectDate',
                                    )
                                  : simpleDateText(
                                      _birthDate!,
                                    ),
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Baloo2',
                                fontSize:
                                    16,
                                color: _birthDate ==
                                        null
                                    ? Colors.grey
                                    : dark
                                        ? Colors.white
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
                  height: 24,
                ),

                // ================================================
                // SEXO
                // ================================================

                _SectionLabel(
                  text:
                      T.txt(
                    'sexForGrowthCurves',
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  T.txt(
                    'sexForGrowthCurvesDescription',
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
                  height: 12,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          _SexCard(
                        icon:
                            Icons
                                .face_6_rounded,
                        label:
                            T.txt(
                          'boy',
                        ),
                        selected:
                            _sex ==
                                ChildSex
                                    .boy,
                        color:
                            Colors.blue,
                        onTap:
                            () {
                          setState(
                            () {
                              _sex =
                                  ChildSex
                                      .boy;
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child:
                          _SexCard(
                        icon:
                            Icons
                                .face_3_rounded,
                        label:
                            T.txt(
                          'girl',
                        ),
                        selected:
                            _sex ==
                                ChildSex
                                    .girl,
                        color:
                            Colors.pink,
                        onTap:
                            () {
                          setState(
                            () {
                              _sex =
                                  ChildSex
                                      .girl;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 34,
                ),

                // ================================================
                // GUARDAR
                // ================================================

                SizedBox(
                  width:
                      double.infinity,
                  height:
                      58,
                  child:
                      FilledButton(
                    onPressed:
                        _saving
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
                    child: _saving
                        ? const SizedBox(
                            width:
                                22,
                            height:
                                22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.4,
                              color:
                                  Colors.white,
                            ),
                          )
                        : Text(
                            _editing
                                ? T.txt(
                                    'saveChanges',
                                  )
                                : T.txt(
                                    'saveChild',
                                  ),
                            style:
                                const TextStyle(
                              fontFamily:
                                  'Fredoka',
                              fontSize:
                                  18,
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

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
  }) {
    final bool dark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    return InputDecoration(
      hintText:
          hint,
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
              Colors.deepPurple
                  .withValues(
            alpha:
                0.12,
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
            0xFF7B2CBF,
          ),
          width:
              1.7,
        ),
      ),
    );
  }
}

class _SectionLabel
    extends StatelessWidget {
  final String text;

  const _SectionLabel({
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      text,
      style:
          TextStyle(
        fontFamily:
            'Fredoka',
        fontSize:
            17,
        fontWeight:
            FontWeight.w700,
        color:
            Theme.of(context)
                        .brightness ==
                    Brightness.dark
                ? Colors.white
                : const Color(
                    0xFF2D2D2D,
                  ),
      ),
    );
  }
}

class _SexCard
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _SexCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool dark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    return Material(
      color:
          Colors.transparent,
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        child:
            AnimatedContainer(
          duration:
              const Duration(
            milliseconds:
                200,
          ),
          padding:
              const EdgeInsets
                  .symmetric(
            vertical:
                18,
            horizontal:
                10,
          ),
          decoration:
              BoxDecoration(
            color: selected
                ? color.withValues(
                    alpha: dark
                        ? 0.24
                        : 0.12,
                  )
                : dark
                    ? const Color(
                        0xFF211B2E,
                      )
                    : Colors.white,
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            border:
                Border.all(
              color: selected
                  ? color
                  : color.withValues(
                      alpha:
                          0.15,
                    ),
              width:
                  selected
                      ? 2
                      : 1.2,
            ),
          ),
          child:
              Column(
            children: [
              Icon(
                icon,
                color:
                    color,
                size:
                    37,
              ),
              const SizedBox(
                height:
                    7,
              ),
              Text(
                label,
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
                      ? Colors.white
                      : const Color(
                          0xFF2D2D2D,
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