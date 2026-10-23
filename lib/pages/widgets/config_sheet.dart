import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import '../../features/privacy/pages/privacy_page.dart';
import '../../features/children/data/child_repository.dart';
import '../app_config.dart';
import '../app_texts.dart';

const String _appVersion = '1.1.0';
// ============================================================================
// VIBRACIÓN
// ============================================================================

Future<bool> dispositivoPermiteVibracion() async {
  if (kIsWeb) {
    return false;
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      return await Vibration.hasVibrator();
    } catch (_) {
      return false;
    }
  }

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return true;
  }

  return false;
}

Future<void> vibrarActivacionFuerte() async {
  try {
    if (kIsWeb) {
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final bool tieneVibrador = await Vibration.hasVibrator();

      if (tieneVibrador) {
        await Vibration.vibrate(pattern: <int>[0, 120, 60, 120]);

        return;
      }
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await HapticFeedback.heavyImpact();
    }
  } catch (_) {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }
}

// ============================================================================
// TEXTO DEL TEMA
// ============================================================================

String textoTema(ThemeMode tema) {
  switch (tema) {
    case ThemeMode.system:
      return T.txt('themeAutomatic');

    case ThemeMode.light:
      return T.txt('lightMode');

    case ThemeMode.dark:
      return T.txt('darkMode');
  }
}

IconData iconoTema(ThemeMode tema) {
  switch (tema) {
    case ThemeMode.system:
      return Icons.brightness_auto_rounded;

    case ThemeMode.light:
      return Icons.light_mode_rounded;

    case ThemeMode.dark:
      return Icons.dark_mode_rounded;
  }
}

Color colorTema(ThemeMode tema) {
  switch (tema) {
    case ThemeMode.system:
      return const Color(0xFF00A896);

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
    return T.txt('languageAutomatic');
  }

  switch (idiomaActual) {
    case 'en':
      return T.txt('english');

    case 'qu':
      return T.txt('kichwa');

    case 'es':
    default:
      return T.txt('spanish');
  }
}

// ============================================================================
// COLOR DEL IDIOMA
// ============================================================================

Color _colorIdioma({required bool idiomaAuto, required String idiomaActual}) {
  if (idiomaAuto) {
    return const Color(0xFF00A896);
  }

  switch (idiomaActual) {
    case 'en':
      return Colors.deepPurple;

    case 'qu':
      return const Color(0xFF2E7D32);

    case 'es':
    default:
      return Colors.orange;
  }
}

// ============================================================================
// ACERCA DE
// ============================================================================

