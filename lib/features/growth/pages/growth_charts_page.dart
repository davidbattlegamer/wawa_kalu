import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:growth_standards/growth_standards.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';

import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';
import '../../children/widgets/child_avatar.dart';

import '../data/growth_repository.dart';
import '../models/growth_measurement.dart';
import '../services/who_growth_service.dart';

// ============================================================================
// TIPOS DE GRÁFICA
// ============================================================================

enum _GrowthChartType { weightAge, heightAge, bmiAge, headAge }

// ============================================================================
// TRADUCCIÓN DEL SVG GENERADO POR growth_standards
// ============================================================================

String _translateGrowthSvg(String svg) {
  String translated = svg;

  final bool spanish = AppConfig.idioma.value == 'es';

  translated = translated.replaceAll(
    'Calculated Result',
    T.txt('growthSvgCalculatedResult'),
  );

  translated = translated.replaceAll(
    'Trajectory',
    T.txt('growthSvgTrajectory'),
  );

  translated = translated.replaceAll('Result:', '${T.txt('growthSvgResult')}:');

  translated = translated.replaceAll('Age/X:', '${T.txt('growthSvgAgeX')}:');

  translated = translated.replaceAll(
    '(Median)',
    '(${T.txt('growthSvgMedian')})',
  );

  translated = translated.replaceAll('Birth', T.txt('growthSvgBirth'));

  translated = translated.replaceAllMapped(
    RegExp(r'(-?\d+(?:\.\d+)?)th %ile'),
    (match) {
      return '${T.txt('growthSvgPercentile')}: '
          '${match.group(1)}';
    },
  );

  if (spanish) {
    translated = translated.replaceAll(RegExp(r'\bSD\b'), 'DE');

    translated = translated.replaceAllMapped(RegExp(r'(\d+)\s+days'), (match) {
      return '${match.group(1)} días';
    });

    translated = translated.replaceAllMapped(
      RegExp(r'(\d+(?:\.\d+)?)\s+mo\b'),
      (match) {
        return '${match.group(1)} meses';
      },
    );

    translated = translated.replaceAllMapped(RegExp(r'\((\d+)d\)'), (match) {
      return '(${match.group(1)} d)';
    });

    translated = translated.replaceAllMapped(RegExp(r'\((\d+(?:\.\d+)?)y\)'), (
      match,
    ) {
      return '(${match.group(1)} a)';
    });

    translated = translated.replaceAllMapped(RegExp(r'>(\d+)y<'), (match) {
      return '>${match.group(1)} a<';
    });

    translated = translated.replaceAllMapped(RegExp(r'>(\d+)m<'), (match) {
      return '>${match.group(1)} m<';
    });

    translated = translated.replaceAll('50th (Mediana)', 'P50 (Mediana)');

    translated = translated.replaceAll('15th / 85th', 'P15 / P85');

    translated = translated.replaceAll('3rd / 97th', 'P3 / P97');
  }

  return translated;
}

// ============================================================================
// PÁGINA
// ============================================================================

class GrowthChartsPage extends StatefulWidget {
  final Child child;

  const GrowthChartsPage({super.key, required this.child});

  @override
  State<GrowthChartsPage> createState() => _GrowthChartsPageState();
}

class _GrowthChartsPageState extends State<GrowthChartsPage> {
  late Future<List<GrowthMeasurement>> _future;

  @override
  void initState() {
    super.initState();

    _future = GrowthRepository.instance.getMeasurementsForChild(
      widget.child.id,
    );
  }

