import 'package:flutter/material.dart';

import '../../../core/notifications/notification_service.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';

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

class _VaccinesPageState extends State<VaccinesPage> {
  Future<List<VaccineEvaluation>>? _future;

  String? _loadedChildId;

  bool _remindersEnabled = false;
  bool _loadingReminders = true;

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
        await VaccineNotificationService
            .instance
            .isEnabled();

    if (!mounted) {
      return;
    }

    setState(() {
      _remindersEnabled = enabled;
      _loadingReminders = false;
    });
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

    ScaffoldMessenger.of(context).showSnackBar(
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

      ScaffoldMessenger.of(context).showSnackBar(
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

  Future<void> _openRecord(
    Child child,
    VaccineEvaluation evaluation,
  ) async {
    final bool? changed =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VaccineFormPage(
          child: child,
          dose: evaluation.dose,
          record: evaluation.record,
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
      valueListenable: AppConfig.idioma,
      builder: (
        context,
        idioma,
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
                'vaccinesPageTitle',
              ),
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: ValueListenableBuilder<String?>(
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
                  dark: dark,
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
                future: _future,
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot.connectionState ==
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
                              icon: const Icon(
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

                  final List<VaccineEvaluation>
                      evaluations =
                      snapshot.data ??
                          <VaccineEvaluation>[];

                  return _VaccinesContent(
                    child: child,
                    evaluations:
                        evaluations,
                    dark: dark,
                    remindersEnabled:
                        _remindersEnabled,
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

class _VaccinesContent extends StatelessWidget {
  final Child child;

  final List<VaccineEvaluation> evaluations;

  final bool dark;

  final bool remindersEnabled;
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
          // ======================================================
          // NIÑO SELECCIONADO
          // ======================================================

          Container(
            padding:
                const EdgeInsets.all(
              17,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  dark
                      ? const Color(
                          0xFF211B2E,
                        )
                      : Colors.white,
                  childColor.withValues(
                    alpha:
                        dark ? 0.16 : 0.07,
                  ),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                24,
              ),
              border: Border.all(
                color: childColor.withValues(
                  alpha: 0.16,
                ),
              ),
            ),
            child: Row(
              children: [
                ChildAvatar(
                  child: child,
                  size: 55,
                  borderWidth: 2,
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
                        child.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily:
                              'Fredoka',
                          fontSize: 21,
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
                        height: 2,
                      ),
                      Text(
                        childAgeText(
                          child.birthDate,
                        ),
                        style: TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize: 15,
                          color: dark
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.vaccines_rounded,
                  color: Colors.blue,
                  size: 31,
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
            dark: dark,
            enabled:
                remindersEnabled,
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

          // ======================================================
          // TÍTULO
          // ======================================================

          Text(
            T.txt(
              'vaccinesScheduleTitle',
            ),
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 23,
              fontWeight:
                  FontWeight.w800,
              color: dark
                  ? Colors.white
                  : const Color(
                      0xFF4A2C82,
                    ),
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            T.txt(
              'vaccinesScheduleSubtitle',
            ),
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 14.5,
              color: dark
                  ? Colors.white60
                  : Colors.black54,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          // ======================================================
          // VACUNAS
          // ======================================================

          ...evaluations.map(
            (
              VaccineEvaluation evaluation,
            ) {
              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 13,
                ),
                child: _VaccineCard(
                  evaluation:
                      evaluation,
                  dark: dark,
                  onTap: () {
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
            decoration: BoxDecoration(
              color: Colors.blue.withValues(
                alpha:
                    dark ? 0.13 : 0.07,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color:
                    Colors.blue.withValues(
                  alpha: 0.13,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons
                      .health_and_safety_outlined,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 11,
                ),
                Expanded(
                  child: Text(
                    T.txt(
                      'vaccinesDisclaimer',
                    ),
                    style: TextStyle(
                      fontFamily:
                          'Baloo2',
                      fontSize: 14,
                      height: 1.3,
                      color: dark
                          ? Colors.white70
                          : Colors.black87,
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

// ================================================================
// RECORDATORIOS
// ================================================================

class _ReminderCard extends StatelessWidget {
  final bool dark;
  final bool enabled;
  final bool loading;

  final ValueChanged<bool> onChanged;
  final VoidCallback onTest;

  const _ReminderCard({
    required this.dark,
    required this.enabled,
    required this.loading,
    required this.onChanged,
    required this.onTest,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color color =
        Color(
      0xFF7B2CBF,
    );

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
                  dark ? 0.16 : 0.07,
            ),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color: color.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
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
                child: const Icon(
                  Icons
                      .notifications_active_rounded,
                  color: color,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      T.txt(
                        'vaccineRemindersTitle',
                      ),
                      style: TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize: 17,
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
                      height: 2,
                    ),
                    Text(
                      T.txt(
                        'vaccineRemindersSubtitle',
                      ),
                      style: TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize: 13.5,
                        height: 1.15,
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
                  width: 24,
                  height: 24,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.2,
                  ),
                )
              else
                Switch.adaptive(
                  value: enabled,
                  onChanged:
                      onChanged,
                ),
            ],
          ),

          const SizedBox(
            height: 12,
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
                alpha: 0.08,
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 20,
                  color: color,
                ),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Text(
                    T.txt(
                      'vaccineRemindersSchedule',
                    ),
                    style: TextStyle(
                      fontFamily:
                          'Baloo2',
                      fontSize: 13.5,
                      fontWeight:
                          FontWeight.w600,
                      color: dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (enabled) ...[
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width:
                  double.infinity,
              child:
                  OutlinedButton.icon(
                onPressed:
                    onTest,
                icon: const Icon(
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

  final VoidCallback onTap;

  const _VaccineCard({
    required this.evaluation,
    required this.dark,
    required this.onTap,
  });

  String _statusText() {
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

      case VaccineStatus
            .waitingPreviousDose:
        return T.txt(
          'vaccineWaitingPrevious',
        );
    }
  }

  Color _statusColor() {
    switch (evaluation.status) {
      case VaccineStatus.applied:
        return const Color(
          0xFF00A896,
        );

      case VaccineStatus.upcoming:
        return Colors.blue;

      case VaccineStatus.review:
        return Colors.orange;

      case VaccineStatus.seasonalReview:
        return Colors.deepPurple;

      case VaccineStatus
            .waitingPreviousDose:
        return Colors.grey;
    }
  }

  int _daysUntil(
    DateTime date,
  ) {
    final DateTime now =
        DateTime.now();

    final DateTime today =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime target =
        DateTime(
      date.year,
      date.month,
      date.day,
    );

    return target
        .difference(
          today,
        )
        .inDays;
  }

  String _dateLabel() {
    if (evaluation.status ==
        VaccineStatus.applied) {
      return T.txt(
        'vaccineAppliedDate',
      );
    }

    if (evaluation.status ==
        VaccineStatus.review) {
      return T.txt(
        'vaccineReferenceDate',
      );
    }

    return T.txt(
      'vaccineExpectedDate',
    );
  }

  String? _remainingText() {
    final DateTime? date =
        evaluation.expectedDate;

    if (date == null ||
        evaluation.status ==
            VaccineStatus.applied) {
      return null;
    }

    final int days =
        _daysUntil(
      date,
    );

    if (days > 1) {
      return T.txt(
        'vaccineDaysRemaining',
      ).replaceAll(
        '{days}',
        days.toString(),
      );
    }

    if (days == 1) {
      return T.txt(
        'vaccineTomorrow',
      );
    }

    if (days == 0) {
      return T.txt(
        'vaccineToday',
      );
    }

    return T.txt(
      'vaccineDatePassed',
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final Color color =
        _statusColor();

    final VaccineRecord? record =
        evaluation.record;

    final DateTime? visibleDate =
        record?.appliedDate ??
            evaluation.expectedDate;

    final String? remainingText =
        _remainingText();

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
                      dark ? 0.14 : 0.065,
                ),
              ],
            ),
            borderRadius:
                BorderRadius.circular(
              24,
            ),
            border: Border.all(
              color: color.withValues(
                alpha: 0.18,
              ),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(
                  alpha: 0.06,
                ),
                blurRadius: 10,
                offset:
                    const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    BoxDecoration(
                  color: color.withValues(
                    alpha: 0.13,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: Icon(
                  evaluation.status ==
                          VaccineStatus.applied
                      ? Icons
                          .check_circle_rounded
                      : Icons
                          .vaccines_rounded,
                  color: color,
                  size: 29,
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
                      T.txt(
                        evaluation
                            .dose
                            .nameKey,
                      ),
                      style: TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize: 18,
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
                      height: 2,
                    ),

                    Text(
                      T.txt(
                        evaluation
                            .dose
                            .doseLabelKey,
                      ),
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
                      height: 6,
                    ),

                    Text(
                      T.txt(
                        evaluation
                            .dose
                            .preventsKey,
                      ),
                      style: TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize: 13,
                        height: 1.2,
                        color: dark
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    ),

                    const SizedBox(
                      height: 9,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration:
                          BoxDecoration(
                        color: color.withValues(
                          alpha: 0.13,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        _statusText(),
                        style: TextStyle(
                          fontFamily:
                              'Fredoka',
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),

                    if (visibleDate != null) ...[
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        _dateLabel(),
                        style: TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize: 12.5,
                          color: dark
                              ? Colors.white54
                              : Colors.black45,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons
                                .calendar_month_rounded,
                            size: 18,
                            color: color,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            simpleDateText(
                              visibleDate,
                            ),
                            style: TextStyle(
                              fontFamily:
                                  'Fredoka',
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w800,
                              color: dark
                                  ? Colors.white
                                  : const Color(
                                      0xFF2D2D2D,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (remainingText != null) ...[
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(
                            evaluation.status ==
                                    VaccineStatus.review
                                ? Icons
                                    .info_outline_rounded
                                : Icons
                                    .schedule_rounded,
                            size: 17,
                            color: color,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              remainingText,
                              style: TextStyle(
                                fontFamily:
                                    'Baloo2',
                                fontSize: 13.5,
                                fontWeight:
                                    FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (evaluation
                                .dose
                                .notesKey !=
                            null &&
                        evaluation.status !=
                            VaccineStatus.applied) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        T.txt(
                          evaluation
                              .dose
                              .notesKey!,
                        ),
                        style: TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize: 12.5,
                          height: 1.2,
                          color: dark
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width: 5,
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: color,
                size: 27,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SIN NIÑO
// ================================================================

class _NoChildState extends StatelessWidget {
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
              width: 100,
              height: 100,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFF7B2CBF,
                ).withValues(
                  alpha: 0.10,
                ),
                shape:
                    BoxShape.circle,
              ),
              child: const Icon(
                Icons.child_care_rounded,
                size: 58,
                color:
                    Color(
                  0xFF7B2CBF,
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              T.txt(
                'healthProfileRequiredTitle',
              ),
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontFamily:
                    'Fredoka',
                fontSize: 22,
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
              height: 7,
            ),
            Text(
              T.txt(
                'healthProfileRequiredSubtitle',
              ),
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontFamily:
                    'Baloo2',
                fontSize: 15,
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