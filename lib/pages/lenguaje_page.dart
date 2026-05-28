import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_texts.dart';

class LenguajePage extends StatefulWidget {
  const LenguajePage({super.key});

  @override
  State<LenguajePage> createState() => _LenguajePageState();
}

class _LenguajePageState extends State<LenguajePage> {
  String tituloSeleccionadoKey = 'selectActivity';
  String recomendacionKey = 'languageDefaultRec';
  String actividadCasaKey = 'languageDefaultHome';
  String frasePadresKey = 'languageDefaultParent';

  IconData iconoSeleccionado = Icons.touch_app_rounded;
  Color colorSeleccionado = Colors.blueGrey;
  int actividadesRealizadas = 0;

  List<ActividadLenguaje> _actividades() {
    return [
      ActividadLenguaje(
        tituloKey: 'nameObjectsTitle',
        descripcionKey: 'nameObjectsDesc',
        recomendacionKey: 'nameObjectsRec',
        actividadCasaKey: 'nameObjectsHome',
        frasePadresKey: 'nameObjectsParent',
        icono: Icons.label_rounded,
        color: const Color(0xFFFF006E),
      ),
      ActividadLenguaje(
        tituloKey: 'readImagesTitle',
        descripcionKey: 'readImagesDesc',
        recomendacionKey: 'readImagesRec',
        actividadCasaKey: 'readImagesHome',
        frasePadresKey: 'readImagesParent',
        icono: Icons.menu_book_rounded,
        color: const Color(0xFF7B2CBF),
      ),
      ActividadLenguaje(
        tituloKey: 'singMoveTitle',
        descripcionKey: 'singMoveDesc',
        recomendacionKey: 'singMoveRec',
        actividadCasaKey: 'singMoveHome',
        frasePadresKey: 'singMoveParent',
        icono: Icons.music_note_rounded,
        color: const Color(0xFFFF8C42),
      ),
      ActividadLenguaje(
        tituloKey: 'talkTitle',
        descripcionKey: 'talkDesc',
        recomendacionKey: 'talkRec',
        actividadCasaKey: 'talkHome',
        frasePadresKey: 'talkParent',
        icono: Icons.chat_bubble_rounded,
        color: const Color(0xFF00B4D8),
      ),
      ActividadLenguaje(
        tituloKey: 'imitateSoundsTitle',
        descripcionKey: 'imitateSoundsDesc',
        recomendacionKey: 'imitateSoundsRec',
        actividadCasaKey: 'imitateSoundsHome',
        frasePadresKey: 'imitateSoundsParent',
        icono: Icons.record_voice_over_rounded,
        color: const Color(0xFF00A896),
      ),
    ];
  }

  void seleccionarActividad(ActividadLenguaje actividad) {
    setState(() {
      tituloSeleccionadoKey = actividad.tituloKey;
      recomendacionKey = actividad.recomendacionKey;
      actividadCasaKey = actividad.actividadCasaKey;
      frasePadresKey = actividad.frasePadresKey;
      iconoSeleccionado = actividad.icono;
      colorSeleccionado = actividad.color;
      actividadesRealizadas++;
    });
  }

  bool get sinSeleccion => tituloSeleccionadoKey == 'selectActivity';

