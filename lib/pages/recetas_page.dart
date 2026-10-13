import 'package:flutter/material.dart';

import '../app/widgets/family_content_ui.dart';
import 'app_config.dart';
import 'app_texts.dart';

class RecetasPage extends StatefulWidget {
  const RecetasPage({super.key});

  @override
  State<RecetasPage> createState() => _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  int? _openIndex;

  List<RecetaItem> _recetas() {
    return [
      RecetaItem(
        tituloKey: 'recipe1Title',
        emoji: '🍲',
        edadKey: 'recipe1Age',
        momentoKey: 'recipe1Moment',
        color: const Color(0xFFFF8C42),
        descripcionKey: 'recipe1Desc',
        ingredientesKeys: const [
          'recipe1Ing1',
          'recipe1Ing2',
          'recipe1Ing3',
          'recipe1Ing4',
        ],
        preparacionKeys: const [
          'recipe1Step1',
          'recipe1Step2',
          'recipe1Step3',
          'recipe1Step4',
        ],
        recomendacionKey: 'recipe1Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe2Title',
        emoji: '🥣',
        edadKey: 'recipe2Age',
        momentoKey: 'recipe2Moment',
        color: const Color(0xFF7B2CBF),
        descripcionKey: 'recipe2Desc',
        ingredientesKeys: const [
          'recipe2Ing1',
          'recipe2Ing2',
          'recipe2Ing3',
          'recipe2Ing4',
        ],
        preparacionKeys: const [
          'recipe2Step1',
          'recipe2Step2',
          'recipe2Step3',
          'recipe2Step4',
        ],
        recomendacionKey: 'recipe2Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe3Title',
        emoji: '🍳',
        edadKey: 'recipe3Age',
        momentoKey: 'recipe3Moment',
        color: const Color(0xFF00A896),
        descripcionKey: 'recipe3Desc',
        ingredientesKeys: const [
          'recipe3Ing1',
          'recipe3Ing2',
          'recipe3Ing3',
          'recipe3Ing4',
        ],
        preparacionKeys: const [
          'recipe3Step1',
          'recipe3Step2',
          'recipe3Step3',
          'recipe3Step4',
        ],
        recomendacionKey: 'recipe3Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe4Title',
        emoji: '🍚',
        edadKey: 'recipe4Age',
        momentoKey: 'recipe4Moment',
        color: const Color(0xFF4361EE),
        descripcionKey: 'recipe4Desc',
        ingredientesKeys: const [
          'recipe4Ing1',
          'recipe4Ing2',
          'recipe4Ing3',
          'recipe4Ing4',
        ],
        preparacionKeys: const [
          'recipe4Step1',
          'recipe4Step2',
          'recipe4Step3',
          'recipe4Step4',
        ],
        recomendacionKey: 'recipe4Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe5Title',
        emoji: '🍓',
        edadKey: 'recipe5Age',
        momentoKey: 'recipe5Moment',
        color: const Color(0xFFFF006E),
        descripcionKey: 'recipe5Desc',
        ingredientesKeys: const ['recipe5Ing1', 'recipe5Ing2', 'recipe5Ing3'],
        preparacionKeys: const [
          'recipe5Step1',
          'recipe5Step2',
          'recipe5Step3',
          'recipe5Step4',
        ],
        recomendacionKey: 'recipe5Rec',
      ),
    ];
  }


  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: AppConfig.idioma,
    builder: (context, language, _) {
      final recipes = _recetas();
      return Scaffold(
        backgroundColor: FamilyUi.dark(context)
            ? FamilyUi.canvasDark : FamilyUi.canvasLight,
        appBar: FamilyUi.appBar(context, T.txt('recipesAppBar')),
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 38),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FamilyHero(
                  eyebrow: T.txt('recipesForChildren'),
                  title: T.txt('recipesHeaderTitle'),
                  subtitle: T.txt('recipesHeaderSubtitle'),
                  icon: Icons.ramen_dining_rounded,
                  color: const Color(0xFFDB784B),
                  accent: const Color(0xFFE9B75B),
                ),
                const SizedBox(height: 26),
                FamilySectionHeading(
                  title: T.txt('recipesIdeasTitle'),
                  subtitle: T.txt('recipesHeaderNote'),
                  icon: Icons.restaurant_menu_rounded,
                ),
                for (var i = 0; i < recipes.length; i++)
                  FamilyTopicCard(
                    title: T.txt(recipes[i].tituloKey),
                    subtitle: T.txt(recipes[i].descripcionKey),
                    icon: Icons.soup_kitchen_rounded,
                    color: recipes[i].color,
                    badge: '${recipes[i].emoji}   ${T.txt(recipes[i].edadKey)}',
                    expanded: _openIndex == i,
                    onTap: () => setState(
                      () => _openIndex = _openIndex == i ? null : i),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FamilyInfoPanel(
                          title: T.txt(recipes[i].momentoKey),
                          text: T.txt(recipes[i].descripcionKey),
                          icon: Icons.schedule_rounded,
                          color: recipes[i].color,
                        ),
                        const SizedBox(height: 19),
                        FamilySectionHeading(
                          title: T.txt('ingredients'),
                          icon: Icons.shopping_basket_rounded,
                        ),
                        FamilyBulletList(
                          items: recipes[i].ingredientesKeys
                              .map((key) => T.txt(key)).toList(),
                          color: recipes[i].color,
                        ),
                        const SizedBox(height: 8),
                        FamilySectionHeading(
                          title: T.txt('preparation'),
                          icon: Icons.format_list_numbered_rounded,
                        ),
                        FamilyBulletList(
                          items: recipes[i].preparacionKeys
                              .map((key) => T.txt(key)).toList(),
                          color: recipes[i].color,
                          numbered: true,
                        ),
                        FamilyNotice(
                          text: T.txt(recipes[i].recomendacionKey),
                          color: recipes[i].color,
                          icon: Icons.tips_and_updates_rounded,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 9),
                FamilyNotice(
                  text: T.txt('recipeFinalNote'),
                  color: const Color(0xFFE38B52),
                  icon: Icons.health_and_safety_rounded,
                ),
              ],
            ),
          )),
        )),
      );
    },
  );
}

class RecetaItem {
  final String tituloKey;
  final String emoji;
  final String edadKey;
  final String momentoKey;
  final Color color;
  final String descripcionKey;
  final List<String> ingredientesKeys;
  final List<String> preparacionKeys;
  final String recomendacionKey;

  const RecetaItem({
    required this.tituloKey,
    required this.emoji,
    required this.edadKey,
    required this.momentoKey,
    required this.color,
    required this.descripcionKey,
    required this.ingredientesKeys,
    required this.preparacionKeys,
    required this.recomendacionKey,
  });
}
