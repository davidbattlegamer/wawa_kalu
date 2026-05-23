import 'app_config.dart';

class T {
  static String txt(String key) {
    final idioma = AppConfig.idioma.value;

    final textos = {
      'es': {
        
        'appName': 'Wawa Kalú',
        'settingsTitle': 'Ajustes de la app',
        'sounds': 'Sonidos de la app',
        'enabled': 'Activados',
        'disabled': 'Desactivados',
        'language': 'Idioma',
        'spanish': 'Español',
        'english': 'Inglés',
        'settingsNote':
            'Estos ajustes se aplican a toda la app y a futuras funciones.',
        'vibration': 'Vibración',
        'vibrationOn': 'Activada',
        'vibrationOff': 'Desactivada',
        'appearance': 'Apariencia',
        'lightMode': 'Modo claro',
        'darkMode': 'Modo oscuro',
        // HOME
        'welcome': 'Bienvenido a\nWawa Kalú',
        'subtitle': 'Aprende, juega y cuida en familia',
        'cps': 'CPS',
        'cpsSubtitle': 'Sistema interactivo',
        'games': 'Juegos',
        'gamesSubtitle': 'Aprender jugando',
        'nutrition': 'Nutrición',
        'nutritionSubtitle': 'Alimentación familiar',
        'languageMenu': 'Lenguaje',
        'languageSubtitle': 'Comunicación en casa',
        'environment': 'Entornos protectores',
        'environmentSubtitle': 'Cuidado y salud',

        // CPS
        'cpsTitle': 'Aprende con figuras',
        'cpsSubTitle': 'Coloca cada figura en su lugar correcto',
        'espConnected': 'ESP32 conectado',
        'connectEsp': 'Conecta tu ESP32 para iniciar',
        'searching': 'Buscando...',
        'disconnect': 'Desconectar',
        'connectEspButton': 'Conectar ESP32',
        'offlineHistory': 'Historial offline',
        'viewGuide': 'Ver guía',
        'selectEsp': 'Selecciona tu ESP32',
        'signal': 'Señal',
        'noBleDevices': 'No se encontraron dispositivos Bluetooth BLE.',
        'turnOnBluetooth': 'Activa el Bluetooth para conectarte al ESP32.',
        'noBleService': 'No se encontró el servicio BLE del ESP32.',
        'connectFirst': 'Primero conecta el ESP32 para ver el historial.',
        'quickGuide': 'Guía rápida',
        'guide1': 'Enciende el ESP32.',
        'guide2': 'Activa Bluetooth en el celular.',
        'guide3': 'Presiona Conectar ESP32.',
        'guide4': 'Coloca una figura en su lugar.',
        'hideGuide': 'Ocultar guía',
        'prizeGuide':
            'Premios: cada 5 detecciones ganas una estrella ⭐ y cada 10 detecciones ganas una medalla 🏆.',
        'sessionProgress': 'Avances de la sesión',
        'defaultPrize':
            'Cada 5 detecciones ganas una estrella y cada 10 una medalla',
        'starPrize': '¡Muy bien! Ganaste una estrella ⭐',
        'medalPrize': '¡Excelente! Ganaste una medalla 🏆',
        'detections': 'detecciones',
        'activeNow': 'activas ahora',
        'stars': 'estrellas',
        'medals': 'medallas',
        'keepPlaying': 'Sigue colocando figuras para ganar premios',
        'starsWon': '¡Ya tienes estrellas ganadas!',
        'medalsWon': '¡Ya tienes medallas ganadas!',
        'circle': 'Círculo',
        'square': 'Cuadrado',
        'triangle': 'Triángulo',
        'star': 'Estrella',
        'savedRecords': 'Registros guardados',
        'offlineData': 'Datos almacenados en el ESP32 sin conexión',
        'updateHistory': 'Actualizar historial',
        'updating': 'Actualizando...',
        'noRecords':
            'No hay registros cargados.\nPresiona "Actualizar historial".',
        'syncingHistory': 'Sincronizando historial...',
        'noOfflineLogs': 'No existen registros offline guardados.',
        'logError': 'Error al leer el log del ESP32.',

        // JUEGOS
        'studentGames': 'Juegos de alumnos',
        'gamePaty': 'Juego de Paty',
        'gamePatyDesc': 'Juego personalizado creado por Paty',
        'gameAndres': 'Juego de Andrés',
        'gameAndresDesc': 'Trivia creada por Andrés',
        'gameDavid': 'Juego David',
        'gameDavidDesc': 'Juego de colores y animales para niños pequeños',

        // JUEGO DAVID
        'davidTitle': 'Animales divertidos',
        'davidSubtitleSound': 'Toca, escucha y aprende',
        'davidSubtitleNoSound': 'Toca y aprende sin sonido',
        'touchAnimal': 'Toca un animalito',
        'correctAnimal': '¡Muy bien! Es un',
        'hits': 'Aciertos',
        'dog': 'Perro',
        'cat': 'Gato',
        'chick': 'Pollito',
        'cow': 'Vaca',
        // Premios Juego David
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
        // NUTRICIÓN
        'nutritionChildTitle': 'Nutrición infantil',
        'nutritionChildSubtitle':
            'Guía práctica para padres y cuidadores de niños de 0 a 3 años',
        'touchSectionRecommendations':
            'Toca cada sección para ver recomendaciones',
        'nutritionFoodsTitle': 'Alimentos y recetas',
        'nutritionFoodsSubtitle': 'Ideas nutritivas para niños de 0 a 3 años',
        'nutritionFoodsTip1':
            'Ofrezca alimentos naturales, suaves y variados según la edad del niño.',
        'nutritionFoodsTip2':
            'Combine frutas, verduras, cereales y proteínas blandas en porciones pequeñas.',
        'nutritionFoodsTip3':
            'Evite azúcar añadida, gaseosas, snacks procesados y exceso de sal.',
        'nutritionFoodsTip4':
            'Cambie la textura según la edad: puré suave, machacado, trozos blandos y luego alimentos más firmes bajo supervisión.',
        'nutritionFoodsTip5':
            'Si el niño rechaza un alimento, no lo obligue; vuelva a ofrecerlo otro día con paciencia.',
        'nutritionRoutineTitle': 'Rutinas de comida',
        'nutritionRoutineSubtitle': 'Horarios tranquilos para formar hábitos',
        'nutritionRoutineTip1':
            'Mantenga horarios parecidos para desayuno, almuerzo, merienda y cena.',
        'nutritionRoutineTip2':
            'Evite que el niño llegue con demasiada hambre, porque puede irritarse o rechazar la comida.',
        'nutritionRoutineTip3':
            'Procure que el momento de comer sea tranquilo y sin presión.',
        'nutritionRoutineTip4':
            'Comer en familia ayuda al niño a imitar hábitos saludables.',
        'nutritionRoutineTip5':
            'Evite pantallas durante la comida para que el niño reconozca hambre y saciedad.',
        'nutritionHydrationTitle': 'Hidratación saludable',
        'nutritionHydrationSubtitle': 'Agua y líquidos adecuados',
        'nutritionHydrationTip1':
            'El agua debe ser la bebida principal cuando la edad del niño lo permita.',
        'nutritionHydrationTip2':
            'Evite gaseosas, jugos artificiales y bebidas con mucho azúcar.',
        'nutritionHydrationTip3':
            'En días calurosos o después de jugar, ofrezca agua con más frecuencia.',
        'nutritionHydrationTip4':
            'Las sopas, frutas jugosas y alimentos con agua también ayudan a hidratar.',
        'nutritionHydrationTip5':
            'Si hay fiebre, vómito o diarrea, observe signos de deshidratación y busque ayuda médica.',
        'nutritionSignalsTitle': 'Señales del niño',
        'nutritionSignalsSubtitle': 'Hambre, saciedad y aceptación',
        'nutritionSignalsTip1':
            'El niño puede mostrar hambre acercándose a la comida, abriendo la boca o buscando alimento.',
        'nutritionSignalsTip2':
            'Puede mostrar saciedad girando la cabeza, cerrando la boca o perdiendo interés.',
        'nutritionSignalsTip3':
            'No obligue a terminar el plato; respete sus señales.',
        'nutritionSignalsTip4':
            'Sirva porciones pequeñas y repita si el niño desea más.',
        'nutritionSignalsTip5':
            'Tocar, oler y explorar la comida también forma parte del aprendizaje.',
        'nutritionSafetyTitle': 'Seguridad al comer',
        'nutritionSafetySubtitle': 'Prevención de atragantamiento',
        'nutritionSafetyTip1': 'Siempre supervise al niño mientras come.',
        'nutritionSafetyTip2':
            'Evite alimentos duros, redondos o muy pequeños sin cortar.',
        'nutritionSafetyTip3':
            'Corte frutas y alimentos blandos en tamaños seguros.',
        'nutritionSafetyTip4':
            'No permita que el niño coma acostado, corriendo o jugando.',
        'nutritionSafetyTip5':
            'Evite uvas enteras, caramelos duros, frutos secos enteros y trozos grandes.',
        'nutritionParentsTitle': 'Consejos para padres',
        'nutritionParentsSubtitle': 'Acompañar sin presionar',
        'nutritionParentsTip1':
            'La paciencia es clave: no todos los niños comen igual ni al mismo ritmo.',
        'nutritionParentsTip2': 'Evite usar la comida como premio o castigo.',
        'nutritionParentsTip3':
            'Presente platos coloridos y sencillos para despertar curiosidad.',
        'nutritionParentsTip4':
            'No compare al niño con otros; observe su propio progreso.',
        'nutritionParentsTip5':
            'Ante bajo peso, alergias, vómitos frecuentes o rechazo persistente, consulte con un profesional de salud.',
        'recipesForChildren': 'Recetas para niños de 0 a 3 años',
        'recipesShortDesc':
            'Preparaciones suaves, seguras y fáciles para casa.',
        'viewRecipes': 'Ver recetas',
        'nutritionFinalNote':
            'Una buena nutrición acompaña el crecimiento del niño. Ofrezca alimentos variados, seguros y adecuados para su edad. Ante alergias, bajo peso o rechazo frecuente de comida, consulte con un profesional de salud.',

        // RECETAS
        'recipesAppBar': 'Nutrición infantil',
        'recipesHeaderTitle': 'Nutrición infantil',
        'recipesHeaderSubtitle':
            'Recetas suaves, seguras y nutritivas para niños de 0 a 3 años',
        'recipesHeaderNote': 'Ideas pensadas para padres y cuidadores',
        'ingredients': 'Ingredientes',
        'preparation': 'Preparación',
        'recipeFinalNote':
            'Estas recetas son ideas generales. Ajusta la textura, porción e ingredientes según la edad, tolerancia y recomendación del pediatra.',
        'recipe1Title': 'Cremita de zapallo y pollo',
        'recipe1Age': 'Desde los 6 meses',
        'recipe1Moment': 'Almuerzo',
        'recipe1Desc':
            'Una receta suave, cálida y nutritiva para iniciar comidas más completas.',
        'recipe1Ing1': 'Zapallo cocido.',
        'recipe1Ing2': 'Un trocito pequeño de pollo bien cocido.',
        'recipe1Ing3': 'Papa pequeña o camote.',
        'recipe1Ing4': 'Agua tibia o caldo natural sin sal.',
        'recipe1Step1': 'Cocina bien el zapallo, la papa o camote y el pollo.',
        'recipe1Step2': 'Desmenuza el pollo para evitar trozos grandes.',
        'recipe1Step3': 'Aplasta o licúa todo hasta lograr una textura suave.',
        'recipe1Step4': 'Sirve tibio y en porción pequeña.',
        'recipe1Rec':
            'Ideal cuando el niño ya inició alimentación complementaria. No agregues sal ni condimentos fuertes.',
        'recipe2Title': 'Avena cremosa con banano',
        'recipe2Age': 'Desde los 6 meses',
        'recipe2Moment': 'Desayuno o media mañana',
        'recipe2Desc':
            'Energética, suave y fácil de preparar. Buena para empezar el día.',
        'recipe2Ing1': '3 cucharadas de avena.',
        'recipe2Ing2': '1 banano maduro pequeño.',
        'recipe2Ing3': 'Agua o leche adecuada para la edad.',
        'recipe2Ing4': 'Canela mínima opcional, si ya la tolera.',
        'recipe2Step1': 'Cocina la avena hasta que quede muy suave.',
        'recipe2Step2': 'Machaca el banano hasta formar puré.',
        'recipe2Step3': 'Mezcla la avena con el banano.',
        'recipe2Step4': 'Deja enfriar antes de servir.',
        'recipe2Rec':
            'No uses miel antes del año. Tampoco agregues azúcar; el banano ya aporta dulzor natural.',
        'recipe3Title': 'Tortillita suave de huevo y espinaca',
        'recipe3Age': 'Desde los 9 a 12 meses',
        'recipe3Moment': 'Desayuno, almuerzo o cena ligera',
        'recipe3Desc':
            'Una opción blanda para niños que ya toleran huevo y texturas más firmes.',
        'recipe3Ing1': '1 huevo bien cocido.',
        'recipe3Ing2': 'Hojitas de espinaca muy bien picadas.',
        'recipe3Ing3': 'Una cucharadita de aceite.',
        'recipe3Ing4': 'Papa o zanahoria cocida opcional.',
        'recipe3Step1': 'Bate el huevo y mezcla con la espinaca picada.',
        'recipe3Step2':
            'Cocina a fuego bajo hasta que esté completamente cocido.',
        'recipe3Step3': 'Corta en pedacitos pequeños y blandos.',
        'recipe3Step4': 'Acompaña con puré o verdura suave.',
        'recipe3Rec':
            'El huevo debe quedar totalmente cocido. Si hay antecedentes de alergia, consulta primero con el pediatra.',
        'recipe4Title': 'Bolitas blandas de arroz y lenteja',
        'recipe4Age': 'Desde los 10 a 12 meses',
        'recipe4Moment': 'Almuerzo o merienda salada',
        'recipe4Desc':
            'Pequeñas porciones blandas para practicar agarre y masticación segura.',
        'recipe4Ing1': 'Arroz bien cocido.',
        'recipe4Ing2': 'Lenteja bien cocida.',
        'recipe4Ing3': 'Zanahoria cocida y aplastada.',
        'recipe4Ing4': 'Un poquito de agua tibia si necesita suavizar.',
        'recipe4Step1': 'Aplasta la lenteja y mezcla con arroz suave.',
        'recipe4Step2': 'Agrega zanahoria cocida para dar textura y sabor.',
        'recipe4Step3': 'Forma bolitas pequeñas y blandas.',
        'recipe4Step4': 'Verifica que se deshagan fácilmente al presionarlas.',
        'recipe4Rec':
            'Sirve bajo supervisión. Las bolitas deben ser pequeñas, suaves y fáciles de aplastar.',
        'recipe5Title': 'Vasito de yogur natural con fruta',
        'recipe5Age': 'Desde los 12 meses',
        'recipe5Moment': 'Merienda',
        'recipe5Desc':
            'Una merienda fresca, colorida y fácil para niños que ya toleran lácteos.',
        'recipe5Ing1': 'Yogur natural sin azúcar.',
        'recipe5Ing2': 'Fruta madura picada o machacada.',
        'recipe5Ing3': 'Avena suave opcional.',
        'recipe5Step1': 'Coloca una pequeña porción de yogur natural.',
        'recipe5Step2': 'Agrega fruta madura machacada o en trozos seguros.',
        'recipe5Step3': 'Mezcla suavemente.',
        'recipe5Step4': 'Sirve frío, pero no demasiado helado.',
        'recipe5Rec':
            'Evita yogures azucarados. Supervisa si usa trozos de fruta.',

        // LENGUAJE
        'languageTitle': 'Lenguaje y comunicación',
        'languageHeaderSubtitle':
            'Actividades simples para estimular sus primeras palabras',
        'touchActivityRecommendation':
            'Toca una actividad y mira la recomendación',
        'selectActivity': 'Seleccione una actividad',
        'languageDefaultRec':
            'Toque una tarjeta para ver cómo estimular el lenguaje del niño en casa.',
        'languageDefaultHome':
            'Aquí aparecerá una actividad sencilla que puede adaptarse a cualquier objeto, imagen o momento del día.',
        'languageDefaultParent':
            'Recuerde hablarle con calma, mirarlo a los ojos y celebrar sus intentos de comunicarse.',
        'homeActivity': 'Actividad en casa',
        'noActivityReviewed': 'Aún no se ha revisado ninguna actividad.',
        'activitiesReviewed': 'Actividades revisadas',
        'repeatActivities':
            'Puede repetirlas varias veces durante el día en momentos tranquilos.',
        'languageFinalNote':
            'Cada niño desarrolla el lenguaje a su ritmo. Si no responde a sonidos, no mira al hablarle o pierde habilidades adquiridas, consulte con un profesional.',
        'nameObjectsTitle': 'Nombrar objetos',
        'nameObjectsDesc': 'Relaciona palabras con cosas reales.',
        'nameObjectsRec':
            'Nombre objetos cercanos usando frases cortas y claras. Puede usar cualquier cosa que tenga a la mano: ropa, comida, juguetes, utensilios o partes del cuerpo.',
        'nameObjectsHome':
            'Reto general: elija 3 cosas que estén cerca del niño, señálelas y diga su nombre lentamente. Luego espere si el niño mira, señala o intenta repetir.',
        'nameObjectsParent':
            'No importa si el niño aún no pronuncia bien. Lo importante es que escuche, asocie y participe.',
        'readImagesTitle': 'Leer imágenes',
        'readImagesDesc': 'Mejora atención, memoria y vocabulario.',
        'readImagesRec':
            'Use cualquier cuento, lámina, foto o imagen. No es necesario que tenga cosas específicas; puede describir colores, personas, objetos o acciones.',
        'readImagesHome':
            'Reto general: mire una imagen con el niño y describa lo que aparece. Use preguntas simples como: “¿qué ves?”, “¿dónde está?”, “¿qué hace?”.',
        'readImagesParent':
            'Si no responde con palabras, también cuenta que mire, señale, sonría o haga sonidos.',
        'singMoveTitle': 'Cantar y moverse',
        'singMoveDesc': 'Estimula ritmo, sonidos y expresión.',
        'singMoveRec':
            'Cante canciones cortas con gestos. Puede usar palmas, movimientos de manos, sonidos suaves o cambios de voz.',
        'singMoveHome':
            'Reto general: cante una canción corta y acompañe con un gesto repetido. Pause un momento para que el niño intente continuar con sonido o movimiento.',
        'singMoveParent':
            'La repetición ayuda mucho. Es mejor una canción sencilla repetida varios días que muchas canciones distintas.',
        'talkTitle': 'Conversar',
        'talkDesc': 'Fortalece la intención de comunicarse.',
        'talkRec':
            'Responda a los sonidos, gestos o miradas del niño como si fueran parte de una conversación. Eso le enseña que comunicarse tiene valor.',
        'talkHome':
            'Reto general: observe qué hace el niño y descríbalo con voz tranquila. Espere unos segundos para darle oportunidad de responder con mirada, gesto o sonido.',
        'talkParent':
            'No llene todos los silencios. Esperar también ayuda a que el niño intente comunicarse.',
        'imitateSoundsTitle': 'Imitar sonidos',
        'imitateSoundsDesc': 'Practica sonidos básicos de forma divertida.',
        'imitateSoundsRec':
            'Haga sonidos simples de acciones, objetos o situaciones. No necesita materiales especiales: puede usar sonidos de sorpresa, golpes suaves, vehículos o animales conocidos.',
        'imitateSoundsHome':
            'Reto general: haga 3 sonidos fáciles y espere si el niño intenta copiarlos. Puede usar sonidos como “pa-pa”, “ma-ma”, “toc toc”, “mmm” o “brum”.',
        'imitateSoundsParent':
            'Felicite cualquier intento. No corrija fuerte; repita el sonido correcto con naturalidad.',

        // ENTORNOS PROTECTORES
        'environmentTitle': 'Entornos protectores',
        'environmentHeaderSubtitle':
            'Guía para cuidar la seguridad, salud y bienestar de niños de 0 a 3 años',
        'touchEnvironmentActions':
            'Toca cada sección para ver acciones prácticas',
        'safeSpacesTitle': 'Espacios seguros',
        'safeSpacesSubtitle': 'Casa preparada para explorar sin riesgo',
        'safeSpacesDesc':
            'Un entorno seguro permite que el niño explore, juegue y aprenda con menos riesgos.',
        'safeSpacesA1':
            'Guarde medicinas, productos de limpieza y objetos pequeños fuera de su alcance.',
        'safeSpacesA2': 'Cubra enchufes y mantenga cables recogidos.',
        'safeSpacesA3':
            'Evite dejar objetos cortantes, calientes o pesados en bordes de mesas.',
        'safeSpacesA4':
            'Revise el piso para retirar piezas pequeñas que pueda llevarse a la boca.',
        'safeSpacesAlert':
            'Tenga especial cuidado con escaleras, cocina, baño, enchufes y objetos pequeños.',
        'activeSupervisionTitle': 'Supervisión activa',
        'activeSupervisionSubtitle': 'Acompañar sin distraerse',
        'activeSupervisionDesc':
            'La supervisión activa significa estar cerca, mirar lo que hace y anticiparse a posibles peligros.',
        'activeSupervisionA1':
            'Mantenga al niño a la vista cuando juega, come o se desplaza.',
        'activeSupervisionA2':
            'Evite dejarlo solo cerca de agua, cocina, escaleras o ventanas.',
        'activeSupervisionA3':
            'Si debe alejarse, coloque al niño en un lugar seguro.',
        'activeSupervisionA4':
            'No confíe solo en el silencio: revise si está explorando algo peligroso.',
        'activeSupervisionAlert':
            'Los accidentes pueden ocurrir en segundos, especialmente cerca de agua o alturas.',
        'protectiveRoutinesTitle': 'Rutinas protectoras',
        'protectiveRoutinesSubtitle': 'Orden, descanso y tranquilidad',
        'protectiveRoutinesDesc':
            'Las rutinas ayudan al niño a sentirse seguro porque sabe qué esperar durante el día.',
        'protectiveRoutinesA1':
            'Mantenga horarios parecidos para dormir, comer, jugar y descansar.',
        'protectiveRoutinesA2':
            'Avise con calma cuando una actividad va a cambiar.',
        'protectiveRoutinesA3':
            'Cree una rutina breve antes de dormir: baño, cuento o canción suave.',
        'protectiveRoutinesA4':
            'Evite cambios bruscos cuando el niño está cansado o irritable.',
        'protectiveRoutinesAlert':
            'La falta de sueño o rutinas muy desordenadas puede aumentar irritabilidad y llanto.',
        'affectionTitle': 'Afecto y buen trato',
        'affectionSubtitle': 'Cuidar también es responder con calma',
        'affectionDesc':
            'El afecto, la paciencia y el buen trato fortalecen la confianza y el desarrollo emocional.',
        'affectionA1':
            'Abrácelo, háblele con calma y responda a sus necesidades.',
        'affectionA2':
            'Valide sus emociones: cansancio, miedo, frustración o alegría.',
        'affectionA3': 'Evite gritos, golpes o amenazas.',
        'affectionA4':
            'Cuando se equivoque, guíelo con palabras sencillas y tono tranquilo.',
        'affectionAlert':
            'Si el adulto se siente muy estresado, es mejor pedir apoyo antes de reaccionar con enojo.',
        'healthAlertTitle': 'Salud y señales de alerta',
        'healthAlertSubtitle': 'Cuándo buscar ayuda',
        'healthAlertDesc':
            'Observar cambios en el niño permite actuar a tiempo y prevenir complicaciones.',
        'healthAlertA1':
            'Controle fiebre, respiración, alimentación y nivel de energía.',
        'healthAlertA2':
            'Observe golpes, caídas, vómitos, diarrea o rechazo de alimentos.',
        'healthAlertA3': 'Mantenga controles médicos y vacunas según la edad.',
        'healthAlertA4': 'No automedique al niño sin indicación profesional.',
        'healthAlertAlert':
            'Busque atención médica si hay dificultad para respirar, fiebre alta, decaimiento extremo, convulsiones, golpes fuertes o signos de deshidratación.',
        'environmentFinalNote':
            'Un entorno protector combina seguridad, afecto, supervisión y rutinas. Pequeñas acciones diarias ayudan a que el niño crezca con confianza y bienestar.',
      },

      // ENGLISH
      'en': {
        // GENERAL
        'appName': 'Wawa Kalú',
        'settingsTitle': 'App settings',
        'sounds': 'App sounds',
        'enabled': 'Enabled',
        'disabled': 'Disabled',
        'language': 'Language',
        'spanish': 'Spanish',
        'english': 'English',
        'settingsNote':
            'These settings apply to the whole app and future features.',
        'vibration': 'Vibration',
        'vibrationOn': 'Enabled',
        'vibrationOff': 'Disabled',
        'appearance': 'Appearance',
        'lightMode': 'Light mode',
        'darkMode': 'Dark mode',
        // HOME
        'welcome': 'Welcome to\nWawa Kalú',
        'subtitle': 'Learn, play, and care as a family',
        'cps': 'CPS',
        'cpsSubtitle': 'Interactive system',
        'games': 'Games',
        'gamesSubtitle': 'Learning through play',
        'nutrition': 'Nutrition',
        'nutritionSubtitle': 'Family nutrition',
        'languageMenu': 'Language',
        'languageSubtitle': 'Communication at home',
        'environment': 'Protective environments',
        'environmentSubtitle': 'Care and health',

        // CPS
        'cpsTitle': 'Learn with shapes',
        'cpsSubTitle': 'Place each shape in the correct spot',
        'espConnected': 'ESP32 connected',
        'connectEsp': 'Connect your ESP32 to start',
        'searching': 'Searching...',
        'disconnect': 'Disconnect',
        'connectEspButton': 'Connect ESP32',
        'offlineHistory': 'Offline history',
        'viewGuide': 'View guide',
        'selectEsp': 'Select your ESP32',
        'signal': 'Signal',
        'noBleDevices': 'No Bluetooth BLE devices were found.',
        'turnOnBluetooth': 'Turn on Bluetooth to connect to the ESP32.',
        'noBleService': 'The ESP32 BLE service was not found.',
        'connectFirst': 'Connect the ESP32 first to view the history.',
        'quickGuide': 'Quick guide',
        'guide1': 'Turn on the ESP32.',
        'guide2': 'Enable Bluetooth on the phone.',
        'guide3': 'Press Connect ESP32.',
        'guide4': 'Place a shape in its correct spot.',
        'hideGuide': 'Hide guide',
        'prizeGuide':
            'Rewards: every 5 detections earns a star ⭐ and every 10 detections earns a medal 🏆.',
        'sessionProgress': 'Session progress',
        'defaultPrize': 'Every 5 detections earns a star and every 10 a medal',
        'starPrize': 'Great job! You earned a star ⭐',
        'medalPrize': 'Excellent! You earned a medal 🏆',
        'detections': 'detections',
        'activeNow': 'active now',
        'stars': 'stars',
        'medals': 'medals',
        'keepPlaying': 'Keep placing shapes to win rewards',
        'starsWon': 'You have earned stars!',
        'medalsWon': 'You have earned medals!',
        'circle': 'Circle',
        'square': 'Square',
        'triangle': 'Triangle',
        'star': 'Star',
        'savedRecords': 'Saved records',
        'offlineData': 'Data stored in the ESP32 without connection',
        'updateHistory': 'Update history',
        'updating': 'Updating...',
        'noRecords': 'No records loaded.\nPress "Update history".',
        'syncingHistory': 'Syncing history...',
        'noOfflineLogs': 'There are no offline records saved.',
        'logError': 'Error reading the ESP32 log.',

        // GAMES
        'studentGames': 'Student games',
        'gamePaty': 'Paty’s game',
        'gamePatyDesc': 'Custom game created by Paty',
        'gameAndres': 'Andrés’ game',
        'gameAndresDesc': 'Trivia created by Andrés',
        'gameDavid': 'David’s game',
        'gameDavidDesc': 'Colors and animal game for young children',

        // DAVID GAME
        'davidTitle': 'Fun animals',
        'davidSubtitleSound': 'Tap, listen, and learn',
        'davidSubtitleNoSound': 'Tap and learn without sound',
        'touchAnimal': 'Tap an animal',
        'correctAnimal': 'Great job! It is a',
        'hits': 'Hits',
        'dog': 'Dog',
        'cat': 'Cat',
        'chick': 'Chick',
        'cow': 'Cow',
        // David Game rewards
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
        // NUTRITION
        'nutritionChildTitle': 'Child nutrition',
        'nutritionChildSubtitle':
            'Practical guide for parents and caregivers of children from 0 to 3 years old',
        'touchSectionRecommendations':
            'Tap each section to see recommendations',
        'nutritionFoodsTitle': 'Foods and recipes',
        'nutritionFoodsSubtitle':
            'Nutritious ideas for children from 0 to 3 years old',
        'nutritionFoodsTip1':
            'Offer natural, soft, and varied foods according to the child’s age.',
        'nutritionFoodsTip2':
            'Combine fruits, vegetables, grains, and soft proteins in small portions.',
        'nutritionFoodsTip3':
            'Avoid added sugar, soda, processed snacks, and excess salt.',
        'nutritionFoodsTip4':
            'Change textures according to age: smooth purée, mashed foods, soft pieces, and then firmer foods with supervision.',
        'nutritionFoodsTip5':
            'If the child rejects a food, do not force it; offer it again another day with patience.',
        'nutritionRoutineTitle': 'Mealtime routines',
        'nutritionRoutineSubtitle': 'Calm schedules to build habits',
        'nutritionRoutineTip1':
            'Keep similar times for breakfast, lunch, snacks, and dinner.',
        'nutritionRoutineTip2':
            'Avoid letting the child become too hungry, as they may become upset or reject food.',
        'nutritionRoutineTip3': 'Try to make mealtime calm and pressure-free.',
        'nutritionRoutineTip4':
            'Eating as a family helps the child imitate healthy habits.',
        'nutritionRoutineTip5':
            'Avoid screens during meals so the child can recognize hunger and fullness.',
        'nutritionHydrationTitle': 'Healthy hydration',
        'nutritionHydrationSubtitle': 'Water and suitable drinks',
        'nutritionHydrationTip1':
            'Water should be the main drink when the child’s age allows it.',
        'nutritionHydrationTip2':
            'Avoid soda, artificial juices, and very sugary drinks.',
        'nutritionHydrationTip3':
            'On hot days or after playing, offer water more often.',
        'nutritionHydrationTip4':
            'Soups, juicy fruits, and water-rich foods also help with hydration.',
        'nutritionHydrationTip5':
            'If there is fever, vomiting, or diarrhea, watch for signs of dehydration and seek medical help.',
        'nutritionSignalsTitle': 'Child signals',
        'nutritionSignalsSubtitle': 'Hunger, fullness, and acceptance',
        'nutritionSignalsTip1':
            'The child may show hunger by moving toward food, opening the mouth, or seeking food.',
        'nutritionSignalsTip2':
            'The child may show fullness by turning the head, closing the mouth, or losing interest.',
        'nutritionSignalsTip3':
            'Do not force the child to finish the plate; respect their signals.',
        'nutritionSignalsTip4':
            'Serve small portions and offer more if the child wants.',
        'nutritionSignalsTip5':
            'Touching, smelling, and exploring food is also part of learning.',
        'nutritionSafetyTitle': 'Eating safety',
        'nutritionSafetySubtitle': 'Choking prevention',
        'nutritionSafetyTip1': 'Always supervise the child while eating.',
        'nutritionSafetyTip2':
            'Avoid hard, round, or very small foods unless properly cut.',
        'nutritionSafetyTip3': 'Cut fruits and soft foods into safe sizes.',
        'nutritionSafetyTip4':
            'Do not let the child eat while lying down, running, or playing.',
        'nutritionSafetyTip5':
            'Avoid whole grapes, hard candies, whole nuts, and large food pieces.',
        'nutritionParentsTitle': 'Tips for parents',
        'nutritionParentsSubtitle': 'Support without pressure',
        'nutritionParentsTip1':
            'Patience is key: not all children eat the same way or at the same pace.',
        'nutritionParentsTip2': 'Avoid using food as a reward or punishment.',
        'nutritionParentsTip3':
            'Offer colorful and simple meals to spark curiosity.',
        'nutritionParentsTip4':
            'Do not compare the child with others; observe their own progress.',
        'nutritionParentsTip5':
            'If there is low weight, allergies, frequent vomiting, or persistent food rejection, consult a healthcare professional.',
        'recipesForChildren': 'Recipes for children from 0 to 3 years old',
        'recipesShortDesc': 'Soft, safe, and easy preparations for home.',
        'viewRecipes': 'View recipes',
        'nutritionFinalNote':
            'Good nutrition supports the child’s growth. Offer varied, safe foods that are suitable for their age. If there are allergies, low weight, or frequent food rejection, consult a healthcare professional.',

        // RECIPES
        'recipesAppBar': 'Child nutrition',
        'recipesHeaderTitle': 'Child nutrition',
        'recipesHeaderSubtitle':
            'Soft, safe, and nutritious recipes for children from 0 to 3 years old',
        'recipesHeaderNote': 'Ideas designed for parents and caregivers',
        'ingredients': 'Ingredients',
        'preparation': 'Preparation',
        'recipeFinalNote':
            'These recipes are general ideas. Adjust texture, portion size, and ingredients according to age, tolerance, and pediatric guidance.',
        'recipe1Title': 'Pumpkin and chicken cream',
        'recipe1Age': 'From 6 months',
        'recipe1Moment': 'Lunch',
        'recipe1Desc':
            'A soft, warm, and nutritious recipe to introduce more complete meals.',
        'recipe1Ing1': 'Cooked pumpkin.',
        'recipe1Ing2': 'A small piece of well-cooked chicken.',
        'recipe1Ing3': 'Small potato or sweet potato.',
        'recipe1Ing4': 'Warm water or natural unsalted broth.',
        'recipe1Step1':
            'Cook the pumpkin, potato or sweet potato, and chicken well.',
        'recipe1Step2': 'Shred the chicken to avoid large pieces.',
        'recipe1Step3': 'Mash or blend everything until smooth.',
        'recipe1Step4': 'Serve warm and in a small portion.',
        'recipe1Rec':
            'Ideal once the child has started complementary feeding. Do not add salt or strong seasonings.',
        'recipe2Title': 'Creamy oatmeal with banana',
        'recipe2Age': 'From 6 months',
        'recipe2Moment': 'Breakfast or mid-morning',
        'recipe2Desc':
            'Energetic, soft, and easy to prepare. Good to start the day.',
        'recipe2Ing1': '3 tablespoons of oatmeal.',
        'recipe2Ing2': '1 small ripe banana.',
        'recipe2Ing3': 'Water or age-appropriate milk.',
        'recipe2Ing4': 'A minimal amount of cinnamon, optional if tolerated.',
        'recipe2Step1': 'Cook the oatmeal until very soft.',
        'recipe2Step2': 'Mash the banana into a purée.',
        'recipe2Step3': 'Mix the oatmeal with the banana.',
        'recipe2Step4': 'Let it cool before serving.',
        'recipe2Rec':
            'Do not use honey before one year of age. Do not add sugar; banana already provides natural sweetness.',
        'recipe3Title': 'Soft egg and spinach omelet',
        'recipe3Age': 'From 9 to 12 months',
        'recipe3Moment': 'Breakfast, lunch, or light dinner',
        'recipe3Desc':
            'A soft option for children who already tolerate egg and firmer textures.',
        'recipe3Ing1': '1 well-cooked egg.',
        'recipe3Ing2': 'Very finely chopped spinach leaves.',
        'recipe3Ing3': 'One teaspoon of oil.',
        'recipe3Ing4': 'Optional cooked potato or carrot.',
        'recipe3Step1': 'Beat the egg and mix it with chopped spinach.',
        'recipe3Step2': 'Cook over low heat until fully cooked.',
        'recipe3Step3': 'Cut into small, soft pieces.',
        'recipe3Step4': 'Serve with purée or soft vegetables.',
        'recipe3Rec':
            'The egg must be fully cooked. If there is a history of allergies, consult the pediatrician first.',
        'recipe4Title': 'Soft rice and lentil balls',
        'recipe4Age': 'From 10 to 12 months',
        'recipe4Moment': 'Lunch or savory snack',
        'recipe4Desc':
            'Small soft portions to practice grasping and safe chewing.',
        'recipe4Ing1': 'Well-cooked rice.',
        'recipe4Ing2': 'Well-cooked lentils.',
        'recipe4Ing3': 'Cooked and mashed carrot.',
        'recipe4Ing4': 'A little warm water if needed to soften.',
        'recipe4Step1': 'Mash the lentils and mix with soft rice.',
        'recipe4Step2': 'Add cooked carrot for texture and flavor.',
        'recipe4Step3': 'Form small, soft balls.',
        'recipe4Step4': 'Make sure they break apart easily when pressed.',
        'recipe4Rec':
            'Serve with supervision. The balls should be small, soft, and easy to mash.',
        'recipe5Title': 'Natural yogurt cup with fruit',
        'recipe5Age': 'From 12 months',
        'recipe5Moment': 'Snack',
        'recipe5Desc':
            'A fresh, colorful, and easy snack for children who already tolerate dairy.',
        'recipe5Ing1': 'Unsweetened natural yogurt.',
        'recipe5Ing2': 'Ripe fruit, chopped or mashed.',
        'recipe5Ing3': 'Optional soft oatmeal.',
        'recipe5Step1': 'Place a small portion of natural yogurt.',
        'recipe5Step2': 'Add ripe mashed fruit or safe fruit pieces.',
        'recipe5Step3': 'Mix gently.',
        'recipe5Step4': 'Serve cold, but not too chilled.',
        'recipe5Rec':
            'Avoid sweetened yogurts. Supervise if using fruit pieces.',

        // LANGUAGE
        'languageTitle': 'Language and communication',
        'languageHeaderSubtitle': 'Simple activities to stimulate first words',
        'touchActivityRecommendation':
            'Tap an activity and see the recommendation',
        'selectActivity': 'Select an activity',
        'languageDefaultRec':
            'Tap a card to see how to stimulate the child’s language at home.',
        'languageDefaultHome':
            'A simple activity will appear here and can be adapted to any object, image, or moment of the day.',
        'languageDefaultParent':
            'Remember to speak calmly, look at the child, and celebrate communication attempts.',
        'homeActivity': 'Home activity',
        'noActivityReviewed': 'No activity has been reviewed yet.',
        'activitiesReviewed': 'Activities reviewed',
        'repeatActivities':
            'You can repeat them several times during the day in calm moments.',
        'languageFinalNote':
            'Each child develops language at their own pace. If they do not respond to sounds, do not look when spoken to, or lose acquired skills, consult a professional.',
        'nameObjectsTitle': 'Name objects',
        'nameObjectsDesc': 'Connects words with real things.',
        'nameObjectsRec':
            'Name nearby objects using short and clear phrases. You can use anything available: clothes, food, toys, utensils, or body parts.',
        'nameObjectsHome':
            'General challenge: choose 3 things near the child, point to them, and say their names slowly. Then wait to see if the child looks, points, or tries to repeat.',
        'nameObjectsParent':
            'It does not matter if the child cannot pronounce well yet. What matters is listening, associating, and participating.',
        'readImagesTitle': 'Read images',
        'readImagesDesc': 'Improves attention, memory, and vocabulary.',
        'readImagesRec':
            'Use any storybook, worksheet, photo, or image. It does not need to include specific things; you can describe colors, people, objects, or actions.',
        'readImagesHome':
            'General challenge: look at an image with the child and describe what appears. Use simple questions like: “What do you see?”, “Where is it?”, “What is it doing?”.',
        'readImagesParent':
            'If the child does not answer with words, looking, pointing, smiling, or making sounds also counts.',
        'singMoveTitle': 'Sing and move',
        'singMoveDesc': 'Stimulates rhythm, sounds, and expression.',
        'singMoveRec':
            'Sing short songs with gestures. You can use claps, hand movements, soft sounds, or voice changes.',
        'singMoveHome':
            'General challenge: sing a short song and add a repeated gesture. Pause briefly so the child can try to continue with a sound or movement.',
        'singMoveParent':
            'Repetition helps a lot. One simple song repeated for several days is better than many different songs.',
        'talkTitle': 'Talk',
        'talkDesc': 'Strengthens the intention to communicate.',
        'talkRec':
            'Respond to the child’s sounds, gestures, or looks as if they were part of a conversation. This teaches that communication has value.',
        'talkHome':
            'General challenge: observe what the child is doing and describe it calmly. Wait a few seconds to give them a chance to respond with a look, gesture, or sound.',
        'talkParent':
            'Do not fill every silence. Waiting also helps the child try to communicate.',
        'imitateSoundsTitle': 'Imitate sounds',
        'imitateSoundsDesc': 'Practices basic sounds in a fun way.',
        'imitateSoundsRec':
            'Make simple sounds from actions, objects, or situations. No special materials are needed: you can use surprise sounds, soft knocks, vehicles, or familiar animals.',
        'imitateSoundsHome':
            'General challenge: make 3 easy sounds and wait to see if the child tries to copy them. You can use sounds like “pa-pa”, “ma-ma”, “knock knock”, “mmm”, or “vroom”.',
        'imitateSoundsParent':
            'Praise any attempt. Do not correct harshly; repeat the correct sound naturally.',

        // PROTECTIVE ENVIRONMENTS
        'environmentTitle': 'Protective environments',
        'environmentHeaderSubtitle':
            'Guide to care for the safety, health, and well-being of children from 0 to 3 years old',
        'touchEnvironmentActions': 'Tap each section to see practical actions',
        'safeSpacesTitle': 'Safe spaces',
        'safeSpacesSubtitle': 'A home prepared for safe exploration',
        'safeSpacesDesc':
            'A safe environment allows the child to explore, play, and learn with fewer risks.',
        'safeSpacesA1':
            'Keep medicines, cleaning products, and small objects out of reach.',
        'safeSpacesA2': 'Cover outlets and keep cables organized.',
        'safeSpacesA3':
            'Avoid leaving sharp, hot, or heavy objects on table edges.',
        'safeSpacesA4':
            'Check the floor to remove small pieces the child could put in their mouth.',
        'safeSpacesAlert':
            'Pay special attention to stairs, kitchen, bathroom, outlets, and small objects.',
        'activeSupervisionTitle': 'Active supervision',
        'activeSupervisionSubtitle': 'Stay present without distractions',
        'activeSupervisionDesc':
            'Active supervision means staying close, watching what the child does, and anticipating possible dangers.',
        'activeSupervisionA1':
            'Keep the child in sight while playing, eating, or moving around.',
        'activeSupervisionA2':
            'Avoid leaving the child alone near water, kitchen areas, stairs, or windows.',
        'activeSupervisionA3':
            'If you need to step away, place the child in a safe area.',
        'activeSupervisionA4':
            'Do not rely only on silence: check whether the child is exploring something dangerous.',
        'activeSupervisionAlert':
            'Accidents can happen in seconds, especially near water or heights.',
        'protectiveRoutinesTitle': 'Protective routines',
        'protectiveRoutinesSubtitle': 'Order, rest, and calm',
        'protectiveRoutinesDesc':
            'Routines help the child feel safe because they know what to expect during the day.',
        'protectiveRoutinesA1':
            'Keep similar schedules for sleeping, eating, playing, and resting.',
        'protectiveRoutinesA2':
            'Calmly let the child know when an activity is about to change.',
        'protectiveRoutinesA3':
            'Create a short bedtime routine: bath, story, or soft song.',
        'protectiveRoutinesA4':
            'Avoid sudden changes when the child is tired or irritable.',
        'protectiveRoutinesAlert':
            'Lack of sleep or very disorganized routines can increase irritability and crying.',
        'affectionTitle': 'Affection and respectful care',
        'affectionSubtitle': 'Caring also means responding calmly',
        'affectionDesc':
            'Affection, patience, and respectful care strengthen trust and emotional development.',
        'affectionA1':
            'Hug the child, speak calmly, and respond to their needs.',
        'affectionA2':
            'Validate emotions: tiredness, fear, frustration, or joy.',
        'affectionA3': 'Avoid shouting, hitting, or threats.',
        'affectionA4':
            'When the child makes a mistake, guide them with simple words and a calm tone.',
        'affectionAlert':
            'If the adult feels very stressed, it is better to ask for support before reacting with anger.',
        'healthAlertTitle': 'Health and warning signs',
        'healthAlertSubtitle': 'When to seek help',
        'healthAlertDesc':
            'Observing changes in the child helps you act in time and prevent complications.',
        'healthAlertA1': 'Monitor fever, breathing, feeding, and energy level.',
        'healthAlertA2':
            'Watch for falls, strong hits, vomiting, diarrhea, or food refusal.',
        'healthAlertA3':
            'Keep medical checkups and vaccinations according to age.',
        'healthAlertA4':
            'Do not medicate the child without professional guidance.',
        'healthAlertAlert':
            'Seek medical care if there is difficulty breathing, high fever, extreme tiredness, seizures, strong hits, or signs of dehydration.',
        'environmentFinalNote':
            'A protective environment combines safety, affection, supervision, and routines. Small daily actions help the child grow with confidence and well-being.',
      },
    };

    return textos[idioma]?[key] ?? key;
  }
}
