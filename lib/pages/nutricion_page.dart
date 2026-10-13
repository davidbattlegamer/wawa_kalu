import 'package:flutter/material.dart';

import '../app/widgets/family_content_ui.dart';
import '../features/children/data/child_repository.dart';
import '../features/health/data/ecuador_recipe_catalog.dart';
import 'app_config.dart';
import 'app_texts.dart';

class NutricionPage extends StatefulWidget {
  const NutricionPage({super.key});

  @override
  State<NutricionPage> createState() => _NutricionPageState();
}

class _NutricionPageState extends State<NutricionPage> {
  int _ageGroup = -1;
  int? _openTopic;

  @override
  void initState() {
    super.initState();
    _ageGroup = _selectedChildAgeGroup();
  }

  int _selectedChildAgeGroup() {
    final selectedId = ChildRepository.instance.selectedChildId.value;
    if (selectedId == null) {
      return -1;
    }

    final child = ChildRepository.instance.findById(selectedId);
    if (child == null) {
      return -1;
    }

    final now = DateTime.now();
    var months =
        (now.year - child.birthDate.year) * 12 + now.month - child.birthDate.month;
    if (now.day < child.birthDate.day) {
      months--;
    }

    if (months < 0) return -1;
    if (months <= 5) return 0;
    if (months <= 8) return 1;
    if (months <= 11) return 2;
    if (months <= 23) return 3;
    if (months <= 35) return 4;
    if (months <= 60) return 5;
    return -1;
  }

  List<MenuNutricionItem> _topics() {
    return const [
      MenuNutricionItem(
        tituloKey: 'nutritionFoodsTitle',
        subtituloKey: 'nutritionFoodsSubtitle',
        icono: Icons.restaurant_menu_rounded,
        color: Color(0xFFF59E55),
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
        color: Color(0xFF7B61C9),
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
        color: Color(0xFF00A8C8),
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
        color: Color(0xFF8B5CF6),
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
        color: Color(0xFFE35D6A),
        tipsKeys: [
          'nutritionSafetyTip1',
          'nutritionSafetyTip2',
          'nutritionSafetyTip3',
          'nutritionSafetyTip4',
          'nutritionSafetyTip5',
        ],
      ),
    ];
  }

