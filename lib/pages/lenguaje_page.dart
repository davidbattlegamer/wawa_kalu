import 'package:flutter/material.dart';

import '../app/widgets/family_content_ui.dart';
import 'app_config.dart';
import 'app_texts.dart';

class LenguajePage extends StatefulWidget {
  const LenguajePage({super.key});

  @override
  State<LenguajePage> createState() => _LenguajePageState();
}

class _LenguajePageState extends State<LenguajePage> {
  int? _selected;
  final Set<int> _reviewed = <int>{};

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


  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: AppConfig.idioma,
    builder: (context, language, _) {
      final activities = _actividades();
      final progress = _reviewed.length / activities.length;
      return Scaffold(
        backgroundColor: FamilyUi.dark(context)
            ? FamilyUi.canvasDark : FamilyUi.canvasLight,
        appBar: FamilyUi.appBar(context, T.txt('languageMenu')),
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 38),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FamilyHero(
                  eyebrow: T.txt('languageMenu'),
                  title: T.txt('languageTitle'),
                  subtitle: T.txt('languageHeaderSubtitle'),
                  icon: Icons.forum_rounded,
                  color: const Color(0xFF9344B5),
                  accent: const Color(0xFFEF7998),
                ),
                const SizedBox(height: 26),
                FamilySectionHeading(
                  title: T.txt('languageIdeasTitle'),
                  subtitle: T.txt('touchActivityRecommendation'),
                  icon: Icons.lightbulb_rounded,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FamilyUi.dark(context)
                        ? FamilyUi.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFFB26BD0), size: 22),
                        const SizedBox(width: 10),
                        Expanded(child: Text(
                          '${T.txt('activitiesReviewed')}: ${_reviewed.length} / ${activities.length}',
                          style: TextStyle(fontFamily: 'Fredoka', fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: FamilyUi.ink(context)),
                        )),
                      ]),
                      const SizedBox(height: 11),
                      ClipRRect(borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          backgroundColor: const Color(0xFFB26BD0).withValues(alpha: .13),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFB26BD0)),
                        )),
                    ],
                  ),
                ),
                for (var i = 0; i < activities.length; i++)
                  FamilyTopicCard(
                    title: T.txt(activities[i].tituloKey),
                    subtitle: T.txt(activities[i].descripcionKey),
                    icon: activities[i].icono,
                    color: activities[i].color,
                    expanded: _selected == i,
                    onTap: () => setState(() {
                      _selected = _selected == i ? null : i;
                      _reviewed.add(i);
                    }),
                    content: Column(children: [
                      FamilyInfoPanel(
                        title: T.txt('languageRecommendationTitle'),
                        text: T.txt(activities[i].recomendacionKey),
                        icon: Icons.tips_and_updates_rounded,
                        color: activities[i].color,
                      ),
                      const SizedBox(height: 11),
                      FamilyInfoPanel(
                        title: T.txt('homeActivity'),
                        text: T.txt(activities[i].actividadCasaKey),
                        icon: Icons.home_rounded,
                        color: activities[i].color,
                      ),
                      const SizedBox(height: 11),
                      FamilyNotice(
                        text: T.txt(activities[i].frasePadresKey),
                        icon: Icons.favorite_rounded,
                        color: activities[i].color,
                      ),
                    ]),
                  ),
                const SizedBox(height: 8),
                FamilyNotice(
                  text: T.txt('languageFinalNote'),
                  icon: Icons.favorite_border_rounded,
                  color: const Color(0xFFDA5B93),
                ),
              ],
            ),
          )),
        )),
      );
    },
  );
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
