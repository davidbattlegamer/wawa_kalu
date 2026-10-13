import 'package:flutter/material.dart';

import '../app/widgets/family_content_ui.dart';
import 'app_config.dart';
import 'app_texts.dart';
import 'recetas_page.dart';

class NutricionPage extends StatefulWidget {
  const NutricionPage({super.key});

  @override
  State<NutricionPage> createState() => _NutricionPageState();
}

class _NutricionPageState extends State<NutricionPage> {
  int? _openIndex;

  List<MenuNutricionItem> _items() {
    return [
      MenuNutricionItem(
        tituloKey: 'nutritionFoodsTitle',
        subtituloKey: 'nutritionFoodsSubtitle',
        icono: Icons.restaurant_menu_rounded,
        color: const Color(0xFFFF8C42),
        tipsKeys: const [
          'nutritionFoodsTip1',
          'nutritionFoodsTip2',
          'nutritionFoodsTip3',
          'nutritionFoodsTip4',
          'nutritionFoodsTip5',
        ],
        mostrarBotonRecetas: true,
      ),
      MenuNutricionItem(
        tituloKey: 'nutritionRoutineTitle',
        subtituloKey: 'nutritionRoutineSubtitle',
        icono: Icons.schedule_rounded,
        color: const Color(0xFF4361EE),
        tipsKeys: const [
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
        color: const Color(0xFF00B4D8),
        tipsKeys: const [
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
        color: const Color(0xFF9B5DE5),
        tipsKeys: const [
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
        color: const Color(0xFFE63946),
        tipsKeys: const [
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
        color: const Color(0xFFFF006E),
        tipsKeys: const [
          'nutritionParentsTip1',
          'nutritionParentsTip2',
          'nutritionParentsTip3',
          'nutritionParentsTip4',
          'nutritionParentsTip5',
        ],
      ),
    ];
  }


  void _openRecipes() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RecetasPage()),
    );
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: AppConfig.idioma,
    builder: (context, language, _) {
      final topics = _items();
      return Scaffold(
        backgroundColor: FamilyUi.dark(context)
            ? FamilyUi.canvasDark : FamilyUi.canvasLight,
        appBar: FamilyUi.appBar(context, T.txt('nutritionChildTitle')),
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 38),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FamilyHero(
                  eyebrow: T.txt('nutrition'),
                  title: T.txt('nutritionChildTitle'),
                  subtitle: T.txt('nutritionChildSubtitle'),
                  icon: Icons.restaurant_rounded,
                  color: const Color(0xFF9C55BD),
                  accent: const Color(0xFFE8A06D),
                ),
                const SizedBox(height: 20),
                FamilyPrimaryLink(
                  title: T.txt('viewRecipes'),
                  subtitle: T.txt('recipesShortDesc'),
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFFDB7A45),
                  onTap: _openRecipes,
                ),
                const SizedBox(height: 27),
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
                      () => _openIndex = _openIndex == i ? null : i),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FamilySectionHeading(
                          title: T.txt('nutritionPracticalTips'),
                          icon: Icons.check_circle_outline_rounded,
                        ),
                        FamilyBulletList(
                          items: topics[i].tipsKeys
                              .map((key) => T.txt(key)).toList(),
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
          )),
        )),
      );
    },
  );
}

class MenuNutricionItem {
  final String tituloKey;
  final String subtituloKey;
  final IconData icono;
  final Color color;
  final List<String> tipsKeys;
  final bool mostrarBotonRecetas;

  const MenuNutricionItem({
    required this.tituloKey,
    required this.subtituloKey,
    required this.icono,
    required this.color,
    required this.tipsKeys,
    this.mostrarBotonRecetas = false,
  });
}