  _NutritionStageCopy _stageCopy() {
    final bool english = AppConfig.idioma.value == 'en';

    const es = <int, _NutritionStageCopy>{
      -1: _NutritionStageCopy(
        title: 'Alimentación que crece con tu peque',
        subtitle:
            'Elige una etapa para ver orientaciones y recetas con texturas adecuadas para su edad.',
        tips: [
          'Prioriza alimentos caseros, variados y de tu entorno.',
          'Acompaña las comidas sin presión y observa señales de hambre y saciedad.',
          'Adapta siempre la textura, el tamaño y la consistencia a lo que el niño ya puede manejar.',
        ],
      ),
      0: _NutritionStageCopy(
        title: '0–5 meses · solo leche',
        subtitle:
            'En esta etapa no mostramos recetas de alimentos complementarios.',
        tips: [
          'Antes de los 6 meses, UNICEF recomienda lactancia materna exclusiva.',
          'No se ofrecen agua, té, jugos, papillas ni otros alimentos antes de los 6 meses.',
          'Si existen dificultades de alimentación o crecimiento, busca orientación del personal de salud.',
        ],
      ),
      1: _NutritionStageCopy(
        title: '6–8 meses · primeras cucharadas',
        subtitle:
            'Empieza con alimentos blandos, húmedos y fáciles de tragar, manteniendo la lactancia.',
        tips: [
          'Comienza con pequeñas cantidades y aumenta poco a poco.',
          'Puedes usar quinua, arroz o maíz, frutas suaves y vegetales bien cocidos.',
          'La carne o el pollo deben estar bien cocidos y muy finos.',
          'La textura debe ser suave, pero puede avanzar gradualmente según sus habilidades.',
        ],
      ),
      2: _NutritionStageCopy(
        title: '9–11 meses · más textura y variedad',
        subtitle:
            'Aparecen alimentos aplastados y trocitos muy blandos que ayudan a practicar la masticación.',
        tips: [
          'Incluye granos como lenteja o fréjol bien cocidos y aplastados.',
          'Combina alimentos locales: papa, verde, zanahoria, zapallo, quinua o yuca.',
          'Mantén los alimentos húmedos y evita piezas duras, redondas o difíciles de manejar.',
        ],
      ),
      3: _NutritionStageCopy(
        title: '1–2 años · comida de la familia adaptada',
        subtitle:
            'Puede compartir muchas preparaciones familiares, con porciones pequeñas y texturas seguras.',
        tips: [
          'Ofrece frutas y verduras todos los días y agua segura.',
          'Usa poca sal y evita bebidas azucaradas y productos ultraprocesados.',
          'Corta o aplasta los alimentos para que pueda comerlos con seguridad.',
          'Mantén horarios y un ambiente tranquilo durante las comidas.',
        ],
      ),
      4: _NutritionStageCopy(
        title: '2–3 años · sabores de casa',
        subtitle:
            'Es una buena etapa para ampliar la variedad y compartir preparaciones ecuatorianas sencillas.',
        tips: [
          'Combina cereales o tubérculos con verduras y una fuente de proteína.',
          'Invítalo a participar en tareas simples como lavar alimentos o mezclar con ayuda.',
          'Mantén el agua como bebida principal y limita productos muy azucarados o ultraprocesados.',
        ],
      ),
      5: _NutritionStageCopy(
        title: '3–5 años · variedad y autonomía',
        subtitle:
            'La comida familiar puede convertirse también en un momento de aprendizaje y participación.',
        tips: [
          'Ofrece variedad de colores, texturas y alimentos locales durante la semana.',
          'Deja que participe en preparaciones sencillas con supervisión.',
          'Mantén frutas, verduras, granos, tubérculos y proteínas como base de las comidas.',
          'Evita usar dulces o comida como premio o castigo.',
        ],
      ),
    };

    const en = <int, _NutritionStageCopy>{
      -1: _NutritionStageCopy(
        title: 'Food that grows with your child',
        subtitle:
            'Choose a stage to see guidance and recipes with age-appropriate textures.',
        tips: [
          'Prioritize homemade, varied foods from your local environment.',
          'Share meals without pressure and watch hunger and fullness cues.',
          'Always adapt texture, size, and consistency to the child’s current eating skills.',
        ],
      ),
      0: _NutritionStageCopy(
        title: '0–5 months · milk only',
        subtitle:
            'At this stage, complementary-food recipes are not displayed.',
        tips: [
          'Before 6 months, UNICEF recommends exclusive breastfeeding.',
          'Water, tea, juice, purees, or other foods are not offered before 6 months.',
          'If feeding or growth is difficult, seek guidance from health personnel.',
        ],
      ),
      1: _NutritionStageCopy(
        title: '6–8 months · first spoonfuls',
        subtitle:
            'Start with soft, moist foods that are easy to swallow while continuing breastfeeding.',
        tips: [
          'Begin with small amounts and increase gradually.',
          'Quinoa, rice or corn, soft fruit, and well-cooked vegetables can be used.',
          'Meat or chicken should be thoroughly cooked and finely prepared.',
          'Texture should be soft and can progress with the child’s skills.',
        ],
      ),
      2: _NutritionStageCopy(
        title: '9–11 months · more texture and variety',
        subtitle:
            'Mashed foods and very soft small pieces help practice chewing.',
        tips: [
          'Include well-cooked mashed legumes such as lentils or beans.',
          'Combine local foods such as potato, plantain, carrot, pumpkin, quinoa, or cassava.',
          'Keep foods moist and avoid hard, round, or difficult pieces.',
        ],
      ),
      3: _NutritionStageCopy(
        title: '1–2 years · adapted family meals',
        subtitle:
            'Many family foods can be shared in small portions and safe textures.',
        tips: [
          'Offer fruit and vegetables daily and safe drinking water.',
          'Use little salt and avoid sugary drinks and ultra-processed foods.',
          'Cut or mash foods to make eating safer.',
          'Keep regular meal times and a calm eating environment.',
        ],
      ),
      4: _NutritionStageCopy(
        title: '2–3 years · family flavors',
        subtitle:
            'A good stage to expand variety and share simple Ecuadorian preparations.',
        tips: [
          'Combine grains or tubers with vegetables and a protein source.',
          'Invite the child to help with simple tasks such as washing or mixing with support.',
          'Keep water as the main drink and limit very sugary or ultra-processed products.',
        ],
      ),
      5: _NutritionStageCopy(
        title: '3–5 years · variety and independence',
        subtitle:
            'Family meals can also become moments for learning and participation.',
        tips: [
          'Offer different colors, textures, and local foods throughout the week.',
          'Let the child participate in simple food preparation with supervision.',
          'Base meals on fruit, vegetables, grains, tubers, and protein foods.',
          'Avoid using sweets or food as a reward or punishment.',
        ],
      ),
    };

    return (english ? en : es)[_ageGroup] ?? (english ? en : es)[-1]!;
  }

