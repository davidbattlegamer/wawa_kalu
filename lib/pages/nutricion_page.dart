import 'package:flutter/material.dart';

import '../app/widgets/family_content_ui.dart';
import 'app_config.dart';
import 'app_texts.dart';
import 'recetas_page.dart';

/// Nutrición es un único módulo con dos vistas:
/// orientación y recetas. Así se evita mostrar Recetas como destino duplicado.
class NutricionPage extends StatelessWidget {
  const NutricionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, language, _) {
        final dark = FamilyUi.dark(context);

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: dark ? FamilyUi.canvasDark : FamilyUi.canvasLight,
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: dark ? FamilyUi.surfaceDark : Colors.white,
              foregroundColor: FamilyUi.ink(context),
              title: Text(
                T.txt('nutritionChildTitle'),
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelColor:
                    dark ? Colors.white : const Color(0xFF8F4A22),
                unselectedLabelColor:
                    dark ? Colors.white60 : const Color(0xFF756C79),
                indicatorColor: const Color(0xFFE78B52),
                labelStyle: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                tabs: [
                  Tab(
                    icon: const Icon(Icons.spa_rounded),
                    text: T.txt('nutritionOrientationTab'),
                  ),
                  Tab(
                    icon: const Icon(Icons.restaurant_menu_rounded),
                    text: T.txt('recipes'),
                  ),
                ],
              ),
            ),
            body: const SafeArea(
              child: TabBarView(
                children: [
                  NutritionGuideContent(),
                  RecipesContent(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NutritionGuideContent extends StatefulWidget {
  const NutritionGuideContent({super.key});

  @override
  State<NutritionGuideContent> createState() => _NutritionGuideContentState();
}

class _NutritionGuideContentState extends State<NutritionGuideContent> {
  int? _openIndex;

  List<MenuNutricionItem> _items() {
    return const [
      MenuNutricionItem(
        tituloKey: 'nutritionFoodsTitle',
        subtituloKey: 'nutritionFoodsSubtitle',
        icono: Icons.restaurant_menu_rounded,
        color: Color(0xFFFF8C42),
        tipsKeys: [
          'nutritionFoodsTip1',
          'nutritionFoodsTip2',
          'nutritionFoodsTip3',
          'nutritionFoodsTip4',
          'nutritionFoodsTip5',
        ],
      ),
      MenuNutricionItem(
        tituloKey: 'nutritionRoutineTitle',
        subtituloKey: 'nutritionRoutineSubtitle',
        icono: Icons.schedule_rounded,
        color: Color(0xFF4361EE),
        tipsKeys: [
          'nutritionRoutineTip1',
          'nutritionRoutineTip2',
          'nutritionRoutineTip3',
          'nutritionRoutineTip4',
          'nutritionRoutineTip5',
        ],
      ),
      MenuNutricionItem(
        tituloKey: 'nutritionHydrationTitle',
        subtituloKey: 'nutritionHydrationSubtitle',
        icono: Icons.water_drop_rounded,
        color: Color(0xFF00B4D8),
        tipsKeys: [
          'nutritionHydrationTip1',
          'nutritionHydrationTip2',
          'nutritionHydrationTip3',
          'nutritionHydrationTip4',
          'nutritionHydrationTip5',
        ],
      ),
      MenuNutricionItem(
        tituloKey: 'nutritionSignalsTitle',
        subtituloKey: 'nutritionSignalsSubtitle',
        icono: Icons.visibility_rounded,
        color: Color(0xFF9B5DE5),
        tipsKeys: [
          'nutritionSignalsTip1',
          'nutritionSignalsTip2',
          'nutritionSignalsTip3',
          'nutritionSignalsTip4',
          'nutritionSignalsTip5',
        ],
      ),
      MenuNutricionItem(
        tituloKey: 'nutritionSafetyTitle',
        subtituloKey: 'nutritionSafetySubtitle',
        icono: Icons.health_and_safety_rounded,
        color: Color(0xFFE63946),
        tipsKeys: [
          'nutritionSafetyTip1',
          'nutritionSafetyTip2',
          'nutritionSafetyTip3',
          'nutritionSafetyTip4',
          'nutritionSafetyTip5',
        ],
      ),
      MenuNutricionItem(
        tituloKey: 'nutritionParentsTitle',
        subtituloKey: 'nutritionParentsSubtitle',
        icono: Icons.family_restroom_rounded,
        color: Color(0xFFFF006E),
        tipsKeys: [
          'nutritionParentsTip1',
          'nutritionParentsTip2',
          'nutritionParentsTip3',
          'nutritionParentsTip4',
          'nutritionParentsTip5',
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final topics = _items();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 38),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FamilyHero(
                eyebrow: T.txt('nutrition'),
                title: T.txt('nutritionChildTitle'),
                subtitle: T.txt('nutritionIntegratedSubtitle'),
                icon: Icons.restaurant_rounded,
                color: const Color(0xFFB66A37),
                accent: const Color(0xFFE5A257),
              ),
              const SizedBox(height: 26),
              FamilySectionHeading(
                title: T.txt('nutritionAdviceTitle'),
                subtitle: T.txt('touchSectionRecommendations'),
                icon: Icons.spa_rounded,
              ),
              for (var i = 0; i < topics.length; i++)
                FamilyTopicCard(
                  title: T.txt(topics[i].tituloKey),
                  subtitle: T.txt(topics[i].subtituloKey),
                  icon: topics[i].icono,
                  color: topics[i].color,
                  expanded: _openIndex == i,
                  onTap: () => setState(
                    () => _openIndex = _openIndex == i ? null : i,
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FamilySectionHeading(
                        title: T.txt('nutritionPracticalTips'),
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      FamilyBulletList(
                        items: topics[i]
                            .tipsKeys
                            .map((key) => T.txt(key))
                            .toList(),
                        color: topics[i].color,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              FamilyNotice(
                text: T.txt('nutritionFinalNote'),
                icon: Icons.health_and_safety_rounded,
                color: const Color(0xFFE38B52),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuNutricionItem {
  const MenuNutricionItem({
    required this.tituloKey,
    required this.subtituloKey,
    required this.icono,
    required this.color,
    required this.tipsKeys,
  });

  final String tituloKey;
  final String subtituloKey;
  final IconData icono;
  final Color color;
  final List<String> tipsKeys;
}
