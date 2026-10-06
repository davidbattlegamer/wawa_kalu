import 'package:flutter/material.dart';

import '../../../pages/app_texts.dart';

import '../../growth/pages/growth_page.dart';
import '../../vaccines/pages/vaccines_page.dart';
import '../../vaccines/services/vaccine_notification_service.dart';

import '../data/child_repository.dart';
import '../models/child.dart';
import '../utils/child_display_utils.dart';
import '../widgets/child_avatar.dart';

import 'child_form_page.dart';

class ChildProfilePage extends StatelessWidget {
  final String childId;

  const ChildProfilePage({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Child>>(
      valueListenable:
          ChildRepository.instance.children,
      builder: (
        context,
        children,
        _,
      ) {
        final Child? child =
            ChildRepository.instance.findById(
          childId,
        );

        if (child == null) {
          return Scaffold(
            body: Center(
              child: Text(
                T.txt(
                  'childNotFound',
                ),
              ),
            ),
          );
        }

        return _ChildProfileContent(
          child: child,
        );
      },
    );
  }
}

// =================================================================
// CONTENIDO DEL PERFIL
// =================================================================

class _ChildProfileContent extends StatelessWidget {
  final Child child;

  const _ChildProfileContent({
    required this.child,
  });

  // ===============================================================
  // EDITAR
  // ===============================================================

