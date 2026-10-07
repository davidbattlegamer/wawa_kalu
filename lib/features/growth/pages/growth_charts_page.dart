import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';

import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';
import '../../children/widgets/child_avatar.dart';

import '../data/growth_repository.dart';
import '../models/growth_measurement.dart';
import '../models/who_growth_table.dart';
import '../services/who_growth_service.dart';

// ============================================================================
// TIPOS DE GRÁFICA
// ============================================================================

enum _GrowthChartType {
  weightAge,
  heightAge,
  bmiAge,
  headAge,

  // Un solo recuadro.
  //
  // < 731 días:
  // Peso / Longitud
  //
  // >= 731 días:
  // Peso / Talla
  weightLengthHeight,
}

// ============================================================================
// PÁGINA
// ============================================================================

class GrowthChartsPage extends StatefulWidget {
  final Child child;

  const GrowthChartsPage({
    super.key,
    required this.child,
  });

  @override
  State<GrowthChartsPage> createState() =>
      _GrowthChartsPageState();
}

class _GrowthChartsPageState
    extends State<GrowthChartsPage> {
  late Future<List<GrowthMeasurement>>
      _measurementsFuture;

  Future<OfficialWhoGrowthChartData>?
      _officialFuture;

  String? _officialSignature;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _measurementsFuture =
        GrowthRepository.instance
            .getMeasurementsForChild(
      widget.child.id,
    );
  }

  // ==========================================================================
  // RECARGAR
  // ==========================================================================

  Future<void> _reload() async {
    setState(() {
      _officialFuture = null;

      _officialSignature = null;

      _measurementsFuture =
          GrowthRepository.instance
              .getMeasurementsForChild(
        widget.child.id,
      );
    });
  }

  // ==========================================================================
  // PREPARAR DATOS OMS
  // ==========================================================================

  Future<OfficialWhoGrowthChartData>
      _prepareOfficialData(
    List<GrowthMeasurement> measurements,
  ) {
    final String signature =
        measurements
            .map(
              (
                GrowthMeasurement item,
              ) =>
                  '${item.id}|'
                  '${item.measuredAt.toIso8601String()}|'
                  '${item.weightKg}|'
                  '${item.heightCm}|'
                  '${item.headCircumferenceCm}|'
                  '${item.measurementType.name}',
            )
            .join(
              '||',
            );

    if (_officialFuture == null ||
        _officialSignature != signature) {
      _officialSignature =
          signature;

      _officialFuture =
          WhoGrowthService.instance
              .buildOfficial(
        child:
            widget.child,
        measurements:
            measurements,
      );
    }

    return _officialFuture!;
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
          backgroundColor:
              dark
                  ? const Color(
                      0xFF15131A,
                    )
                  : const Color(
                      0xFFFAF7F2,
                    ),

          // ==================================================================
          // APP BAR
          // ==================================================================

          appBar:
              AppBar(
            backgroundColor:
                dark
                    ? const Color(
                        0xFF211B2E,
                      )
                    : Colors.white,
            foregroundColor:
                dark
                    ? Colors.white
                    : const Color(
                        0xFF2D2D2D,
                      ),
            elevation:
                0,
            title:
                Text(
              T.txt(
                'growthChartsTitle',
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
              IconButton(
                tooltip:
                    T.txt(
                  'refresh',
                ),
                onPressed:
                    _reload,
                icon:
                    const Icon(
                  Icons.refresh_rounded,
                ),
              ),
            ],
          ),

          // ==================================================================
          // CONTENIDO
          // ==================================================================

          body:
              FutureBuilder<
                  List<GrowthMeasurement>>(
            future:
                _measurementsFuture,
            builder: (
              context,
              snapshot,
            ) {
              // --------------------------------------------------------------
              // CARGANDO
              // --------------------------------------------------------------

              if (snapshot
                      .connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              // --------------------------------------------------------------
              // ERROR
              // --------------------------------------------------------------

              if (snapshot.hasError) {
                return _LoadError(
                  dark:
                      dark,
                  onRetry:
                      _reload,
                );
              }

              final List<GrowthMeasurement>
                  measurements =
                  snapshot.data ??
                      <GrowthMeasurement>[];

              // --------------------------------------------------------------
              // SIN CONTROLES
              // --------------------------------------------------------------

              if (measurements.isEmpty) {
                return _NoMeasurements(
                  dark:
                      dark,
                );
              }

              // --------------------------------------------------------------
              // DATOS OMS
              // --------------------------------------------------------------

              return FutureBuilder<
                  OfficialWhoGrowthChartData>(
                future:
                    _prepareOfficialData(
                  measurements,
                ),
                builder: (
                  context,
                  officialSnapshot,
                ) {
                  if (officialSnapshot
                          .connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  if (officialSnapshot
                          .hasError ||
                      officialSnapshot.data ==
                          null) {
                    return _LoadError(
                      dark:
                          dark,
                      onRetry:
                          _reload,
                    );
                  }

                  final OfficialWhoGrowthChartData
                      data =
                      officialSnapshot.data!;

                  if (!data.hasAnyData) {
                    return _NoValidMeasurements(
                      dark:
                          dark,
                    );
                  }

                  return _GrowthChartsContent(
                    child:
                        widget.child,
                    data:
                        data,
                    dark:
                        dark,
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

class _GrowthChartsContent
    extends StatefulWidget {
  final Child child;

  final OfficialWhoGrowthChartData data;

  final bool dark;

  const _GrowthChartsContent({
    required this.child,
    required this.data,
    required this.dark,
  });

  @override
  State<_GrowthChartsContent>
      createState() =>
          _GrowthChartsContentState();
}

class _GrowthChartsContentState
    extends State<_GrowthChartsContent> {
  // ==========================================================================
  // SELECCIÓN
  // ==========================================================================

  _GrowthChartType _selected =
      _GrowthChartType.weightAge;

  // ==========================================================================
  // CAMBIO AUTOMÁTICO PESO/LONGITUD -> PESO/TALLA
  // ==========================================================================

  static const int
      _standingHeightFromDay =
      731;

  // ==========================================================================
  // EDAD ACTUAL DEL NIÑO EN DÍAS
  // ==========================================================================

  int get _childAgeDays {
    final DateTime birth =
        DateTime(
      widget.child.birthDate.year,
      widget.child.birthDate.month,
      widget.child.birthDate.day,
    );

    final DateTime now =
        DateTime.now();

    final DateTime today =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    return today
        .difference(
          birth,
        )
        .inDays;
  }

  // ==========================================================================
  // ¿USA PESO PARA TALLA?
  // ==========================================================================

  bool get _usesWeightForHeight =>
      _childAgeDays >=
      _standingHeightFromDay;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _ensureValidSelection();
  }

  // ==========================================================================
  // ACTUALIZACIÓN
  // ==========================================================================

  @override
  void didUpdateWidget(
    covariant _GrowthChartsContent oldWidget,
  ) {
    super.didUpdateWidget(
      oldWidget,
    );

    _ensureValidSelection();
  }

  // ==========================================================================
  // VERIFICAR SELECCIÓN
  // ==========================================================================

  void _ensureValidSelection() {
    if (_isAvailable(
      _selected,
    )) {
      return;
    }

    for (final _GrowthChartType type
        in _GrowthChartType.values) {
      if (_isAvailable(
        type,
      )) {
        _selected =
            type;

        return;
      }
    }
  }

  // ==========================================================================
  // DISPONIBILIDAD
  // ==========================================================================

  bool _isAvailable(
    _GrowthChartType type,
  ) {
    switch (type) {
      // ----------------------------------------------------------------------
      // PESO / EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.weightAge:
        return widget
            .data
            .weightForAge
            .isNotEmpty;

      // ----------------------------------------------------------------------
      // TALLA / EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.heightAge:
        return widget
            .data
            .lengthHeightForAge
            .isNotEmpty;

      // ----------------------------------------------------------------------
      // IMC / EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.bmiAge:
        return widget
            .data
            .bmiForAge
            .isNotEmpty;

      // ----------------------------------------------------------------------
      // CABEZA / EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.headAge:
        return widget
            .data
            .headCircumferenceForAge
            .isNotEmpty;

      // ----------------------------------------------------------------------
      // PESO / LONGITUD O PESO / TALLA
      //
      // NUNCA SE BLOQUEA.
      // ----------------------------------------------------------------------

      case _GrowthChartType
            .weightLengthHeight:
        return true;
    }
  }

  // ==========================================================================
  // LABEL DEL SELECTOR
  // ==========================================================================

  String _selectorLabel(
    _GrowthChartType type,
  ) {
    switch (type) {
      case _GrowthChartType.weightAge:
        return T.txt(
          'growthSelectorWeight',
        );

      case _GrowthChartType.heightAge:
        return T.txt(
          'growthSelectorHeight',
        );

      case _GrowthChartType.bmiAge:
        return T.txt(
          'growthSelectorBmi',
        );

      case _GrowthChartType.headAge:
        return T.txt(
          'growthSelectorHead',
        );

      case _GrowthChartType
            .weightLengthHeight:
        if (_usesWeightForHeight) {
          return T.txt(
            'growthSelectorWeightHeight',
          );
        }

        return T.txt(
          'growthSelectorWeightLength',
        );
    }
  }

  // ==========================================================================
  // ICONO DEL SELECTOR
  // ==========================================================================

  IconData _selectorIcon(
    _GrowthChartType type,
  ) {
    switch (type) {
      case _GrowthChartType.weightAge:
        return Icons
            .monitor_weight_outlined;

      case _GrowthChartType.heightAge:
        return Icons
            .straighten_rounded;

      case _GrowthChartType.bmiAge:
        return Icons
            .analytics_outlined;

      case _GrowthChartType.headAge:
        return Icons
            .radio_button_unchecked_rounded;

      case _GrowthChartType
            .weightLengthHeight:
        if (_usesWeightForHeight) {
          return Icons
              .height_rounded;
        }

        return Icons
            .swap_horiz_rounded;
    }
  }

  // ==========================================================================
  // ESPECIFICACIÓN DE LA GRÁFICA
  // ==========================================================================

  _GrowthChartSpec _chartSpec() {
    switch (_selected) {
      // ----------------------------------------------------------------------
      // PESO / EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.weightAge:
        return _GrowthChartSpec(
          title:
              T.txt(
            'weightForAgeChart',
          ),
          description:
              T.txt(
            'weightForAgeChartDescription',
          ),
          table:
              widget
                  .data
                  .weightForAgeTable,
          points:
              widget
                  .data
                  .weightForAge,
          xLabel:
              T.txt(
            'age',
          ),
          yLabel:
              T.txt(
            'weightKgShort',
          ),
        );

      // ----------------------------------------------------------------------
      // LONGITUD / TALLA PARA LA EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.heightAge:
        return _GrowthChartSpec(
          title:
              T.txt(
            'heightForAgeChart',
          ),
          description:
              T.txt(
            'heightForAgeChartDescription',
          ),
          table:
              widget
                  .data
                  .lengthHeightForAgeTable,
          points:
              widget
                  .data
                  .lengthHeightForAge,
          xLabel:
              T.txt(
            'age',
          ),
          yLabel:
              T.txt(
            'heightCmShort',
          ),
        );

      // ----------------------------------------------------------------------
      // IMC / EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.bmiAge:
        return _GrowthChartSpec(
          title:
              T.txt(
            'bmiForAgeChart',
          ),
          description:
              T.txt(
            'bmiForAgeChartDescription',
          ),
          table:
              widget
                  .data
                  .bmiForAgeTable,
          points:
              widget
                  .data
                  .bmiForAge,
          xLabel:
              T.txt(
            'age',
          ),
          yLabel:
              T.txt(
            'bmiShort',
          ),
        );

      // ----------------------------------------------------------------------
      // PERÍMETRO CEFÁLICO / EDAD
      // ----------------------------------------------------------------------

      case _GrowthChartType.headAge:
        return _GrowthChartSpec(
          title:
              T.txt(
            'headCircumferenceForAgeChart',
          ),
          description:
              T.txt(
            'headCircumferenceForAgeChartDescription',
          ),
          table:
              widget
                  .data
                  .headCircumferenceForAgeTable,
          points:
              widget
                  .data
                  .headCircumferenceForAge,
          xLabel:
              T.txt(
            'age',
          ),
          yLabel:
              T.txt(
            'headCmShort',
          ),
        );

      // ----------------------------------------------------------------------
      // PESO / LONGITUD O PESO / TALLA
      //
      // CAMBIA AUTOMÁTICAMENTE DEPENDIENDO DE LA EDAD ACTUAL DEL NIÑO.
      // ----------------------------------------------------------------------

      case _GrowthChartType
            .weightLengthHeight:
        // --------------------------------------------------------------------
        // DESDE 731 DÍAS:
        // PESO PARA TALLA
        // --------------------------------------------------------------------

        if (_usesWeightForHeight) {
          return _GrowthChartSpec(
            title:
                T.txt(
              'weightForHeightChart',
            ),
            description:
                T.txt(
              'weightForHeightChartDescription',
            ),
            table:
                widget
                    .data
                    .weightForHeightTable,
            points:
                widget
                    .data
                    .weightForHeight,
            xLabel:
                T.txt(
              'heightCmShort',
            ),
            yLabel:
                T.txt(
              'weightKgShort',
            ),
          );
        }

        // --------------------------------------------------------------------
        // MENOR DE 731 DÍAS:
        // PESO PARA LONGITUD
        // --------------------------------------------------------------------

        return _GrowthChartSpec(
          title:
              T.txt(
            'weightForLengthChart',
          ),
          description:
              T.txt(
            'weightForLengthChartDescription',
          ),
          table:
              widget
                  .data
                  .weightForLengthTable,
          points:
              widget
                  .data
                  .weightForLength,
          xLabel:
              T.txt(
            'lengthCmShort',
          ),
          yLabel:
              T.txt(
            'weightKgShort',
          ),
        );
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color growthColor =
        Color(
      0xFF00A896,
    );

    final Color childColor =
        widget.child.sex ==
                ChildSex.girl
            ? Colors.pink
            : Colors.blue;

    final _GrowthChartSpec spec =
        _chartSpec();

    return SafeArea(
      child:
          ListView(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          40,
        ),
        children: [
          // ==================================================================
          // PERFIL DEL NIÑO
          // ==================================================================

          Container(
            padding:
                const EdgeInsets.all(
              16,
            ),
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  widget.dark
                      ? const Color(
                          0xFF211B2E,
                        )
                      : Colors.white,
                  childColor.withValues(
                    alpha:
                        widget.dark
                            ? 0.15
                            : 0.07,
                  ),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                23,
              ),
              border:
                  Border.all(
                color:
                    childColor.withValues(
                  alpha:
                      0.14,
                ),
              ),
            ),
            child:
                Row(
              children: [
                ChildAvatar(
                  child:
                      widget.child,
                  size:
                      54,
                  borderWidth:
                      2,
                ),

                const SizedBox(
                  width:
                      13,
                ),

                Expanded(
                  child:
                      Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.child.name,
                        maxLines:
                            1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            TextStyle(
                          fontFamily:
                              'Fredoka',
                          fontSize:
                              20,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              widget.dark
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
                          widget.child.birthDate,
                        ),
                        style:
                            TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize:
                              14,
                          color:
                              widget.dark
                                  ? Colors.white60
                                  : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width:
                      46,
                  height:
                      46,
                  decoration:
                      BoxDecoration(
                    color:
                        growthColor.withValues(
                      alpha:
                          0.12,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                  child:
                      const Icon(
                    Icons.insert_chart_rounded,
                    color:
                        growthColor,
                    size:
                        28,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height:
                17,
          ),

          // ==================================================================
          // NOTA OMS
          // ==================================================================

          Container(
            padding:
                const EdgeInsets.all(
              14,
            ),
            decoration:
                BoxDecoration(
              color:
                  growthColor.withValues(
                alpha:
                    widget.dark
                        ? 0.12
                        : 0.065,
              ),
              borderRadius:
                  BorderRadius.circular(
                19,
              ),
            ),
            child:
                Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.health_and_safety_outlined,
                  color:
                      growthColor,
                ),

                const SizedBox(
                  width:
                      10,
                ),

                Expanded(
                  child:
                      Text(
                    T.txt(
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
                      color:
                          widget.dark
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
                23,
          ),

          // ==================================================================
          // TÍTULO SELECTOR
          // ==================================================================

          Text(
            T.txt(
              'growthSelectorTitle',
            ),
            style:
                TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  21,
              fontWeight:
                  FontWeight.w800,
              color:
                  widget.dark
                      ? Colors.white
                      : const Color(
                          0xFF4A2C82,
                        ),
            ),
          ),

          const SizedBox(
            height:
                4,
          ),

          Text(
            T.txt(
              'growthSelectorSubtitle',
            ),
            style:
                TextStyle(
              fontFamily:
                  'Baloo2',
              fontSize:
                  14,
              color:
                  widget.dark
                      ? Colors.white60
                      : Colors.black54,
            ),
          ),

          const SizedBox(
            height:
                13,
          ),

          // ==================================================================
          // SELECTOR DE 5 GRÁFICAS
          // ==================================================================

          SizedBox(
            height:
                112,
            child:
                ListView.separated(
              scrollDirection:
                  Axis.horizontal,
              itemCount:
                  _GrowthChartType
                      .values
                      .length,
              separatorBuilder:
                  (
                context,
                index,
              ) =>
                      const SizedBox(
                width:
                    10,
              ),
              itemBuilder:
                  (
                context,
                index,
              ) {
                final _GrowthChartType type =
                    _GrowthChartType
                        .values[index];

                final bool available =
                    _isAvailable(
                  type,
                );

                return _ChartSelectorCard(
                  label:
                      _selectorLabel(
                    type,
                  ),
                  icon:
                      _selectorIcon(
                    type,
                  ),
                  selected:
                      _selected ==
                          type,
                  available:
                      available,
                  dark:
                      widget.dark,
                  onTap:
                      available
                          ? () {
                              setState(
                                () {
                                  _selected =
                                      type;
                                },
                              );
                            }
                          : null,
                );
              },
            ),
          ),

          const SizedBox(
            height:
                20,
          ),

          // ==================================================================
          // SOLO UNA GRÁFICA A LA VEZ
          // ==================================================================

          AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds:
                  260,
            ),
            switchInCurve:
                Curves.easeOutCubic,
            switchOutCurve:
                Curves.easeInCubic,
            transitionBuilder:
                (
              Widget child,
              Animation<double> animation,
            ) {
              return FadeTransition(
                opacity:
                    animation,
                child:
                    SlideTransition(
                  position:
                      Tween<Offset>(
                    begin:
                        const Offset(
                      0.025,
                      0,
                    ),
                    end:
                        Offset.zero,
                  ).animate(
                    animation,
                  ),
                  child:
                      child,
                ),
              );
            },
            child:
                _OfficialGrowthChartCard(
              key:
                  ValueKey<String>(
                '${_selected.name}-'
                '${_usesWeightForHeight ? 'height' : 'length'}',
              ),
              spec:
                  spec,
              dark:
                  widget.dark,
              pointColor:
                  childColor,
            ),
          ),

          // ==================================================================
          // CONTROLES OMITIDOS
          // ==================================================================

          if (widget.data
                  .skippedMeasurements >
              0) ...[
            const SizedBox(
              height:
                  18,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.orange.withValues(
                  alpha:
                      0.09,
                ),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child:
                  Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color:
                        Colors.orange,
                  ),

                  const SizedBox(
                    width:
                        10,
                  ),

                  Expanded(
                    child:
                        Text(
                      T.txt(
                        'growthSkippedMeasurements',
                      ).replaceAll(
                        '{count}',
                        widget
                            .data
                            .skippedMeasurements
                            .toString(),
                      ),
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        color:
                            widget.dark
                                ? Colors.white70
                                : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(
            height:
                20,
          ),

          // ==================================================================
          // AVISO
          // ==================================================================

          Text(
            T.txt(
              'growthChartDisclaimer',
            ),
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              fontFamily:
                  'Baloo2',
              fontSize:
                  13,
              height:
                  1.35,
              color:
                  widget.dark
                      ? Colors.white54
                      : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ESPECIFICACIÓN DE GRÁFICA
// ============================================================================

class _GrowthChartSpec {
  final String title;

  final String description;

  final WhoGrowthTable table;

  final List<OfficialWhoGrowthPoint>
      points;

  final String xLabel;

  final String yLabel;

  const _GrowthChartSpec({
    required this.title,
    required this.description,
    required this.table,
    required this.points,
    required this.xLabel,
    required this.yLabel,
  });
}

// ============================================================================
// TARJETA DEL SELECTOR
// ============================================================================

class _ChartSelectorCard
    extends StatelessWidget {
  final String label;

  final IconData icon;

  final bool selected;

  final bool available;

  final bool dark;

  final VoidCallback? onTap;

  const _ChartSelectorCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.available,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color selectedColor =
        Color(
      0xFF00A896,
    );

    final Color normalText =
        dark
            ? Colors.white
            : const Color(
                0xFF2D2D2D,
              );

    final Color foreground =
        !available
            ? Colors.grey
            : selected
                ? Colors.white
                : normalText;

    return Semantics(
      button:
          true,
      selected:
          selected,
      enabled:
          available,
      label:
          label,
      child:
          AnimatedOpacity(
        duration:
            const Duration(
          milliseconds:
              180,
        ),
        opacity:
            available
                ? 1
                : 0.42,
        child:
            Material(
          color:
              Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            21,
          ),
          child:
              InkWell(
            onTap:
                onTap,
            borderRadius:
                BorderRadius.circular(
              21,
            ),
            child:
                AnimatedContainer(
              duration:
                  const Duration(
                milliseconds:
                    220,
              ),
              width:
                  126,
              padding:
                  const EdgeInsets.symmetric(
                horizontal:
                    10,
                vertical:
                    11,
              ),
              decoration:
                  BoxDecoration(
                color:
                    selected
                        ? selectedColor
                        : dark
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
                      selected
                          ? selectedColor
                          : available
                              ? selectedColor.withValues(
                                  alpha:
                                      0.18,
                                )
                              : Colors.grey.withValues(
                                  alpha:
                                      0.20,
                                ),
                  width:
                      selected
                          ? 1.8
                          : 1,
                ),
                boxShadow:
                    selected
                        ? [
                            BoxShadow(
                              color:
                                  selectedColor
                                      .withValues(
                                alpha:
                                    0.20,
                              ),
                              blurRadius:
                                  13,
                              offset:
                                  const Offset(
                                0,
                                5,
                              ),
                            ),
                          ]
                        : const [],
              ),
              child:
                  Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    available
                        ? icon
                        : Icons.lock_outline_rounded,
                    size:
                        28,
                    color:
                        foreground,
                  ),

                  const SizedBox(
                    height:
                        7,
                  ),

                  Text(
                    label,
                    maxLines:
                        2,
                    overflow:
                        TextOverflow.ellipsis,
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontFamily:
                          'Fredoka',
                      fontSize:
                          13,
                      height:
                          1.05,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// TARJETA DE GRÁFICA
// ============================================================================

class _OfficialGrowthChartCard
    extends StatelessWidget {
  final _GrowthChartSpec spec;

  final bool dark;

  final Color pointColor;

  const _OfficialGrowthChartCard({
    super.key,
    required this.spec,
    required this.dark,
    required this.pointColor,
  });

  // ==========================================================================
  // FORMATEAR VALOR
  // ==========================================================================

  String _formatValue(
    double value,
  ) {
    if (value.abs() >=
        100) {
      return value.toStringAsFixed(
        0,
      );
    }

    return value.toStringAsFixed(
      1,
    );
  }

  // ==========================================================================
  // FORMATEAR Z
  // ==========================================================================

  String _formatZ(
    double value,
  ) {
    if (value >= 0) {
      return '+${value.toStringAsFixed(2)}';
    }

    return value.toStringAsFixed(
      2,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // ------------------------------------------------------------------------
    // SIN DATOS
    // ------------------------------------------------------------------------

    if (spec.points.isEmpty) {
      return _EmptyChartCard(
        title:
            spec.title,
        dark:
            dark,
      );
    }

    final OfficialWhoGrowthPoint latest =
        spec.points.last;

    final bool spanish =
        AppConfig.idioma.value ==
            'es';

    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color:
            dark
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
              const Color(
            0xFF00A896,
          ).withValues(
            alpha:
                0.15,
          ),
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ==================================================================
          // TÍTULO
          // ==================================================================

          Text(
            spec.title,
            style:
                TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  20,
              fontWeight:
                  FontWeight.w800,
              color:
                  dark
                      ? Colors.white
                      : const Color(
                          0xFF2D2D2D,
                        ),
            ),
          ),

          const SizedBox(
            height:
                4,
          ),

          // ==================================================================
          // DESCRIPCIÓN
          // ==================================================================

          Text(
            spec.description,
            style:
                TextStyle(
              fontFamily:
                  'Baloo2',
              fontSize:
                  14,
              height:
                  1.25,
              color:
                  dark
                      ? Colors.white60
                      : Colors.black54,
            ),
          ),

          const SizedBox(
            height:
                13,
          ),

          // ==================================================================
          // INFORMACIÓN DEL ÚLTIMO CONTROL
          // ==================================================================

          Wrap(
            spacing:
                8,
            runSpacing:
                8,
            children: [
              _InfoChip(
                icon:
                    Icons.fiber_manual_record_rounded,
                text:
                    '${_formatValue(latest.value)} '
                    '${spec.table.unit}',
                dark:
                    dark,
                color:
                    pointColor,
              ),
              _InfoChip(
                icon:
                    Icons.analytics_outlined,
                text:
                    'Z ${_formatZ(latest.zScore)}',
                dark:
                    dark,
                color:
                    const Color(
                  0xFF00A896,
                ),
              ),
              _InfoChip(
                icon:
                    Icons.calendar_month_rounded,
                text:
                    simpleDateText(
                  latest
                      .measurement
                      .measuredAt,
                ),
                dark:
                    dark,
                color:
                    const Color(
                  0xFF7B2CBF,
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                14,
          ),

          // ==================================================================
          // GRÁFICA
          // ==================================================================

          Container(
            height:
                470,
            width:
                double.infinity,
            clipBehavior:
                Clip.antiAlias,
            decoration:
                BoxDecoration(
              color:
                  dark
                      ? const Color(
                          0xFF17141C,
                        )
                      : const Color(
                          0xFFFEFEFE,
                        ),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
              border:
                  Border.all(
                color:
                    dark
                        ? Colors.white.withValues(
                            alpha:
                                0.06,
                          )
                        : Colors.black.withValues(
                            alpha:
                                0.06,
                          ),
              ),
            ),
            child:
                InteractiveViewer(
              minScale:
                  0.7,
              maxScale:
                  5,
              boundaryMargin:
                  const EdgeInsets.all(
                150,
              ),
              constrained:
                  false,
              child:
                  SizedBox(
                width:
                    900,
                height:
                    620,
                child:
                    CustomPaint(
                  painter:
                      _WhoGrowthChartPainter(
                    table:
                        spec.table,
                    points:
                        spec.points,
                    dark:
                        dark,
                    pointColor:
                        pointColor,
                    spanish:
                        spanish,
                    xLabel:
                        spec.xLabel,
                    yLabel:
                        spec.yLabel,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height:
                10,
          ),

          // ==================================================================
          // LEYENDA
          // ==================================================================

          const _ZScoreLegend(),

          const SizedBox(
            height:
                10,
          ),

          // ==================================================================
          // ZOOM
          // ==================================================================

          Row(
            children: [
              const Icon(
                Icons.zoom_in_rounded,
                size:
                    18,
                color:
                    Color(
                  0xFF00A896,
                ),
              ),

              const SizedBox(
                width:
                    6,
              ),

              Expanded(
                child:
                    Text(
                  T.txt(
                    'growthChartZoomHint',
                  ),
                  style:
                      TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize:
                        13,
                    color:
                        dark
                            ? Colors.white54
                            : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CHIP DE INFORMACIÓN
// ============================================================================

class _InfoChip extends StatelessWidget {
  final IconData icon;

  final String text;

  final bool dark;

  final Color color;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.dark,
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            10,
        vertical:
            7,
      ),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha:
              dark
                  ? 0.14
                  : 0.09,
        ),
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      child:
          Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size:
                16,
            color:
                color,
          ),

          const SizedBox(
            width:
                5,
          ),

          Text(
            text,
            style:
                TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  12.5,
              fontWeight:
                  FontWeight.w700,
              color:
                  dark
                      ? Colors.white
                      : const Color(
                          0xFF333333,
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LEYENDA Z-SCORE
// ============================================================================

class _ZScoreLegend
    extends StatelessWidget {
  const _ZScoreLegend();

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Wrap(
      spacing:
          9,
      runSpacing:
          6,
      children: [
        _LegendItem(
          text:
              '-3 DE',
          color:
              const Color(
            0xFFC75B5B,
          ),
          dark:
              dark,
        ),
        _LegendItem(
          text:
              '-2 DE',
          color:
              const Color(
            0xFFD8913A,
          ),
          dark:
              dark,
        ),
        _LegendItem(
          text:
              '-1 DE',
          color:
              const Color(
            0xFF8AA29E,
          ),
          dark:
              dark,
        ),
        _LegendItem(
          text:
              '0 DE',
          color:
              const Color(
            0xFF00A896,
          ),
          dark:
              dark,
        ),
        _LegendItem(
          text:
              '+1 DE',
          color:
              const Color(
            0xFF8AA29E,
          ),
          dark:
              dark,
        ),
        _LegendItem(
          text:
              '+2 DE',
          color:
              const Color(
            0xFFD8913A,
          ),
          dark:
              dark,
        ),
        _LegendItem(
          text:
              '+3 DE',
          color:
              const Color(
            0xFFC75B5B,
          ),
          dark:
              dark,
        ),
      ],
    );
  }
}

// ============================================================================
// ELEMENTO DE LEYENDA
// ============================================================================

class _LegendItem
    extends StatelessWidget {
  final String text;

  final Color color;

  final bool dark;

  const _LegendItem({
    required this.text,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Container(
          width:
              16,
          height:
              3,
          decoration:
              BoxDecoration(
            color:
                color,
            borderRadius:
                BorderRadius.circular(
              3,
            ),
          ),
        ),

        const SizedBox(
          width:
              4,
        ),

        Text(
          text,
          style:
              TextStyle(
            fontFamily:
                'Baloo2',
            fontSize:
                11.5,
            color:
                dark
                    ? Colors.white60
                    : Colors.black54,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PAINTER OMS
// ============================================================================

class _WhoGrowthChartPainter
    extends CustomPainter {
  final WhoGrowthTable table;

  final List<OfficialWhoGrowthPoint>
      points;

  final bool dark;

  final Color pointColor;

  final bool spanish;

  final String xLabel;

  final String yLabel;

  _WhoGrowthChartPainter({
    required this.table,
    required this.points,
    required this.dark,
    required this.pointColor,
    required this.spanish,
    required this.xLabel,
    required this.yLabel,
  });

  // ==========================================================================
  // MÁRGENES
  // ==========================================================================

  static const double _left =
      68;

  static const double _right =
      64;

  static const double _top =
      32;

  static const double _bottom =
      58;

  // ==========================================================================
  // PAINT
  // ==========================================================================

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (table.rows.isEmpty) {
      return;
    }

    final Rect plot =
        Rect.fromLTRB(
      _left,
      _top,
      size.width -
          _right,
      size.height -
          _bottom,
    );

    final Color gridColor =
        dark
            ? Colors.white.withValues(
                alpha:
                    0.10,
              )
            : Colors.black.withValues(
                alpha:
                    0.09,
              );

    final Color axisColor =
        dark
            ? Colors.white54
            : Colors.black54;

    final double xMin =
        table.xStart;

    final double xMax =
        table.xEnd;

    final _YRange yRange =
        _calculateYRange();

    final double yMin =
        yRange.min;

    final double yMax =
        yRange.max;

    // ========================================================================
    // MAP X
    // ========================================================================

    double mapX(
      double x,
    ) {
      final double fraction =
          (x - xMin) /
              (xMax -
                  xMin);

      return plot.left +
          fraction *
              plot.width;
    }

    // ========================================================================
    // MAP Y
    // ========================================================================

    double mapY(
      double y,
    ) {
      final double fraction =
          (y - yMin) /
              (yMax -
                  yMin);

      return plot.bottom -
          fraction *
              plot.height;
    }

    // ========================================================================
    // FONDO
    // ========================================================================

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        plot,
        const Radius.circular(
          10,
        ),
      ),
      Paint()
        ..color =
            dark
                ? const Color(
                    0xFF1E1A25,
                  )
                : Colors.white,
    );

    // ========================================================================
    // GRID HORIZONTAL
    // ========================================================================

    const int yTicks =
        6;

    for (int i = 0;
        i <= yTicks;
        i++) {
      final double fraction =
          i /
              yTicks;

      final double value =
          yMin +
              (yMax -
                      yMin) *
                  fraction;

      final double y =
          mapY(
        value,
      );

      canvas.drawLine(
        Offset(
          plot.left,
          y,
        ),
        Offset(
          plot.right,
          y,
        ),
        Paint()
          ..color =
              gridColor
          ..strokeWidth =
              1,
      );

      _drawText(
        canvas:
            canvas,
        text:
            _formatAxisNumber(
          value,
        ),
        offset:
            Offset(
          plot.left -
              9,
          y,
        ),
        color:
            axisColor,
        fontSize:
            11,
        anchorRight:
            true,
        centerVertical:
            true,
      );
    }

    // ========================================================================
    // EJE X
    // ========================================================================

    if (table.xUnit ==
        'age_days') {
      _drawAgeAxis(
        canvas:
            canvas,
        plot:
            plot,
        mapX:
            mapX,
        xMin:
            xMin,
        xMax:
            xMax,
        gridColor:
            gridColor,
        axisColor:
            axisColor,
      );
    } else {
      _drawMeasurementAxis(
        canvas:
            canvas,
        plot:
            plot,
        mapX:
            mapX,
        xMin:
            xMin,
        xMax:
            xMax,
        gridColor:
            gridColor,
        axisColor:
            axisColor,
      );
    }

    // ========================================================================
    // EJES PRINCIPALES
    // ========================================================================

    final Paint axisPaint =
        Paint()
          ..color =
              axisColor
          ..strokeWidth =
              1.2;

    canvas.drawLine(
      Offset(
        plot.left,
        plot.bottom,
      ),
      Offset(
        plot.right,
        plot.bottom,
      ),
      axisPaint,
    );

    canvas.drawLine(
      Offset(
        plot.left,
        plot.top,
      ),
      Offset(
        plot.left,
        plot.bottom,
      ),
      axisPaint,
    );

    // ========================================================================
    // LABEL EJE X
    // ========================================================================

    _drawText(
      canvas:
          canvas,
      text:
          xLabel,
      offset:
          Offset(
        plot.center.dx,
        size.height -
            12,
      ),
      color:
          axisColor,
      fontSize:
          12,
      fontWeight:
          FontWeight.w600,
      centerHorizontal:
          true,
      centerVertical:
          true,
    );

    // ========================================================================
    // LABEL EJE Y
    // ========================================================================

    _drawText(
      canvas:
          canvas,
      text:
          yLabel,
      offset:
          Offset(
        plot.left,
        12,
      ),
      color:
          axisColor,
      fontSize:
          12,
      fontWeight:
          FontWeight.w600,
    );

    // ========================================================================
    // CURVAS OMS
    // ========================================================================

    _drawReferenceCurve(
      canvas:
          canvas,
      plot:
          plot,
      mapX:
          mapX,
      mapY:
          mapY,
      valueOf:
          (
        WhoGrowthRow row,
      ) =>
              row.sd3Negative,
      color:
          const Color(
        0xFFC75B5B,
      ),
      width:
          1.5,
      label:
          '-3',
    );

    _drawReferenceCurve(
      canvas:
          canvas,
      plot:
          plot,
      mapX:
          mapX,
      mapY:
          mapY,
      valueOf:
          (
        WhoGrowthRow row,
      ) =>
              row.sd2Negative,
      color:
          const Color(
        0xFFD8913A,
      ),
      width:
          1.7,
      label:
          '-2',
    );

    _drawReferenceCurve(
      canvas:
          canvas,
      plot:
          plot,
      mapX:
          mapX,
      mapY:
          mapY,
      valueOf:
          (
        WhoGrowthRow row,
      ) =>
              row.sd1Negative,
      color:
          const Color(
        0xFF8AA29E,
      ),
      width:
          1.3,
      label:
          '-1',
    );

    _drawReferenceCurve(
      canvas:
          canvas,
      plot:
          plot,
      mapX:
          mapX,
      mapY:
          mapY,
      valueOf:
          (
        WhoGrowthRow row,
      ) =>
              row.median,
      color:
          const Color(
        0xFF00A896,
      ),
      width:
          2.6,
      label:
          '0',
    );

    _drawReferenceCurve(
      canvas:
          canvas,
      plot:
          plot,
      mapX:
          mapX,
      mapY:
          mapY,
      valueOf:
          (
        WhoGrowthRow row,
      ) =>
              row.sd1,
      color:
          const Color(
        0xFF8AA29E,
      ),
      width:
          1.3,
      label:
          '+1',
    );

    _drawReferenceCurve(
      canvas:
          canvas,
      plot:
          plot,
      mapX:
          mapX,
      mapY:
          mapY,
      valueOf:
          (
        WhoGrowthRow row,
      ) =>
              row.sd2,
      color:
          const Color(
        0xFFD8913A,
      ),
      width:
          1.7,
      label:
          '+2',
    );

    _drawReferenceCurve(
      canvas:
          canvas,
      plot:
          plot,
      mapX:
          mapX,
      mapY:
          mapY,
      valueOf:
          (
        WhoGrowthRow row,
      ) =>
              row.sd3,
      color:
          const Color(
        0xFFC75B5B,
      ),
      width:
          1.5,
      label:
          '+3',
    );

    // ========================================================================
    // TRAYECTORIA DEL NIÑO
    // ========================================================================

    if (points.length >
        1) {
      final Path trajectory =
          Path();

      for (int i = 0;
          i < points.length;
          i++) {
        final OfficialWhoGrowthPoint point =
            points[i];

        final double x =
            mapX(
          point.x,
        );

        final double y =
            mapY(
          point.value,
        );

        if (i == 0) {
          trajectory.moveTo(
            x,
            y,
          );
        } else {
          trajectory.lineTo(
            x,
            y,
          );
        }
      }

      canvas.drawPath(
        trajectory,
        Paint()
          ..color =
              pointColor.withValues(
            alpha:
                0.65,
          )
          ..strokeWidth =
              2.2
          ..style =
              PaintingStyle.stroke
          ..strokeCap =
              StrokeCap.round
          ..strokeJoin =
              StrokeJoin.round,
      );
    }

    // ========================================================================
    // PUNTOS DEL NIÑO
    // ========================================================================

    for (int i = 0;
        i < points.length;
        i++) {
      final OfficialWhoGrowthPoint point =
          points[i];

      final Offset position =
          Offset(
        mapX(
          point.x,
        ),
        mapY(
          point.value,
        ),
      );

      final bool latest =
          i ==
              points.length -
                  1;

      // ----------------------------------------------------------------------
      // HALO DEL ÚLTIMO PUNTO
      // ----------------------------------------------------------------------

      if (latest) {
        canvas.drawCircle(
          position,
          8.5,
          Paint()
            ..color =
                pointColor.withValues(
              alpha:
                  0.20,
            ),
        );
      }

      // ----------------------------------------------------------------------
      // PUNTO
      // ----------------------------------------------------------------------

      canvas.drawCircle(
        position,
        latest
            ? 5.7
            : 4.6,
        Paint()
          ..color =
              pointColor
          ..style =
              PaintingStyle.fill,
      );

      // ----------------------------------------------------------------------
      // BORDE BLANCO
      // ----------------------------------------------------------------------

      canvas.drawCircle(
        position,
        latest
            ? 5.7
            : 4.6,
        Paint()
          ..color =
              Colors.white
          ..strokeWidth =
              1.5
          ..style =
              PaintingStyle.stroke,
      );
    }
  }

  // ==========================================================================
  // EJE DE EDAD
  // ==========================================================================

  void _drawAgeAxis({
    required Canvas canvas,
    required Rect plot,
    required double Function(
      double,
    ) mapX,
    required double xMin,
    required double xMax,
    required Color gridColor,
    required Color axisColor,
  }) {
    const List<double> yearDays =
        <double>[
      0,
      365.25,
      730.5,
      1095.75,
      1461,
      1826.25,
    ];

    for (int i = 0;
        i < yearDays.length;
        i++) {
      final double value =
          yearDays[i];

      if (value <
              xMin ||
          value >
              xMax) {
        continue;
      }

      final double x =
          mapX(
        value,
      );

      canvas.drawLine(
        Offset(
          x,
          plot.top,
        ),
        Offset(
          x,
          plot.bottom,
        ),
        Paint()
          ..color =
              gridColor
          ..strokeWidth =
              1,
      );

      final String text;

      if (i == 0) {
        text =
            '0';
      } else {
        text =
            spanish
                ? '${i}a'
                : '${i}y';
      }

      _drawText(
        canvas:
            canvas,
        text:
            text,
        offset:
            Offset(
          x,
          plot.bottom +
              12,
        ),
        color:
            axisColor,
        fontSize:
            11,
        centerHorizontal:
            true,
      );
    }
  }

  // ==========================================================================
  // EJE DE LONGITUD / TALLA
  // ==========================================================================

  void _drawMeasurementAxis({
    required Canvas canvas,
    required Rect plot,
    required double Function(
      double,
    ) mapX,
    required double xMin,
    required double xMax,
    required Color gridColor,
    required Color axisColor,
  }) {
    const int ticks =
        6;

    for (int i = 0;
        i <= ticks;
        i++) {
      final double fraction =
          i /
              ticks;

      final double value =
          xMin +
              (xMax -
                      xMin) *
                  fraction;

      final double x =
          mapX(
        value,
      );

      canvas.drawLine(
        Offset(
          x,
          plot.top,
        ),
        Offset(
          x,
          plot.bottom,
        ),
        Paint()
          ..color =
              gridColor
          ..strokeWidth =
              1,
      );

      _drawText(
        canvas:
            canvas,
        text:
            value.toStringAsFixed(
          0,
        ),
        offset:
            Offset(
          x,
          plot.bottom +
              12,
        ),
        color:
            axisColor,
        fontSize:
            11,
        centerHorizontal:
            true,
      );
    }
  }

  // ==========================================================================
  // RANGO Y
  // ==========================================================================

  _YRange _calculateYRange() {
    double minimum =
        double.infinity;

    double maximum =
        double.negativeInfinity;

    // ------------------------------------------------------------------------
    // CURVAS OMS
    // ------------------------------------------------------------------------

    for (final WhoGrowthRow row
        in table.rows) {
      minimum =
          math.min(
        minimum,
        row.sd3Negative,
      );

      maximum =
          math.max(
        maximum,
        row.sd3,
      );
    }

    // ------------------------------------------------------------------------
    // MEDICIONES DEL NIÑO
    // ------------------------------------------------------------------------

    for (final OfficialWhoGrowthPoint point
        in points) {
      minimum =
          math.min(
        minimum,
        point.value,
      );

      maximum =
          math.max(
        maximum,
        point.value,
      );
    }

    // ------------------------------------------------------------------------
    // FALLBACK
    // ------------------------------------------------------------------------

    if (!minimum.isFinite ||
        !maximum.isFinite) {
      return const _YRange(
        min:
            0,
        max:
            1,
      );
    }

    // ------------------------------------------------------------------------
    // EVITAR RANGO CERO
    // ------------------------------------------------------------------------

    if ((maximum -
            minimum)
        .abs() <
        0.0001) {
      minimum -=
          1;

      maximum +=
          1;
    }

    // ------------------------------------------------------------------------
    // MARGEN VISUAL
    // ------------------------------------------------------------------------

    final double padding =
        (maximum -
                minimum) *
            0.06;

    return _YRange(
      min:
          minimum -
              padding,
      max:
          maximum +
              padding,
    );
  }

  // ==========================================================================
  // DIBUJAR CURVA OMS
  // ==========================================================================

  void _drawReferenceCurve({
    required Canvas canvas,
    required Rect plot,
    required double Function(
      double x,
    ) mapX,
    required double Function(
      double y,
    ) mapY,
    required double Function(
      WhoGrowthRow row,
    ) valueOf,
    required Color color,
    required double width,
    required String label,
  }) {
    final Path path =
        Path();

    // ------------------------------------------------------------------------
    // REDUCIR PUNTOS DE DIBUJO SIN ALTERAR LA TABLA ORIGINAL
    // ------------------------------------------------------------------------

    final int sampleStep =
        math.max(
      1,
      (table.rows.length /
              650)
          .ceil(),
    );

    bool started =
        false;

    for (int i = 0;
        i < table.rows.length;
        i += sampleStep) {
      final WhoGrowthRow row =
          table.rows[i];

      final double x =
          mapX(
        row.x,
      );

      final double y =
          mapY(
        valueOf(
          row,
        ),
      );

      if (!started) {
        path.moveTo(
          x,
          y,
        );

        started =
            true;
      } else {
        path.lineTo(
          x,
          y,
        );
      }
    }

    // ------------------------------------------------------------------------
    // INCLUIR SIEMPRE EL ÚLTIMO PUNTO
    // ------------------------------------------------------------------------

    final WhoGrowthRow last =
        table.rows.last;

    path.lineTo(
      mapX(
        last.x,
      ),
      mapY(
        valueOf(
          last,
        ),
      ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color =
            color
        ..strokeWidth =
            width
        ..style =
            PaintingStyle.stroke
        ..strokeCap =
            StrokeCap.round
        ..strokeJoin =
            StrokeJoin.round,
    );

    // ------------------------------------------------------------------------
    // LABEL AL FINAL
    // ------------------------------------------------------------------------

    final double lastY =
        mapY(
      valueOf(
        last,
      ),
    );

    if (lastY >=
            plot.top &&
        lastY <=
            plot.bottom) {
      _drawText(
        canvas:
            canvas,
        text:
            label,
        offset:
            Offset(
          plot.right +
              7,
          lastY,
        ),
        color:
            color,
        fontSize:
            10.5,
        fontWeight:
            FontWeight.w700,
        centerVertical:
            true,
      );
    }
  }

  // ==========================================================================
  // FORMATO NÚMEROS
  // ==========================================================================

  String _formatAxisNumber(
    double value,
  ) {
    if (value.abs() >=
        100) {
      return value.toStringAsFixed(
        0,
      );
    }

    if ((value -
            value.roundToDouble())
        .abs() <
        0.05) {
      return value.toStringAsFixed(
        0,
      );
    }

    return value.toStringAsFixed(
      1,
    );
  }

  // ==========================================================================
  // TEXTO DEL CANVAS
  // ==========================================================================

  void _drawText({
    required Canvas canvas,
    required String text,
    required Offset offset,
    required Color color,
    required double fontSize,
    FontWeight fontWeight =
        FontWeight.w400,
    bool anchorRight =
        false,
    bool centerHorizontal =
        false,
    bool centerVertical =
        false,
  }) {
    final TextPainter painter =
        TextPainter(
      text:
          TextSpan(
        text:
            text,
        style:
            TextStyle(
          color:
              color,
          fontSize:
              fontSize,
          fontFamily:
              'Baloo2',
          fontWeight:
              fontWeight,
        ),
      ),
      textDirection:
          TextDirection.ltr,
    )
          ..layout();

    double dx =
        offset.dx;

    double dy =
        offset.dy;

    if (anchorRight) {
      dx -=
          painter.width;
    }

    if (centerHorizontal) {
      dx -=
          painter.width /
              2;
    }

    if (centerVertical) {
      dy -=
          painter.height /
              2;
    }

    painter.paint(
      canvas,
      Offset(
        dx,
        dy,
      ),
    );
  }

  // ==========================================================================
  // REPAINT
  // ==========================================================================

  @override
  bool shouldRepaint(
    covariant _WhoGrowthChartPainter
        oldDelegate,
  ) {
    return oldDelegate.table !=
            table ||
        oldDelegate.points !=
            points ||
        oldDelegate.dark !=
            dark ||
        oldDelegate.pointColor !=
            pointColor ||
        oldDelegate.spanish !=
            spanish ||
        oldDelegate.xLabel !=
            xLabel ||
        oldDelegate.yLabel !=
            yLabel;
  }
}

// ============================================================================
// RANGO Y
// ============================================================================

class _YRange {
  final double min;

  final double max;

  const _YRange({
    required this.min,
    required this.max,
  });
}

// ============================================================================
// GRÁFICA SIN DATOS
// ============================================================================

class _EmptyChartCard
    extends StatelessWidget {
  final String title;

  final bool dark;

  const _EmptyChartCard({
    required this.title,
    required this.dark,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            dark
                ? const Color(
                    0xFF211B2E,
                  )
                : Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF00A896,
          ).withValues(
            alpha:
                0.10,
          ),
        ),
      ),
      child:
          Row(
        children: [
          const Icon(
            Icons.insert_chart_outlined_rounded,
            color:
                Color(
              0xFF00A896,
            ),
          ),

          const SizedBox(
            width:
                12,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontWeight:
                        FontWeight.w700,
                    color:
                        dark
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
                    'growthChartNoData',
                  ),
                  style:
                      TextStyle(
                    fontFamily:
                        'Baloo2',
                    color:
                        dark
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

// ============================================================================
// ERROR
// ============================================================================

class _LoadError extends StatelessWidget {
  final bool dark;

  final VoidCallback onRetry;

  const _LoadError({
    required this.dark,
    required this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          28,
        ),
        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size:
                  55,
              color:
                  Colors.orange,
            ),

            const SizedBox(
              height:
                  14,
            ),

            Text(
              T.txt(
                'growthChartsLoadError',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
                fontSize:
                    15,
                color:
                    dark
                        ? Colors.white70
                        : Colors.black87,
              ),
            ),

            const SizedBox(
              height:
                  16,
            ),

            OutlinedButton.icon(
              onPressed:
                  onRetry,
              icon:
                  const Icon(
                Icons.refresh_rounded,
              ),
              label:
                  Text(
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
}

// ============================================================================
// SIN CONTROLES
// ============================================================================

class _NoMeasurements
    extends StatelessWidget {
  final bool dark;

  const _NoMeasurements({
    required this.dark,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          28,
        ),
        child:
            Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_chart_outlined_rounded,
              size:
                  70,
              color:
                  Color(
                0xFF00A896,
              ),
            ),

            const SizedBox(
              height:
                  18,
            ),

            Text(
              T.txt(
                'growthChartsNoMeasurements',
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
                color:
                    dark
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
                'growthChartsNoMeasurementsSubtitle',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
                color:
                    dark
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

// ============================================================================
// SIN MEDICIONES OMS VÁLIDAS
// ============================================================================

class _NoValidMeasurements
    extends StatelessWidget {
  final bool dark;

  const _NoValidMeasurements({
    required this.dark,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          28,
        ),
        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.query_stats_rounded,
              size:
                  60,
              color:
                  Color(
                0xFF00A896,
              ),
            ),

            const SizedBox(
              height:
                  14,
            ),

            Text(
              T.txt(
                'growthNoValidWhoMeasurements',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
                fontSize:
                    16,
                color:
                    dark
                        ? Colors.white70
                        : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}