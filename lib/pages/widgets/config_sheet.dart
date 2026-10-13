import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import '../../features/privacy/pages/privacy_page.dart';
import '../app_config.dart';
import '../app_texts.dart';

const String _appVersion = '1.1.0';
const String _developers = 'D.S Y K.T';

final AudioPlayer _switchPlayer =
    AudioPlayer();

// ============================================================================
// SONIDO DEL SWITCH
// ============================================================================

Future<void> _reproducirSonidoSwitch() async {
  if (!AppConfig.sonidosActivos.value) {
    return;
  }

  try {
    await _switchPlayer.stop();

    await _switchPlayer.play(
      AssetSource(
        'sonidos/switch.mp3',
      ),
      volume:
          0.55,
    );
  } catch (_) {
    // El sonido de interfaz es opcional.
  }
}

// ============================================================================
// VIBRACIÓN
// ============================================================================

Future<bool>
    dispositivoPermiteVibracion() async {
  if (kIsWeb) {
    return false;
  }

  if (defaultTargetPlatform ==
      TargetPlatform.android) {
    try {
      return await Vibration
          .hasVibrator();
    } catch (_) {
      return false;
    }
  }

  if (defaultTargetPlatform ==
      TargetPlatform.iOS) {
    return true;
  }

  return false;
}

Future<void>
    vibrarActivacionFuerte() async {
  try {
    if (kIsWeb) {
      return;
    }

    if (defaultTargetPlatform ==
        TargetPlatform.android) {
      final bool tieneVibrador =
          await Vibration
              .hasVibrator();

      if (tieneVibrador) {
        await Vibration.vibrate(
          pattern:
              <int>[
            0,
            120,
            60,
            120,
          ],
        );

        return;
      }
    }

    if (defaultTargetPlatform ==
        TargetPlatform.iOS) {
      await HapticFeedback
          .heavyImpact();
    }
  } catch (_) {
    try {
      await HapticFeedback
          .mediumImpact();
    } catch (_) {}
  }
}

// ============================================================================
// TEXTO DEL TEMA
// ============================================================================

String textoTema(
  ThemeMode tema,
) {
  switch (tema) {
    case ThemeMode.system:
      return T.txt(
        'themeAutomatic',
      );

    case ThemeMode.light:
      return T.txt(
        'lightMode',
      );

    case ThemeMode.dark:
      return T.txt(
        'darkMode',
      );
  }
}

IconData iconoTema(
  ThemeMode tema,
) {
  switch (tema) {
    case ThemeMode.system:
      return Icons
          .brightness_auto_rounded;

    case ThemeMode.light:
      return Icons
          .light_mode_rounded;

    case ThemeMode.dark:
      return Icons
          .dark_mode_rounded;
  }
}

Color colorTema(
  ThemeMode tema,
) {
  switch (tema) {
    case ThemeMode.system:
      return const Color(
        0xFF00A896,
      );

    case ThemeMode.light:
      return Colors.amber;

    case ThemeMode.dark:
      return Colors.indigo;
  }
}

// ============================================================================
// TEXTO DEL IDIOMA
// ============================================================================

String textoIdiomaActual({
  required bool idiomaAuto,
  required String idiomaActual,
}) {
  if (idiomaAuto) {
    return T.txt(
      'languageAutomatic',
    );
  }

  switch (idiomaActual) {
    case 'en':
      return T.txt(
        'english',
      );

    case 'qu':
      return T.txt(
        'kichwa',
      );

    case 'es':
    default:
      return T.txt(
        'spanish',
      );
  }
}

// ============================================================================
// COLOR DEL IDIOMA
// ============================================================================

Color _colorIdioma({
  required bool idiomaAuto,
  required String idiomaActual,
}) {
  if (idiomaAuto) {
    return const Color(
      0xFF00A896,
    );
  }

  switch (idiomaActual) {
    case 'en':
      return Colors.deepPurple;

    case 'qu':
      return const Color(
        0xFF2E7D32,
      );

    case 'es':
    default:
      return Colors.orange;
  }
}

// ============================================================================
// ACERCA DE
// ============================================================================

