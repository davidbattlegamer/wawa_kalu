import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';

import '../../children/data/child_repository.dart';
import '../../children/models/child.dart';
import '../../children/pages/child_form_page.dart';
import '../../children/utils/child_display_utils.dart';
import '../../children/widgets/child_avatar.dart';

import '../data/growth_repository.dart';
import '../models/growth_measurement.dart';

import 'growth_charts_page.dart';
import 'growth_form_page.dart';

class GrowthPage extends StatefulWidget {
  const GrowthPage({
    super.key,
  });

  @override
  State<GrowthPage> createState() =>
      _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  Future<List<GrowthMeasurement>>? _future;

  String? _loadedChildId;

  // ==========================================================================
  // PREPARAR
  // ==========================================================================

  void _prepare(
    Child child,
  ) {
    if (_loadedChildId == child.id &&
        _future != null) {
      return;
    }

    _loadedChildId = child.id;

    _future = GrowthRepository.instance
        .getMeasurementsForChild(
      child.id,
    );
  }

  // ==========================================================================
  // RECARGAR
  // ==========================================================================

  void _reload(
    Child child,
  ) {
    setState(() {
      _loadedChildId = child.id;

      _future = GrowthRepository.instance
          .getMeasurementsForChild(
        child.id,
      );
    });
  }

  // ==========================================================================
  // AGREGAR CONTROL
  // ==========================================================================

