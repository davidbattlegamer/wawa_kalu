import '../../../pages/app_texts.dart';

enum EcuadorRecipeRegion {
  sierra,
  costa,
  amazonia,
}

class EcuadorRecipeCopy {
  const EcuadorRecipeCopy({
    required this.title,
    required this.summary,
    required this.ingredients,
    required this.steps,
    required this.texture,
    required this.safety,
  });

  final String title;
  final String summary;
  final List<String> ingredients;
  final List<String> steps;
  final String texture;
  final String safety;
}

class EcuadorRecipeCopyKeys {
  const EcuadorRecipeCopyKeys({
    required this.titleKey,
    required this.summaryKey,
    required this.ingredientKeys,
    required this.stepKeys,
    required this.textureKey,
    required this.safetyKey,
  });

  final String titleKey;
  final String summaryKey;
  final List<String> ingredientKeys;
  final List<String> stepKeys;
  final String textureKey;
  final String safetyKey;

  EcuadorRecipeCopy resolve() {
    return EcuadorRecipeCopy(
      title: T.txt(titleKey),
      summary: T.txt(summaryKey),
      ingredients: ingredientKeys.map(T.txt).toList(growable: false),
      steps: stepKeys.map(T.txt).toList(growable: false),
      texture: T.txt(textureKey),
      safety: T.txt(safetyKey),
    );
  }
}

class EcuadorRecipe {
  const EcuadorRecipe({
    required this.id,
    required this.minAgeMonths,
    required this.maxAgeMonths,
    required this.region,
    required this.emoji,
    required this.minutes,
    required this.copyKeys,
  });

  final String id;
  final int minAgeMonths;
  final int maxAgeMonths;
  final EcuadorRecipeRegion region;
  final String emoji;
  final int minutes;
  final EcuadorRecipeCopyKeys copyKeys;

  EcuadorRecipeCopy get copy => copyKeys.resolve();

  bool fitsMonths(int months) {
    return months >= minAgeMonths && months <= maxAgeMonths;
  }
}

