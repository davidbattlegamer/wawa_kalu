import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_texts.dart';

import 'widgets/config_sheet.dart';

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

            final bool modoOscuro =
                Theme.of(context).brightness == Brightness.dark;

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
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color:
                        modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
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
                    'assets/images/home.png',
                    fit: BoxFit.contain,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: T.txt('settingsTitle'),
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () {
                      showConfigSheet(context);
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
                                style: TextStyle(
                                  fontFamily: 'Fredoka',
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
                                style: TextStyle(
                                  fontFamily: 'Baloo2',
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
                      item.color.withValues(
                        alpha: modoOscuro ? 0.18 : 0.10,
                      ),
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
                            style: TextStyle(
                              fontFamily: 'Fredoka',
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
                            style: TextStyle(
                              fontFamily: 'Baloo2',
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
                      Icons.chevron_right_rounded,
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