import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_config.dart';
import 'app_texts.dart';

class EntornoPage extends StatefulWidget {
  const EntornoPage({super.key});

  @override
  State<EntornoPage> createState() => _EntornoPageState();
}

class _EntornoPageState extends State<EntornoPage> {
  int? indiceAbierto;

  final Color colorPrincipal = const Color(0xFF2A9D8F);
  final Color colorSecundario = const Color(0xFFFF6B6B);

  List<EntornoItem> _items() {
    return [
      EntornoItem(
        tituloKey: 'safeSpacesTitle',
        subtituloKey: 'safeSpacesSubtitle',
        descripcionKey: 'safeSpacesDesc',
        alertaKey: 'safeSpacesAlert',
        icono: Icons.home_rounded,
        color: const Color(0xFF2A9D8F),
        accionesKeys: const [
          'safeSpacesA1',
          'safeSpacesA2',
          'safeSpacesA3',
          'safeSpacesA4',
        ],
      ),
      EntornoItem(
        tituloKey: 'activeSupervisionTitle',
        subtituloKey: 'activeSupervisionSubtitle',
        descripcionKey: 'activeSupervisionDesc',
        alertaKey: 'activeSupervisionAlert',
        icono: Icons.visibility_rounded,
        color: const Color(0xFF4361EE),
        accionesKeys: const [
          'activeSupervisionA1',
          'activeSupervisionA2',
          'activeSupervisionA3',
          'activeSupervisionA4',
        ],
      ),
      EntornoItem(
        tituloKey: 'protectiveRoutinesTitle',
        subtituloKey: 'protectiveRoutinesSubtitle',
        descripcionKey: 'protectiveRoutinesDesc',
        alertaKey: 'protectiveRoutinesAlert',
        icono: Icons.schedule_rounded,
        color: const Color(0xFFFF8C42),
        accionesKeys: const [
          'protectiveRoutinesA1',
          'protectiveRoutinesA2',
          'protectiveRoutinesA3',
          'protectiveRoutinesA4',
        ],
      ),
      EntornoItem(
        tituloKey: 'affectionTitle',
        subtituloKey: 'affectionSubtitle',
        descripcionKey: 'affectionDesc',
        alertaKey: 'affectionAlert',
        icono: Icons.favorite_rounded,
        color: const Color(0xFFFF006E),
        accionesKeys: const [
          'affectionA1',
          'affectionA2',
          'affectionA3',
          'affectionA4',
        ],
      ),
      EntornoItem(
        tituloKey: 'healthAlertTitle',
        subtituloKey: 'healthAlertSubtitle',
        descripcionKey: 'healthAlertDesc',
        alertaKey: 'healthAlertAlert',
        icono: Icons.health_and_safety_rounded,
        color: const Color(0xFFE63946),
        accionesKeys: const [
          'healthAlertA1',
          'healthAlertA2',
          'healthAlertA3',
          'healthAlertA4',
        ],
      ),
    ];
  }

  void toggleItem(int index) {
    setState(() {
      indiceAbierto = indiceAbierto == index ? null : index;
    });
  }

  Widget _encabezadoEntorno(bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            colorPrincipal.withValues(alpha: modoOscuro ? 0.22 : 0.10),
            colorSecundario.withValues(alpha: modoOscuro ? 0.18 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colorPrincipal.withValues(alpha: modoOscuro ? 0.32 : 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorPrincipal.withValues(alpha: modoOscuro ? 0.18 : 0.10),
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
                  colorPrincipal.withValues(alpha: 0.25),
                  colorSecundario.withValues(alpha: 0.14),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🛡️',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            T.txt('environmentTitle'),
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : colorPrincipal,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt('environmentHeaderSubtitle'),
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: colorSecundario,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: colorPrincipal.withValues(alpha: modoOscuro ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              T.txt('touchEnvironmentActions'),
              textAlign: TextAlign.center,
              style: GoogleFonts.baloo2(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: modoOscuro ? Colors.white : colorPrincipal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardEntorno(EntornoItem item, int index, bool modoOscuro) {
    final bool abierto = indiceAbierto == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            item.color.withValues(
              alpha: abierto
                  ? modoOscuro
                      ? 0.24
                      : 0.15
                  : modoOscuro
                      ? 0.14
                      : 0.07,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: item.color.withValues(alpha: abierto ? 0.42 : 0.20),
          width: abierto ? 2 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: item.color.withValues(alpha: abierto ? 0.16 : 0.08),
            blurRadius: abierto ? 15 : 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => toggleItem(index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            item.color.withValues(alpha: 0.25),
                            item.color.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(item.icono, color: item.color, size: 31),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            T.txt(item.tituloKey),
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
                            T.txt(item.subtituloKey),
                            style: GoogleFonts.baloo2(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: modoOscuro ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: abierto ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 260),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 32,
                        color: item.color,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: item.color.withValues(
                              alpha: modoOscuro ? 0.18 : 0.09,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            T.txt(item.descripcionKey),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.baloo2(
                              fontSize: 15.8,
                              fontWeight: FontWeight.w600,
                              color: modoOscuro ? Colors.white70 : Colors.black87,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...item.accionesKeys.map(
                          (accionKey) => InfoBulletEntorno(
                            texto: T.txt(accionKey),
                            color: item.color,
                            modoOscuro: modoOscuro,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                modoOscuro
                                    ? const Color(0xFF15131A)
                                    : Colors.white,
                                Colors.redAccent.withValues(
                                  alpha: modoOscuro ? 0.16 : 0.08,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.redAccent.withValues(
                                alpha: modoOscuro ? 0.28 : 0.14,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.redAccent,
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  T.txt(item.alertaKey),
                                  style: GoogleFonts.baloo2(
                                    fontSize: 15.2,
                                    fontWeight: FontWeight.w600,
                                    color: modoOscuro
                                        ? Colors.white70
                                        : Colors.black87,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: abierto
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 260),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _notaFinal(bool modoOscuro) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            colorPrincipal.withValues(alpha: modoOscuro ? 0.16 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorPrincipal.withValues(alpha: modoOscuro ? 0.28 : 0.16),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.volunteer_activism_rounded,
              color: colorPrincipal, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              T.txt('environmentFinalNote'),
              style: GoogleFonts.baloo2(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: modoOscuro ? Colors.white70 : Colors.black87,
              ),
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
            final listaItems = _items();

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('environmentTitle'),
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
                      _encabezadoEntorno(modoOscuro),
                      const SizedBox(height: 22),
                      ...List.generate(
                        listaItems.length,
                        (index) =>
                            _cardEntorno(listaItems[index], index, modoOscuro),
                      ),
                      _notaFinal(modoOscuro),
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

class InfoBulletEntorno extends StatelessWidget {
  final String texto;
  final Color color;
  final bool modoOscuro;

  const InfoBulletEntorno({
    super.key,
    required this.texto,
    required this.color,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: GoogleFonts.baloo2(
                fontSize: 15.6,
                fontWeight: FontWeight.w500,
                color: modoOscuro ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EntornoItem {
  final String tituloKey;
  final String subtituloKey;
  final String descripcionKey;
  final String alertaKey;
  final IconData icono;
  final Color color;
  final List<String> accionesKeys;

  const EntornoItem({
    required this.tituloKey,
    required this.subtituloKey,
    required this.descripcionKey,
    required this.alertaKey,
    required this.icono,
    required this.color,
    required this.accionesKeys,
  });
}