void _mostrarAcercaDe(
  BuildContext context,
  bool modoOscuro,
) {
  showDialog<void>(
    context:
        context,
    builder:
        (
      BuildContext dialogContext,
    ) {
      return AlertDialog(
        backgroundColor:
            modoOscuro
                ? const Color(
                    0xFF211B2E,
                  )
                : Colors.white,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            24,
          ),
        ),
        title:
            Row(
          children: [
            Container(
              width:
                  44,
              height:
                  44,
              decoration:
                  BoxDecoration(
                color:
                    Colors.deepPurple
                        .withValues(
                  alpha:
                      0.12,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child:
                  const Icon(
                Icons
                    .info_outline_rounded,
                color:
                    Colors.deepPurple,
              ),
            ),

            const SizedBox(
              width:
                  12,
            ),

            Expanded(
              child:
                  Text(
                T.txt(
                  'aboutApp',
                ),
                style:
                    TextStyle(
                  fontFamily:
                      'Fredoka',
                  fontWeight:
                      FontWeight.w700,
                  color:
                      modoOscuro
                          ? Colors.white
                          : const Color(
                              0xFF4A2C82,
                            ),
                ),
              ),
            ),
          ],
        ),
        content:
            SingleChildScrollView(
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                T.txt(
                  'aboutAppSubtitle',
                ),
                style:
                    TextStyle(
                  fontFamily:
                      'Baloo2',
                  fontSize:
                      15,
                  height:
                      1.4,
                  color:
                      modoOscuro
                          ? Colors.white70
                          : Colors.black87,
                ),
              ),

              const SizedBox(
                height:
                    18,
              ),

              _AboutRow(
                label:
                    T.txt(
                  'appVersion',
                ),
                value:
                    _appVersion,
                modoOscuro:
                    modoOscuro,
              ),

              const SizedBox(
                height:
                    10,
              ),

              _AboutRow(
                label:
                    T.txt(
                  'developers',
                ),
                value:
                    _developers,
                modoOscuro:
                    modoOscuro,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                () {
              Navigator.pop(
                dialogContext,
              );
            },
            child:
                Text(
              T.txt(
                'close',
              ),
            ),
          ),
        ],
      );
    },
  );
}

// ============================================================================
// HOJA DE CONFIGURACIÓN
// ============================================================================