  bool _recipeVisible(EcuadorRecipe recipe) {
    switch (_ageGroup) {
      case 0:
        return false;
      case 1:
        return recipe.fitsMonths(6) || recipe.fitsMonths(8);
      case 2:
        return recipe.fitsMonths(9) || recipe.fitsMonths(11);
      case 3:
        return recipe.fitsMonths(12) || recipe.fitsMonths(23);
      case 4:
        return recipe.fitsMonths(24) || recipe.fitsMonths(35);
      case 5:
        return recipe.fitsMonths(36) || recipe.fitsMonths(60);
      default:
        return true;
    }
  }

  String _ageLabel(int group) {
    switch (group) {
      case 0:
        return T.txt('nutritionAge0to5');
      case 1:
        return T.txt('nutritionAge6to8');
      case 2:
        return T.txt('nutritionAge9to11');
      case 3:
        return T.txt('nutritionAge1to2');
      case 4:
        return T.txt('nutritionAge2to3');
      case 5:
        return T.txt('nutritionAge3to5');
      default:
        return T.txt('nutritionAllAges');
    }
  }

  Color _regionColor(EcuadorRecipeRegion region) {
    switch (region) {
      case EcuadorRecipeRegion.sierra:
        return const Color(0xFF7B61C9);
      case EcuadorRecipeRegion.costa:
        return const Color(0xFFF59E55);
      case EcuadorRecipeRegion.amazonia:
        return const Color(0xFF16B89A);
    }
  }

  String _regionLabel(EcuadorRecipeRegion region) {
    switch (region) {
      case EcuadorRecipeRegion.sierra:
        return T.txt('nutritionRegionSierra');
      case EcuadorRecipeRegion.costa:
        return T.txt('nutritionRegionCosta');
      case EcuadorRecipeRegion.amazonia:
        return T.txt('nutritionRegionAmazonia');
    }
  }

