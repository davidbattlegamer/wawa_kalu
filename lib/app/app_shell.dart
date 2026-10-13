import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/app_config.dart';
import '../pages/app_texts.dart';
import '../pages/home_page.dart';
import '../pages/juego_page.dart';
import '../pages/lenguaje_page.dart';
import '../pages/entorno_page.dart';
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

// APRENDER
class _LearningPage extends StatelessWidget {
  const _LearningPage();

  @override
  Widget build(BuildContext context) {
    final bool modoOscuro = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,

      builder: (context, idiomaActual, _) {
        return Scaffold(
          backgroundColor: modoOscuro
              ? const Color(0xFF15131A)
              : const Color(0xFFFAF7F2),

          appBar: AppBar(
            automaticallyImplyLeading: false,

            elevation: 0,

            backgroundColor: modoOscuro
                ? const Color(0xFF211B2E)
                : Colors.white,

            title: Text(
              T.txt('learning'),

              style: TextStyle(
                fontFamily: 'Fredoka',

                fontSize: 24,

                fontWeight: FontWeight.w700,

                color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              // Espacio extra para que la barra
              // flotante no tape el contenido.
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    T.txt('learningHeaderTitle'),

                    style: TextStyle(
                      fontFamily: 'Fredoka',

                      fontSize: 26,

                      fontWeight: FontWeight.w700,

                      color: modoOscuro
                          ? Colors.white
                          : const Color(0xFF4A2C82),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    T.txt('learningHeaderSubtitle'),

                    style: TextStyle(
                      fontFamily: 'Baloo2',

                      fontSize: 16,

                      height: 1.25,

                      color: modoOscuro ? Colors.white70 : Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==========================================================
                  // JUEGOS
                  // ==========================================================
                  _LearningCard(
                    icon: Icons.menu_book_rounded,

                    title: T.txt('games'),

                    subtitle: T.txt('learningGamesSubtitle'),

                    color: const Color(0xFF8054D7),

                    modoOscuro: modoOscuro,

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (_) => const JuegoPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // ==========================================================
                  // LENGUAJE
                  // ==========================================================
                  _LearningCard(
                    icon: Icons.record_voice_over_rounded,

                    title: T.txt('languageMenu'),

                    subtitle: T.txt('learningLanguageSubtitle'),

                    color: Colors.pink,

                    modoOscuro: modoOscuro,

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (_) => const LenguajePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // ==========================================================
                  // ENTORNOS PROTECTORES
                  // ==========================================================
                  _LearningCard(
                    icon: Icons.volunteer_activism_rounded,

                    title: T.txt('protectiveEnvironments'),

                    subtitle: T.txt('learningEnvironmentSubtitle'),

                    color: Colors.teal,

                    modoOscuro: modoOscuro,

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (_) => const EntornoPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// TARJETA DE APRENDER
// ============================================================================

class _LearningCard extends StatelessWidget {
  final IconData icon;

  final String title;
  final String subtitle;

  final Color color;

  final bool modoOscuro;

  final VoidCallback onTap;

  const _LearningCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.modoOscuro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      borderRadius: BorderRadius.circular(24),

      child: InkWell(
        borderRadius: BorderRadius.circular(24),

        onTap: onTap,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(17),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                modoOscuro ? const Color(0xFF211B2E) : Colors.white,

                color.withValues(alpha: modoOscuro ? 0.18 : 0.09),
              ],
            ),

            borderRadius: BorderRadius.circular(24),

            border: Border.all(
              color: color.withValues(alpha: 0.20),

              width: 1.4,
            ),

            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),

                blurRadius: 12,

                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 58,

                height: 58,

                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(icon, color: color, size: 31),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        fontFamily: 'Fredoka',

                        fontSize: 19,

                        fontWeight: FontWeight.w700,

                        color: modoOscuro
                            ? Colors.white
                            : const Color(0xFF2D2D2D),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      style: TextStyle(
                        fontFamily: 'Baloo2',

                        fontSize: 14.5,

                        height: 1.2,

                        color: modoOscuro ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right_rounded, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
