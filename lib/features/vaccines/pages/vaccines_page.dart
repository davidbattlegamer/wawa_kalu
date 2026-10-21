import 'package:flutter/material.dart';

import '../../../core/notifications/notification_service.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';
import '../../../app/widgets/family_content_ui.dart';

import '../../children/data/child_repository.dart';
import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';
import '../../children/widgets/child_avatar.dart';

import '../models/vaccine_record.dart';

import '../services/vaccine_notification_service.dart';
import '../services/vaccine_service.dart';

import 'vaccine_form_page.dart';

class VaccinesPage extends StatefulWidget {
  const VaccinesPage({
    super.key,
  });

  @override
  State<VaccinesPage> createState() =>
      _VaccinesPageState();
}

class _VaccinesPageState
    extends State<VaccinesPage> {
  Future<List<VaccineEvaluation>>? _future;

  String? _loadedChildId;

  bool _remindersEnabled = false;
  bool _loadingReminders = true;
  int _reminderIntervalDays = 0;

  @override
  void initState() {
    super.initState();

    _loadReminderState();
  }

  // ============================================================
  // RECORDATORIOS
  // ============================================================

  Future<void> _loadReminderState() async {
    final bool enabled =
        await VaccineNotificationService.instance.isEnabled();
    final int intervalDays =
        await VaccineNotificationService.instance.getReminderIntervalDays();

    if (!mounted) {
      return;
    }

    setState(() {
      _remindersEnabled = enabled;
      _reminderIntervalDays = intervalDays;
      _loadingReminders = false;
    });
  }

  Future<void> _changeReminderInterval(int intervalDays) async {
    if (_loadingReminders || intervalDays == _reminderIntervalDays) return;

    setState(() => _loadingReminders = true);
    try {
      await VaccineNotificationService.instance
          .setReminderIntervalDays(intervalDays);
      if (!mounted) return;
      setState(() {
        _reminderIntervalDays = intervalDays;
        _loadingReminders = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(T.txt('vaccineReminderFrequencyUpdated'))),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingReminders = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(T.txt('vaccineReminderFrequencyError'))),
      );
    }
  }

  Future<void> _changeReminders(
    bool value,
  ) async {
    if (_loadingReminders) {
      return;
    }

    setState(() {
      _loadingReminders = true;
    });

    final bool enabled =
        await VaccineNotificationService
            .instance
            .setEnabled(
      value,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _remindersEnabled = enabled;
      _loadingReminders = false;
    });

    final String message;

    if (enabled) {
      message = T.txt(
        'vaccineRemindersEnabledMessage',
      );
    } else if (value) {
      message = T.txt(
        'notificationPermissionDenied',
      );
    } else {
      message = T.txt(
        'vaccineRemindersDisabledMessage',
      );
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  Future<void> _testNotification() async {
    final bool permission =
        await NotificationService
            .instance
            .requestPermission();

    if (!permission) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            T.txt(
              'notificationPermissionDenied',
            ),
          ),
        ),
      );

      return;
    }

    await NotificationService.instance
        .showTestNotification();
  }

  // ============================================================
  // VACUNAS
  // ============================================================

  void _prepare(
    Child child,
  ) {
    if (_loadedChildId == child.id &&
        _future != null) {
      return;
    }

    _loadedChildId = child.id;

    _future = VaccineService.instance
        .evaluateChild(
      child,
    );
  }

  void _reload(
    Child child,
  ) {
    setState(() {
      _loadedChildId = child.id;

      _future = VaccineService.instance
          .evaluateChild(
        child,
      );
    });
  }

  // ============================================================
  // ABRIR REGISTRO
  // ============================================================

  Future<void> _openRecord(
    Child child,
    VaccineEvaluation evaluation,
  ) async {
    // ----------------------------------------------------------
    // SEGURIDAD:
    // Si falta una dosis anterior, no se abre el formulario.
    // ----------------------------------------------------------

    if (evaluation.status ==
        VaccineStatus.waitingPreviousDose) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            T.txt(
              'vaccineWaitingPrevious',
            ),
          ),
        ),
      );

      return;
    }

    final bool? changed =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            VaccineFormPage(
          child: child,
          dose:
              evaluation.dose,
          record:
              evaluation.record,
        ),
      ),
    );

    if (changed == true &&
        mounted) {
      _reload(
        child,
      );
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
          backgroundColor:
              dark ? FamilyUi.canvasDark : FamilyUi.canvasLight,
          appBar: FamilyUi.appBar(
            context,
            T.txt('vaccinesPageTitle'),
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
              if (selectedId == null) {
                return _NoChildState(
                  dark:
                      dark,
                );
              }

              final Child? child =
                  ChildRepository.instance
                      .findById(
                selectedId,
              );

              if (child == null) {
                return Center(
                  child: Text(
                    T.txt(
                      'childNotFound',
                    ),
                  ),
                );
              }

              _prepare(
                child,
              );

              return FutureBuilder<
                  List<VaccineEvaluation>>(
                future:
                    _future,
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot
                          .connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          24,
                        ),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons
                                  .error_outline_rounded,
                              size: 48,
                              color:
                                  Colors.orange,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              T.txt(
                                'vaccinesLoadError',
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                _reload(
                                  child,
                                );
                              },
                              icon:
                                  const Icon(
                                Icons
                                    .refresh_rounded,
                              ),
                              label: Text(
                                T.txt(
                                  'refresh',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final List<
                          VaccineEvaluation>
                      evaluations =
                      snapshot.data ??
                          <VaccineEvaluation>[];

                  return _VaccinesContent(
                    child:
                        child,
                    evaluations:
                        evaluations,
                    dark:
                        dark,
                    remindersEnabled:
                        _remindersEnabled,
                    reminderIntervalDays: _reminderIntervalDays,
                    onReminderIntervalChanged: _changeReminderInterval,
                    loadingReminders:
                        _loadingReminders,
                    onReminderChanged:
                        _changeReminders,
                    onTestNotification:
                        _testNotification,
                    onOpenRecord:
                        (
                      evaluation,
                    ) {
                      _openRecord(
                        child,
                        evaluation,
                      );
                    },
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

// ================================================================
// CONTENIDO
// ================================================================

class _VaccinesContent
    extends StatelessWidget {
  final Child child;

  final List<VaccineEvaluation> evaluations;

  final bool dark;

  final bool remindersEnabled;
  final int reminderIntervalDays;
  final ValueChanged<int> onReminderIntervalChanged;
  final bool loadingReminders;

  final ValueChanged<bool>
      onReminderChanged;

  final VoidCallback
      onTestNotification;

  final void Function(
    VaccineEvaluation evaluation,
  ) onOpenRecord;

  const _VaccinesContent({
    required this.child,
    required this.evaluations,
    required this.dark,
    required this.remindersEnabled,
    required this.reminderIntervalDays,
    required this.onReminderIntervalChanged,
    required this.loadingReminders,
    required this.onReminderChanged,
    required this.onTestNotification,
    required this.onOpenRecord,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final Color childColor =
        child.sex == ChildSex.girl
            ? Colors.pink
            : Colors.blue;

    return SafeArea(
      child: ListView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          35,
        ),
        children: [
          FamilyHero(
            eyebrow: T.txt('vaccinesVisualHeroEyebrow'),
            title: T.txt('vaccinesVisualHeroTitle'),
            subtitle: T.txt('vaccinesVisualHeroSubtitle')
                .replaceAll('{name}', child.name),
            icon: Icons.vaccines_rounded,
            color: const Color(0xFF4D8DFF),
            accent: const Color(0xFF8B5CF6),
          ),
          const SizedBox(height: 20),

          // ======================================================
          // NIÑO SELECCIONADO
          // ======================================================

          Container(
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
                      ? const Color(0xFF292135)
                      : Color.lerp(Colors.white, childColor, 0.12)!,
                  dark
                      ? Color.lerp(const Color(0xFF332940), childColor, 0.20)!
                      : Color.lerp(Colors.white, childColor, 0.25)!,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                24,
              ),
              border: Border.all(
                color: childColor.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: childColor.withValues(alpha: dark ? 0.05 : 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              children: [
                ChildAvatar(
                  child:
                      child,
                  size:
                      55,
                  borderWidth:
                      2,
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
                              21,
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
                        height: 2,
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
                              15,
                          color: dark
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons
                      .vaccines_rounded,
                  color:
                      Colors.blue,
                  size:
                      31,
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          // ======================================================
          // RECORDATORIOS
          // ======================================================

          _ReminderCard(
            dark:
                dark,
            enabled:
                remindersEnabled,
            intervalDays: reminderIntervalDays,
            onIntervalChanged: onReminderIntervalChanged,
            loading:
                loadingReminders,
            onChanged:
                onReminderChanged,
            onTest:
                onTestNotification,
          ),

          const SizedBox(
            height: 25,
          ),

          FamilySectionHeading(
            title: T.txt('vaccinesScheduleTitle'),
            subtitle: T.txt('vaccinesScheduleSubtitle'),
            icon: Icons.calendar_month_rounded,
          ),

          const SizedBox(height: 12),
          _VaccineProgressSummary(evaluations: evaluations, dark: dark),
          const SizedBox(height: 20),

          // ======================================================
          // LISTA DE VACUNAS
          // ======================================================

          ...evaluations.map(
            (
              VaccineEvaluation evaluation,
            ) {
              final bool locked =
                  evaluation.status ==
                      VaccineStatus
                          .waitingPreviousDose;

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom:
                      13,
                ),
                child: _VaccineCard(
                  evaluation:
                      evaluation,
                  dark:
                      dark,

                  // ------------------------------------------------
                  // SI ESTÁ BLOQUEADA, onTap ES NULL
                  // ------------------------------------------------

                  onTap: locked
                      ? null
                      : () {
                          onOpenRecord(
                            evaluation,
                          );
                        },
                ),
              );
            },
          ),

          const SizedBox(
            height: 10,
          ),

          // ======================================================
          // AVISO
          // ======================================================

          Container(
            padding:
                const EdgeInsets.all(
              16,
            ),
            decoration:
                BoxDecoration(
              color:
                  Colors.blue.withValues(
                alpha:
                    dark
                        ? 0.13
                        : 0.07,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color:
                    Colors.blue.withValues(
                  alpha:
                      0.13,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                const Icon(
                  Icons
                      .health_and_safety_outlined,
                  color:
                      Colors.blue,
                ),

                const SizedBox(
                  width:
                      11,
                ),

                Expanded(
                  child: Text(
                    T.txt(
                      'vaccinesDisclaimer',
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
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _VaccineColorGuide(dark: dark),
        ],
      ),
    );
  }
}

class _VaccineProgressSummary extends StatelessWidget {
  const _VaccineProgressSummary({
    required this.evaluations,
    required this.dark,
  });

  final List<VaccineEvaluation> evaluations;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF4D8DFF);
    final int applied = evaluations
        .where((item) => item.status == VaccineStatus.applied)
        .length;
    final int total = evaluations.length;
    final double progress = total == 0 ? 0 : applied / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [const Color(0xFF29243A), const Color(0xFF30264B)]
              : [
                  Color.lerp(Colors.white, accent, 0.16)!,
                  Color.lerp(Colors.white, const Color(0xFF8B5CF6), 0.23)!,
                ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: accent.withValues(alpha: dark ? 0.25 : 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: dark ? 0.03 : 0.07),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4D8DFF), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.insights_rounded, color: Colors.white),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  T.txt('vaccinesProgressTitle'),
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: FamilyUi.ink(context),
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: accent,
                  fontFamily: 'Fredoka',
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: accent.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            T.txt('vaccinesProgressCount')
                .replaceAll('{applied}', '$applied')
                .replaceAll('{total}', '$total'),
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: FamilyUi.ink(context),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            T.txt('vaccinesProgressSubtitle'),
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 12.5,
              height: 1.25,
              color: FamilyUi.muted(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccineColorGuide extends StatelessWidget {
  const _VaccineColorGuide({
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final items = <_VaccineLegendItem>[
      _VaccineLegendItem(
        color: const Color(0xFF00B894),
        icon: Icons.check_circle_rounded,
        title: T.txt('vaccineApplied'),
        description: T.txt('vaccineColorAppliedDesc'),
      ),
      _VaccineLegendItem(
        color: const Color(0xFFFF5D73),
        icon: Icons.remove_circle_rounded,
        title: T.txt('vaccineNotApplied'),
        description: T.txt('vaccineColorNotAppliedDesc'),
      ),
      _VaccineLegendItem(
        color: const Color(0xFF2F80ED),
        icon: Icons.schedule_rounded,
        title: T.txt('vaccineUpcoming'),
        description: T.txt('vaccineColorUpcomingDesc'),
      ),
      _VaccineLegendItem(
        color: const Color(0xFFFF9F1C),
        icon: Icons.info_rounded,
        title: T.txt('vaccineReview'),
        description: T.txt('vaccineColorReviewDesc'),
      ),
      _VaccineLegendItem(
        color: const Color(0xFF8B5CF6),
        icon: Icons.event_repeat_rounded,
        title: T.txt('vaccineSeasonalReview'),
        description: T.txt('vaccineColorSeasonalDesc'),
      ),
      _VaccineLegendItem(
        color: const Color(0xFF7C8798),
        icon: Icons.lock_rounded,
        title: T.txt('vaccineWaitingPrevious'),
        description: T.txt('vaccineColorWaitingDesc'),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            dark ? const Color(0xFF211D2B) : Colors.white,
            const Color(0xFF4D8DFF).withValues(
              alpha: dark ? 0.08 : 0.04,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF4D8DFF).withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D8DFF).withValues(
              alpha: dark ? 0.035 : 0.07,
            ),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF4D8DFF).withValues(
                    alpha: dark ? 0.16 : 0.09,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.palette_outlined,
                  color: Color(0xFF4D8DFF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      T.txt('vaccineColorsTitle'),
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: FamilyUi.ink(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      T.txt('vaccineColorsSubtitle'),
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 13.5,
                        height: 1.2,
                        color: FamilyUi.muted(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < items.length; i++) ...[
            _VaccineLegendRow(
              item: items[i],
              dark: dark,
            ),
            if (i != items.length - 1)
              Divider(
                height: 14,
                color: dark ? Colors.white10 : Colors.black12,
              ),
          ],
        ],
      ),
    );
  }
}

class _VaccineLegendItem {
  const _VaccineLegendItem({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String description;
}

class _VaccineLegendRow extends StatelessWidget {
  const _VaccineLegendRow({
    required this.item,
    required this.dark,
  });

  final _VaccineLegendItem item;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: dark ? 0.17 : 0.09),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: 19,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: FamilyUi.ink(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.description,
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 13,
                  height: 1.25,
                  color: FamilyUi.muted(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ================================================================
// RECORDATORIOS
// ================================================================

class _ReminderCard
    extends StatelessWidget {
  final bool dark;
  final bool enabled;
  final bool loading;
  final int intervalDays;
  final ValueChanged<int> onIntervalChanged;

  final ValueChanged<bool> onChanged;
  final VoidCallback onTest;

  const _ReminderCard({
    required this.dark,
    required this.enabled,
    required this.loading,
    required this.intervalDays,
    required this.onIntervalChanged,
    required this.onChanged,
    required this.onTest,
  });

  String _intervalLabel(int value) {
    if (value == 0) return T.txt('vaccineReminderFrequencyDefault');
    if (value == 1) return T.txt('vaccineReminderFrequencyDaily');
    return T.txt('vaccineReminderFrequencyEveryDays')
        .replaceAll('{days}', value.toString());
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color color =
        Color(
      0xFF7B2CBF,
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
        gradient:
            LinearGradient(
          colors: [
            dark
                ? const Color(0xFF2D213B)
                : Color.lerp(Colors.white, color, 0.14)!,
            dark
                ? Color.lerp(const Color(0xFF322542), color, 0.20)!
                : Color.lerp(Colors.white, color, 0.24)!,
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: dark ? 0.05 : 0.09),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width:
                    48,
                height:
                    48,
                decoration:
                    BoxDecoration(
                  color:
                      color.withValues(
                    alpha:
                        0.13,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    15,
                  ),
                ),
                child:
                    const Icon(
                  Icons
                      .notifications_active_rounded,
                  color:
                      color,
                ),
              ),

              const SizedBox(
                width:
                    12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      T.txt(
                        'vaccineRemindersTitle',
                      ),
                      style:
                          TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize:
                            17,
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
                      height:
                          2,
                    ),

                    Text(
                      T.txt(
                        'vaccineRemindersSubtitle',
                      ),
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize:
                            13.5,
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

              if (loading)
                const SizedBox(
                  width:
                      24,
                  height:
                      24,
                  child:
                      CircularProgressIndicator(
                    strokeWidth:
                        2.2,
                  ),
                )
              else
                Switch.adaptive(
                  value:
                      enabled,
                  onChanged:
                      onChanged,
                ),
            ],
          ),

          const SizedBox(
            height:
                12,
          ),

          Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets.all(
              11,
            ),
            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha:
                    0.08,
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons
                      .schedule_rounded,
                  size:
                      20,
                  color:
                      color,
                ),

                const SizedBox(
                  width:
                      9,
                ),

                Expanded(
                  child: Text(
                    intervalDays == 0
                        ? T.txt('vaccineRemindersSchedule')
                        : T.txt('vaccineReminderFrequencyRange'),
                    style:
                        TextStyle(
                      fontFamily:
                          'Baloo2',
                      fontSize:
                          13.5,
                      fontWeight:
                          FontWeight
                              .w600,
                      color: dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              T.txt('vaccineReminderFrequencyTitle'),
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: FamilyUi.ink(context),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              T.txt('vaccineReminderFrequencySubtitle'),
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 12.7,
                height: 1.25,
                color: FamilyUi.muted(context),
              ),
            ),
          ),
          const SizedBox(height: 11),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final interval in VaccineNotificationService.allowedIntervals)
                  ChoiceChip(
                    label: Text(_intervalLabel(interval)),
                    selected: intervalDays == interval,
                    onSelected: loading
                        ? null
                        : (selected) {
                            if (selected) onIntervalChanged(interval);
                          },
                    selectedColor: color.withValues(alpha: dark ? 0.27 : 0.13),
                    backgroundColor: dark
                        ? const Color(0xFF292333)
                        : Color.lerp(Colors.white, color, 0.10)!,
                    side: BorderSide(
                      color: intervalDays == interval
                          ? color
                          : color.withValues(alpha: 0.18),
                    ),
                    checkmarkColor: color,
                    labelStyle: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: intervalDays == interval
                          ? color
                          : FamilyUi.ink(context),
                    ),
                  ),
              ],
            ),
          ),

          if (enabled) ...[
            const SizedBox(
              height:
                  12,
            ),
            SizedBox(
              width:
                  double.infinity,
              child:
                  OutlinedButton.icon(
                onPressed:
                    onTest,
                icon:
                    const Icon(
                  Icons
                      .notifications_none_rounded,
                ),
                label: Text(
                  T.txt(
                    'testNotification',
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ================================================================
// TARJETA DE VACUNA
// ================================================================

class _VaccineCard extends StatelessWidget {
  final VaccineEvaluation evaluation;
  final bool dark;
  final VoidCallback? onTap;

  const _VaccineCard({
    required this.evaluation,
    required this.dark,
    required this.onTap,
  });

  String _statusText() {
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

  Color _statusColor() {
    switch (evaluation.status) {
      case VaccineStatus.applied:
        return const Color(0xFF00B894);
      case VaccineStatus.notApplied:
        return const Color(0xFFFF5D73);
      case VaccineStatus.upcoming:
        return const Color(0xFF2F80ED);
      case VaccineStatus.review:
        return const Color(0xFFFF9F1C);
      case VaccineStatus.seasonalReview:
        return const Color(0xFF8B5CF6);
      case VaccineStatus.waitingPreviousDose:
        return const Color(0xFF7C8798);
    }
  }

  IconData _statusIcon() {
    switch (evaluation.status) {
      case VaccineStatus.applied:
        return Icons.check_circle_rounded;
      case VaccineStatus.notApplied:
        return Icons.remove_circle_rounded;
      case VaccineStatus.upcoming:
        return Icons.schedule_rounded;
      case VaccineStatus.review:
        return Icons.info_rounded;
      case VaccineStatus.seasonalReview:
        return Icons.event_repeat_rounded;
      case VaccineStatus.waitingPreviousDose:
        return Icons.lock_rounded;
    }
  }

  int _daysUntil(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final DateTime target = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return target.difference(today).inDays;
  }

  String _dateLabel() {
    if (evaluation.status == VaccineStatus.applied) {
      return T.txt('vaccineAppliedDate');
    }

    if (evaluation.status == VaccineStatus.review) {
      return T.txt('vaccineReferenceDate');
    }

    return T.txt('vaccineExpectedDate');
  }

  String? _remainingText() {
    if (evaluation.status == VaccineStatus.waitingPreviousDose ||
        evaluation.status == VaccineStatus.applied ||
        evaluation.status == VaccineStatus.notApplied) {
      return null;
    }

    final DateTime? date = evaluation.expectedDate;

    if (date == null) {
      return null;
    }

    final int days = _daysUntil(date);

    if (days > 1) {
      return T.txt('vaccineDaysRemaining').replaceAll(
        '{days}',
        days.toString(),
      );
    }

    if (days == 1) {
      return T.txt('vaccineTomorrow');
    }

    if (days == 0) {
      return T.txt('vaccineToday');
    }

    return T.txt('vaccineDatePassed');
  }

  @override
  Widget build(BuildContext context) {
    final bool locked =
        evaluation.status == VaccineStatus.waitingPreviousDose;
    final Color color = _statusColor();
    final VaccineRecord? record = evaluation.record;

    // Las fechas, estados y textos siguen exactamente como los calcula
    // VaccineService. Solo cambia su presentación visual.
    final DateTime? visibleDate =
        evaluation.status == VaccineStatus.applied
            ? record?.appliedDate
            : evaluation.status == VaccineStatus.notApplied
                ? null
                : evaluation.expectedDate;
    final String? remainingText = _remainingText();

    final Color foreground = locked
        ? (dark ? Colors.white60 : const Color(0xFF77717F))
        : FamilyUi.ink(context);
    // Gradientes según el estado: estética alegre como en Aprender.
    final Color gradientStart = dark
        ? Color.lerp(const Color(0xFF292335), color, locked ? 0.06 : 0.15)!
        : Color.lerp(Colors.white, color, locked ? 0.10 : 0.20)!;
    final Color gradientEnd = dark
        ? Color.lerp(const Color(0xFF30263D), color, locked ? 0.10 : 0.28)!
        : Color.lerp(Colors.white, color, locked ? 0.14 : 0.34)!;
    final Color detailColor = dark
        ? Color.lerp(const Color(0xFF332D42), color, 0.12)!
        : Color.lerp(Colors.white, color, 0.13)!;
    final Color statusForeground = switch (evaluation.status) {
      VaccineStatus.applied => const Color(0xFF04392A),
      VaccineStatus.notApplied => const Color(0xFF561125),
      VaccineStatus.upcoming => const Color(0xFF061F43),
      VaccineStatus.review => const Color(0xFF442800),
      VaccineStatus.seasonalReview => Colors.white,
      VaccineStatus.waitingPreviousDose => const Color(0xFF182532),
    };

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStart, gradientEnd],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withValues(alpha: locked ? 0.26 : 0.55),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: dark ? 0.12 : 0.17),
                blurRadius: 19,
                spreadRadius: -2,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado: primero nombre de vacuna y número de dosis.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withValues(alpha: 0.98),
                          color.withValues(alpha: 0.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: dark ? 0.23 : 0.25),
                          blurRadius: 13,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -19,
                            right: -18,
                            child: Container(
                              width: 61,
                              height: 61,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.19),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Icon(
                            _statusIcon(),
                            color: Colors.white,
                            size: 35,
                          ),
                          const Positioned(
                            bottom: 8,
                            right: 8,
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Color(0xFFFFEDAE),
                              size: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          T.txt(evaluation.dose.nameKey),
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontWeight: FontWeight.w800,
                            fontSize: 18.5,
                            height: 1.12,
                            color: foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          T.txt(evaluation.dose.doseLabelKey),
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 13,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: dark
                                ? Colors.white70
                                : const Color(0xFF574D62),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    locked
                        ? Icons.lock_outline_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 17,
                    color: color,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Estado, sin depender únicamente del color.
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11, vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.98),
                          color.withValues(alpha: 0.80),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.15),
                          blurRadius: 7,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(_statusIcon(), color: statusForeground, size: 15),
                        Text(
                          _statusText(),
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 12,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: statusForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Fecha exacta, sin tocar reglas ni cálculos existentes.
              if (visibleDate != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13, vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        detailColor,
                        color.withValues(alpha: dark ? 0.18 : 0.16),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withValues(alpha: dark ? 0.30 : 0.27),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: color, size: 22),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _dateLabel(),
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 11.5,
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                                color: FamilyUi.muted(context),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              simpleDateText(visibleDate),
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (remainingText != null) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      evaluation.status == VaccineStatus.review
                          ? Icons.info_outline_rounded
                          : Icons.schedule_rounded,
                      size: 17,
                      color: color,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        remainingText,
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 13,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Conservar íntegramente la ayuda para "No aplicada".
              if (evaluation.status == VaccineStatus.notApplied) ...[
                const SizedBox(height: 11),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: dark ? 0.17 : 0.07),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: color, size: 18),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          T.txt('vaccineNotAppliedOptionHelp'),
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            height: 1.25,
                            fontSize: 12.7,
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Conservar las notas de cada dosis sin alterar el contenido.
              if (evaluation.dose.notesKey != null &&
                  evaluation.status != VaccineStatus.applied &&
                  evaluation.status != VaccineStatus.notApplied) ...[
                const SizedBox(height: 11),
                Text(
                  T.txt(evaluation.dose.notesKey!),
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 12.8,
                    height: 1.25,
                    color: FamilyUi.muted(context),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NoChildState
    extends StatelessWidget {
  final bool dark;

  const _NoChildState({
    required this.dark,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          25,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width:
                  100,
              height:
                  100,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFF7B2CBF,
                ).withValues(
                  alpha:
                      0.10,
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons
                    .child_care_rounded,
                size:
                    58,
                color:
                    Color(
                  0xFF7B2CBF,
                ),
              ),
            ),

            const SizedBox(
              height:
                  18,
            ),

            Text(
              T.txt(
                'healthProfileRequiredTitle',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Fredoka',
                fontSize:
                    22,
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
              height:
                  7,
            ),

            Text(
              T.txt(
                'healthProfileRequiredSubtitle',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
                fontSize:
                    15,
                color: dark
                    ? Colors.white60
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}