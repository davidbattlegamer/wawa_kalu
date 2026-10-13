import '../../../pages/app_config.dart';

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

class EcuadorRecipe {
  const EcuadorRecipe({
    required this.id,
    required this.minAgeMonths,
    required this.maxAgeMonths,
    required this.region,
    required this.emoji,
    required this.minutes,
    required this.es,
    required this.en,
  });

  final String id;
  final int minAgeMonths;
  final int maxAgeMonths;
  final EcuadorRecipeRegion region;
  final String emoji;
  final int minutes;
  final EcuadorRecipeCopy es;
  final EcuadorRecipeCopy en;

  EcuadorRecipeCopy get copy {
    return AppConfig.idioma.value == 'en' ? en : es;
  }

  bool fitsMonths(int months) {
    return months >= minAgeMonths && months <= maxAgeMonths;
  }
}

/// Recetas ecuatorianas adaptadas para la primera infancia.
///
/// La identidad de los platos toma como referencia preparaciones e ingredientes
/// presentes en materiales educativos ecuatorianos. Las texturas y rangos de
/// edad se ajustan para una experiencia familiar orientativa y no sustituyen
/// la valoración individual de un profesional de salud.
const List<EcuadorRecipe> ecuadorRecipeCatalog = <EcuadorRecipe>[
  EcuadorRecipe(
    id: 'papilla_quinua_banano',
    minAgeMonths: 6,
    maxAgeMonths: 8,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🥣',
    minutes: 18,
    es: EcuadorRecipeCopy(
      title: 'Papilla suave de quinua y banano',
      summary:
          'Una combinación andina muy suave para el inicio de la alimentación complementaria.',
      ingredients: [
        '2 cucharadas de quinua bien lavada',
        '½ banano maduro',
        'Agua segura para la cocción',
      ],
      steps: [
        'Cocina la quinua en suficiente agua hasta que quede muy blanda.',
        'Aplasta o procesa la quinua hasta obtener una textura lisa y húmeda.',
        'Añade el banano aplastado y mezcla justo antes de servir.',
      ],
      texture:
          'Lisa, húmeda y fácil de tragar; ajusta con agua segura si queda muy espesa.',
      safety:
          'No agregues azúcar, miel ni sal. Ofrece al bebé sentado y siempre acompañado por un adulto.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Soft quinoa and banana mash',
      summary:
          'A gentle Andean combination for the beginning of complementary feeding.',
      ingredients: [
        '2 tablespoons well-rinsed quinoa',
        '½ ripe banana',
        'Safe water for cooking',
      ],
      steps: [
        'Cook quinoa in plenty of water until very soft.',
        'Mash or blend until smooth and moist.',
        'Add mashed banana just before serving.',
      ],
      texture:
          'Smooth, moist, and easy to swallow; thin with safe water if needed.',
      safety:
          'Do not add sugar, honey, or salt. Feed while seated and with close adult supervision.',
    ),
  ),
  EcuadorRecipe(
    id: 'crema_zapallo_papa_pollo',
    minAgeMonths: 6,
    maxAgeMonths: 8,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🎃',
    minutes: 25,
    es: EcuadorRecipeCopy(
      title: 'Crema de zapallo, papa y pollo',
      summary:
          'Una preparación casera de textura uniforme con vegetales y pollo bien cocido.',
      ingredients: [
        '½ taza de zapallo en cubos',
        '½ papa pequeña',
        '1 cucharada de pollo cocido y desmenuzado',
        'Agua segura',
      ],
      steps: [
        'Cocina el zapallo y la papa hasta que estén muy blandos.',
        'Añade el pollo ya cocido y calienta unos minutos.',
        'Tritura todo hasta lograr una crema homogénea y húmeda.',
      ],
      texture:
          'Crema uniforme sin trozos duros; deja enfriar antes de ofrecer.',
      safety:
          'Revisa que el pollo no tenga huesos. No uses cubitos de caldo ni añadas sal.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Pumpkin, potato, and chicken cream',
      summary:
          'A homemade smooth meal with vegetables and thoroughly cooked chicken.',
      ingredients: [
        '½ cup diced pumpkin',
        '½ small potato',
        '1 tablespoon cooked shredded chicken',
        'Safe water',
      ],
      steps: [
        'Cook pumpkin and potato until very soft.',
        'Add cooked chicken and heat briefly.',
        'Mash until smooth and moist.',
      ],
      texture:
          'Smooth cream with no hard pieces; let it cool before serving.',
      safety:
          'Check carefully for bones. Do not use stock cubes or add salt.',
    ),
  ),
  EcuadorRecipe(
    id: 'lenteja_papa_zanahoria',
    minAgeMonths: 9,
    maxAgeMonths: 11,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🫘',
    minutes: 30,
    es: EcuadorRecipeCopy(
      title: 'Lentejitas con papa y zanahoria',
      summary:
          'Lentejas bien cocidas y aplastadas, con ingredientes sencillos del hogar.',
      ingredients: [
        '3 cucharadas de lenteja cocida',
        '½ papa pequeña cocida',
        '2 cucharadas de zanahoria cocida',
        'Agua segura o líquido de cocción',
      ],
      steps: [
        'Cocina la lenteja hasta que esté completamente blanda.',
        'Aplasta la papa, la zanahoria y la lenteja con un tenedor.',
        'Añade un poco de líquido de cocción para mantener la mezcla húmeda.',
      ],
      texture:
          'Aplastada, suave y con pequeños grumos blandos para practicar nuevas texturas.',
      safety:
          'No dejes granos enteros duros. Supervisa de cerca mientras come.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Soft lentils with potato and carrot',
      summary:
          'Well-cooked mashed lentils with simple everyday ingredients.',
      ingredients: [
        '3 tablespoons cooked lentils',
        '½ small cooked potato',
        '2 tablespoons cooked carrot',
        'Safe water or cooking liquid',
      ],
      steps: [
        'Cook lentils until completely soft.',
        'Mash potato, carrot, and lentils with a fork.',
        'Add a little cooking liquid to keep the mixture moist.',
      ],
      texture:
          'Soft mash with small tender lumps for practicing new textures.',
      safety:
          'Do not leave firm whole legumes. Keep close supervision while eating.',
    ),
  ),
  EcuadorRecipe(
    id: 'majado_verde_pollo',
    minAgeMonths: 9,
    maxAgeMonths: 17,
    region: EcuadorRecipeRegion.costa,
    emoji: '🍌',
    minutes: 25,
    es: EcuadorRecipeCopy(
      title: 'Majado suave de verde con pollo',
      summary:
          'Plátano verde cocido y majado con pollo desmenuzado, inspirado en sabores de la Costa.',
      ingredients: [
        '½ plátano verde',
        '1 cucharada de pollo cocido y desmenuzado',
        '1 cucharadita de aceite vegetal',
        'Agua segura',
      ],
      steps: [
        'Hierve el verde hasta que esté completamente blando.',
        'Májalo con un poco de agua de cocción hasta que quede húmedo.',
        'Mezcla con el pollo muy fino y una pequeña cantidad de aceite.',
      ],
      texture:
          'Majado húmedo, sin bolas secas ni fibras largas de pollo.',
      safety:
          'No frías el verde para esta etapa y no añadas sal. Revisa que el pollo no tenga huesos.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Soft green plantain mash with chicken',
      summary:
          'Boiled green plantain mashed with shredded chicken, inspired by coastal flavors.',
      ingredients: [
        '½ green plantain',
        '1 tablespoon cooked shredded chicken',
        '1 teaspoon vegetable oil',
        'Safe water',
      ],
      steps: [
        'Boil plantain until completely soft.',
        'Mash with a little cooking water until moist.',
        'Mix in very finely shredded chicken and a small amount of oil.',
      ],
      texture:
          'Moist mash with no dry clumps or long chicken fibers.',
      safety:
          'Do not fry the plantain for this stage and do not add salt. Check for bones.',
    ),
  ),
  EcuadorRecipe(
    id: 'locro_suave_papa_queso',
    minAgeMonths: 12,
    maxAgeMonths: 35,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🥔',
    minutes: 30,
    es: EcuadorRecipeCopy(
      title: 'Locro suave de papa y queso',
      summary:
          'Una versión familiar, sencilla y menos condimentada del locro de papa.',
      ingredients: [
        '1 papa mediana',
        '2 cucharadas de leche pasteurizada',
        '1 cucharada de queso fresco pasteurizado desmenuzado',
        'Un trocito de aguacate para acompañar',
      ],
      steps: [
        'Cocina la papa en agua hasta que esté muy blanda.',
        'Aplasta parte de la papa para espesar y añade la leche.',
        'Agrega el queso al final y sirve tibio con aguacate bien maduro.',
      ],
      texture:
          'Espesa y suave, con trocitos blandos pequeños según la habilidad del niño.',
      safety:
          'Usa lácteos pasteurizados y poca o ninguna sal añadida. Corta el aguacate en forma segura para su etapa.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Gentle potato and cheese locro',
      summary:
          'A simple, lightly seasoned family version of Ecuadorian potato locro.',
      ingredients: [
        '1 medium potato',
        '2 tablespoons pasteurized milk',
        '1 tablespoon crumbled pasteurized fresh cheese',
        'A small piece of ripe avocado',
      ],
      steps: [
        'Cook potato in water until very soft.',
        'Mash part of the potato to thicken and add milk.',
        'Add cheese at the end and serve warm with ripe avocado.',
      ],
      texture:
          'Thick and soft, with small tender pieces based on the child’s eating skills.',
      safety:
          'Use pasteurized dairy and little or no added salt. Cut avocado appropriately for the child’s stage.',
    ),
  ),
  EcuadorRecipe(
    id: 'sopa_quinua_pollo',
    minAgeMonths: 12,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🍲',
    minutes: 35,
    es: EcuadorRecipeCopy(
      title: 'Sopa ecuatoriana de quinua con pollo',
      summary:
          'Adaptación infantil de la sopa de quinua del recetario educativo ecuatoriano.',
      ingredients: [
        '¼ taza de quinua bien lavada',
        '½ papa pequeña',
        '2 cucharadas de zanahoria rallada',
        '2 cucharadas de pollo cocido y desmenuzado',
      ],
      steps: [
        'Cocina la quinua hasta que abra y quede blanda.',
        'Añade papa y zanahoria; cocina hasta que se deshagan con facilidad.',
        'Incorpora el pollo muy fino y sirve con suficiente caldo para que quede húmeda.',
      ],
      texture:
          'Para 1–2 años, deja los ingredientes muy blandos y pequeños; después puede quedar más rústica.',
      safety:
          'Evita cubitos de caldo y exceso de sal. Revisa cuidadosamente que el pollo no tenga huesos.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Ecuadorian quinoa soup with chicken',
      summary:
          'A child-friendly adaptation of quinoa soup from Ecuadorian educational recipe materials.',
      ingredients: [
        '¼ cup well-rinsed quinoa',
        '½ small potato',
        '2 tablespoons grated carrot',
        '2 tablespoons cooked shredded chicken',
      ],
      steps: [
        'Cook quinoa until opened and soft.',
        'Add potato and carrot and cook until very tender.',
        'Add finely shredded chicken and enough broth to keep it moist.',
      ],
      texture:
          'For ages 1–2, keep ingredients very soft and small; later it may be more rustic.',
      safety:
          'Avoid stock cubes and excess salt. Check chicken carefully for bones.',
    ),
  ),
  EcuadorRecipe(
    id: 'bolon_suave_verde_queso',
    minAgeMonths: 24,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.costa,
    emoji: '🟢',
    minutes: 25,
    es: EcuadorRecipeCopy(
      title: 'Bolón suave de verde y queso',
      summary:
          'Versión al horno o cocida, sin fritura pesada, de un clásico de la Costa ecuatoriana.',
      ingredients: [
        '1 plátano verde pequeño',
        '2 cucharadas de queso fresco pasteurizado rallado',
        '1 cucharadita de aceite vegetal',
      ],
      steps: [
        'Hierve el verde hasta que esté muy blando y luego májalo.',
        'Mezcla con el queso y el aceite hasta formar una masa suave.',
        'Forma porciones pequeñas y calienta en sartén antiadherente o al horno sin dorar en exceso.',
      ],
      texture:
          'Blanda y húmeda; sirve en trozos pequeños que el niño pueda masticar con facilidad.',
      safety:
          'Evita chicharrón y exceso de sal para esta versión infantil. Supervisa mientras come.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Soft green plantain and cheese bolón',
      summary:
          'A baked or boiled child-friendly version of a coastal Ecuadorian classic.',
      ingredients: [
        '1 small green plantain',
        '2 tablespoons grated pasteurized fresh cheese',
        '1 teaspoon vegetable oil',
      ],
      steps: [
        'Boil plantain until very soft and mash it.',
        'Mix with cheese and oil until soft.',
        'Shape small portions and warm in a non-stick pan or oven without over-browning.',
      ],
      texture:
          'Soft and moist; serve in small pieces that are easy to chew.',
      safety:
          'Skip pork cracklings and excess salt in this child-friendly version. Supervise while eating.',
    ),
  ),
  EcuadorRecipe(
    id: 'sango_pescado_coco',
    minAgeMonths: 24,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.costa,
    emoji: '🐟',
    minutes: 35,
    es: EcuadorRecipeCopy(
      title: 'Sango suave de pescado con coco',
      summary:
          'Adaptación infantil del sango de pescado con coco incluido en el recetario educativo ecuatoriano.',
      ingredients: [
        '1 filete pequeño de pescado sin espinas',
        '½ plátano maduro',
        '¼ taza de leche de coco sin azúcar añadida',
        'Agua segura',
      ],
      steps: [
        'Cocina el plátano maduro en agua hasta que esté muy blando.',
        'Añade el pescado limpio y cocina completamente.',
        'Incorpora la leche de coco y aplasta ligeramente hasta obtener una preparación espesa.',
      ],
      texture:
          'Espesa, húmeda y con el pescado desmenuzado en trozos muy pequeños.',
      safety:
          'Retira todas las espinas antes de servir. Para niños pequeños evita camarón en esta versión y no añadas sal.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Gentle fish and coconut sango',
      summary:
          'A child-friendly adaptation of fish and coconut sango from Ecuadorian educational recipe materials.',
      ingredients: [
        '1 small boneless fish fillet',
        '½ ripe plantain',
        '¼ cup unsweetened coconut milk',
        'Safe water',
      ],
      steps: [
        'Cook ripe plantain in water until very soft.',
        'Add cleaned fish and cook thoroughly.',
        'Add coconut milk and lightly mash until thick.',
      ],
      texture:
          'Thick and moist with fish flaked into very small pieces.',
      safety:
          'Remove every bone before serving. For young children, omit shrimp in this version and do not add salt.',
    ),
  ),
  EcuadorRecipe(
    id: 'yuca_pollo_vegetales',
    minAgeMonths: 24,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.amazonia,
    emoji: '🌿',
    minutes: 35,
    es: EcuadorRecipeCopy(
      title: 'Yuca suave con pollo y vegetales',
      summary:
          'Una preparación inspirada en ingredientes cotidianos de la Amazonía ecuatoriana.',
      ingredients: [
        '½ taza de yuca pelada en trozos',
        '2 cucharadas de pollo cocido y desmenuzado',
        '2 cucharadas de zanahoria',
        '2 cucharadas de zapallo',
      ],
      steps: [
        'Hierve la yuca hasta que esté completamente suave y retira la fibra central.',
        'Cocina zanahoria y zapallo hasta que estén blandos.',
        'Mezcla con pollo desmenuzado y sirve todo en trozos pequeños y húmedos.',
      ],
      texture:
          'Trozos pequeños, blandos y húmedos; la yuca nunca debe quedar dura o fibrosa.',
      safety:
          'La yuca debe estar bien pelada y completamente cocida. Retira fibras duras y huesos del pollo.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Soft cassava with chicken and vegetables',
      summary:
          'A meal inspired by everyday ingredients from the Ecuadorian Amazon.',
      ingredients: [
        '½ cup peeled cassava pieces',
        '2 tablespoons cooked shredded chicken',
        '2 tablespoons carrot',
        '2 tablespoons pumpkin',
      ],
      steps: [
        'Boil cassava until fully soft and remove the central fiber.',
        'Cook carrot and pumpkin until tender.',
        'Mix with shredded chicken and serve in small moist pieces.',
      ],
      texture:
          'Small, tender, moist pieces; cassava should never remain hard or stringy.',
      safety:
          'Cassava must be peeled and thoroughly cooked. Remove tough fibers and chicken bones.',
    ),
  ),
  EcuadorRecipe(
    id: 'tortilla_maiz_queso_aguacate',
    minAgeMonths: 36,
    maxAgeMonths: 60,
    region: EcuadorRecipeRegion.sierra,
    emoji: '🌽',
    minutes: 20,
    es: EcuadorRecipeCopy(
      title: 'Tortillita de maíz con queso y aguacate',
      summary:
          'Una opción sencilla con maíz, queso fresco y aguacate para compartir en familia.',
      ingredients: [
        '½ taza de harina de maíz precocida',
        '2 cucharadas de queso fresco pasteurizado',
        'Agua tibia',
        'Aguacate maduro',
      ],
      steps: [
        'Mezcla la harina con agua hasta obtener una masa suave.',
        'Incorpora el queso y forma tortillitas pequeñas y delgadas.',
        'Cocina en sartén antiadherente y sirve con aguacate aplastado.',
      ],
      texture:
          'Tortilla tierna, no tostada en exceso, acompañada de aguacate cremoso.',
      safety:
          'Sirve en trozos pequeños y evita dejar la tortilla seca o dura. Usa queso pasteurizado.',
    ),
    en: EcuadorRecipeCopy(
      title: 'Small corn tortilla with cheese and avocado',
      summary:
          'A simple family option with corn, fresh cheese, and avocado.',
      ingredients: [
        '½ cup precooked corn flour',
        '2 tablespoons pasteurized fresh cheese',
        'Warm water',
        'Ripe avocado',
      ],
      steps: [
        'Mix flour with water into a soft dough.',
        'Add cheese and shape small thin tortillas.',
        'Cook in a non-stick pan and serve with mashed avocado.',
      ],
      texture:
          'Tender tortilla, not over-toasted, with creamy avocado.',
      safety:
          'Serve in small pieces and avoid a dry or hard texture. Use pasteurized cheese.',
    ),
  ),
];