  Future<void> _addMeasurement(
    Child child,
  ) async {
    final bool? changed =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GrowthFormPage(
          child: child,
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

  // ==========================================================================
  // EDITAR CONTROL
  // ==========================================================================

  Future<void> _editMeasurement(
    Child child,
    GrowthMeasurement measurement,
  ) async {
    final bool? changed =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GrowthFormPage(
          child: child,
          measurement: measurement,
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

  // ==========================================================================
  // CURVAS
  // ==========================================================================

  Future<void> _openCharts(
    Child child,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GrowthChartsPage(
          child: child,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    _reload(
      child,
    );
  }

  // ==========================================================================
  // AGREGAR NIÑO
  // ==========================================================================

  Future<void> _addChild() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ChildFormPage(),
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

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

          // ==================================================================
          // APP BAR
          // ==================================================================

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
                'growthPageTitle',
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

          // ==================================================================
          // CONTENIDO
          // ==================================================================

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
                  onAdd:
                      _addChild,
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
                  List<GrowthMeasurement>>(
                future:
                    _future,
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
                              size:
                                  50,
                              color:
                                  Colors.orange,
                            ),

                            const SizedBox(
                              height:
                                  12,
                            ),

                            Text(
                              T.txt(
                                'growthLoadError',
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),

                            const SizedBox(
                              height:
                                  16,
                            ),

                            OutlinedButton.icon(
                              onPressed:
                                  () {
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
                          GrowthMeasurement>
                      measurements =
                      snapshot.data ??
                          <GrowthMeasurement>[];

                  return _GrowthContent(
                    child:
                        child,
                    measurements:
                        measurements,
                    dark:
                        dark,
                    onAdd:
                        () {
                      _addMeasurement(
                        child,
                      );
                    },
                    onEdit:
                        (
                      measurement,
                    ) {
                      _editMeasurement(
                        child,
                        measurement,
                      );
                    },
                    onOpenCharts:
                        () {
                      _openCharts(
                        child,
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

// ============================================================================
// CONTENIDO
// ============================================================================

class _GrowthContent extends StatelessWidget {
  final Child child;

  final List<GrowthMeasurement>
      measurements;

  final bool dark;

  final VoidCallback onAdd;
  final VoidCallback onOpenCharts;

  final void Function(
    GrowthMeasurement measurement,
  ) onEdit;

  const _GrowthContent({
    required this.child,
    required this.measurements,
    required this.dark,
    required this.onAdd,
    required this.onOpenCharts,
    required this.onEdit,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color color =
        Color(
      0xFF00A896,
    );

    final Color childColor =
        child.sex == ChildSex.girl
            ? Colors.pink
            : Colors.blue;

    final GrowthMeasurement? latest =
        measurements.isEmpty
            ? null
            : measurements.first;

    return SafeArea(
      child: ListView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        children: [
          // ==================================================================
          // NIÑO
          // ==================================================================

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
                      ? const Color(
                          0xFF211B2E,
                        )
                      : Colors.white,
                  childColor.withValues(
                    alpha:
                        dark
                            ? 0.16
                            : 0.07,
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
                    childColor.withValues(
                  alpha:
                      0.12,
                ),
              ),
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
                  width:
                      14,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        child.name,
                        maxLines:
                            1,
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
                        height:
                            2,
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

                Container(
                  width:
                      47,
                  height:
                      47,
                  decoration:
                      BoxDecoration(
                    color:
                        color.withValues(
                      alpha:
                          0.12,
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
                        .show_chart_rounded,
                    color:
                        color,
                    size:
                        29,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height:
                24,
          ),

          // ==================================================================
          // ÚLTIMO CONTROL
          // ==================================================================

          Text(
            T.txt(
              'latestGrowthControl',
            ),
            style: TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  22,
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
            height:
                12,
          ),

          if (latest == null)
            _EmptyGrowthCard(
              dark:
                  dark,
            )
          else
            _LatestControlCard(
              measurement:
                  latest,
              dark:
                  dark,
              onTap:
                  () {
                onEdit(
                  latest,
                );
              },
            ),

          const SizedBox(
            height:
                16,
          ),

          // ==================================================================
          // REGISTRAR CONTROL
          // ==================================================================

          SizedBox(
            width:
                double.infinity,
            height:
                55,
            child:
                FilledButton.icon(
              onPressed:
                  onAdd,
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    color,
                foregroundColor:
                    Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    19,
                  ),
                ),
              ),
              icon:
                  const Icon(
                Icons
                    .add_rounded,
              ),
              label: Text(
                T.txt(
                  'registerGrowthControl',
                ),
                style:
                    const TextStyle(
                  fontFamily:
                      'Fredoka',
                  fontSize:
                      17,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(
            height:
                12,
          ),

          // ==================================================================
          // CURVAS
          // ==================================================================

          SizedBox(
            width:
                double.infinity,
            height:
                55,
            child:
                OutlinedButton.icon(
              onPressed:
                  measurements.isEmpty
                      ? null
                      : onOpenCharts,
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    color,
                disabledForegroundColor:
                    Colors.grey,
                side:
                    BorderSide(
                  color: measurements
                          .isEmpty
                      ? Colors.grey
                          .withValues(
                            alpha:
                                0.30,
                          )
                      : color,
                  width:
                      1.5,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    19,
                  ),
                ),
              ),
              icon:
                  const Icon(
                Icons
                    .insert_chart_rounded,
              ),
              label: Text(
                T.txt(
                  'viewGrowthCharts',
                ),
                style:
                    const TextStyle(
                  fontFamily:
                      'Fredoka',
                  fontSize:
                      17,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ),

          if (measurements.isEmpty) ...[
            const SizedBox(
              height:
                  8,
            ),

            Text(
              T.txt(
                'growthChartsNoMeasurementsSubtitle',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
                fontSize:
                    13,
                color: dark
                    ? Colors.white54
                    : Colors.black45,
              ),
            ),
          ],

          const SizedBox(
            height:
                18,
          ),

          // ==================================================================
          // INFORMACIÓN OMS
          // ==================================================================

          Container(
            padding:
                const EdgeInsets.all(
              15,
            ),
            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha:
                    dark
                        ? 0.11
                        : 0.06,
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
                      0.12,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons
                      .info_outline_rounded,
                  color:
                      color,
                ),

                const SizedBox(
                  width:
                      10,
                ),

                Expanded(
                  child: Text(
                    measurements.isEmpty
                        ? T.txt(
                            'growthChartsNextStep',
                          )
                        : T.txt(
                            'whoGrowthReferenceNote',
                          ),
                    style:
                        TextStyle(
                      fontFamily:
                          'Baloo2',
                      fontSize:
                          13.5,
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

          const SizedBox(
            height:
                26,
          ),

          // ==================================================================
          // HISTORIAL
          // ==================================================================

          Text(
            T.txt(
              'growthHistory',
            ),
            style: TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  22,
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
            height:
                12,
          ),

          if (measurements.isEmpty)
            _EmptyHistoryCard(
              dark:
                  dark,
            )
          else
            ...measurements.map(
              (
                GrowthMeasurement measurement,
              ) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom:
                        12,
                  ),
                  child:
                      _HistoryCard(
                    measurement:
                        measurement,
                    dark:
                        dark,
                    onTap:
                        () {
                      onEdit(
                        measurement,
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// ÚLTIMO CONTROL
// ============================================================================

class _LatestControlCard
    extends StatelessWidget {
  final GrowthMeasurement measurement;

  final bool dark;

  final VoidCallback onTap;

  const _LatestControlCard({
    required this.measurement,
    required this.dark,
    required this.onTap,
  });

  String _format(
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

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color color =
        Color(
      0xFF00A896,
    );

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
                alpha:
                    0.12,
              ),
            ),
          ),
          child: Column(
            children: [
              // ==============================================================
              // PESO Y LONGITUD / TALLA
              // ==============================================================

              Row(
                children: [
                  Expanded(
                    child:
                        _ValueBox(
                      icon:
                          Icons
                              .monitor_weight_outlined,
                      label:
                          T.txt(
                        'weight',
                      ),
                      value:
                          '${_format(measurement.weightKg)} kg',
                      dark:
                          dark,
                    ),
                  ),

                  const SizedBox(
                    width:
                        10,
                  ),

                  Expanded(
                    child:
                        _ValueBox(
                      icon:
                          Icons
                              .straighten_rounded,
                      label:
                          T.txt(
                        'lengthOrHeight',
                      ),
                      value:
                          '${_format(measurement.heightCm)} cm',
                      dark:
                          dark,
                    ),
                  ),
                ],
              ),

              // ==============================================================
              // PERÍMETRO CEFÁLICO
              // ==============================================================

              if (measurement
                      .headCircumferenceCm !=
                  null) ...[
                const SizedBox(
                  height:
                      10,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      _ValueBox(
                    icon:
                        Icons
                            .radio_button_unchecked_rounded,
                    label:
                        T.txt(
                      'headCircumference',
                    ),
                    value:
                        '${_format(measurement.headCircumferenceCm!)} cm',
                    dark:
                        dark,
                  ),
                ),
              ],

              const SizedBox(
                height:
                    14,
              ),

              // ==============================================================
              // FECHA
              // ==============================================================

              Row(
                children: [
                  const Icon(
                    Icons
                        .calendar_month_rounded,
                    size:
                        19,
                    color:
                        color,
                  ),

                  const SizedBox(
                    width:
                        7,
                  ),

                  Text(
                    simpleDateText(
                      measurement.measuredAt,
                    ),
                    style:
                        TextStyle(
                      fontFamily:
                          'Fredoka',
                      fontSize:
                          15,
                      fontWeight:
                          FontWeight.w700,
                      color: dark
                          ? Colors.white
                          : const Color(
                              0xFF2D2D2D,
                            ),
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    Icons
                        .edit_outlined,
                    size:
                        20,
                    color: dark
                        ? Colors.white54
                        : Colors.black45,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CUADRO DE VALOR
// ============================================================================

class _ValueBox extends StatelessWidget {
  final IconData icon;

  final String label;
  final String value;

  final bool dark;

  const _ValueBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.dark,
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
      padding:
          const EdgeInsets.all(
        12,
      ),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha:
              0.09,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color:
                color,
          ),

          const SizedBox(
            height:
                5,
          ),

          Text(
            label,
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              fontFamily:
                  'Baloo2',
              fontSize:
                  13,
              color: dark
                  ? Colors.white60
                  : Colors.black54,
            ),
          ),

          const SizedBox(
            height:
                2,
          ),

          Text(
            value,
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  17,
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
    );
  }
}

// ============================================================================
// HISTORIAL
// ============================================================================

class _HistoryCard extends StatelessWidget {
  final GrowthMeasurement measurement;

  final bool dark;

  final VoidCallback onTap;

  const _HistoryCard({
    required this.measurement,
    required this.dark,
    required this.onTap,
  });

  String _format(
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

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color color =
        Color(
      0xFF00A896,
    );

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
          padding:
              const EdgeInsets.all(
            15,
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
                alpha:
                    0.12,
              ),
            ),
          ),
          child: Row(
            children: [
              // ==============================================================
              // ICONO
              // ==============================================================

              Container(
                width:
                    45,
                height:
                    45,
                decoration:
                    BoxDecoration(
                  color:
                      color.withValues(
                    alpha:
                        0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child:
                    const Icon(
                  Icons
                      .show_chart_rounded,
                  color:
                      color,
                ),
              ),

              const SizedBox(
                width:
                    12,
              ),

              // ==============================================================
              // DATOS
              // ==============================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    // ---------------------------------------------------------
                    // FECHA
                    // ---------------------------------------------------------

                    Text(
                      simpleDateText(
                        measurement.measuredAt,
                      ),
                      style:
                          TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize:
                            16,
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
                      height:
                          3,
                    ),

                    // ---------------------------------------------------------
                    // PESO + LONGITUD/TALLA
                    // ---------------------------------------------------------

                    Text(
                      '${_format(measurement.weightKg)} kg • '
                      '${_format(measurement.heightCm)} cm',
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize:
                            14,
                        color: dark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),

                    // ---------------------------------------------------------
                    // PERÍMETRO CEFÁLICO
                    // ---------------------------------------------------------

                    if (measurement
                            .headCircumferenceCm !=
                        null) ...[
                      const SizedBox(
                        height:
                            2,
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons
                                .radio_button_unchecked_rounded,
                            size:
                                15,
                            color:
                                color,
                          ),

                          const SizedBox(
                            width:
                                5,
                          ),

                          Expanded(
                            child: Text(
                              '${T.txt('headCircumference')}: '
                              '${_format(measurement.headCircumferenceCm!)} cm',
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Baloo2',
                                fontSize:
                                    13,
                                fontWeight:
                                    FontWeight.w600,
                                color: dark
                                    ? Colors.white60
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // ---------------------------------------------------------
                    // NOTAS
                    // ---------------------------------------------------------

                    if (measurement.notes !=
                            null &&
                        measurement.notes!
                            .trim()
                            .isNotEmpty) ...[
                      const SizedBox(
                        height:
                            4,
                      ),

                      Text(
                        measurement.notes!,
                        maxLines:
                            2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize:
                              12,
                          color: dark
                              ? Colors.white54
                              : Colors.black45,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width:
                    6,
              ),

              const Icon(
                Icons
                    .chevron_right_rounded,
                color:
                    color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SIN CONTROL
// ============================================================================

class _EmptyGrowthCard
    extends StatelessWidget {
  final bool dark;

  const _EmptyGrowthCard({
    required this.dark,
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
        22,
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
          24,
        ),
        border:
            Border.all(
          color:
              color.withValues(
            alpha:
                0.10,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width:
                70,
            height:
                70,
            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha:
                    0.11,
              ),
              shape:
                  BoxShape.circle,
            ),
            child:
                const Icon(
              Icons
                  .monitor_weight_outlined,
              size:
                  38,
              color:
                  color,
            ),
          ),

          const SizedBox(
            height:
                13,
          ),

          Text(
            T.txt(
              'noGrowthControls',
            ),
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  18,
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
            height:
                6,
          ),

          Text(
            T.txt(
              'noGrowthControlsSubtitle',
            ),
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              fontFamily:
                  'Baloo2',
              fontSize:
                  14,
              height:
                  1.3,
              color: dark
                  ? Colors.white60
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HISTORIAL VACÍO
// ============================================================================

class _EmptyHistoryCard
    extends StatelessWidget {
  final bool dark;

  const _EmptyHistoryCard({
    required this.dark,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        18,
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
      ),
      child: Text(
        T.txt(
          'noGrowthControlsSubtitle',
        ),
        textAlign:
            TextAlign.center,
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
    );
  }
}

// ============================================================================
// SIN NIÑO
// ============================================================================

class _NoChildState
    extends StatelessWidget {
  final bool dark;

  final VoidCallback onAdd;

  const _NoChildState({
    required this.dark,
    required this.onAdd,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          25,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width:
                  110,
              height:
                  110,
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
                    65,
                color:
                    Color(
                  0xFF7B2CBF,
                ),
              ),
            ),

            const SizedBox(
              height:
                  20,
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
                    23,
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
                  8,
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

            const SizedBox(
              height:
                  22,
            ),

            FilledButton.icon(
              onPressed:
                  onAdd,
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF7B2CBF,
                ),
                foregroundColor:
                    Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      22,
                  vertical:
                      14,
                ),
              ),
              icon:
                  const Icon(
                Icons
                    .add_rounded,
              ),
              label: Text(
                T.txt(
                  'addChild',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}