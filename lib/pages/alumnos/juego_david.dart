import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import '../app_config.dart';
import '../app_texts.dart';

class JuegoDavidPage extends StatefulWidget {
  const JuegoDavidPage({super.key});

  @override
  State<JuegoDavidPage> createState() => _JuegoDavidPageState();
}

class _JuegoDavidPageState extends State<JuegoDavidPage> {
  String mensajeKey = 'touchAnimal';
  String? animalMensajeKey;

  int puntos = 0;
  int estrellasNotificadas = 0;
  int medallasNotificadas = 0;

  String animalActivoKey = '';
  String premioMensajeKey = 'zooRewardDefault';
  String premioEmoji = '🎁';

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer audioPremio = AudioPlayer();

  Timer? timerAnimal;
  Timer? timerPremio;

  final List<Map<String, dynamic>> animales = [
    {
      'key': 'dog',
      'emoji': '🐶',
      'color': const Color(0xFF8D6E63),
      'sonido': 'perro.mp3',
    },
    {
      'key': 'cat',
      'emoji': '🐱',
      'color': const Color(0xFF7B2CBF),
      'sonido': 'gato.mp3',
    },
    {
      'key': 'chick',
      'emoji': '🐥',
      'color': const Color(0xFFFF8C42),
      'sonido': 'pollito.mp3',
    },
    {
      'key': 'cow',
      'emoji': '🐮',
      'color': const Color(0xFF00A896),
      'sonido': 'vaca.mp3',
    },
  ];

  Future<void> vibrarToque() async {
    if (!AppConfig.vibracionActiva.value) return;

    try {
      if (!kIsWeb) {
        final bool tieneVibrador = await Vibration.hasVibrator();

        if (tieneVibrador) {
          await Vibration.vibrate(duration: 70);
          return;
        }
      }

      await HapticFeedback.selectionClick();
    } catch (_) {
      try {
        await HapticFeedback.lightImpact();
      } catch (_) {}
    }
  }

