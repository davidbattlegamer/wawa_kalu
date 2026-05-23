import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

import 'app_config.dart';
import 'app_texts.dart';

import 'juego_page.dart';
import 'nutricion_page.dart';
import 'cps_page.dart';
import 'lenguaje_page.dart';
import 'entorno_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<HomeItem> _getItems() {
    return [
      HomeItem(
        title: T.txt('cps'),
        subtitle: T.txt('cpsSubtitle'),
        icon: Icons.smart_toy,
        color: Colors.deepPurple,
        page: const CpsPage(),
      ),
      HomeItem(
        title: T.txt('games'),
        subtitle: T.txt('gamesSubtitle'),
        icon: Icons.videogame_asset,
        color: Colors.orange,
        page: const JuegoPage(),
      ),
      HomeItem(
        title: T.txt('nutrition'),
        subtitle: T.txt('nutritionSubtitle'),
        icon: Icons.restaurant_menu,
        color: Colors.green,
        page: const NutricionPage(),
      ),
      HomeItem(
        title: T.txt('languageMenu'),
        subtitle: T.txt('languageSubtitle'),
        icon: Icons.record_voice_over,
        color: Colors.pink,
        page: const LenguajePage(),
      ),
      HomeItem(
        title: T.txt('environment'),
        subtitle: T.txt('environmentSubtitle'),
        icon: Icons.volunteer_activism,
        color: Colors.teal,
        page: const EntornoPage(),
      ),
    ];
  }

  Future<void> vibrarActivacionFuerte() async {
    try {
      if (!kIsWeb) {
        final bool tieneVibrador = await Vibration.hasVibrator();

        if (tieneVibrador) {
          await Vibration.vibrate(
            pattern: [0, 160, 70, 160],
          );
          return;
        }
      }

      await HapticFeedback.heavyImpact();
    } catch (_) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  void mostrarConfiguracion(BuildContext context) {
    final temaActual = AppConfig.temaApp.value;
    final bool modoOscuroInicial = temaActual == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          modoOscuroInicial ? const Color(0xFF15131A) : const Color(0xFFFAF7F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        final altoPantalla = MediaQuery.of(context).size.height;

        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppConfig.temaApp,
          builder: (context, temaActual, _) {
            final bool modoOscuro = temaActual == ThemeMode.dark;

            final Color fondoModal =
                modoOscuro ? const Color(0xFF15131A) : const Color(0xFFFAF7F2);

            final Color textoPrincipal =
                modoOscuro ? Colors.white : const Color(0xFF2D2D2D);

            final Color textoSecundario =
                modoOscuro ? Colors.white70 : Colors.black54;

            return Container(
              decoration: BoxDecoration(
                color: fondoModal,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: altoPantalla * 0.88,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 18,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: AppConfig.idioma,
                      builder: (context, idiomaActual, _) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: AppConfig.sonidosActivos,
                          builder: (context, sonidosActivos, _) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: AppConfig.vibracionActiva,
                              builder: (context, vibracionActiva, _) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: modoOscuro
                                            ? Colors.white24
                                            : Colors.black26,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    Container(
                                      width: 74,
                                      height: 74,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.deepPurple.withValues(
                                              alpha: modoOscuro ? 0.38 : 0.22,
                                            ),
                                            Colors.deepPurple.withValues(
                                              alpha: modoOscuro ? 0.16 : 0.08,
                                            ),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.settings,
                                        size: 42,
                                        color: Colors.deepPurple,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      T.txt('settingsTitle'),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.fredoka(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: modoOscuro
                                            ? Colors.white
                                            : const Color(0xFF4A2C82),
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    SettingCard(
                                      color: sonidosActivos
                                          ? Colors.green
                                          : Colors.redAccent,
                                      icon: sonidosActivos
                                          ? Icons.volume_up_rounded
                                          : Icons.volume_off_rounded,
                                      title: T.txt('sounds'),
                                      subtitle: sonidosActivos
                                          ? T.txt('enabled')
                                          : T.txt('disabled'),
                                      modoOscuro: modoOscuro,
                                      trailing: Switch(
                                        value: sonidosActivos,
                                        activeThumbColor: Colors.green,
                                        inactiveThumbColor: Colors.redAccent,
                                        onChanged: (valor) {
                                          AppConfig.cambiarSonidos(valor);
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    SettingCard(
                                      color: Colors.deepPurple,
                                      icon: Icons.language_rounded,
                                      title: T.txt('language'),
                                      subtitle: idiomaActual == 'es'
                                          ? T.txt('spanish')
                                          : T.txt('english'),
                                      modoOscuro: modoOscuro,
                                      trailing: DropdownButton<String>(
                                        value: idiomaActual,
                                        dropdownColor: modoOscuro
                                            ? const Color(0xFF211B2E)
                                            : Colors.white,
                                        underline: const SizedBox(),
                                        borderRadius: BorderRadius.circular(18),
                                        style: GoogleFonts.baloo2(
                                          fontWeight: FontWeight.w600,
                                          color: textoPrincipal,
                                        ),
                                        items: [
                                          DropdownMenuItem(
                                            value: 'es',
                                            child: Text(T.txt('spanish')),
                                          ),
                                          DropdownMenuItem(
                                            value: 'en',
                                            child: Text(T.txt('english')),
                                          ),
                                        ],
                                        onChanged: (valor) {
                                          if (valor != null) {
                                            AppConfig.cambiarIdioma(valor);
                                          }
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    SettingCard(
                                      color: vibracionActiva
                                          ? Colors.orange
                                          : Colors.blueGrey,
                                      icon: vibracionActiva
                                          ? Icons.vibration_rounded
                                          : Icons.phone_android_rounded,
                                      title: T.txt('vibration'),
                                      subtitle: vibracionActiva
                                          ? T.txt('vibrationOn')
                                          : T.txt('vibrationOff'),
                                      modoOscuro: modoOscuro,
                                      trailing: Switch(
                                        value: vibracionActiva,
                                        activeThumbColor: Colors.orange,
                                        inactiveThumbColor: Colors.blueGrey,
                                        onChanged: (valor) async {
                                          AppConfig.cambiarVibracion(valor);

                                          if (!valor) return;

                                          await vibrarActivacionFuerte();
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    SettingCard(
                                      color: modoOscuro
                                          ? Colors.indigo
                                          : Colors.amber,
                                      icon: modoOscuro
                                          ? Icons.dark_mode_rounded
                                          : Icons.light_mode_rounded,
                                      title: T.txt('appearance'),
                                      subtitle: modoOscuro
                                          ? T.txt('darkMode')
                                          : T.txt('lightMode'),
                                      modoOscuro: modoOscuro,
                                      trailing: Switch(
                                        value: modoOscuro,
                                        activeThumbColor: Colors.indigo,
                                        inactiveThumbColor: Colors.amber,
                                        onChanged: (valor) {
                                          AppConfig.cambiarTema(valor);
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      T.txt('settingsNote'),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.baloo2(
                                        fontSize: 15.5,
                                        color: textoSecundario,
                                      ),
                                    ),

                                    const SizedBox(height: 8),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
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
            final items = _getItems();

            final ancho = MediaQuery.of(context).size.width;
            final alto = MediaQuery.of(context).size.height;

            final bool pantallaPequena = alto < 720 || ancho < 380;
            final bool modoOscuro = temaActual == ThemeMode.dark;

            final double imagenAlto = pantallaPequena ? 120 : 165;
            final double tituloTamano = pantallaPequena ? 29 : 34;
            final double subtituloTamano = pantallaPequena ? 17 : 20;

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('appName'),
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro
                        ? Colors.white
                        : const Color(0xFF2D2D2D),
                  ),
                ),
                centerTitle: true,
                backgroundColor:
                    modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                foregroundColor:
                    modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/WawaKalu_icono.png',
                    fit: BoxFit.contain,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: T.txt('settingsTitle'),
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      mostrarConfiguracion(context);
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/familia_kalu.png',
                                height: imagenAlto,
                                fit: BoxFit.contain,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                T.txt('welcome'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                  fontSize: tituloTamano,
                                  fontWeight: FontWeight.w700,
                                  color: modoOscuro
                                      ? Colors.white
                                      : const Color(0xFF4A2C82),
                                  height: 1.05,
                                  shadows: [
                                    Shadow(
                                      color: Colors.deepPurple.withValues(
                                        alpha: 0.16,
                                      ),
                                      offset: const Offset(0, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                T.txt('subtitle'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.baloo2(
                                  fontSize: subtituloTamano,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFEF476F),
                                  height: 1.1,
                                ),
                              ),

                              const SizedBox(height: 20),

                              ...items.map(
                                (item) => MinimalMenuItem(
                                  item: item,
                                  modoOscuro: modoOscuro,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SettingCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool modoOscuro;

  const SettingCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool estrecho = constraints.maxWidth < 360;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                color.withValues(alpha: modoOscuro ? 0.18 : 0.09),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: color.withValues(alpha: modoOscuro ? 0.30 : 0.16),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: modoOscuro ? 0.10 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: estrecho
              ? Column(
                  children: [
                    Row(
                      children: [
                        SettingIcon(color: color, icon: icon),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SettingText(
                            title: title,
                            subtitle: subtitle,
                            modoOscuro: modoOscuro,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: trailing,
                    ),
                  ],
                )
              : Row(
                  children: [
                    SettingIcon(color: color, icon: icon),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SettingText(
                        title: title,
                        subtitle: subtitle,
                        modoOscuro: modoOscuro,
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: trailing,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class SettingIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const SettingIcon({
    super.key,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: color,
        size: 30,
      ),
    );
  }
}

class SettingText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool modoOscuro;

  const SettingText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.fredoka(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.baloo2(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: modoOscuro ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }
}

class MinimalMenuItem extends StatelessWidget {
  final HomeItem item;
  final bool modoOscuro;

  const MinimalMenuItem({
    super.key,
    required this.item,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool estrecho = constraints.maxWidth < 340;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => item.page,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: estrecho ? 12 : 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                      item.color.withValues(alpha: modoOscuro ? 0.18 : 0.10),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: item.color.withValues(alpha: 0.20),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withValues(alpha: 0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: estrecho ? 46 : 52,
                      height: estrecho ? 46 : 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            item.color.withValues(alpha: 0.22),
                            item.color.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: estrecho ? 27 : 30,
                      ),
                    ),

                    SizedBox(width: estrecho ? 10 : 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.fredoka(
                              fontSize: estrecho ? 17 : 19,
                              fontWeight: FontWeight.w700,
                              color: modoOscuro
                                  ? Colors.white
                                  : const Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.subtitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.baloo2(
                              fontSize: estrecho ? 13.5 : 15,
                              fontWeight: FontWeight.w500,
                              color: modoOscuro
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons.chevron_right,
                      color: item.color,
                      size: estrecho ? 24 : 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  const HomeItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });
}