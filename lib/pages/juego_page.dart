import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_config.dart';
import 'app_texts.dart';

import 'alumnos/juego_paty.dart';
import 'alumnos/juego_andres.dart';
import 'alumnos/juego_david.dart';

class JuegoPage extends StatelessWidget {
  const JuegoPage({super.key});

  List<JuegoItem> _juegos() {
    return [
      JuegoItem(
        titulo: T.txt('gamePaty'),
        descripcion: T.txt('gamePatyDesc'),
        icono: Icons.extension_rounded,
        color: const Color(0xFFFF006E),
        pagina: const JuegoPatyPage(),
      ),
      JuegoItem(
        titulo: T.txt('gameAndres'),
        descripcion: T.txt('gameAndresDesc'),
        icono: Icons.quiz_rounded,
        color: const Color(0xFF4361EE),
        pagina: const JuegoAndresPage(),
      ),
      JuegoItem(
        titulo: T.txt('gameDavid'),
        descripcion: T.txt('gameDavidDesc'),
        icono: Icons.pets_rounded,
        color: const Color(0xFFFF8C42),
        pagina: const JuegoDavidPage(),
      ),
    ];
  }

  Widget _encabezado(bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.22 : 0.10),
            const Color(0xFFFF6B6B).withValues(alpha: modoOscuro ? 0.18 : 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.32 : 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.18 : 0.10),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7B2CBF).withValues(alpha: 0.28),
                  const Color(0xFFFF6B6B).withValues(alpha: 0.16),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🎮',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            T.txt('studentGames'),
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF7B2CBF),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt('gamesSubtitle'),
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF6B6B),
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppConfig.temaApp,
          builder: (context, temaActual, _) {
            final bool modoOscuro = temaActual == ThemeMode.dark;
            final listaJuegos = _juegos();

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('games'),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _encabezado(modoOscuro),
                      const SizedBox(height: 22),
                      ...listaJuegos.map(
                        (juego) => JuegoCard(
                          juego: juego,
                          modoOscuro: modoOscuro,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class JuegoCard extends StatelessWidget {
  final JuegoItem juego;
  final bool modoOscuro;

  const JuegoCard({
    super.key,
    required this.juego,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => juego.pagina,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                  juego.color.withValues(alpha: modoOscuro ? 0.18 : 0.09),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: juego.color.withValues(alpha: modoOscuro ? 0.30 : 0.18),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: juego.color.withValues(alpha: modoOscuro ? 0.13 : 0.08),
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
                    gradient: LinearGradient(
                      colors: [
                        juego.color.withValues(alpha: 0.24),
                        juego.color.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    juego.icono,
                    size: 32,
                    color: juego.color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        juego.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: modoOscuro
                              ? Colors.white
                              : const Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        juego.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.baloo2(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: modoOscuro ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: juego.color,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JuegoItem {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;
  final Widget pagina;

  const JuegoItem({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.pagina,
  });
}