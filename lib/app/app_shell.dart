import 'dart:ui';

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

// ============================================================================
// APP SHELL
// ============================================================================

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

  // ==========================================================================
  // CAMBIAR PÁGINA
  // ==========================================================================

  void _cambiarPagina(int index) {
    if (_paginaActual == index) {
      return;
    }

    // Pequeña respuesta táctil estilo iOS.
    HapticFeedback.selectionClick();

    setState(() {
      _paginaActual = index;
    });
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final bool modoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Permite que el contenido continúe detrás
      // de la barra flotante de cristal.
      extendBody: true,

      backgroundColor: modoOscuro
          ? const Color(0xFF15131A)
          : const Color(0xFFFAF7F2),

      body: IndexedStack(index: _paginaActual, children: _paginas),

      // ======================================================================
      // LIQUID GLASS NAVIGATION
      // ======================================================================
      bottomNavigationBar: ValueListenableBuilder<String>(
        valueListenable: AppConfig.idioma,
        builder: (context, idiomaActual, _) {
          return _LiquidGlassNavigationBar(
            currentIndex: _paginaActual,
            dark: modoOscuro,
            onTap: _cambiarPagina,
          );
        },
      ),
<<<<<<< HEAD
    );
  }
}

// ============================================================================
// LIQUID GLASS NAVIGATION BAR
// ============================================================================

class _LiquidGlassNavigationBar extends StatelessWidget {
  final int currentIndex;
  final bool dark;
  final ValueChanged<int> onTap;

  const _LiquidGlassNavigationBar({
    required this.currentIndex,
    required this.dark,
    required this.onTap,
  });

  // ==========================================================================
  // COLOR DE CADA SECCIÓN
  // ==========================================================================

  static const List<Color> _sectionColors = <Color>[
    Color(0xFF7B2CBF), // Inicio - morado

    Color(0xFF3A86FF), // Mis niños - azul

    Color(0xFFEF476F), // Salud - rosado

    Color(0xFFFF9F1C), // Aprender - naranja
  ];

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = _sectionColors[currentIndex];

    return SafeArea(
      top: false,

      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),

