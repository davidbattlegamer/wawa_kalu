import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/app_config.dart';
import '../pages/app_texts.dart';
import '../pages/home_page.dart';
import '../features/learning/pages/guia_familias_page.dart';
import '../pages/lenguaje_page.dart';
import '../pages/entorno_page.dart';
import '../features/children/pages/children_page.dart';
import '../features/health/pages/health_page.dart';

import 'widgets/liquid_glass_bottom_bar.dart';
import 'widgets/family_content_ui.dart';

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
      ChildrenPage(),
      HealthPage(),
      _LearningPage(),
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
                icon: Icons.child_care_outlined,
                selectedIcon: Icons.child_care_rounded,
                label: T.txt('navChildren'),
                color: const Color(0xFF3A86FF),
              ),

              LiquidGlassNavItem(
                icon: Icons.favorite_border_rounded,
                selectedIcon: Icons.favorite_rounded,
                label: T.txt('navHealth'),
                color: const Color(0xFFEF476F),
              ),

              LiquidGlassNavItem(
                icon: Icons.auto_stories_outlined,
                selectedIcon: Icons.auto_stories_rounded,
                label: T.txt('navLearning'),
                color: const Color(0xFFFF9F1C),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Página principal de Aprender: experiencias familiares fuera de pantalla.
class _LearningPage extends StatelessWidget {
  const _LearningPage();

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, language, _) => Scaffold(
        backgroundColor: FamilyUi.dark(context)
            ? FamilyUi.canvasDark : FamilyUi.canvasLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: FamilyUi.dark(context)
              ? FamilyUi.surfaceDark : Colors.white,
          title: Text(T.txt('learning'),
            style: TextStyle(fontFamily: 'Fredoka', fontSize: 24,
              fontWeight: FontWeight.w800, color: FamilyUi.ink(context))),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 125),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FamilyHero(
                      eyebrow: T.txt('learning'),
                      title: T.txt('learningHeaderTitle'),
                      subtitle: T.txt('learningHeaderSubtitle'),
                      icon: Icons.auto_stories_rounded,
                      color: const Color(0xFF7544BC),
                      accent: const Color(0xFFEE8B76),
                    ),
                    const SizedBox(height: 28),
                    FamilySectionHeading(
                      title: T.txt('learningExploreTitle'),
                      subtitle: T.txt('learningExploreSubtitle'),
                      icon: Icons.auto_awesome_rounded,
                    ),
                    FamilyTopicCard(
                      title: T.txt('familyGuide'),
                      subtitle: T.txt('learningGuideSubtitle'),
                      icon: Icons.menu_book_rounded,
                      color: const Color(0xFF8B5CD6),
                      badge: T.txt('learningFeatured'),
                      featured: true,
                      onTap: () => _open(context, const GuiaFamiliasPage()),
                    ),
                    FamilyTopicCard(
                      title: T.txt('languageMenu'),
                      subtitle: T.txt('learningLanguageSubtitle'),
                      icon: Icons.record_voice_over_rounded,
                      color: const Color(0xFFDA5B93),
                      onTap: () => _open(context, const LenguajePage()),
                    ),
                    FamilyTopicCard(
                      title: T.txt('protectiveEnvironments'),
                      subtitle: T.txt('learningEnvironmentSubtitle'),
                      icon: Icons.volunteer_activism_rounded,
                      color: const Color(0xFF269B90),
                      onTap: () => _open(context, const EntornoPage()),
                    ),
                    const SizedBox(height: 11),
                    FamilyNotice(
                      text: T.txt('learningFamilyNotice'),
                      color: const Color(0xFF9A75D1),
                      icon: Icons.favorite_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