  Widget _encabezadoLenguaje(bool modoOscuro) {
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
          color: const Color(0xFF7B2CBF).withValues(
            alpha: modoOscuro ? 0.32 : 0.18,
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2CBF).withValues(
              alpha: modoOscuro ? 0.18 : 0.10,
            ),
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
                  const Color(0xFF7B2CBF).withValues(alpha: 0.25),
                  const Color(0xFFFF6B6B).withValues(alpha: 0.14),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🗣️',
                style: TextStyle(fontSize: 46),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            T.txt('languageTitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF7B2CBF),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt('languageHeaderSubtitle'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6B6B),
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF7B2CBF).withValues(
                alpha: modoOscuro ? 0.18 : 0.10,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              T.txt('touchActivityRecommendation'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: modoOscuro ? Colors.white : const Color(0xFF7B2CBF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cajaInteractiva(bool modoOscuro) {
    final Color colorBase = sinSeleccion ? Colors.blueGrey : colorSeleccionado;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            colorBase.withValues(
              alpha: sinSeleccion
                  ? modoOscuro
                      ? 0.14
                      : 0.08
                  : modoOscuro
                      ? 0.24
                      : 0.16,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colorBase.withValues(alpha: sinSeleccion ? 0.20 : 0.40),
          width: sinSeleccion ? 1.5 : 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorBase.withValues(alpha: sinSeleccion ? 0.08 : 0.18),
            blurRadius: sinSeleccion ? 12 : 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorBase.withValues(alpha: 0.25),
                  colorBase.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconoSeleccionado,
              size: 44,
              color: colorBase,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            T.txt(tituloSeleccionadoKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: sinSeleccion
                  ? modoOscuro
                      ? Colors.white
                      : const Color(0xFF2D2D2D)
                  : colorBase,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            T.txt(recomendacionKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              color: modoOscuro ? Colors.white70 : Colors.black87,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          _bloqueInfo(
            titulo: T.txt('homeActivity'),
            texto: T.txt(actividadCasaKey),
            icono: Icons.home_rounded,
            color: colorBase,
            modoOscuro: modoOscuro,
          ),
          const SizedBox(height: 12),
          _frasePadres(colorBase, modoOscuro),
        ],
      ),
    );
  }

  Widget _bloqueInfo({
    required String titulo,
    required String texto,
    required IconData icono,
    required Color color,
    required bool modoOscuro,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: modoOscuro ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.22 : 0.12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 26),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: modoOscuro ? Colors.white : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: modoOscuro ? Colors.white70 : Colors.black87,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _frasePadres(Color color, bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: modoOscuro
            ? const Color(0xFF15131A).withValues(alpha: 0.82)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.22 : 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite_rounded, color: color, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              T.txt(frasePadresKey),
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: modoOscuro ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progresoPadres(bool modoOscuro) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            Colors.blueGrey.withValues(alpha: modoOscuro ? 0.12 : 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blueGrey.withValues(alpha: modoOscuro ? 0.22 : 0.12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insights_rounded,
            color: Colors.blueGrey.shade400,
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              actividadesRealizadas == 0
                  ? T.txt('noActivityReviewed')
                  : '${T.txt('activitiesReviewed')}: $actividadesRealizadas',
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: modoOscuro ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actividadCard(ActividadLenguaje actividad, bool modoOscuro) {
    final bool seleccionada = tituloSeleccionadoKey == actividad.tituloKey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => seleccionarActividad(actividad),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                  actividad.color.withValues(
                    alpha: seleccionada
                        ? modoOscuro
                            ? 0.28
                            : 0.18
                        : modoOscuro
                            ? 0.14
                            : 0.08,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: actividad.color.withValues(
                  alpha: seleccionada ? 0.48 : 0.20,
                ),
                width: seleccionada ? 2.3 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: actividad.color.withValues(
                    alpha: seleccionada ? 0.17 : 0.07,
                  ),
                  blurRadius: seleccionada ? 16 : 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        actividad.color.withValues(alpha: 0.25),
                        actividad.color.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    actividad.icono,
                    color: actividad.color,
                    size: 31,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        T.txt(actividad.tituloKey),
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: modoOscuro
                              ? Colors.white
                              : const Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        T.txt(actividad.descripcionKey),
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: modoOscuro ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  seleccionada
                      ? Icons.check_circle_rounded
                      : Icons.touch_app_rounded,
                  color: actividad.color,
                  size: 29,
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
            Colors.redAccent.withValues(alpha: modoOscuro ? 0.16 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: modoOscuro ? 0.28 : 0.16),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Colors.redAccent,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              T.txt('languageFinalNote'),
              style: TextStyle(
                fontFamily: 'Baloo2',
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
            final bool modoOscuro =
                Theme.of(context).brightness == Brightness.dark;
            final lista = _actividades();

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('languageMenu'),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _encabezadoLenguaje(modoOscuro),
                      const SizedBox(height: 22),
                      _cajaInteractiva(modoOscuro),
                      _progresoPadres(modoOscuro),
                      ...lista.map((a) => _actividadCard(a, modoOscuro)),
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

class ActividadLenguaje {
  final String tituloKey;
  final String descripcionKey;
  final String recomendacionKey;
  final String actividadCasaKey;
  final String frasePadresKey;
  final IconData icono;
  final Color color;

  const ActividadLenguaje({
    required this.tituloKey,
    required this.descripcionKey,
    required this.recomendacionKey,
    required this.actividadCasaKey,
    required this.frasePadresKey,
    required this.icono,
    required this.color,
  });
}