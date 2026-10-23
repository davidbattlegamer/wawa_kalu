import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/app_config.dart';
import '../pages/app_texts.dart';
import '../pages/home_page.dart';
import '../features/learning/pages/guia_familias_page.dart';
import '../features/children/pages/children_page.dart';
import '../features/health/pages/health_page.dart';

import 'widgets/app_tour_overlay.dart';
import 'widgets/liquid_glass_bottom_bar.dart';
import 'widgets/tour_targets.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _paginaActual = 0;
  int? _tourStep;
  late final List<Widget> _paginas;

  // Las claves permiten resaltar el botón auténtico de cada pestaña
  // sin modificar su aspecto ni los gestos de navegación.
  final GlobalKey _tourRootKey = GlobalKey(debugLabel: 'tour_root');
  final List<GlobalKey> _tabKeys = List<GlobalKey>.generate(
    4,
    (index) => GlobalKey(debugLabel: 'tour_tab_$index'),
  );

  @override
  void initState() {
    super.initState();
    _paginas = const [
      HomePage(),
      GuiaFamiliasPage(),
      HealthPage(),
      ChildrenPage(),
    ];

    AppConfig.recorridoSolicitud.addListener(_repeatTour);

    // Solo se abre tras entrar por primera vez a la aplicación desde
    // la bienvenida existente; nunca se marca visto hasta finalizar u omitir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !AppConfig.recorridoVisto.value) {
        _startTour();
      }
    });
  }

  @override
  void dispose() {
    AppConfig.recorridoSolicitud.removeListener(_repeatTour);
    super.dispose();
  }

  void _startTour() {
    if (!mounted) return;
    setState(() {
      _paginaActual = 0;
      _tourStep = 0;
    });
  }

  void _repeatTour() {
    _startTour();
  }

  void _tourGoTo(int step) {
    if (step < 0) return;
    if (step >= AppTourOverlay.stepCount) {
      _closeTour();
      return;
    }

    const destinations = <int>[0, 3, 2, 1, 0];
    HapticFeedback.selectionClick();
    setState(() {
      _tourStep = step;
      _paginaActual = destinations[step];
    });

    // Asegura que se midan los controles de la nueva pestaña
    // antes de ubicar su foco visual.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _tourStep == step) setState(() {});
    });
  }

  Future<void> _closeTour() async {
    if (_tourStep == null) return;
    setState(() {
      _tourStep = null;
      _paginaActual = 0;
    });
    await AppConfig.marcarRecorridoVisto();
  }

  Rect? _focusRect(int step) {
    if (step == 0) return null;

    final GlobalKey target = switch (step) {
      1 => _tabKeys[3],
      2 => _tabKeys[2],
      3 => _tabKeys[1],
      4 => TourTargets.settingsButton,
      _ => _tabKeys[0],
    };

    final root = _tourRootKey.currentContext?.findRenderObject();
    final object = target.currentContext?.findRenderObject();

    if (root is! RenderBox ||
        object is! RenderBox ||
        !root.hasSize ||
        !object.hasSize) {
      return null;
    }

    final offset = object.localToGlobal(Offset.zero, ancestor: root);
    return offset & object.size;
  }

  void _cambiarPagina(int index) {
    if (_paginaActual == index) return;

    HapticFeedback.selectionClick();
    setState(() => _paginaActual = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool modoOscuro =
        Theme.of(context).brightness == Brightness.dark;

    return Stack(
      key: _tourRootKey,
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: modoOscuro
              ? const Color(0xFF15131A)
              : const Color(0xFFFAF7F2),
          body: IndexedStack(
            index: _paginaActual,
            children: _paginas,
          ),
          bottomNavigationBar: ValueListenableBuilder<String>(
            valueListenable: AppConfig.idioma,
            builder: (context, idiomaActual, _) {
              return LiquidGlassBottomBar(
                selectedIndex: _paginaActual,
                onSelected: _cambiarPagina,
                darkMode: modoOscuro,
                itemKeys: _tabKeys,
                items: [
                  LiquidGlassNavItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: T.txt('navHome'),
                    color: const Color(0xFF7B2CBF),
                  ),
                  LiquidGlassNavItem(
                    icon: Icons.auto_stories_outlined,
                    selectedIcon: Icons.auto_stories_rounded,
                    label: T.txt('navLearning'),
                    color: const Color(0xFFFF9F1C),
                  ),
                  LiquidGlassNavItem(
                    icon: Icons.favorite_border_rounded,
                    selectedIcon: Icons.favorite_rounded,
                    label: T.txt('navHealth'),
                    color: const Color(0xFFEF476F),
                  ),
                  LiquidGlassNavItem(
                    icon: Icons.child_care_outlined,
                    selectedIcon: Icons.child_care_rounded,
                    label: T.txt('navChildren'),
                    color: const Color(0xFF6E56C6),
                  ),
                ],
              );
            },
          ),
        ),
        if (_tourStep case final int step)
          Positioned.fill(
            child: AppTourOverlay(
              step: step,
              focusRect: _focusRect(step),
              onBack: () => _tourGoTo(step - 1),
              onNext: () => _tourGoTo(step + 1),
              onSkip: _closeTour,
            ),
          ),
      ],
    );
  }
}