  void _openRecipe(EcuadorRecipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _RecipeDetailPage(
          recipe: recipe,
          regionLabel: _regionLabel(recipe.region),
          regionColor: _regionColor(recipe.region),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, language, _) {
        final bool dark = FamilyUi.dark(context);
        final stage = _stageCopy();
        final recipes =
            ecuadorRecipeCatalog.where(_recipeVisible).toList(growable: false);
        final topics = _topics();

        return Scaffold(
          backgroundColor: dark ? FamilyUi.canvasDark : FamilyUi.canvasLight,
          appBar: FamilyUi.appBar(context, T.txt('nutrition')),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final side = constraints.maxWidth < 380 ? 16.0 : 20.0;
                final inner = constraints.maxWidth - side * 2;
                final twoColumns = inner >= 650;
                final cardWidth = twoColumns ? (inner - 14) / 2 : inner;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(side, 20, side, 38),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FamilyHero(
                            eyebrow: T.txt('nutritionGuideTag'),
                            title: T.txt('nutritionGuideTitle'),
                            subtitle: T.txt('nutritionGuideSubtitle'),
                            icon: Icons.restaurant_rounded,
                            color: const Color(0xFFF59E55),
                            accent: const Color(0xFFE9C15A),
                          ),
                          const SizedBox(height: 26),
                          FamilySectionHeading(
                            title: T.txt('nutritionChooseAge'),
                            subtitle: T.txt('nutritionChooseAgeSubtitle'),
                            icon: Icons.child_care_rounded,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int group = -1; group <= 5; group++) ...[
                                  _NutritionAgePill(
                                    label: _ageLabel(group),
                                    selected: _ageGroup == group,
                                    onTap: () => setState(() {
                                      _ageGroup = group;
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _NutritionStagePanel(
                            stage: stage,
                            dark: dark,
                          ),
                          const SizedBox(height: 30),
                          FamilySectionHeading(
                            title: T.txt('nutritionHabitsTitle'),
                            subtitle: T.txt('nutritionHabitsSubtitle'),
                            icon: Icons.spa_rounded,
                          ),
                          for (var i = 0; i < topics.length; i++)
                            _NutritionGuideRow(
                              title: T.txt(topics[i].tituloKey),
                              subtitle: T.txt(topics[i].subtituloKey),
                              icon: topics[i].icono,
                              color: topics[i].color,
                              dark: dark,
                              expanded: _openTopic == i,
                              onTap: () => setState(
                                () => _openTopic = _openTopic == i ? null : i,
                              ),
                              child: _NutritionBulletList(
                                items: topics[i]
                                    .tipsKeys
                                    .map((key) => T.txt(key))
                                    .toList(),
                                color: topics[i].color,
                                dark: dark,
                              ),
                            ),
                          const SizedBox(height: 32),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FamilySectionHeading(
                                  title: T.txt('nutritionRecipesEcuadorTitle'),
                                  subtitle:
                                      T.txt('nutritionRecipesEcuadorSubtitle'),
                                  icon: Icons.menu_book_rounded,
                                ),
                              ),
                              if (_ageGroup != 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    T
                                        .txt('nutritionRecipesCount')
                                        .replaceAll(
                                          '{count}',
                                          recipes.length.toString(),
                                        ),
                                    style: TextStyle(
                                      fontFamily: 'Baloo2',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          dark ? Colors.white60 : Colors.black54,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (_ageGroup == 0)
                            FamilyNotice(
                              text: T.txt('nutritionNoRecipesUnder6'),
                              icon: Icons.favorite_rounded,
                              color: const Color(0xFFEC5F7A),
                            )
                          else
                            Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: [
                                for (final recipe in recipes)
                                  SizedBox(
                                    width: cardWidth,
                                    child: _EcuadorRecipeCard(
                                      recipe: recipe,
                                      regionLabel:
                                          _regionLabel(recipe.region),
                                      color: _regionColor(recipe.region),
                                      dark: dark,
                                      onTap: () => _openRecipe(recipe),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 26),
                          FamilyNotice(
                            text: T.txt('nutritionSourceNote'),
                            icon: Icons.verified_rounded,
                            color: const Color(0xFF16B89A),
                          ),
                          const SizedBox(height: 12),
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
              },
            ),
          ),
        );
      },
    );
  }
}

class _NutritionStageCopy {
  const _NutritionStageCopy({
    required this.title,
    required this.subtitle,
    required this.tips,
  });

  final String title;
  final String subtitle;
  final List<String> tips;
}

class _NutritionStagePanel extends StatelessWidget {
  const _NutritionStagePanel({
    required this.stage,
    required this.dark,
  });

  final _NutritionStageCopy stage;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFF59E55);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            dark ? const Color(0xFF211D2B) : Colors.white,
            color.withValues(alpha: dark ? 0.18 : 0.09),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: dark ? 0.05 : 0.10),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: dark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: color,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.title,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: FamilyUi.ink(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stage.subtitle,
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 14.5,
                        height: 1.3,
                        color: FamilyUi.muted(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final tip in stage.tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: color,
                    size: 19,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 14.5,
                        height: 1.35,
                        color: dark ? Colors.white70 : const Color(0xFF625A69),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NutritionAgePill extends StatelessWidget {
  const _NutritionAgePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = FamilyUi.dark(context);
    const color = Color(0xFFF59E55);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? color
                : dark
                    ? FamilyUi.surfaceDark
                    : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.22),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: selected
                  ? Colors.white
                  : dark
                      ? Colors.white70
                      : const Color(0xFF5E5665),
            ),
          ),
        ),
      ),
    );
  }
}

class _NutritionGuideRow extends StatelessWidget {
  const _NutritionGuideRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.dark,
    required this.expanded,
    required this.onTap,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool dark;
  final bool expanded;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 49,
                    height: 49,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: dark ? 0.18 : 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: color, size: 25),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 17.5,
                            fontWeight: FontWeight.w800,
                            color: FamilyUi.ink(context),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 14,
                            height: 1.25,
                            color: FamilyUi.muted(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 220),
                    turns: expanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: color,
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 15),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: dark ? 0.08 : 0.04),
                      borderRadius: BorderRadius.circular(18),
                      border: Border(
                        left: BorderSide(
                          color: color.withValues(alpha: 0.72),
                          width: 3,
                        ),
                      ),
                    ),
                    child: child,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        Divider(
          height: 1,
          color: dark ? Colors.white10 : Colors.black.withValues(alpha: 0.07),
        ),
      ],
    );
  }
}

