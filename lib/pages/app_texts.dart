import 'app_config.dart';

class T {
  static String txt(String key) {
    final lang = AppConfig.idioma.value;

    final Map<String, String> selected =
        lang == 'en' ? _english : _spanish;

    return selected[key] ?? _spanish[key] ?? key;
  }

  static final Map<String, String> _spanish = {
    'vaccineApplied': 'APLICADA',
'vaccineUpcoming': 'PRÓXIMA',
'vaccineReview': 'REQUIERE REVISIÓN',
'vaccineSeasonalReview':
    'REVISAR VACUNACIÓN ESTACIONAL',
'vaccineWaitingPrevious':
    'PENDIENTE DE DOSIS ANTERIOR',

'vaccineExpectedDate':
    'Fecha prevista',

'vaccineReferenceDate':
    'Fecha de referencia',

'vaccineDaysRemaining':
    'Faltan {days} días',

'vaccineTomorrow':
    'Corresponde mañana',

'vaccineToday':
    'Corresponde revisar hoy',

'vaccineDatePassed':
    'La fecha de referencia ya pasó',
    // GENERAL
    'appName': 'Wawa Kalú',
    'subtitle': 'Aprende jugando, explorando y creciendo en familia',
    'settingsTitle': 'Configuración',
    'enabled': 'Activado',
    'disabled': 'Desactivado',
    'startApp': 'Comenzar',
    'startingApp': 'Entrando...',

// NAVEGACIÓN PRINCIPAL
'navHome': 'Inicio',
'navChildren': 'Mis niños',
'navHealth': 'Salud',
'navLearning': 'Aprender',

// MIS NIÑOS
'myChildren': 'Mis niños',
'noChildrenRegistered':
    'Aún no tienes niños registrados',
'childrenEmptyDescription':
    'Aquí podrás registrar uno o varios niños y llevar su información de crecimiento y salud por separado.',
'addChild': 'Agregar niño',

// SALUD
'health': 'Salud',
'healthHeaderTitle':
    'Acompaña su crecimiento y bienestar',
'healthHeaderSubtitle':
    'Toda la información de salud estará organizada en un solo lugar.',
'vaccines': 'Vacunas',
'vaccinesSubtitle':
    'Esquema, dosis aplicadas y próximas vacunas',
'growth': 'Crecimiento',
'growthSubtitle':
    'Peso, talla y evolución del niño',
'healthNutritionSubtitle':
    'Consejos y alimentación infantil',

// APRENDER
'learning': 'Aprender',
'learningHeaderTitle':
    'Aprender y crecer',
'learningHeaderSubtitle':
    'Actividades para acompañar el aprendizaje y desarrollo del niño.',
'learningGamesSubtitle':
    'Actividades educativas e interactivas',
'learningLanguageSubtitle':
    'Comunicación y estimulación',
'protectiveEnvironments':
    'Entornos protectores',
'learningEnvironmentSubtitle':
    'Cuidado, bienestar y protección infantil',

    // INFORMACIÓN
    'aboutApp': 'Acerca de la app',
    'aboutAppSubtitle':
        'Wawa Kalú es una app educativa infantil que combina juegos, sonidos, vibración y actividades interactivas para apoyar el aprendizaje temprano.',
    'close': 'Cerrar',

    // CONFIGURACIÓN
    'sounds': 'Sonidos',
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
    'languageAutomatic': 'Automático',
    'languageAutoSubtitle': 'Según idioma del celular',

    // BIENVENIDA
    'welcomeScreenTitle': 'Bienvenido a',
    'welcomeSettingsNote':
        'Puedes cambiar idioma, sonidos, vibración y apariencia desde el engrane.',

    // HOME
    'games': 'Juegos',
    'nutrition': 'Nutrición',
    'languageMenu': 'Lenguaje',

    // PÁGINA DE JUEGOS
    'gamesPageTitle': 'Zona de Juegos',
    'gamesPageSubtitle': 'Aprender jugando',
    'gamesPageDescription':
        'Explora actividades creadas para que los niños aprendan con juegos, colores, animales, preguntas y retos sencillos.',
    'playNow': 'Jugar ahora',
    'availableGames': 'Juegos disponibles',
    'gameBenefits': 'Beneficios del juego',
    'gameBenefit1': 'Estimula la atención y la observación.',
    'gameBenefit2':
        'Favorece el reconocimiento de sonidos, colores y figuras.',
    'gameBenefit3': 'Promueve el aprendizaje mediante interacción.',
    'gameBenefit4':
        'Permite aprender de forma sencilla y entretenida.',

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

    // JUEGO GENERAL / PATY
    'gameTitle': 'Juego de figuras',
    'gameSubtitle': 'Toca, observa y aprende',
    'gameDescription':
        'Toca cada figura para reconocer su nombre, color y forma de manera visual e interactiva.',
    'touchFigure': 'Toca una figura para comenzar',
    'correctFigure': 'Seleccionaste:',
    'hits': 'Aciertos',
    'resetGame': 'Reiniciar juego',
    'figureRewardDefault':
        'Sigue tocando figuras para ganar premios',
    'figureRewardStar':
        '¡Ganaste una estrella por tus aciertos!',
    'figureRewardMedal':
        '¡Excelente! Ganaste una medalla de figuras',
    'figureInstructions':
        'Observa las figuras, toca una y escucha o mira la respuesta en pantalla.',

    // JUEGO DAVID
    'gameDavid': 'Juego David',
    'davidTitle': 'Juego de animales',
    'davidSubtitleSound': 'Toca un animal y escucha su sonido',
    'davidSubtitleNoSound': 'Toca un animal y aprende sin sonido',
    'touchAnimal': 'Toca un animal para jugar',
    'correctAnimal': 'Seleccionaste:',
    'dog': 'Perro',
    'cat': 'Gato',
    'chick': 'Pollito',
    'cow': 'Vaca',
// PERFILES DE NIÑOS
'childrenHeaderTitle': 'Tus niños',
'childrenHeaderSubtitle':
    'Selecciona un perfil o registra un nuevo niño.',
'childProfile': 'Perfil del niño',
'childName': 'Nombre o apodo',
'childNameHint': 'Ej. Sofía',
'childNameRequired': 'Ingresa el nombre o apodo del niño.',
'birthDate': 'Fecha de nacimiento',
'selectBirthDate': 'Seleccionar fecha de nacimiento',
'selectDate': 'Seleccionar fecha',
'birthDateRequired': 'Selecciona la fecha de nacimiento.',
'sex': 'Sexo',
'sexForGrowthCurves': 'Sexo para curvas de crecimiento',
'sexForGrowthCurvesDescription':
    'Este dato se utiliza para seleccionar la curva de crecimiento correspondiente.',
'sexRequired': 'Selecciona niño o niña.',
'boy': 'Niño',
'girl': 'Niña',
'saveChild': 'Guardar perfil',
'editChild': 'Editar perfil',
'saveChanges': 'Guardar cambios',
'deleteChild': 'Eliminar perfil',
'deleteChildConfirmation':
    '¿Seguro que deseas eliminar el perfil de {name}? Esta acción no se puede deshacer.',
'delete': 'Eliminar',
'edit': 'Editar',
'cancel': 'Cancelar',
'accept': 'Aceptar',
'selectThisChild': 'Seleccionar este niño',
'activeChild': 'Niño seleccionado',
'childHealth': 'Salud y seguimiento',

// EDAD
'year': 'año',
'years': 'años',
'month': 'mes',
'months': 'meses',
'day': 'día',
'days': 'días',
'active': 'Activo',
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
// CURVAS DE CRECIMIENTO OMS

'viewGrowthCharts':
    'Ver curvas de crecimiento',

'growthChartsTitle':
    'Curvas de crecimiento',

'whoChildGrowthStandards':
    'Estándares de crecimiento infantil OMS 0–5 años',

'whoGrowthReferenceNote':
    'Las curvas utilizan los estándares de crecimiento infantil de la OMS para niñas y niños de 0 a 5 años. Los puntos corresponden a los controles registrados en Wawa Kalú.',

'weightForAgeChart':
    'Peso para la edad',

'weightForAgeChartDescription':
    'Compara la evolución del peso del niño con las curvas de referencia según su edad.',

'heightForAgeChart':
    'Longitud/Talla para la edad',

'heightForAgeChartDescription':
    'Compara la longitud o talla registrada con las curvas de referencia según la edad.',

'weightForLengthChart':
    'Peso para la longitud',

'weightForLengthChartDescription':
    'Relaciona el peso con la longitud en los controles de los primeros años de vida.',

'weightForHeightChart':
    'Peso para la talla',

'weightForHeightChartDescription':
    'Relaciona el peso con la talla registrada.',

'bmiForAgeChart':
    'IMC para la edad',

'bmiForAgeChartDescription':
    'Muestra la evolución del índice de masa corporal en relación con la edad.',

'growthChartZoomHint':
    'Puedes ampliar y mover la gráfica para verla con mayor detalle.',

'growthChartNoData':
    'No existen controles compatibles para esta gráfica.',

'growthChartsNoMeasurements':
    'Aún no hay datos para graficar',

'growthChartsNoMeasurementsSubtitle':
    'Registra al menos un control de peso y longitud o talla para comenzar.',

'growthChartsLoadError':
    'No se pudieron cargar las curvas de crecimiento.',

'growthChartRenderError':
    'No se pudo generar esta gráfica con los datos registrados.',

'growthNoValidWhoMeasurements':
    'Los controles registrados no se encuentran dentro del rango válido de las curvas OMS de 0 a 5 años.',

'growthSkippedMeasurements':
    '{count} control(es) no pudieron utilizarse en las curvas OMS y fueron omitidos.',

'growthChartDisclaimer':
    'Las curvas sirven como apoyo para el seguimiento y no constituyen por sí solas un diagnóstico. La interpretación clínica debe realizarla un profesional de salud.',

'age':
    'Edad',

'weightKgShort':
    'Peso (kg)',

'heightCmShort':
    'Talla (cm)',

'lengthCmShort':
    'Longitud (cm)',

'bmiShort':
    'IMC',

'refresh':
    'Actualizar',
    // NUTRICIÓN
    'nutritionChildTitle': 'Nutrición infantil',
    'nutritionChildSubtitle':
        'Guía práctica para padres y cuidadores de niños de 0 a 3 años',
    'touchSectionRecommendations':
        'Toca cada sección para ver recomendaciones',

    'nutritionFoodsTitle': 'Alimentos y recetas',
    'nutritionFoodsSubtitle':
        'Ideas nutritivas para niños de 0 a 3 años',
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
'vaccineRemindersTitle':
    'Recordatorios de vacunas',

'vaccineRemindersSubtitle':
    'Recibe avisos antes de las fechas previstas de vacunación.',

'vaccineRemindersSchedule':
    'Avisos 7 días antes, 1 día antes y el mismo día.',

'vaccineRemindersEnabledMessage':
    'Los recordatorios de vacunas están activados.',

'vaccineRemindersDisabledMessage':
    'Los recordatorios de vacunas están desactivados.',

'notificationPermissionDenied':
    'No se concedió permiso para mostrar notificaciones.',

'testNotification':
    'Probar notificación',

'vaccineNotificationTitle':
    'Vacuna de {name} 💉',

'vaccineNotification7Days':
    'En una semana corresponde revisar la vacuna {vaccine} de {name}.',
// CRECIMIENTO - REGISTRO
'registerGrowthControl':
    'Registrar control',

'editGrowthControl':
    'Editar control',

'saveGrowthControl':
    'Guardar control',

'latestGrowthControl':
    'Último control',

'growthHistory':
    'Historial de controles',

'noGrowthControls':
    'Aún no hay controles registrados',

'noGrowthControlsSubtitle':
    'Registra el peso y la talla o longitud del niño para comenzar su seguimiento.',

'growthControlDate':
    'Fecha del control',

'weight': 'Peso',

'weightKg':
    'Peso en kilogramos',

'height': 'Talla',

'length': 'Longitud',

'heightCm':
    'Longitud o talla en centímetros',

'weightRequired':
    'Ingresa el peso.',

'weightInvalid':
    'Revisa el valor del peso ingresado.',

'heightRequired':
    'Ingresa la longitud o talla.',

'heightInvalid':
    'Revisa el valor de longitud o talla ingresado.',

'measurementMethod':
    'Tipo de medición',

'measurementMethodDescription':
    'Selecciona cómo se realizó la medición. Esto será importante para interpretar correctamente las curvas de crecimiento.',

'recumbentLength':
    'Longitud acostado',

'standingHeight':
    'Talla de pie',

'growthNotesHint':
    'Ej. Control realizado en el centro de salud',

'deleteGrowthControl':
    'Eliminar control',

'deleteGrowthControlQuestion':
    '¿Seguro que deseas eliminar este control de crecimiento?',

'growthLoadError':
    'No se pudieron cargar los controles de crecimiento.',

'growthChartsNextStep':
    'Estos controles serán utilizados en las gráficas de peso/edad, talla/edad y otros indicadores del siguiente paso.',
'vaccineNotificationTomorrow':
    'Mañana corresponde revisar la vacuna {vaccine} de {name}.',

'vaccineNotificationToday':
    'Hoy corresponde revisar la vacuna {vaccine} de {name}.',
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
// SALUD - ORGANIZACIÓN
'healthTrackingTitle':
    'Seguimiento infantil',
'healthGuidanceTitle':
    'Alimentación y orientación',
'healthOfChild':
    'Salud de {name}',
'healthNoChild':
    'Registra un niño para comenzar su seguimiento de salud.',

'recipes': 'Recetas',
'healthRecipesSubtitle':
    'Ideas de alimentación y preparaciones para niños',

// PERFIL NECESARIO
'healthProfileRequiredTitle':
    'Primero registra un niño',
'healthProfileRequiredSubtitle':
    'Necesitamos un perfil para relacionar correctamente sus vacunas y controles de crecimiento.',

// VACUNAS
'vaccinesPageTitle':
    'Vacunas',
// VACUNAS - ESQUEMA
'vaccinesScheduleTitle':
    'Esquema de vacunación',
'vaccinesScheduleSubtitle':
    'Referencia basada en el esquema nacional del MSP Ecuador 2026.',

'vaccinesLoadError':
    'No se pudo cargar el esquema de vacunación.',

'registerVaccine':
    'Registrar vacuna',
'editVaccineRecord':
    'Editar registro',
'vaccineAppliedDate':
    'Fecha de aplicación',
'healthCenterOptional':
    'Centro de salud (opcional)',
'notesOptional':
    'Notas (opcional)',
'saveVaccineRecord':
    'Guardar aplicación',
'deleteVaccineRecord':
    'Eliminar registro',
'deleteVaccineRecordQuestion':
    '¿Seguro que deseas eliminar este registro de vacunación?',

'vaccinesDisclaimer':
    'Este seguimiento es orientativo y no reemplaza el carné de vacunación ni la evaluación de un profesional de salud. Si existen dosis pendientes, antecedentes incompletos o dudas sobre el esquema, consulta en un establecimiento de salud.',

// DOSIS
'vaccineSingleDose': 'Dosis única',
'vaccineBirthDose':
    'Dosis al nacimiento',
'vaccineDose1': 'Primera dosis',
'vaccineDose2': 'Segunda dosis',
'vaccineDose3': 'Tercera dosis',
'vaccineDose6Months':
    'Dosis de los 6 meses',
'vaccineDose15Months':
    'Dosis de los 15 meses',
'vaccineDose18Months':
    'Dosis de los 18 meses',
'vaccineDose5Years':
    'Dosis de los 5 años',
'vaccineSeasonalDose':
    'Vacunación estacional',

'vaccineBirth24Hours':
    'De preferencia dentro de las primeras 24 horas de vida.',
'vaccineSeasonalNote':
    'La fecha depende de la estrategia de vacunación estacional vigente.',

// NOMBRES DE VACUNAS
'vaccineBCG': 'BCG',
'vaccineHepatitisBZero':
    'Hepatitis B - dosis cero',
'vaccineRotavirus':
    'Rotavirus',
'vaccineHexavalent':
    'Hexavalente',
'vaccinePneumococcal':
    'Neumococo',
'vaccineBOPV':
    'Poliomielitis (bOPV)',
'vaccineInfluenza':
    'Influenza estacional',
'vaccineYellowFever':
    'Fiebre amarilla',
'vaccineMMR':
    'SRP',
'vaccineVaricella':
    'Varicela',
'vaccineDPT':
    'DPT',

// ENFERMEDADES QUE PREVIENEN
'vaccineBCGPrevents':
    'Ayuda a prevenir formas graves de tuberculosis.',
'vaccineHepatitisBPrevents':
    'Ayuda a prevenir la hepatitis B.',
'vaccineRotavirusPrevents':
    'Ayuda a prevenir enfermedad grave por rotavirus.',
'vaccineHexavalentPrevents':
    'Protege contra varias enfermedades prevenibles por vacunación.',
'vaccinePneumococcalPrevents':
    'Ayuda a prevenir enfermedades causadas por neumococo.',
'vaccinePolioPrevents':
    'Ayuda a prevenir la poliomielitis.',
'vaccineInfluenzaPrevents':
    'Ayuda a prevenir la influenza.',
'vaccineYellowFeverPrevents':
    'Ayuda a prevenir la fiebre amarilla.',
'vaccineMMRPrevents':
    'Ayuda a prevenir sarampión, rubéola y paperas.',
'vaccineVaricellaPrevents':
    'Ayuda a prevenir la varicela.',
'vaccineDPTPrevents':
    'Ayuda a prevenir difteria, tosferina y tétanos.',
// CRECIMIENTO
'growthPageTitle':
    'Crecimiento',
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
// PRIVACIDAD

'privacyAndData':
    'Privacidad y datos',

'privacySettingsSubtitle':
    'Datos locales y eliminación',

'privacyTitle':
    'Tu información permanece bajo tu control',

'privacyDescription':
    'Wawa Kalú guarda los perfiles infantiles y sus controles en el dispositivo para que puedas utilizarlos sin depender de una conexión a internet.',

'localStorageTitle':
    'Almacenamiento local',

'localStorageDescription':
    'Los perfiles infantiles, registros de vacunas y controles de crecimiento se guardan localmente en este dispositivo.',

'storedDataTitle':
    'Información guardada',

'storedDataDescription':
    'La aplicación puede almacenar nombre del niño, fecha de nacimiento, sexo, registros de vacunas, peso, longitud o talla y notas que hayas ingresado.',

'notificationPrivacyTitle':
    'Recordatorios locales',

'notificationPrivacyDescription':
    'Los recordatorios de vacunas se programan mediante el sistema de notificaciones del dispositivo. Puedes desactivarlos desde el módulo de vacunas.',

'dataManagement':
    'Administración de datos',

'dataManagementDescription':
    'Puedes eliminar los perfiles infantiles y toda la información de salud registrada en Wawa Kalú.',

'deleteAllChildDataTitle':
    'Eliminar todos los datos infantiles',

'deleteAllChildDataDescription':
    'Esta acción elimina todos los perfiles, vacunas registradas y controles de crecimiento guardados en el dispositivo.',

'deleteAllChildDataQuestion':
    '¿Seguro que deseas eliminar todos los perfiles infantiles y sus datos? Esta acción no se puede deshacer.',

'deleteAllData':
    'Eliminar todos los datos',

'allChildDataDeleted':
    'Todos los datos infantiles fueron eliminados.',

'deleteAllDataError':
    'No se pudieron eliminar todos los datos. Inténtalo nuevamente.',

'privacyFinalNote':
    'Las preferencias generales de la aplicación, como idioma y tema, no se eliminan al borrar los datos infantiles.',
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
    'nutritionSafetyTip1':
        'Siempre supervise al niño mientras come.',
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
    'nutritionParentsTip2':
        'Evite usar la comida como premio o castigo.',
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
    'recipe1Ing2':
        'Un trocito pequeño de pollo bien cocido.',
    'recipe1Ing3': 'Papa pequeña o camote.',
    'recipe1Ing4': 'Agua tibia o caldo natural sin sal.',
    'recipe1Step1':
        'Cocina bien el zapallo, la papa o camote y el pollo.',
    'recipe1Step2':
        'Desmenuza el pollo para evitar trozos grandes.',
    'recipe1Step3':
        'Aplasta o licúa todo hasta lograr una textura suave.',
    'recipe1Step4':
        'Sirve tibio y en porción pequeña.',
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
    'recipe2Ing4':
        'Canela mínima opcional, si ya la tolera.',
    'recipe2Step1':
        'Cocina la avena hasta que quede muy suave.',
    'recipe2Step2':
        'Machaca el banano hasta formar puré.',
    'recipe2Step3':
        'Mezcla la avena con el banano.',
    'recipe2Step4':
        'Deja enfriar antes de servir.',
    'recipe2Rec':
        'No uses miel antes del año. Tampoco agregues azúcar; el banano ya aporta dulzor natural.',

    'recipe3Title': 'Tortillita suave de huevo y espinaca',
    'recipe3Age': 'Desde los 9 a 12 meses',
    'recipe3Moment': 'Desayuno, almuerzo o cena ligera',
    'recipe3Desc':
        'Una opción blanda para niños que ya toleran huevo y texturas más firmes.',
    'recipe3Ing1': '1 huevo bien cocido.',
    'recipe3Ing2':
        'Hojitas de espinaca muy bien picadas.',
    'recipe3Ing3': 'Una cucharadita de aceite.',
    'recipe3Ing4':
        'Papa o zanahoria cocida opcional.',
    'recipe3Step1':
        'Bate el huevo y mezcla con la espinaca picada.',
    'recipe3Step2':
        'Cocina a fuego bajo hasta que esté completamente cocido.',
    'recipe3Step3':
        'Corta en pedacitos pequeños y blandos.',
    'recipe3Step4':
        'Acompaña con puré o verdura suave.',
    'recipe3Rec':
        'El huevo debe quedar totalmente cocido. Si hay antecedentes de alergia, consulta primero con el pediatra.',

    'recipe4Title': 'Bolitas blandas de arroz y lenteja',
    'recipe4Age': 'Desde los 10 a 12 meses',
    'recipe4Moment': 'Almuerzo o merienda salada',
    'recipe4Desc':
        'Pequeñas porciones blandas para practicar agarre y masticación segura.',
    'recipe4Ing1': 'Arroz bien cocido.',
    'recipe4Ing2': 'Lenteja bien cocida.',
    'recipe4Ing3':
        'Zanahoria cocida y aplastada.',
    'recipe4Ing4':
        'Un poquito de agua tibia si necesita suavizar.',
    'recipe4Step1':
        'Aplasta la lenteja y mezcla con arroz suave.',
    'recipe4Step2':
        'Agrega zanahoria cocida para dar textura y sabor.',
    'recipe4Step3':
        'Forma bolitas pequeñas y blandas.',
    'recipe4Step4':
        'Verifica que se deshagan fácilmente al presionarlas.',
    'recipe4Rec':
        'Sirve bajo supervisión. Las bolitas deben ser pequeñas, suaves y fáciles de aplastar.',
'homeHealthLoading':
    'Actualizando información de salud...',

'homeHealthLoadError':
    'No se pudo actualizar esta información.',
'appVersion': 'Versión',
'developers': 'Desarrolladores',
'homeVaccinesNoPending':
    'No hay dosis pendientes en el seguimiento actual.',

'deleteChildError':
    'No se pudo eliminar el perfil. Inténtalo nuevamente.',

    'recipe5Title': 'Vasito de yogur natural con fruta',
    'recipe5Age': 'Desde los 12 meses',
    'recipe5Moment': 'Merienda',
    'recipe5Desc':
        'Una merienda fresca, colorida y fácil para niños que ya toleran lácteos.',
    'recipe5Ing1':
        'Yogur natural sin azúcar.',
    'recipe5Ing2':
        'Fruta madura picada o machacada.',
    'recipe5Ing3': 'Avena suave opcional.',
    'recipe5Step1':
        'Coloca una pequeña porción de yogur natural.',
    'recipe5Step2':
        'Agrega fruta madura machacada o en trozos seguros.',
    'recipe5Step3': 'Mezcla suavemente.',
    'recipe5Step4':
        'Sirve frío, pero no demasiado helado.',
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
    'noActivityReviewed':
        'Aún no se ha revisado ninguna actividad.',
    'activitiesReviewed': 'Actividades revisadas',
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
    'readImagesDesc':
        'Mejora atención, memoria y vocabulario.',
    'readImagesRec':
        'Use cualquier cuento, lámina, foto o imagen. No es necesario que tenga cosas específicas; puede describir colores, personas, objetos o acciones.',
    'readImagesHome':
        'Reto general: mire una imagen con el niño y describa lo que aparece. Use preguntas simples como: “¿qué ves?”, “¿dónde está?”, “¿qué hace?”.',
    'readImagesParent':
        'Si no responde con palabras, también cuenta que mire, señale, sonría o haga sonidos.',

    'singMoveTitle': 'Cantar y moverse',
    'singMoveDesc':
        'Estimula ritmo, sonidos y expresión.',
    'singMoveRec':
        'Cante canciones cortas con gestos. Puede usar palmas, movimientos de manos, sonidos suaves o cambios de voz.',
    'singMoveHome':
        'Reto general: cante una canción corta y acompañe con un gesto repetido. Pause un momento para que el niño intente continuar con sonido o movimiento.',
    'singMoveParent':
        'La repetición ayuda mucho. Es mejor una canción sencilla repetida varios días que muchas canciones distintas.',
'childPhoto': 'Foto del niño',
'addPhoto': 'Agregar foto',
'changePhoto': 'Cambiar foto',
'removePhoto': 'Quitar foto',
    'talkTitle': 'Conversar',
    'talkDesc':
        'Fortalece la intención de comunicarse.',
    'talkRec':
        'Responda a los sonidos, gestos o miradas del niño como si fueran parte de una conversación. Eso le enseña que comunicarse tiene valor.',
    'talkHome':
        'Reto general: observe qué hace el niño y descríbalo con voz tranquila. Espere unos segundos para darle oportunidad de responder con mirada, gesto o sonido.',
    'talkParent':
        'No llene todos los silencios. Esperar también ayuda a que el niño intente comunicarse.',
'childNotFound': 'No se encontró el perfil del niño.',
    'imitateSoundsTitle': 'Imitar sonidos',
    'imitateSoundsDesc':
        'Practica sonidos básicos de forma divertida.',
    'imitateSoundsRec':
        'Haga sonidos simples de acciones, objetos o situaciones. No necesita materiales especiales: puede usar sonidos de sorpresa, golpes suaves, vehículos o animales conocidos.',
    'imitateSoundsHome':
        'Reto general: haga 3 sonidos fáciles y espere si el niño intenta copiarlos. Puede usar sonidos como “pa-pa”, “ma-ma”, “toc toc”, “mmm” o “brum”.',
    'imitateSoundsParent':
        'Felicite cualquier intento. No corrija fuerte; repita el sonido correcto con naturalidad.',
// INICIO / DASHBOARD
'homeGreeting': 'Hola 👋',
'homeGreetingSubtitle':
    'Acompaña su crecimiento, salud y aprendizaje desde un solo lugar.',

'selectChild': 'Seleccionar niño',
'tapToChangeChild': 'Toca para cambiar de perfil',
'viewProfile': 'Ver perfil',

'healthSummary': 'Resumen de salud',

'nextVaccine': 'Próxima vacuna',
'viewVaccines': 'Ver vacunas',

'lastGrowthCheck': 'Último control',
'growthDataPending':
    'Todavía no hay controles de peso y talla registrados.',
'viewGrowth': 'Ver crecimiento',

'quickSummary': 'Datos principales',

'homeNoChildTitle':
    'Comienza creando un perfil',
'homeNoChildSubtitle':
    'Registra al primer niño para organizar su crecimiento, vacunas y seguimiento de salud.',
'addFirstChild': 'Registrar primer niño',
    // ENTORNOS PROTECTORES
    'environmentTitle': 'Entornos protectores',
    'environmentHeaderSubtitle':
        'Guía para cuidar la seguridad, salud y bienestar de niños de 0 a 3 años',
    'touchEnvironmentActions':
        'Toca cada sección para ver acciones prácticas',

    'safeSpacesTitle': 'Espacios seguros',
    'safeSpacesSubtitle':
        'Casa preparada para explorar sin riesgo',
    'safeSpacesDesc':
        'Un entorno seguro permite que el niño explore, juegue y aprenda con menos riesgos.',
    'safeSpacesA1':
        'Guarde medicinas, productos de limpieza y objetos pequeños fuera de su alcance.',
    'safeSpacesA2':
        'Cubra enchufes y mantenga cables recogidos.',
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
    'affectionSubtitle':
        'Cuidar también es responder con calma',
    'affectionDesc':
        'El afecto, la paciencia y el buen trato fortalecen la confianza y el desarrollo emocional.',
    'affectionA1':
        'Abrácelo, háblele con calma y responda a sus necesidades.',
    'affectionA2':
        'Valide sus emociones: cansancio, miedo, frustración o alegría.',
    'affectionA3':
        'Evite gritos, golpes o amenazas.',
    'affectionA4':
        'Cuando se equivoque, guíelo con palabras sencillas y tono tranquilo.',
    'affectionAlert':
        'Si el adulto se siente muy estresado, es mejor pedir apoyo antes de reaccionar con enojo.',
'vaccinePreviousDoseRequired':
    'Primero debes registrar la dosis anterior para poder registrar esta vacuna.',
    'healthAlertTitle':
        'Salud y señales de alerta',
    'healthAlertSubtitle':
        'Cuándo buscar ayuda',
    'healthAlertDesc':
        'Observar cambios en el niño permite actuar a tiempo y prevenir complicaciones.',
    'healthAlertA1':
        'Controle fiebre, respiración, alimentación y nivel de energía.',
    'healthAlertA2':
        'Observe golpes, caídas, vómitos, diarrea o rechazo de alimentos.',
    'healthAlertA3':
        'Mantenga controles médicos y vacunas según la edad.',
    'healthAlertA4':
        'No automedique al niño sin indicación profesional.',
    'healthAlertAlert':
        'Busque atención médica si hay dificultad para respirar, fiebre alta, decaimiento extremo, convulsiones, golpes fuertes o signos de deshidratación.',

    'environmentFinalNote':
        'Un entorno protector combina seguridad, afecto, supervisión y rutinas. Pequeñas acciones diarias ayudan a que el niño crezca con confianza y bienestar.',
        // TEXTOS INTERNOS DE CURVAS DE CRECIMIENTO
'growthSvgResult':
    'Resultado',

'growthSvgAgeX':
    'Edad/X',

'growthSvgTrajectory':
    'Trayectoria',

'growthSvgCalculatedResult':
    'Resultado calculado',

'growthSvgMedian':
    'Mediana',

'growthSvgPercentile':
    'Percentil',

'growthSvgBirth':
    'Nacimiento',
  };

