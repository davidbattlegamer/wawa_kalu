import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import '../../features/privacy/pages/privacy_page.dart';

import '../app_config.dart';
import '../app_texts.dart';

// ============================================================================
// DATOS DE LA APP
// ============================================================================

const String _appVersion = '1.0.0';
const String _developers = 'D.S Y K.T';

// ============================================================================
// SONIDO DE LOS INTERRUPTORES
// ============================================================================

final AudioPlayer _switchPlayer = AudioPlayer();

Future<void> reproducirSonidoSwitch({
  bool forzar = false,
}) async {
  try {
    if (!forzar &&
        !AppConfig.sonidosActivos.value) {
      return;
    }

    await _switchPlayer.stop();

    await _switchPlayer.play(
      AssetSource(
        'sonidos/switch.mp3',
      ),
    );
  } catch (e) {
    debugPrint(
      'Error reproduciendo sonido switch: $e',
    );
  }
}

// ============================================================================
// VIBRACIÓN
// ============================================================================

Future<bool> dispositivoPermiteVibracion() async {
  if (kIsWeb) {
    return false;
  }

  if (defaultTargetPlatform ==
      TargetPlatform.android) {
    try {
      return await Vibration.hasVibrator();
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

Future<void> vibrarActivacionFuerte() async {
  try {
    if (!kIsWeb &&
        defaultTargetPlatform ==
            TargetPlatform.android) {
      final bool tieneVibrador =
          await Vibration.hasVibrator();

      if (tieneVibrador) {
        await Vibration.vibrate(
          pattern: <int>[
            0,
            160,
            70,
            160,
          ],
        );

        return;
      }
    }

    if (!kIsWeb &&
        defaultTargetPlatform ==
            TargetPlatform.iOS) {
      await HapticFeedback.heavyImpact();
      return;
    }
  } catch (_) {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }
}

// ============================================================================
// TEMA
// ============================================================================

String textoTema(
  ThemeMode tema,
) {
  switch (tema) {
    case ThemeMode.system:
      return T.txt(
        'themeAutomatic',
      );

    case ThemeMode.dark:
      return T.txt(
        'darkMode',
      );

    case ThemeMode.light:
      return T.txt(
        'lightMode',
      );
  }
}

IconData iconoTema(
  ThemeMode tema,
) {
  switch (tema) {
    case ThemeMode.system:
      return Icons.brightness_auto_rounded;

    case ThemeMode.dark:
      return Icons.dark_mode_rounded;

    case ThemeMode.light:
      return Icons.light_mode_rounded;
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

    case ThemeMode.dark:
      return Colors.indigo;

    case ThemeMode.light:
      return Colors.amber;
  }
}

// ============================================================================
// IDIOMA
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

  if (idiomaActual == 'en') {
    return T.txt(
      'english',
    );
  }

  return T.txt(
    'spanish',
  );
}

// ============================================================================
// ACERCA DE WAWA KALÚ
// ============================================================================

Future<void> mostrarAcercaDelApp(
  BuildContext context,
  bool modoOscuro,
) async {
  await showDialog<void>(
    context: context,
    builder: (
      dialogContext,
    ) {
      return AlertDialog(
        backgroundColor: modoOscuro
            ? const Color(
                0xFF15131A,
              )
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            26,
          ),
        ),

        // --------------------------------------------------------------------
        // TÍTULO
        // --------------------------------------------------------------------

        title: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: <Color>[
                    Color(
                      0xFFFF006E,
                    ),
                    Color(
                      0xFFFF9F1C,
                    ),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              child: const Icon(
                Icons.child_care_rounded,
                color: Colors.white,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Text(
                T.txt(
                  'aboutApp',
                ),
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w800,
                  color: modoOscuro
                      ? Colors.white
                      : const Color(
                          0xFF4A2C82,
                        ),
                ),
              ),
            ),
          ],
        ),

        // --------------------------------------------------------------------
        // CONTENIDO
        // --------------------------------------------------------------------

        content:
            SingleChildScrollView(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              // --------------------------------------------------------------
              // CABECERA WAWA KALÚ
              // --------------------------------------------------------------

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(
                  20,
                ),
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: <Color>[
                      const Color(
                        0xFF7B2CBF,
                      ).withValues(
                        alpha: modoOscuro
                            ? 0.25
                            : 0.10,
                      ),
                      const Color(
                        0xFFFF006E,
                      ).withValues(
                        alpha: modoOscuro
                            ? 0.18
                            : 0.06,
                      ),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      padding:
                          const EdgeInsets.all(
                        8,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        shape:
                            BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black
                                .withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 12,
                            offset:
                                const Offset(
                              0,
                              5,
                            ),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/home.png',
                          fit:
                              BoxFit.contain,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              decoration:
                                  const BoxDecoration(
                                gradient:
                                    LinearGradient(
                                  colors: <Color>[
                                    Color(
                                      0xFFFFC300,
                                    ),
                                    Color(
                                      0xFFFF7B00,
                                    ),
                                  ],
                                ),
                                shape:
                                    BoxShape.circle,
                              ),
                              child:
                                  const Icon(
                                Icons
                                    .child_care_rounded,
                                size: 44,
                                color:
                                    Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Text(
                      'Wawa Kalú',
                      style: TextStyle(
                        fontFamily:
                            'Fredoka',
                        fontSize: 27,
                        fontWeight:
                            FontWeight.w900,
                        color: modoOscuro
                            ? Colors.white
                            : const Color(
                                0xFF4A2C82,
                              ),
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Text(
                      T.txt(
                        'aboutAppSubtitle',
                      ),
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize: 15,
                        height: 1.25,
                        color: modoOscuro
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 17,
              ),

              // --------------------------------------------------------------
              // SALUD
              // --------------------------------------------------------------

              _AboutInfoCard(
                modoOscuro:
                    modoOscuro,
                icon: Icons
                    .health_and_safety_outlined,
                color:
                    const Color(
                  0xFF00A896,
                ),
                title:
                    T.txt(
                  'health',
                ),
                description:
                    T.txt(
                  'healthHeaderSubtitle',
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // --------------------------------------------------------------
              // PRIVACIDAD
              // --------------------------------------------------------------

              _AboutInfoCard(
                modoOscuro:
                    modoOscuro,
                icon:
                    Icons.shield_outlined,
                color:
                    const Color(
                  0xFF7B2CBF,
                ),
                title:
                    T.txt(
                  'privacyAndData',
                ),
                description:
                    T.txt(
                  'localStorageDescription',
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // --------------------------------------------------------------
              // VERSIÓN
              // --------------------------------------------------------------

              _AboutInfoCard(
                modoOscuro:
                    modoOscuro,
                icon:
                    Icons.info_outline_rounded,
                color:
                    Colors.blue,
                title:
                    T.txt(
                  'appVersion',
                ),
                description:
                    _appVersion,
              ),

              const SizedBox(
                height: 10,
              ),

              // --------------------------------------------------------------
              // DESARROLLADORES
              // --------------------------------------------------------------

              _AboutInfoCard(
                modoOscuro:
                    modoOscuro,
                icon:
                    Icons.code_rounded,
                color:
                    const Color(
                  0xFFFF006E,
                ),
                title:
                    T.txt(
                  'developers',
                ),
                description:
                    _developers,
              ),
            ],
          ),
        ),

        // --------------------------------------------------------------------
        // BOTÓN CERRAR
        // --------------------------------------------------------------------

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
              );
            },
            child: Text(
              T.txt(
                'close',
              ),
              style:
                  const TextStyle(
                fontFamily:
                    'Fredoka',
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// ============================================================================
// MOSTRAR CONFIGURACIÓN
// ============================================================================

void showConfigSheet(
  BuildContext context,
) {
  final BuildContext pageContext =
      context;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor:
        Colors.transparent,
    builder: (
      sheetContext,
    ) {
      return ValueListenableBuilder<
          ThemeMode>(
        valueListenable:
            AppConfig.temaApp,
        builder: (
          context,
          temaActual,
          _,
        ) {
          final bool modoOscuro =
              Theme.of(context)
                      .brightness ==
                  Brightness.dark;

          final Color fondo =
              modoOscuro
                  ? const Color(
                      0xFF15131A,
                    )
                  : const Color(
                      0xFFFAF7F2,
                    );

          final Color colorApariencia =
              colorTema(
            temaActual,
          );

          return Container(
            constraints:
                BoxConstraints(
              maxHeight:
                  MediaQuery.of(
                        context,
                      ).size.height *
                      0.92,
            ),
            decoration:
                BoxDecoration(
              color: fondo,
              borderRadius:
                  const BorderRadius
                      .vertical(
                top:
                    Radius.circular(
                  30,
                ),
              ),
            ),
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                14,
                18,
                30,
              ),
              child:
                  ValueListenableBuilder<
                      String>(
                valueListenable:
                    AppConfig.idioma,
                builder: (
                  context,
                  idiomaActual,
                  _,
                ) {
                  return ValueListenableBuilder<
                      bool>(
                    valueListenable:
                        AppConfig.idiomaAuto,
                    builder: (
                      context,
                      idiomaAuto,
                      _,
                    ) {
                      return ValueListenableBuilder<
                          bool>(
                        valueListenable:
                            AppConfig
                                .sonidosActivos,
                        builder: (
                          context,
                          sonidosActivos,
                          _,
                        ) {
                          return ValueListenableBuilder<
                              bool>(
                            valueListenable:
                                AppConfig
                                    .vibracionActiva,
                            builder: (
                              context,
                              vibracionActiva,
                              _,
                            ) {
                              return Column(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  // ==========================================
                                  // BARRA SUPERIOR
                                  // ==========================================

                                  Container(
                                    width: 48,
                                    height: 5,
                                    decoration:
                                        BoxDecoration(
                                      color: modoOscuro
                                          ? Colors
                                              .white24
                                          : Colors
                                              .black26,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        20,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 17,
                                  ),

                                  // ==========================================
                                  // ENCABEZADO
                                  // ==========================================

                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            59,
                                        height:
                                            59,
                                        decoration:
                                            BoxDecoration(
                                          color:
                                              const Color(
                                            0xFF7B2CBF,
                                          ).withValues(
                                            alpha:
                                                0.12,
                                          ),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            18,
                                          ),
                                        ),
                                        child:
                                            const Icon(
                                          Icons
                                              .settings_rounded,
                                          color:
                                              Color(
                                            0xFF7B2CBF,
                                          ),
                                          size:
                                              34,
                                        ),
                                      ),

                                      const SizedBox(
                                        width:
                                            13,
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              T.txt(
                                                'settingsTitle',
                                              ),
                                              style:
                                                  TextStyle(
                                                fontFamily:
                                                    'Fredoka',
                                                fontSize:
                                                    26,
                                                fontWeight:
                                                    FontWeight
                                                        .w800,
                                                color: modoOscuro
                                                    ? Colors
                                                        .white
                                                    : const Color(
                                                        0xFF4A2C82,
                                                      ),
                                              ),
                                            ),
                                            Text(
                                              T.txt(
                                                'settingsNote',
                                              ),
                                              maxLines:
                                                  2,
                                              overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                              style:
                                                  TextStyle(
                                                fontFamily:
                                                    'Baloo2',
                                                fontSize:
                                                    13.5,
                                                color: modoOscuro
                                                    ? Colors
                                                        .white60
                                                    : Colors
                                                        .black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ACERCA DE LA APP
                                      IconButton(
                                        tooltip:
                                            T.txt(
                                          'aboutApp',
                                        ),
                                        onPressed:
                                            () {
                                          mostrarAcercaDelApp(
                                            sheetContext,
                                            modoOscuro,
                                          );
                                        },
                                        icon:
                                            const Icon(
                                          Icons
                                              .info_outline_rounded,
                                          color:
                                              Color(
                                            0xFF7B2CBF,
                                          ),
                                        ),
                                      ),

                                      // CERRAR
                                      IconButton(
                                        tooltip:
                                            T.txt(
                                          'close',
                                        ),
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                            sheetContext,
                                          );
                                        },
                                        icon:
                                            const Icon(
                                          Icons
                                              .close_rounded,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 22,
                                  ),

                                  // ==========================================
                                  // SONIDO
                                  // ==========================================

                                  SettingCard(
                                    color: sonidosActivos
                                        ? Colors.green
                                        : Colors
                                            .redAccent,
                                    icon: sonidosActivos
                                        ? Icons
                                            .volume_up_rounded
                                        : Icons
                                            .volume_off_rounded,
                                    title:
                                        T.txt(
                                      'sounds',
                                    ),
                                    subtitle: sonidosActivos
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
                                          Colors
                                              .redAccent,
                                      onChanged:
                                          (
                                        valor,
                                      ) async {
                                        await reproducirSonidoSwitch(
                                          forzar:
                                              true,
                                        );

                                        await AppConfig
                                            .cambiarSonidos(
                                          valor,
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  // ==========================================
                                  // IDIOMA
                                  // ==========================================

                                  SettingCard(
                                    color: idiomaAuto
                                        ? const Color(
                                            0xFF00A896,
                                          )
                                        : Colors
                                            .deepPurple,
                                    icon: idiomaAuto
                                        ? Icons
                                            .translate_rounded
                                        : Icons
                                            .language_rounded,
                                    title:
                                        T.txt(
                                      'language',
                                    ),
                                    subtitle: idiomaAuto
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

                                  // ==========================================
                                  // VIBRACIÓN
                                  // ==========================================

                                  FutureBuilder<bool>(
                                    future:
                                        dispositivoPermiteVibracion(),
                                    builder: (
                                      context,
                                      snapshot,
                                    ) {
                                      final bool puedeVibrar =
                                          snapshot.data ??
                                              false;

                                      if (!puedeVibrar) {
                                        return const SizedBox
                                            .shrink();
                                      }

                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height:
                                                14,
                                          ),

                                          SettingCard(
                                            color: vibracionActiva
                                                ? Colors
                                                    .orange
                                                : Colors
                                                    .blueGrey,
                                            icon: vibracionActiva
                                                ? Icons
                                                    .vibration_rounded
                                                : Icons
                                                    .phone_android_rounded,
                                            title:
                                                T.txt(
                                              'vibration',
                                            ),
                                            subtitle: vibracionActiva
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
                                                  Colors
                                                      .orange,
                                              inactiveColor:
                                                  Colors
                                                      .blueGrey,
                                              onChanged:
                                                  (
                                                valor,
                                              ) async {
                                                await reproducirSonidoSwitch();

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
                                    height: 14,
                                  ),

                                  // ==========================================
                                  // APARIENCIA
                                  // ==========================================

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
                                        nuevoTema,
                                      ) async {
                                        await AppConfig
                                            .cambiarTema(
                                          nuevoTema,
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  // ==========================================
                                  // PRIVACIDAD
                                  // ==========================================

                                  SettingCard(
                                    color:
                                        const Color(
                                      0xFF00A896,
                                    ),
                                    icon:
                                        Icons.shield_outlined,
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
                                        const Icon(
                                      Icons
                                          .chevron_right_rounded,
                                      color:
                                          Color(
                                        0xFF00A896,
                                      ),
                                      size:
                                          28,
                                    ),
                                    onTap:
                                        () async {
                                      Navigator.pop(
                                        sheetContext,
                                      );

                                      await Future<void>
                                          .delayed(
                                        const Duration(
                                          milliseconds:
                                              100,
                                        ),
                                      );

                                      if (!pageContext
                                          .mounted) {
                                        return;
                                      }

                                      await Navigator.push(
                                        pageContext,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const PrivacyPage(),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
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
          );
        },
      );
    },
  );
}

// ============================================================================
// TARJETA DE CONFIGURACIÓN
// ============================================================================

class SettingCard extends StatelessWidget {
  final Color color;
  final IconData icon;

  final String title;
  final String subtitle;

  final Widget trailing;

  final bool modoOscuro;

  final VoidCallback? onTap;

  const SettingCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.modoOscuro,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool estrecho =
            constraints.maxWidth <
                390;

        final Widget content =
            Container(
          width:
              double.infinity,
          padding:
              EdgeInsets.all(
            estrecho ? 14 : 16,
          ),
          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              colors: <Color>[
                modoOscuro
                    ? const Color(
                        0xFF211B2E,
                      )
                    : Colors.white,
                color.withValues(
                  alpha: modoOscuro
                      ? 0.18
                      : 0.09,
                ),
              ],
            ),
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            border:
                Border.all(
              color:
                  color.withValues(
                alpha: modoOscuro
                    ? 0.30
                    : 0.16,
              ),
              width: 1.4,
            ),
          ),
          child: estrecho
              ? Column(
                  children: [
                    Row(
                      children: [
                        SettingIcon(
                          color: color,
                          icon: icon,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: SettingText(
                            title: title,
                            subtitle:
                                subtitle,
                            modoOscuro:
                                modoOscuro,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Align(
                      alignment:
                          Alignment
                              .centerRight,
                      child:
                          trailing,
                    ),
                  ],
                )
              : Row(
                  children: [
                    SettingIcon(
                      color: color,
                      icon: icon,
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: SettingText(
                        title: title,
                        subtitle:
                            subtitle,
                        modoOscuro:
                            modoOscuro,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    trailing,
                  ],
                ),
        );

        if (onTap == null) {
          return content;
        }

        return Material(
          color:
              Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            22,
          ),
          child: InkWell(
            onTap:
                onTap,
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            child:
                content,
          ),
        );
      },
    );
  }
}

// ============================================================================
// ICONO DE CONFIGURACIÓN
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
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: <Color>[
            color.withValues(
              alpha: 0.25,
            ),
            color.withValues(
              alpha: 0.10,
            ),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 30,
      ),
    );
  }
}

// ============================================================================
// TEXTO DE CONFIGURACIÓN
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily:
                'Fredoka',
            fontSize: 18,
            fontWeight:
                FontWeight.w700,
            color: modoOscuro
                ? Colors.white
                : const Color(
                    0xFF2D2D2D,
                  ),
          ),
        ),

        const SizedBox(
          height: 3,
        ),

        Text(
          subtitle,
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily:
                'Baloo2',
            fontSize: 14.5,
            color: modoOscuro
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

class AdaptiveSwitch extends StatelessWidget {
  final bool value;

  final Color activeColor;
  final Color inactiveColor;

  final Future<void> Function(
    bool value,
  ) onChanged;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      activeThumbColor:
          activeColor,
      inactiveThumbColor:
          inactiveColor,
      onChanged: (
        value,
      ) async {
        await onChanged(
          value,
        );
      },
    );
  }
}

// ============================================================================
// SELECTOR DE IDIOMA
// ============================================================================

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
    final Color seleccionado =
        idiomaAuto
            ? const Color(
                0xFF00A896,
              )
            : idiomaActual == 'en'
                ? Colors.deepPurple
                : Colors.orange;

    return Container(
      padding:
          const EdgeInsets.all(
        4,
      ),
      decoration:
          BoxDecoration(
        color: modoOscuro
            ? const Color(
                0xFF15131A,
              )
            : const Color(
                0xFFF2ECFF,
              ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              seleccionado.withValues(
            alpha: 0.22,
          ),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          LanguageOptionButton(
            text: 'A',
            icon: Icons
                .settings_suggest_rounded,
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
            onTap: () async {
              await AppConfig
                  .cambiarIdiomaAutomatico();
            },
          ),

          LanguageOptionButton(
            text: 'ES',
            selected:
                !idiomaAuto &&
                    idiomaActual == 'es',
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            tooltip:
                T.txt(
              'spanish',
            ),
            onTap: () async {
              await AppConfig
                  .cambiarIdioma(
                'es',
              );
            },
          ),

          LanguageOptionButton(
            text: 'EN',
            selected:
                !idiomaAuto &&
                    idiomaActual == 'en',
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            tooltip:
                T.txt(
              'english',
            ),
            onTap: () async {
              await AppConfig
                  .cambiarIdioma(
                'en',
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
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          tooltip,
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 220,
        ),
        margin:
            const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? selectedColor
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          onTap: () async {
            await onTap();
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 9,
            ),
            child: icon != null
                ? Icon(
                    icon,
                    size: 20,
                    color: selected
                        ? Colors.white
                        : modoOscuro
                            ? Colors.white70
                            : const Color(
                                0xFF4A2C82,
                              ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontFamily:
                          'Fredoka',
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w800,
                      color: selected
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

class ThemeSelector extends StatelessWidget {
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

  Color _selectedColor() {
    switch (temaActual) {
      case ThemeMode.system:
        return const Color(
          0xFF00A896,
        );

      case ThemeMode.dark:
        return Colors.indigo;

      case ThemeMode.light:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color seleccionado =
        _selectedColor();

    return Container(
      padding:
          const EdgeInsets.all(
        4,
      ),
      decoration:
          BoxDecoration(
        color: modoOscuro
            ? const Color(
                0xFF15131A,
              )
            : const Color(
                0xFFF2ECFF,
              ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              seleccionado.withValues(
            alpha: 0.22,
          ),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          ThemeOptionButton(
            icon: Icons
                .brightness_auto_rounded,
            selected:
                temaActual ==
                    ThemeMode.system,
            selectedColor:
                seleccionado,
            modoOscuro:
                modoOscuro,
            tooltip:
                T.txt(
              'themeAutomatic',
            ),
            onTap: () async {
              await onChanged(
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
            tooltip:
                T.txt(
              'lightMode',
            ),
            onTap: () async {
              await onChanged(
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
            tooltip:
                T.txt(
              'darkMode',
            ),
            onTap: () async {
              await onChanged(
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

  final String tooltip;

  final Future<void> Function()
      onTap;

  const ThemeOptionButton({
    super.key,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.modoOscuro,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          horizontal: 2,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? selectedColor
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          onTap: () async {
            await onTap();
          },
          child:
              Padding(
            padding:
                const EdgeInsets.all(
              9,
            ),
            child: Icon(
              icon,
              size: 22,
              color: selected
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
    );
  }
}

// ============================================================================
// TARJETA DE ACERCA DE
// ============================================================================

class _AboutInfoCard extends StatelessWidget {
  final bool modoOscuro;

  final IconData icon;

  final Color color;

  final String title;
  final String description;

  const _AboutInfoCard({
    required this.modoOscuro,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color: modoOscuro
            ? const Color(
                0xFF211B2E,
              )
            : Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              color.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color: modoOscuro
                        ? Colors.white
                        : const Color(
                            0xFF2D2D2D,
                          ),
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  description,
                  style: TextStyle(
                    fontFamily:
                        'Baloo2',
                    fontSize: 13.5,
                    height: 1.25,
                    color: modoOscuro
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
}