void _mostrarAcercaDe(BuildContext context, bool modoOscuro) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.48),
    builder: (BuildContext dialogContext) {
      final Color fondo = modoOscuro
          ? const Color(0xFF17131E)
          : const Color(0xFFFFFCF8);

      final Color textoPrincipal = modoOscuro
          ? Colors.white
          : const Color(0xFF30243A);

      final Color textoSecundario = modoOscuro
          ? Colors.white70
          : const Color(0xFF6F6577);

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 690),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              color: fondo,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ==========================================================
                  // CABECERA
                  // ==========================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 14, 22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: modoOscuro
                            ? const <Color>[
                                Color(0xFF4A2C82),
                                Color(0xFF7B2CBF),
                                Color(0xFFB5179E),
                              ]
                            : const <Color>[
                                Color(0xFFF4E8FF),
                                Color(0xFFFFE8F3),
                                Color(0xFFFFF0D9),
                              ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -30,
                          right: -18,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(
                                alpha: modoOscuro ? 0.08 : 0.32,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -48,
                          left: -34,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFFFFC300,
                              ).withValues(alpha: modoOscuro ? 0.10 : 0.18),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                tooltip: T.txt('close'),
                                onPressed: () => Navigator.pop(dialogContext),
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: modoOscuro
                                      ? Colors.white
                                      : const Color(0xFF4A2C82),
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withValues(
                                    alpha: modoOscuro ? 0.12 : 0.72,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color(0xFFFFC300),
                                    Color(0xFFFF7B00),
                                    Color(0xFFFF006E),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  width: 4,
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.14),
                                    blurRadius: 18,
                                    offset: const Offset(0, 7),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/images/home.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.child_care_rounded,
                                      size: 50,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Wawa Kalú',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 29,
                                fontWeight: FontWeight.w900,
                                color: modoOscuro
                                    ? Colors.white
                                    : const Color(0xFF4A2C82),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: modoOscuro ? 0.12 : 0.78,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withValues(
                                    alpha: modoOscuro ? 0.16 : 0.75,
                                  ),
                                ),
                              ),
                              child: Text(
                                '${T.txt('appVersion')} $_appVersion',
                                style: TextStyle(
                                  fontFamily: 'Fredoka',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: modoOscuro
                                      ? Colors.white
                                      : const Color(0xFF6C3BAA),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ==========================================================
                  // CONTENIDO
                  // ==========================================================
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            T.txt('aboutApp'),
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: textoPrincipal,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            T.txt('aboutAppSubtitle'),
                            style: TextStyle(
                              fontFamily: 'Baloo2',
                              fontSize: 15.5,
                              height: 1.42,
                              color: textoSecundario,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _AboutSectionCard(
                                  modoOscuro: modoOscuro,
                                  icon: Icons.health_and_safety_rounded,
                                  color: const Color(0xFF00A896),
                                  title: T.txt('health'),
                                  description: T.txt('healthHeaderSubtitle'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AboutSectionCard(
                                  modoOscuro: modoOscuro,
                                  icon: Icons.auto_stories_rounded,
                                  color: const Color(0xFF7B2CBF),
                                  title: T.txt('learning'),
                                  description: T.txt('learningHeaderSubtitle'),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            T.txt('projectFeatures'),
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: textoPrincipal,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _AboutFeatureChip(
                                icon: Icons.vaccines_rounded,
                                text: T.txt('vaccines'),
                                color: const Color(0xFFEF476F),
                                modoOscuro: modoOscuro,
                              ),
                              _AboutFeatureChip(
                                icon: Icons.show_chart_rounded,
                                text: T.txt('growth'),
                                color: const Color(0xFF118AB2),
                                modoOscuro: modoOscuro,
                              ),
                              _AboutFeatureChip(
                                icon: Icons.restaurant_menu_rounded,
                                text: T.txt('nutrition'),
                                color: const Color(0xFF06A77D),
                                modoOscuro: modoOscuro,
                              ),
                              _AboutFeatureChip(
                                icon: Icons.menu_book_rounded,
                                text: T.txt('familyGuide'),
                                color: const Color(0xFFFF9F1C),
                                modoOscuro: modoOscuro,
                              ),
                              _AboutFeatureChip(
                                icon: Icons.record_voice_over_rounded,
                                text: T.txt('languageMenu'),
                                color: const Color(0xFFFF006E),
                                modoOscuro: modoOscuro,
                              ),
                              _AboutFeatureChip(
                                icon: Icons.home_rounded,
                                text: T.txt('protectiveEnvironments'),
                                color: const Color(0xFF7B2CBF),
                                modoOscuro: modoOscuro,
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: modoOscuro
                                    ? [
                                        const Color(0xFF241D30),
                                        const Color(0xFF7B2CBF)
                                            .withValues(alpha: 0.13),
                                      ]
                                    : [
                                        Colors.white,
                                        const Color(0xFFF8F0FF),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFF7B2CBF).withValues(
                                  alpha: modoOscuro ? 0.22 : 0.13,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7B2CBF).withValues(
                                    alpha: modoOscuro ? 0.05 : 0.08,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7B2CBF)
                                            .withValues(
                                          alpha: modoOscuro ? 0.22 : 0.10,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.draw_rounded,
                                        color: Color(0xFF7B2CBF),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        T.txt('developers'),
                                        style: TextStyle(
                                          fontFamily: 'Fredoka',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: textoPrincipal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _DeveloperSignature(
                                  name: 'DAVID SANTANA',
                                  modoOscuro: modoOscuro,
                                  colors: const [
                                    Color(0xFF7B2CBF),
                                    Color(0xFFFF006E),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _DeveloperSignature(
                                  name: 'KERLY TELLO',
                                  modoOscuro: modoOscuro,
                                  colors: const [
                                    Color(0xFF00A896),
                                    Color(0xFF118AB2),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Center(
                            child: Text(
                              'Wawa Kalú • Ecuador',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: textoSecundario,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

// ============================================================================
// HOJA DE CONFIGURACIÓN
// ============================================================================

void showConfigSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.34),
    builder: (BuildContext sheetContext) {
      final double altoPantalla = MediaQuery.of(sheetContext).size.height;

      return ValueListenableBuilder<ThemeMode>(
        valueListenable: AppConfig.temaApp,
        builder: (context, temaActual, _) {
          final bool modoOscuro =
              Theme.of(context).brightness == Brightness.dark;

          final Color colorApariencia = colorTema(temaActual);

          return ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(34),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 26,
                sigmaY: 26,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: modoOscuro
                        ? [
                            const Color(0xFF211B2E).withValues(alpha: 0.94),
                            const Color(0xFF17131E).withValues(alpha: 0.91),
                            const Color(0xFF2A1D36).withValues(alpha: 0.88),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.88),
                            const Color(0xFFFFF8F2).withValues(alpha: 0.91),
                            const Color(0xFFF5EDFF).withValues(alpha: 0.86),
                          ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(34),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(
                        alpha: modoOscuro ? 0.14 : 0.92,
                      ),
                      width: 1.2,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: modoOscuro ? 0.30 : 0.14,
                      ),
                      blurRadius: 34,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: altoPantalla * 0.92,
                    ),
                    child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 18,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 22,
                  ),
                  child: ValueListenableBuilder<String>(
                    valueListenable: AppConfig.idioma,
                    builder: (context, idiomaActual, _) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: AppConfig.idiomaAuto,
                        builder: (context, idiomaAuto, _) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: AppConfig.vibracionActiva,
                                builder: (context, vibracionActiva, _) {
                                  final Color colorIdioma = _colorIdioma(
                                    idiomaAuto: idiomaAuto,
                                    idiomaActual: idiomaActual,
                                  );

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _SettingsGlassHero(
                                        modoOscuro: modoOscuro,
                                      ),

                                      const SizedBox(height: 18),

                                      // ======================================================
                                      // IDIOMA
                                      // ======================================================
                                      SettingCard(
                                        color: colorIdioma,
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

                                      // ======================================================
                                      // VIBRACIÓN
                                      // ======================================================
                                      FutureBuilder<bool>(
                                        future: dispositivoPermiteVibracion(),
                                        builder: (context, snapshot) {
                                          final bool puedeVibrar =
                                              snapshot.data ?? false;

                                          if (!puedeVibrar) {
                                            return const SizedBox.shrink();
                                          }

                                          return Column(
                                            children: [
                                              const SizedBox(height: 14),
                                              SettingCard(
                                                color: vibracionActiva
                                                    ? Colors.orange
                                                    : Colors.blueGrey,
                                                icon: vibracionActiva
                                                    ? Icons.vibration_rounded
                                                    : Icons
                                                          .phone_android_rounded,
                                                title: T.txt('vibration'),
                                                subtitle: vibracionActiva
                                                    ? T.txt('vibrationOn')
                                                    : T.txt('vibrationOff'),
                                                modoOscuro: modoOscuro,
                                                trailing: AdaptiveSwitch(
                                                  value: vibracionActiva,
                                                  activeColor: Colors.orange,
                                                  inactiveColor:
                                                      Colors.blueGrey,
                                                  onChanged: (bool valor) async {
                                                    await AppConfig.cambiarVibracion(
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

                                      const SizedBox(height: 14),

                                      // ======================================================
                                      // APARIENCIA
                                      // ======================================================
                                      SettingCard(
                                        color: colorApariencia,
                                        icon: iconoTema(temaActual),
                                        title: T.txt('appearance'),
                                        subtitle: textoTema(temaActual),
                                        modoOscuro: modoOscuro,
                                        trailing: ThemeSelector(
                                          temaActual: temaActual,
                                          modoOscuro: modoOscuro,
                                          onChanged:
                                              (ThemeMode nuevoTema) async {
                                                await AppConfig.cambiarTema(
                                                  nuevoTema,
                                                );
                                              },
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      // ======================================================
                                      // REPETIR RECORRIDO GUIADO
                                      // ======================================================
                                      if (AppConfig.bienvenidaVista.value) ...[
                                        SettingCard(
                                          color: const Color(0xFF8B5CF6),
                                          icon: Icons.auto_awesome_rounded,
                                          title: T.txt('tourReplayTitle'),
                                          subtitle: T.txt('tourReplaySubtitle'),
                                          modoOscuro: modoOscuro,
                                          trailing: IconButton(
                                            tooltip: T.txt('tourReplayTitle'),
                                            icon: const Icon(
                                              Icons.play_arrow_rounded,
                                            ),
                                            color: const Color(0xFF8B5CF6),
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF8B5CF6)
                                                      .withValues(alpha: 0.12),
                                            ),
                                            onPressed: () {
                                              Navigator.of(sheetContext).pop();
                                              AppConfig.solicitarRecorrido();
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                      ],

                                      // Guía práctica después de crear el primer perfil.
                                      if (AppConfig.bienvenidaVista.value &&
                                          ChildRepository.instance.children.value.isNotEmpty) ...[
                                        SettingCard(
                                          color: const Color(0xFF00A896),
                                          icon: Icons.explore_rounded,
                                          title: T.txt('guideFirstChildReplayTitle'),
                                          subtitle: T.txt('guideFirstChildReplaySubtitle'),
                                          modoOscuro: modoOscuro,
                                          trailing: IconButton(
                                            tooltip: T.txt('guideFirstChildReplayTitle'),
                                            icon: const Icon(Icons.play_arrow_rounded),
                                            color: const Color(0xFF00A896),
                                            style: IconButton.styleFrom(
                                              backgroundColor: const Color(0xFF00A896)
                                                  .withValues(alpha: 0.12),
                                            ),
                                            onPressed: () {
                                              Navigator.of(sheetContext).pop();
                                              AppConfig.solicitarGuiaPrimerNino();
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                      ],

                                      // ======================================================
                                      // PRIVACIDAD
                                      // ======================================================
                                      SettingCard(
                                        color: Colors.teal,
                                        icon: Icons.privacy_tip_outlined,
                                        title: T.txt('privacyAndData'),
                                        subtitle: T.txt(
                                          'privacySettingsSubtitle',
                                        ),
                                        modoOscuro: modoOscuro,
                                        trailing: IconButton(
                                          tooltip: T.txt('privacyAndData'),
                                          icon: const Icon(
                                            Icons.chevron_right_rounded,
                                          ),
                                          color: Colors.teal,
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.teal
                                                .withValues(alpha: 0.10),
                                            side: BorderSide(
                                              color: Colors.teal
                                                  .withValues(alpha: 0.14),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                builder: (context) =>
                                                    PrivacyPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      // ======================================================
                                      // ACERCA DE
                                      // ======================================================
                                      SettingCard(
                                        color: Colors.lightBlue,
                                        icon: Icons.info_outline_rounded,
                                        title: T.txt('aboutApp'),
                                        subtitle:
                                            '${T.txt('appVersion')} $_appVersion',
                                        modoOscuro: modoOscuro,
                                        trailing: IconButton(
                                          tooltip: T.txt('aboutApp'),
                                          icon: const Icon(
                                            Icons.chevron_right_rounded,
                                          ),
                                          color: Colors.lightBlue,
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.lightBlue
                                                .withValues(alpha: 0.10),
                                            side: BorderSide(
                                              color: Colors.lightBlue
                                                  .withValues(alpha: 0.14),
                                            ),
                                          ),
                                          onPressed: () {
                                            _mostrarAcercaDe(
                                              context,
                                              modoOscuro,
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 18),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 9,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: modoOscuro ? 0.045 : 0.48,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha:
                                                  modoOscuro ? 0.08 : 0.72,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.auto_awesome_rounded,
                                              size: 16,
                                              color: Color(0xFF8B5CF6),
                                            ),
                                            const SizedBox(width: 7),
                                            Text(
                                              'Wawa Kalú',
                                              style: TextStyle(
                                                fontFamily: 'Fredoka',
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w700,
                                                color: modoOscuro
                                                    ? Colors.white60
                                                    : const Color(0xFF6F667B),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 5,
                                              height: 5,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFEC5F7A),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              width: 5,
                                              height: 5,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF16B89A),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              width: 5,
                                              height: 5,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF59E55),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
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
            ),
          ),
        );
        },
      );
    },
  );
}

// ============================================================================
// TARJETAS DEL MODAL "ACERCA DE"
// ============================================================================

class _AboutSectionCard extends StatelessWidget {
  final bool modoOscuro;
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _AboutSectionCard({
    required this.modoOscuro,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: modoOscuro
            ? color.withValues(alpha: 0.12)
            : color.withValues(alpha: 0.075),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.24 : 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withValues(alpha: modoOscuro ? 0.22 : 0.13),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(height: 11),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: modoOscuro ? Colors.white : const Color(0xFF30243A),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 13.5,
              height: 1.28,
              color: modoOscuro ? Colors.white70 : const Color(0xFF6F6577),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutFeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final bool modoOscuro;

  const _AboutFeatureChip({
    required this.icon,
    required this.text,
    required this.color,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: modoOscuro ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.25 : 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF413449),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperSignature extends StatelessWidget {
  const _DeveloperSignature({
    required this.name,
    required this.modoOscuro,
    required this.colors,
  });

  final String name;
  final bool modoOscuro;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
      decoration: BoxDecoration(
        color: modoOscuro
            ? Colors.white.withValues(alpha: 0.045)
            : Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.first.withValues(
            alpha: modoOscuro ? 0.20 : 0.11,
          ),
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: colors,
              ).createShader(bounds);
            },
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 22,
                height: 1.05,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.15,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: 0.58,
              child: Container(
                height: 2.2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGlassHero extends StatelessWidget {
  const _SettingsGlassHero({
    required this.modoOscuro,
  });

  final bool modoOscuro;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 5,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7B61C9),
                Color(0xFFEC5F7A),
                Color(0xFF16B89A),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B61C9).withValues(alpha: 0.24),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 17),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: modoOscuro
                      ? [
                          Colors.white.withValues(alpha: 0.10),
                          const Color(0xFF7B61C9)
                              .withValues(alpha: 0.12),
                          const Color(0xFF16B89A)
                              .withValues(alpha: 0.07),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.78),
                          const Color(0xFFF4EFFF)
                              .withValues(alpha: 0.80),
                          const Color(0xFFEFFBF8)
                              .withValues(alpha: 0.62),
                        ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: modoOscuro ? 0.13 : 0.88,
                  ),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B61C9).withValues(
                      alpha: modoOscuro ? 0.08 : 0.12,
                    ),
                    blurRadius: 26,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -34,
                    right: -22,
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEC5F7A).withValues(
                          alpha: modoOscuro ? 0.08 : 0.07,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -38,
                    right: 54,
                    child: Container(
                      width: 102,
                      height: 102,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF16B89A).withValues(
                          alpha: modoOscuro ? 0.07 : 0.06,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF8B5CF6),
                              Color(0xFFEC5F7A),
                              Color(0xFFF59E55),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.50),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.24),
                              blurRadius: 18,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wawa Kalú',
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 12.5,
                                height: 1,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w800,
                                color: modoOscuro
                                    ? Colors.white60
                                    : const Color(0xFF7B61C9),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              T.txt('settingsTitle'),
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 27,
                                height: 1,
                                fontWeight: FontWeight.w800,
                                color: modoOscuro
                                    ? Colors.white
                                    : const Color(0xFF302942),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              T.txt('settingsNote'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 13.5,
                                height: 1.2,
                                color: modoOscuro
                                    ? Colors.white60
                                    : const Color(0xFF6F667B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool estrecho = constraints.maxWidth < 430;

        return ClipRRect(
          borderRadius: BorderRadius.circular(27),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: modoOscuro
                      ? [
                          Colors.white.withValues(alpha: 0.075),
                          color.withValues(alpha: 0.13),
                          Colors.white.withValues(alpha: 0.035),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.74),
                          color.withValues(alpha: 0.085),
                          Colors.white.withValues(alpha: 0.58),
                        ],
                ),
                borderRadius: BorderRadius.circular(27),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: modoOscuro ? 0.11 : 0.86,
                  ),
                  width: 1.15,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(
                      alpha: modoOscuro ? 0.08 : 0.13,
                    ),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(
                      alpha: modoOscuro ? 0.015 : 0.38,
                    ),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -34,
                    right: -30,
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(
                          alpha: modoOscuro ? 0.07 : 0.055,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 16,
                    bottom: 16,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.88),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.26),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      estrecho ? 16 : 17,
                      estrecho ? 15 : 16,
                      estrecho ? 14 : 16,
                      estrecho ? 15 : 16,
                    ),
                    child: estrecho
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  SettingIcon(
                                    color: color,
                                    icon: icon,
                                    modoOscuro: modoOscuro,
                                  ),
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
                                child: trailing,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              SettingIcon(
                                color: color,
                                icon: icon,
                                modoOscuro: modoOscuro,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: SettingText(
                                  title: title,
                                  subtitle: subtitle,
                                  modoOscuro: modoOscuro,
                                ),
                              ),
                              const SizedBox(width: 12),
                              trailing,
                            ],
                          ),
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
// ICONO DE TARJETA
// ============================================================================

class SettingIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool modoOscuro;

  const SettingIcon({
    super.key,
    required this.color,
    required this.icon,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: modoOscuro ? 0.32 : 0.23),
            color.withValues(alpha: modoOscuro ? 0.13 : 0.075),
          ],
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: modoOscuro ? 0.12 : 0.72,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.17),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 5,
            left: 7,
            right: 7,
            child: Container(
              height: 1,
              color: Colors.white.withValues(
                alpha: modoOscuro ? 0.11 : 0.52,
              ),
            ),
          ),
          Icon(
            icon,
            color: color,
            size: 29,
          ),
        ],
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 19,
            height: 1.05,
            fontWeight: FontWeight.w700,
            color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontSize: 15,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: modoOscuro ? Colors.white70 : Colors.black54,
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
    final bool dark =
        Theme.of(context).brightness == Brightness.dark;
    final Color accent = value ? activeColor : inactiveColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: dark ? 0.06 : 0.58,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: accent.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Switch(
        value: value,
        activeThumbColor: Colors.white,
        activeTrackColor: activeColor,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: inactiveColor.withValues(alpha: 0.44),
        onChanged: (bool valor) async {
          await onChanged(valor);
        },
      ),
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
    final Color seleccionado = _colorIdioma(
      idiomaAuto: idiomaAuto,
      idiomaActual: idiomaActual,
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: modoOscuro
              ? [
                  Colors.white.withValues(alpha: 0.075),
                  seleccionado.withValues(alpha: 0.08),
                ]
              : [
                  Colors.white.withValues(alpha: 0.72),
                  seleccionado.withValues(alpha: 0.065),
                ],
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: modoOscuro ? 0.10 : 0.82,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: seleccionado.withValues(alpha: 0.09),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        alignment: WrapAlignment.end,
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
          LanguageOptionButton(
            text: 'KI',
            selected: !idiomaAuto && idiomaActual == 'qu',
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            tooltip: T.txt('kichwa'),
            onTap: () async {
              await AppConfig.cambiarIdioma('qu');
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

class LanguageOptionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool selected;
  final Color selectedColor;
  final bool modoOscuro;
  final String tooltip;
  final Future<void> Function() onTap;

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
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    selectedColor,
                    Color.lerp(
                      selectedColor,
                      const Color(0xFF8B5CF6),
                      0.32,
                    )!,
                  ],
                )
              : null,
          color: selected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.30)
                : Colors.transparent,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await onTap();
          },
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
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 13,
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

// ============================================================================
// SELECTOR DE TEMA
// ============================================================================

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
    final Color seleccionado = colorTema(temaActual);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: modoOscuro
              ? [
                  Colors.white.withValues(alpha: 0.075),
                  seleccionado.withValues(alpha: 0.08),
                ]
              : [
                  Colors.white.withValues(alpha: 0.72),
                  seleccionado.withValues(alpha: 0.065),
                ],
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: modoOscuro ? 0.10 : 0.82,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: seleccionado.withValues(alpha: 0.09),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeOptionButton(
            icon: Icons.brightness_auto_rounded,
            selected: temaActual == ThemeMode.system,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () {
              onChanged(ThemeMode.system);
            },
          ),
          ThemeOptionButton(
            icon: Icons.light_mode_rounded,
            selected: temaActual == ThemeMode.light,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () {
              onChanged(ThemeMode.light);
            },
          ),
          ThemeOptionButton(
            icon: Icons.dark_mode_rounded,
            selected: temaActual == ThemeMode.dark,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () {
              onChanged(ThemeMode.dark);
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
        gradient: selected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  selectedColor,
                  Color.lerp(
                    selectedColor,
                    const Color(0xFF8B5CF6),
                    0.28,
                  )!,
                ],
              )
            : null,
        color: selected ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? Colors.white.withValues(alpha: 0.30)
              : Colors.transparent,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: selectedColor.withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : const [],
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
