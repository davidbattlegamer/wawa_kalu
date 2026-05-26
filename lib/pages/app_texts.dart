import 'app_config.dart';

class T {
  static String txt(String key) {
    final lang = AppConfig.idioma.value;
    final Map<String, String> selected = lang == 'en' ? _english : _spanish;
    return selected[key] ?? _spanish[key] ?? key;
  }

  static final Map<String, String> _spanish = {
    // GENERAL
    'appName': 'Wawa Kalú',
    'welcome': 'Bienvenido a Wawa Kalú',
    'subtitle': 'Aprende jugando, explorando y creciendo en familia',
    'settingsTitle': 'Configuración',
    'enabled': 'Activado',
    'disabled': 'Desactivado',
    'yes': 'Sí',
    'no': 'No',
    'back': 'Volver',
    'continue': 'Continuar',
    'startApp': 'Comenzar',
    'startingApp': 'Entrando...',
    'close': 'Cerrar',
    'next': 'Siguiente',
    'previous': 'Anterior',

    // CONFIGURACIÓN
    'sounds': 'Sonidos',
    'soundsOn': 'Sonidos activos',
    'soundsOff': 'Sonidos desactivados',
    'language': 'Idioma',
    'spanish': 'Español',
    'english': 'Inglés',
    'vibration': 'Vibración',
    'vibrationOn': 'Vibración activada',
    'vibrationOff': 'Vibración desactivada',
    'appearance': 'Apariencia',
    'themeAutomatic': 'Automático',
    'lightMode': 'Modo claro',
    'darkMode': 'Modo oscuro',
    'settingsNote':
        'Puedes cambiar estas opciones cuando lo necesites desde el engrane.',

    // BIENVENIDA
    'welcomeScreenTitle': 'Bienvenido a Wawa Kalú',
    'welcomeScreenSubtitle':
        'Aprende jugando con actividades, figuras inteligentes y consejos para padres.',
    'welcomeSettingsNote':
        'Puedes cambiar idioma, sonidos, vibración y apariencia desde el engrane.',
    'welcomePill1': 'Interactivo',
    'welcomePill2': 'Infantil',
    'welcomePill3': 'Familiar',
    'welcomeMiniGames': 'Juegos',
    'welcomeMiniCps': 'Figuras',
    'welcomeMiniFood': 'Nutrición',
    'welcomeMiniCare': 'Cuidado',
    'welcomeGamesTitle': 'Juegos educativos',
    'welcomeGamesSubtitle':
        'Actividades sencillas para aprender de forma divertida.',
    'welcomeCpsTitle': 'Figuras inteligentes',
    'welcomeCpsSubtitle':
        'Conecta el ESP32 y detecta figuras mediante sensores.',
    'welcomeNutritionTitle': 'Nutrición infantil',
    'welcomeNutritionSubtitle':
        'Consejos y recetas pensadas para niños pequeños.',
    'welcomeParentsTitle': 'Apoyo para padres',
    'welcomeParentsSubtitle':
        'Ideas para lenguaje, cuidado y entornos protectores.',

    // HOME
    'cps': 'CPS',
    'cpsSubtitle': 'Figuras inteligentes con ESP32',
    'games': 'Juegos',
    'gamesSubtitle': 'Actividades interactivas para niños',
    'nutrition': 'Nutrición',
    'nutritionSubtitle': 'Consejos y recetas infantiles',
    'languageMenu': 'Lenguaje',
    'languageSubtitle': 'Comunicación y estimulación',
    'environment': 'Entornos',
    'environmentSubtitle': 'Cuidado y protección infantil',

    // PÁGINA DE JUEGOS
    'gamesPageTitle': 'Zona de Juegos',
    'gamesPageSubtitle': 'Aprender jugando',
    'gamesPageDescription':
        'Explora actividades creadas para que los niños aprendan con juegos, colores, animales, preguntas y retos sencillos.',
    'selectGame': 'Selecciona un juego',
    'playNow': 'Jugar ahora',
    'availableGames': 'Juegos disponibles',
    'recommendedForKids': 'Recomendado para niños pequeños',
    'gameBenefits': 'Beneficios del juego',
    'gameBenefit1': 'Estimula la atención y la observación.',
    'gameBenefit2': 'Favorece el reconocimiento de sonidos, colores y figuras.',
    'gameBenefit3': 'Promueve el aprendizaje mediante interacción.',
    'gameBenefit4': 'Permite aprender de forma sencilla y entretenida.',

    'patyGameCardTitle': 'Juego de Paty',
    'patyGameCardSubtitle': 'Juego personalizado creado por Paty',
    'patyGameCardDescription':
        'Actividad visual e interactiva para reforzar la atención, la observación y el aprendizaje mediante estímulos sencillos.',

    'andresGameCardTitle': 'Juego de Andrés',
    'andresGameCardSubtitle': 'Trivia creada por Andrés',
    'andresGameCardDescription':
        'Juego tipo trivia para responder preguntas, reconocer elementos y aprender mediante retos interactivos.',

    'davidGameCardTitle': 'Juego David',
    'davidGameCardSubtitle':
        'Juego de colores y animales para niños pequeños',
    'davidGameCardDescription':
        'Juego interactivo donde el niño toca animales, escucha sus sonidos y gana estrellas o medallas según sus aciertos.',

    // JUEGO GENERAL
    'game': 'Juego',
    'gameTitle': 'Juego de figuras',
    'gameSubtitle': 'Toca, observa y aprende',
    'gameDescription':
        'Toca cada figura para reconocer su nombre, color y forma de manera visual e interactiva.',
    'touchFigure': 'Toca una figura para comenzar',
    'correctFigure': 'Seleccionaste:',
    'hits': 'Aciertos',
    'resetGame': 'Reiniciar juego',
    'figureRewardDefault': 'Sigue tocando figuras para ganar premios',
    'figureRewardStar': '¡Ganaste una estrella por tus aciertos!',
    'figureRewardMedal': '¡Excelente! Ganaste una medalla de figuras',
    'figureInstructions':
        'Observa las figuras, toca una y escucha o mira la respuesta en pantalla.',

    // JUEGO DAVID
    'gameDavid': 'Juego David',
    'davidTitle': 'Juego de animales',
    'davidSubtitleSound': 'Toca un animal y escucha su sonido',
    'davidSubtitleNoSound': 'Toca un animal y aprende sin sonido',
    'davidDescription':
        'En este juego el niño puede tocar animales, reconocerlos por su imagen, escuchar sus sonidos y ganar premios por sus aciertos.',
    'davidInstructions':
        'Selecciona un animal para escuchar su sonido y sumar aciertos. Cada 3 animales ganas una estrella y cada 5 una medalla.',
    'davidBenefits':
        'Este juego ayuda a reconocer animales, asociar sonidos, mejorar la atención y motivar el aprendizaje con recompensas.',
    'touchAnimal': 'Toca un animal para jugar',
    'correctAnimal': 'Seleccionaste:',
    'animalSelected': 'Animal seleccionado',
    'animalsAvailable': 'Animales disponibles',
    'listenAnimal': 'Escucha el sonido del animal',
    'keepTouchingAnimals': 'Sigue tocando animales para ganar premios',
    'dog': 'Perro',
    'cat': 'Gato',
    'chick': 'Pollito',
    'cow': 'Vaca',

    // PREMIOS JUEGO DAVID
    'zooRewardsTitle': 'Premios del zoológico',
    'zooRewardDefault': 'Juega con los animales para ganar premios',
    'zooRewardStar': '¡Muy bien! Ganaste una estrella animal',
    'zooRewardMedal': '¡Excelente! Ganaste una medalla animal',
    'zooRewardBoth': '¡Increíble! Ganaste una estrella y una medalla',
    'zooStars': 'Estrellas',
    'zooMedals': 'Medallas',
    'zooNextStar': 'Próxima estrella',
    'zooNextMedal': 'Próxima medalla',
    'zooMissingForStar': 'Faltan',
    'zooAnimalsForStar': 'animales para ganar una estrella',
    'zooMissingForMedal': 'Faltan',
    'zooAnimalsForMedal': 'animales para ganar una medalla',
    'zooStarUnlocked': '¡Estrella desbloqueada!',
    'zooMedalUnlocked': '¡Medalla desbloqueada!',

    // CPS
    'cpsTitle': 'Figuras inteligentes',
    'cpsSubTitle': 'Conecta el ESP32 y detecta las figuras',
    'connectEsp': 'Conecta tu ESP32 para iniciar',
    'connectEspButton': 'Conectar ESP32',
    'espConnected': 'ESP32 conectado correctamente',
    'disconnect': 'Desconectar',
    'searching': 'Buscando...',
    'selectEsp': 'Selecciona tu ESP32',
    'signal': 'Señal',
    'turnOnBluetooth': 'Activa el Bluetooth para continuar',
    'noBleDevices': 'No se encontraron dispositivos BLE',
    'noBleService': 'El dispositivo no tiene el servicio esperado',
    'connectFirst': 'Primero conecta el ESP32',
    'offlineHistory': 'Datos offline',
    'savedRecords': 'Registros guardados',
    'offlineData': 'Datos almacenados cuando no había conexión',
    'updateHistory': 'Actualizar historial',
    'updating': 'Actualizando...',
    'noRecords': 'No hay registros guardados',
    'syncingHistory': 'Sincronizando historial...',
    'noOfflineLogs': 'No hay datos offline guardados',
    'logError': 'Error al leer el historial',
    'quickGuide': 'Guía rápida',
    'guide1': 'Conecta el ESP32 desde el botón verde.',
    'guide2': 'Coloca una figura sobre su espacio correspondiente.',
    'guide3': 'La figura detectada se iluminará en pantalla.',
    'guide4': 'Los avances se reinician cada vez que conectas el ESP32.',
    'hideGuide': 'Ocultar guía',
    'viewGuide': 'Ver guía',
    'prizeGuide':
        'Cada 5 detecciones ganas una estrella y cada 10 detecciones una medalla.',
    'sessionProgress': 'Avances de la sesión',
    'detections': 'Detecciones',
    'activeNow': 'Activas ahora',
    'stars': 'Estrellas',
    'medals': 'Medallas',
    'defaultPrize': 'Sigue detectando figuras para ganar premios',
    'starPrize': '¡Ganaste una estrella!',
    'medalPrize': '¡Ganaste una medalla!',
    'keepPlaying': 'Sigue jugando para ganar recompensas',
    'starsWon': 'Ya ganaste estrellas en esta sesión',
    'medalsWon': 'Ya ganaste medallas en esta sesión',
    'circle': 'Círculo',
    'square': 'Cuadrado',
    'triangle': 'Triángulo',
    'star': 'Estrella',

    // NUTRICIÓN
    'nutritionChildTitle': 'Nutrición infantil',
    'nutritionChildSubtitle': 'Consejos para niños de 0 a 3 años',
    'touchSectionRecommendations':
        'Toca una sección para ver recomendaciones',
    'nutritionFoodsTitle': 'Alimentos',
    'nutritionFoodsSubtitle': 'Ideas saludables y fáciles',
    'nutritionFoodsTip1':
        'Ofrece alimentos suaves, variados y adecuados para la edad.',
    'nutritionFoodsTip2':
        'Incluye frutas, verduras, cereales, proteínas y grasas saludables.',
    'nutritionFoodsTip3':
        'Evita azúcar añadida, gaseosas, exceso de sal y ultraprocesados.',
    'nutritionFoodsTip4':
        'Introduce alimentos nuevos poco a poco y observa posibles alergias.',
    'nutritionFoodsTip5':
        'Acompaña las comidas con paciencia, sin presionar al niño.',
    'nutritionRoutineTitle': 'Rutina',
    'nutritionRoutineSubtitle': 'Horarios y hábitos',
    'nutritionRoutineTip1':
        'Mantén horarios similares para desayuno, almuerzo, merienda y cena.',
    'nutritionRoutineTip2': 'Crea un ambiente tranquilo durante la comida.',
    'nutritionRoutineTip3': 'Evita pantallas mientras el niño se alimenta.',
    'nutritionRoutineTip4':
        'Permite que el niño explore texturas con supervisión.',
    'nutritionRoutineTip5': 'Respeta señales de hambre y saciedad.',
    'nutritionHydrationTitle': 'Hidratación',
    'nutritionHydrationSubtitle': 'Agua y bebidas adecuadas',
    'nutritionHydrationTip1':
        'Ofrece agua simple durante el día según la edad.',
    'nutritionHydrationTip2':
        'Evita jugos artificiales, gaseosas y bebidas azucaradas.',
    'nutritionHydrationTip3':
        'En días calurosos, aumenta la atención a la hidratación.',
    'nutritionHydrationTip4':
        'La leche materna o fórmula sigue siendo importante en etapas tempranas.',
    'nutritionHydrationTip5':
        'Consulta al pediatra si hay diarrea, fiebre o rechazo de líquidos.',
    'nutritionSignalsTitle': 'Señales del niño',
    'nutritionSignalsSubtitle': 'Observar antes de insistir',
    'nutritionSignalsTip1':
        'Si gira la cabeza o cierra la boca, puede estar satisfecho.',
    'nutritionSignalsTip2':
        'Si mira la comida o abre la boca, puede tener interés.',
    'nutritionSignalsTip3': 'No obligues a terminar el plato.',
    'nutritionSignalsTip4':
        'Observa cambios de apetito durante enfermedad o dentición.',
    'nutritionSignalsTip5': 'El apetito puede variar de un día a otro.',
    'nutritionSafetyTitle': 'Seguridad',
    'nutritionSafetySubtitle': 'Evitar riesgos al comer',
    'nutritionSafetyTip1': 'Supervisa siempre al niño mientras come.',
    'nutritionSafetyTip2':
        'Evita alimentos duros, redondos o pequeños que puedan causar atragantamiento.',
    'nutritionSafetyTip3': 'Corta los alimentos en tamaños seguros.',
    'nutritionSafetyTip4': 'Sienta al niño correctamente durante la comida.',
    'nutritionSafetyTip5': 'Ante alergias o dudas, consulta al pediatra.',
    'nutritionParentsTitle': 'Para padres',
    'nutritionParentsSubtitle': 'Acompañamiento positivo',
    'nutritionParentsTip1':
        'El ejemplo de la familia influye en los hábitos del niño.',
    'nutritionParentsTip2': 'Evita usar dulces como premio o castigo.',
    'nutritionParentsTip3': 'Celebra pequeños avances sin presionar.',
    'nutritionParentsTip4':
        'Planifica comidas sencillas con ingredientes disponibles.',
    'nutritionParentsTip5':
        'Consulta a un profesional si hay bajo peso, rechazo constante o alergias.',
    'nutritionFinalNote':
        'Estas recomendaciones son generales y no reemplazan la orientación del pediatra. La alimentación debe ajustarse a la edad, salud, desarrollo, alergias y necesidades de cada niño.',

    // RECETAS
    'recipesForChildren': 'Recetas para niños',
    'recipesShortDesc':
        'Encuentra ideas nutritivas y fáciles para diferentes momentos del día.',
    'viewRecipes': 'Ver recetas',
    'recipesAppBar': 'Recetas',
    'recipesHeaderTitle': 'Recetas infantiles',
    'recipesHeaderSubtitle': 'Ideas suaves, nutritivas y fáciles',
    'recipesHeaderNote': 'Pensadas como apoyo general para niños pequeños',
    'ingredients': 'Ingredientes',
    'preparation': 'Preparación',
    'recipeFinalNote':
        'Ajusta cada receta según la edad, textura tolerada, alergias y recomendación del pediatra.',

    'recipe1Title': 'Puré suave de zapallo y pollo',
    'recipe1Age': 'Desde 8 meses',
    'recipe1Moment': 'Almuerzo',
    'recipe1Desc':
        'Una receta suave con proteína y vegetales para una comida completa.',
    'recipe1Ing1': 'Zapallo cocido',
    'recipe1Ing2': 'Pollo cocido y desmenuzado',
    'recipe1Ing3': 'Un poco de arroz bien cocido',
    'recipe1Ing4': 'Agua tibia o caldo natural sin sal',
    'recipe1Step1': 'Cocina todos los ingredientes hasta que estén suaves.',
    'recipe1Step2': 'Tritura o licúa según la textura que tolere el niño.',
    'recipe1Step3':
        'Agrega líquido poco a poco hasta lograr una textura cremosa.',
    'recipe1Step4': 'Sirve tibio y en porciones pequeñas.',
    'recipe1Rec':
        'Es recomendable al almuerzo, cuando el niño está más activo y receptivo.',

    'recipe2Title': 'Avena cremosa con banana',
    'recipe2Age': 'Desde 7 meses',
    'recipe2Moment': 'Desayuno',
    'recipe2Desc': 'Una opción suave y energética para iniciar el día.',
    'recipe2Ing1': 'Avena cocida',
    'recipe2Ing2': 'Banana madura aplastada',
    'recipe2Ing3': 'Leche materna, fórmula o agua',
    'recipe2Ing4': 'Canela mínima opcional',
    'recipe2Step1': 'Cocina la avena hasta que quede muy suave.',
    'recipe2Step2': 'Agrega la banana aplastada.',
    'recipe2Step3': 'Mezcla hasta obtener una textura cremosa.',
    'recipe2Step4': 'Deja enfriar antes de servir.',
    'recipe2Rec': 'Ideal para desayuno o media mañana, sin añadir azúcar.',

    'recipe3Title': 'Tortillita suave de huevo y verduras',
    'recipe3Age': 'Desde 12 meses',
    'recipe3Moment': 'Cena o almuerzo',
    'recipe3Desc':
        'Una preparación blanda para practicar masticación con supervisión.',
    'recipe3Ing1': 'Huevo bien cocido',
    'recipe3Ing2': 'Zanahoria rallada cocida',
    'recipe3Ing3': 'Espinaca picada cocida',
    'recipe3Ing4': 'Aceite vegetal en pequeña cantidad',
    'recipe3Step1': 'Bate el huevo y mezcla las verduras cocidas.',
    'recipe3Step2':
        'Cocina a fuego bajo hasta que el huevo esté completamente cocido.',
    'recipe3Step3': 'Corta en trozos pequeños y blandos.',
    'recipe3Step4': 'Sirve tibio y supervisa mientras come.',
    'recipe3Rec': 'Úsala solo si el niño ya tolera huevo y verduras.',

    'recipe4Title': 'Arroz suave con lenteja',
    'recipe4Age': 'Desde 10 meses',
    'recipe4Moment': 'Almuerzo',
    'recipe4Desc': 'Combina cereal y legumbre para una comida nutritiva.',
    'recipe4Ing1': 'Arroz bien cocido',
    'recipe4Ing2': 'Lentejas cocidas y suaves',
    'recipe4Ing3': 'Zanahoria cocida',
    'recipe4Ing4': 'Agua o caldo natural sin sal',
    'recipe4Step1': 'Cocina las lentejas hasta que estén muy blandas.',
    'recipe4Step2': 'Mezcla con arroz y zanahoria cocida.',
    'recipe4Step3': 'Aplasta ligeramente si el niño aún no mastica bien.',
    'recipe4Step4': 'Sirve en porciones pequeñas.',
    'recipe4Rec': 'Puede darse al almuerzo, observando tolerancia digestiva.',

    'recipe5Title': 'Yogur natural con fruta',
    'recipe5Age': 'Desde 12 meses',
    'recipe5Moment': 'Merienda',
    'recipe5Desc': 'Una merienda fresca y sencilla sin azúcar añadida.',
    'recipe5Ing1': 'Yogur natural sin azúcar',
    'recipe5Ing2': 'Fruta madura picada o aplastada',
    'recipe5Ing3': 'Avena suave opcional',
    'recipe5Step1': 'Lava y prepara la fruta.',
    'recipe5Step2': 'Mezcla con yogur natural.',
    'recipe5Step3': 'Aplasta si se requiere una textura más suave.',
    'recipe5Step4': 'Sirve frío, pero no helado.',
    'recipe5Rec': 'Ideal para merienda, siempre que el niño tolere lácteos.',

    // LENGUAJE
    'languageTitle': 'Lenguaje y comunicación',
    'languageHeaderSubtitle': 'Actividades sencillas para estimular el habla',
    'touchActivityRecommendation':
        'Toca una actividad para ver cómo hacerla en casa',
    'selectActivity': 'Selecciona una actividad',
    'languageDefaultRec':
        'Elige una actividad para recibir una recomendación práctica.',
    'languageDefaultHome':
        'Puedes iniciar con una conversación corta usando objetos cercanos.',
    'languageDefaultParent':
        'Hablar con calma y responder a los sonidos del niño ayuda a fortalecer su comunicación.',
    'homeActivity': 'Actividad en casa',
    'noActivityReviewed': 'Aún no revisas actividades',
    'activitiesReviewed': 'Actividades revisadas',
    'languageFinalNote':
        'Cada niño desarrolla el lenguaje a su ritmo. Si existen dudas sobre audición, comprensión o habla, consulta con un profesional.',

    'nameObjectsTitle': 'Nombrar objetos',
    'nameObjectsDesc': 'Usa cosas cercanas y nómbralas con claridad.',
    'nameObjectsRec':
        'Señala un objeto, di su nombre y espera una reacción del niño.',
    'nameObjectsHome':
        'Durante el juego, nombra colores, formas, personas o acciones.',
    'nameObjectsParent': 'Repite las palabras sin corregir de forma brusca.',

    'readImagesTitle': 'Leer imágenes',
    'readImagesDesc': 'Usa cuentos, fotos o láminas.',
    'readImagesRec':
        'Describe lo que ves: colores, personas, objetos o acciones.',
    'readImagesHome':
        'Use cualquier cuento, lámina, foto o imagen. No es necesario que tenga cosas específicas; puede describir colores, personas, objetos o acciones.',
    'readImagesParent': 'Hacer preguntas simples ayuda a que el niño participe.',

    'singMoveTitle': 'Cantar y moverse',
    'singMoveDesc': 'Une música, gestos y palabras.',
    'singMoveRec':
        'Canta canciones cortas y acompáñalas con movimientos de manos.',
    'singMoveHome': 'Usa canciones conocidas y repite frases fáciles.',
    'singMoveParent': 'La repetición favorece memoria, ritmo y lenguaje.',

    'talkTitle': 'Conversar',
    'talkDesc': 'Habla durante actividades diarias.',
    'talkRec':
        'Describe lo que hacen mientras comen, juegan o se visten.',
    'talkHome':
        'Usa frases cortas como: ahora lavamos manos, ahora guardamos juguetes.',
    'talkParent':
        'Conversar no necesita materiales, solo atención y paciencia.',

    'imitateSoundsTitle': 'Imitar sonidos',
    'imitateSoundsDesc': 'Juega con sonidos de objetos o animales.',
    'imitateSoundsRec':
        'Haz un sonido simple y espera que el niño intente repetirlo.',
    'imitateSoundsHome':
        'Pueden imitar sonidos de carros, agua, animales o juguetes.',
    'imitateSoundsParent': 'Celebra cualquier intento de comunicación.',

    // ENTORNOS
    'environmentTitle': 'Entornos protectores',
    'environmentHeaderSubtitle':
        'Ideas para cuidar, acompañar y prevenir riesgos',
    'touchEnvironmentActions':
        'Toca una sección para ver acciones recomendadas',
    'environmentFinalNote':
        'Un entorno protector combina seguridad física, afecto, rutinas y supervisión constante.',

    'safeSpacesTitle': 'Espacios seguros',
    'safeSpacesSubtitle': 'Casa organizada y libre de riesgos',
    'safeSpacesDesc':
        'Un espacio seguro permite que el niño explore sin exponerse a peligros innecesarios.',
    'safeSpacesAlert':
        'Revisa enchufes, esquinas, objetos pequeños, cables y productos de limpieza.',
    'safeSpacesA1': 'Mantén objetos pequeños fuera del alcance.',
    'safeSpacesA2': 'Guarda medicinas y químicos en lugares altos o cerrados.',
    'safeSpacesA3': 'Usa protectores en enchufes si es necesario.',
    'safeSpacesA4': 'Asegura muebles que puedan caerse.',

    'activeSupervisionTitle': 'Supervisión activa',
    'activeSupervisionSubtitle': 'Acompañar sin distraerse',
    'activeSupervisionDesc':
        'Supervisar significa observar, anticiparse y estar presente durante el juego.',
    'activeSupervisionAlert':
        'Evita dejar al niño solo cerca de agua, escaleras, cocina o calles.',
    'activeSupervisionA1': 'Observa mientras juega o explora.',
    'activeSupervisionA2': 'Mantén contacto visual frecuente.',
    'activeSupervisionA3': 'Evita distracciones largas con el celular.',
    'activeSupervisionA4': 'Acompaña especialmente en espacios nuevos.',

    'protectiveRoutinesTitle': 'Rutinas protectoras',
    'protectiveRoutinesSubtitle': 'Hábitos que dan seguridad',
    'protectiveRoutinesDesc':
        'Las rutinas ayudan a que el niño anticipe lo que viene y se sienta seguro.',
    'protectiveRoutinesAlert':
        'Los cambios bruscos pueden generar irritabilidad o inseguridad.',
    'protectiveRoutinesA1': 'Mantén horarios similares para dormir y comer.',
    'protectiveRoutinesA2': 'Anticipa cambios con frases simples.',
    'protectiveRoutinesA3': 'Crea rituales de sueño tranquilos.',
    'protectiveRoutinesA4': 'Evita pantallas antes de dormir.',

    'affectionTitle': 'Afecto y vínculo',
    'affectionSubtitle': 'Cuidado emocional diario',
    'affectionDesc':
        'El afecto ayuda al desarrollo emocional y fortalece la confianza.',
    'affectionAlert':
        'Gritos, castigos físicos o humillaciones afectan el bienestar del niño.',
    'affectionA1': 'Responde con calma al llanto.',
    'affectionA2': 'Abraza, mira y habla con cariño.',
    'affectionA3': 'Valida emociones con palabras simples.',
    'affectionA4': 'Celebra pequeños logros.',

    'healthAlertTitle': 'Señales de alerta',
    'healthAlertSubtitle': 'Cuándo buscar ayuda',
    'healthAlertDesc':
        'Algunas señales requieren atención de un profesional de salud.',
    'healthAlertAlert':
        'Busca ayuda si hay fiebre persistente, dificultad para respirar, convulsiones, deshidratación o cambios fuertes de conducta.',
    'healthAlertA1': 'Observa fiebre, sueño excesivo o rechazo de alimentos.',
    'healthAlertA2': 'Consulta si hay golpes fuertes o caídas.',
    'healthAlertA3': 'No automediques al niño.',
    'healthAlertA4': 'Mantén controles pediátricos al día.',
  };

