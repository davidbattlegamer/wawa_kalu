import 'package:flutter/material.dart';

import '../../../app/widgets/family_content_ui.dart';
import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';
import '../../../pages/entorno_page.dart';
import '../../../pages/lenguaje_page.dart';
import 'guia_familias_page.dart';

/// Hub canónico de aprendizaje.
///
/// Aquí cada recurso tiene un propósito distinto:
/// - Guía para familias: actividades prácticas por edad.
/// - Lenguaje: orientación específica de comunicación.
/// - Entornos protectores: orientación de seguridad y cuidado.
class LearningHubPage extends StatelessWidget {
  const LearningHubPage({
    super.key,
    this.initialAgeGroup = -1,
  });

  final int initialAgeGroup;

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, language, _) {
        final dark = FamilyUi.dark(context);

        return Scaffold(
          backgroundColor: dark ? FamilyUi.canvasDark : FamilyUi.canvasLight,
          appBar: AppBar(
            automaticallyImplyLeading: Navigator.of(context).canPop(),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: dark ? FamilyUi.surfaceDark : Colors.white,
            foregroundColor: FamilyUi.ink(context),
            title: Text(
              T.txt('learning'),
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 125),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FamilyHero(
                        eyebrow: T.txt('learningHeroEyebrow'),
                        title: T.txt('learningHubTitle'),
                        subtitle: T.txt('learningHubSubtitle'),
                        icon: Icons.auto_stories_rounded,
                        color: const Color(0xFF7544BC),
                        accent: const Color(0xFFE48A79),
                      ),
                      const SizedBox(height: 28),
                      FamilySectionHeading(
                        title: T.txt('learningChooseTitle'),
                        subtitle: T.txt('learningChooseSubtitle'),
                        icon: Icons.explore_rounded,
                      ),
                      FamilyTopicCard(
                        title: T.txt('familyGuide'),
                        subtitle: T.txt('learningGuideSubtitle'),
                        icon: Icons.auto_awesome_rounded,
                        color: const Color(0xFF8B5CD6),
                        badge: T.txt('learningActivitiesBadge'),
                        featured: true,
                        onTap: () => _open(
                          context,
                          GuiaFamiliasPage(initialAgeGroup: initialAgeGroup),
                        ),
                      ),
                      FamilyTopicCard(
                        title: T.txt('languageMenu'),
                        subtitle: T.txt('learningLanguageSubtitle'),
                        icon: Icons.record_voice_over_rounded,
                        color: const Color(0xFF4F7CFF),
                        badge: T.txt('learningGuidanceBadge'),
                        onTap: () => _open(
                          context,
                          const LenguajePage(),
                        ),
                      ),
                      FamilyTopicCard(
                        title: T.txt('protectiveEnvironments'),
                        subtitle: T.txt('learningEnvironmentSubtitle'),
                        icon: Icons.shield_rounded,
                        color: const Color(0xFF16A68F),
                        badge: T.txt('learningGuidanceBadge'),
                        onTap: () => _open(
                          context,
                          const EntornoPage(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FamilyNotice(
                        text: T.txt('learningFamilyNotice'),
                        color: const Color(0xFF9A75D1),
                        icon: Icons.favorite_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