  Future<void> vibrarPremio({required bool medalla, bool ambos = false}) async {
    if (!AppConfig.vibracionActiva.value) return;

    try {
      if (!kIsWeb) {
        final bool tieneVibrador = await Vibration.hasVibrator();

        if (tieneVibrador) {
          if (ambos) {
            await Vibration.vibrate(pattern: [0, 120, 60, 120, 60, 180]);
          } else if (medalla) {
            await Vibration.vibrate(pattern: [0, 180, 70, 180]);
          } else {
            await Vibration.vibrate(duration: 130);
          }
          return;
        }
      }

      if (ambos) {
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 120));
        await HapticFeedback.mediumImpact();
      } else if (medalla) {
        await HapticFeedback.heavyImpact();
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (_) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  Future<void> tocarAnimal({
    required String animalKey,
    required String sonido,
  }) async {
    setState(() {
      puntos++;
      mensajeKey = 'correctAnimal';
      animalMensajeKey = animalKey;
      animalActivoKey = animalKey;
    });

    timerAnimal?.cancel();

    await vibrarToque();

    await audioPlayer.stop();

    if (AppConfig.sonidosActivos.value) {
      await audioPlayer.play(AssetSource('sonidos/$sonido'));
    }

    await revisarPremio();

    timerAnimal = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      setState(() {
        animalActivoKey = '';
      });
    });
  }

  Future<void> revisarPremio() async {
    final bool ganoEstrella = puntos > 0 && puntos % 3 == 0;
    final bool ganoMedalla = puntos > 0 && puntos % 5 == 0;

    if (ganoEstrella && ganoMedalla) {
      estrellasNotificadas++;
      medallasNotificadas++;

      setState(() {
        premioEmoji = '⭐🏅';
        premioMensajeKey = 'zooRewardBoth';
      });

      await activarPremio(sonido: 'medalla.mp3', medalla: true, ambos: true);
      return;
    }

    if (ganoMedalla) {
      medallasNotificadas++;

      setState(() {
        premioEmoji = '🏅';
        premioMensajeKey = 'zooRewardMedal';
      });

      await activarPremio(sonido: 'medalla.mp3', medalla: true);
      return;
    }

    if (ganoEstrella) {
      estrellasNotificadas++;

      setState(() {
        premioEmoji = '⭐';
        premioMensajeKey = 'zooRewardStar';
      });

      await activarPremio(sonido: 'estrella.mp3', medalla: false);
    }
  }

  Future<void> activarPremio({
    required String sonido,
    required bool medalla,
    bool ambos = false,
  }) async {
    await vibrarPremio(medalla: medalla, ambos: ambos);

    if (AppConfig.sonidosActivos.value) {
      try {
        await audioPremio.stop();
        await audioPremio.play(AssetSource('sonidos/$sonido'));
      } catch (e) {
        debugPrint('No se pudo reproducir sonido de premio: $e');
      }
    }

    timerPremio?.cancel();

    timerPremio = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      setState(() {
        premioEmoji = '🎁';
        premioMensajeKey = 'zooRewardDefault';
      });
    });
  }

  String mensajePrincipal() {
    if (mensajeKey == 'correctAnimal' && animalMensajeKey != null) {
      return '${T.txt('correctAnimal')} ${T.txt(animalMensajeKey!)}';
    }

    return T.txt(mensajeKey);
  }

  int calcularColumnas(double ancho) {
    if (ancho < 620) return 2;
    if (ancho < 900) return 3;
    return 4;
  }

  double calcularProporcion(double ancho, double alto) {
    if (ancho < 340) return 0.78;
    if (ancho < 390) return 0.84;
    if (alto < 700) return 1.00;
    return 0.92;
  }

  Widget encabezado(bool pantallaPequena, bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pantallaPequena ? 18 : 22,
        vertical: pantallaPequena ? 20 : 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            const Color(0xFFFF8C42).withValues(alpha: modoOscuro ? 0.22 : 0.12),
            const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.18 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(
            0xFFFF8C42,
          ).withValues(alpha: modoOscuro ? 0.32 : 0.18),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text('🦁', style: TextStyle(fontSize: pantallaPequena ? 44 : 54)),
          SizedBox(height: pantallaPequena ? 8 : 10),
          Text(
            T.txt('davidTitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: pantallaPequena ? 28 : 34,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF7B2CBF),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<bool>(
            valueListenable: AppConfig.sonidosActivos,
            builder: (context, sonidosActivos, _) {
              return Text(
                sonidosActivos
                    ? T.txt('davidSubtitleSound')
                    : T.txt('davidSubtitleNoSound'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: pantallaPequena ? 17 : 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF476F),
                  height: 1.1,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget estadoJuego(bool pantallaPequena, bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pantallaPequena ? 16 : 20,
        vertical: pantallaPequena ? 18 : 22,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            const Color(0xFFFF8C42).withValues(alpha: modoOscuro ? 0.22 : 0.13),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(
            0xFFFF8C42,
          ).withValues(alpha: modoOscuro ? 0.32 : 0.20),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: pantallaPequena ? 68 : 82,
            height: pantallaPequena ? 68 : 82,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF8C42).withValues(alpha: 0.25),
                  const Color(0xFFFF8C42).withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '🐾',
                style: TextStyle(fontSize: pantallaPequena ? 38 : 46),
              ),
            ),
          ),
          SizedBox(height: pantallaPequena ? 10 : 14),
          Text(
            mensajePrincipal(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: pantallaPequena ? 19 : 22,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFF8C42,
                  ).withValues(alpha: modoOscuro ? 0.20 : 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${T.txt('hits')}: $puntos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: pantallaPequena ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro
                        ? Colors.orange.shade200
                        : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget premioAnimal(bool pantallaPequena, bool modoOscuro) {
    final int estrellas = puntos ~/ 3;
    final int medallas = puntos ~/ 5;

    final int avanceEstrella = puntos % 3;
    final int avanceMedalla = puntos % 5;

    final int faltanEstrella = avanceEstrella == 0 && puntos > 0
        ? 0
        : 3 - avanceEstrella;

    final int faltanMedalla = avanceMedalla == 0 && puntos > 0
        ? 0
        : 5 - avanceMedalla;

    final double progresoEstrella = avanceEstrella == 0 && puntos > 0
        ? 1
        : avanceEstrella / 3;

    final double progresoMedalla = avanceMedalla == 0 && puntos > 0
        ? 1
        : avanceMedalla / 5;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            const Color(0xFFFFC300).withValues(alpha: modoOscuro ? 0.20 : 0.14),
            const Color(0xFFFF006E).withValues(alpha: modoOscuro ? 0.14 : 0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(
            0xFFFFC300,
          ).withValues(alpha: modoOscuro ? 0.38 : 0.25),
          width: 1.7,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC300).withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedScale(
                scale: premioEmoji == '🎁' ? 1.0 : 1.18,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: pantallaPequena ? 58 : 68,
                  height: pantallaPequena ? 58 : 68,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFC300).withValues(alpha: 0.30),
                        const Color(0xFFFF006E).withValues(alpha: 0.13),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      premioEmoji,
                      style: TextStyle(fontSize: pantallaPequena ? 30 : 36),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      T.txt('zooRewardsTitle'),
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: pantallaPequena ? 20 : 23,
                        fontWeight: FontWeight.w700,
                        color: modoOscuro
                            ? Colors.white
                            : const Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      T.txt(premioMensajeKey),
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: pantallaPequena ? 14.5 : 16,
                        fontWeight: FontWeight.w600,
                        color: modoOscuro ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _barraPremio(
            titulo: T.txt('zooNextStar'),
            avance: '$avanceEstrella/3',
            progreso: progresoEstrella,
            color: Colors.amber,
            icono: Icons.star_rounded,
            mensaje: faltanEstrella == 0
                ? T.txt('zooStarUnlocked')
                : '${T.txt('zooMissingForStar')} $faltanEstrella ${T.txt('zooAnimalsForStar')}',
            modoOscuro: modoOscuro,
          ),
          const SizedBox(height: 14),
          _barraPremio(
            titulo: T.txt('zooNextMedal'),
            avance: '$avanceMedalla/5',
            progreso: progresoMedalla,
            color: Colors.deepPurple,
            icono: Icons.emoji_events_rounded,
            mensaje: faltanMedalla == 0
                ? T.txt('zooMedalUnlocked')
                : '${T.txt('zooMissingForMedal')} $faltanMedalla ${T.txt('zooAnimalsForMedal')}',
            modoOscuro: modoOscuro,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _premioMiniCard(
                icono: '⭐',
                valor: estrellas,
                texto: T.txt('zooStars'),
                color: Colors.amber,
                modoOscuro: modoOscuro,
              ),
              const SizedBox(width: 10),
              _premioMiniCard(
                icono: '🏅',
                valor: medallas,
                texto: T.txt('zooMedals'),
                color: Colors.deepPurple,
                modoOscuro: modoOscuro,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _barraPremio({
    required String titulo,
    required String avance,
    required double progreso,
    required Color color,
    required IconData icono,
    required String mensaje,
    required bool modoOscuro,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: modoOscuro ? 0.16 : 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.30 : 0.18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 27),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                  ),
                ),
              ),
              Text(
                avance,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 12,
              backgroundColor: modoOscuro
                  ? Colors.white12
                  : Colors.black.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _premioMiniCard({
    required String icono,
    required int valor,
    required String texto,
    required Color color,
    required bool modoOscuro,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: modoOscuro ? 0.18 : 0.11),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: modoOscuro ? 0.32 : 0.20),
          ),
        ),
        child: Column(
          children: [
            Text(icono, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 3),
            Text(
              '$valor',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: modoOscuro ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget animalCard({
    required String animalKey,
    required String emoji,
    required Color color,
    required String sonido,
    required bool pantallaPequena,
    required bool modoOscuro,
  }) {
    final bool activo = animalActivoKey == animalKey;

    return GestureDetector(
      onTap: () async {
        await tocarAnimal(animalKey: animalKey, sonido: sonido);
      },
      child: AnimatedScale(
        scale: activo ? 1.06 : 1.0,
        duration: const Duration(milliseconds: 230),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          padding: EdgeInsets.all(pantallaPequena ? 9 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                activo
                    ? color.withValues(alpha: modoOscuro ? 0.34 : 0.24)
                    : color.withValues(alpha: modoOscuro ? 0.18 : 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(pantallaPequena ? 22 : 26),
            border: Border.all(
              color: color.withValues(alpha: activo ? 0.75 : 0.25),
              width: activo ? 4 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: activo ? 0.32 : 0.12),
                blurRadius: activo ? 18 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double emojiSize = constraints.maxWidth * 0.42;

              if (pantallaPequena) {
                emojiSize = emojiSize.clamp(42, 60);
              } else {
                emojiSize = emojiSize.clamp(50, 76);
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: activo ? 1.18 : 1.0,
                    duration: const Duration(milliseconds: 230),
                    child: Text(emoji, style: TextStyle(fontSize: emojiSize)),
                  ),
                  SizedBox(height: pantallaPequena ? 5 : 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      T.txt(animalKey),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: pantallaPequena ? 20 : 25,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  SizedBox(height: pantallaPequena ? 2 : 4),
                  ValueListenableBuilder<bool>(
                    valueListenable: AppConfig.sonidosActivos,
                    builder: (context, sonidosActivos, _) {
                      return Icon(
                        sonidosActivos
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        color: color,
                        size: pantallaPequena ? 21 : 25,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget gridAnimales(double ancho, double alto, bool modoOscuro) {
    final bool pantallaPequena = alto < 720 || ancho < 380;
    final int columnas = calcularColumnas(ancho);
    final double proporcion = calcularProporcion(ancho, alto);

    return GridView.builder(
      itemCount: animales.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnas,
        crossAxisSpacing: pantallaPequena ? 10 : 16,
        mainAxisSpacing: pantallaPequena ? 10 : 16,
        childAspectRatio: proporcion,
      ),
      itemBuilder: (context, index) {
        final animal = animales[index];

        return animalCard(
          animalKey: animal['key'],
          emoji: animal['emoji'],
          color: animal['color'],
          sonido: animal['sonido'],
          pantallaPequena: pantallaPequena,
          modoOscuro: modoOscuro,
        );
      },
    );
  }

  @override
  void dispose() {
    timerAnimal?.cancel();
    timerPremio?.cancel();
    audioPlayer.dispose();
    audioPremio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: AppConfig.sonidosActivos,
          builder: (context, sonidosActivos, _) {
            return ValueListenableBuilder<ThemeMode>(
              valueListenable: AppConfig.temaApp,
              builder: (context, temaActual, _) {
                final bool modoOscuro =
                    Theme.of(context).brightness == Brightness.dark;

                return Scaffold(
                  backgroundColor: modoOscuro
                      ? const Color(0xFF15131A)
                      : const Color(0xFFFAF7F2),
                  appBar: AppBar(
                    title: Text(
                      T.txt('gameDavid'),
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: modoOscuro
                            ? Colors.white
                            : const Color(0xFF2D2D2D),
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: modoOscuro
                        ? const Color(0xFF211B2E)
                        : Colors.white,
                    foregroundColor: modoOscuro
                        ? Colors.white
                        : const Color(0xFF2D2D2D),
                    elevation: 0,
                  ),
                  body: SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double ancho = constraints.maxWidth;
                        final double alto = constraints.maxHeight;
                        final bool pantallaPequena = alto < 720 || ancho < 380;

                        return SingleChildScrollView(
                          padding: EdgeInsets.all(pantallaPequena ? 14 : 18),
                          child: Column(
                            children: [
                              encabezado(pantallaPequena, modoOscuro),
                              SizedBox(height: pantallaPequena ? 14 : 18),
                              estadoJuego(pantallaPequena, modoOscuro),
                              SizedBox(height: pantallaPequena ? 14 : 18),
                              premioAnimal(pantallaPequena, modoOscuro),
                              SizedBox(height: pantallaPequena ? 18 : 24),
                              gridAnimales(ancho, alto, modoOscuro),
                            ],
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
      },
    );
  }
}
