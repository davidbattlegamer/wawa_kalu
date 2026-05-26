import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

import '../app_config.dart';
import '../app_texts.dart';

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

String textoTema(ThemeMode tema) {
  if (tema == ThemeMode.system) return T.txt('themeAutomatic');
  if (tema == ThemeMode.dark) return T.txt('darkMode');
  return T.txt('lightMode');
}

IconData iconoTema(ThemeMode tema) {
  if (tema == ThemeMode.system) return Icons.brightness_auto_rounded;
  if (tema == ThemeMode.dark) return Icons.dark_mode_rounded;
  return Icons.light_mode_rounded;
}

Color colorTema(ThemeMode tema) {
  if (tema == ThemeMode.system) return const Color(0xFF00A896);
  if (tema == ThemeMode.dark) return Colors.indigo;
  return Colors.amber;
}

String textoIdiomaActual({
  required bool idiomaAuto,
  required String idiomaActual,
}) {
  if (idiomaAuto) return T.txt('languageAutomatic');
  if (idiomaActual == 'en') return T.txt('english');
  return T.txt('spanish');
}

void showConfigSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF15131A)
        : const Color(0xFFFAF7F2),
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
          final bool modoOscuro =
              Theme.of(context).brightness == Brightness.dark;

          final Color fondoModal =
              modoOscuro ? const Color(0xFF15131A) : const Color(0xFFFAF7F2);

          final Color textoSecundario =
              modoOscuro ? Colors.white70 : Colors.black54;

          final Color colorApariencia = colorTema(temaActual);

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
                  maxHeight: altoPantalla * 0.90,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 18,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: ValueListenableBuilder<String>(
                    valueListenable: AppConfig.idioma,
                    builder: (context, idiomaActual, _) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: AppConfig.idiomaAuto,
                        builder: (context, idiomaAuto, _) {
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                alpha:
                                                    modoOscuro ? 0.38 : 0.22,
                                              ),
                                              Colors.deepPurple.withValues(
                                                alpha:
                                                    modoOscuro ? 0.16 : 0.08,
                                              ),
                                            ],
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
                                        trailing: AdaptiveSwitch(
                                          value: sonidosActivos,
                                          activeColor: Colors.green,
                                          inactiveColor: Colors.redAccent,
                                          onChanged: (valor) async {
                                            await AppConfig.cambiarSonidos(
                                              valor,
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      SettingCard(
                                        color: idiomaAuto
                                            ? const Color(0xFF00A896)
                                            : Colors.deepPurple,
                                        icon: idiomaAuto
                                            ? Icons.translate_rounded
                                            : Icons.language_rounded,
                                        title: T.txt('language'),
                                        subtitle: idiomaAuto
                                            ? T.txt('languageAutoSubtitle')
                                            : textoIdiomaActual(
                                                idiomaAuto: idiomaAuto,
                                                idiomaActual: idiomaActual,
                                              ),
                                        modoOscuro: modoOscuro,
                                        trailing: LanguageSelector(
                                          idiomaActual: idiomaActual,
                                          idiomaAuto: idiomaAuto,
                                          modoOscuro: modoOscuro,
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
                                        trailing: AdaptiveSwitch(
                                          value: vibracionActiva,
                                          activeColor: Colors.orange,
                                          inactiveColor: Colors.blueGrey,
                                          onChanged: (valor) async {
                                            await AppConfig.cambiarVibracion(
                                              valor,
                                            );

                                            if (!valor) return;

                                            await vibrarActivacionFuerte();
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      SettingCard(
                                        color: colorApariencia,
                                        icon: iconoTema(temaActual),
                                        title: T.txt('appearance'),
                                        subtitle: textoTema(temaActual),
                                        modoOscuro: modoOscuro,
                                        trailing: ThemeSelector(
                                          temaActual: temaActual,
                                          modoOscuro: modoOscuro,
                                          onChanged: (nuevoTema) async {
                                            await AppConfig.cambiarTema(
                                              nuevoTema,
                                            );
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
        final bool estrecho = constraints.maxWidth < 390;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(estrecho ? 14 : 16),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: SettingText(
                            title: title,
                            subtitle: subtitle,
                            modoOscuro: modoOscuro,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: trailing,
                      ),
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
                    const SizedBox(width: 8),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: trailing,
                        ),
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
          maxLines: 2,
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

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final Color inactiveColor;
  final Future<void> Function(bool valor) onChanged;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      activeThumbColor: activeColor,
      inactiveThumbColor: inactiveColor,
      onChanged: (valor) async {
        await onChanged(valor);
      },
    );
  }
}

class LanguageSelector extends StatelessWidget {
  final String idiomaActual;
  final bool idiomaAuto;
  final bool modoOscuro;

  const LanguageSelector({
    super.key,
    required this.idiomaActual,
    required this.idiomaAuto,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    final Color seleccionado = idiomaAuto
        ? const Color(0xFF00A896)
        : idiomaActual == 'en'
            ? Colors.deepPurple
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: modoOscuro ? const Color(0xFF15131A) : const Color(0xFFF2ECFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: seleccionado.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LanguageOptionButton(
            text: 'A',
            icon: Icons.settings_suggest_rounded,
            selected: idiomaAuto,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            tooltip: T.txt('languageAutomatic'),
            onTap: () async {
              await AppConfig.cambiarIdiomaAutomatico();
            },
          ),
          LanguageOptionButton(
            text: 'ES',
            selected: !idiomaAuto && idiomaActual == 'es',
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            tooltip: T.txt('spanish'),
            onTap: () async {
              await AppConfig.cambiarIdioma('es');
            },
          ),
          LanguageOptionButton(
            text: 'EN',
            selected: !idiomaAuto && idiomaActual == 'en',
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            tooltip: T.txt('english'),
            onTap: () async {
              await AppConfig.cambiarIdioma('en');
            },
          ),
        ],
      ),
    );
  }
}

class LanguageOptionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool selected;
  final Color selectedColor;
  final bool modoOscuro;
  final String tooltip;
  final VoidCallback onTap;

  const LanguageOptionButton({
    super.key,
    required this.text,
    this.icon,
    required this.selected,
    required this.selectedColor,
    required this.modoOscuro,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.26),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            child: icon != null
                ? Icon(
                    icon,
                    size: 20,
                    color: selected
                        ? Colors.white
                        : modoOscuro
                            ? Colors.white70
                            : const Color(0xFF4A2C82),
                  )
                : Text(
                    text,
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? Colors.white
                          : modoOscuro
                              ? Colors.white70
                              : const Color(0xFF4A2C82),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ThemeSelector extends StatelessWidget {
  final ThemeMode temaActual;
  final bool modoOscuro;
  final Future<void> Function(ThemeMode nuevoTema) onChanged;

  const ThemeSelector({
    super.key,
    required this.temaActual,
    required this.modoOscuro,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color fondo =
        modoOscuro ? const Color(0xFF15131A) : const Color(0xFFF2ECFF);

    Color colorSeleccionado() {
      if (temaActual == ThemeMode.system) {
        return const Color(0xFF00A896);
      }

      if (temaActual == ThemeMode.dark) {
        return modoOscuro ? Colors.indigo.shade400 : Colors.indigo;
      }

      return Colors.amber;
    }

    final Color seleccionado = colorSeleccionado();

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: seleccionado.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeOptionButton(
            icon: Icons.brightness_auto_rounded,
            selected: temaActual == ThemeMode.system,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () => onChanged(ThemeMode.system),
          ),
          ThemeOptionButton(
            icon: Icons.light_mode_rounded,
            selected: temaActual == ThemeMode.light,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () => onChanged(ThemeMode.light),
          ),
          ThemeOptionButton(
            icon: Icons.dark_mode_rounded,
            selected: temaActual == ThemeMode.dark,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () => onChanged(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}

class ThemeOptionButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final bool modoOscuro;
  final VoidCallback onTap;

  const ThemeOptionButton({
    super.key,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.modoOscuro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: selectedColor.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(
            icon,
            size: 22,
            color: selected
                ? Colors.white
                : modoOscuro
                    ? Colors.white70
                    : const Color(0xFF4A2C82),
          ),
        ),
      ),
    );
  }
}