import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:growth_standards/growth_standards.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';

import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';

import '../data/growth_repository.dart';
import '../models/growth_measurement.dart';
import '../services/who_growth_service.dart';

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
      _future;

  @override
  void initState() {
    super.initState();

    _future =
        GrowthRepository.instance
            .getMeasurementsForChild(
      widget.child.id,
    );
  }

  Future<void> _reload() async {
    setState(() {
      _future =
          GrowthRepository.instance
              .getMeasurementsForChild(
        widget.child.id,
      );
    });
  }

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
                    T.txt('refresh'),
                onPressed:
                    _reload,
                icon:
                    const Icon(
                  Icons
                      .refresh_rounded,
                ),
              ),
            ],
          ),
          body: FutureBuilder<
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
                        const EdgeInsets
                            .all(
                      24,
                    ),
                    child: Text(
                      T.txt(
                        'growthChartsLoadError',
                      ),
                      textAlign:
                          TextAlign
                              .center,
                    ),
                  ),
                );
              }

              final List<GrowthMeasurement>
                  measurements =
                  snapshot.data ??
                      <GrowthMeasurement>[];

              if (measurements.isEmpty) {
                return _NoMeasurements(
                  dark:
                      dark,
                );
              }

              final WhoGrowthChartData data =
                  WhoGrowthService
                      .instance
                      .build(
                child:
                    widget.child,
                measurements:
                    measurements,
              );

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
          ),
        );
      },
    );
  }
}