/// Recetas ecuatorianas adaptadas para la primera infancia.
///
/// Todo el texto visible se resuelve desde app_texts.dart para que español,
/// inglés y kichwa compartan la misma fuente de traducción.
const List<EcuadorRecipe> ecuadorRecipeCatalog = <EcuadorRecipe>[
  EcuadorRecipe(
    id: 'papilla_quinua_banano',
    minAgeMonths: 6,
    maxAgeMonths: 8,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🥣',
    minutes: 18,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeQuinoaBananaTitle',
      summaryKey: 'ecuRecipeQuinoaBananaSummary',
      ingredientKeys: [
        'ecuRecipeQuinoaBananaIng1',
        'ecuRecipeQuinoaBananaIng2',
        'ecuRecipeQuinoaBananaIng3',
      ],
      stepKeys: [
        'ecuRecipeQuinoaBananaStep1',
        'ecuRecipeQuinoaBananaStep2',
        'ecuRecipeQuinoaBananaStep3',
      ],
      textureKey: 'ecuRecipeQuinoaBananaTexture',
      safetyKey: 'ecuRecipeQuinoaBananaSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'crema_zapallo_papa_pollo',
    minAgeMonths: 6,
    maxAgeMonths: 8,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🎃',
    minutes: 25,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipePumpkinChickenTitle',
      summaryKey: 'ecuRecipePumpkinChickenSummary',
      ingredientKeys: [
        'ecuRecipePumpkinChickenIng1',
        'ecuRecipePumpkinChickenIng2',
        'ecuRecipePumpkinChickenIng3',
        'ecuRecipePumpkinChickenIng4',
      ],
      stepKeys: [
        'ecuRecipePumpkinChickenStep1',
        'ecuRecipePumpkinChickenStep2',
        'ecuRecipePumpkinChickenStep3',
      ],
      textureKey: 'ecuRecipePumpkinChickenTexture',
      safetyKey: 'ecuRecipePumpkinChickenSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'lenteja_papa_zanahoria',
    minAgeMonths: 9,
    maxAgeMonths: 11,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🫘',
    minutes: 30,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeLentilTitle',
      summaryKey: 'ecuRecipeLentilSummary',
      ingredientKeys: [
        'ecuRecipeLentilIng1',
        'ecuRecipeLentilIng2',
        'ecuRecipeLentilIng3',
        'ecuRecipeLentilIng4',
      ],
      stepKeys: [
        'ecuRecipeLentilStep1',
        'ecuRecipeLentilStep2',
        'ecuRecipeLentilStep3',
      ],
      textureKey: 'ecuRecipeLentilTexture',
      safetyKey: 'ecuRecipeLentilSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'majado_verde_pollo',
    minAgeMonths: 9,
    maxAgeMonths: 17,
    region: EcuadorRecipeRegion.costa,
    emoji: '🍌',
    minutes: 25,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipePlantainChickenTitle',
      summaryKey: 'ecuRecipePlantainChickenSummary',
      ingredientKeys: [
        'ecuRecipePlantainChickenIng1',
        'ecuRecipePlantainChickenIng2',
        'ecuRecipePlantainChickenIng3',
        'ecuRecipePlantainChickenIng4',
      ],
      stepKeys: [
        'ecuRecipePlantainChickenStep1',
        'ecuRecipePlantainChickenStep2',
        'ecuRecipePlantainChickenStep3',
      ],
      textureKey: 'ecuRecipePlantainChickenTexture',
      safetyKey: 'ecuRecipePlantainChickenSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'locro_suave_papa_queso',
    minAgeMonths: 12,
    maxAgeMonths: 35,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🥔',
    minutes: 30,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeLocroTitle',
      summaryKey: 'ecuRecipeLocroSummary',
      ingredientKeys: [
        'ecuRecipeLocroIng1',
        'ecuRecipeLocroIng2',
        'ecuRecipeLocroIng3',
        'ecuRecipeLocroIng4',
      ],
      stepKeys: [
        'ecuRecipeLocroStep1',
        'ecuRecipeLocroStep2',
        'ecuRecipeLocroStep3',
      ],
      textureKey: 'ecuRecipeLocroTexture',
      safetyKey: 'ecuRecipeLocroSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'sopa_quinua_pollo',
    minAgeMonths: 12,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🍲',
    minutes: 35,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeQuinoaSoupTitle',
      summaryKey: 'ecuRecipeQuinoaSoupSummary',
      ingredientKeys: [
        'ecuRecipeQuinoaSoupIng1',
        'ecuRecipeQuinoaSoupIng2',
        'ecuRecipeQuinoaSoupIng3',
        'ecuRecipeQuinoaSoupIng4',
      ],
      stepKeys: [
        'ecuRecipeQuinoaSoupStep1',
        'ecuRecipeQuinoaSoupStep2',
        'ecuRecipeQuinoaSoupStep3',
      ],
      textureKey: 'ecuRecipeQuinoaSoupTexture',
      safetyKey: 'ecuRecipeQuinoaSoupSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'bolon_suave_verde_queso',
    minAgeMonths: 24,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.costa,
    emoji: '🟢',
    minutes: 25,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeBolonTitle',
      summaryKey: 'ecuRecipeBolonSummary',
      ingredientKeys: [
        'ecuRecipeBolonIng1',
        'ecuRecipeBolonIng2',
        'ecuRecipeBolonIng3',
      ],
      stepKeys: [
        'ecuRecipeBolonStep1',
        'ecuRecipeBolonStep2',
        'ecuRecipeBolonStep3',
      ],
      textureKey: 'ecuRecipeBolonTexture',
      safetyKey: 'ecuRecipeBolonSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'sango_pescado_coco',
    minAgeMonths: 24,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.costa,
    emoji: '🐟',
    minutes: 35,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeSangoTitle',
      summaryKey: 'ecuRecipeSangoSummary',
      ingredientKeys: [
        'ecuRecipeSangoIng1',
        'ecuRecipeSangoIng2',
        'ecuRecipeSangoIng3',
        'ecuRecipeSangoIng4',
      ],
      stepKeys: [
        'ecuRecipeSangoStep1',
        'ecuRecipeSangoStep2',
        'ecuRecipeSangoStep3',
      ],
      textureKey: 'ecuRecipeSangoTexture',
      safetyKey: 'ecuRecipeSangoSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'yuca_pollo_vegetales',
    minAgeMonths: 24,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.amazonia,
    emoji: '🌿',
    minutes: 35,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeCassavaTitle',
      summaryKey: 'ecuRecipeCassavaSummary',
      ingredientKeys: [
        'ecuRecipeCassavaIng1',
        'ecuRecipeCassavaIng2',
        'ecuRecipeCassavaIng3',
        'ecuRecipeCassavaIng4',
      ],
      stepKeys: [
        'ecuRecipeCassavaStep1',
        'ecuRecipeCassavaStep2',
        'ecuRecipeCassavaStep3',
      ],
      textureKey: 'ecuRecipeCassavaTexture',
      safetyKey: 'ecuRecipeCassavaSafety',
    ),
  ),
  EcuadorRecipe(
    id: 'tortilla_maiz_queso_aguacate',
    minAgeMonths: 36,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🌽',
    minutes: 20,
    copyKeys: EcuadorRecipeCopyKeys(
      titleKey: 'ecuRecipeCornTortillaTitle',
      summaryKey: 'ecuRecipeCornTortillaSummary',
      ingredientKeys: [
        'ecuRecipeCornTortillaIng1',
        'ecuRecipeCornTortillaIng2',
        'ecuRecipeCornTortillaIng3',
        'ecuRecipeCornTortillaIng4',
      ],
      stepKeys: [
        'ecuRecipeCornTortillaStep1',
        'ecuRecipeCornTortillaStep2',
        'ecuRecipeCornTortillaStep3',
      ],
      textureKey: 'ecuRecipeCornTortillaTexture',
      safetyKey: 'ecuRecipeCornTortillaSafety',
    ),
  ),
];