void showConfigSheet(
  BuildContext context,
) {
  showModalBottomSheet<void>(
    context:
        context,
    isScrollControlled:
        true,
    backgroundColor:
        Colors.transparent,
    builder:
        (
      BuildContext sheetContext,
    ) {
      final double altoPantalla =
          MediaQuery.of(
        sheetContext,
      ).size.height;

      return ValueListenableBuilder<
          ThemeMode>(
        valueListenable:
            AppConfig.temaApp,
        builder:
            (
          context,
          temaActual,
          _,
        ) {
          final bool modoOscuro =
              Theme.of(
                context,
              ).brightness ==
              Brightness.dark;

          final Color fondoModal =
              modoOscuro
                  ? const Color(
                      0xFF15131A,
                    )
                  : const Color(
                      0xFFFAF7F2,
                    );

          final Color
              textoSecundario =
              modoOscuro
                  ? Colors.white70
                  : Colors.black54;

          final Color
              colorApariencia =
              colorTema(
            temaActual,
          );

          return Container(
            decoration:
                BoxDecoration(
              color:
                  fondoModal,
              borderRadius:
                  const BorderRadius.vertical(
                top:
                    Radius.circular(
                  28,
                ),
              ),
            ),
            child:
                SafeArea(
              child:
                  ConstrainedBox(
                constraints:
                    BoxConstraints(
                  maxHeight:
                      altoPantalla *
                          0.92,
                ),
                child:
                    SingleChildScrollView(
                  padding:
                      EdgeInsets.only(
                    left:
                        18,
                    right:
                        18,
                    top:
                        18,
                    bottom:
                        MediaQuery.of(
                              context,
                            )
                                .viewInsets
                                .bottom +
                            22,
                  ),
                  child:
                      ValueListenableBuilder<
                          String>(
                    valueListenable:
                        AppConfig.idioma,
                    builder:
                        (
                      context,
                      idiomaActual,
                      _,
                    ) {
                      return ValueListenableBuilder<
                          bool>(
                        valueListenable:
                            AppConfig
                                .idiomaAuto,
                        builder:
                            (
                          context,
                          idiomaAuto,
                          _,
                        ) {
                          return ValueListenableBuilder<
                              bool>(
                            valueListenable:
                                AppConfig
                                    .sonidosActivos,
                            builder:
                                (
                              context,
                              sonidosActivos,
                              _,
                            ) {
                              return ValueListenableBuilder<
                                  bool>(
                                valueListenable:
                                    AppConfig
                                        .vibracionActiva,
                                builder:
                                    (
                                  context,
                                  vibracionActiva,
                                  _,
                                ) {
                                  final Color
                                      colorIdioma =
                                      _colorIdioma(
                                    idiomaAuto:
                                        idiomaAuto,
                                    idiomaActual:
                                        idiomaActual,
                                  );

                                  return Column(
                                    mainAxisSize:
                                        MainAxisSize.min,
                                    children: [
                                      // ======================================================
                                      // INDICADOR
                                      // ======================================================

                                      Container(
                                        width:
                                            48,
                                        height:
                                            5,
                                        decoration:
                                            BoxDecoration(
                                          color:
                                              modoOscuro
                                                  ? Colors.white24
                                                  : Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            18,
                                      ),

                                      // ======================================================
                                      // ICONO
                                      // ======================================================

                                      Container(
                                        width:
                                            74,
                                        height:
                                            74,
                                        decoration:
                                            BoxDecoration(
                                          gradient:
                                              LinearGradient(
                                            colors: [
                                              Colors.deepPurple.withValues(
                                                alpha:
                                                    modoOscuro
                                                        ? 0.38
                                                        : 0.22,
                                              ),
                                              Colors.deepPurple.withValues(
                                                alpha:
                                                    modoOscuro
                                                        ? 0.16
                                                        : 0.08,
                                              ),
                                            ],
                                          ),
                                          shape:
                                              BoxShape.circle,
                                        ),
                                        child:
                                            const Icon(
                                          Icons.settings_rounded,
                                          size:
                                              42,
                                          color:
                                              Colors.deepPurple,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            14,
                                      ),

                                      Text(
                                        T.txt(
                                          'settingsTitle',
                                        ),
                                        textAlign:
                                            TextAlign.center,
                                        style:
                                            TextStyle(
                                          fontFamily:
                                              'Fredoka',
                                          fontSize:
                                              28,
                                          fontWeight:
                                              FontWeight.w700,
                                          color:
                                              modoOscuro
                                                  ? Colors.white
                                                  : const Color(
                                                      0xFF4A2C82,
                                                    ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            18,
                                      ),

                                      // ======================================================
                                      // SONIDOS
                                      // ======================================================

                                      SettingCard(
                                        color:
                                            sonidosActivos
                                                ? Colors.green
                                                : Colors.redAccent,
                                        icon:
                                            sonidosActivos
                                                ? Icons.volume_up_rounded
                                                : Icons.volume_off_rounded,
                                        title:
                                            T.txt(
                                          'sounds',
                                        ),
                                        subtitle:
                                            sonidosActivos
                                                ? T.txt(
                                                    'enabled',
                                                  )
                                                : T.txt(
                                                    'disabled',
                                                  ),
                                        modoOscuro:
                                            modoOscuro,
                                        trailing:
                                            AdaptiveSwitch(
                                          value:
                                              sonidosActivos,
                                          activeColor:
                                              Colors.green,
                                          inactiveColor:
                                              Colors.redAccent,
                                          onChanged:
                                              (
                                            bool valor,
                                          ) async {
                                            if (!valor) {
                                              await _reproducirSonidoSwitch();
                                            }

                                            await AppConfig.cambiarSonidos(
                                              valor,
                                            );

                                            if (valor) {
                                              await _reproducirSonidoSwitch();
                                            }
                                          },
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            14,
                                      ),

                                      // ======================================================
                                      // IDIOMA
                                      // ======================================================

                                      SettingCard(
                                        color:
                                            colorIdioma,
                                        icon:
                                            idiomaAuto
                                                ? Icons.translate_rounded
                                                : Icons.language_rounded,
                                        title:
                                            T.txt(
                                          'language',
                                        ),
                                        subtitle:
                                            idiomaAuto
                                                ? T.txt(
                                                    'languageAutoSubtitle',
                                                  )
                                                : textoIdiomaActual(
                                                    idiomaAuto:
                                                        idiomaAuto,
                                                    idiomaActual:
                                                        idiomaActual,
                                                  ),
                                        modoOscuro:
                                            modoOscuro,
                                        trailing:
                                            LanguageSelector(
                                          idiomaActual:
                                              idiomaActual,
                                          idiomaAuto:
                                              idiomaAuto,
                                          modoOscuro:
                                              modoOscuro,
                                        ),
                                      ),

                                      // ======================================================
                                      // VIBRACIÓN
                                      // ======================================================

                                      FutureBuilder<
                                          bool>(
                                        future:
                                            dispositivoPermiteVibracion(),
                                        builder:
                                            (
                                          context,
                                          snapshot,
                                        ) {
                                          final bool
                                              puedeVibrar =
                                              snapshot.data ??
                                                  false;

                                          if (!puedeVibrar) {
                                            return const SizedBox.shrink();
                                          }

                                          return Column(
                                            children: [
                                              const SizedBox(
                                                height:
                                                    14,
                                              ),
                                              SettingCard(
                                                color:
                                                    vibracionActiva
                                                        ? Colors.orange
                                                        : Colors.blueGrey,
                                                icon:
                                                    vibracionActiva
                                                        ? Icons.vibration_rounded
                                                        : Icons.phone_android_rounded,
                                                title:
                                                    T.txt(
                                                  'vibration',
                                                ),
                                                subtitle:
                                                    vibracionActiva
                                                        ? T.txt(
                                                            'vibrationOn',
                                                          )
                                                        : T.txt(
                                                            'vibrationOff',
                                                          ),
                                                modoOscuro:
                                                    modoOscuro,
                                                trailing:
                                                    AdaptiveSwitch(
                                                  value:
                                                      vibracionActiva,
                                                  activeColor:
                                                      Colors.orange,
                                                  inactiveColor:
                                                      Colors.blueGrey,
                                                  onChanged:
                                                      (
                                                    bool valor,
                                                  ) async {
                                                    await AppConfig
                                                        .cambiarVibracion(
                                                      valor,
                                                    );

                                                    if (valor) {
                                                      await vibrarActivacionFuerte();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                      const SizedBox(
                                        height:
                                            14,
                                      ),

                                      // ======================================================
                                      // APARIENCIA
                                      // ======================================================

                                      SettingCard(
                                        color:
                                            colorApariencia,
                                        icon:
                                            iconoTema(
                                          temaActual,
                                        ),
                                        title:
                                            T.txt(
                                          'appearance',
                                        ),
                                        subtitle:
                                            textoTema(
                                          temaActual,
                                        ),
                                        modoOscuro:
                                            modoOscuro,
                                        trailing:
                                            ThemeSelector(
                                          temaActual:
                                              temaActual,
                                          modoOscuro:
                                              modoOscuro,
                                          onChanged:
                                              (
                                            ThemeMode nuevoTema,
                                          ) async {
                                            await AppConfig.cambiarTema(
                                              nuevoTema,
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            14,
                                      ),

                                      // ======================================================
                                      // PRIVACIDAD
                                      // ======================================================

                                      SettingCard(
                                        color:
                                            Colors.teal,
                                        icon:
                                            Icons.privacy_tip_outlined,
                                        title:
                                            T.txt(
                                          'privacyAndData',
                                        ),
                                        subtitle:
                                            T.txt(
                                          'privacySettingsSubtitle',
                                        ),
                                        modoOscuro:
                                            modoOscuro,
                                        trailing:
                                            IconButton(
                                          tooltip:
                                              T.txt(
                                            'privacyAndData',
                                          ),
                                          icon:
                                              const Icon(
                                            Icons.chevron_right_rounded,
                                          ),
                                          color:
                                              Colors.teal,
                                          onPressed:
                                              () {
                                            Navigator.of(
                                              context,
                                            ).push(
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (
                                                  context,
                                                ) =>
                                                        PrivacyPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            14,
                                      ),

                                      // ======================================================
                                      // ACERCA DE
                                      // ======================================================

                                      SettingCard(
                                        color:
                                            Colors.lightBlue,
                                        icon:
                                            Icons.info_outline_rounded,
                                        title:
                                            T.txt(
                                          'aboutApp',
                                        ),
                                        subtitle:
                                            '${T.txt('appVersion')} $_appVersion',
                                        modoOscuro:
                                            modoOscuro,
                                        trailing:
                                            IconButton(
                                          tooltip:
                                              T.txt(
                                            'aboutApp',
                                          ),
                                          icon:
                                              const Icon(
                                            Icons.chevron_right_rounded,
                                          ),
                                          color:
                                              Colors.lightBlue,
                                          onPressed:
                                              () {
                                            _mostrarAcercaDe(
                                              context,
                                              modoOscuro,
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            16,
                                      ),

                                      Text(
                                        T.txt(
                                          'settingsNote',
                                        ),
                                        textAlign:
                                            TextAlign.center,
                                        style:
                                            TextStyle(
                                          fontFamily:
                                              'Baloo2',
                                          fontSize:
                                              15.5,
                                          height:
                                              1.3,
                                          color:
                                              textoSecundario,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            8,
                                      ),
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

// ============================================================================
// FILA ACERCA DE
// ============================================================================

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;
  final bool modoOscuro;

  const _AboutRow({
    required this.label,
    required this.value,
    required this.modoOscuro,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child:
              Text(
            label,
            style:
                TextStyle(
              fontFamily:
                  'Fredoka',
              fontWeight:
                  FontWeight.w600,
              color:
                  modoOscuro
                      ? Colors.white70
                      : Colors.black54,
            ),
          ),
        ),
        const SizedBox(
          width:
              12,
        ),
        Text(
          value,
          style:
              TextStyle(
            fontFamily:
                'Fredoka',
            fontWeight:
                FontWeight.w700,
            color:
                modoOscuro
                    ? Colors.white
                    : const Color(
                        0xFF2D2D2D,
                      ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TARJETA
// ============================================================================

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
  Widget build(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder:
          (
        context,
        constraints,
      ) {
        final bool estrecho =
            constraints.maxWidth <
                430;

        return Container(
          width:
              double.infinity,
          padding:
              EdgeInsets.all(
            estrecho
                ? 14
                : 16,
          ),
          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                modoOscuro
                    ? const Color(
                        0xFF211B2E,
                      )
                    : Colors.white,
                color.withValues(
                  alpha:
                      modoOscuro
                          ? 0.18
                          : 0.09,
                ),
              ],
              begin:
                  Alignment.centerLeft,
              end:
                  Alignment.centerRight,
            ),
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            border:
                Border.all(
              color:
                  color.withValues(
                alpha:
                    modoOscuro
                        ? 0.30
                        : 0.16,
              ),
              width:
                  1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    color.withValues(
                  alpha:
                      modoOscuro
                          ? 0.10
                          : 0.08,
                ),
                blurRadius:
                    12,
                offset:
                    const Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),
          child:
              estrecho
                  ? Column(
                      children: [
                        Row(
                          children: [
                            SettingIcon(
                              color:
                                  color,
                              icon:
                                  icon,
                            ),
                            const SizedBox(
                              width:
                                  12,
                            ),
                            Expanded(
                              child:
                                  SettingText(
                                title:
                                    title,
                                subtitle:
                                    subtitle,
                                modoOscuro:
                                    modoOscuro,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height:
                              12,
                        ),
                        Align(
                          alignment:
                              Alignment.centerRight,
                          child:
                              trailing,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SettingIcon(
                          color:
                              color,
                          icon:
                              icon,
                        ),
                        const SizedBox(
                          width:
                              14,
                        ),
                        Expanded(
                          child:
                              SettingText(
                            title:
                                title,
                            subtitle:
                                subtitle,
                            modoOscuro:
                                modoOscuro,
                          ),
                        ),
                        const SizedBox(
                          width:
                              12,
                        ),
                        trailing,
                      ],
                    ),
        );
      },
    );
  }
}

// ============================================================================
// ICONO DE TARJETA
// ============================================================================

class SettingIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const SettingIcon({
    super.key,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width:
          52,
      height:
          52,
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            color.withValues(
              alpha:
                  0.25,
            ),
            color.withValues(
              alpha:
                  0.10,
            ),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child:
          Icon(
        icon,
        color:
            color,
        size:
            30,
      ),
    );
  }
}

// ============================================================================
// TEXTO DE TARJETA
// ============================================================================

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
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines:
              2,
          overflow:
              TextOverflow.ellipsis,
          style:
              TextStyle(
            fontFamily:
                'Fredoka',
            fontSize:
                19,
            height:
                1.05,
            fontWeight:
                FontWeight.w700,
            color:
                modoOscuro
                    ? Colors.white
                    : const Color(
                        0xFF2D2D2D,
                      ),
          ),
        ),
        const SizedBox(
          height:
              4,
        ),
        Text(
          subtitle,
          maxLines:
              3,
          overflow:
              TextOverflow.ellipsis,
          style:
              TextStyle(
            fontFamily:
                'Baloo2',
            fontSize:
                15,
            height:
                1.2,
            fontWeight:
                FontWeight.w500,
            color:
                modoOscuro
                    ? Colors.white70
                    : Colors.black54,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SWITCH
// ============================================================================

class AdaptiveSwitch
    extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final Color inactiveColor;
  final Future<void> Function(
    bool valor,
  ) onChanged;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Switch(
      value:
          value,
      activeThumbColor:
          activeColor,
      inactiveThumbColor:
          inactiveColor,
      onChanged:
          (
        bool valor,
      ) async {
        await onChanged(
          valor,
        );
      },
    );
  }
}

// ============================================================================
// SELECTOR DE IDIOMA
// ============================================================================

class LanguageSelector
    extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    final Color seleccionado =
        _colorIdioma(
      idiomaAuto:
          idiomaAuto,
      idiomaActual:
          idiomaActual,
    );

    final Color fondo =
        modoOscuro
            ? const Color(
                0xFF15131A,
              )
            : const Color(
                0xFFF2ECFF,
              );

    return Container(
      padding:
          const EdgeInsets.all(
        4,
      ),
      decoration:
          BoxDecoration(
        color:
            fondo,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              seleccionado.withValues(
            alpha:
                0.22,
          ),
        ),
      ),
      child:
          Wrap(
        spacing:
            2,
        runSpacing:
            2,
        alignment:
            WrapAlignment.end,
        children: [
          LanguageOptionButton(
            text:
                'A',
            icon:
                Icons.settings_suggest_rounded,
            selected:
                idiomaAuto,
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            tooltip:
                T.txt(
              'languageAutomatic',
            ),
            onTap:
                () async {
              await AppConfig
                  .cambiarIdiomaAutomatico();
            },
          ),
          LanguageOptionButton(
            text:
                'ES',
            selected:
                !idiomaAuto &&
                idiomaActual ==
                    'es',
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            tooltip:
                T.txt(
              'spanish',
            ),
            onTap:
                () async {
              await AppConfig
                  .cambiarIdioma(
                'es',
              );
            },
          ),
          LanguageOptionButton(
            text:
                'EN',
            selected:
                !idiomaAuto &&
                idiomaActual ==
                    'en',
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            tooltip:
                T.txt(
              'english',
            ),
            onTap:
                () async {
              await AppConfig
                  .cambiarIdioma(
                'en',
              );
            },
          ),
          LanguageOptionButton(
            text:
                'KI',
            selected:
                !idiomaAuto &&
                idiomaActual ==
                    'qu',
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            tooltip:
                T.txt(
              'kichwa',
            ),
            onTap:
                () async {
              await AppConfig
                  .cambiarIdioma(
                'qu',
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTÓN DE IDIOMA
// ============================================================================

class LanguageOptionButton
    extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool selected;
  final Color selectedColor;
  final bool modoOscuro;
  final String tooltip;
  final Future<void> Function()
      onTap;

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
  Widget build(
    BuildContext context,
  ) {
    return Tooltip(
      message:
          tooltip,
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds:
              220,
        ),
        margin:
            const EdgeInsets.symmetric(
          horizontal:
              1,
        ),
        decoration:
            BoxDecoration(
          color:
              selected
                  ? selectedColor
                  : Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          boxShadow:
              selected
                  ? [
                      BoxShadow(
                        color:
                            selectedColor.withValues(
                          alpha:
                              0.26,
                        ),
                        blurRadius:
                            8,
                        offset:
                            const Offset(
                          0,
                          3,
                        ),
                      ),
                    ]
                  : const [],
        ),
        child:
            InkWell(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          onTap:
              () async {
            await onTap();
          },
          child:
              Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  9,
              vertical:
                  9,
            ),
            child:
                icon != null
                    ? Icon(
                        icon,
                        size:
                            20,
                        color:
                            selected
                                ? Colors.white
                                : modoOscuro
                                    ? Colors.white70
                                    : const Color(
                                        0xFF4A2C82,
                                      ),
                      )
                    : Text(
                        text,
                        style:
                            TextStyle(
                          fontFamily:
                              'Fredoka',
                          fontSize:
                              13,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              selected
                                  ? Colors.white
                                  : modoOscuro
                                      ? Colors.white70
                                      : const Color(
                                          0xFF4A2C82,
                                        ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SELECTOR DE TEMA
// ============================================================================

class ThemeSelector
    extends StatelessWidget {
  final ThemeMode temaActual;
  final bool modoOscuro;
  final Future<void> Function(
    ThemeMode nuevoTema,
  ) onChanged;

  const ThemeSelector({
    super.key,
    required this.temaActual,
    required this.modoOscuro,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final Color fondo =
        modoOscuro
            ? const Color(
                0xFF15131A,
              )
            : const Color(
                0xFFF2ECFF,
              );

    final Color seleccionado =
        colorTema(
      temaActual,
    );

    return Container(
      padding:
          const EdgeInsets.all(
        4,
      ),
      decoration:
          BoxDecoration(
        color:
            fondo,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              seleccionado.withValues(
            alpha:
                0.22,
          ),
        ),
      ),
      child:
          Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          ThemeOptionButton(
            icon:
                Icons.brightness_auto_rounded,
            selected:
                temaActual ==
                ThemeMode.system,
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            onTap:
                () {
              onChanged(
                ThemeMode.system,
              );
            },
          ),
          ThemeOptionButton(
            icon:
                Icons.light_mode_rounded,
            selected:
                temaActual ==
                ThemeMode.light,
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            onTap:
                () {
              onChanged(
                ThemeMode.light,
              );
            },
          ),
          ThemeOptionButton(
            icon:
                Icons.dark_mode_rounded,
            selected:
                temaActual ==
                ThemeMode.dark,
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            onTap:
                () {
              onChanged(
                ThemeMode.dark,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTÓN DE TEMA
// ============================================================================

class ThemeOptionButton
    extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    return AnimatedContainer(
      duration:
          const Duration(
        milliseconds:
            220,
      ),
      margin:
          const EdgeInsets.symmetric(
        horizontal:
            2,
      ),
      decoration:
          BoxDecoration(
        color:
            selected
                ? selectedColor
                : Colors.transparent,
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        boxShadow:
            selected
                ? [
                    BoxShadow(
                      color:
                          selectedColor.withValues(
                        alpha:
                            0.28,
                      ),
                      blurRadius:
                          8,
                      offset:
                          const Offset(
                        0,
                        3,
                      ),
                    ),
                  ]
                : const [],
      ),
      child:
          InkWell(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        onTap:
            onTap,
        child:
            Padding(
          padding:
              const EdgeInsets.all(
            9,
          ),
          child:
              Icon(
            icon,
            size:
                22,
            color:
                selected
                    ? Colors.white
                    : modoOscuro
                        ? Colors.white70
                        : const Color(
                            0xFF4A2C82,
                          ),
          ),
        ),
      ),
    );
  }
}
