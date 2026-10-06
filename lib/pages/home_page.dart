import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_texts.dart';
import 'widgets/config_sheet.dart';

import '../features/children/data/child_repository.dart';
import '../features/children/models/child.dart';
import '../features/children/pages/child_form_page.dart';
import '../features/children/pages/child_profile_page.dart';
import '../features/children/utils/child_display_utils.dart';
import '../features/children/widgets/child_avatar.dart';

import '../features/growth/data/growth_repository.dart';
import '../features/growth/models/growth_measurement.dart';
import '../features/growth/pages/growth_page.dart';

import '../features/vaccines/pages/vaccines_page.dart';
import '../features/vaccines/services/vaccine_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ===============================================================
  // AGREGAR NIÑO
  // ===============================================================

  Future<void> _addChild() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ChildFormPage(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===============================================================
  // PERFIL
  // ===============================================================

  Future<void> _openProfile(
    Child child,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChildProfilePage(
          childId: child.id,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===============================================================
  // VACUNAS
  // ===============================================================

  Future<void> _openVaccines() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const VaccinesPage(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===============================================================
  // CRECIMIENTO
  // ===============================================================

  Future<void> _openGrowth() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const GrowthPage(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===============================================================
  // SELECTOR DE NIÑO
  // ===============================================================

  Future<void> _showChildSelector() async {
    final List<Child> children =
        ChildRepository
            .instance
            .children
            .value;

    if (children.isEmpty) {
      await _addChild();
      return;
    }

    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (
        sheetContext,
      ) {
        return Container(
          decoration:
              BoxDecoration(
            color: dark
                ? const Color(
                    0xFF15131A,
                  )
                : const Color(
                    0xFFFAF7F2,
                  ),
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(
                28,
              ),
            ),
          ),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            14,
            20,
            30,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 5,
                  decoration:
                      BoxDecoration(
                    color: dark
                        ? Colors.white24
                        : Colors.black12,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        T.txt(
                          'selectChild',
                        ),
                        style:
                            TextStyle(
                          fontFamily:
                              'Fredoka',
                          fontSize: 23,
                          fontWeight:
                              FontWeight.w800,
                          color: dark
                              ? Colors.white
                              : const Color(
                                  0xFF2D2D2D,
                                ),
                        ),
                      ),
                    ),

                    IconButton(
                      tooltip:
                          T.txt(
                        'addChild',
                      ),
                      onPressed:
                          () async {
                        Navigator.pop(
                          sheetContext,
                        );

                        await _addChild();
                      },
                      icon: const Icon(
                        Icons
                            .person_add_alt_1_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

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
                    return ListView.separated(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          children.length,
                      separatorBuilder:
                          (
                        _,
                        __,
                      ) =>
                              const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final Child child =
                            children[index];

                        final bool selected =
                            child.id ==
                                selectedId;

                        final Color childColor =
                            child.sex ==
                                    ChildSex.girl
                                ? Colors.pink
                                : Colors.blue;

                        return Material(
                          color:
                              Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                            onTap:
                                () async {
                              await ChildRepository
                                  .instance
                                  .selectChild(
                                child.id,
                              );

                              if (!sheetContext
                                  .mounted) {
                                return;
                              }

                              Navigator.pop(
                                sheetContext,
                              );

                              if (mounted) {
                                setState(
                                  () {},
                                );
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.all(
                                14,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: selected
                                    ? childColor.withValues(
                                        alpha: dark
                                            ? 0.18
                                            : 0.10,
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
                                      ? childColor
                                      : childColor
                                          .withValues(
                                          alpha:
                                              0.14,
                                        ),
                                  width:
                                      selected
                                          ? 1.8
                                          : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ChildAvatar(
                                    child:
                                        child,
                                    size:
                                        48,
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
                                          child.name,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                          style:
                                              TextStyle(
                                            fontFamily:
                                                'Fredoka',
                                            fontSize:
                                                17,
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
                                        Text(
                                          childAgeText(
                                            child.birthDate,
                                          ),
                                          style:
                                              TextStyle(
                                            fontFamily:
                                                'Baloo2',
                                            fontSize:
                                                14,
                                            color: dark
                                                ? Colors.white60
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (selected)
                                    const Icon(
                                      Icons
                                          .check_circle_rounded,
                                      color:
                                          Color(
                                        0xFF00A896,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable:
          AppConfig.idioma,
      builder: (
        context,
        idiomaActual,
        _,
      ) {
        final bool dark =
            Theme.of(context).brightness ==
                Brightness.dark;

        return Scaffold(
          backgroundColor: dark
              ? const Color(
                  0xFF15131A,
                )
              : const Color(
                  0xFFFAF7F2,
                ),

          // =======================================================
          // APP BAR
          // =======================================================

          appBar: AppBar(
            automaticallyImplyLeading:
                false,
            elevation: 0,
            backgroundColor: dark
                ? const Color(
                    0xFF211B2E,
                  )
                : Colors.white,
            titleSpacing: 16,
            title: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/home.png',
                  width: 39,
                  height: 39,
                  fit: BoxFit.contain,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const Icon(
                      Icons
                          .child_care_rounded,
                      color:
                          Color(
                        0xFF7B2CBF,
                      ),
                      size: 34,
                    );
                  },
                ),

                const SizedBox(
                  width: 9,
                ),

                Flexible(
                  child: Text(
                    T.txt(
                      'appName',
                    ),
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      fontFamily:
                          'Fredoka',
                      fontSize: 24,
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
              ],
            ),
            actions: [
              IconButton(
                tooltip:
                    T.txt(
                  'settingsTitle',
                ),
                onPressed: () {
                  showConfigSheet(
                    context,
                  );
                },
                icon: const Icon(
                  Icons
                      .settings_rounded,
                ),
              ),
            ],
          ),

          // =======================================================
          // CONTENIDO
          // =======================================================

          body:
              ValueListenableBuilder<List<Child>>(
            valueListenable:
                ChildRepository
                    .instance
                    .children,
            builder: (
              context,
              children,
              _,
            ) {
              if (children.isEmpty) {
                return _EmptyHome(
                  dark: dark,
                  onAdd:
                      _addChild,
                );
              }

              return ValueListenableBuilder<String?>(
                valueListenable:
                    ChildRepository
                        .instance
                        .selectedChildId,
                builder: (
                  context,
                  selectedId,
                  _,
                ) {
                  final Child activeChild =
                      selectedId == null
                          ? children.first
                          : ChildRepository
                                  .instance
                                  .findById(
                                selectedId,
                              ) ??
                              children.first;

                  return _Dashboard(
                    child:
                        activeChild,
                    dark:
                        dark,
                    onChangeChild:
                        _showChildSelector,
                    onOpenProfile:
                        () {
                      _openProfile(
                        activeChild,
                      );
                    },
                    onVaccines:
                        _openVaccines,
                    onGrowth:
                        _openGrowth,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

// =================================================================
// DATOS DEL DASHBOARD
// =================================================================

class _HomeHealthData {
  final VaccineEvaluation? vaccine;

  final GrowthMeasurement? growth;

  const _HomeHealthData({
    required this.vaccine,
    required this.growth,
  });
}

Future<_HomeHealthData> _loadHomeHealthData(
  Child child,
) async {
  final List<VaccineEvaluation> vaccines =
      await VaccineService.instance
          .evaluateChild(
    child,
  );

  final GrowthMeasurement? growth =
      await GrowthRepository.instance
          .getLatestMeasurement(
    child.id,
  );

  return _HomeHealthData(
    vaccine:
        _selectHomeVaccine(
      vaccines,
    ),
    growth:
        growth,
  );
}

// =================================================================
// SELECCIONAR VACUNA PARA MOSTRAR EN INICIO
// =================================================================

VaccineEvaluation? _selectHomeVaccine(
  List<VaccineEvaluation> evaluations,
) {
  final List<VaccineEvaluation> pending =
      evaluations
          .where(
            (
              evaluation,
            ) =>
                evaluation.status !=
                VaccineStatus.applied,
          )
          .toList();

  if (pending.isEmpty) {
    return null;
  }

  // ---------------------------------------------------------------
  // PRIMERO: DOSIS CUYA FECHA YA PASÓ Y REQUIEREN REVISIÓN
  // ---------------------------------------------------------------

  final List<VaccineEvaluation> review =
      pending
          .where(
            (
              evaluation,
            ) =>
                evaluation.status ==
                VaccineStatus.review,
          )
          .toList();

  review.sort(
    (
      a,
      b,
    ) {
      final DateTime aDate =
          a.expectedDate ??
              DateTime(
                9999,
              );

      final DateTime bDate =
          b.expectedDate ??
              DateTime(
                9999,
              );

      return aDate.compareTo(
        bDate,
      );
    },
  );

  if (review.isNotEmpty) {
    return review.first;
  }

  // ---------------------------------------------------------------
  // SEGUNDO: PRÓXIMA DOSIS CON FECHA
  // ---------------------------------------------------------------

  final List<VaccineEvaluation> upcoming =
      pending
          .where(
            (
              evaluation,
            ) =>
                evaluation.status ==
                    VaccineStatus
                        .upcoming &&
                evaluation.expectedDate !=
                    null,
          )
          .toList();

  upcoming.sort(
    (
      a,
      b,
    ) =>
        a.expectedDate!.compareTo(
      b.expectedDate!,
    ),
  );

  if (upcoming.isNotEmpty) {
    return upcoming.first;
  }

  // ---------------------------------------------------------------
  // TERCERO: ESTACIONAL
  // ---------------------------------------------------------------

  for (final VaccineEvaluation evaluation
      in pending) {
    if (evaluation.status ==
        VaccineStatus.seasonalReview) {
      return evaluation;
    }
  }

  // ---------------------------------------------------------------
  // CUARTO: ESPERA UNA DOSIS ANTERIOR
  // ---------------------------------------------------------------

  for (final VaccineEvaluation evaluation
      in pending) {
    if (evaluation.status ==
        VaccineStatus.waitingPreviousDose) {
      return evaluation;
    }
  }

  return pending.first;
}

// =================================================================
// DASHBOARD
// =================================================================

class _Dashboard extends StatelessWidget {
  final Child child;

  final bool dark;

  final VoidCallback onChangeChild;
  final VoidCallback onOpenProfile;
  final VoidCallback onVaccines;
  final VoidCallback onGrowth;

  const _Dashboard({
    required this.child,
    required this.dark,
    required this.onChangeChild,
    required this.onOpenProfile,
    required this.onVaccines,
    required this.onGrowth,
  });

  String _formatNumber(
    double value,
  ) {
    if (value ==
        value.roundToDouble()) {
      return value.toStringAsFixed(
        0,
      );
    }

    return value.toStringAsFixed(
      1,
    );
  }

  String _vaccineStatusText(
    VaccineEvaluation evaluation,
  ) {
    switch (evaluation.status) {
      case VaccineStatus.applied:
        return T.txt(
          'vaccineApplied',
        );

      case VaccineStatus.upcoming:
        return T.txt(
          'vaccineUpcoming',
        );

      case VaccineStatus.review:
        return T.txt(
          'vaccineReview',
        );

      case VaccineStatus.seasonalReview:
        return T.txt(
          'vaccineSeasonalReview',
        );

      case VaccineStatus.waitingPreviousDose:
        return T.txt(
          'vaccineWaitingPrevious',
        );
    }
  }

  String _vaccineSubtitle(
    VaccineEvaluation? evaluation,
  ) {
    if (evaluation == null) {
      return T.txt(
        'homeVaccinesNoPending',
      );
    }

    final String vaccineName =
        T.txt(
      evaluation.dose.nameKey,
    );

    final String status =
        _vaccineStatusText(
      evaluation,
    );

    final DateTime? date =
        evaluation.expectedDate;

    if (date == null) {
      return '$vaccineName • $status';
    }

    return '$vaccineName • $status • '
        '${simpleDateText(date)}';
  }

  String _growthSubtitle(
    GrowthMeasurement? measurement,
  ) {
    if (measurement == null) {
      return T.txt(
        'growthDataPending',
      );
    }

    return '${simpleDateText(measurement.measuredAt)} • '
        '${_formatNumber(measurement.weightKg)} kg • '
        '${_formatNumber(measurement.heightCm)} cm';
  }

  @override
  Widget build(BuildContext context) {
    final Color childColor =
        child.sex == ChildSex.girl
            ? Colors.pink
            : Colors.blue;

    final Future<_HomeHealthData>
        healthFuture =
        _loadHomeHealthData(
      child,
    );

    return SafeArea(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          110,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =====================================================
            // SALUDO
            // =====================================================

            Text(
              T.txt(
                'homeGreeting',
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
              height: 4,
            ),

            Text(
              T.txt(
                'homeGreetingSubtitle',
              ),
              style: TextStyle(
                fontFamily:
                    'Baloo2',
                fontSize: 16,
                color: dark
                    ? Colors.white60
                    : Colors.black54,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =====================================================
            // NIÑO ACTIVO
            // =====================================================

            Material(
              color:
                  Colors.transparent,
              borderRadius:
                  BorderRadius.circular(
                26,
              ),
              child: InkWell(
                onTap:
                    onChangeChild,
                borderRadius:
                    BorderRadius.circular(
                  26,
                ),
                child: Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    18,
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
                        childColor.withValues(
                          alpha:
                              dark
                                  ? 0.18
                                  : 0.08,
                        ),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      26,
                    ),
                    border:
                        Border.all(
                      color:
                          childColor.withValues(
                        alpha:
                            0.18,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      ChildAvatar(
                        child:
                            child,
                        size: 68,
                        borderWidth:
                            2.2,
                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              child.name,
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Fredoka',
                                fontSize: 23,
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
                              height: 3,
                            ),
                            Text(
                              childAgeText(
                                child.birthDate,
                              ),
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Baloo2',
                                fontSize: 16,
                                color: dark
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              T.txt(
                                'tapToChangeChild',
                              ),
                              style:
                                  const TextStyle(
                                fontFamily:
                                    'Baloo2',
                                fontSize:
                                    12.5,
                                color:
                                    Color(
                                  0xFF7B2CBF,
                                ),
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons
                            .keyboard_arrow_down_rounded,
                        color:
                            Color(
                          0xFF7B2CBF,
                        ),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Align(
              alignment:
                  Alignment.centerRight,
              child:
                  TextButton.icon(
                onPressed:
                    onOpenProfile,
                icon: const Icon(
                  Icons
                      .person_outline_rounded,
                ),
                label: Text(
                  T.txt(
                    'viewProfile',
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            // =====================================================
            // RESUMEN DE SALUD
            // =====================================================

            _SectionTitle(
              title:
                  T.txt(
                'healthSummary',
              ),
              dark:
                  dark,
            ),

            const SizedBox(
              height: 12,
            ),

            FutureBuilder<_HomeHealthData>(
              future:
                  healthFuture,
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Column(
                    children: [
                      _DashboardHealthCard(
                        icon:
                            Icons
                                .vaccines_rounded,
                        color:
                            Colors.blue,
                        title:
                            T.txt(
                          'nextVaccine',
                        ),
                        subtitle:
                            T.txt(
                          'homeHealthLoading',
                        ),
                        actionText:
                            T.txt(
                          'viewVaccines',
                        ),
                        dark:
                            dark,
                        onTap:
                            onVaccines,
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      _DashboardHealthCard(
                        icon:
                            Icons
                                .show_chart_rounded,
                        color:
                            const Color(
                          0xFF00A896,
                        ),
                        title:
                            T.txt(
                          'lastGrowthCheck',
                        ),
                        subtitle:
                            T.txt(
                          'homeHealthLoading',
                        ),
                        actionText:
                            T.txt(
                          'viewGrowth',
                        ),
                        dark:
                            dark,
                        onTap:
                            onGrowth,
                      ),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    children: [
                      _DashboardHealthCard(
                        icon:
                            Icons
                                .vaccines_rounded,
                        color:
                            Colors.blue,
                        title:
                            T.txt(
                          'nextVaccine',
                        ),
                        subtitle:
                            T.txt(
                          'homeHealthLoadError',
                        ),
                        actionText:
                            T.txt(
                          'viewVaccines',
                        ),
                        dark:
                            dark,
                        onTap:
                            onVaccines,
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      _DashboardHealthCard(
                        icon:
                            Icons
                                .show_chart_rounded,
                        color:
                            const Color(
                          0xFF00A896,
                        ),
                        title:
                            T.txt(
                          'lastGrowthCheck',
                        ),
                        subtitle:
                            T.txt(
                          'homeHealthLoadError',
                        ),
                        actionText:
                            T.txt(
                          'viewGrowth',
                        ),
                        dark:
                            dark,
                        onTap:
                            onGrowth,
                      ),
                    ],
                  );
                }

                final _HomeHealthData data =
                    snapshot.data!;

                return Column(
                  children: [
                    _DashboardHealthCard(
                      icon:
                          Icons
                              .vaccines_rounded,
                      color: data.vaccine
                                  ?.status ==
                              VaccineStatus.review
                          ? Colors.orange
                          : Colors.blue,
                      title:
                          T.txt(
                        'nextVaccine',
                      ),
                      subtitle:
                          _vaccineSubtitle(
                        data.vaccine,
                      ),
                      actionText:
                          T.txt(
                        'viewVaccines',
                      ),
                      dark:
                          dark,
                      onTap:
                          onVaccines,
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    _DashboardHealthCard(
                      icon:
                          Icons
                              .show_chart_rounded,
                      color:
                          const Color(
                        0xFF00A896,
                      ),
                      title:
                          T.txt(
                        'lastGrowthCheck',
                      ),
                      subtitle:
                          _growthSubtitle(
                        data.growth,
                      ),
                      actionText:
                          T.txt(
                        'viewGrowth',
                      ),
                      dark:
                          dark,
                      onTap:
                          onGrowth,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(
              height: 24,
            ),

            // =====================================================
            // DATOS PRINCIPALES
            // =====================================================

            _SectionTitle(
              title:
                  T.txt(
                'quickSummary',
              ),
              dark:
                  dark,
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      _SmallInfoCard(
                    icon:
                        Icons
                            .cake_rounded,
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
                    dark:
                        dark,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child:
                      _SmallInfoCard(
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
                    dark:
                        dark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// HOME SIN NIÑO
// =================================================================

class _EmptyHome extends StatelessWidget {
  final bool dark;

  final VoidCallback onAdd;

  const _EmptyHome({
    required this.dark,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            24,
          ),
          child: Column(
            children: [
              Container(
                width: 125,
                height: 125,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  gradient:
                      LinearGradient(
                    colors: [
                      const Color(
                        0xFF7B2CBF,
                      ).withValues(
                        alpha: 0.20,
                      ),
                      const Color(
                        0xFFFF006E,
                      ).withValues(
                        alpha: 0.10,
                      ),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons
                      .family_restroom_rounded,
                  size: 65,
                  color:
                      Color(
                    0xFF7B2CBF,
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Text(
                T.txt(
                  'homeNoChildTitle',
                ),
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  fontFamily:
                      'Fredoka',
                  fontSize: 26,
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
                height: 10,
              ),

              Text(
                T.txt(
                  'homeNoChildSubtitle',
                ),
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  fontFamily:
                      'Baloo2',
                  fontSize: 16,
                  height: 1.3,
                  color: dark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              SizedBox(
                width:
                    double.infinity,
                height: 56,
                child:
                    FilledButton.icon(
                  onPressed:
                      onAdd,
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
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add_rounded,
                  ),
                  label: Text(
                    T.txt(
                      'addFirstChild',
                    ),
                    style:
                        const TextStyle(
                      fontFamily:
                          'Fredoka',
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w700,
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

// =================================================================
// TÍTULO
// =================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool dark;

  const _SectionTitle({
    required this.title,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily:
            'Fredoka',
        fontSize: 21,
        fontWeight:
            FontWeight.w800,
        color: dark
            ? Colors.white
            : const Color(
                0xFF4A2C82,
              ),
      ),
    );
  }
}

// =================================================================
// TARJETA DE SALUD
// =================================================================

class _DashboardHealthCard
    extends StatelessWidget {
  final IconData icon;
  final Color color;

  final String title;
  final String subtitle;
  final String actionText;

  final bool dark;

  final VoidCallback onTap;

  const _DashboardHealthCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Colors.transparent,
      borderRadius:
          BorderRadius.circular(
        24,
      ),
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        child: Container(
          width:
              double.infinity,
          padding:
              const EdgeInsets.all(
            17,
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
              24,
            ),
            border:
                Border.all(
              color:
                  color.withValues(
                alpha: 0.15,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration:
                    BoxDecoration(
                  color:
                      color.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
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
                      title,
                      style:
                          TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize: 18,
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
                      height: 3,
                    ),

                    Text(
                      subtitle,
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize: 14,
                        height: 1.25,
                        color: dark
                            ? Colors.white60
                            : Colors.black54,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      actionText,
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons
                    .chevron_right_rounded,
                color: color,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================================
// TARJETA PEQUEÑA
// =================================================================

class _SmallInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool dark;

  const _SmallInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        14,
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
          20,
        ),
        border:
            Border.all(
          color:
              color.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            title,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily:
                  'Baloo2',
              fontSize: 13,
              color: dark
                  ? Colors.white60
                  : Colors.black54,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            value,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize: 15,
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
    );
  }
}