  static final Map<String, String> _english = {
    // GENERAL
    'appName': 'Wawa Kalú',
    'subtitle':
        'Learn by playing, exploring, and growing as a family',
    'settingsTitle': 'Settings',
    'enabled': 'Enabled',
    'disabled': 'Disabled',
    'startApp': 'Start',
    'startingApp': 'Starting...',

// INTERNAL GROWTH CHART TEXT
'growthSvgResult':
    'Result',

'growthSvgAgeX':
    'Age/X',

'growthSvgTrajectory':
    'Trajectory',

'growthSvgCalculatedResult':
    'Calculated Result',

'growthSvgMedian':
    'Median',

'growthSvgPercentile':
    'Percentile',

'growthSvgBirth':
    'Birth',
    
    // INFORMATION
    'aboutApp': 'About the app',
    'aboutAppSubtitle':
        'Wawa Kalú is an educational children’s app that combines games, sounds, vibration, and interactive activities to support early learning.',
    'close': 'Close',

    // SETTINGS
    'sounds': 'Sounds',
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
    'languageAutomatic': 'Automatic',
    'languageAutoSubtitle': 'Based on phone language',

    // WELCOME
    'welcomeScreenTitle': 'Welcome to',
    'welcomeSettingsNote':
        'You can change language, sounds, vibration, and appearance from the gear icon.',

    // HOME
    'games': 'Games',
    'nutrition': 'Nutrition',
    'languageMenu': 'Language',

    // GAMES PAGE
    'gamesPageTitle': 'Game Zone',
    'gamesPageSubtitle': 'Learning through play',
    'gamesPageDescription':
        'Explore activities created so children can learn with games, colors, animals, questions, and simple challenges.',
    'playNow': 'Play now',
    'availableGames': 'Available games',
    'gameBenefits': 'Game benefits',
    'gameBenefit1':
        'Stimulates attention and observation.',
    'gameBenefit2':
        'Supports recognition of sounds, colors, and shapes.',
    'gameBenefit3':
        'Promotes learning through interaction.',
    'gameBenefit4':
        'Allows learning in a simple and entertaining way.',

    'patyGameCardTitle': 'Paty Game',
    'patyGameCardSubtitle':
        'Custom game created by Paty',
    'patyGameCardDescription':
        'Visual and interactive activity to strengthen attention, observation, and learning through simple stimuli.',

    'andresGameCardTitle': 'Andrés Game',
    'andresGameCardSubtitle':
        'Trivia created by Andrés',
    'andresGameCardDescription':
        'Trivia-style game to answer questions, recognize elements, and learn through interactive challenges.',
// VACCINES - SCHEDULE
'vaccinesScheduleTitle':
    'Vaccination schedule',
'vaccinesScheduleSubtitle':
    'Reference based on Ecuador MSP’s 2026 national vaccination schedule.',

'vaccinesLoadError':
    'The vaccination schedule could not be loaded.',

'vaccineApplied': 'Administered',
'vaccineUpcoming': 'Upcoming',
'vaccineReview': 'Needs review',
'vaccineSeasonalReview':
    'Review seasonal vaccination',
'vaccineWaitingPrevious':
    'Waiting for previous dose',

'registerVaccine':
    'Register vaccine',
'editVaccineRecord':
    'Edit record',
'vaccineAppliedDate':
    'Administration date',
'healthCenterOptional':
    'Health center (optional)',
'notesOptional':
    'Notes (optional)',
'saveVaccineRecord':
    'Save administration',
'deleteVaccineRecord':
    'Delete record',
'deleteVaccineRecordQuestion':
    'Are you sure you want to delete this vaccination record?',

'vaccinesDisclaimer':
    'This tracking tool is for guidance only and does not replace the vaccination card or assessment by a health professional. If doses are pending, records are incomplete, or you have questions about the schedule, consult a health facility.',

// DOSES
'vaccineSingleDose': 'Single dose',
'vaccineBirthDose': 'Birth dose',
'vaccineDose1': 'First dose',
'vaccineDose2': 'Second dose',
'vaccineDose3': 'Third dose',
'vaccineDose6Months':
    '6-month dose',
'vaccineDose15Months':
    '15-month dose',
'vaccineDose18Months':
    '18-month dose',
'vaccineDose5Years':
    '5-year dose',
'vaccineSeasonalDose':
    'Seasonal vaccination',

'vaccineBirth24Hours':
    'Preferably within the first 24 hours of life.',
'vaccineSeasonalNote':
    'The date depends on the current seasonal vaccination strategy.',

// VACCINE NAMES
'vaccineBCG': 'BCG',
'vaccineHepatitisBZero':
    'Hepatitis B - birth dose',
'vaccineRotavirus':
    'Rotavirus',
'vaccineHexavalent':
    'Hexavalent',
'vaccinePneumococcal':
    'Pneumococcal',
'vaccineBOPV':
    'Polio (bOPV)',
'vaccineInfluenza':
    'Seasonal influenza',
'vaccineYellowFever':
    'Yellow fever',
'vaccineMMR':
    'MMR',
'vaccineVaricella':
    'Varicella',
'vaccineDPT':
    'DPT',

// DISEASES PREVENTED
'vaccineBCGPrevents':
    'Helps prevent severe forms of tuberculosis.',
'vaccineHepatitisBPrevents':
    'Helps prevent hepatitis B.',
'vaccineRotavirusPrevents':
    'Helps prevent severe rotavirus disease.',
'vaccineHexavalentPrevents':
    'Protects against several vaccine-preventable diseases.',
'vaccinePneumococcalPrevents':
    'Helps prevent pneumococcal disease.',
'vaccinePolioPrevents':
    'Helps prevent poliomyelitis.',
'vaccineInfluenzaPrevents':
    'Helps prevent influenza.',
'vaccineYellowFeverPrevents':
    'Helps prevent yellow fever.',
'vaccineMMRPrevents':
    'Helps prevent measles, mumps, and rubella.',
'vaccineVaricellaPrevents':
    'Helps prevent varicella.',
'vaccineDPTPrevents':
    'Helps prevent diphtheria, pertussis, and tetanus.',
    'davidGameCardTitle': 'David Game',
    'davidGameCardSubtitle':
        'Color and animal game for young children',
    'davidGameCardDescription':
        'Interactive game where the child taps animals, listens to their sounds, and earns stars or medals based on correct touches.',
// WHO GROWTH CHARTS

'viewGrowthCharts':
    'View growth charts',

'growthChartsTitle':
    'Growth charts',

'whoChildGrowthStandards':
    'WHO Child Growth Standards 0–5 years',

'whoGrowthReferenceNote':
    'The charts use WHO Child Growth Standards for girls and boys from birth to 5 years. The plotted points correspond to measurements registered in Wawa Kalú.',

'weightForAgeChart':
    'Weight-for-age',

'weightForAgeChartDescription':
    'Compares the child’s weight progression with reference curves according to age.',

'heightForAgeChart':
    'Length/height-for-age',

'heightForAgeChartDescription':
    'Compares registered length or height with reference curves according to age.',

'weightForLengthChart':
    'Weight-for-length',

'weightForLengthChartDescription':
    'Relates weight to recumbent length during the first years of life.',

'weightForHeightChart':
    'Weight-for-height',

'weightForHeightChartDescription':
    'Relates weight to standing height.',

'bmiForAgeChart':
    'BMI-for-age',

'bmiForAgeChartDescription':
    'Shows body mass index progression according to age.',

'growthChartZoomHint':
    'You can zoom and move the chart to view it in more detail.',

'growthChartNoData':
    'There are no compatible measurements for this chart.',

'growthChartsNoMeasurements':
    'There is no data to chart yet',

'growthChartsNoMeasurementsSubtitle':
    'Register at least one weight and length or height measurement to begin.',

'growthChartsLoadError':
    'Growth charts could not be loaded.',

'growthChartRenderError':
    'This chart could not be generated from the registered data.',

'growthNoValidWhoMeasurements':
    'The registered measurements are outside the valid range for the WHO 0–5 year growth standards.',

'growthSkippedMeasurements':
    '{count} measurement(s) could not be used in the WHO charts and were skipped.',

'growthChartDisclaimer':
    'Growth charts support monitoring but do not provide a diagnosis by themselves. Clinical interpretation should be performed by a health professional.',

'age':
    'Age',

'weightKgShort':
    'Weight (kg)',

'heightCmShort':
    'Height (cm)',

'lengthCmShort':
    'Length (cm)',

'bmiShort':
    'BMI',

'refresh':
    'Refresh',
    // GENERAL GAME / PATY
    'gameTitle': 'Shape game',
    'gameSubtitle': 'Tap, observe, and learn',
    'gameDescription':
        'Tap each shape to recognize its name, color, and form in a visual and interactive way.',
    'touchFigure': 'Tap a shape to start',
    'correctFigure': 'You selected:',
    'hits': 'Hits',
    'resetGame': 'Reset game',
    'figureRewardDefault':
        'Keep tapping shapes to win rewards',
    'figureRewardStar':
        'You won a star for your hits!',
    'figureRewardMedal':
        'Excellent! You won a shape medal',
    'figureInstructions':
        'Look at the shapes, tap one, and listen or watch the response on screen.',
// GROWTH - RECORDS
'registerGrowthControl':
    'Register measurement',
// PRIVACY

'privacyAndData':
    'Privacy and data',

'privacySettingsSubtitle':
    'Local data and deletion',

'privacyTitle':
    'Your information remains under your control',

'privacyDescription':
    'Wawa Kalú stores child profiles and their records on the device so they can be used without depending on an internet connection.',

'localStorageTitle':
    'Local storage',

'localStorageDescription':
    'Child profiles, vaccine records and growth measurements are stored locally on this device.',

'storedDataTitle':
    'Stored information',

'storedDataDescription':
    'The app may store the child’s name, date of birth, sex, vaccine records, weight, length or height, and notes you entered.',

'notificationPrivacyTitle':
    'Local reminders',

'notificationPrivacyDescription':
    'Vaccine reminders are scheduled through the device notification system. They can be disabled from the vaccine module.',

'dataManagement':
    'Data management',

'dataManagementDescription':
    'You can delete child profiles and all health information registered in Wawa Kalú.',

'deleteAllChildDataTitle':
    'Delete all child data',

'deleteAllChildDataDescription':
    'This action deletes every child profile, registered vaccine and growth measurement stored on the device.',

'deleteAllChildDataQuestion':
    'Are you sure you want to delete all child profiles and their data? This action cannot be undone.',

'deleteAllData':
    'Delete all data',

'allChildDataDeleted':
    'All child data was deleted.',

'deleteAllDataError':
    'All data could not be deleted. Please try again.',

'privacyFinalNote':
    'General app preferences, such as language and theme, are not deleted when child data is removed.',
'editGrowthControl':
    'Edit measurement',

'saveGrowthControl':
    'Save measurement',

'latestGrowthControl':
    'Latest measurement',

'growthHistory':
    'Measurement history',

'noGrowthControls':
    'No measurements have been registered yet',

'noGrowthControlsSubtitle':
    'Register the child’s weight and height or length to begin tracking growth.',

'growthControlDate':
    'Measurement date',

'weight': 'Weight',

'weightKg':
    'Weight in kilograms',

'height': 'Height',

'length': 'Length',

'heightCm':
    'Length or height in centimeters',

'weightRequired':
    'Enter the weight.',

'weightInvalid':
    'Check the entered weight value.',

'heightRequired':
    'Enter the length or height.',

'heightInvalid':
    'Check the entered length or height value.',

'measurementMethod':
    'Measurement method',

'measurementMethodDescription':
    'Select how the measurement was taken. This will be important for correctly interpreting the growth charts.',

'recumbentLength':
    'Recumbent length',

'standingHeight':
    'Standing height',

'growthNotesHint':
    'E.g. Measurement taken at the health center',

'deleteGrowthControl':
    'Delete measurement',

'deleteGrowthControlQuestion':
    'Are you sure you want to delete this growth measurement?',

'growthLoadError':
    'Growth measurements could not be loaded.',

'growthChartsNextStep':
    'These measurements will be used in weight-for-age, height-for-age, and other growth charts in the next step.',
    // DAVID GAME
    'gameDavid': 'David Game',
    'davidTitle': 'Animal game',
    'davidSubtitleSound':
        'Tap an animal and listen to its sound',
    'davidSubtitleNoSound':
        'Tap an animal and learn without sound',
    'touchAnimal':
        'Tap an animal to play',
    'correctAnimal': 'You selected:',
    'dog': 'Dog',
    'cat': 'Cat',
    'chick': 'Chick',
    'cow': 'Cow',

    // DAVID GAME REWARDS
    'zooRewardsTitle': 'Zoo rewards',
    'zooRewardDefault':
        'Play with the animals to win rewards',
    'zooRewardStar':
        'Great job! You won an animal star',
    'zooRewardMedal':
        'Excellent! You won an animal medal',
    'zooRewardBoth':
        'Amazing! You won a star and a medal',
    'zooStars': 'Stars',
    'zooMedals': 'Medals',
    'zooNextStar': 'Next star',
    'zooNextMedal': 'Next medal',
    'zooMissingForStar': 'Missing',
    'zooAnimalsForStar':
        'animals to win a star',
    'zooMissingForMedal': 'Missing',
    'zooAnimalsForMedal':
        'animals to win a medal',
    'zooStarUnlocked': 'Star unlocked!',
    'zooMedalUnlocked': 'Medal unlocked!',

    // NUTRITION
    'nutritionChildTitle': 'Child nutrition',
    'nutritionChildSubtitle':
        'Practical guide for parents and caregivers of children from 0 to 3 years old',
    'touchSectionRecommendations':
        'Tap each section to see recommendations',

    'nutritionFoodsTitle':
        'Foods and recipes',
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
'vaccineExpectedDate':
    'Expected date',

'vaccineReferenceDate':
    'Reference date',
'vaccineRemindersTitle':
    'Vaccine reminders',

'vaccineRemindersSubtitle':
    'Receive reminders before expected vaccination dates.',

'vaccineRemindersSchedule':
    'Notifications 7 days before, 1 day before, and on the same day.',

'vaccineRemindersEnabledMessage':
    'Vaccine reminders are enabled.',

'vaccineRemindersDisabledMessage':
    'Vaccine reminders are disabled.',

'notificationPermissionDenied':
    'Notification permission was not granted.',

'testNotification':
    'Test notification',
'homeHealthLoading':
    'Updating health information...',

'homeHealthLoadError':
    'This information could not be updated.',

'homeVaccinesNoPending':
    'There are no pending doses in the current tracking schedule.',

'deleteChildError':
    'The profile could not be deleted. Please try again.',
'vaccineNotificationTitle':
    '{name}’s vaccine 💉',

'vaccineNotification7Days':
    'In one week, review {name}’s {vaccine} vaccine.',

'vaccineNotificationTomorrow':
    'Tomorrow, review {name}’s {vaccine} vaccine.',

'vaccineNotificationToday':
    'Today, review {name}’s {vaccine} vaccine.',
'vaccineDaysRemaining':
    '{days} days remaining',

'vaccineTomorrow':
    'Expected tomorrow',
'childPhoto': 'Child photo',
'addPhoto': 'Add photo',
'changePhoto': 'Change photo',
'removePhoto': 'Remove photo',
'vaccineToday':
    'Review today',

'vaccineDatePassed':
    'The reference date has passed',
    'nutritionRoutineTitle':
        'Mealtime routines',
    'nutritionRoutineSubtitle':
        'Calm schedules to build habits',
    'nutritionRoutineTip1':
        'Keep similar times for breakfast, lunch, snacks, and dinner.',
    'nutritionRoutineTip2':
        'Avoid letting the child become too hungry, as they may become upset or reject the food.',
    'nutritionRoutineTip3':
        'Try to make mealtime calm and pressure-free.',
    'nutritionRoutineTip4':
        'Eating as a family helps the child imitate healthy habits.',
    'nutritionRoutineTip5':
        'Avoid screens during meals so the child can recognize hunger and fullness.',

    'nutritionHydrationTitle':
        'Healthy hydration',
    'nutritionHydrationSubtitle':
        'Water and suitable drinks',
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

    'nutritionSignalsTitle':
        'Child signals',
    'nutritionSignalsSubtitle':
        'Hunger, fullness, and acceptance',
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

    'nutritionSafetyTitle':
        'Eating safety',
    'nutritionSafetySubtitle':
        'Choking prevention',
    'nutritionSafetyTip1':
        'Always supervise the child while eating.',
    'nutritionSafetyTip2':
        'Avoid hard, round, or very small foods unless properly cut.',
    'nutritionSafetyTip3':
        'Cut fruits and soft foods into safe sizes.',
    'nutritionSafetyTip4':
        'Do not let the child eat while lying down, running, or playing.',
    'nutritionSafetyTip5':
        'Avoid whole grapes, hard candies, whole nuts, and large food pieces.',

    'nutritionParentsTitle':
        'Tips for parents',
    'nutritionParentsSubtitle':
        'Support without pressure',
    'nutritionParentsTip1':
        'Patience is key: not all children eat the same way or at the same pace.',
    'nutritionParentsTip2':
        'Avoid using food as a reward or punishment.',
    'nutritionParentsTip3':
        'Offer colorful and simple meals to spark curiosity.',
    'nutritionParentsTip4':
        'Do not compare the child with others; observe their own progress.',
    'nutritionParentsTip5':
        'If there is low weight, allergies, frequent vomiting, or persistent food rejection, consult a healthcare professional.',

    'recipesForChildren':
        'Recipes for children from 0 to 3 years old',
    'recipesShortDesc':
        'Soft, safe, and easy preparations for home.',
    'viewRecipes': 'View recipes',
    'nutritionFinalNote':
        'Good nutrition supports the child’s growth. Offer varied, safe foods that are suitable for their age. If there are allergies, low weight, or frequent food rejection, consult a healthcare professional.',

    // RECIPES
    'recipesAppBar': 'Child nutrition',
    'recipesHeaderTitle': 'Child nutrition',
    'recipesHeaderSubtitle':
        'Soft, safe, and nutritious recipes for children from 0 to 3 years old',
    'recipesHeaderNote':
        'Ideas designed for parents and caregivers',
    'ingredients': 'Ingredients',
    'preparation': 'Preparation',
    'recipeFinalNote':
        'These recipes are general ideas. Adjust texture, portion size, and ingredients according to age, tolerance, and pediatric guidance.',

    'recipe1Title':
        'Pumpkin and chicken cream',
    'recipe1Age': 'From 6 months',
    'recipe1Moment': 'Lunch',
    'recipe1Desc':
        'A soft, warm, and nutritious recipe to introduce more complete meals.',
    'recipe1Ing1': 'Cooked pumpkin.',
    'recipe1Ing2':
        'A small piece of well-cooked chicken.',
    'recipe1Ing3':
        'Small potato or sweet potato.',
    'recipe1Ing4':
        'Warm water or natural unsalted broth.',
    'recipe1Step1':
        'Cook the pumpkin, potato or sweet potato, and chicken well.',
    'recipe1Step2':
        'Shred the chicken to avoid large pieces.',
    'recipe1Step3':
        'Mash or blend everything until smooth.',
    'recipe1Step4':
        'Serve warm and in a small portion.',
    'recipe1Rec':
        'Ideal once the child has started complementary feeding. Do not add salt or strong seasonings.',

    'recipe2Title':
        'Creamy oatmeal with banana',
    'recipe2Age': 'From 6 months',
    'recipe2Moment':
        'Breakfast or mid-morning',
    'recipe2Desc':
        'Energetic, soft, and easy to prepare. Good to start the day.',
    'recipe2Ing1':
        '3 tablespoons of oatmeal.',
    'recipe2Ing2':
        '1 small ripe banana.',
    'recipe2Ing3':
        'Water or age-appropriate milk.',
    'recipe2Ing4':
        'A minimal amount of cinnamon, optional if tolerated.',
    'recipe2Step1':
        'Cook the oatmeal until very soft.',
    'recipe2Step2':
        'Mash the banana into a purée.',
    'recipe2Step3':
        'Mix the oatmeal with the banana.',
    'recipe2Step4':
        'Let it cool before serving.',
    'recipe2Rec':
        'Do not use honey before one year of age. Do not add sugar; banana already provides natural sweetness.',

    'recipe3Title':
        'Soft egg and spinach omelet',
    'recipe3Age':
        'From 9 to 12 months',
    'recipe3Moment':
        'Breakfast, lunch, or light dinner',
    'recipe3Desc':
        'A soft option for children who already tolerate egg and firmer textures.',
    'recipe3Ing1':
        '1 well-cooked egg.',
    'recipe3Ing2':
        'Very finely chopped spinach leaves.',
    'recipe3Ing3':
        'One teaspoon of oil.',
    'recipe3Ing4':
        'Optional cooked potato or carrot.',
    'recipe3Step1':
        'Beat the egg and mix it with chopped spinach.',
    'recipe3Step2':
        'Cook over low heat until fully cooked.',
    'recipe3Step3':
        'Cut into small, soft pieces.',
    'recipe3Step4':
        'Serve with purée or soft vegetables.',
    'recipe3Rec':
        'The egg must be fully cooked. If there is a history of allergies, consult the pediatrician first.',

    'recipe4Title':
        'Soft rice and lentil balls',
    'recipe4Age':
        'From 10 to 12 months',
    'recipe4Moment':
        'Lunch or savory snack',
    'recipe4Desc':
        'Small soft portions to practice grasping and safe chewing.',
    'recipe4Ing1':
        'Well-cooked rice.',
    'recipe4Ing2':
        'Well-cooked lentils.',
    'recipe4Ing3':
        'Cooked and mashed carrot.',
    'recipe4Ing4':
        'A little warm water if needed to soften.',
    'recipe4Step1':
        'Mash the lentils and mix with soft rice.',
    'recipe4Step2':
        'Add cooked carrot for texture and flavor.',
    'recipe4Step3':
        'Form small, soft balls.',
    'recipe4Step4':
        'Make sure they break apart easily when pressed.',
    'recipe4Rec':
        'Serve with supervision. The balls should be small, soft, and easy to mash.',

    'recipe5Title':
        'Natural yogurt cup with fruit',
    'recipe5Age': 'From 12 months',
    'recipe5Moment': 'Snack',
    'recipe5Desc':
        'A fresh, colorful, and easy snack for children who already tolerate dairy.',
    'recipe5Ing1':
        'Unsweetened natural yogurt.',
    'recipe5Ing2':
        'Ripe fruit, chopped or mashed.',
    'recipe5Ing3':
        'Optional soft oatmeal.',
    'recipe5Step1':
        'Place a small portion of natural yogurt.',
    'recipe5Step2':
        'Add ripe mashed fruit or safe fruit pieces.',
    'recipe5Step3':
        'Mix gently.',
    'recipe5Step4':
        'Serve cold, but not too chilled.',
    'recipe5Rec':
        'Avoid sweetened yogurts. Supervise if using fruit pieces.',

    // LANGUAGE
    'languageTitle':
        'Language and communication',
    'languageHeaderSubtitle':
        'Simple activities to stimulate first words',
    'touchActivityRecommendation':
        'Tap an activity and see the recommendation',
    'selectActivity':
        'Select an activity',
    'languageDefaultRec':
        'Tap a card to see how to stimulate the child’s language at home.',
    'languageDefaultHome':
        'A simple activity will appear here and can be adapted to any object, image, or moment of the day.',
    'languageDefaultParent':
        'Remember to speak calmly, look at the child, and celebrate communication attempts.',
    'homeActivity':
        'Home activity',
    'noActivityReviewed':
        'No activity has been reviewed yet.',
    'activitiesReviewed':
        'Activities reviewed',
    'languageFinalNote':
        'Each child develops language at their own pace. If they do not respond to sounds, do not look when spoken to, or lose acquired skills, consult a professional.',
// CHILD PROFILES
'childrenHeaderTitle': 'Your children',
'childrenHeaderSubtitle':
    'Select a profile or register a new child.',
'childProfile': 'Child profile',
'childName': 'Name or nickname',
'childNameHint': 'E.g. Sofia',
'childNameRequired':
    'Enter the child’s name or nickname.',
'birthDate': 'Date of birth',
'selectBirthDate': 'Select date of birth',
'selectDate': 'Select date',
'birthDateRequired':
    'Select the date of birth.',
'sex': 'Sex',
'sexForGrowthCurves':
    'Sex for growth charts',
'sexForGrowthCurvesDescription':
    'This information is used to select the corresponding growth chart.',
'sexRequired':
    'Select boy or girl.',
'boy': 'Boy',
'girl': 'Girl',
'saveChild': 'Save profile',
'editChild': 'Edit profile',
'saveChanges': 'Save changes',
'deleteChild': 'Delete profile',
'deleteChildConfirmation':
    'Are you sure you want to delete {name}’s profile? This action cannot be undone.',
'delete': 'Delete',
'edit': 'Edit',
'cancel': 'Cancel',
'accept': 'Accept',
'selectThisChild': 'Select this child',
'activeChild': 'Selected child',
'childHealth': 'Health and tracking',
'childNotFound': 'The child profile could not be found.',
// AGE
'year': 'year',
'years': 'years',
'month': 'month',
'months': 'months',
'day': 'day',
'days': 'days',
'active': 'Active',
    'nameObjectsTitle':
        'Name objects',
    'nameObjectsDesc':
        'Connects words with real things.',
    'nameObjectsRec':
        'Name nearby objects using short and clear phrases. You can use anything available: clothes, food, toys, utensils, or body parts.',
    'nameObjectsHome':
        'General challenge: choose 3 things near the child, point to them, and say their names slowly. Then wait to see if the child looks, points, or tries to repeat.',
    'nameObjectsParent':
        'It does not matter if the child cannot pronounce well yet. What matters is listening, associating, and participating.',

    'readImagesTitle':
        'Read images',
    'readImagesDesc':
        'Improves attention, memory, and vocabulary.',
    'readImagesRec':
        'Use any storybook, worksheet, photo, or image. It does not need to include specific things; you can describe colors, people, objects, or actions.',
    'readImagesHome':
        'General challenge: look at an image with the child and describe what appears. Use simple questions like: “What do you see?”, “Where is it?”, “What is it doing?”.',
    'readImagesParent':
        'If the child does not answer with words, looking, pointing, smiling, or making sounds also counts.',

    'singMoveTitle':
        'Sing and move',
    'singMoveDesc':
        'Stimulates rhythm, sounds, and expression.',
    'singMoveRec':
        'Sing short songs with gestures. You can use claps, hand movements, soft sounds, or voice changes.',
    'singMoveHome':
        'General challenge: sing a short song and add a repeated gesture. Pause briefly so the child can try to continue with a sound or movement.',
    'singMoveParent':
        'Repetition helps a lot. One simple song repeated for several days is better than many different songs.',

    'talkTitle': 'Talk',
    'talkDesc':
        'Strengthens the intention to communicate.',
    'talkRec':
        'Respond to the child’s sounds, gestures, or looks as if they were part of a conversation. This teaches that communication has value.',
    'talkHome':
        'General challenge: observe what the child is doing and describe it calmly. Wait a few seconds to give them a chance to respond with a look, gesture, or sound.',
    'talkParent':
        'Do not fill every silence. Waiting also helps the child try to communicate.',

    'imitateSoundsTitle':
        'Imitate sounds',
    'imitateSoundsDesc':
        'Practices basic sounds in a fun way.',
    'imitateSoundsRec':
        'Make simple sounds from actions, objects, or situations. No special materials are needed: you can use surprise sounds, soft knocks, vehicles, or familiar animals.',
    'imitateSoundsHome':
        'General challenge: make 3 easy sounds and wait to see if the child tries to copy them. You can use sounds like “pa-pa”, “ma-ma”, “knock knock”, “mmm”, or “vroom”.',
    'imitateSoundsParent':
        'Praise any attempt. Do not correct harshly; repeat the correct sound naturally.',

    // PROTECTIVE ENVIRONMENTS
    'environmentTitle':
        'Protective environments',
    'environmentHeaderSubtitle':
        'Guide to care for the safety, health, and well-being of children from 0 to 3 years old',
    'touchEnvironmentActions':
        'Tap each section to see practical actions',

    'safeSpacesTitle':
        'Safe spaces',
    'safeSpacesSubtitle':
        'A home prepared for safe exploration',
    'safeSpacesDesc':
        'A safe environment allows the child to explore, play, and learn with fewer risks.',
    'safeSpacesA1':
        'Keep medicines, cleaning products, and small objects out of reach.',
    'safeSpacesA2':
        'Cover outlets and keep cables organized.',
    'safeSpacesA3':
        'Avoid leaving sharp, hot, or heavy objects on table edges.',
    'safeSpacesA4':
        'Check the floor to remove small pieces the child could put in their mouth.',
    'safeSpacesAlert':
        'Pay special attention to stairs, kitchen, bathroom, outlets, and small objects.',
'vaccinePreviousDoseRequired':
    'You must register the previous dose before you can register this vaccine.',
    'activeSupervisionTitle':
        'Active supervision',
    'activeSupervisionSubtitle':
        'Stay present without distractions',
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

    'protectiveRoutinesTitle':
        'Protective routines',
    'protectiveRoutinesSubtitle':
        'Order, rest, and calm',
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

// MAIN NAVIGATION
'navHome': 'Home',
'navChildren': 'My children',
'navHealth': 'Health',
'navLearning': 'Learn',

// MY CHILDREN
'myChildren': 'My children',
'noChildrenRegistered':
    'You have not registered any children yet',
'childrenEmptyDescription':
    'Here you can register one or more children and keep their growth and health information separately.',
'addChild': 'Add child',

// HEALTH
'health': 'Health',
'healthHeaderTitle':
    'Support their growth and well-being',
'healthHeaderSubtitle':
    'All health information will be organized in one place.',
'vaccines': 'Vaccines',
'vaccinesSubtitle':
    'Schedule, administered doses, and upcoming vaccines',
'growth': 'Growth',
'growthSubtitle':
    'Weight, height, and child development',
'healthNutritionSubtitle':
    'Child nutrition tips and guidance',

// LEARNING
'learning': 'Learn',
'learningHeaderTitle':
    'Learn and grow',
'learningHeaderSubtitle':
    'Activities to support children’s learning and development.',
'learningGamesSubtitle':
    'Educational and interactive activities',
'learningLanguageSubtitle':
    'Communication and stimulation',
'protectiveEnvironments':
    'Protective environments',
'learningEnvironmentSubtitle':
    'Child care, well-being, and protection',
    // HOME / DASHBOARD
'homeGreeting': 'Hello 👋',
'homeGreetingSubtitle':
    'Support their growth, health, and learning from one place.',

'selectChild': 'Select child',
'tapToChangeChild': 'Tap to change profile',
'viewProfile': 'View profile',

'healthSummary': 'Health summary',

'nextVaccine': 'Next vaccine',
'viewVaccines': 'View vaccines',

'lastGrowthCheck': 'Latest check-up',
'growthDataPending':
    'No weight or height measurements have been registered yet.',
'viewGrowth': 'View growth',

'quickSummary': 'Main information',
// HEALTH - ORGANIZATION
'healthTrackingTitle':
    'Child health tracking',
'healthGuidanceTitle':
    'Nutrition and guidance',
'healthOfChild':
    '{name}’s health',
'healthNoChild':
    'Register a child to begin health tracking.',

'recipes': 'Recipes',
'healthRecipesSubtitle':
    'Meal ideas and preparations for children',

// PROFILE REQUIRED
'healthProfileRequiredTitle':
    'Register a child first',
'healthProfileRequiredSubtitle':
    'A child profile is required to correctly associate vaccines and growth measurements.',

// VACCINES
'vaccinesPageTitle':
    'Vaccines',

// GROWTH
'growthPageTitle':
    'Growth',
'homeNoChildTitle':
    'Start by creating a profile',
'homeNoChildSubtitle':
    'Register the first child to organize their growth, vaccines, and health tracking.',
'addFirstChild': 'Register first child',
    'affectionTitle':
        'Affection and respectful care',
    'affectionSubtitle':
        'Caring also means responding calmly',
    'affectionDesc':
        'Affection, patience, and respectful care strengthen trust and emotional development.',
    'affectionA1':
        'Hug the child, speak calmly, and respond to their needs.',
    'affectionA2':
        'Validate emotions: tiredness, fear, frustration, or joy.',
    'affectionA3':
        'Avoid shouting, hitting, or threats.',
    'affectionA4':
        'When the child makes a mistake, guide them with simple words and a calm tone.',
    'affectionAlert':
        'If the adult feels very stressed, it is better to ask for support before reacting with anger.',
'appVersion': 'Version',
'developers': 'Developers',
    'healthAlertTitle':
        'Health and warning signs',
    'healthAlertSubtitle':
        'When to seek help',
    'healthAlertDesc':
        'Observing changes in the child helps you act in time and prevent complications.',
    'healthAlertA1':
        'Monitor fever, breathing, feeding, and energy level.',
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
  };
}