  Future<void> _reload() async {
    setState(() {
      _future = GrowthRepository.instance.getMeasurementsForChild(
        widget.child.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        final bool dark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: dark
              ? const Color(0xFF15131A)
              : const Color(0xFFFAF7F2),
          appBar: AppBar(
            backgroundColor: dark ? const Color(0xFF211B2E) : Colors.white,
            foregroundColor: dark ? Colors.white : const Color(0xFF2D2D2D),
            elevation: 0,
            title: Text(
              T.txt('growthChartsTitle'),
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                tooltip: T.txt('refresh'),
                onPressed: _reload,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: FutureBuilder<List<GrowthMeasurement>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      T.txt('growthChartsLoadError'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final List<GrowthMeasurement> measurements =
                  snapshot.data ?? <GrowthMeasurement>[];

              if (measurements.isEmpty) {
                return _NoMeasurements(dark: dark);
              }

              final WhoGrowthChartData data = WhoGrowthService.instance.build(
                child: widget.child,
                measurements: measurements,
              );

              if (!data.hasAnyData) {
                return _NoValidMeasurements(dark: dark);
              }

              return _GrowthChartsContent(
                child: widget.child,
                data: data,
                dark: dark,
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

class _GrowthChartsContent extends StatefulWidget {
  final Child child;
  final WhoGrowthChartData data;
  final bool dark;

  const _GrowthChartsContent({
    required this.child,
    required this.data,
    required this.dark,
  });

  @override
  State<_GrowthChartsContent> createState() => _GrowthChartsContentState();
}

class _GrowthChartsContentState extends State<_GrowthChartsContent> {
  _GrowthChartType _selected = _GrowthChartType.weightAge;

  // ==========================================================================
  // NOMBRE CORTO
  // ==========================================================================

  String _selectorLabel(_GrowthChartType type) {
    switch (type) {
      case _GrowthChartType.weightAge:
        return T.txt('growthSelectorWeight');

      case _GrowthChartType.heightAge:
        return T.txt('growthSelectorHeight');

      case _GrowthChartType.bmiAge:
        return T.txt('growthSelectorBmi');

      case _GrowthChartType.headAge:
        return T.txt('growthSelectorHead');
    }
  }

  // ==========================================================================
  // ICONO
  // ==========================================================================

  IconData _selectorIcon(_GrowthChartType type) {
    switch (type) {
      case _GrowthChartType.weightAge:
        return Icons.monitor_weight_outlined;

      case _GrowthChartType.heightAge:
        return Icons.straighten_rounded;

      case _GrowthChartType.bmiAge:
        return Icons.analytics_outlined;

      case _GrowthChartType.headAge:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  // ==========================================================================
  // DISPONIBILIDAD
  //
  // Cabeza se habilitará en la Parte 2 cuando agreguemos
  // las tablas OMS oficiales y el cálculo correspondiente.
  // ==========================================================================

  bool _isAvailable(_GrowthChartType type) {
    switch (type) {
      case _GrowthChartType.weightAge:
        return widget.data.weightForAge.isNotEmpty;

      case _GrowthChartType.heightAge:
        return widget.data.lengthHeightForAge.isNotEmpty;

      case _GrowthChartType.bmiAge:
        return widget.data.bmiForAge.isNotEmpty;

      case _GrowthChartType.headAge:
        return widget.data.headCircumferenceForAge.isNotEmpty;
    }
  }

  // ==========================================================================
  // GRÁFICA SELECCIONADA
  // ==========================================================================

  Widget _selectedChart() {
    switch (_selected) {
      case _GrowthChartType.weightAge:
        return _GrowthChartCard(
          title: T.txt('weightForAgeChart'),
          description: T.txt('weightForAgeChartDescription'),
          results: widget.data.weightForAge,
          sex: widget.data.sex,
          dark: widget.dark,
          xLabel: T.txt('age'),
          yLabel: T.txt('weightKgShort'),
        );

      case _GrowthChartType.heightAge:
        return _GrowthChartCard(
          title: T.txt('heightForAgeChart'),
          description: T.txt('heightForAgeChartDescription'),
          results: widget.data.lengthHeightForAge,
          sex: widget.data.sex,
          dark: widget.dark,
          xLabel: T.txt('age'),
          yLabel: T.txt('heightCmShort'),
        );

      case _GrowthChartType.bmiAge:
        return _GrowthChartCard(
          title: T.txt('bmiForAgeChart'),
          description: T.txt('bmiForAgeChartDescription'),
          results: widget.data.bmiForAge,
          sex: widget.data.sex,
          dark: widget.dark,
          xLabel: T.txt('age'),
          yLabel: T.txt('bmiShort'),
        );

case _GrowthChartType.headAge:
  return _GrowthChartCard(
    title:
        T.txt(
      'headCircumferenceForAgeChart',
    ),
    description:
        T.txt(
      'headCircumferenceForAgeChartDescription',
    ),
    results:
        widget
            .data
            .headCircumferenceForAge,
    sex:
        widget
            .data
            .sex,
    dark:
        widget.dark,
    xLabel:
        T.txt(
      'age',
    ),
    yLabel:
        T.txt(
      'headCmShort',
    ),
  );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color color = Color(0xFF00A896);

    final Color childColor = widget.child.sex == ChildSex.girl
        ? Colors.pink
        : Colors.blue;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
        children: [
          // ==================================================================
          // PERFIL
          // ==================================================================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.dark ? const Color(0xFF211B2E) : Colors.white,
                  childColor.withValues(alpha: widget.dark ? 0.15 : 0.07),
                ],
              ),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: childColor.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                ChildAvatar(child: widget.child, size: 54, borderWidth: 2),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.child.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: widget.dark
                              ? Colors.white
                              : const Color(0xFF2D2D2D),
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        childAgeText(widget.child.birthDate),
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          color: widget.dark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.insert_chart_rounded,
                    color: color,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ==================================================================
          // NOTA OMS
          // ==================================================================
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withValues(alpha: widget.dark ? 0.13 : 0.07),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.health_and_safety_outlined, color: color),

                const SizedBox(width: 11),

                Expanded(
                  child: Text(
                    T.txt('whoGrowthReferenceNote'),
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 14,
                      height: 1.3,
                      color: widget.dark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==================================================================
          // TÍTULO SELECTOR
          // ==================================================================
          Text(
            T.txt('growthSelectorTitle'),
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: widget.dark ? Colors.white : const Color(0xFF4A2C82),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            T.txt('growthSelectorSubtitle'),
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 14,
              color: widget.dark ? Colors.white60 : Colors.black54,
            ),
          ),

          const SizedBox(height: 14),

          // ==================================================================
          // SELECTOR
          // ==================================================================
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _GrowthChartType.values.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final _GrowthChartType type = _GrowthChartType.values[index];

                final bool selected = _selected == type;

                final bool available = _isAvailable(type);

                return _ChartSelectorCard(
                  label: _selectorLabel(type),
                  icon: _selectorIcon(type),
                  selected: selected,
                  available: available,
                  dark: widget.dark,
                  onTap: available
                      ? () {
                          setState(() {
                            _selected = type;
                          });
                        }
                      : null,
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ==================================================================
          // SOLO UNA GRÁFICA A LA VEZ
          // ==================================================================
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.03, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_selected),
              child: _selectedChart(),
            ),
          ),

          // ==================================================================
          // CONTROLES OMITIDOS
          // ==================================================================
          if (widget.data.skippedMeasurements > 0) ...[
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.orange),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      T
                          .txt('growthSkippedMeasurements')
                          .replaceAll(
                            '{count}',
                            widget.data.skippedMeasurements.toString(),
                          ),
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        color: widget.dark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // ==================================================================
          // AVISO
          // ==================================================================
          Text(
            T.txt('growthChartDisclaimer'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 13,
              height: 1.3,
              color: widget.dark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TARJETA DEL SELECTOR
// ============================================================================

class _ChartSelectorCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFF00A896);

    final Color textColor = !available
        ? Colors.grey
        : selected
        ? Colors.white
        : dark
        ? Colors.white
        : const Color(0xFF2D2D2D);

    return Semantics(
      button: true,
      selected: selected,
      enabled: available,
      label: label,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: available ? 1 : 0.48,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(21),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(21),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 104,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: selected
                    ? selectedColor
                    : dark
                    ? const Color(0xFF211B2E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: selected
                      ? selectedColor
                      : available
                      ? selectedColor.withValues(alpha: 0.18)
                      : Colors.grey.withValues(alpha: 0.22),
                  width: selected ? 1.8 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: selectedColor.withValues(alpha: 0.22),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : const [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    available ? icon : Icons.lock_outline_rounded,
                    size: 28,
                    color: textColor,
                  ),

                  const SizedBox(height: 7),

                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
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

class _GrowthChartCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return _EmptyChartCard(title: title, dark: dark);
    }

    final GrowthChartConfig config = GrowthChartConfig(
      width: 900,
      height: 650,
      title: title,
      subtitle: T.txt('whoChildGrowthStandards'),
      xLabel: xLabel,
      yLabel: yLabel,
      theme: GrowthChartTheme.forSex(sex),
      displayMode: GrowthChartDisplayMode.zScore,
      showGridLines: true,
      showLegend: true,
      showResultCallout: true,
      showTrajectoryLine: true,
      zScoreLines: const <int>[-3, -2, -1, 0, 1, 2, 3],
    );

    late final String svg;

    try {
      final String generatedSvg = results.toSvg(config: config);

      svg = _translateGrowthSvg(generatedSvg);
    } catch (_) {
      return _ChartErrorCard(title: title, dark: dark);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF211B2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF00A896).withValues(alpha: 0.13),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: dark ? Colors.white : const Color(0xFF2D2D2D),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            description,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 14,
              color: dark ? Colors.white60 : Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            height: 430,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(100),
              child: SizedBox(
                width: 900,
                height: 650,
                child: SvgPicture.string(svg, fit: BoxFit.contain),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.zoom_in_rounded,
                size: 18,
                color: Color(0xFF00A896),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  T.txt('growthChartZoomHint'),
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 13,
                    color: dark ? Colors.white54 : Colors.black54,
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
// GRÁFICA SIN DATOS
// ============================================================================
class _EmptyChartCard extends StatelessWidget {
  final String title;
  final bool dark;

  const _EmptyChartCard({required this.title, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF211B2E) : Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_chart_outlined_rounded,
            color: Color(0xFF00A896),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  T.txt('growthChartNoData'),
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    color: dark ? Colors.white60 : Colors.black54,
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

class _ChartErrorCard extends StatelessWidget {
  final String title;
  final bool dark;

  const _ChartErrorCard({required this.title, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              '$title\n'
              '${T.txt('growthChartRenderError')}',
              style: TextStyle(
                fontFamily: 'Baloo2',
                color: dark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SIN CONTROLES
// ============================================================================

class _NoMeasurements extends StatelessWidget {
  final bool dark;

  const _NoMeasurements({required this.dark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_chart_outlined_rounded,
              size: 70,
              color: Color(0xFF00A896),
            ),

            const SizedBox(height: 18),

            Text(
              T.txt('growthChartsNoMeasurements'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: dark ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              T.txt('growthChartsNoMeasurementsSubtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Baloo2',
                color: dark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FUERA DE RANGO
// ============================================================================

class _NoValidMeasurements extends StatelessWidget {
  final bool dark;

  const _NoValidMeasurements({required this.dark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          T.txt('growthNoValidWhoMeasurements'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontSize: 16,
            color: dark ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
