import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';

import '../../children/data/child_repository.dart';
import '../../children/models/child.dart';

import '../../vaccines/services/vaccine_notification_service.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({
    super.key,
  });

  @override
  State<PrivacyPage> createState() =>
      _PrivacyPageState();
}

class _PrivacyPageState
    extends State<PrivacyPage> {
  bool _deleting = false;

  // ============================================================
  // ELIMINAR TODOS LOS DATOS INFANTILES
  // ============================================================

  Future<void> _deleteAllChildData() async {
    if (_deleting) {
      return;
    }

    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 42,
          ),
          title: Text(
            T.txt(
              'deleteAllChildDataTitle',
            ),
          ),
          content: Text(
            T.txt(
              'deleteAllChildDataQuestion',
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
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    Colors.redAccent,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: Text(
                T.txt(
                  'deleteAllData',
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !mounted) {
      return;
    }

    setState(() {
      _deleting = true;
    });

    try {
      final List<Child> children =
          List<Child>.from(
        ChildRepository
            .instance
            .children
            .value,
      );

      for (final Child child
          in children) {
        // Cancelar recordatorios antes
        // de borrar el perfil.
        await VaccineNotificationService
            .instance
            .cancelForChild(
          child,
        );

        // La base usa ON DELETE CASCADE,
        // por lo que también elimina:
        // - vacunas registradas
        // - controles de crecimiento
        await ChildRepository.instance
            .removeChild(
          child.id,
        );
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            T.txt(
              'allChildDataDeleted',
            ),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            T.txt(
              'deleteAllDataError',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return ValueListenableBuilder<String>(
      valueListenable:
          AppConfig.idioma,
      builder: (
        context,
        idioma,
        _,
      ) {
        final bool dark =
            Theme.of(context)
                    .brightness ==
                Brightness.dark;

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
              T.txt(
                'privacyAndData',
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
            child: ListView(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                20,
                22,
                20,
                40,
              ),
              children: [
                // ================================================
                // ENCABEZADO
                // ================================================

                Container(
                  padding:
                      const EdgeInsets
                          .all(
                    20,
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
                        const Color(
                          0xFF7B2CBF,
                        ).withValues(
                          alpha: dark
                              ? 0.15
                              : 0.07,
                        ),
                      ],
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      25,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFF7B2CBF,
                          ).withValues(
                            alpha:
                                0.13,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            17,
                          ),
                        ),
                        child:
                            const Icon(
                          Icons
                              .shield_outlined,
                          color:
                              Color(
                            0xFF7B2CBF,
                          ),
                          size: 31,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              T.txt(
                                'privacyTitle',
                              ),
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Fredoka',
                                fontSize:
                                    21,
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
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              T.txt(
                                'privacyDescription',
                              ),
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Baloo2',
                                fontSize:
                                    14.5,
                                height:
                                    1.3,
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
                  height: 25,
                ),

                // ================================================
                // ALMACENAMIENTO LOCAL
                // ================================================

                _PrivacyInfoCard(
                  dark: dark,
                  icon:
                      Icons
                          .phone_android_rounded,
                  title: T.txt(
                    'localStorageTitle',
                  ),
                  description: T.txt(
                    'localStorageDescription',
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // ================================================
                // DATOS GUARDADOS
                // ================================================

                _PrivacyInfoCard(
                  dark: dark,
                  icon:
                      Icons
                          .folder_outlined,
                  title: T.txt(
                    'storedDataTitle',
                  ),
                  description: T.txt(
                    'storedDataDescription',
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // ================================================
                // NOTIFICACIONES
                // ================================================

                _PrivacyInfoCard(
                  dark: dark,
                  icon:
                      Icons
                          .notifications_none_rounded,
                  title: T.txt(
                    'notificationPrivacyTitle',
                  ),
                  description: T.txt(
                    'notificationPrivacyDescription',
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                // ================================================
                // ZONA DE DATOS
                // ================================================

                Text(
                  T.txt(
                    'dataManagement',
                  ),
                  style:
                      TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontSize: 21,
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

                const SizedBox(
                  height: 6,
                ),

                Text(
                  T.txt(
                    'dataManagementDescription',
                  ),
                  style:
                      TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize: 14,
                    height: 1.3,
                    color: dark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // ================================================
                // ELIMINAR TODO
                // ================================================

                Container(
                  padding:
                      const EdgeInsets
                          .all(
                    17,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.redAccent
                            .withValues(
                      alpha: dark
                          ? 0.12
                          : 0.06,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      22,
                    ),
                    border:
                        Border.all(
                      color:
                          Colors.redAccent
                              .withValues(
                        alpha:
                            0.20,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons
                                .delete_forever_outlined,
                            color:
                                Colors
                                    .redAccent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              T.txt(
                                'deleteAllChildDataTitle',
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
                                color:
                                    Colors
                                        .redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        T.txt(
                          'deleteAllChildDataDescription',
                        ),
                        style:
                            TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize:
                              14,
                          height:
                              1.3,
                          color: dark
                              ? Colors
                                  .white70
                              : Colors
                                  .black87,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            OutlinedButton
                                .icon(
                          onPressed:
                              _deleting
                                  ? null
                                  : _deleteAllChildData,
                          style:
                              OutlinedButton
                                  .styleFrom(
                            foregroundColor:
                                Colors
                                    .redAccent,
                            side:
                                const BorderSide(
                              color:
                                  Colors
                                      .redAccent,
                            ),
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical:
                                  14,
                            ),
                          ),
                          icon: _deleting
                              ? const SizedBox(
                                  width:
                                      18,
                                  height:
                                      18,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                    color:
                                        Colors
                                            .redAccent,
                                  ),
                                )
                              : const Icon(
                                  Icons
                                      .delete_outline_rounded,
                                ),
                          label: Text(
                            T.txt(
                              'deleteAllData',
                            ),
                            style:
                                const TextStyle(
                              fontFamily:
                                  'Fredoka',
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

                const SizedBox(
                  height: 25,
                ),

                // ================================================
                // AVISO
                // ================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Icon(
                      Icons
                          .info_outline_rounded,
                      size: 19,
                      color:
                          Colors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        T.txt(
                          'privacyFinalNote',
                        ),
                        style:
                            TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize:
                              12.5,
                          height:
                              1.3,
                          color: dark
                              ? Colors
                                  .white54
                              : Colors
                                  .black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
// TARJETA DE INFORMACIÓN
// ================================================================

class _PrivacyInfoCard extends StatelessWidget {
  final bool dark;

  final IconData icon;

  final String title;
  final String description;

  const _PrivacyInfoCard({
    required this.dark,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color color =
        Color(
      0xFF00A896,
    );

    return Container(
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
            BorderRadius.circular(
          21,
        ),
        border:
            Border.all(
          color:
              color.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius
                      .circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color:
                  color,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
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

                const SizedBox(
                  height: 4,
                ),

                Text(
                  description,
                  style:
                      TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize:
                        13.5,
                    height:
                        1.3,
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
    );
  }
}