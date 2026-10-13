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
import '../app/widgets/family_content_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ===============================================================
  // AGREGAR NIÑO
  // ===============================================================

  Future<void> _addChild() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChildFormPage()),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===============================================================
  // PERFIL
  // ===============================================================

  Future<void> _openProfile(Child child) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChildProfilePage(childId: child.id)),
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
      MaterialPageRoute(builder: (_) => const VaccinesPage()),
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
      MaterialPageRoute(builder: (_) => const GrowthPage()),
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
    final List<Child> children = ChildRepository.instance.children.value;

    if (children.isEmpty) {
      await _addChild();
      return;
    }

    final bool dark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF15131A) : const Color(0xFFFAF7F2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: dark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        T.txt('selectChild'),
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: dark ? Colors.white : const Color(0xFF2D2D2D),
                        ),
                      ),
                    ),

                    IconButton(
                      tooltip: T.txt('addChild'),
                      onPressed: () async {
                        Navigator.pop(sheetContext);

                        await _addChild();
                      },
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ValueListenableBuilder<String?>(
                  valueListenable: ChildRepository.instance.selectedChildId,
                  builder: (context, selectedId, _) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: children.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final Child child = children[index];

                        final bool selected = child.id == selectedId;

                        final Color childColor = child.sex == ChildSex.girl
                            ? Colors.pink
                            : Colors.blue;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              await ChildRepository.instance.selectChild(
                                child.id,
                              );

                              if (!sheetContext.mounted) {
                                return;
                              }

                              Navigator.pop(sheetContext);

                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? childColor.withValues(
                                        alpha: dark ? 0.18 : 0.10,
                                      )
                                    : dark
                                    ? const Color(0xFF211B2E)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? childColor
                                      : childColor.withValues(alpha: 0.14),
                                  width: selected ? 1.8 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ChildAvatar(child: child, size: 48),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Fredoka',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: dark
                                                ? Colors.white
                                                : const Color(0xFF2D2D2D),
                                          ),
                                        ),
                                        Text(
                                          childAgeText(child.birthDate),
                                          style: TextStyle(
                                            fontFamily: 'Baloo2',
                                            fontSize: 14,
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
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF00A896),
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
      valueListenable: AppConfig.idioma,
      builder: (context, idiomaActual, _) {
        final bool dark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: dark
              ? const Color(0xFF15131A)
              : const Color(0xFFFAF7F2),

          // =======================================================
          // APP BAR
          // =======================================================
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: dark ? const Color(0xFF211B2E) : Colors.white,
            titleSpacing: 16,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // MASCOTA
                SizedBox(
                  width: 34,
                  height: 34,
                  child: Image.asset(
                    'assets/images/home.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.child_care_rounded,
                        color: Color(0xFF7B2CBF),
                        size: 30,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // WAWA
                Text(
                  'Wawa',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 31,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    color: dark ? Colors.white : const Color(0xFF4A2C82),
                  ),
                ),

                const SizedBox(width: 5),

                // KALÚ COMO IMAGEN
                SizedBox(
                  height: 30,
                  child: Image.asset(
                    'assets/images/logo_kalu.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Kalú',
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          color: dark ? Colors.white : const Color(0xFF4A2C82),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: T.txt('settingsTitle'),
                onPressed: () {
                  showConfigSheet(context);
                },
                icon: const Icon(Icons.settings_rounded),
              ),
            ],
          ),

          // =======================================================
          // CONTENIDO
          // =======================================================
          body: ValueListenableBuilder<List<Child>>(
            valueListenable: ChildRepository.instance.children,
            builder: (context, children, _) {
              if (children.isEmpty) {
                return _EmptyHome(onAdd: _addChild);
              }

              return ValueListenableBuilder<String?>(
                valueListenable: ChildRepository.instance.selectedChildId,
                builder: (context, selectedId, _) {
                  final Child activeChild = selectedId == null
                      ? children.first
                      : ChildRepository.instance.findById(selectedId) ??
                            children.first;

                  return _Dashboard(
                    child: activeChild,
                    dark: dark,
                    onChangeChild: _showChildSelector,
                    onOpenProfile: () {
                      _openProfile(activeChild);
                    },
                    onVaccines: _openVaccines,
                    onGrowth: _openGrowth,
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

  const _HomeHealthData({required this.vaccine, required this.growth});
}

Future<_HomeHealthData> _loadHomeHealthData(Child child) async {
  final List<VaccineEvaluation> vaccines = await VaccineService.instance
      .evaluateChild(child);

  final GrowthMeasurement? growth = await GrowthRepository.instance
      .getLatestMeasurement(child.id);

  return _HomeHealthData(vaccine: _selectHomeVaccine(vaccines), growth: growth);
}

// =================================================================
// SELECCIONAR VACUNA PARA MOSTRAR EN INICIO
// =================================================================

VaccineEvaluation? _selectHomeVaccine(List<VaccineEvaluation> evaluations) {
  final List<VaccineEvaluation> pending = evaluations
      .where(
        (evaluation) =>
            evaluation.status != VaccineStatus.applied &&
            evaluation.status != VaccineStatus.notApplied,
      )
      .toList();

  if (pending.isEmpty) {
    return null;
  }

  // ---------------------------------------------------------------
  // PRIMERO: REQUIERE REVISIÓN
  // ---------------------------------------------------------------

  final List<VaccineEvaluation> review = pending
      .where((evaluation) => evaluation.status == VaccineStatus.review)
      .toList();

  review.sort((a, b) {
    final DateTime aDate = a.expectedDate ?? DateTime(9999);

    final DateTime bDate = b.expectedDate ?? DateTime(9999);

    return aDate.compareTo(bDate);
  });

  if (review.isNotEmpty) {
    return review.first;
  }

  // ---------------------------------------------------------------
  // SEGUNDO: PRÓXIMA
  // ---------------------------------------------------------------

  final List<VaccineEvaluation> upcoming = pending
      .where(
        (evaluation) =>
            evaluation.status == VaccineStatus.upcoming &&
            evaluation.expectedDate != null,
      )
      .toList();

  upcoming.sort((a, b) => a.expectedDate!.compareTo(b.expectedDate!));

  if (upcoming.isNotEmpty) {
    return upcoming.first;
  }

  // ---------------------------------------------------------------
  // TERCERO: ESTACIONAL
  // ---------------------------------------------------------------

  for (final VaccineEvaluation evaluation in pending) {
    if (evaluation.status == VaccineStatus.seasonalReview) {
      return evaluation;
    }
  }

  // ---------------------------------------------------------------
  // CUARTO: ESPERA DOSIS ANTERIOR
  // ---------------------------------------------------------------

  for (final VaccineEvaluation evaluation in pending) {
    if (evaluation.status == VaccineStatus.waitingPreviousDose) {
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

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }

  String _vaccineStatusText(VaccineEvaluation evaluation) {
    switch (evaluation.status) {
      case VaccineStatus.applied:
        return T.txt('vaccineApplied');

      case VaccineStatus.notApplied:
        return T.txt('vaccineNotApplied');

      case VaccineStatus.upcoming:
        return T.txt('vaccineUpcoming');

      case VaccineStatus.review:
        return T.txt('vaccineReview');

      case VaccineStatus.seasonalReview:
        return T.txt('vaccineSeasonalReview');

      case VaccineStatus.waitingPreviousDose:
        return T.txt('vaccineWaitingPrevious');
    }
  }

  String _vaccineSubtitle(VaccineEvaluation? evaluation) {
    if (evaluation == null) {
      return T.txt('homeVaccinesNoPending');
    }

    final String vaccineName = T.txt(evaluation.dose.nameKey);

    final String status = _vaccineStatusText(evaluation);

    final DateTime? date = evaluation.expectedDate;

    if (date == null) {
      return '$vaccineName • $status';
    }

    return '$vaccineName • $status • '
        '${simpleDateText(date)}';
  }

  String _growthSubtitle(GrowthMeasurement? measurement) {
    if (measurement == null) {
      return T.txt('growthDataPending');
    }

    return '${simpleDateText(measurement.measuredAt)} • '
        '${_formatNumber(measurement.weightKg)} kg • '
        '${_formatNumber(measurement.heightCm)} cm';
  }

  @override
  Widget build(BuildContext context) {
    final Color childColor = child.sex == ChildSex.girl
        ? Colors.pink
        : Colors.blue;

    final Future<_HomeHealthData> healthFuture = _loadHomeHealthData(child);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyHero(
              eyebrow: T.txt('homeHeroEyebrow'),
              title: T.txt('homeHeroTitle').replaceAll('{name}', child.name),
              subtitle: T.txt('homeHeroSubtitle'),
              icon: Icons.waving_hand_rounded,
              color: const Color(0xFF6C4CCF),
              accent: const Color(0xFFE77B9F),
            ),

            const SizedBox(height: 22),

            _HomeChildSpotlight(
              child: child,
              dark: dark,
              onChangeChild: onChangeChild,
              onOpenProfile: onOpenProfile,
            ),

            const SizedBox(height: 27),

            // =====================================================
            // RESUMEN DE SALUD
            // =====================================================
            FamilySectionHeading(
              title: T.txt('homeTodayTitle').replaceAll('{name}', child.name),
              subtitle: T.txt('homeTodaySubtitle'),
              icon: Icons.favorite_rounded,
            ),

            const SizedBox(height: 2),

            FutureBuilder<_HomeHealthData>(
              future: healthFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      _DashboardHealthCard(
                        icon: Icons.vaccines_rounded,
                        color: Colors.blue,
                        title: T.txt('nextVaccine'),
                        subtitle: T.txt('homeHealthLoading'),
                        actionText: T.txt('viewVaccines'),
                        dark: dark,
                        onTap: onVaccines,
                      ),

                      const SizedBox(height: 14),

                      _DashboardHealthCard(
                        icon: Icons.show_chart_rounded,
                        color: const Color(0xFF00A896),
                        title: T.txt('lastGrowthCheck'),
                        subtitle: T.txt('homeHealthLoading'),
                        actionText: T.txt('viewGrowth'),
                        dark: dark,
                        onTap: onGrowth,
                      ),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    children: [
                      _DashboardHealthCard(
                        icon: Icons.vaccines_rounded,
                        color: Colors.blue,
                        title: T.txt('nextVaccine'),
                        subtitle: T.txt('homeHealthLoadError'),
                        actionText: T.txt('viewVaccines'),
                        dark: dark,
                        onTap: onVaccines,
                      ),

                      const SizedBox(height: 14),

                      _DashboardHealthCard(
                        icon: Icons.show_chart_rounded,
                        color: const Color(0xFF00A896),
                        title: T.txt('lastGrowthCheck'),
                        subtitle: T.txt('homeHealthLoadError'),
                        actionText: T.txt('viewGrowth'),
                        dark: dark,
                        onTap: onGrowth,
                      ),
                    ],
                  );
                }

                final _HomeHealthData data = snapshot.data!;

                return Column(
                  children: [
                    _DashboardHealthCard(
                      icon: Icons.vaccines_rounded,
                      color: data.vaccine?.status == VaccineStatus.review
                          ? Colors.orange
                          : Colors.blue,
                      title: T.txt('nextVaccine'),
                      subtitle: _vaccineSubtitle(data.vaccine),
                      actionText: T.txt('viewVaccines'),
                      dark: dark,
                      onTap: onVaccines,
                    ),

                    const SizedBox(height: 14),

                    _DashboardHealthCard(
                      icon: Icons.show_chart_rounded,
                      color: const Color(0xFF00A896),
                      title: T.txt('lastGrowthCheck'),
                      subtitle: _growthSubtitle(data.growth),
                      actionText: T.txt('viewGrowth'),
                      dark: dark,
                      onTap: onGrowth,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // =====================================================
            // DATOS PRINCIPALES
            // =====================================================
            FamilySectionHeading(
              title: T.txt('quickSummary'),
              subtitle: T.txt('homeQuickSummarySubtitle'),
              icon: Icons.auto_awesome_rounded,
            ),

            const SizedBox(height: 2),

            Row(
              children: [
                Expanded(
                  child: _SmallInfoCard(
                    icon: Icons.cake_rounded,
                    title: T.txt('birthDate'),
                    value: simpleDateText(child.birthDate),
                    color: Colors.orange,
                    dark: dark,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _SmallInfoCard(
                    icon: Icons.child_care_rounded,
                    title: T.txt('sex'),
                    value: child.sex == ChildSex.girl
                        ? T.txt('girl')
                        : T.txt('boy'),
                    color: childColor,
                    dark: dark,
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

class _HomeChildSpotlight extends StatelessWidget {
  const _HomeChildSpotlight({
    required this.child,
    required this.dark,
    required this.onChangeChild,
    required this.onOpenProfile,
  });

  final Child child;
  final bool dark;
  final VoidCallback onChangeChild;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final Color color = child.sex == ChildSex.girl
        ? const Color(0xFFE85D9C)
        : const Color(0xFF4F7CFF);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            dark ? const Color(0xFF211D2B) : Colors.white,
            color.withValues(alpha: dark ? 0.21 : 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.28), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: dark ? 0.06 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -42,
            right: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 16, 17),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.31),
                            color.withValues(alpha: 0.10),
                          ],
                        ),
                        border: Border.all(
                          color: color.withValues(alpha: 0.28),
                        ),
                      ),
                      child: ChildAvatar(child: child, size: 66),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            child.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 22,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                              color: dark
                                  ? Colors.white
                                  : const Color(0xFF302942),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.cake_outlined,
                                size: 16,
                                color: color,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  childAgeText(child.birthDate),
                                  style: TextStyle(
                                    fontFamily: 'Baloo2',
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: dark
                                        ? Colors.white70
                                        : const Color(0xFF6C6476),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: T.txt('tapToChangeChild'),
                      onPressed: onChangeChild,
                      style: IconButton.styleFrom(
                        backgroundColor:
                            color.withValues(alpha: dark ? 0.19 : 0.10),
                        foregroundColor: color,
                      ),
                      icon: const Icon(Icons.swap_horiz_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: dark ? Colors.white10 : Colors.black12,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        T.txt('homeChildContextText'),
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 13.5,
                          height: 1.25,
                          color:
                              dark ? Colors.white60 : const Color(0xFF6C6476),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: onOpenProfile,
                      style: TextButton.styleFrom(foregroundColor: color),
                      icon: const Icon(Icons.person_outline_rounded, size: 19),
                      label: Text(
                        T.txt('viewProfile'),
                        style: const TextStyle(
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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
// HOME SIN NIÑO
// =================================================================

class _EmptyHome extends StatelessWidget {
  const _EmptyHome({
    required this.onAdd,
  });

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FamilyHero(
                  eyebrow: T.txt('homeHeroEyebrow'),
                  title: T.txt('homeNoChildTitle'),
                  subtitle: T.txt('homeNoChildSubtitle'),
                  icon: Icons.family_restroom_rounded,
                  color: const Color(0xFF6C4CCF),
                  accent: const Color(0xFFE77B9F),
                ),
                const SizedBox(height: 24),
                FamilyNotice(
                  text: T.txt('childrenEmptyDescription'),
                  color: const Color(0xFF7B61C9),
                  icon: Icons.auto_awesome_rounded,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton.icon(
                    onPressed: onAdd,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7B61C9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: Text(
                      T.txt('addFirstChild'),
                      style: const TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
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
}

// =================================================================
// TÍTULO
// =================================================================


// =================================================================
// TARJETA DE SALUD
// =================================================================

class _DashboardHealthCard extends StatelessWidget {
  const _DashboardHealthCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.dark,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String actionText;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FamilyTopicCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      badge: actionText,
      onTap: onTap,
    );
  }
}

// =================================================================
// TARJETA PEQUEÑA
// =================================================================

class _SmallInfoCard extends StatelessWidget {
  const _SmallInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.dark,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            dark ? const Color(0xFF211D2B) : Colors.white,
            color.withValues(alpha: dark ? 0.16 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: dark ? 0.04 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: dark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 11),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: dark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: dark ? Colors.white : const Color(0xFF302942),
            ),
          ),
        ],
      ),
    );
  }
}
