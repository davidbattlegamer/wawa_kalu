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
  bool _manualAgeSelection = false;
  late String _selectedProfileSignature;

  @override
  void initState() {
    super.initState();
    _selectedProfileSignature = _profileSignature();
    _ageGroup = _selectedChildAgeGroup();
    ChildRepository.instance.selectedChildId.addListener(_onProfileChanged);
    ChildRepository.instance.children.addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    ChildRepository.instance.selectedChildId.removeListener(_onProfileChanged);
    ChildRepository.instance.children.removeListener(_onProfileChanged);
    super.dispose();
  }

  // Si cambia el niño seleccionado (o su cumpleaños), actualizar la etapa.
  void _onProfileChanged() {
    final signature = _profileSignature();
    if (signature == _selectedProfileSignature || !mounted) return;
    _selectedProfileSignature = signature;
    setState(() {
      _manualAgeSelection = false;
      _ageGroup = _selectedChildAgeGroup();
    });
  }

  String _profileSignature() {
    final child = ChildRepository.instance.selectedChild;
    return child == null
        ? 'sin_perfil'
        : '${child.id}|${child.birthDate.toIso8601String()}';
  }

  int? _selectedChildAgeMonths() {
    final child = ChildRepository.instance.selectedChild;
    if (child == null) return null;
    final now = DateTime.now();
    final months = (now.year - child.birthDate.year) * 12 +
        now.month - child.birthDate.month -
        (now.day < child.birthDate.day ? 1 : 0);
    return months < 0 ? null : months;
  }

  int _photoAgeMonths(EcuadorRecipe recipe) {
    final actualMonths = _selectedChildAgeMonths();
    if (!_manualAgeSelection && actualMonths != null) {
      return actualMonths;
    }
    switch (_ageGroup) {
      case 1:
        return 7; // 6–8 meses
      case 2:
        return 10; // 9–11 meses
      case 3:
        return 18; // 12–23 meses
      case 4:
        return 30; // 24–35 meses
      case 5:
        return 48; // 36–60 meses
      default:
        return recipe.minAgeMonths;
    }
  }

  int _selectedChildAgeGroup() {
    final months = _selectedChildAgeMonths();
    if (months == null) return -1;
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
    switch (_ageGroup) {
      case 0:
        return _NutritionStageCopy(
          title: T.txt('nutritionStage0Title'),
          subtitle: T.txt('nutritionStage0Subtitle'),
          tips: [
            T.txt('nutritionStage0Tip1'),
            T.txt('nutritionStage0Tip2'),
            T.txt('nutritionStage0Tip3'),
          ],
        );
      case 1:
        return _NutritionStageCopy(
          title: T.txt('nutritionStage1Title'),
          subtitle: T.txt('nutritionStage1Subtitle'),
          tips: [
            T.txt('nutritionStage1Tip1'),
            T.txt('nutritionStage1Tip2'),
            T.txt('nutritionStage1Tip3'),
            T.txt('nutritionStage1Tip4'),
          ],
        );
      case 2:
        return _NutritionStageCopy(
          title: T.txt('nutritionStage2Title'),
          subtitle: T.txt('nutritionStage2Subtitle'),
          tips: [
            T.txt('nutritionStage2Tip1'),
            T.txt('nutritionStage2Tip2'),
            T.txt('nutritionStage2Tip3'),
          ],
        );
      case 3:
        return _NutritionStageCopy(
          title: T.txt('nutritionStage3Title'),
          subtitle: T.txt('nutritionStage3Subtitle'),
          tips: [
            T.txt('nutritionStage3Tip1'),
            T.txt('nutritionStage3Tip2'),
            T.txt('nutritionStage3Tip3'),
            T.txt('nutritionStage3Tip4'),
          ],
        );
      case 4:
        return _NutritionStageCopy(
          title: T.txt('nutritionStage4Title'),
          subtitle: T.txt('nutritionStage4Subtitle'),
          tips: [
            T.txt('nutritionStage4Tip1'),
            T.txt('nutritionStage4Tip2'),
            T.txt('nutritionStage4Tip3'),
          ],
        );
      case 5:
        return _NutritionStageCopy(
          title: T.txt('nutritionStage5Title'),
          subtitle: T.txt('nutritionStage5Subtitle'),
          tips: [
            T.txt('nutritionStage5Tip1'),
            T.txt('nutritionStage5Tip2'),
            T.txt('nutritionStage5Tip3'),
            T.txt('nutritionStage5Tip4'),
          ],
        );
      default:
        return _NutritionStageCopy(
          title: T.txt('nutritionStageAllTitle'),
          subtitle: T.txt('nutritionStageAllSubtitle'),
          tips: [
            T.txt('nutritionStageAllTip1'),
            T.txt('nutritionStageAllTip2'),
            T.txt('nutritionStageAllTip3'),
          ],
        );
    }
  }

  bool _recipeVisible(EcuadorRecipe recipe) {
    // Si se eligió un niño, mostrar únicamente recetas para su edad exacta.
    // El filtro manual permite explorar intervalos completos de edad.
    final months = _selectedChildAgeMonths();
    if (!_manualAgeSelection && months != null && months >= 6 && months <= 60) {
      return recipe.fitsMonths(months);
    }
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
          photoAgeMonths: _photoAgeMonths(recipe),
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
                                      _manualAgeSelection = true;
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
                          const SizedBox(height: 28),

                          FamilySectionHeading(
                            title: T.txt('nutritionCookTodayTitle'),
                            subtitle: T.txt('nutritionCookTodaySubtitle'),
                            icon: Icons.soup_kitchen_rounded,
                          ),

                          if (_ageGroup == 0)
                            FamilyNotice(
                              text: T.txt('nutritionNoRecipesUnder6'),
                              icon: Icons.favorite_rounded,
                              color: const Color(0xFFEC5F7A),
                            )
                          else if (recipes.isNotEmpty) ...[
                            _RecipeSpotlight(
                              recipe: recipes.first,
                              photoAgeMonths: _photoAgeMonths(recipes.first),
                              regionLabel:
                                  _regionLabel(recipes.first.region),
                              color: _regionColor(recipes.first.region),
                              dark: dark,
                              onTap: () => _openRecipe(recipes.first),
                            ),
                            if (recipes.length > 1) ...[
                              const SizedBox(height: 13),
                              Text(
                                T.txt('nutritionMoreIdeasTitle'),
                                style: TextStyle(
                                  fontFamily: 'Fredoka',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: FamilyUi.ink(context),
                                ),
                              ),
                              const SizedBox(height: 9),
                              SizedBox(
                                // Espacio para foto, título de dos líneas y pie
                                // sin desbordar las tarjetas horizontales.
                                height: 224,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recipes.length - 1,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final recipe = recipes[index + 1];
                                    return SizedBox(
                                      width: 225,
                                      child: _RecipeQuickPick(
                                        recipe: recipe,
                                        photoAgeMonths: _photoAgeMonths(recipe),
                                        regionLabel:
                                            _regionLabel(recipe.region),
                                        color:
                                            _regionColor(recipe.region),
                                        dark: dark,
                                        onTap: () => _openRecipe(recipe),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],

                          const SizedBox(height: 28),
                          _NutritionBridge(
                            dark: dark,
                            title: T.txt('nutritionJourneyBridgeTitle'),
                            text: T.txt('nutritionJourneyBridgeText'),
                          ),

                          const SizedBox(height: 28),
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

// La foto representa la textura de la receta para la edad seleccionada.
class _RecipePhoto extends StatelessWidget {
  const _RecipePhoto({
    required this.recipe,
    required this.color,
    required this.ageMonths,
    this.height = 150,
    this.radius = 18,
  });

  final EcuadorRecipe recipe;
  final Color color;
  final int ageMonths;
  final double height;
  final double radius;

  String _ageLabel(int months) {
    if (months < 9) return T.txt('nutritionAge6to8');
    if (months < 12) return T.txt('nutritionAge9to11');
    if (months < 24) return T.txt('nutritionAge1to2');
    if (months < 36) return T.txt('nutritionAge2to3');
    return T.txt('nutritionAge3to5');
  }

  @override
  Widget build(BuildContext context) {
    final photo = recipe.photoForAgeMonths(ageMonths);
    final age = ageMonths < recipe.minAgeMonths
        ? recipe.minAgeMonths
        : (ageMonths > recipe.maxAgeMonths ? recipe.maxAgeMonths : ageMonths);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Priorizar fotos dentro del APK: no consumen datos móviles.
            // Si aún no se ha incorporado el asset, usar la foto web como
            // respaldo; el resto de recetas mantienen su comportamiento.
            photo.assetPath == null
                ? _networkPhoto(photo.url)
                : Image.asset(
                    photo.assetPath!,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, __, ___) => _networkPhoto(photo.url),
                  ),
            if (height >= 140)
              Positioned(
                left: 9,
                bottom: 9,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.66),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _ageLabel(age),
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _networkPhoto(String url) => Image.network(
    url,
    fit: BoxFit.cover,
    filterQuality: FilterQuality.medium,
    errorBuilder: (_, __, ___) => _placeholder(),
    loadingBuilder: (_, child, progress) =>
        progress == null ? child : _placeholder(),
  );

  Widget _placeholder() => ColoredBox(
    color: color.withValues(alpha: 0.12),
    child: Center(child: Icon(Icons.restaurant_rounded, color: color, size: 32)),
  );
}

class _RecipeSpotlight extends StatelessWidget {
  const _RecipeSpotlight({
    required this.recipe,
    required this.photoAgeMonths,
    required this.regionLabel,
    required this.color,
    required this.dark,
    required this.onTap,
  });

  final EcuadorRecipe recipe;
  final int photoAgeMonths;
  final String regionLabel;
  final Color color;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final copy = recipe.copy;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: dark ? 0.34 : 0.18),
                dark ? const Color(0xFF211D2B) : Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: color.withValues(alpha: 0.30),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: dark ? 0.06 : 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -38,
                right: -18,
                child: Container(
                  width: 130,
                  height: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.09),
                  ),
                  child: Text(
                    recipe.emoji,
                    style: const TextStyle(fontSize: 52),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 19, 20, 19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 7,
                      runSpacing: 6,
                      children: [
                        _RecipeBadge(
                          text: T.txt('nutritionSuggestedRecipe'),
                          color: color,
                          dark: dark,
                        ),
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
                    const SizedBox(height: 14),
                    _RecipePhoto(recipe: recipe, color: color, ageMonths: photoAgeMonths, height: 168, radius: 19),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(right: 76),
                      child: Text(
                        copy.title,
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 23,
                          height: 1.08,
                          fontWeight: FontWeight.w800,
                          color: FamilyUi.ink(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 48),
                      child: Text(
                        copy.summary,
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 14.5,
                          height: 1.35,
                          color: FamilyUi.muted(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu_rounded,
                          color: color,
                          size: 20,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          T.txt('nutritionOpenRecipe'),
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: color.withValues(
                              alpha: dark ? 0.20 : 0.11,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: color,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeQuickPick extends StatelessWidget {
  const _RecipeQuickPick({
    required this.recipe,
    required this.photoAgeMonths,
    required this.regionLabel,
    required this.color,
    required this.dark,
    required this.onTap,
  });

  final EcuadorRecipe recipe;
  final int photoAgeMonths;
  final String regionLabel;
  final Color color;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final copy = recipe.copy;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                dark ? const Color(0xFF211D2B) : Colors.white,
                color.withValues(alpha: dark ? 0.16 : 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: color.withValues(alpha: 0.22),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    recipe.emoji,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const Spacer(),
                  _RecipeBadge(
                    text: regionLabel,
                    color: color,
                    dark: dark,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _RecipePhoto(recipe: recipe, color: color, ageMonths: photoAgeMonths, height: 64, radius: 10),
              const SizedBox(height: 7),
              Text(
                copy.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  color: FamilyUi.ink(context),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: color,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${recipe.minutes} ${T.txt('nutritionMinutes')}',
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: color,
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

class _NutritionBridge extends StatelessWidget {
  const _NutritionBridge({
    required this.dark,
    required this.title,
    required this.text,
  });

  final bool dark;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF7B61C9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.10 : 0.055),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: color.withValues(alpha: 0.17),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withValues(alpha: dark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.family_restroom_rounded,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: FamilyUi.ink(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 14,
                    height: 1.3,
                    color: FamilyUi.muted(context),
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
    required this.photoAgeMonths,
    required this.regionLabel,
    required this.regionColor,
  });

  final EcuadorRecipe recipe;
  final int photoAgeMonths;
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
                  const SizedBox(height: 15),
                  _RecipePhoto(
                    recipe: recipe,
                    color: regionColor,
                    ageMonths: photoAgeMonths,
                    height: 250,
                    radius: 24,
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