      child: Container(
        height: 82,

        // ====================================================================
        // SOMBRA EXTERIOR
        // ====================================================================
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(31),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.35 : 0.13),
              blurRadius: 35,
              spreadRadius: -6,
              offset: const Offset(0, 13),
            ),

            // Resplandor suave
            // basado en la sección activa.
            BoxShadow(
              color: selectedColor.withValues(alpha: dark ? 0.13 : 0.09),
              blurRadius: 34,
              spreadRadius: -8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        // ====================================================================
        // RECORTE DEL VIDRIO
        // ====================================================================
        child: ClipRRect(
          borderRadius: BorderRadius.circular(31),

          child: BackdropFilter(
            // =================================================================
            // BLUR REAL DEL CONTENIDO
            // =================================================================
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(31),

                // =============================================================
                // CRISTAL
                // =============================================================
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: dark
                      ? [
                          Colors.white.withValues(alpha: 0.145),
                          Colors.white.withValues(alpha: 0.075),
                          Colors.black.withValues(alpha: 0.13),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.76),
                          Colors.white.withValues(alpha: 0.45),
                          Colors.white.withValues(alpha: 0.28),
                        ],
                ),

                // =============================================================
                // BORDE BRILLANTE
                // =============================================================
                border: Border.all(
                  color: Colors.white.withValues(alpha: dark ? 0.20 : 0.76),
                  width: 1.15,
                ),
              ),

              child: Stack(
                children: [
                  // ===========================================================
                  // RESPLANDOR SUPERIOR PRINCIPAL
                  // ===========================================================
                  Positioned(
                    top: 1,
                    left: 25,
                    right: 25,

                    child: IgnorePointer(
                      child: Container(
                        height: 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(
                                alpha: dark ? 0.34 : 0.95,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ===========================================================
                  // LUZ AMBIENTAL SUPERIOR
                  // ===========================================================
                  Positioned(
                    top: -28,
                    left: 30,
                    right: 30,

                    child: IgnorePointer(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(
                                alpha: dark ? 0.045 : 0.20,
                              ),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ===========================================================
                  // NAVEGACIÓN
                  // ===========================================================
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double itemWidth = constraints.maxWidth / 4;

                      return Stack(
                        children: [
                          // ===================================================
                          // BURBUJA DE VIDRIO ANIMADA
                          // ===================================================
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 430),

                            curve: Curves.easeOutCubic,

                            left: currentIndex * itemWidth + 5,

                            top: 6,

                            bottom: 6,

                            width: itemWidth - 10,

                            child: _LiquidSelectedBubble(
                              color: selectedColor,
                              dark: dark,
                            ),
                          ),

                          // ===================================================
                          // BOTONES
                          // ===================================================
                          Row(
                            children: [
                              Expanded(
                                child: _LiquidNavItem(
                                  index: 0,
                                  currentIndex: currentIndex,

                                  icon: Icons.home_outlined,

                                  selectedIcon: Icons.home_rounded,

                                  label: T.txt('navHome'),

                                  color: _sectionColors[0],

                                  dark: dark,

                                  onTap: onTap,
                                ),
                              ),

                              Expanded(
                                child: _LiquidNavItem(
                                  index: 1,
                                  currentIndex: currentIndex,

                                  icon: Icons.child_care_outlined,

                                  selectedIcon: Icons.child_care_rounded,

                                  label: T.txt('navChildren'),

                                  color: _sectionColors[1],

                                  dark: dark,

                                  onTap: onTap,
                                ),
                              ),

                              Expanded(
                                child: _LiquidNavItem(
                                  index: 2,
                                  currentIndex: currentIndex,

                                  icon: Icons.favorite_border_rounded,

                                  selectedIcon: Icons.favorite_rounded,

                                  label: T.txt('navHealth'),

                                  color: _sectionColors[2],

                                  dark: dark,

                                  onTap: onTap,
                                ),
                              ),

                              Expanded(
                                child: _LiquidNavItem(
                                  index: 3,
                                  currentIndex: currentIndex,

                                  icon: Icons.auto_stories_outlined,

                                  selectedIcon: Icons.auto_stories_rounded,

                                  label: T.txt('navLearning'),

                                  color: _sectionColors[3],

                                  dark: dark,

                                  onTap: onTap,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
=======
      extendBody: true,
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
                color: const Color(0xFF8E44AD),
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
>>>>>>> feec5014802cf283e11411c8aefd3d2aaaecbef5
      ),
    );
  }
}

// ============================================================================
// BURBUJA LIQUID GLASS SELECCIONADA
// ============================================================================

class _LiquidSelectedBubble extends StatelessWidget {
  final Color color;
  final bool dark;

  const _LiquidSelectedBubble({required this.color, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        // ====================================================================
        // TONO INTERNO DEL VIDRIO
        // ====================================================================
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Colors.white.withValues(alpha: dark ? 0.18 : 0.76),

            color.withValues(alpha: dark ? 0.24 : 0.15),

            Colors.white.withValues(alpha: dark ? 0.055 : 0.30),
          ],
        ),

        // ====================================================================
        // BORDE INTERIOR
        // ====================================================================
        border: Border.all(
          color: Colors.white.withValues(alpha: dark ? 0.22 : 0.82),
          width: 1.1,
        ),

        // ====================================================================
        // SOMBRAS DE LA BURBUJA
        // ====================================================================
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: dark ? 0.26 : 0.16),
            blurRadius: 18,
            spreadRadius: -4,
            offset: const Offset(0, 7),
          ),

          BoxShadow(
            color: Colors.white.withValues(alpha: dark ? 0.055 : 0.48),
            blurRadius: 5,
            spreadRadius: -1,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Stack(
        children: [
          // ==================================================================
          // REFLEJO SUPERIOR
          // ==================================================================
          Positioned(
            top: 3,
            left: 14,
            right: 14,

            child: Container(
              height: 1.4,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),

                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,

                    Colors.white.withValues(alpha: dark ? 0.25 : 0.90),

                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ==================================================================
          // REFLEJO IZQUIERDO
          // ==================================================================
          Positioned(
            top: 13,
            left: 4,

            child: Container(
              width: 1.8,
              height: 25,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                color: Colors.white.withValues(alpha: dark ? 0.10 : 0.40),
              ),
            ),
          ),

          // ==================================================================
          // BRILLO INTERIOR
          // ==================================================================
          Positioned(
            bottom: -8,
            right: -6,

            child: Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: dark ? 0.11 : 0.08),
                    blurRadius: 18,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTÓN INDIVIDUAL
// ============================================================================

class _LiquidNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;

  final IconData icon;
  final IconData selectedIcon;

  final String label;

  final Color color;
  final bool dark;

  final ValueChanged<int> onTap;

  const _LiquidNavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.color,
    required this.dark,
    required this.onTap,
  });

  bool get selected => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = dark
        ? Colors.white.withValues(alpha: 0.63)
        : const Color(0xFF3C3C43).withValues(alpha: 0.68);

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          onTap(index);
        },

        splashColor: color.withValues(alpha: 0.06),

        highlightColor: Colors.transparent,

        child: AnimatedScale(
          duration: const Duration(milliseconds: 280),

          curve: Curves.easeOutCubic,

          scale: selected ? 1.0 : 0.965,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // ==============================================================
              // ICONO
              // ==============================================================
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                curve: Curves.easeOutCubic,

                width: selected ? 31 : 28,

                height: selected ? 31 : 28,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.25),
                            blurRadius: 14,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),

                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),

                  switchInCurve: Curves.easeOutBack,

                  switchOutCurve: Curves.easeIn,

                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,

                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },

                  child: Icon(
                    selected ? selectedIcon : icon,

                    key: ValueKey<bool>(selected),

                    size: selected ? 25 : 23,

                    color: selected ? color : inactiveColor,
                  ),
                ),
              ),

              const SizedBox(height: 3),

              // ==============================================================
              // TEXTO
              // ==============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),

                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 280),

                  curve: Curves.easeOutCubic,

                  style: TextStyle(
                    fontFamily: 'Fredoka',

                    fontSize: selected ? 11.7 : 11,

                    height: 1,

                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,

                    color: selected ? color : inactiveColor,
                  ),

                  child: FittedBox(
                    fit: BoxFit.scaleDown,

                    child: Text(label, maxLines: 1),
                  ),
                ),
              ),

              // ==============================================================
              // PEQUEÑO PUNTO DE LUZ
              // ==============================================================
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),

                margin: const EdgeInsets.only(top: 3),

                width: selected ? 4 : 0,

                height: selected ? 4 : 0,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: color,

                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.55),
                            blurRadius: 7,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// APRENDER
// ============================================================================

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
                    icon: Icons.videogame_asset_rounded,

                    title: T.txt('games'),

                    subtitle: T.txt('learningGamesSubtitle'),

                    color: Colors.orange,

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