class _GrowthChartsContent
    extends StatelessWidget {
  final Child child;
  final WhoGrowthChartData data;
  final bool dark;

  const _GrowthChartsContent({
    required this.child,
    required this.data,
    required this.dark,
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
            const EdgeInsets
                .fromLTRB(
          18,
          18,
          18,
          40,
        ),
        children: [
          // ------------------------------------------------------
          // PERFIL
          // ------------------------------------------------------

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
                  BorderRadius.circular(
                23,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width:
                      54,
                  height:
                      54,
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
                    child.sex ==
                            ChildSex.girl
                        ? Icons
                            .face_3_rounded
                        : Icons
                            .face_6_rounded,
                    color:
                        childColor,
                    size:
                        31,
                  ),
                ),
                const SizedBox(
                  width:
                      13,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        child.name,
                        style:
                            TextStyle(
                          fontFamily:
                              'Fredoka',
                          fontSize:
                              20,
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
                      Text(
                        childAgeText(
                          child.birthDate,
                        ),
                        style:
                            TextStyle(
                          fontFamily:
                              'Baloo2',
                          color: dark
                              ? Colors
                                  .white60
                              : Colors
                                  .black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons
                      .insert_chart_rounded,
                  color:
                      Color(
                    0xFF00A896,
                  ),
                  size:
                      31,
                ),
              ],
            ),
          ),

          const SizedBox(
            height:
                18,
          ),

          // ------------------------------------------------------
          // INFORMACIÓN OMS
          // ------------------------------------------------------

          Container(
            padding:
                const EdgeInsets.all(
              15,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF00A896,
              ).withValues(
                alpha:
                    dark
                        ? 0.13
                        : 0.07,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
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
                      Color(
                    0xFF00A896,
                  ),
                ),
                const SizedBox(
                  width:
                      11,
                ),
                Expanded(
                  child: Text(
                    T.txt(
                      'whoGrowthReferenceNote',
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

          const SizedBox(
            height:
                24,
          ),

          // ------------------------------------------------------
          // PESO / EDAD
          // ------------------------------------------------------

          _GrowthChartCard(
            title:
                T.txt(
              'weightForAgeChart',
            ),
            description:
                T.txt(
              'weightForAgeChartDescription',
            ),
            results:
                data.weightForAge,
            sex:
                data.sex,
            dark:
                dark,
            xLabel:
                T.txt('age'),
            yLabel:
                T.txt('weightKgShort'),
          ),

          const SizedBox(
            height:
                22,
          ),

          // ------------------------------------------------------
          // LONGITUD/TALLA / EDAD
          // ------------------------------------------------------

          _GrowthChartCard(
            title:
                T.txt(
              'heightForAgeChart',
            ),
            description:
                T.txt(
              'heightForAgeChartDescription',
            ),
            results:
                data.lengthHeightForAge,
            sex:
                data.sex,
            dark:
                dark,
            xLabel:
                T.txt('age'),
            yLabel:
                T.txt('heightCmShort'),
          ),

          const SizedBox(
            height:
                22,
          ),

          // ------------------------------------------------------
          // PESO / LONGITUD
          // ------------------------------------------------------

          if (data.weightForLength
              .isNotEmpty) ...[
            _GrowthChartCard(
              title:
                  T.txt(
                'weightForLengthChart',
              ),
              description:
                  T.txt(
                'weightForLengthChartDescription',
              ),
              results:
                  data.weightForLength,
              sex:
                  data.sex,
              dark:
                  dark,
              xLabel:
                  T.txt(
                'lengthCmShort',
              ),
              yLabel:
                  T.txt(
                'weightKgShort',
              ),
            ),
            const SizedBox(
              height:
                  22,
            ),
          ],

          // ------------------------------------------------------
          // PESO / TALLA
          // ------------------------------------------------------

          if (data.weightForHeight
              .isNotEmpty) ...[
            _GrowthChartCard(
              title:
                  T.txt(
                'weightForHeightChart',
              ),
              description:
                  T.txt(
                'weightForHeightChartDescription',
              ),
              results:
                  data.weightForHeight,
              sex:
                  data.sex,
              dark:
                  dark,
              xLabel:
                  T.txt(
                'heightCmShort',
              ),
              yLabel:
                  T.txt(
                'weightKgShort',
              ),
            ),
            const SizedBox(
              height:
                  22,
            ),
          ],

          // ------------------------------------------------------
          // IMC / EDAD
          // ------------------------------------------------------

          _GrowthChartCard(
            title:
                T.txt(
              'bmiForAgeChart',
            ),
            description:
                T.txt(
              'bmiForAgeChartDescription',
            ),
            results:
                data.bmiForAge,
            sex:
                data.sex,
            dark:
                dark,
            xLabel:
                T.txt('age'),
            yLabel:
                T.txt('bmiShort'),
          ),

          if (data.skippedMeasurements >
              0) ...[
            const SizedBox(
              height:
                  20,
            ),
            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.orange
                        .withValues(
                  alpha:
                      0.09,
                ),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Icon(
                    Icons
                        .info_outline_rounded,
                    color:
                        Colors.orange,
                  ),
                  const SizedBox(
                    width:
                        10,
                  ),
                  Expanded(
                    child: Text(
                      T.txt(
                        'growthSkippedMeasurements',
                      ).replaceAll(
                        '{count}',
                        data
                            .skippedMeasurements
                            .toString(),
                      ),
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
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

          const SizedBox(
            height:
                20,
          ),

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
                  1.3,
              color: dark
                  ? Colors.white54
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthChartCard
    extends StatelessWidget {
  final String title;
  final String description;

  final List<Result> results;

  final Sex sex;

  final bool dark;

  final String xLabel;
  final String yLabel;

  const _GrowthChartCard({
    required this.title,
    required this.description,
    required this.results,
    required this.sex,
    required this.dark,
    required this.xLabel,
    required this.yLabel,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (results.isEmpty) {
      return _EmptyChartCard(
        title:
            title,
        dark:
            dark,
      );
    }

    final GrowthChartConfig config =
        GrowthChartConfig(
      width:
          900,
      height:
          650,

      title:
          title,

      subtitle:
          T.txt(
        'whoChildGrowthStandards',
      ),

      xLabel:
          xLabel,

      yLabel:
          yLabel,

      theme:
          GrowthChartTheme.forSex(
        sex,
      ),

      displayMode:
          GrowthChartDisplayMode
              .zScore,

      showGridLines:
          true,

      showLegend:
          true,

      showResultCallout:
          true,

      showTrajectoryLine:
          true,

      zScoreLines:
          const <int>[
        -3,
        -2,
        -1,
        0,
        1,
        2,
        3,
      ],
    );

    late final String svg;

    try {
      svg =
          results.toSvg(
        config:
            config,
      );
    } catch (_) {
      return _ChartErrorCard(
        title:
            title,
        dark:
            dark,
      );
    }

    return Container(
      width:
          double.infinity,
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
          24,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF00A896,
          ).withValues(
            alpha:
                0.13,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                TextStyle(
              fontFamily:
                  'Fredoka',
              fontSize:
                  20,
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
                4,
          ),

          Text(
            description,
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

          const SizedBox(
            height:
                12,
          ),

          Container(
            height:
                430,
            width:
                double.infinity,
            clipBehavior:
                Clip.antiAlias,
            decoration:
                BoxDecoration(
              color:
                  Colors.white,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child:
                InteractiveViewer(
              minScale:
                  0.5,
              maxScale:
                  4,
              boundaryMargin:
                  const EdgeInsets.all(
                100,
              ),
              child:
                  SizedBox(
                width:
                    900,
                height:
                    650,
                child:
                    SvgPicture.string(
                  svg,
                  fit:
                      BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(
            height:
                10,
          ),

          Row(
            children: [
              const Icon(
                Icons
                    .zoom_in_rounded,
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
                child: Text(
                  T.txt(
                    'growthChartZoomHint',
                  ),
                  style:
                      TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize:
                        13,
                    color: dark
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
        color: dark
            ? const Color(
                0xFF211B2E,
              )
            : Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons
                .insert_chart_outlined_rounded,
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
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                Text(
                  T.txt(
                    'growthChartNoData',
                  ),
                  style:
                      TextStyle(
                    fontFamily:
                        'Baloo2',
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

class _ChartErrorCard
    extends StatelessWidget {
  final String title;
  final bool dark;

  const _ChartErrorCard({
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
            Colors.orange
                .withValues(
          alpha:
              0.08,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons
                .warning_amber_rounded,
            color:
                Colors.orange,
          ),
          const SizedBox(
            width:
                10,
          ),
          Expanded(
            child: Text(
              '$title\n${T.txt('growthChartRenderError')}',
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
                color: dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      child: Padding(
        padding:
            const EdgeInsets.all(
          28,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons
                  .insert_chart_outlined_rounded,
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
                'growthChartsNoMeasurementsSubtitle',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
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
      child: Padding(
        padding:
            const EdgeInsets.all(
          28,
        ),
        child: Text(
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
            color: dark
                ? Colors.white70
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}