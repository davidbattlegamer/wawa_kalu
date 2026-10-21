import '../../../pages/app_texts.dart';

enum EcuadorRecipeRegion {
  sierra,
  costa,
  amazonia,
}

/// Fotografía orientativa de la presentación de una receta por etapa.
class EcuadorRecipePhoto {
  const EcuadorRecipePhoto({
    required this.url,
    required this.sourceUrl,
  });

  final String url;
  final String sourceUrl;
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
    required this.imageUrl,
    required this.imageSourceUrl,
    this.agePhotos = const <int, EcuadorRecipePhoto>{},
    required this.minutes,
    required this.copyKeys,
  });

  final String id;
  final int minAgeMonths;
  final int maxAgeMonths;
  final EcuadorRecipeRegion region;
  final String emoji;
  // Fotografía de referencia: puede mostrar una variante de la preparación.
  // Las imágenes se cargan de sus sitios de origen y necesitan Internet.
  final String imageUrl;
  final String imageSourceUrl;
  // Claves: 1 = 6–8 meses, 2 = 9–11, 3 = 12–23,
  // 4 = 24–35, 5 = 36–60. Si no hay variante, se usa la foto base.
  final Map<int, EcuadorRecipePhoto> agePhotos;
  final int minutes;
  final EcuadorRecipeCopyKeys copyKeys;

  EcuadorRecipeCopy get copy => copyKeys.resolve();

  /// Selecciona una fotografía según la edad, sin mostrar presentaciones
  /// de etapas posteriores para los niños más pequeños.
  EcuadorRecipePhoto photoForAgeMonths(int months) {
    final int age = months < minAgeMonths
        ? minAgeMonths
        : (months > maxAgeMonths ? maxAgeMonths : months);

    final int group;
    if (age < 9) {
      group = 1;
    } else if (age < 12) {
      group = 2;
    } else if (age < 24) {
      group = 3;
    } else if (age < 36) {
      group = 4;
    } else {
      group = 5;
    }
    return agePhotos[group] ??
        EcuadorRecipePhoto(url: imageUrl, sourceUrl: imageSourceUrl);
  }

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
    imageUrl: 'https://cdn7.kiwilimon.com/ss_secreto/1365/640x640/1365.jpg.jpg',
    imageSourceUrl: 'https://www.kiwilimon.com/tips/cocina/tips-de-platillos/papilla-de-platano-y-quinoa',
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
    imageUrl: 'https://img-global.cpcdn.com/recipes/539d998a11aa63aa/680x482cq70/papilla-de-pollo-y-zapallo-6-meses-foto-principal.jpg',
    imageSourceUrl: 'https://cookpad.com/mx/recetas/8959200-papilla-de-pollo-y-zapallo-6-meses',
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
    imageUrl: 'https://d3n3udvbogpuxv.cloudfront.net/cunxpxam4t__w%3D1000_autoCrop%3Dtrue',
    imageSourceUrl: 'https://www.frukt.no/oppskrifter/linsegryte/',
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
    imageUrl: 'https://1.bp.blogspot.com/-AMbc2jLXy_o/VZY1WMFO49I/AAAAAAAAFKY/M7I7kE7y0cc/s1600/7.jpg',
    imageSourceUrl: 'https://yumforbaby.blogspot.com/2015/07/4-easy-plantain-recipes.html',
    agePhotos: <int, EcuadorRecipePhoto>{
      3: EcuadorRecipePhoto(
        url: 'https://www.recetasnestle.com.ec/sites/default/files/srh_recipes/f143eccd7f5b11dbd8d95eb8829d0caf.jpg',
        sourceUrl: 'https://www.recetasnestle.com.ec/recetas/majado-de-verde',
      ),
    },
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
    imageUrl: 'https://static.wixstatic.com/media/4b53e3_77ef1503b15641b0a0e8f3d3b1c813f5~mv2.jpg/v1/fill/w_1000%2Ch_729%2Cal_c%2Cq_85%2Cusm_0.66_1.00_0.01/4b53e3_77ef1503b15641b0a0e8f3d3b1c813f5~mv2.jpg',
    imageSourceUrl: 'https://www.myecuadoriankitchen.com/post/sopa-de-papa',
    agePhotos: <int, EcuadorRecipePhoto>{
      4: EcuadorRecipePhoto(
        url: 'https://toursaroundquito.com/wp-content/uploads/2025/02/Potato-soup-locro-de-papa.jpg',
        sourceUrl: 'https://toursaroundquito.com/dishes-to-eat-in-quito-and-ecuador/',
      ),
    },
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
    imageUrl: 'https://cdn.cybassets.com/media/W1siZiIsIjI5MDA1L3Byb2R1Y3RzLzQ2Mzk4Mzg2LzE3MTg4MDY2NTlfYmUzMjQzNTIwYWM3YzYyMjk4MzMuanBlZyJdXQ.jpeg?sha=b347c8f95482f9a4',
    imageSourceUrl: 'https://www.royalmeal2018.com/products/sv21',
    agePhotos: <int, EcuadorRecipePhoto>{
      4: EcuadorRecipePhoto(
        url: 'https://www.recetasnestle.com.ec/sites/default/files/srh_recipes/1c7c9902781c62ebd24ea257fd5a6271.jpg',
        sourceUrl: 'https://www.recetasnestle.com.ec/recetas/sopa-de-quinua',
      ),
      5: EcuadorRecipePhoto(
        url: 'https://www.recetasnestle.com.co/sites/default/files/srh_recipes/75db642f62ccf3685aa50d274c026ec8.png',
        sourceUrl: 'https://www.recetasnestle.com.co/recetas/sopa-de-pollo-con-quinua-y-verduras',
      ),
    },
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
    imageUrl: 'https://img-global.cpcdn.com/recipes/7ec91a6e6f342988/1200x630cq70/photo.jpg',
    imageSourceUrl: 'https://cookpad.com/es/buscar/bolon%20de%20verde',
    agePhotos: <int, EcuadorRecipePhoto>{
      5: EcuadorRecipePhoto(
        url: 'https://www.recetasnestle.com.ec/sites/default/files/styles/recipe_detail_desktop_new/public/srh_recipes/b58bf96b15a0458b2a7a762ac7578dcb.jpg?itok=ff7IxR9N',
        sourceUrl: 'https://www.recetasnestle.com.ec/recetas/bolon-de-verde',
      ),
    },
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
    imageUrl: 'https://www.eluniverso.com/resizer/v2/KE74NOX6XVCTDIWL27L6GU5ORQ.jpg?auth=749a4d3159106d066dbe640d44f92cff94062b162279dcde900eac76b1b7a9f3&height=670&quality=75&smart=true&width=809',
    imageSourceUrl: 'https://www.eluniverso.com/larevista/cocina/receta-del-sango-de-verde-con-pescado-para-este-carnaval-nota/',
    agePhotos: <int, EcuadorRecipePhoto>{
      5: EcuadorRecipePhoto(
        url: 'https://cloudfront-us-east-1.images.arcpublishing.com/eluniverso/XTOJLBXOINCYNCIDWMKIY43E7E.jpg',
        sourceUrl: 'https://www.eluniverso.com/larevista/cocina/receta-de-sango-de-verde-con-pescado-por-las-fiestas-de-independencia-de-guayaquil-nota/',
      ),
    },
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
    imageUrl: 'https://res.cloudinary.com/hv9ssmzrz/image/fetch/c_fill%2Cf_auto%2Ch_1500%2Cq_auto%3Aeco%2Cw_1500/https%3A/s3-eu-west-1.amazonaws.com/images-ca-1-0-1-eu/recipe_photos/original/100783/102298565.jpg',
    imageSourceUrl: 'https://chefsimon.com/gourmets/made-in-cooking/recettes/poulet-carottes-et-pommes-de-terre-pour-bebe',
    agePhotos: <int, EcuadorRecipePhoto>{
      5: EcuadorRecipePhoto(
        url: 'https://www.arise-app.com/images/dishes/es/pollo-a-la-plancha-con-yuca-y-ensalada-1v8e5m.webp',
        sourceUrl: 'https://www.arise-app.com/es/plato/Pollo-a-la-plancha-con-yuca-y-ensalada',
      ),
    },
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
    imageUrl: 'https://www.superhealthykids.com/wp-content/uploads/2017/08/IMG_5067-2048x1365.jpg',
    imageSourceUrl: 'https://www.superhealthykids.com/kid-lunchbox-photo-roundup-90-healthy-lunches/',
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
