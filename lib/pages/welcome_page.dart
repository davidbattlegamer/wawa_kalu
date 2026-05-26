import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_config.dart';
import 'app_texts.dart';
import 'widgets/config_sheet.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  bool mostrarImagenInicial = true;
  bool mostrarBoton = false;
  bool saliendo = false;
  bool presionando = false;

  late AnimationController imagenController;
  late AnimationController contenidoController;
  late AnimationController tituloController;
  late AnimationController botonController;

  late Animation<double> fadeImagen;
  late Animation<double> scaleImagen;

  late Animation<double> fadeContenido;
  late Animation<double> fadeBoton;
  late Animation<double> scaleBoton;

  late Animation<double> tituloScale;
  late Animation<double> tituloFade;

  @override
  void initState() {
    super.initState();

    imagenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    tituloController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    contenidoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    botonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    fadeImagen = CurvedAnimation(
      parent: imagenController,
      curve: Curves.easeOut,
    );

    scaleImagen = Tween<double>(
      begin: 1.05,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: imagenController,
        curve: Curves.easeOutCubic,
      ),
    );

    tituloScale = Tween<double>(
      begin: 0.80,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: tituloController,
        curve: Curves.elasticOut,
      ),
    );

    tituloFade = CurvedAnimation(
      parent: tituloController,
      curve: Curves.easeIn,
    );

    fadeContenido = CurvedAnimation(
      parent: contenidoController,
      curve: Curves.easeIn,
    );

    fadeBoton = CurvedAnimation(
      parent: botonController,
      curve: Curves.easeIn,
    );

    scaleBoton = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: botonController,
        curve: Curves.easeOutBack,
      ),
    );

    iniciarAnimacion();
  }

  Future<void> iniciarAnimacion() async {
    await imagenController.forward();

    if (!mounted) return;
    tituloController.forward();

    await Future.delayed(const Duration(milliseconds: 1900));

    if (!mounted) return;
    await imagenController.reverse();

    if (!mounted) return;
    setState(() {
      mostrarImagenInicial = false;
    });

    await contenidoController.forward();

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;
    setState(() {
      mostrarBoton = true;
    });

    botonController.forward();
  }

  Future<void> comenzar() async {
    if (saliendo) return;

    setState(() {
      presionando = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    setState(() {
      saliendo = true;
    });

    await Future.delayed(const Duration(milliseconds: 430));

    await AppConfig.marcarBienvenidaVista();
  }

  @override
  void dispose() {
    imagenController.dispose();
    contenidoController.dispose();
    tituloController.dispose();
    botonController.dispose();
    super.dispose();
  }

  Widget botonConfiguracion(bool modoOscuro) {
    return Positioned(
      top: 10,
      right: 10,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              showConfigSheet(context);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: modoOscuro
                    ? const Color(0xFF211B2E).withValues(alpha: 0.92)
                    : Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.deepPurple.withValues(alpha: 0.22),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.settings_rounded,
                size: 27,
                color: modoOscuro ? Colors.white : const Color(0xFF4A2C82),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tituloConImagen(bool modoOscuro, bool pantallaPequena) {
    final List<String> letras = ['W', 'a', 'w', 'a', ' ', 'K', 'a', 'l', 'ú'];

    return Column(
      children: [
        Text(
          T.txt('welcomeScreenTitle'),
          textAlign: TextAlign.center,
          style: GoogleFonts.baloo2(
            fontSize: pantallaPequena ? 19 : 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFEF476F),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        FadeTransition(
          opacity: tituloFade,
          child: ScaleTransition(
            scale: tituloScale,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 1,
              children: List.generate(letras.length, (index) {
                final letra = letras[index];

                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 520 + (index * 55)),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 18 * (1 - value)),
                      child: Transform.scale(
                        scale: value == 0 ? 0.7 : value,
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    letra,
                    style: GoogleFonts.fredoka(
                      fontSize: pantallaPequena ? 43 : 52,
                      fontWeight: FontWeight.w800,
                      color: modoOscuro
                          ? Colors.white
                          : const Color(0xFF4A2C82),
                      height: 1,
                      shadows: [
                        Shadow(
                          color: Colors.deepPurple.withValues(alpha: 0.18),
                          blurRadius: 9,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget pantallaImagenInicial(bool modoOscuro) {
    return Scaffold(
      backgroundColor:
          modoOscuro ? const Color(0xFF15131A) : const Color(0xFFFFF7EA),
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeImagen,
          child: ScaleTransition(
            scale: scaleImagen,
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool pantallaPequena =
                        constraints.maxHeight < 720 ||
                            constraints.maxWidth < 380;

                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        14,
                        pantallaPequena ? 42 : 54,
                        14,
                        pantallaPequena ? 18 : 28,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                'assets/images/familia_kalu.png',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          tituloConImagen(modoOscuro, pantallaPequena),
                          SizedBox(height: pantallaPequena ? 12 : 22),
                        ],
                      ),
                    );
                  },
                ),

                // Siempre encima para poder pulsarse
                botonConfiguracion(modoOscuro),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget seccionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool modoOscuro,
    required int index,
  }) {
    final bool desdeIzquierda = index.isEven;

    return AnimatedBuilder(
      animation: contenidoController,
      builder: (context, child) {
        final double inicio = index * 0.12;
        final double progreso =
            ((contenidoController.value - inicio) / (1 - inicio))
                .clamp(0.0, 1.0);

        final double curva = Curves.easeOutBack.transform(progreso);
        final double dx =
            desdeIzquierda ? -90 * (1 - curva) : 90 * (1 - curva);
        final double opacity = progreso.clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(dx, 0),
            child: Transform.scale(
              scale: 0.96 + (0.04 * opacity),
              child: child,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              modoOscuro
                  ? const Color(0xFF211B2E).withValues(alpha: 0.96)
                  : Colors.white.withValues(alpha: 0.96),
              color.withValues(alpha: modoOscuro ? 0.18 : 0.08),
            ],
            begin:
                desdeIzquierda ? Alignment.centerLeft : Alignment.centerRight,
            end: desdeIzquierda ? Alignment.centerRight : Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withValues(alpha: modoOscuro ? 0.32 : 0.18),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: modoOscuro ? 0.09 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.25),
                    color.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: color,
                size: 31,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fredoka(
                      fontSize: 18.5,
                      fontWeight: FontWeight.w700,
                      color:
                          modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.baloo2(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: modoOscuro ? Colors.white70 : Colors.black54,
                      height: 1.12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget botonComenzar() {
    return FadeTransition(
      opacity: fadeBoton,
      child: ScaleTransition(
        scale: scaleBoton,
        child: AnimatedScale(
          scale: presionando ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: saliendo
                    ? [
                        const Color(0xFF00A896),
                        const Color(0xFF7B2CBF),
                      ]
                    : [
                        const Color(0xFF7B2CBF),
                        const Color(0xFFFF006E),
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B2CBF).withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: comenzar,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    child: saliendo
                        ? Row(
                            key: const ValueKey('loading'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 21,
                                height: 21,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                T.txt('startingApp'),
                                style: GoogleFonts.fredoka(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey('start'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                T.txt('startApp'),
                                style: GoogleFonts.fredoka(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 25,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pantallaSecciones(bool modoOscuro) {
    return Scaffold(
      backgroundColor:
          modoOscuro ? const Color(0xFF15131A) : const Color(0xFFFFF7EA),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeTransition(
                opacity: fadeContenido,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool pantallaPequena = constraints.maxHeight < 720 ||
                        constraints.maxWidth < 380;

                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        22,
                        pantallaPequena ? 72 : 82,
                        22,
                        24,
                      ),
                      child: Column(
                        children: [
                          seccionCard(
                            icon: Icons.videogame_asset_rounded,
                            title: T.txt('games'),
                            subtitle: T.txt('gamesSubtitle'),
                            color: Colors.orange,
                            modoOscuro: modoOscuro,
                            index: 0,
                          ),
                          const SizedBox(height: 12),
                          seccionCard(
                            icon: Icons.smart_toy_rounded,
                            title: T.txt('cps'),
                            subtitle: T.txt('cpsSubtitle'),
                            color: Colors.deepPurple,
                            modoOscuro: modoOscuro,
                            index: 1,
                          ),
                          const SizedBox(height: 12),
                          seccionCard(
                            icon: Icons.restaurant_menu_rounded,
                            title: T.txt('nutrition'),
                            subtitle: T.txt('nutritionSubtitle'),
                            color: Colors.green,
                            modoOscuro: modoOscuro,
                            index: 2,
                          ),
                          const SizedBox(height: 12),
                          seccionCard(
                            icon: Icons.record_voice_over_rounded,
                            title: T.txt('languageMenu'),
                            subtitle: T.txt('languageSubtitle'),
                            color: Colors.pink,
                            modoOscuro: modoOscuro,
                            index: 3,
                          ),
                          const SizedBox(height: 12),
                          seccionCard(
                            icon: Icons.volunteer_activism_rounded,
                            title: T.txt('environment'),
                            subtitle: T.txt('environmentSubtitle'),
                            color: Colors.teal,
                            modoOscuro: modoOscuro,
                            index: 4,
                          ),
                          SizedBox(height: pantallaPequena ? 22 : 34),
                          if (mostrarBoton) botonComenzar(),
                          const SizedBox(height: 14),
                          if (mostrarBoton)
                            Text(
                              T.txt('welcomeSettingsNote'),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.baloo2(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: modoOscuro
                                    ? Colors.white60
                                    : Colors.black45,
                                height: 1.2,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Este va último y por encima del scroll
            botonConfiguracion(modoOscuro),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idiomaActual, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppConfig.temaApp,
          builder: (context, temaActual, _) {
            final bool modoOscuro =
                Theme.of(context).brightness == Brightness.dark;

            return AnimatedOpacity(
              opacity: saliendo ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 430),
              curve: Curves.easeInOut,
              child: mostrarImagenInicial
                  ? pantallaImagenInicial(modoOscuro)
                  : pantallaSecciones(modoOscuro),
            );
          },
        );
      },
    );
  }
}