  Future<void> _edit(
    BuildContext context,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChildFormPage(
          child: child,
        ),
      ),
    );
  }

  // ===============================================================
  // ABRIR VACUNAS
  // ===============================================================

  Future<void> _openVaccines(
    BuildContext context,
  ) async {
    await ChildRepository.instance.selectChild(
      child.id,
    );

    if (!context.mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const VaccinesPage(),
      ),
    );
  }

  // ===============================================================
  // ABRIR CRECIMIENTO
  // ===============================================================

  Future<void> _openGrowth(
    BuildContext context,
  ) async {
    await ChildRepository.instance.selectChild(
      child.id,
    );

    if (!context.mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const GrowthPage(),
      ),
    );
  }

  // ===============================================================
  // ELIMINAR
  // ===============================================================

  Future<void> _delete(
    BuildContext context,
  ) async {
    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title: Text(
            T.txt(
              'deleteChild',
            ),
          ),
          content: Text(
            T.txt(
              'deleteChildConfirmation',
            ).replaceAll(
              '{name}',
              child.name,
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
                foregroundColor:
                    Colors.white,
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
        !context.mounted) {
      return;
    }

    bool notificationsCancelled =
        false;

    try {
      // -----------------------------------------------------------
      // CANCELAR TODAS LAS NOTIFICACIONES DE ESTE NIÑO
      // -----------------------------------------------------------

      await VaccineNotificationService
          .instance
          .cancelForChild(
        child,
      );

      notificationsCancelled =
          true;

      // -----------------------------------------------------------
      // ELIMINAR PERFIL
      //
      // La base elimina por cascada vacunas y crecimiento.
      // ChildRepository elimina también la fotografía.
      // -----------------------------------------------------------

      await ChildRepository.instance
          .removeChild(
        child.id,
      );
    } catch (e) {
      // Si las notificaciones se alcanzaron a cancelar
      // pero falló la eliminación del perfil,
      // intentamos restaurarlas.
      if (notificationsCancelled) {
        try {
          await VaccineNotificationService
              .instance
              .rescheduleForChild(
            child,
          );
        } catch (_) {
          // No ocultamos el error principal.
        }
      }

      debugPrint(
        'Error eliminando perfil infantil: $e',
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            T.txt(
              'deleteChildError',
            ),
          ),
        ),
      );

      return;
    }

    if (!context.mounted) {
      return;
    }

    Navigator.pop(
      context,
    );
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color childColor =
        child.sex == ChildSex.girl
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

      // ===========================================================
      // APP BAR
      // ===========================================================

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
          T.txt(
            'childProfile',
          ),
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontWeight:
                FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip:
                T.txt(
              'edit',
            ),
            onPressed: () {
              _edit(
                context,
              );
            },
            icon: const Icon(
              Icons.edit_rounded,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (
              value,
            ) {
              if (value == 'delete') {
                _delete(
                  context,
                );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .delete_outline_rounded,
                      color:
                          Colors.redAccent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      T.txt(
                        'deleteChild',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body:
          ValueListenableBuilder<String?>(
        valueListenable:
            ChildRepository
                .instance
                .selectedChildId,
        builder: (
          context,
          selectedId,
          _,
        ) {
          final bool selected =
              selectedId == child.id;

          return SafeArea(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                36,
              ),
              child: Column(
                children: [
                  // ===============================================
                  // FOTO
                  // ===============================================

                  ChildAvatar(
                    child: child,
                    size: 112,
                    borderWidth: 2.5,
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  // ===============================================
                  // NOMBRE
                  // ===============================================

                  Text(
                    child.name,
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          'Fredoka',
                      fontSize: 29,
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
                    height: 4,
                  ),

                  Text(
                    childAgeText(
                      child.birthDate,
                    ),
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          'Baloo2',
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w500,
                      color: dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ===============================================
                  // NIÑO ACTIVO
                  // ===============================================

                  if (!selected)
                    SizedBox(
                      width:
                          double.infinity,
                      height: 52,
                      child:
                          OutlinedButton.icon(
                        onPressed:
                            () async {
                          await ChildRepository
                              .instance
                              .selectChild(
                            child.id,
                          );
                        },
                        style:
                            OutlinedButton
                                .styleFrom(
                          foregroundColor:
                              const Color(
                            0xFF7B2CBF,
                          ),
                          side:
                              const BorderSide(
                            color: Color(
                              0xFF7B2CBF,
                            ),
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons
                              .check_circle_outline_rounded,
                        ),
                        label: Text(
                          T.txt(
                            'selectThisChild',
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
                    )
                  else
                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets.all(
                        13,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFF00A896,
                        ).withValues(
                          alpha: 0.12,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),
                        border:
                            Border.all(
                          color:
                              const Color(
                            0xFF00A896,
                          ).withValues(
                            alpha: 0.20,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          const Icon(
                            Icons
                                .check_circle_rounded,
                            color:
                                Color(
                              0xFF00A896,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            T.txt(
                              'activeChild',
                            ),
                            style:
                                const TextStyle(
                              fontFamily:
                                  'Fredoka',
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  Color(
                                0xFF00A896,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(
                    height: 22,
                  ),

                  // ===============================================
                  // FECHA DE NACIMIENTO
                  // ===============================================

                  _InfoCard(
                    icon:
                        Icons.cake_outlined,
                    title:
                        T.txt(
                      'birthDate',
                    ),
                    value:
                        simpleDateText(
                      child.birthDate,
                    ),
                    color:
                        Colors.orange,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ===============================================
                  // SEXO
                  // ===============================================

                  _InfoCard(
                    icon:
                        Icons
                            .child_care_rounded,
                    title:
                        T.txt(
                      'sex',
                    ),
                    value: child.sex ==
                            ChildSex.girl
                        ? T.txt(
                            'girl',
                          )
                        : T.txt(
                            'boy',
                          ),
                    color:
                        childColor,
                  ),

                  const SizedBox(
                    height: 26,
                  ),

                  // ===============================================
                  // SALUD
                  // ===============================================

                  Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      T.txt(
                        'childHealth',
                      ),
                      style: TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize: 22,
                        fontWeight:
                            FontWeight.w800,
                        color: dark
                            ? Colors.white
                            : const Color(
                                0xFF4A2C82,
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ===============================================
                  // VACUNAS
                  // ===============================================

                  _HealthCard(
                    icon:
                        Icons
                            .vaccines_rounded,
                    title:
                        T.txt(
                      'vaccines',
                    ),
                    subtitle:
                        T.txt(
                      'vaccinesSubtitle',
                    ),
                    color:
                        Colors.blue,
                    onTap: () {
                      _openVaccines(
                        context,
                      );
                    },
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ===============================================
                  // CRECIMIENTO
                  // ===============================================

                  _HealthCard(
                    icon:
                        Icons
                            .show_chart_rounded,
                    title:
                        T.txt(
                      'growth',
                    ),
                    subtitle:
                        T.txt(
                      'growthSubtitle',
                    ),
                    color:
                        const Color(
                      0xFF00A896,
                    ),
                    onTap: () {
                      _openGrowth(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =================================================================
// TARJETA DE INFORMACIÓN
// =================================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            dark
                ? const Color(
                    0xFF211B2E,
                  )
                : Colors.white,
            color.withValues(
              alpha:
                  dark ? 0.12 : 0.06,
            ),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: color.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:
                BoxDecoration(
              color: color.withValues(
                alpha: 0.13,
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 27,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize: 14,
                    color: dark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w700,
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
        ],
      ),
    );
  }
}

// =================================================================
// TARJETA DE SALUD
// =================================================================

class _HealthCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _HealthCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Material(
      color:
          Colors.transparent,
      borderRadius:
          BorderRadius.circular(
        20,
      ),
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          20,
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
            gradient:
                LinearGradient(
              colors: [
                dark
                    ? const Color(
                        0xFF211B2E,
                      )
                    : Colors.white,
                color.withValues(
                  alpha:
                      dark
                          ? 0.16
                          : 0.08,
                ),
              ],
            ),
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            border:
                Border.all(
              color:
                  color.withValues(
                alpha:
                    0.13,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(
                  color:
                      color.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    16,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                      color,
                  size: 28,
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
                      title,
                      style:
                          TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize:
                            17,
                        fontWeight:
                            FontWeight.w700,
                        color: dark
                            ? Colors.white
                            : const Color(
                                0xFF2D2D2D,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      subtitle,
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize:
                            14,
                        height:
                            1.15,
                        color: dark
                            ? Colors.white60
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons
                    .chevron_right_rounded,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}