  static final Map<String, String> _english = {
    // GENERAL
    'appName': 'Wawa Kalú',
    'welcome': 'Welcome to Wawa Kalú',
    'subtitle': 'Learn by playing, exploring, and growing as a family',
    'settingsTitle': 'Settings',
    'enabled': 'Enabled',
    'disabled': 'Disabled',
    'yes': 'Yes',
    'no': 'No',
    'back': 'Back',
    'continue': 'Continue',
    'startApp': 'Start',
    'startingApp': 'Starting...',
    'close': 'Close',
    'next': 'Next',
    'previous': 'Previous',

    // SETTINGS
    'sounds': 'Sounds',
    'soundsOn': 'Sounds on',
    'soundsOff': 'Sounds off',
    'language': 'Language',
    'spanish': 'Spanish',
    'english': 'English',
    'vibration': 'Vibration',
    'vibrationOn': 'Vibration on',
    'vibrationOff': 'Vibration off',
    'appearance': 'Appearance',
    'themeAutomatic': 'Automatic',
    'lightMode': 'Light mode',
    'darkMode': 'Dark mode',
    'settingsNote':
        'You can change these options whenever you need from the gear icon.',

    // WELCOME
    'welcomeScreenTitle': 'Welcome to Wawa Kalú',
    'welcomeScreenSubtitle':
        'Learn through games, smart shapes, and helpful tips for parents.',
    'welcomeSettingsNote':
        'You can change language, sounds, vibration, and appearance from the gear icon.',
    'welcomePill1': 'Interactive',
    'welcomePill2': 'Child-friendly',
    'welcomePill3': 'Family',
    'welcomeMiniGames': 'Games',
    'welcomeMiniCps': 'Shapes',
    'welcomeMiniFood': 'Nutrition',
    'welcomeMiniCare': 'Care',
    'welcomeGamesTitle': 'Educational games',
    'welcomeGamesSubtitle': 'Simple activities to learn in a fun way.',
    'welcomeCpsTitle': 'Smart shapes',
    'welcomeCpsSubtitle': 'Connect the ESP32 and detect shapes using sensors.',
    'welcomeNutritionTitle': 'Child nutrition',
    'welcomeNutritionSubtitle': 'Tips and recipes designed for young children.',
    'welcomeParentsTitle': 'Support for parents',
    'welcomeParentsSubtitle':
        'Ideas for language, care, and protective environments.',

    // HOME
    'cps': 'CPS',
    'cpsSubtitle': 'Smart shapes with ESP32',
    'games': 'Games',
    'gamesSubtitle': 'Interactive activities for children',
    'nutrition': 'Nutrition',
    'nutritionSubtitle': 'Child nutrition tips and recipes',
    'languageMenu': 'Language',
    'languageSubtitle': 'Communication and stimulation',
    'environment': 'Environments',
    'environmentSubtitle': 'Child care and protection',

    // GAMES PAGE
    'gamesPageTitle': 'Game Zone',
    'gamesPageSubtitle': 'Learning through play',
    'gamesPageDescription':
        'Explore activities created so children can learn with games, colors, animals, questions, and simple challenges.',
    'selectGame': 'Select a game',
    'playNow': 'Play now',
    'availableGames': 'Available games',
    'recommendedForKids': 'Recommended for young children',
    'gameBenefits': 'Game benefits',
    'gameBenefit1': 'Stimulates attention and observation.',
    'gameBenefit2': 'Supports recognition of sounds, colors, and shapes.',
    'gameBenefit3': 'Promotes learning through interaction.',
    'gameBenefit4': 'Allows learning in a simple and entertaining way.',

    'patyGameCardTitle': 'Paty Game',
    'patyGameCardSubtitle': 'Custom game created by Paty',
    'patyGameCardDescription':
        'Visual and interactive activity to strengthen attention, observation, and learning through simple stimuli.',

    'andresGameCardTitle': 'Andrés Game',
    'andresGameCardSubtitle': 'Trivia created by Andrés',
    'andresGameCardDescription':
        'Trivia-style game to answer questions, recognize elements, and learn through interactive challenges.',

    'davidGameCardTitle': 'David Game',
    'davidGameCardSubtitle':
        'Color and animal game for young children',
    'davidGameCardDescription':
        'Interactive game where the child taps animals, listens to their sounds, and earns stars or medals based on correct touches.',

    // GENERAL GAME
    'game': 'Game',
    'gameTitle': 'Shape game',
    'gameSubtitle': 'Tap, observe, and learn',
    'gameDescription':
        'Tap each shape to recognize its name, color, and form in a visual and interactive way.',
    'touchFigure': 'Tap a shape to start',
    'correctFigure': 'You selected:',
    'hits': 'Hits',
    'resetGame': 'Reset game',
    'figureRewardDefault': 'Keep tapping shapes to win rewards',
    'figureRewardStar': 'You won a star for your hits!',
    'figureRewardMedal': 'Excellent! You won a shape medal',
    'figureInstructions':
        'Look at the shapes, tap one, and listen or watch the response on screen.',

    // DAVID GAME
    'gameDavid': 'David Game',
    'davidTitle': 'Animal game',
    'davidSubtitleSound': 'Tap an animal and listen to its sound',
    'davidSubtitleNoSound': 'Tap an animal and learn without sound',
    'davidDescription':
        'In this game, children can tap animals, recognize them by image, listen to their sounds, and earn rewards for their hits.',
    'davidInstructions':
        'Select an animal to hear its sound and add hits. Every 3 animals earns a star and every 5 earns a medal.',
    'davidBenefits':
        'This game helps recognize animals, associate sounds, improve attention, and encourage learning with rewards.',
    'touchAnimal': 'Tap an animal to play',
    'correctAnimal': 'You selected:',
    'animalSelected': 'Selected animal',
    'animalsAvailable': 'Available animals',
    'listenAnimal': 'Listen to the animal sound',
    'keepTouchingAnimals': 'Keep tapping animals to win rewards',
    'dog': 'Dog',
    'cat': 'Cat',
    'chick': 'Chick',
    'cow': 'Cow',

    // DAVID GAME REWARDS
    'zooRewardsTitle': 'Zoo rewards',
    'zooRewardDefault': 'Play with the animals to win rewards',
    'zooRewardStar': 'Great job! You won an animal star',
    'zooRewardMedal': 'Excellent! You won an animal medal',
    'zooRewardBoth': 'Amazing! You won a star and a medal',
    'zooStars': 'Stars',
    'zooMedals': 'Medals',
    'zooNextStar': 'Next star',
    'zooNextMedal': 'Next medal',
    'zooMissingForStar': 'Missing',
    'zooAnimalsForStar': 'animals to win a star',
    'zooMissingForMedal': 'Missing',
    'zooAnimalsForMedal': 'animals to win a medal',
    'zooStarUnlocked': 'Star unlocked!',
    'zooMedalUnlocked': 'Medal unlocked!',

    // CPS
    'cpsTitle': 'Smart shapes',
    'cpsSubTitle': 'Connect the ESP32 and detect the shapes',
    'connectEsp': 'Connect your ESP32 to start',
    'connectEspButton': 'Connect ESP32',
    'espConnected': 'ESP32 connected successfully',
    'disconnect': 'Disconnect',
    'searching': 'Searching...',
    'selectEsp': 'Select your ESP32',
    'signal': 'Signal',
    'turnOnBluetooth': 'Turn on Bluetooth to continue',
    'noBleDevices': 'No BLE devices found',
    'noBleService': 'The device does not have the expected service',
    'connectFirst': 'Connect the ESP32 first',
    'offlineHistory': 'Offline data',
    'savedRecords': 'Saved records',
    'offlineData': 'Data stored when there was no connection',
    'updateHistory': 'Update history',
    'updating': 'Updating...',
    'noRecords': 'No saved records',
    'syncingHistory': 'Syncing history...',
    'noOfflineLogs': 'No offline data saved',
    'logError': 'Error reading history',
    'quickGuide': 'Quick guide',
    'guide1': 'Connect the ESP32 using the green button.',
    'guide2': 'Place a shape on its matching space.',
    'guide3': 'The detected shape will light up on the screen.',
    'guide4': 'Progress resets every time you connect the ESP32.',
    'hideGuide': 'Hide guide',
    'viewGuide': 'View guide',
    'prizeGuide':
        'Every 5 detections you win a star, and every 10 detections you win a medal.',
    'sessionProgress': 'Session progress',
    'detections': 'Detections',
    'activeNow': 'Active now',
    'stars': 'Stars',
    'medals': 'Medals',
    'defaultPrize': 'Keep detecting shapes to win rewards',
    'starPrize': 'You won a star!',
    'medalPrize': 'You won a medal!',
    'keepPlaying': 'Keep playing to win rewards',
    'starsWon': 'You already won stars this session',
    'medalsWon': 'You already won medals this session',
    'circle': 'Circle',
    'square': 'Square',
    'triangle': 'Triangle',
    'star': 'Star',

    // NUTRITION
    'nutritionChildTitle': 'Child nutrition',
    'nutritionChildSubtitle': 'Tips for children from 0 to 3 years old',
    'touchSectionRecommendations': 'Tap a section to see recommendations',
    'nutritionFoodsTitle': 'Foods',
    'nutritionFoodsSubtitle': 'Healthy and simple ideas',
    'nutritionFoodsTip1':
        'Offer soft, varied foods appropriate for the child’s age.',
    'nutritionFoodsTip2':
        'Include fruits, vegetables, grains, proteins, and healthy fats.',
    'nutritionFoodsTip3':
        'Avoid added sugar, soda, excess salt, and ultra-processed foods.',
    'nutritionFoodsTip4':
        'Introduce new foods gradually and watch for possible allergies.',
    'nutritionFoodsTip5':
        'Support meals with patience, without pressuring the child.',
    'nutritionRoutineTitle': 'Routine',
    'nutritionRoutineSubtitle': 'Schedules and habits',
    'nutritionRoutineTip1':
        'Keep similar times for breakfast, lunch, snack, and dinner.',
    'nutritionRoutineTip2': 'Create a calm environment during meals.',
    'nutritionRoutineTip3': 'Avoid screens while the child is eating.',
    'nutritionRoutineTip4':
        'Allow the child to explore textures with supervision.',
    'nutritionRoutineTip5': 'Respect hunger and fullness cues.',
    'nutritionHydrationTitle': 'Hydration',
    'nutritionHydrationSubtitle': 'Water and suitable drinks',
    'nutritionHydrationTip1':
        'Offer plain water during the day according to age.',
    'nutritionHydrationTip2':
        'Avoid artificial juices, soda, and sugary drinks.',
    'nutritionHydrationTip3':
        'On hot days, pay more attention to hydration.',
    'nutritionHydrationTip4':
        'Breast milk or formula remains important in early stages.',
    'nutritionHydrationTip5':
        'Consult the pediatrician if there is diarrhea, fever, or refusal of fluids.',
    'nutritionSignalsTitle': 'Child signals',
    'nutritionSignalsSubtitle': 'Observe before insisting',
    'nutritionSignalsTip1':
        'Turning the head or closing the mouth may mean the child is full.',
    'nutritionSignalsTip2':
        'Looking at food or opening the mouth may show interest.',
    'nutritionSignalsTip3': 'Do not force the child to finish the plate.',
    'nutritionSignalsTip4':
        'Watch appetite changes during illness or teething.',
    'nutritionSignalsTip5': 'Appetite may vary from day to day.',
    'nutritionSafetyTitle': 'Safety',
    'nutritionSafetySubtitle': 'Avoid risks while eating',
    'nutritionSafetyTip1': 'Always supervise the child while eating.',
    'nutritionSafetyTip2':
        'Avoid hard, round, or small foods that may cause choking.',
    'nutritionSafetyTip3': 'Cut food into safe sizes.',
    'nutritionSafetyTip4': 'Seat the child correctly during meals.',
    'nutritionSafetyTip5':
        'For allergies or concerns, consult the pediatrician.',
    'nutritionParentsTitle': 'For parents',
    'nutritionParentsSubtitle': 'Positive support',
    'nutritionParentsTip1': 'Family example influences the child’s habits.',
    'nutritionParentsTip2': 'Avoid using sweets as rewards or punishment.',
    'nutritionParentsTip3': 'Celebrate small progress without pressure.',
    'nutritionParentsTip4':
        'Plan simple meals with available ingredients.',
    'nutritionParentsTip5':
        'Consult a professional if there is low weight, constant refusal, or allergies.',
    'nutritionFinalNote':
        'These recommendations are general and do not replace pediatric guidance. Feeding should be adapted to each child’s age, health, development, allergies, and needs.',

    // RECIPES
    'recipesForChildren': 'Recipes for children',
    'recipesShortDesc':
        'Find nutritious and easy ideas for different moments of the day.',
    'viewRecipes': 'View recipes',
    'recipesAppBar': 'Recipes',
    'recipesHeaderTitle': 'Child recipes',
    'recipesHeaderSubtitle': 'Soft, nutritious, and easy ideas',
    'recipesHeaderNote': 'Designed as general support for young children',
    'ingredients': 'Ingredients',
    'preparation': 'Preparation',
    'recipeFinalNote':
        'Adjust each recipe according to age, tolerated texture, allergies, and pediatric guidance.',

    'recipe1Title': 'Soft pumpkin and chicken purée',
    'recipe1Age': 'From 8 months',
    'recipe1Moment': 'Lunch',
    'recipe1Desc':
        'A soft recipe with protein and vegetables for a complete meal.',
    'recipe1Ing1': 'Cooked pumpkin',
    'recipe1Ing2': 'Cooked shredded chicken',
    'recipe1Ing3': 'A little well-cooked rice',
    'recipe1Ing4': 'Warm water or natural broth without salt',
    'recipe1Step1': 'Cook all ingredients until soft.',
    'recipe1Step2': 'Mash or blend according to the child’s tolerated texture.',
    'recipe1Step3': 'Add liquid little by little until creamy.',
    'recipe1Step4': 'Serve warm in small portions.',
    'recipe1Rec':
        'Recommended for lunch, when the child is more active and receptive.',

    'recipe2Title': 'Creamy oatmeal with banana',
    'recipe2Age': 'From 7 months',
    'recipe2Moment': 'Breakfast',
    'recipe2Desc': 'A soft and energetic option to start the day.',
    'recipe2Ing1': 'Cooked oatmeal',
    'recipe2Ing2': 'Mashed ripe banana',
    'recipe2Ing3': 'Breast milk, formula, or water',
    'recipe2Ing4': 'A tiny amount of cinnamon, optional',
    'recipe2Step1': 'Cook the oatmeal until very soft.',
    'recipe2Step2': 'Add mashed banana.',
    'recipe2Step3': 'Mix until creamy.',
    'recipe2Step4': 'Let it cool before serving.',
    'recipe2Rec': 'Ideal for breakfast or mid-morning, without added sugar.',

    'recipe3Title': 'Soft egg and vegetable omelet',
    'recipe3Age': 'From 12 months',
    'recipe3Moment': 'Dinner or lunch',
    'recipe3Desc':
        'A soft preparation to practice chewing with supervision.',
    'recipe3Ing1': 'Well-cooked egg',
    'recipe3Ing2': 'Cooked grated carrot',
    'recipe3Ing3': 'Cooked chopped spinach',
    'recipe3Ing4': 'Small amount of vegetable oil',
    'recipe3Step1': 'Beat the egg and mix with cooked vegetables.',
    'recipe3Step2': 'Cook on low heat until the egg is fully cooked.',
    'recipe3Step3': 'Cut into small soft pieces.',
    'recipe3Step4': 'Serve warm and supervise while eating.',
    'recipe3Rec': 'Use only if the child already tolerates egg and vegetables.',

    'recipe4Title': 'Soft rice with lentils',
    'recipe4Age': 'From 10 months',
    'recipe4Moment': 'Lunch',
    'recipe4Desc': 'Combines grain and legume for a nutritious meal.',
    'recipe4Ing1': 'Well-cooked rice',
    'recipe4Ing2': 'Cooked soft lentils',
    'recipe4Ing3': 'Cooked carrot',
    'recipe4Ing4': 'Water or natural broth without salt',
    'recipe4Step1': 'Cook the lentils until very soft.',
    'recipe4Step2': 'Mix with rice and cooked carrot.',
    'recipe4Step3': 'Mash slightly if the child does not chew well yet.',
    'recipe4Step4': 'Serve in small portions.',
    'recipe4Rec': 'Can be given at lunch while observing digestive tolerance.',

    'recipe5Title': 'Natural yogurt with fruit',
    'recipe5Age': 'From 12 months',
    'recipe5Moment': 'Snack',
    'recipe5Desc': 'A fresh and simple snack without added sugar.',
    'recipe5Ing1': 'Natural unsweetened yogurt',
    'recipe5Ing2': 'Ripe fruit, chopped or mashed',
    'recipe5Ing3': 'Soft oatmeal, optional',
    'recipe5Step1': 'Wash and prepare the fruit.',
    'recipe5Step2': 'Mix with natural yogurt.',
    'recipe5Step3': 'Mash if a softer texture is needed.',
    'recipe5Step4': 'Serve cold, but not frozen.',
    'recipe5Rec': 'Ideal as a snack if the child tolerates dairy.',

    // LANGUAGE
    'languageTitle': 'Language and communication',
    'languageHeaderSubtitle': 'Simple activities to stimulate speech',
    'touchActivityRecommendation':
        'Tap an activity to see how to do it at home',
    'selectActivity': 'Select an activity',
    'languageDefaultRec':
        'Choose an activity to receive a practical recommendation.',
    'languageDefaultHome':
        'You can start with a short conversation using nearby objects.',
    'languageDefaultParent':
        'Speaking calmly and responding to the child’s sounds helps strengthen communication.',
    'homeActivity': 'Home activity',
    'noActivityReviewed': 'No activities reviewed yet',
    'activitiesReviewed': 'Activities reviewed',
    'languageFinalNote':
        'Each child develops language at their own pace. If there are concerns about hearing, understanding, or speech, consult a professional.',

    'nameObjectsTitle': 'Name objects',
    'nameObjectsDesc': 'Use nearby things and name them clearly.',
    'nameObjectsRec':
        'Point to an object, say its name, and wait for the child’s reaction.',
    'nameObjectsHome': 'During play, name colors, shapes, people, or actions.',
    'nameObjectsParent': 'Repeat words without correcting harshly.',

    'readImagesTitle': 'Read images',
    'readImagesDesc': 'Use stories, photos, or pictures.',
    'readImagesRec':
        'Describe what you see: colors, people, objects, or actions.',
    'readImagesHome':
        'Use any story, picture, photo, or image. It does not need to contain specific things; you can describe colors, people, objects, or actions.',
    'readImagesParent': 'Simple questions help the child participate.',

    'singMoveTitle': 'Sing and move',
    'singMoveDesc': 'Combine music, gestures, and words.',
    'singMoveRec': 'Sing short songs and accompany them with hand movements.',
    'singMoveHome': 'Use familiar songs and repeat easy phrases.',
    'singMoveParent': 'Repetition supports memory, rhythm, and language.',

    'talkTitle': 'Talk',
    'talkDesc': 'Talk during daily activities.',
    'talkRec':
        'Describe what you are doing while eating, playing, or getting dressed.',
    'talkHome':
        'Use short phrases like: now we wash hands, now we put toys away.',
    'talkParent':
        'Talking does not require materials, only attention and patience.',

    'imitateSoundsTitle': 'Imitate sounds',
    'imitateSoundsDesc': 'Play with sounds from objects or animals.',
    'imitateSoundsRec':
        'Make a simple sound and wait for the child to try repeating it.',
    'imitateSoundsHome':
        'You can imitate sounds of cars, water, animals, or toys.',
    'imitateSoundsParent': 'Celebrate any attempt to communicate.',

    // ENVIRONMENT
    'environmentTitle': 'Protective environments',
    'environmentHeaderSubtitle': 'Ideas to care, support, and prevent risks',
    'touchEnvironmentActions': 'Tap a section to see recommended actions',
    'environmentFinalNote':
        'A protective environment combines physical safety, affection, routines, and constant supervision.',

    'safeSpacesTitle': 'Safe spaces',
    'safeSpacesSubtitle': 'Organized home free of risks',
    'safeSpacesDesc':
        'A safe space allows the child to explore without unnecessary danger.',
    'safeSpacesAlert':
        'Check outlets, corners, small objects, cables, and cleaning products.',
    'safeSpacesA1': 'Keep small objects out of reach.',
    'safeSpacesA2': 'Store medicine and chemicals in high or locked places.',
    'safeSpacesA3': 'Use outlet covers if necessary.',
    'safeSpacesA4': 'Secure furniture that could fall.',

    'activeSupervisionTitle': 'Active supervision',
    'activeSupervisionSubtitle': 'Support without distractions',
    'activeSupervisionDesc':
        'Supervision means watching, anticipating, and being present during play.',
    'activeSupervisionAlert':
        'Avoid leaving the child alone near water, stairs, kitchen, or streets.',
    'activeSupervisionA1': 'Observe while the child plays or explores.',
    'activeSupervisionA2': 'Keep frequent eye contact.',
    'activeSupervisionA3': 'Avoid long distractions with your phone.',
    'activeSupervisionA4': 'Support especially in new spaces.',

    'protectiveRoutinesTitle': 'Protective routines',
    'protectiveRoutinesSubtitle': 'Habits that provide safety',
    'protectiveRoutinesDesc':
        'Routines help children anticipate what comes next and feel safe.',
    'protectiveRoutinesAlert':
        'Sudden changes may cause irritability or insecurity.',
    'protectiveRoutinesA1': 'Keep similar times for sleeping and eating.',
    'protectiveRoutinesA2': 'Prepare for changes with simple phrases.',
    'protectiveRoutinesA3': 'Create calm bedtime rituals.',
    'protectiveRoutinesA4': 'Avoid screens before sleep.',

    'affectionTitle': 'Affection and bonding',
    'affectionSubtitle': 'Daily emotional care',
    'affectionDesc':
        'Affection supports emotional development and strengthens trust.',
    'affectionAlert':
        'Yelling, physical punishment, or humiliation affects the child’s well-being.',
    'affectionA1': 'Respond calmly to crying.',
    'affectionA2': 'Hug, look, and speak with affection.',
    'affectionA3': 'Validate emotions with simple words.',
    'affectionA4': 'Celebrate small achievements.',

    'healthAlertTitle': 'Warning signs',
    'healthAlertSubtitle': 'When to seek help',
    'healthAlertDesc':
        'Some signs require attention from a health professional.',
    'healthAlertAlert':
        'Seek help if there is persistent fever, trouble breathing, seizures, dehydration, or strong behavior changes.',
    'healthAlertA1': 'Watch for fever, excessive sleepiness, or food refusal.',
    'healthAlertA2': 'Consult after strong hits or falls.',
    'healthAlertA3': 'Do not self-medicate the child.',
    'healthAlertA4': 'Keep pediatric checkups up to date.',
  };
}