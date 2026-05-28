import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_texts.dart';

import 'alumnos/juego_paty.dart';
import 'alumnos/juego_andres.dart';
import 'alumnos/juego_david.dart';

class JuegoPage extends StatelessWidget {
  const JuegoPage({super.key});

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
                  T.txt('games'),
                  style: TextStyle(
                    fontFamily: 'Fredoka',
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
                    final bool pantallaPequena =
                        constraints.maxHeight < 720 ||
                            constraints.maxWidth < 380;

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(pantallaPequena ? 16 : 20),
                      child: Column(
                        children: [
                          _headerJuegos(
                            modoOscuro: modoOscuro,
                            pantallaPequena: pantallaPequena,
                          ),
                          const SizedBox(height: 18),
                          _beneficiosCard(modoOscuro),
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              T.txt('availableGames'),
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                color: modoOscuro
                                    ? Colors.white
                                    : const Color(0xFF4A2C82),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _juegoCard(
                            context: context,
                            modoOscuro: modoOscuro,
                            color: Colors.pink,
                            icon: Icons.extension_rounded,
                            title: T.txt('patyGameCardTitle'),
                            subtitle: T.txt('patyGameCardSubtitle'),
                            description: T.txt('patyGameCardDescription'),
                            page: const JuegoPatyPage(),
                          ),
                          const SizedBox(height: 14),
                          _juegoCard(
                            context: context,
                            modoOscuro: modoOscuro,
                            color: Colors.blueAccent,
                            icon: Icons.quiz_rounded,
                            title: T.txt('andresGameCardTitle'),
                            subtitle: T.txt('andresGameCardSubtitle'),
                            description: T.txt('andresGameCardDescription'),
                            page: const JuegoAndresPage(),
                          ),
                          const SizedBox(height: 14),
                          _juegoCard(
                            context: context,
                            modoOscuro: modoOscuro,
                            color: Colors.orange,
                            icon: Icons.pets_rounded,
                            title: T.txt('davidGameCardTitle'),
                            subtitle: T.txt('davidGameCardSubtitle'),
                            description: T.txt('davidGameCardDescription'),
                            page: const JuegoDavidPage(),
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

  Widget _headerJuegos({
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
            Colors.deepPurple.withValues(alpha: modoOscuro ? 0.22 : 0.12),
            Colors.pinkAccent.withValues(alpha: modoOscuro ? 0.14 : 0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.deepPurple.withValues(
            alpha: modoOscuro ? 0.30 : 0.16,
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: pantallaPequena ? 78 : 92,
            height: pantallaPequena ? 78 : 92,
            decoration: BoxDecoration(
              color: Colors.pink.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '🎮',
                style: TextStyle(fontSize: pantallaPequena ? 44 : 54),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            T.txt('gamesPageTitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: pantallaPequena ? 30 : 36,
              fontWeight: FontWeight.w800,
              color: modoOscuro ? Colors.white : const Color(0xFF4A2C82),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt('gamesPageSubtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: pantallaPequena ? 17 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF476F),
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            T.txt('gamesPageDescription'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: pantallaPequena ? 14.5 : 16,
              fontWeight: FontWeight.w500,
              color: modoOscuro ? Colors.white70 : Colors.black54,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _beneficiosCard(bool modoOscuro) {
    final beneficios = [
      T.txt('gameBenefit1'),
      T.txt('gameBenefit2'),
      T.txt('gameBenefit3'),
      T.txt('gameBenefit4'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            Colors.pink.withValues(alpha: modoOscuro ? 0.18 : 0.08),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.pink.withValues(alpha: modoOscuro ? 0.28 : 0.15),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.pink,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  T.txt('gameBenefits'),
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...beneficios.map(
            (beneficio) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      beneficio,
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                        color: modoOscuro ? Colors.white70 : Colors.black87,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _juegoCard({
    required BuildContext context,
    required bool modoOscuro,
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Widget page,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            color.withValues(alpha: modoOscuro ? 0.20 : 0.09),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.32 : 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => page,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.26),
                        color.withValues(alpha: 0.09),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: modoOscuro
                              ? Colors.white
                              : const Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: color,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: modoOscuro ? Colors.white70 : Colors.black54,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(
                              alpha: modoOscuro ? 0.22 : 0.12,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            T.txt('playNow'),
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: color,
                  size: 31,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}