class _NutritionBulletList extends StatelessWidget {
  const _NutritionBulletList({
    required this.items,
    required this.color,
    required this.dark,
  });

  final List<String> items;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_rounded, size: 18, color: color),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 14.5,
                      height: 1.35,
                      color: dark ? Colors.white70 : const Color(0xFF625A69),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EcuadorRecipeCard extends StatelessWidget {
  const _EcuadorRecipeCard({
    required this.recipe,
    required this.regionLabel,
    required this.color,
    required this.dark,
    required this.onTap,
  });

  final EcuadorRecipe recipe;
  final String regionLabel;
  final Color color;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final copy = recipe.copy;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                dark ? const Color(0xFF211D2B) : Colors.white,
                color.withValues(alpha: dark ? 0.18 : 0.09),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: dark ? 0.05 : 0.09),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 49,
                    height: 49,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: dark ? 0.18 : 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      recipe.emoji,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 5,
                      children: [
                        _RecipeBadge(
                          text: regionLabel,
                          color: color,
                          dark: dark,
                        ),
                        _RecipeBadge(
                          text:
                              '${recipe.minutes} ${T.txt('nutritionMinutes')}',
                          color: color,
                          dark: dark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                copy.title,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 19,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  color: FamilyUi.ink(context),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                copy.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 14,
                  height: 1.3,
                  color: FamilyUi.muted(context),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Text(
                    T.txt('guideActivityCta'),
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: color,
                    size: 21,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeBadge extends StatelessWidget {
  const _RecipeBadge({
    required this.text,
    required this.color,
    required this.dark,
  });

  final String text;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Baloo2',
          fontSize: 11.5,
          height: 1,
          fontWeight: FontWeight.w800,
          color: dark ? Colors.white70 : color,
        ),
      ),
    );
  }
}

class _RecipeDetailPage extends StatelessWidget {
  const _RecipeDetailPage({
    required this.recipe,
    required this.regionLabel,
    required this.regionColor,
  });

  final EcuadorRecipe recipe;
  final String regionLabel;
  final Color regionColor;

  @override
  Widget build(BuildContext context) {
    final copy = recipe.copy;
    final dark = FamilyUi.dark(context);

    return Scaffold(
      backgroundColor: dark ? FamilyUi.canvasDark : FamilyUi.canvasLight,
      appBar: FamilyUi.appBar(context, T.txt('nutritionRecipeDetailTitle')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 38),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FamilyHero(
                    eyebrow: regionLabel,
                    title: copy.title,
                    subtitle: copy.summary,
                    icon: Icons.soup_kitchen_rounded,
                    color: regionColor,
                    accent: const Color(0xFFF3C664),
                  ),
                  const SizedBox(height: 23),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _RecipeBadge(
                        text: regionLabel,
                        color: regionColor,
                        dark: dark,
                      ),
                      _RecipeBadge(
                        text:
                            '${recipe.minutes} ${T.txt('nutritionMinutes')}',
                        color: regionColor,
                        dark: dark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FamilySectionHeading(
                    title: T.txt('ingredients'),
                    icon: Icons.shopping_basket_rounded,
                  ),
                  FamilyBulletList(
                    items: copy.ingredients,
                    color: regionColor,
                  ),
                  const SizedBox(height: 13),
                  FamilySectionHeading(
                    title: T.txt('preparation'),
                    icon: Icons.format_list_numbered_rounded,
                  ),
                  FamilyBulletList(
                    items: copy.steps,
                    color: regionColor,
                    numbered: true,
                  ),
                  const SizedBox(height: 13),
                  FamilyInfoPanel(
                    title: T.txt('nutritionTextureTitle'),
                    text: copy.texture,
                    icon: Icons.texture_rounded,
                    color: regionColor,
                  ),
                  const SizedBox(height: 11),
                  FamilyNotice(
                    text: copy.safety,
                    icon: Icons.health_and_safety_rounded,
                    color: const Color(0xFFE35D6A),
                  ),
                  const SizedBox(height: 11),
                  FamilyNotice(
                    text: T.txt('nutritionRecipeAdaptedNote'),
                    icon: Icons.verified_rounded,
                    color: const Color(0xFF16B89A),
                  ),
                ],
              ),
            ),
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
