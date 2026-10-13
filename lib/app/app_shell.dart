import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/app_config.dart';
import '../pages/app_texts.dart';
import '../pages/home_page.dart';
import '../features/learning/pages/learning_hub_page.dart';
import '../features/children/pages/children_page.dart';
import '../features/health/pages/health_page.dart';

import 'widgets/liquid_glass_bottom_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _paginaActual = 0;

  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = const [
      HomePage(),
      LearningHubPage(),
      HealthPage(),
      ChildrenPage(),
    ];
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

    return Scaffold(
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
    );
  }
}
