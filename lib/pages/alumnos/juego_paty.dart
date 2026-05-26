import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_config.dart';
import '../app_texts.dart';

class JuegoPatyPage extends StatefulWidget {
  const JuegoPatyPage({super.key});

  @override
  State<JuegoPatyPage> createState() => JuegoPatyPageState();
}

class JuegoPatyPageState extends State<JuegoPatyPage> {
  int aciertos = 0;
  String figuraActiva = '';
  String mensajeKey = 'touchFigure';
  String recompensaKey = 'figureRewardDefault';

  final List<Map<String, dynamic>> figuras = [
    {
      'key': 'circle',
      'icon': Icons.circle,
      'color': Colors.blue,
    },
    {
      'key': 'square',
      'icon': Icons.crop_square_rounded,
      'color': Colors.redAccent,
    },
    {
      'key': 'triangle',
      'icon': Icons.change_history_rounded,
      'color': Colors.green,
    },
    {
      'key': 'star',
      'icon': Icons.star_rounded,
      'color': Colors.amber,
    },
  ];

  Future<void> tocarFigura(String key) async {
    if (AppConfig.vibracionActiva.value) {
      try {
        await HapticFeedback.selectionClick();
      } catch (_) {}
    }

    setState(() {
      aciertos++;
      figuraActiva = key;
      mensajeKey = 'correctFigure';

      if (aciertos > 0 && aciertos % 5 == 0) {
        recompensaKey = 'figureRewardMedal';
      } else if (aciertos > 0 && aciertos % 3 == 0) {
        recompensaKey = 'figureRewardStar';
      } else {
        recompensaKey = 'figureRewardDefault';
      }
    });

    Future.delayed(const Duration(milliseconds: 550), () {
      if (!mounted) return;
      setState(() {
        figuraActiva = '';
      });
    });
  }

  void reiniciar() {
    setState(() {
      aciertos = 0;
      figuraActiva = '';
      mensajeKey = 'touchFigure';
      recompensaKey = 'figureRewardDefault';
    });
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

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('patyGameCardTitle'),
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                  ),
                ),
                centerTitle: true,
                backgroundColor:
                    modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                foregroundColor:
                    modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                elevation: 0,
              ),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double ancho = constraints.maxWidth;
                    final bool pantallaPequena =
                        constraints.maxHeight < 720 || ancho < 380;

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(pantallaPequena ? 16 : 20),
                      child: Column(
                        children: [
                          headerPaty(
                            modoOscuro: modoOscuro,
                            pantallaPequena: pantallaPequena,
                          ),
                          const SizedBox(height: 16),
                          estadoJuego(modoOscuro),
                          const SizedBox(height: 18),
                          GridView.builder(
                            itemCount: figuras.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ancho < 620 ? 2 : 4,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: ancho < 380 ? 0.86 : 0.95,
                            ),
                            itemBuilder: (context, index) {
                              final figura = figuras[index];

                              return figuraCard(
                                keyName: figura['key'],
                                icon: figura['icon'],
                                color: figura['color'],
                                modoOscuro: modoOscuro,
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            onPressed: reiniciar,
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(T.txt('resetGame')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              textStyle: GoogleFonts.fredoka(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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
  }

  Widget headerPaty({
    required bool modoOscuro,
    required bool pantallaPequena,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pantallaPequena ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            Colors.pink.withValues(alpha: modoOscuro ? 0.22 : 0.10),
            Colors.deepPurple.withValues(alpha: modoOscuro ? 0.14 : 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.pink.withValues(alpha: modoOscuro ? 0.30 : 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: pantallaPequena ? 76 : 88,
            height: pantallaPequena ? 76 : 88,
            decoration: BoxDecoration(
              color: Colors.pink.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.extension_rounded,
              color: Colors.pink,
              size: 48,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            T.txt('gameTitle'),
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: pantallaPequena ? 30 : 36,
              fontWeight: FontWeight.w800,
              color: modoOscuro ? Colors.white : const Color(0xFF4A2C82),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt('gameSubtitle'),
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: pantallaPequena ? 17 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF476F),
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            T.txt('gameDescription'),
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: pantallaPequena ? 15 : 16.5,
              fontWeight: FontWeight.w500,
              color: modoOscuro ? Colors.white70 : Colors.black54,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            T.txt('figureInstructions'),
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: pantallaPequena ? 14.5 : 15.5,
              fontWeight: FontWeight.w600,
              color: modoOscuro ? Colors.white60 : Colors.black45,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  Widget estadoJuego(bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            Colors.orange.withValues(alpha: modoOscuro ? 0.20 : 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.orange.withValues(alpha: modoOscuro ? 0.30 : 0.18),
        ),
      ),
      child: Column(
        children: [
          Text(
            mensajeKey == 'correctFigure' && figuraActiva.isNotEmpty
                ? '${T.txt('correctFigure')} ${T.txt(figuraActiva)}'
                : T.txt(mensajeKey),
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '${T.txt('hits')}: $aciertos',
            style: GoogleFonts.baloo2(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            T.txt(recompensaKey),
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: modoOscuro ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget figuraCard({
    required String keyName,
    required IconData icon,
    required Color color,
    required bool modoOscuro,
  }) {
    final bool activo = figuraActiva == keyName;

    return GestureDetector(
      onTap: () => tocarFigura(keyName),
      child: AnimatedScale(
        scale: activo ? 1.07 : 1.0,
        duration: const Duration(milliseconds: 230),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                color.withValues(alpha: activo ? 0.27 : 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: color.withValues(alpha: activo ? 0.75 : 0.26),
              width: activo ? 4 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: activo ? 0.28 : 0.10),
                blurRadius: activo ? 18 : 11,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 64,
              ),
              const SizedBox(height: 10),
              Text(
                T.txt(keyName),
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}