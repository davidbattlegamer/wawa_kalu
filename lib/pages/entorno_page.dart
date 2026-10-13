import 'package:flutter/material.dart';

import '../app/widgets/family_content_ui.dart';
import 'app_config.dart';
import 'app_texts.dart';

class EntornoPage extends StatefulWidget {
  const EntornoPage({super.key});

  @override
  State<EntornoPage> createState() => _EntornoPageState();
}

class _EntornoPageState extends State<EntornoPage> {
  int? _openIndex;

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


  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: AppConfig.idioma,
    builder: (context, language, _) {
      final topics = _items();
      return Scaffold(
        backgroundColor: FamilyUi.dark(context)
            ? FamilyUi.canvasDark : FamilyUi.canvasLight,
        appBar: FamilyUi.appBar(context, T.txt('environmentTitle')),
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 38),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FamilyHero(
                  eyebrow: T.txt('protectiveEnvironments'),
                  title: T.txt('environmentTitle'),
                  subtitle: T.txt('environmentHeaderSubtitle'),
                  icon: Icons.shield_rounded,
                  color: const Color(0xFF188C84),
                  accent: const Color(0xFF67BCA0),
                ),
                const SizedBox(height: 26),
                FamilySectionHeading(
                  title: T.txt('environmentActionsTitle'),
                  subtitle: T.txt('touchEnvironmentActions'),
                  icon: Icons.verified_user_rounded,
                ),
                for (var i = 0; i < topics.length; i++)
                  FamilyTopicCard(
                    title: T.txt(topics[i].tituloKey),
                    subtitle: T.txt(topics[i].subtituloKey),
                    icon: topics[i].icono,
                    color: topics[i].color,
                    expanded: _openIndex == i,
                    onTap: () => setState(
                      () => _openIndex = _openIndex == i ? null : i),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FamilyInfoPanel(
                          title: T.txt('environmentWhatToKnow'),
                          text: T.txt(topics[i].descripcionKey),
                          icon: Icons.info_outline_rounded,
                          color: topics[i].color,
                        ),
                        const SizedBox(height: 17),
                        FamilySectionHeading(
                          title: T.txt('environmentActionsTitle'),
                          icon: Icons.checklist_rounded,
                        ),
                        FamilyBulletList(
                          items: topics[i].accionesKeys
                              .map((key) => T.txt(key)).toList(),
                          color: topics[i].color,
                          numbered: true,
                        ),
                        FamilyNotice(
                          text: T.txt(topics[i].alertaKey),
                          color: const Color(0xFFE58B56),
                          icon: Icons.health_and_safety_outlined,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 9),
                FamilyNotice(
                  text: T.txt('environmentFinalNote'),
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFF269B90),
                ),
              ],
            ),
          )),
        )),
      );
    },
  );
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
