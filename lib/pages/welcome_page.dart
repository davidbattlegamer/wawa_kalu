import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_texts.dart';
import 'widgets/config_sheet.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  State<WelcomePage> createState() =>
      _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _starting = false;
  bool _pressing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(
        0,
        0.08,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // COMENZAR
  // ============================================================

  Future<void> _startApp() async {
    if (_starting) {
      return;
    }

    setState(() {
      _pressing = true;
    });

    await Future<void>.delayed(
      const Duration(
        milliseconds: 110,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _pressing = false;
      _starting = true;
    });

    await Future<void>.delayed(
      const Duration(
        milliseconds: 420,
      ),
    );

    await AppConfig.marcarBienvenidaVista();
  }

  // ============================================================
  // CONFIGURACIÓN
  // ============================================================

  Widget _settingsButton({
    required bool dark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        onTap: () {
          showConfigSheet(
            context,
          );
        },
        child: Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: dark
                ? const Color(
                    0xFF211B2E,
                  )
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  const Color(
                0xFF7B2CBF,
              ).withValues(
                alpha: 0.18,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(
                  alpha:
                      dark ? 0.18 : 0.08,
                ),
                blurRadius: 12,
                offset:
                    const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),
          child: Icon(
            Icons.settings_rounded,
            color: dark
                ? Colors.white
                : const Color(
                    0xFF4A2C82,
                  ),
            size: 26,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _logo({
    required bool dark,
    required bool smallScreen,
  }) {
    final double size =
        smallScreen ? 145 : 185;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: size,
        height: size,
        padding:
            const EdgeInsets.all(
          14,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              const Color(
                0xFF7B2CBF,
              ).withValues(
                alpha:
                    dark ? 0.22 : 0.10,
              ),
              const Color(
                0xFFFF006E,
              ).withValues(
                alpha:
                    dark ? 0.15 : 0.06,
              ),
              const Color(
                0xFF00A896,
              ).withValues(
                alpha:
                    dark ? 0.15 : 0.06,
              ),
            ],
          ),
          border: Border.all(
            color:
                const Color(
              0xFF7B2CBF,
            ).withValues(
              alpha: 0.14,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(
                0xFF7B2CBF,
              ).withValues(
                alpha:
                    dark ? 0.16 : 0.12,
              ),
              blurRadius: 28,
              spreadRadius: 2,
              offset:
                  const Offset(
                0,
                10,
              ),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/familia_kalu.png',
          fit: BoxFit.contain,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return const Icon(
              Icons.child_care_rounded,
              size: 90,
              color:
                  Color(
                0xFF7B2CBF,
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // TARJETA DE FUNCIÓN
  // ============================================================

  Widget _featureCard({
    required bool dark,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),
      decoration: BoxDecoration(
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
                  dark ? 0.15 : 0.06,
            ),
          ],
          begin:
              Alignment.centerLeft,
          end:
              Alignment.centerRight,
        ),
        borderRadius:
            BorderRadius.circular(
          21,
        ),
        border: Border.all(
          color:
              color.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontSize: 17,
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
                  height: 2,
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
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
        ],
      ),
    );
  }

  // ============================================================
  // BOTÓN COMENZAR
  // ============================================================

  Widget _startButton() {
    return AnimatedScale(
      scale:
          _pressing ? 0.97 : 1,
      duration:
          const Duration(
        milliseconds: 110,
      ),
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 300,
        ),
        width:
            double.infinity,
        height: 59,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(
            begin:
                Alignment.centerLeft,
            end:
                Alignment.centerRight,
            colors: _starting
                ? const [
                    Color(
                      0xFF00A896,
                    ),
                    Color(
                      0xFF118AB2,
                    ),
                  ]
                : const [
                    Color(
                      0xFF7B2CBF,
                    ),
                    Color(
                      0xFFFF006E,
                    ),
                  ],
          ),
          borderRadius:
              BorderRadius.circular(
            22,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(
                0xFF7B2CBF,
              ).withValues(
                alpha: 0.25,
              ),
              blurRadius: 18,
              offset:
                  const Offset(
                0,
                8,
              ),
            ),
          ],
        ),
        child: Material(
          color:
              Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            22,
          ),
          child: InkWell(
            onTap:
                _starting
                    ? null
                    : _startApp,
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            child: Center(
              child:
                  AnimatedSwitcher(
                duration:
                    const Duration(
                  milliseconds:
                      250,
                ),
                child: _starting
                    ? Row(
                        key:
                            const ValueKey(
                          'starting',
                        ),
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          const SizedBox(
                            width: 21,
                            height: 21,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.4,
                              color:
                                  Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                          Text(
                            T.txt(
                              'startingApp',
                            ),
                            style:
                                const TextStyle(
                              fontFamily:
                                  'Fredoka',
                              fontSize:
                                  19,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color:
                                  Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        key:
                            const ValueKey(
                          'start',
                        ),
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Text(
                            T.txt(
                              'startApp',
                            ),
                            style:
                                const TextStyle(
                              fontFamily:
                                  'Fredoka',
                              fontSize:
                                  20,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color:
                                  Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            Icons
                                .arrow_forward_rounded,
                            color:
                                Colors.white,
                            size: 24,
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

  // ============================================================
  // CONTENIDO
  // ============================================================

  Widget _content({
    required bool dark,
  }) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool smallScreen =
            constraints.maxHeight <
                    760 ||
                constraints.maxWidth <
                    380;

        return SingleChildScrollView(
          padding:
              EdgeInsets.fromLTRB(
            22,
            smallScreen
                ? 18
                : 26,
            22,
            30,
          ),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(
              minHeight:
                  constraints
                          .maxHeight -
                      48,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children: [
                // ================================================
                // LOGO
                // ================================================

                _logo(
                  dark: dark,
                  smallScreen:
                      smallScreen,
                ),

                SizedBox(
                  height:
                      smallScreen
                          ? 16
                          : 20,
                ),

                // ================================================
                // BIENVENIDA
                // ================================================

                Text(
                  T.txt(
                    'welcomeScreenTitle',
                  ),
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(
                      0xFFEF476F,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 1,
                ),

                // ================================================
                // NOMBRE
                // ================================================

                Text(
                  T.txt(
                    'appName',
                  ),
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontSize:
                        smallScreen
                            ? 39
                            : 45,
                    height: 1,
                    fontWeight:
                        FontWeight.w900,
                    color: dark
                        ? Colors.white
                        : const Color(
                            0xFF4A2C82,
                          ),
                    shadows: [
                      Shadow(
                        color:
                            const Color(
                          0xFF7B2CBF,
                        ).withValues(
                          alpha: 0.12,
                        ),
                        blurRadius: 8,
                        offset:
                            const Offset(
                          0,
                          3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 9,
                ),

                // ================================================
                // SUBTÍTULO
                // ================================================

                Text(
                  T.txt(
                    'subtitle',
                  ),
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize:
                        smallScreen
                            ? 15
                            : 16.5,
                    fontWeight:
                        FontWeight.w600,
                    height: 1.25,
                    color: dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),

                SizedBox(
                  height:
                      smallScreen
                          ? 22
                          : 28,
                ),

                // ================================================
                // FUNCIONES PRINCIPALES
                // ================================================

                _featureCard(
                  dark: dark,
                  icon:
                      Icons.child_care_rounded,
                  color:
                      const Color(
                    0xFF118AB2,
                  ),
                  title:
                      T.txt(
                    'myChildren',
                  ),
                  subtitle:
                      T.txt(
                    'childrenHeaderSubtitle',
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                _featureCard(
                  dark: dark,
                  icon:
                      Icons.vaccines_rounded,
                  color:
                      const Color(
                    0xFF7B2CBF,
                  ),
                  title:
                      T.txt(
                    'vaccines',
                  ),
                  subtitle:
                      T.txt(
                    'vaccinesSubtitle',
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                _featureCard(
                  dark: dark,
                  icon:
                      Icons.show_chart_rounded,
                  color:
                      const Color(
                    0xFF00A896,
                  ),
                  title:
                      T.txt(
                    'growth',
                  ),
                  subtitle:
                      T.txt(
                    'growthSubtitle',
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                _featureCard(
                  dark: dark,
                  icon:
                      Icons.extension_rounded,
                  color:
                      Colors.orange,
                  title:
                      T.txt(
                    'learning',
                  ),
                  subtitle:
                      T.txt(
                    'learningHeaderSubtitle',
                  ),
                ),

                SizedBox(
                  height:
                      smallScreen
                          ? 22
                          : 28,
                ),

                // ================================================
                // COMENZAR
                // ================================================

                _startButton(),

                const SizedBox(
                  height: 13,
                ),

                // ================================================
                // NOTA
                // ================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Icon(
                      Icons
                          .shield_outlined,
                      size: 17,
                      color: dark
                          ? Colors.white38
                          : const Color(
                              0xFF00A896,
                            ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        T.txt(
                          'welcomeSettingsNote',
                        ),
                        textAlign:
                            TextAlign.center,
                        style:
                            TextStyle(
                          fontFamily:
                              'Baloo2',
                          fontSize: 12.5,
                          height: 1.2,
                          color: dark
                              ? Colors.white54
                              : Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

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
        return ValueListenableBuilder<
            ThemeMode>(
          valueListenable:
              AppConfig.temaApp,
          builder: (
            context,
            themeMode,
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
                      0xFFFFF9F1,
                    ),
              body: SafeArea(
                child: Stack(
                  children: [
                    // ============================================
                    // DECORACIÓN SUPERIOR
                    // ============================================

                    Positioned(
                      top: -85,
                      left: -75,
                      child: IgnorePointer(
                        child: Container(
                          width: 210,
                          height: 210,
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,
                            color:
                                const Color(
                              0xFF7B2CBF,
                            ).withValues(
                              alpha: dark
                                  ? 0.08
                                  : 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // DECORACIÓN INFERIOR
                    // ============================================

                    Positioned(
                      right: -90,
                      bottom: -100,
                      child: IgnorePointer(
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,
                            color:
                                const Color(
                              0xFF00A896,
                            ).withValues(
                              alpha: dark
                                  ? 0.08
                                  : 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // CONTENIDO ANIMADO
                    // ============================================

                    Positioned.fill(
                      child:
                          FadeTransition(
                        opacity:
                            _fadeAnimation,
                        child:
                            SlideTransition(
                          position:
                              _slideAnimation,
                          child:
                              _content(
                            dark:
                                dark,
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // CONFIGURACIÓN
                    // ============================================

                    Positioned(
                      top: 8,
                      right: 12,
                      child:
                          _settingsButton(
                        dark: dark,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}