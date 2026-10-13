import 'app_config.dart';

class T {
  T._();

  static String txt(String key) {
    final String lang = AppConfig.idioma.value;

    final Map<String, String> selected;

    switch (lang) {
      case 'en':
        selected = _english;
        break;
      case 'qu':
        selected = _kichwa;
        break;
      case 'es':
      default:
        selected = _spanish;
        break;
    }

    // Si falta una traducción, se usa español como respaldo.
    return selected[key] ?? _spanish[key] ?? key;
  }

  static bool hasKey(String key) => _spanish.containsKey(key);

  static Set<String> get spanishKeys => Set<String>.unmodifiable(_spanish.keys);

  static Set<String> get englishKeys => Set<String>.unmodifiable(_english.keys);

  static Set<String> get kichwaKeys => Set<String>.unmodifiable(_kichwa.keys);

  static final Map<String, String> _spanish = <String, String>{
    'childHealthSubtitle': 'Vacunas y crecimiento usan este mismo perfil, sin crear registros duplicados.',
    'learningHeroEyebrow': 'ACOMPAÑAR · DESCUBRIR · CUIDAR',
    'learningHubTitle': 'Acompaña cada descubrimiento',
    'learningHubSubtitle': 'Actividades y orientaciones claras para aprender, comunicarse y crecer en un entorno seguro.',
    'learningChooseTitle': '¿Qué quieres acompañar hoy?',
    'learningChooseSubtitle': 'Cada espacio tiene un propósito distinto para evitar contenidos repetidos.',
    'learningActivitiesBadge': 'ACTIVIDADES POR EDAD',
    'learningGuidanceBadge': 'ORIENTACIÓN PARA CUIDADORES',
    'nutritionOrientationTab': 'Orientación',
    'nutritionIntegratedSubtitle': 'Consejos y recetas reunidos en un solo lugar para acompañar su alimentación.',
    'healthTrackingSubtitle': 'Registros personales del niño seleccionado.',
    'healthGuidanceSubtitle': 'Orientación cotidiana sin repetir accesos ni pantallas.',
    'healthNutritionIntegratedSubtitle': 'Consejos de alimentación y recetas en una sola sección',
    'childrenHubTitle': 'Cada peque, su propio espacio',
    'childrenHubSubtitle': 'Perfiles separados para organizar crecimiento, vacunas y accesos útiles según su etapa.',
    'childrenProfilesTitle': 'Perfiles de tu familia',
    'childrenProfilesSubtitle': 'Toca un perfil para ver su información y herramientas relacionadas.',
    'childrenContextNotice': 'Mis niños no duplica Salud ni Aprender: desde cada perfil abre las mismas herramientas con el niño seleccionado.',
    'childPersonalizedForAge': 'Para acompañar su etapa',
    'childPersonalizedSubtitle': 'Accesos a las mismas guías de Aprender y Nutrición, usando este perfil como contexto.',
    'childLearningShortcutSubtitle': 'Actividades y orientaciones para acompañar su desarrollo',
    'childNutritionShortcutSubtitle': 'Alimentación y recetas reunidas en Nutrición',
    'learningExploreTitle': 'Explora a su lado',
    'learningExploreSubtitle': 'Tres espacios para descubrir, conversar y cuidar con cariño.',
    'learningFeatured': 'DESTACADO · 1 A 5 AÑOS',
    'learningFamilyNotice': 'Cada niño tiene su propio ritmo. Acompaña sus descubrimientos con juego, escucha y afecto.',
    'languageIdeasTitle': 'Ideas para conversar y conectar',
    'languageRecommendationTitle': '¿Cómo acompañar?',
    'environmentActionsTitle': 'Acciones que protegen',
    'environmentWhatToKnow': '¿Por qué es importante?',
    'nutritionAdviceTitle': 'Pequeños hábitos, grandes cuidados',
    'nutritionPracticalTips': 'Consejos para poner en práctica',
    'recipesIdeasTitle': 'Ideas para cocinar en familia',
    'guideAreaExplore': "Exploración sensorial",
    'guideAreaMove': "Movimiento",
    'guideAreaLanguage': "Lenguaje",
    'guideAreaThink': "Pensamiento",
    'guideAreaCreate': "Creatividad",
    'guideAreaLife': "Vida cotidiana",
    'guideAreaFeel': "Emociones",
    'guideNavTitle': "Guía para familias",
    'guideHeroTag': "PARA MADRES, PADRES Y CUIDADORES",
    'guideHeroTitle': "Pequeños descubrimientos, grandes aprendizajes",
    'guideHeroSubtitle': "Ideas sencillas para acompañar su crecimiento de 1 a 5 años, con materiales que tienes cerca.",
    'guideAgesTitle': "Elige su edad",
    'guideAreasTitle': "¿Qué quieres explorar?",
    'guideAllAges': "Todas las edades",
    'guideAllAreas': "Todas",
    'guideActivitiesTitle': "Actividades para compartir",
    'guideCount': "{count} ideas",
    'guideActivityCta': "Ver guía",
    'guideAge12': "1–2 años",
    'guideAge23': "2–3 años",
    'guideAge34': "3–4 años",
    'guideAge45': "4–5 años",
    'guideMinutes': "min",
    'guideDetails': "Acompañar la actividad",
    'guideGoal': "¿Qué favorece?",
    'guideMaterials': "Materiales en casa",
    'guideSteps': "Paso a paso",
    'guideObserve': "¿Qué puedes observar?",
    'guideAdapt': "Hazlo a su manera",
    'guideSafety': "Primero, su seguridad",
    'guideTipTitle': "Tu compañía es lo más valioso",
    'guideTipText': "No necesitas materiales costosos ni resultados perfectos. Observa, conversa, escucha y deja que el niño marque su ritmo.",
    'guideNoResults': "No hay actividades con estos filtros.",
    'guideResetFilters': "Mostrar todas",
    'guideReadyCount': "{ready}/{total} listos",
    'guideStepProgress': "{done} de {total} pasos",
    'guideRestart': "Reiniciar lista",
    'guideAgeNotice': "Las edades son orientativas. Adapta cada propuesta a sus intereses y capacidades, siempre con acompañamiento adulto.",
    'vaccineApplied': 'APLICADA',
    'vaccineNotApplied': 'NO APLICADA',
    'vaccineUpcoming': 'PRÓXIMA',
    'vaccineReview': 'REQUIERE REVISIÓN',
    'vaccineSeasonalReview': 'REVISAR VACUNACIÓN ESTACIONAL',
    'vaccineWaitingPrevious': 'PENDIENTE DE DOSIS ANTERIOR',
    'vaccineExpectedDate': 'Fecha prevista',
    'vaccineReferenceDate': 'Fecha de referencia',
    'vaccineDaysRemaining': 'Faltan {days} días',
    'vaccineTomorrow': 'Corresponde mañana',
    'vaccineToday': 'Corresponde revisar hoy',
    'vaccineDatePassed': 'La fecha de referencia ya pasó',
    'appName': 'Wawa Kalú',
    'subtitle': 'Descubre, aprende y crece en familia',
    'settingsTitle': 'Configuración',
    'enabled': 'Activado',
    'disabled': 'Desactivado',
    'startApp': 'Comenzar',
    'startingApp': 'Entrando...',
    'navHome': 'Inicio',
    'navChildren': 'Mis niños',
    'navHealth': 'Salud',
    'navLearning': 'Aprender',
    'myChildren': 'Mis niños',
    'noChildrenRegistered': 'Aún no tienes niños registrados',
    'childrenEmptyDescription':
        'Aquí podrás registrar uno o varios niños y llevar su información de crecimiento y salud por separado.',
    'addChild': 'Agregar niño',
    'health': 'Salud',
    'healthHeaderTitle': 'Acompaña su crecimiento y bienestar',
    'healthHeaderSubtitle':
        'Toda la información de salud estará organizada en un solo lugar.',
    'vaccines': 'Vacunas',
    'vaccinesSubtitle': 'Esquema, dosis aplicadas y próximas vacunas',
    'growth': 'Crecimiento',
    'growthSubtitle': 'Peso, talla y evolución del niño',
    'healthNutritionSubtitle': 'Consejos y alimentación infantil',
    'learning': 'Aprender',
    'learningHeaderTitle': 'Aprender y crecer',
    'learningHeaderSubtitle':
        'Actividades para acompañar el aprendizaje y desarrollo del niño.',
    'learningGuideSubtitle': "Actividades prácticas por edad para compartir con materiales cotidianos.",
    'learningLanguageSubtitle': 'Conversación, cuentos, canciones y momentos cotidianos para fortalecer la comunicación',
    'protectiveEnvironments': 'Entornos protectores',
    'learningEnvironmentSubtitle': 'Seguridad, afecto, rutinas y protección para el día a día',
    'aboutApp': 'Acerca de la app',
    'projectFeatures': 'Funciones principales',
    'aboutAppSubtitle':
        "Wawa Kalú acompaña a las familias con orientaciones de salud, crecimiento y actividades para aprender juntos.",
    'close': 'Cerrar',
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
    'welcomeScreenTitle': 'Bienvenido a',
    'welcomeSettingsNote':
        'Puedes cambiar idioma, sonidos, vibración y apariencia desde el engrane.',
    'familyGuide': "Guía para familias",
    'nutrition': 'Nutrición',
    'languageMenu': 'Lenguaje',
    'childrenHeaderTitle': 'Tus niños',
    'childrenHeaderSubtitle': 'Selecciona un perfil o registra un nuevo niño.',
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
    'year': 'año',
    'years': 'años',
    'month': 'mes',
    'months': 'meses',
    'day': 'día',
    'days': 'días',
    'active': 'Activo',
    'viewGrowthCharts': 'Ver curvas de crecimiento',
    'growthChartsTitle': 'Curvas de crecimiento',
    'whoChildGrowthStandards':
        'Estándares de crecimiento infantil OMS 0–5 años',
    'whoGrowthReferenceNote':
        'Las curvas utilizan los estándares de crecimiento infantil de la OMS para niñas y niños de 0 a 5 años. Los puntos corresponden a los controles registrados en Wawa Kalú.',
    'weightForAgeChart': 'Peso para la edad',
    'weightForAgeChartDescription':
        'Compara la evolución del peso del niño con las curvas de referencia según su edad.',
    'heightForAgeChart': 'Longitud/Talla para la edad',
    'heightForAgeChartDescription':
        'Compara la longitud o talla registrada con las curvas de referencia según la edad.',
    'weightForLengthChart': 'Peso para la longitud',
    'weightForLengthChartDescription':
        'Relaciona el peso con la longitud en los controles de los primeros años de vida.',
    'weightForHeightChart': 'Peso para la talla',
    'weightForHeightChartDescription':
        'Relaciona el peso con la talla registrada.',
    'bmiForAgeChart': 'IMC para la edad',
    'bmiForAgeChartDescription':
        'Muestra la evolución del índice de masa corporal en relación con la edad.',
    'growthChartZoomHint':
        'Puedes ampliar y mover la gráfica para verla con mayor detalle.',
    'growthChartNoData': 'No existen controles compatibles para esta gráfica.',
    'growthChartsNoMeasurements': 'Aún no hay datos para graficar',
    'growthChartsNoMeasurementsSubtitle':
        'Registra al menos un control de peso y longitud o talla para comenzar.',
    'growthChartsLoadError': 'No se pudieron cargar las curvas de crecimiento.',
    'growthChartRenderError':
        'No se pudo generar esta gráfica con los datos registrados.',
    'growthNoValidWhoMeasurements':
        'Los controles registrados no se encuentran dentro del rango válido de las curvas OMS de 0 a 5 años.',
    'growthSkippedMeasurements':
        '{count} control(es) no pudieron utilizarse en las curvas OMS y fueron omitidos.',
    'growthChartDisclaimer':
        'Las curvas sirven como apoyo para el seguimiento y no constituyen por sí solas un diagnóstico. La interpretación clínica debe realizarla un profesional de salud.',
    'age': 'Edad',
    'weightKgShort': 'Peso (kg)',
    'heightCmShort': 'Talla (cm)',
    'lengthCmShort': 'Longitud (cm)',
    'bmiShort': 'IMC',
    'refresh': 'Actualizar',
    'nutritionChildTitle': 'Nutrición infantil',
    'nutritionChildSubtitle':
        'Guía práctica para padres y cuidadores de niños de 0 a 3 años',
    'touchSectionRecommendations': 'Toca cada sección para ver recomendaciones',
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
    'vaccineRemindersTitle': 'Recordatorios de vacunas',
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
    'testNotification': 'Probar notificación',
    'vaccineNotificationTitle': 'Vacuna de {name} 💉',
    'vaccineNotification7Days':
        'En una semana corresponde revisar la vacuna {vaccine} de {name}.',
    'registerGrowthControl': 'Registrar control',
    'editGrowthControl': 'Editar control',
    'saveGrowthControl': 'Guardar control',
    'latestGrowthControl': 'Último control',
    'growthHistory': 'Historial de controles',
    'noGrowthControls': 'Aún no hay controles registrados',
    'noGrowthControlsSubtitle':
        'Registra el peso y la talla o longitud del niño para comenzar su seguimiento.',
    'growthControlDate': 'Fecha del control',
    'weight': 'Peso',
    'weightKg': 'Peso en kilogramos',
    'height': 'Talla',
    'length': 'Longitud',
    'heightCm': 'Longitud o talla en centímetros',
    'weightRequired': 'Ingresa el peso.',
    'weightInvalid': 'Revisa el valor del peso ingresado.',
    'heightRequired': 'Ingresa la longitud o talla.',
    'heightInvalid': 'Revisa el valor de longitud o talla ingresado.',
    'measurementMethod': 'Tipo de medición',
    'measurementMethodDescription':
        'Selecciona cómo se realizó la medición. Esto será importante para interpretar correctamente las curvas de crecimiento.',
    'recumbentLength': 'Longitud acostado',
    'standingHeight': 'Talla de pie',
    'growthNotesHint': 'Ej. Control realizado en el centro de salud',
    'deleteGrowthControl': 'Eliminar control',
    'deleteGrowthControlQuestion':
        '¿Seguro que deseas eliminar este control de crecimiento?',
    'growthLoadError': 'No se pudieron cargar los controles de crecimiento.',
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
    'healthTrackingTitle': 'Seguimiento infantil',
    'healthGuidanceTitle': 'Alimentación y orientación',
    'healthOfChild': 'Salud de {name}',
    'healthNoChild': 'Registra un niño para comenzar su seguimiento de salud.',
    'recipes': 'Recetas',
    'healthRecipesSubtitle': 'Ideas de alimentación y preparaciones para niños',
    'healthProfileRequiredTitle': 'Primero registra un niño',
    'healthProfileRequiredSubtitle':
        'Necesitamos un perfil para relacionar correctamente sus vacunas y controles de crecimiento.',
    'vaccinesPageTitle': 'Vacunas',
    'vaccinesScheduleTitle': 'Esquema de vacunación',
    'vaccinesScheduleSubtitle':
        'Referencia basada en el esquema nacional del MSP Ecuador 2026.',
    'vaccinesLoadError': 'No se pudo cargar el esquema de vacunación.',
    'registerVaccine': 'Registrar vacuna',
    'editVaccineRecord': 'Editar registro',
    'vaccineDoseStatus': 'Estado de esta dosis',
    'vaccineDoseStatusSubtitle':
        'Indica si esta dosis fue aplicada o no aplicada.',
    'vaccineMarkApplied': 'Aplicada',
    'vaccineMarkNotApplied': 'No aplicada',
    'vaccineAppliedOptionHelp': 'Registra la fecha y, si deseas, el centro de salud.',
    'vaccineNotAppliedOptionHelp': 'Registra que esta dosis no fue administrada.',
    'vaccineNotAppliedUnlockInfo':
        'La dosis quedará registrada como no aplicada y la siguiente dosis se habilitará. Si la siguiente depende de un intervalo, se mostrará para revisión sin inventar una fecha.',
    'vaccineAppliedDate': 'Fecha de aplicación',
    'healthCenterOptional': 'Centro de salud (opcional)',
    'notesOptional': 'Notas (opcional)',
    'saveVaccineRecord': 'Guardar registro',
    'deleteVaccineRecord': 'Eliminar registro',
    'deleteVaccineRecordQuestion':
        '¿Seguro que deseas eliminar este registro de vacunación?',
    'vaccinesDisclaimer':
        'Este seguimiento es orientativo y no reemplaza el carné de vacunación ni la evaluación de un profesional de salud. Si existen dosis pendientes, antecedentes incompletos o dudas sobre el esquema, consulta en un establecimiento de salud.',
    'vaccineSingleDose': 'Dosis única',
    'vaccineBirthDose': 'Dosis al nacimiento',
    'vaccineDose1': 'Primera dosis',
    'vaccineDose2': 'Segunda dosis',
    'vaccineDose3': 'Tercera dosis',
    'vaccineDose6Months': 'Dosis de los 6 meses',
    'vaccineDose15Months': 'Dosis de los 15 meses',
    'vaccineDose18Months': 'Dosis de los 18 meses',
    'vaccineDose5Years': 'Dosis de los 5 años',
    'vaccineSeasonalDose': 'Vacunación estacional',
    'vaccineBirth24Hours':
        'De preferencia dentro de las primeras 24 horas de vida.',
    'vaccineSeasonalNote':
        'La fecha depende de la estrategia de vacunación estacional vigente.',
    'vaccineBCG': 'BCG',
    'vaccineHepatitisBZero': 'Hepatitis B - dosis cero',
    'vaccineRotavirus': 'Rotavirus',
    'vaccineHexavalent': 'Hexavalente',
    'vaccinePneumococcal': 'Neumococo',
    'vaccineBOPV': 'Poliomielitis (bOPV)',
    'vaccineInfluenza': 'Influenza estacional',
    'vaccineYellowFever': 'Fiebre amarilla',
    'vaccineMMR': 'SRP',
    'vaccineVaricella': 'Varicela',
    'vaccineDPT': 'DPT',
    'vaccineBCGPrevents': 'Ayuda a prevenir formas graves de tuberculosis.',
    'vaccineHepatitisBPrevents': 'Ayuda a prevenir la hepatitis B.',
    'vaccineRotavirusPrevents':
        'Ayuda a prevenir enfermedad grave por rotavirus.',
    'vaccineHexavalentPrevents':
        'Protege contra varias enfermedades prevenibles por vacunación.',
    'vaccinePneumococcalPrevents':
        'Ayuda a prevenir enfermedades causadas por neumococo.',
    'vaccinePolioPrevents': 'Ayuda a prevenir la poliomielitis.',
    'vaccineInfluenzaPrevents': 'Ayuda a prevenir la influenza.',
    'vaccineYellowFeverPrevents': 'Ayuda a prevenir la fiebre amarilla.',
    'vaccineMMRPrevents': 'Ayuda a prevenir sarampión, rubéola y paperas.',
    'vaccineVaricellaPrevents': 'Ayuda a prevenir la varicela.',
    'vaccineDPTPrevents': 'Ayuda a prevenir difteria, tosferina y tétanos.',
    'growthPageTitle': 'Crecimiento',
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
    'privacyAndData': 'Privacidad y datos',
    'privacySettingsSubtitle': 'Datos locales y eliminación',
    'privacyTitle': 'Tu información permanece bajo tu control',
    'privacyDescription':
        'Wawa Kalú guarda los perfiles infantiles y sus controles en el dispositivo para que puedas utilizarlos sin depender de una conexión a internet.',
    'localStorageTitle': 'Almacenamiento local',
    'localStorageDescription':
        'Los perfiles infantiles, registros de vacunas y controles de crecimiento se guardan localmente en este dispositivo.',
    'storedDataTitle': 'Información guardada',
    'storedDataDescription':
        'La aplicación puede almacenar nombre del niño, fecha de nacimiento, sexo, registros de vacunas, peso, longitud o talla y notas que hayas ingresado.',
    'notificationPrivacyTitle': 'Recordatorios locales',
    'notificationPrivacyDescription':
        'Los recordatorios de vacunas se programan mediante el sistema de notificaciones del dispositivo. Puedes desactivarlos desde el módulo de vacunas.',
    'dataManagement': 'Administración de datos',
    'dataManagementDescription':
        'Puedes eliminar los perfiles infantiles y toda la información de salud registrada en Wawa Kalú.',
    'deleteAllChildDataTitle': 'Eliminar todos los datos infantiles',
    'deleteAllChildDataDescription':
        'Esta acción elimina todos los perfiles, vacunas registradas y controles de crecimiento guardados en el dispositivo.',
    'deleteAllChildDataQuestion':
        '¿Seguro que deseas eliminar todos los perfiles infantiles y sus datos? Esta acción no se puede deshacer.',
    'deleteAllData': 'Eliminar todos los datos',
    'allChildDataDeleted': 'Todos los datos infantiles fueron eliminados.',
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
    'recipesShortDesc': 'Preparaciones suaves, seguras y fáciles para casa.',
    'viewRecipes': 'Ver recetas',
    'nutritionFinalNote':
        'Una buena nutrición acompaña el crecimiento del niño. Ofrezca alimentos variados, seguros y adecuados para su edad. Ante alergias, bajo peso o rechazo frecuente de comida, consulte con un profesional de salud.',
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
    'recipe3Step2': 'Cocina a fuego bajo hasta que esté completamente cocido.',
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
    'homeHealthLoading': 'Actualizando información de salud...',
    'homeHealthLoadError': 'No se pudo actualizar esta información.',
    'appVersion': 'Versión',
    'developers': 'Desarrolladores',
    'homeVaccinesNoPending':
        'No hay dosis pendientes en el seguimiento actual.',
    'deleteChildError': 'No se pudo eliminar el perfil. Inténtalo nuevamente.',
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
    'recipe5Rec': 'Evita yogures azucarados. Supervisa si usa trozos de fruta.',
    'languageTitle': 'Lenguaje y comunicación',
    'languageHeaderSubtitle':
        'Actividades simples para estimular sus primeras palabras',
    'touchActivityRecommendation': 'Toca una actividad y mira la recomendación',
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
    'childPhoto': 'Foto del niño',
    'addPhoto': 'Agregar foto',
    'changePhoto': 'Cambiar foto',
    'removePhoto': 'Quitar foto',
    'talkTitle': 'Conversar',
    'talkDesc': 'Fortalece la intención de comunicarse.',
    'talkRec':
        'Responda a los sonidos, gestos o miradas del niño como si fueran parte de una conversación. Eso le enseña que comunicarse tiene valor.',
    'talkHome':
        'Reto general: observe qué hace el niño y descríbalo con voz tranquila. Espere unos segundos para darle oportunidad de responder con mirada, gesto o sonido.',
    'talkParent':
        'No llene todos los silencios. Esperar también ayuda a que el niño intente comunicarse.',
    'childNotFound': 'No se encontró el perfil del niño.',
    'imitateSoundsTitle': 'Imitar sonidos',
    'imitateSoundsDesc': 'Practica sonidos básicos de forma divertida.',
    'imitateSoundsRec':
        'Haga sonidos simples de acciones, objetos o situaciones. No necesita materiales especiales: puede usar sonidos de sorpresa, golpes suaves, vehículos o animales conocidos.',
    'imitateSoundsHome':
        'Reto general: haga 3 sonidos fáciles y espere si el niño intenta copiarlos. Puede usar sonidos como “pa-pa”, “ma-ma”, “toc toc”, “mmm” o “brum”.',
    'imitateSoundsParent':
        'Felicite cualquier intento. No corrija fuerte; repita el sonido correcto con naturalidad.',
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
    'homeNoChildTitle': 'Comienza creando un perfil',
    'homeNoChildSubtitle':
        'Registra al primer niño para organizar su crecimiento, vacunas y seguimiento de salud.',
    'addFirstChild': 'Registrar primer niño',
    'environmentTitle': 'Entornos protectores',
    'environmentHeaderSubtitle':
        'Guía para cuidar la seguridad, salud y bienestar de niños de 0 a 3 años',
    'touchEnvironmentActions': 'Toca cada sección para ver acciones prácticas',
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
    'affectionA1': 'Abrácelo, háblele con calma y responda a sus necesidades.',
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
    'kichwa': 'Kichwa',
    'lengthOrHeight': 'Longitud o talla',
    'headCircumference': 'Perímetro cefálico',
    'headCircumferenceOptional': 'Perímetro cefálico (opcional)',
    'headCircumferenceInvalid':
        'Revisa el valor del perímetro cefálico ingresado.',
    'growthSelectorTitle': 'Selecciona una gráfica',
    'growthSelectorSubtitle': 'Muestra una curva a la vez.',
    'growthSelectorWeight': 'Peso/Edad',
    'growthSelectorHeight': 'Talla/Edad',
    'growthSelectorBmi': 'IMC/Edad',
    'growthSelectorHead': 'Perímetro cefálico',
    'growthSelectorWeightLength': 'Peso/Longitud',
    'growthSelectorWeightHeight': 'Peso/Talla',
    'headCircumferenceForAgeChart': 'Perímetro cefálico para la edad',
    'headCircumferenceForAgeChartDescription':
        'Compara el perímetro cefálico registrado con las curvas de referencia según la edad.',
    'headCmShort': 'Cabeza (cm)',
  };

  static final Map<String, String> _english = <String, String>{
    'childHealthSubtitle': 'Vaccines and growth use this same profile, without creating duplicate records.',
    'learningHeroEyebrow': 'SUPPORT · DISCOVER · CARE',
    'learningHubTitle': 'Support every discovery',
    'learningHubSubtitle': 'Clear activities and guidance to learn, communicate, and grow in a safe environment.',
    'learningChooseTitle': 'What would you like to support today?',
    'learningChooseSubtitle': 'Each space has a different purpose, so content is not repeated.',
    'learningActivitiesBadge': 'AGE-BASED ACTIVITIES',
    'learningGuidanceBadge': 'CAREGIVER GUIDANCE',
    'nutritionOrientationTab': 'Guidance',
    'nutritionIntegratedSubtitle': 'Guidance and recipes together in one place to support everyday feeding.',
    'healthTrackingSubtitle': 'Personal records for the selected child.',
    'healthGuidanceSubtitle': 'Everyday guidance without duplicate destinations.',
    'healthNutritionIntegratedSubtitle': 'Feeding guidance and recipes in one section',
    'childrenHubTitle': 'A space for each child',
    'childrenHubSubtitle': 'Separate profiles for growth, vaccines, and useful tools for each stage.',
    'childrenProfilesTitle': 'Your family profiles',
    'childrenProfilesSubtitle': 'Open a profile to see its information and related tools.',
    'childrenContextNotice': 'My children does not duplicate Health or Learning: each profile opens the same tools with that child selected.',
    'childPersonalizedForAge': 'For this stage',
    'childPersonalizedSubtitle': 'Open the same Learning and Nutrition guides using this child as context.',
    'childLearningShortcutSubtitle': 'Activities and guidance to support development',
    'childNutritionShortcutSubtitle': 'Feeding guidance and recipes together in Nutrition',
    'learningExploreTitle': 'Explore together',
    'learningExploreSubtitle': 'Three spaces to discover, communicate, and care with kindness.',
    'learningFeatured': 'FEATURED · AGES 1–5',
    'learningFamilyNotice': 'Every child develops at their own pace. Support their discoveries with play, listening, and affection.',
    'languageIdeasTitle': 'Ideas to talk and connect',
    'languageRecommendationTitle': 'How can you help?',
    'environmentActionsTitle': 'Actions that protect',
    'environmentWhatToKnow': 'Why does it matter?',
    'nutritionAdviceTitle': 'Small habits, lasting care',
    'nutritionPracticalTips': 'Practical tips',
    'recipesIdeasTitle': 'Ideas for cooking together',
    'guideAreaExplore': "Sensory exploration",
    'guideAreaMove': "Movement",
    'guideAreaLanguage': "Language",
    'guideAreaThink': "Thinking",
    'guideAreaCreate': "Creativity",
    'guideAreaLife': "Everyday life",
    'guideAreaFeel': "Feelings",
    'guideNavTitle': "Family activity guide",
    'guideHeroTag': "FOR PARENTS AND CAREGIVERS",
    'guideHeroTitle': "Little discoveries, big learning",
    'guideHeroSubtitle': "Simple ways to support development from ages 1 to 5, using everyday materials.",
    'guideAgesTitle': "Choose an age",
    'guideAreasTitle': "What shall we explore?",
    'guideAllAges': "All ages",
    'guideAllAreas': "All areas",
    'guideActivitiesTitle': "Activities to share",
    'guideCount': "{count} ideas",
    'guideActivityCta': "Open guide",
    'guideAge12': "1–2 years",
    'guideAge23': "2–3 years",
    'guideAge34': "3–4 years",
    'guideAge45': "4–5 years",
    'guideMinutes': "min",
    'guideDetails': "Guide the activity",
    'guideGoal': "What does it support?",
    'guideMaterials': "Materials at home",
    'guideSteps': "Step by step",
    'guideObserve': "What to notice",
    'guideAdapt': "Make it their own",
    'guideSafety': "Safety first",
    'guideTipTitle': "Your presence matters most",
    'guideTipText': "No expensive materials or perfect results needed. Watch, talk, listen and follow your child's pace.",
    'guideNoResults': "No activities match these filters.",
    'guideResetFilters': "Show all",
    'guideReadyCount': "{ready}/{total} ready",
    'guideStepProgress': "{done} of {total} steps",
    'guideRestart': "Reset checklist",
    'guideAgeNotice': "Ages are only a guide. Adapt each idea to your child's interests and abilities, with adult supervision.",
    'appName': 'Wawa Kalú',
    'subtitle': 'Discover, learn and grow together as a family',
    'settingsTitle': 'Settings',
    'enabled': 'Enabled',
    'disabled': 'Disabled',
    'startApp': 'Start',
    'startingApp': 'Starting...',
    'aboutApp': 'About the app',
    'projectFeatures': 'Main features',
    'aboutAppSubtitle':
        "Wawa Kalú supports families with health, growth and hands-on learning activities.",
    'close': 'Close',
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
    'welcomeScreenTitle': 'Welcome to',
    'welcomeSettingsNote':
        'You can change language, sounds, vibration, and appearance from the gear icon.',
    'familyGuide': "Family guide",
    'nutrition': 'Nutrition',
    'languageMenu': 'Language',
    'vaccinesScheduleTitle': 'Vaccination schedule',
    'vaccinesScheduleSubtitle':
        'Reference based on Ecuador MSP’s 2026 national vaccination schedule.',
    'vaccinesLoadError': 'The vaccination schedule could not be loaded.',
    'vaccineApplied': 'Administered',
    'vaccineNotApplied': 'Not administered',
    'vaccineUpcoming': 'Upcoming',
    'vaccineReview': 'Needs review',
    'vaccineSeasonalReview': 'Review seasonal vaccination',
    'vaccineWaitingPrevious': 'Waiting for previous dose',
    'registerVaccine': 'Register vaccine',
    'editVaccineRecord': 'Edit record',
    'vaccineDoseStatus': 'Dose status',
    'vaccineDoseStatusSubtitle':
        'Choose whether this dose was administered or not administered.',
    'vaccineMarkApplied': 'Administered',
    'vaccineMarkNotApplied': 'Not administered',
    'vaccineAppliedOptionHelp': 'Record the date and, optionally, the health center.',
    'vaccineNotAppliedOptionHelp': 'Record that this dose was not administered.',
    'vaccineNotAppliedUnlockInfo':
        'This dose will be recorded as not administered and the next dose will be unlocked. If the next dose depends on an interval, it will be shown for review without inventing a date.',
    'vaccineAppliedDate': 'Administration date',
    'healthCenterOptional': 'Health center (optional)',
    'notesOptional': 'Notes (optional)',
    'saveVaccineRecord': 'Save record',
    'deleteVaccineRecord': 'Delete record',
    'deleteVaccineRecordQuestion':
        'Are you sure you want to delete this vaccination record?',
    'vaccinesDisclaimer':
        'This tracking tool is for guidance only and does not replace the vaccination card or assessment by a health professional. If doses are pending, records are incomplete, or you have questions about the schedule, consult a health facility.',
    'vaccineSingleDose': 'Single dose',
    'vaccineBirthDose': 'Birth dose',
    'vaccineDose1': 'First dose',
    'vaccineDose2': 'Second dose',
    'vaccineDose3': 'Third dose',
    'vaccineDose6Months': '6-month dose',
    'vaccineDose15Months': '15-month dose',
    'vaccineDose18Months': '18-month dose',
    'vaccineDose5Years': '5-year dose',
    'vaccineSeasonalDose': 'Seasonal vaccination',
    'vaccineBirth24Hours': 'Preferably within the first 24 hours of life.',
    'vaccineSeasonalNote':
        'The date depends on the current seasonal vaccination strategy.',
    'vaccineBCG': 'BCG',
    'vaccineHepatitisBZero': 'Hepatitis B - birth dose',
    'vaccineRotavirus': 'Rotavirus',
    'vaccineHexavalent': 'Hexavalent',
    'vaccinePneumococcal': 'Pneumococcal',
    'vaccineBOPV': 'Polio (bOPV)',
    'vaccineInfluenza': 'Seasonal influenza',
    'vaccineYellowFever': 'Yellow fever',
    'vaccineMMR': 'MMR',
    'vaccineVaricella': 'Varicella',
    'vaccineDPT': 'DPT',
    'vaccineBCGPrevents': 'Helps prevent severe forms of tuberculosis.',
    'vaccineHepatitisBPrevents': 'Helps prevent hepatitis B.',
    'vaccineRotavirusPrevents': 'Helps prevent severe rotavirus disease.',
    'vaccineHexavalentPrevents':
        'Protects against several vaccine-preventable diseases.',
    'vaccinePneumococcalPrevents': 'Helps prevent pneumococcal disease.',
    'vaccinePolioPrevents': 'Helps prevent poliomyelitis.',
    'vaccineInfluenzaPrevents': 'Helps prevent influenza.',
    'vaccineYellowFeverPrevents': 'Helps prevent yellow fever.',
    'vaccineMMRPrevents': 'Helps prevent measles, mumps, and rubella.',
    'vaccineVaricellaPrevents': 'Helps prevent varicella.',
    'vaccineDPTPrevents': 'Helps prevent diphtheria, pertussis, and tetanus.',
    'viewGrowthCharts': 'View growth charts',
    'growthChartsTitle': 'Growth charts',
    'whoChildGrowthStandards': 'WHO Child Growth Standards 0–5 years',
    'whoGrowthReferenceNote':
        'The charts use WHO Child Growth Standards for girls and boys from birth to 5 years. The plotted points correspond to measurements registered in Wawa Kalú.',
    'weightForAgeChart': 'Weight-for-age',
    'weightForAgeChartDescription':
        'Compares the child’s weight progression with reference curves according to age.',
    'heightForAgeChart': 'Length/height-for-age',
    'heightForAgeChartDescription':
        'Compares registered length or height with reference curves according to age.',
    'weightForLengthChart': 'Weight-for-length',
    'weightForLengthChartDescription':
        'Relates weight to recumbent length during the first years of life.',
    'weightForHeightChart': 'Weight-for-height',
    'weightForHeightChartDescription': 'Relates weight to standing height.',
    'bmiForAgeChart': 'BMI-for-age',
    'bmiForAgeChartDescription':
        'Shows body mass index progression according to age.',
    'growthChartZoomHint':
        'You can zoom and move the chart to view it in more detail.',
    'growthChartNoData': 'There are no compatible measurements for this chart.',
    'growthChartsNoMeasurements': 'There is no data to chart yet',
    'growthChartsNoMeasurementsSubtitle':
        'Register at least one weight and length or height measurement to begin.',
    'growthChartsLoadError': 'Growth charts could not be loaded.',
    'growthChartRenderError':
        'This chart could not be generated from the registered data.',
    'growthNoValidWhoMeasurements':
        'The registered measurements are outside the valid range for the WHO 0–5 year growth standards.',
    'growthSkippedMeasurements':
        '{count} measurement(s) could not be used in the WHO charts and were skipped.',
    'growthChartDisclaimer':
        'Growth charts support monitoring but do not provide a diagnosis by themselves. Clinical interpretation should be performed by a health professional.',
    'age': 'Age',
    'weightKgShort': 'Weight (kg)',
    'heightCmShort': 'Height (cm)',
    'lengthCmShort': 'Length (cm)',
    'bmiShort': 'BMI',
    'refresh': 'Refresh',
    'registerGrowthControl': 'Register measurement',
    'privacyAndData': 'Privacy and data',
    'privacySettingsSubtitle': 'Local data and deletion',
    'privacyTitle': 'Your information remains under your control',
    'privacyDescription':
        'Wawa Kalú stores child profiles and their records on the device so they can be used without depending on an internet connection.',
    'localStorageTitle': 'Local storage',
    'localStorageDescription':
        'Child profiles, vaccine records and growth measurements are stored locally on this device.',
    'storedDataTitle': 'Stored information',
    'storedDataDescription':
        'The app may store the child’s name, date of birth, sex, vaccine records, weight, length or height, and notes you entered.',
    'notificationPrivacyTitle': 'Local reminders',
    'notificationPrivacyDescription':
        'Vaccine reminders are scheduled through the device notification system. They can be disabled from the vaccine module.',
    'dataManagement': 'Data management',
    'dataManagementDescription':
        'You can delete child profiles and all health information registered in Wawa Kalú.',
    'deleteAllChildDataTitle': 'Delete all child data',
    'deleteAllChildDataDescription':
        'This action deletes every child profile, registered vaccine and growth measurement stored on the device.',
    'deleteAllChildDataQuestion':
        'Are you sure you want to delete all child profiles and their data? This action cannot be undone.',
    'deleteAllData': 'Delete all data',
    'allChildDataDeleted': 'All child data was deleted.',
    'deleteAllDataError': 'All data could not be deleted. Please try again.',
    'privacyFinalNote':
        'General app preferences, such as language and theme, are not deleted when child data is removed.',
    'editGrowthControl': 'Edit measurement',
    'saveGrowthControl': 'Save measurement',
    'latestGrowthControl': 'Latest measurement',
    'growthHistory': 'Measurement history',
    'noGrowthControls': 'No measurements have been registered yet',
    'noGrowthControlsSubtitle':
        'Register the child’s weight and height or length to begin tracking growth.',
    'growthControlDate': 'Measurement date',
    'weight': 'Weight',
    'weightKg': 'Weight in kilograms',
    'height': 'Height',
    'length': 'Length',
    'heightCm': 'Length or height in centimeters',
    'weightRequired': 'Enter the weight.',
    'weightInvalid': 'Check the entered weight value.',
    'heightRequired': 'Enter the length or height.',
    'heightInvalid': 'Check the entered length or height value.',
    'measurementMethod': 'Measurement method',
    'measurementMethodDescription':
        'Select how the measurement was taken. This will be important for correctly interpreting the growth charts.',
    'recumbentLength': 'Recumbent length',
    'standingHeight': 'Standing height',
    'growthNotesHint': 'E.g. Measurement taken at the health center',
    'deleteGrowthControl': 'Delete measurement',
    'deleteGrowthControlQuestion':
        'Are you sure you want to delete this growth measurement?',
    'growthLoadError': 'Growth measurements could not be loaded.',
    'growthChartsNextStep':
        'These measurements will be used in weight-for-age, height-for-age, and other growth charts in the next step.',
    'nutritionChildTitle': 'Child nutrition',
    'nutritionChildSubtitle':
        'Practical guide for parents and caregivers of children from 0 to 3 years old',
    'touchSectionRecommendations': 'Tap each section to see recommendations',
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
    'vaccineExpectedDate': 'Expected date',
    'vaccineReferenceDate': 'Reference date',
    'vaccineRemindersTitle': 'Vaccine reminders',
    'vaccineRemindersSubtitle':
        'Receive reminders before expected vaccination dates.',
    'vaccineRemindersSchedule':
        'Notifications 7 days before, 1 day before, and on the same day.',
    'vaccineRemindersEnabledMessage': 'Vaccine reminders are enabled.',
    'vaccineRemindersDisabledMessage': 'Vaccine reminders are disabled.',
    'notificationPermissionDenied': 'Notification permission was not granted.',
    'testNotification': 'Test notification',
    'homeHealthLoading': 'Updating health information...',
    'homeHealthLoadError': 'This information could not be updated.',
    'homeVaccinesNoPending':
        'There are no pending doses in the current tracking schedule.',
    'deleteChildError': 'The profile could not be deleted. Please try again.',
    'vaccineNotificationTitle': '{name}’s vaccine 💉',
    'vaccineNotification7Days':
        'In one week, review {name}’s {vaccine} vaccine.',
    'vaccineNotificationTomorrow':
        'Tomorrow, review {name}’s {vaccine} vaccine.',
    'vaccineNotificationToday': 'Today, review {name}’s {vaccine} vaccine.',
    'vaccineDaysRemaining': '{days} days remaining',
    'vaccineTomorrow': 'Expected tomorrow',
    'childPhoto': 'Child photo',
    'addPhoto': 'Add photo',
    'changePhoto': 'Change photo',
    'removePhoto': 'Remove photo',
    'vaccineToday': 'Review today',
    'vaccineDatePassed': 'The reference date has passed',
    'nutritionRoutineTitle': 'Mealtime routines',
    'nutritionRoutineSubtitle': 'Calm schedules to build habits',
    'nutritionRoutineTip1':
        'Keep similar times for breakfast, lunch, snacks, and dinner.',
    'nutritionRoutineTip2':
        'Avoid letting the child become too hungry, as they may become upset or reject the food.',
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
    'recipe4Desc': 'Small soft portions to practice grasping and safe chewing.',
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
    'recipe5Rec': 'Avoid sweetened yogurts. Supervise if using fruit pieces.',
    'languageTitle': 'Language and communication',
    'languageHeaderSubtitle': 'Simple activities to stimulate first words',
    'touchActivityRecommendation': 'Tap an activity and see the recommendation',
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
    'languageFinalNote':
        'Each child develops language at their own pace. If they do not respond to sounds, do not look when spoken to, or lose acquired skills, consult a professional.',
    'childrenHeaderTitle': 'Your children',
    'childrenHeaderSubtitle': 'Select a profile or register a new child.',
    'childProfile': 'Child profile',
    'childName': 'Name or nickname',
    'childNameHint': 'E.g. Sofia',
    'childNameRequired': 'Enter the child’s name or nickname.',
    'birthDate': 'Date of birth',
    'selectBirthDate': 'Select date of birth',
    'selectDate': 'Select date',
    'birthDateRequired': 'Select the date of birth.',
    'sex': 'Sex',
    'sexForGrowthCurves': 'Sex for growth charts',
    'sexForGrowthCurvesDescription':
        'This information is used to select the corresponding growth chart.',
    'sexRequired': 'Select boy or girl.',
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
    'year': 'year',
    'years': 'years',
    'month': 'month',
    'months': 'months',
    'day': 'day',
    'days': 'days',
    'active': 'Active',
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
    'navHome': 'Home',
    'navChildren': 'My children',
    'navHealth': 'Health',
    'navLearning': 'Learn',
    'myChildren': 'My children',
    'noChildrenRegistered': 'You have not registered any children yet',
    'childrenEmptyDescription':
        'Here you can register one or more children and keep their growth and health information separately.',
    'addChild': 'Add child',
    'health': 'Health',
    'healthHeaderTitle': 'Support their growth and well-being',
    'healthHeaderSubtitle':
        'All health information will be organized in one place.',
    'vaccines': 'Vaccines',
    'vaccinesSubtitle': 'Schedule, administered doses, and upcoming vaccines',
    'growth': 'Growth',
    'growthSubtitle': 'Weight, height, and child development',
    'healthNutritionSubtitle': 'Child nutrition tips and guidance',
    'learning': 'Learn',
    'learningHeaderTitle': 'Learn and grow',
    'learningHeaderSubtitle':
        'Activities to support children’s learning and development.',
    'learningGuideSubtitle': "Hands-on ideas using everyday materials for ages 1 to 5.",
    'learningLanguageSubtitle': 'Conversation, stories, songs, and everyday moments that support communication',
    'protectiveEnvironments': 'Protective environments',
    'learningEnvironmentSubtitle': 'Child care, well-being, and protection',
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
    'healthTrackingTitle': 'Child health tracking',
    'healthGuidanceTitle': 'Nutrition and guidance',
    'healthOfChild': '{name}’s health',
    'healthNoChild': 'Register a child to begin health tracking.',
    'recipes': 'Recipes',
    'healthRecipesSubtitle': 'Meal ideas and preparations for children',
    'healthProfileRequiredTitle': 'Register a child first',
    'healthProfileRequiredSubtitle':
        'A child profile is required to correctly associate vaccines and growth measurements.',
    'vaccinesPageTitle': 'Vaccines',
    'growthPageTitle': 'Growth',
    'homeNoChildTitle': 'Start by creating a profile',
    'homeNoChildSubtitle':
        'Register the first child to organize their growth, vaccines, and health tracking.',
    'addFirstChild': 'Register first child',
    'affectionTitle': 'Affection and respectful care',
    'affectionSubtitle': 'Caring also means responding calmly',
    'affectionDesc':
        'Affection, patience, and respectful care strengthen trust and emotional development.',
    'affectionA1': 'Hug the child, speak calmly, and respond to their needs.',
    'affectionA2': 'Validate emotions: tiredness, fear, frustration, or joy.',
    'affectionA3': 'Avoid shouting, hitting, or threats.',
    'affectionA4':
        'When the child makes a mistake, guide them with simple words and a calm tone.',
    'affectionAlert':
        'If the adult feels very stressed, it is better to ask for support before reacting with anger.',
    'appVersion': 'Version',
    'developers': 'Developers',
    'healthAlertTitle': 'Health and warning signs',
    'healthAlertSubtitle': 'When to seek help',
    'healthAlertDesc':
        'Observing changes in the child helps you act in time and prevent complications.',
    'healthAlertA1': 'Monitor fever, breathing, feeding, and energy level.',
    'healthAlertA2':
        'Watch for falls, strong hits, vomiting, diarrhea, or food refusal.',
    'healthAlertA3': 'Keep medical checkups and vaccinations according to age.',
    'healthAlertA4': 'Do not medicate the child without professional guidance.',
    'healthAlertAlert':
        'Seek medical care if there is difficulty breathing, high fever, extreme tiredness, seizures, strong hits, or signs of dehydration.',
    'environmentFinalNote':
        'A protective environment combines safety, affection, supervision, and routines. Small daily actions help the child grow with confidence and well-being.',
    'kichwa': 'Kichwa',
    'lengthOrHeight': 'Length or height',
    'headCircumference': 'Head circumference',
    'headCircumferenceOptional': 'Head circumference (optional)',
    'headCircumferenceInvalid': 'Check the entered head circumference value.',
    'growthSelectorTitle': 'Select a chart',
    'growthSelectorSubtitle': 'Shows one growth chart at a time.',
    'growthSelectorWeight': 'Weight/Age',
    'growthSelectorHeight': 'Height/Age',
    'growthSelectorBmi': 'BMI/Age',
    'growthSelectorHead': 'Head circumference',
    'growthSelectorWeightLength': 'Weight/Length',
    'growthSelectorWeightHeight': 'Weight/Height',
    'headCircumferenceForAgeChart': 'Head circumference for age',
    'headCircumferenceForAgeChartDescription':
        'Compares the recorded head circumference with the reference curves for age.',
    'headCmShort': 'Head (cm)',
  };

  // KICHWA ECUATORIANO
  //
  // Traducción funcional para la interfaz de Wawa Kalú.
  // Los nombres técnicos (OMS, IMC, BCG, vacunas, etc.) se conservan cuando
  // conviene para no perder precisión clínica.
  //
  // IMPORTANTE:
  // Antes de presentar esta versión como traducción oficial o validada por el
  // MSP, debe ser revisada por un/a hablante o traductor/a de Kichwa ecuatoriano,
  // especialmente los textos de vacunas, crecimiento, nutrición y alertas.
  static final Map<String, String> _kichwa = <String, String>{
    'guideAreaExplore': "Taripay",
    'guideAreaMove': "Kuyuriy",
    'guideAreaLanguage': "Shimi",
    'guideAreaThink': "Yuyay",
    'guideAreaCreate': "Kamay",
    'guideAreaLife': "Punchanta kawsay",
    'guideAreaFeel': "Shunkupa yuyaykuna",
    'guideNavTitle': "Aylluwan yachay",
    'guideHeroTag': "AYLLUKUNAPAK",
    'guideHeroTitle': "Uchilla taripaykuna, hatun yachaykuna",
    'guideAgesTitle': "Watakunata akllay",
    'guideAllAges': "Tukuy watakuna",
    'guideAllAreas': "Tukuy",
    'guideActivitiesTitle': "Aylluwan ruraykuna",
    'guideActivityCta': "Yachayta rikuy",
    'guideAge12': "1–2 wata",
    'guideAge23': "2–3 wata",
    'guideAge34': "3–4 wata",
    'guideAge45': "4–5 wata",
    'guideMinutes': "min",
    'guideMaterials': "Wasipi tiyashkakuna",
    'guideSteps': "Shuk shuk ruray",
    'guideSafety': "Ñawpakta alli kamay",
    'vaccineApplied': 'CHURASHKA',
    'vaccineNotApplied': 'MANA CHURASHKA',
    'vaccineUpcoming': 'KATIKPI',
    'vaccineReview': 'RIKUNA KAN',
    'vaccineSeasonalReview': 'WATA KILLAPI VACUNATA RIKUY',
    'vaccineWaitingPrevious': 'ÑAWPA DOSIS-TA SHUYAKUN',
    'vaccineExpectedDate': 'Shuyashka puncha',
    'vaccineReferenceDate': 'Rikuchik puncha',
    'vaccineDaysRemaining': '{days} punchami pishin',
    'vaccineTomorrow': 'Kayapakmi rikuna kan',
    'vaccineToday': 'Kunanmi rikuna kan',
    'vaccineDatePassed': 'Rikuchik punchaka yallishkami',
    'appName': 'Wawa Kalú',
    'subtitle': 'Aylluwan pukllashpa, maskashpa, wiñashpa yachay',
    'settingsTitle': 'Wakichiy',
    'enabled': 'Rikurishka',
    'disabled': 'Mana rikurishka',
    'startApp': 'Kallariy',
    'startingApp': 'Yaykukushpa...',
    'navHome': 'Kallari',
    'navChildren': 'Ñukapa wawakuna',
    'navHealth': 'Hampiy',
    'navLearning': 'Yachay',
    'myChildren': 'Ñukapa wawakuna',
    'noChildrenRegistered': 'Manarak wawakunata killkachishkachu',
    'childrenEmptyDescription':
        'Kaypimi shuk uta ashtawan wawakunata killkachishpa, sapalla paykunapak wiñayta, hampiy willaytapash katina ushanki.',
    'addChild': 'Wawata yapay',
    'health': 'Hampiy',
    'healthHeaderTitle': 'Paypa wiñayta alli kawsaytapash katipay',
    'healthHeaderSubtitle':
        'Tukuy hampiy willayka shuklla kitipi allichishka kanka.',
    'vaccines': 'Vacunakuna',
    'vaccinesSubtitle': 'Vacuna ñan, churashka dosis, katik vacunapash',
    'growth': 'Wiñay',
    'growthSubtitle': 'Llashak, aksi/talla, wawapa wiñay katina',
    'healthNutritionSubtitle': 'Wawa mikuy hawa yuyachikuna',
    'learning': 'Yachay',
    'learningHeaderTitle': 'Yachay, wiñay',
    'learningHeaderSubtitle':
        'Wawapa yachayta, wiñaytapash yanapankapak ruraykuna.',
    'learningGuideSubtitle': "1–5 watayuk wawakunawan ayllupi ruraykuna.",
    'learningLanguageSubtitle': 'Rimanakuy, kallari yachachiy',
    'protectiveEnvironments': 'Kamashka kawsaypachakuna',
    'learningEnvironmentSubtitle': 'Wawata kamana, alli kawsay, harkay',
    'aboutApp': 'Aplicación hawa',
    'projectFeatures': 'Ruraykuna',
    'aboutAppSubtitle':
        'Wawa Kalúka ayllukunapak yanapak aplicaciónmi; wawakunapa alli kawsayta, wiñayta, yachaytapash yanapan.',
    'close': 'Tukuchiy',
    'sounds': 'Uyarikuna',
    'language': 'Shimi',
    'spanish': 'Kastilla shimi',
    'english': 'Inglés shimi',
    'vibration': 'Kuyuriy',
    'vibrationOn': 'Kuyuriy rikurishka',
    'vibrationOff': 'Kuyuriy wañuchishka',
    'appearance': 'Rikchay',
    'themeAutomatic': 'Kikinmanta',
    'lightMode': 'Achik rikchay',
    'darkMode': 'Yana rikchay',
    'settingsNote': 'Kay akllaykunataka munashka pachapi wakichina ushanki.',
    'languageAutomatic': 'Kikinmanta',
    'languageAutoSubtitle': 'Telefonopa shimiman rikushpa',
    'welcomeScreenTitle': 'Alli shamushka',
    'welcomeSettingsNote':
        'Shimi, uyariy, kuyuriy, rikchaytapash wakichiykunapi tikrachina ushanki.',
    'familyGuide': "Aylluwan yachay",
    'nutrition': 'Mikuy',
    'languageMenu': 'Shimi',
    'childrenHeaderTitle': 'Kanpa wawakuna',
    'childrenHeaderSubtitle':
        'Shuk perfilta akllay uta mushuk wawata killkachiy.',
    'childProfile': 'Wawapa perfil',
    'childName': 'Shuti uta kuyashka shuti',
    'childNameHint': 'Shina: Sofía',
    'childNameRequired': 'Wawapa shutita uta kuyashka shutita killkay.',
    'birthDate': 'Wacharishka puncha',
    'selectBirthDate': 'Wacharishka punchata akllay',
    'selectDate': 'Punchata akllay',
    'birthDateRequired': 'Wacharishka punchata akllay.',
    'sex': 'Kari/warmi kay',
    'sexForGrowthCurves': 'Wiñay kurvakunapak kari/warmi kay',
    'sexForGrowthCurvesDescription':
        'Kay willaywanmi wawapak tupak wiñay kurvata akllarin.',
    'sexRequired': 'Kari wawa uta warmi wawata akllay.',
    'boy': 'Kari wawa',
    'girl': 'Warmi wawa',
    'saveChild': 'Perfilta wakaychiy',
    'editChild': 'Perfilta tikrachiy',
    'saveChanges': 'Tikrachishkata wakaychiy',
    'deleteChild': 'Perfilta kichuy',
    'deleteChildConfirmation':
        '¿{name} shutiyukpa perfilta kichunaykichu? Kay rurayta mana kutichina ushankichu.',
    'delete': 'Kichuy',
    'edit': 'Tikrachiy',
    'cancel': 'Sakiy',
    'accept': 'Chaskiy',
    'selectThisChild': 'Kay wawata akllay',
    'activeChild': 'Akllashka wawa',
    'childHealth': 'Hampiyta katina',
    'year': 'wata',
    'years': 'watakuna',
    'month': 'killa',
    'months': 'killakuna',
    'day': 'puncha',
    'days': 'punchakuna',
    'active': 'Rikurishka',
    'viewGrowthCharts': 'Wiñay kurvakunata rikuy',
    'growthChartsTitle': 'Wiñay kurvakuna',
    'whoChildGrowthStandards': 'OMS wawakunapak wiñay tupukuna 0–5 wata',
    'whoGrowthReferenceNote':
        'Kay kurvakunaka OMS wawakunapak 0–5 wata wiñay tupukunata usan. Puntu rikuchishkakunaka Wawa Kalú ukupi killkachishka controlkunami.',
    'weightForAgeChart': 'Watayukman rikushpa llasha',
    'weightForAgeChartDescription':
        'Wawapa llashapa wiñayta paypa watayukman rikushpa rikuchik kurvakunawan chimpapurachin.',
    'heightForAgeChart': 'Watayukman rikushpa suniyay/talla',
    'heightForAgeChartDescription':
        'Killkachishka suniyay uta tallata watayukman rikushpa rikuchik kurvakunawan chimpapurachin.',
    'weightForLengthChart': 'Suniyayman rikushpa llasha',
    'weightForLengthChartDescription':
        'Kallari watakunapi wawapa llashata suniyaywan chimpapurachin.',
    'weightForHeightChart': 'Tallaman rikushpa llasha',
    'weightForHeightChartDescription':
        'Wawapa llashata killkachishka tallawan chimpapurachin.',
    'bmiForAgeChart': 'Watayukman rikushpa IMC',
    'bmiForAgeChartDescription':
        'IMC-pa tikrayta watayukwan chimpapurashpa rikuchin.',
    'growthChartZoomHint':
        'Ashtawan alli rikunkapak grafikata hatunyachina, kuyuchina ushanki.',
    'growthChartNoData': 'Kay grafikapak tupak controlkuna mana tiyanchu.',
    'growthChartsNoMeasurements':
        'Grafikata rurankapak manarak willay tiyanchu',
    'growthChartsNoMeasurementsSubtitle':
        'Kallarinkapak shuk llasha, suniyay uta talla controlta killkachiy.',
    'growthChartsLoadError': 'Wiñay kurvakunata mana kargay usharishkachu.',
    'growthChartRenderError':
        'Killkachishka willaykunawan kay grafikata mana ruray usharishkachu.',
    'growthNoValidWhoMeasurements':
        'Killkachishka controlkunaka OMS 0–5 wata wiñay kurvakunapak alli tupuna ukupi mana kanchu.',
    'growthSkippedMeasurements':
        '{count} control OMS kurvakunapi mana usharishkamanta sakirishka.',
    'growthChartDisclaimer':
        'Kay kurvakunaka katipankapak yanapakllami kan; paykunallaka mana unkuymanta ninkapakchu. Hampikmi klinika yuyayta kuna kan.',
    'age': 'Watayuk',
    'weightKgShort': 'Llasha (kg)',
    'heightCmShort': 'Talla (cm)',
    'lengthCmShort': 'Suniyay (cm)',
    'bmiShort': 'IMC',
    'refresh': 'Mushukyachiy',
    'nutritionChildTitle': 'Wawapa mikuy',
    'nutritionChildSubtitle':
        '0–3 watayuk wawakunapa tayta-mamakunapak, kamakkunapak yanapak ñan',
    'touchSectionRecommendations':
        'Yuyachikunata rikunkapak sapa rakita llankay',
    'nutritionFoodsTitle': 'Mikuykuna, yanushkakuna',
    'nutritionFoodsSubtitle': '0–3 watayuk wawakunapak alli mikuy yuyaykuna',
    'nutritionFoodsTip1':
        'Wawapa watayukman rikushpa kikin, llampu, chikan chikan mikuykunata kuy.',
    'nutritionFoodsTip2':
        'Uchilla porciónpi muyukuna, yuyukuna, cereal, llampu proteína mikuykunata tantachiy.',
    'nutritionFoodsTip3':
        'Yapashka mishkita, gaseosata, procesado snacks-ta, yapa kachitapash ama kuychu.',
    'nutritionFoodsTip4':
        'Watayukman rikushpa mikuy rikchayta tikrachiy: llampu puré, ñitishka, llampu pitikuna, chaymanta rikushpa ashtawan sinchi mikuy.',
    'nutritionFoodsTip5':
        'Wawaka mikuyta mana munashpaka ama kallpachiychu; shuk punchapi alli shunkuwan kutin kuy.',
    'vaccineRemindersTitle': 'Vacunapa yuyachikuna',
    'vaccineRemindersSubtitle':
        'Vacunapa shuyashka punchakuna manarak chayamukpi willachiyta chaskiy.',
    'vaccineRemindersSchedule':
        '7 puncha ñawpak, 1 puncha ñawpak, chay punchapash willachiy.',
    'vaccineRemindersEnabledMessage': 'Vacunapa yuyachikuna rikurishkami.',
    'vaccineRemindersDisabledMessage': 'Vacunapa yuyachikuna wañuchishkami.',
    'notificationPermissionDenied':
        'Willachiykunata rikuchinkapak permiso mana kurkachu.',
    'testNotification': 'Willachiyta probay',
    'vaccineNotificationTitle': '{name} wawa vacunata chaskinka 💉',
    'vaccineNotification7Days':
        'Shuk semana kipaka {name} wawapa {vaccine} vacunata rikuna kan.',
    'registerGrowthControl': 'Wiñay controlta killkachiy',
    'editGrowthControl': 'Controlta tikrachiy',
    'saveGrowthControl': 'Controlta wakaychiy',
    'latestGrowthControl': 'Katik control',
    'growthHistory': 'Controlkunapa ñawpa willay',
    'noGrowthControls': 'Manarak controlkuna killkachishkachu',
    'noGrowthControlsSubtitle':
        'Wawapa katipayta kallarinkapak llashata, talla uta suniyayta killkachiy.',
    'growthControlDate': 'Controlpa puncha',
    'weight': 'Llasha',
    'weightKg': 'Kilogramopi llasha',
    'height': 'Talla',
    'length': 'Suniyay',
    'heightCm': 'Centímetropi suniyay uta talla',
    'weightRequired': 'Llashata killkay.',
    'weightInvalid': 'Killkashka llashata alli rikuy.',
    'heightRequired': 'Suniyayta uta tallata killkay.',
    'heightInvalid': 'Killkashka suniyay/tallata alli rikuy.',
    'measurementMethod': 'Tupuna rikchay',
    'measurementMethodDescription':
        'Imashina tupushkata akllay. Kayka wiñay kurvakunata alli yuyaychankapak may alli kan.',
    'recumbentLength': 'Siririshpa suniyay',
    'standingHeight': 'Shayarishpa talla',
    'growthNotesHint': 'Shina: hanpi wasipi rurashka control',
    'deleteGrowthControl': 'Controlta kichuy',
    'deleteGrowthControlQuestion': '¿Kay wiñay controlta kichunaykichu?',
    'growthLoadError': 'Wiñay controlkunata mana kargay usharishkachu.',
    'growthChartsNextStep':
        'Kay controlkunaka llasha/watayuk, talla/watayuk, shuktak indikator grafikakunapi usharinka.',
    'vaccineNotificationTomorrow':
        'Kayapakmi {name} wawapa {vaccine} vacunata rikuna kan.',
    'vaccineNotificationToday':
        'Kunanmi {name} wawapa {vaccine} vacunata rikuna kan.',
    'nutritionRoutineTitle': 'Mikuy pachakuna',
    'nutritionRoutineSubtitle':
        'Alli yachayta rurankapak hawalla mikuy pachakuna',
    'nutritionRoutineTip1':
        'Pakari mikuy, chawpi puncha mikuy, chishi mikuy, tuta mikuy pachakunata ashtawan shina shina charichiy.',
    'nutritionRoutineTip2':
        'Wawa yapa yarikashpa chayamuchun ama sakiychu; piñarina uta mikuyta mana munana ushan.',
    'nutritionRoutineTip3': 'Mikuy pachaka hawalla, mana kallpachishpa kachun.',
    'nutritionRoutineTip4':
        'Aylluwan mikuyka wawata alli yachaykunata katinkapak yanapan.',
    'nutritionRoutineTip5':
        'Mikukpi pantallakunata ama churaychu, wawa yarikayta, saksaytapash riksichun.',
    'healthTrackingTitle': 'Wawapa hampiy katipay',
    'healthGuidanceTitle': 'Mikuy, yanapay yuyay',
    'healthOfChild': '{name} wawa hampiy',
    'healthNoChild': 'Hampiy katipayta kallarinkapak shuk wawata killkachiy.',
    'recipes': 'Yanushkakuna',
    'healthRecipesSubtitle': 'Wawakunapak mikuy, yanushka yuyaykuna',
    'healthProfileRequiredTitle': 'Ñawpaka shuk wawata killkachiy',
    'healthProfileRequiredSubtitle':
        'Vacunakunata, wiñay controlkunatapash alli tinkichinkapak shuk perfilta minishtinchik.',
    'vaccinesPageTitle': 'Vacunakuna',
    'vaccinesScheduleTitle': 'Vacuna ñan',
    'vaccinesScheduleSubtitle':
        'Ecuador MSP 2026 vacuna ñanman rikushpa rurashka.',
    'vaccinesLoadError': 'Vacuna ñanta mana kargay usharishkachu.',
    'registerVaccine': 'Vacunata killkachiy',
    'editVaccineRecord': 'Killkachishkata tikrachiy',
    'vaccineDoseStatus': 'Kay dosispa kay',
    'vaccineDoseStatusSubtitle':
        'Kay dosiska churashkachu mana churashkachu akllay.',
    'vaccineMarkApplied': 'Churashka',
    'vaccineMarkNotApplied': 'Mana churashka',
    'vaccineAppliedOptionHelp': 'Punchata, munashpaka hanpi wasitapash killkachiy.',
    'vaccineNotAppliedOptionHelp': 'Kay dosiska mana churashkachu nishpa killkachiy.',
    'vaccineNotAppliedUnlockInfo':
        'Kay dosista mana churashka nishpa wakaychishpaka, katik dosiska paskarinka. Katik dosiska intervalo punchamanta kanchikpika, mana llullashka punchata churashpa rikunapaqmi sakirinka.',
    'vaccineAppliedDate': 'Vacunata churashka puncha',
    'healthCenterOptional': 'Hanpi wasi (munashpalla)',
    'notesOptional': 'Yuyachikuna (munashpalla)',
    'saveVaccineRecord': 'Killkachishkata wakaychiy',
    'deleteVaccineRecord': 'Killkachishkata kichuy',
    'deleteVaccineRecordQuestion': '¿Kay vacuna killkachishkata kichunaykichu?',
    'vaccinesDisclaimer':
        'Kay katipayka yuyachikllami; vacuna pankata, hanpikpa rikuytapash mana rantinchinchu. Dosis pishik, ñawpa willay mana paktashka, uta vacuna ñanmanta tapuy tiyashpaka hanpi wasiman tapuy.',
    'vaccineSingleDose': 'Shuklla dosis',
    'vaccineBirthDose': 'Wacharikpi dosis',
    'vaccineDose1': 'Shukniki dosis',
    'vaccineDose2': 'Ishkayniki dosis',
    'vaccineDose3': 'Kimsaniki dosis',
    'vaccineDose6Months': '6 killapi dosis',
    'vaccineDose15Months': '15 killapi dosis',
    'vaccineDose18Months': '18 killapi dosis',
    'vaccineDose5Years': '5 watapi dosis',
    'vaccineSeasonalDose': 'Wata killapi vacuna',
    'vaccineBirth24Hours': 'Allikarin kallari 24 pacha ukupi churana.',
    'vaccineSeasonalNote':
        'Punchaka kunan wata killapi vacuna ruranaman rikushpa kan.',
    'vaccineBCG': 'BCG',
    'vaccineHepatitisBZero': 'Hepatitis B - cero dosis',
    'vaccineRotavirus': 'Rotavirus',
    'vaccineHexavalent': 'Hexavalente',
    'vaccinePneumococcal': 'Neumococo',
    'vaccineBOPV': 'Poliomielitis (bOPV)',
    'vaccineInfluenza': 'Influenza estacional',
    'vaccineYellowFever': 'Killu rupay',
    'vaccineMMR': 'SRP',
    'vaccineVaricella': 'Varicela',
    'vaccineDPT': 'DPT',
    'vaccineBCGPrevents':
        'Tuberculosispa sinchi rikchaykunata harkankapak yanapan.',
    'vaccineHepatitisBPrevents': 'Hepatitis B unkuyta harkankapak yanapan.',
    'vaccineRotavirusPrevents':
        'Rotavirusmanta sinchi unkuyta harkankapak yanapan.',
    'vaccineHexavalentPrevents':
        'Vacunawan harkay usharik achka unkuykunamanta kaman.',
    'vaccinePneumococcalPrevents':
        'Neumococomanta shamuk unkuykunata harkankapak yanapan.',
    'vaccinePolioPrevents': 'Poliomielitis unkuyta harkankapak yanapan.',
    'vaccineInfluenzaPrevents': 'Influenza unkuyta harkankapak yanapan.',
    'vaccineYellowFeverPrevents': 'Killu rupay unkuyta harkankapak yanapan.',
    'vaccineMMRPrevents':
        'Sarampión, rubéola, paperas unkuykunata harkankapak yanapan.',
    'vaccineVaricellaPrevents': 'Varicela unkuyta harkankapak yanapan.',
    'vaccineDPTPrevents':
        'Difteria, tosferina, tétanos unkuykunata harkankapak yanapan.',
    'growthPageTitle': 'Wiñay',
    'nutritionHydrationTitle': 'Alli yakuyachiy',
    'nutritionHydrationSubtitle': 'Yaku, alli upyanakuna',
    'nutritionHydrationTip1':
        'Wawapa watayuk shinallatak kashpaka yakumi hatun upyanaka kana.',
    'nutritionHydrationTip2':
        'Gaseosa, artificial jugo, yapa mishki upyanakunata ama kuychu.',
    'nutritionHydrationTip3':
        'Rupay punchakunapi uta pukllashka kipaka ashtawan yaku kuy.',
    'nutritionHydrationTip4':
        'Api, yakuyuk muyukuna, yakuyuk mikuykunapash aychata yakuyachin.',
    'nutritionHydrationTip5':
        'Rupay, lansay uta kichay tiyashpaka yaku pishiyachik unanchakunata rikuy, hanpikman riy.',
    'privacyAndData': 'Pakalla kay, willaykuna',
    'privacySettingsSubtitle': 'Kay aparato ukupi willay, kichuy',
    'privacyTitle': 'Kanpa willayka kanpa makipimi kan',
    'privacyDescription':
        'Wawa Kalúka wawakunapa perfilkunata, controlkunatapash kay aparato ukupi wakaychin; internet mana tiyashpapash ushana ushanki.',
    'localStorageTitle': 'Kay aparato ukupi wakaychiy',
    'localStorageDescription':
        'Wawapa perfilkuna, vacuna killkachishkakuna, wiñay controlkunapash kay aparato ukupi wakaycharin.',
    'storedDataTitle': 'Wakaychishka willay',
    'storedDataDescription':
        'Aplicaciónka wawapa shuti, wacharishka puncha, kari/warmi kay, vacuna killkachishka, llasha, suniyay/talla, kan killkashka yuyachikunatapash wakaychina ushan.',
    'notificationPrivacyTitle': 'Kay aparato ukupi yuyachikuna',
    'notificationPrivacyDescription':
        'Vacunapa yuyachikuna kay aparatopa willachiy sistemawan wakichirin. Vacuna ukupi wañuchina ushanki.',
    'dataManagement': 'Willaykunata kamachiy',
    'dataManagementDescription':
        'Wawapa perfilkunata, Wawa Kalú ukupi killkachishka tukuy hampiy willaytapash kichuna ushanki.',
    'deleteAllChildDataTitle': 'Tukuy wawapa willayta kichuy',
    'deleteAllChildDataDescription':
        'Kay rurayka tukuy perfilkunata, vacuna killkachishkakunata, wiñay controlkunatapash kay aparatopi kichun.',
    'deleteAllChildDataQuestion':
        '¿Tukuy wawapa perfilkunata, paykunapa willaytapash kichunaykichu? Kayta mana kutichina ushankichu.',
    'deleteAllData': 'Tukuy willayta kichuy',
    'allChildDataDeleted': 'Tukuy wawapa willay kichushkami.',
    'deleteAllDataError':
        'Tukuy willayta mana kichuy usharishkachu. Kutin ruray.',
    'privacyFinalNote':
        'Aplicaciónpa shimi, rikchay shina wakichiykunaka wawapa willayta kichukpipash mana kichurinkachu.',
    'nutritionSignalsTitle': 'Wawapa unanchakuna',
    'nutritionSignalsSubtitle': 'Yarikay, saksay, chaskiy',
    'nutritionSignalsTip1':
        'Wawaka mikuyman kimirishpa, shimita paskashpa, mikuyta maskashpa yarikashkata rikuchina ushan.',
    'nutritionSignalsTip2':
        'Umata tikrachishpa, shimita wichkashpa, mana munashpa saksashkata rikuchina ushan.',
    'nutritionSignalsTip3':
        'Platutaka tukuchichun ama kallpachiychu; paypa unanchakunata yupaychay.',
    'nutritionSignalsTip4':
        'Uchilla porciónkunata kuy; ashtawan munashpaka yapay.',
    'nutritionSignalsTip5':
        'Mikuyta llankay, mutkiy, maskaypash yachaypa shuk rakimi kan.',
    'nutritionSafetyTitle': 'Mikukpi kamana',
    'nutritionSafetySubtitle': 'Tukllayta/atragantamiento harkay',
    'nutritionSafetyTip1': 'Wawa mikukpika tukuy pachapi rikushpa katiy.',
    'nutritionSafetyTip2':
        'Sinchi, rumpa, yapa uchilla mikuykunata mana pitishpaka ama kuychu.',
    'nutritionSafetyTip3':
        'Muyukuna, llampu mikuykunata alli, kamashka hatunykunapi pitiy.',
    'nutritionSafetyTip4':
        'Wawaka siririshpa, kallpashpa uta pukllashpa mikuchun ama sakiychu.',
    'nutritionSafetyTip5':
        'Tukuy uva, sinchi mishki, tukuy ñukñu/muyu, hatun pitikunata ama kuychu.',
    'nutritionParentsTitle': 'Tayta-mamakunapak yuyachikuna',
    'nutritionParentsSubtitle': 'Mana kallpachishpa yanapay',
    'nutritionParentsTip1':
        'Alli shunkuwan shuyaymi may alli: tukuy wawakuna mana shina shina mikunkuchu, mana shina pacha mikunkuchu.',
    'nutritionParentsTip2': 'Mikuyta karana uta castigo shina ama usaychu.',
    'nutritionParentsTip3':
        'Wawa munachun tullpuyuk, hawalla platukunata churay.',
    'nutritionParentsTip4':
        'Shuktak wawawan ama chimpapuraychu; paypa kikin wiñayta rikuy.',
    'nutritionParentsTip5':
        'Llashaka pishi, alergia, kutin kutin lansay, uta mikuyta mana munay tiyashpaka hanpikman tapuy.',
    'recipesForChildren': '0–3 watayuk wawakunapak yanushkakuna',
    'recipesShortDesc':
        'Wasipi rurankapak llampu, kamashka, hawalla yanushkakuna.',
    'viewRecipes': 'Yanushkakunata rikuy',
    'nutritionFinalNote':
        'Alli mikuyka wawapa wiñayta yanapan. Watayukman tupak chikan chikan, kamashka mikuykunata kuy. Alergia, pishi llasha uta kutin kutin mikuyta mana munay tiyashpaka hanpikman tapuy.',
    'recipesAppBar': 'Wawapa mikuy',
    'recipesHeaderTitle': 'Wawapa mikuy',
    'recipesHeaderSubtitle':
        '0–3 watayuk wawakunapak llampu, kamashka, alli mikuy yanushkakuna',
    'recipesHeaderNote': 'Tayta-mamakunapak, kamakkunapak yuyaykuna',
    'ingredients': 'Imakunawan rurana',
    'preparation': 'Imashina rurana',
    'recipeFinalNote':
        'Kay yanushkakunaka tukuypak yuyaykunallami. Wawapa watayuk, chaskiy, pediatrapa yuyayman rikushpa llampuyta, porciónta, imakunawan rurashkatapash tikrachiy.',
    'recipe1Title': 'Zapallo, wallpa aycha llampu api',
    'recipe1Age': '6 killamantapacha',
    'recipe1Moment': 'Chawpi puncha mikuy',
    'recipe1Desc':
        'Ashtawan paktashka mikuyta kallarinkapak llampu, kunuk, alli mikuy yanushka.',
    'recipe1Ing1': 'Yanushka zapallo.',
    'recipe1Ing2': 'Uchilla, alli yanushka wallpa aycha.',
    'recipe1Ing3': 'Uchilla papa uta camote.',
    'recipe1Ing4': 'Kunuk yaku uta mana kachiyuk kikin caldo.',
    'recipe1Step1':
        'Zapallota, papata uta camoteta, wallpa aychatapash alli yanuy.',
    'recipe1Step2': 'Wallpa aychata hatun pitikuna ama sakirichun charkiy.',
    'recipe1Step3': 'Tukuyta ñitiy uta licuay, llampu kashkakama.',
    'recipe1Step4': 'Kunuklla, uchilla porciónpi kuy.',
    'recipe1Rec':
        'Wawa complementaria mikuyta kallarikpika alli kan. Kachita, sinchi condimento ama yapaychu.',
    'recipe2Title': 'Bananuwan llampu avena',
    'recipe2Age': '6 killamantapacha',
    'recipe2Moment': 'Pakari mikuy uta chawpi pakari mikuy',
    'recipe2Desc': 'Kallari punchapak kallpayuk, llampu, hawalla rurana.',
    'recipe2Ing1': '3 wishina avena.',
    'recipe2Ing2': '1 uchilla pukushka banano.',
    'recipe2Ing3': 'Yaku uta watayukman tupak ñuñu.',
    'recipe2Ing4': 'Chaskishpaka ashalla canela.',
    'recipe2Step1': 'Avenata ancha llampu kashkakama yanuy.',
    'recipe2Step2': 'Bananota puré tukuchinkakama ñitiy.',
    'recipe2Step3': 'Avenata bananowan chapuy.',
    'recipe2Step4': 'Kunkapak ñawpa chiriyachiy.',
    'recipe2Rec':
        'Shuk wata ñawpak mishkita/mielta ama kuychu. Azúcarta ama yapaychu; bananoka kikin mishkita charin.',
    'recipe3Title': 'Runtu, espinaca llampu tortillita',
    'recipe3Age': '9–12 killamantapacha',
    'recipe3Moment': 'Pakari mikuy, chawpi puncha mikuy uta llampu tuta mikuy',
    'recipe3Desc':
        'Runtuta, ashtawan sinchi mikuyta chaskik wawakunapak llampu akllay.',
    'recipe3Ing1': '1 alli yanushka runtu.',
    'recipe3Ing2': 'Ancha uchilla pitishka espinaca pankakuna.',
    'recipe3Ing3': 'Shuk uchilla wishina aceite.',
    'recipe3Ing4': 'Munashpaka yanushka papa uta zanahoria.',
    'recipe3Step1': 'Runtuta waktay, pitishka espinacawan chapuy.',
    'recipe3Step2': 'Uchilla ninapi tukuylla alli yanushkakama yanuy.',
    'recipe3Step3': 'Uchilla, llampu pitikunapi pitiy.',
    'recipe3Step4': 'Puré uta llampu yuyuwan kushka mikuchiy.',
    'recipe3Rec':
        'Runtuka tukuylla alli yanushka kana. Alergia ñawpa willay tiyashpaka pediatraman ñawpata tapuy.',
    'recipe4Title': 'Arroz, lenteja llampu bolitakuna',
    'recipe4Age': '10–12 killamantapacha',
    'recipe4Moment': 'Chawpi puncha mikuy uta kachiyuk chishi mikuy',
    'recipe4Desc':
        'Kamashka maki hapina, kashtuna yachankapak uchilla llampu porciónkuna.',
    'recipe4Ing1': 'Alli yanushka arroz.',
    'recipe4Ing2': 'Alli yanushka lenteja.',
    'recipe4Ing3': 'Yanushka, ñitishka zanahoria.',
    'recipe4Ing4': 'Llampuyachina kashpaka ashalla kunuk yaku.',
    'recipe4Step1': 'Lentejata ñitiy, llampu arrozwan chapuy.',
    'recipe4Step2': 'Yanushka zanahoriata yapay, rikchayta, mishkita kunapak.',
    'recipe4Step3': 'Uchilla, llampu bolitakunata ruray.',
    'recipe4Step4': 'Ñitishpaka hawalla chinkarina kashkata rikuy.',
    'recipe4Rec':
        'Rikushpa katiy. Bolitakunaka uchilla, llampu, hawalla ñitina kana.',
    'homeHealthLoading': 'Hampiy willayta mushukyachikushpa...',
    'homeHealthLoadError': 'Kay willayta mana mushukyachiy usharishkachu.',
    'appVersion': 'Versión',
    'developers': 'Rurakkuna',
    'homeVaccinesNoPending': 'Kunan katipaypika mana shuyak dosis tiyanchu.',
    'deleteChildError': 'Perfilta mana kichuy usharishkachu. Kutin ruray.',
    'recipe5Title': 'Kikin yogur, muyuwan vasito',
    'recipe5Age': '12 killamantapacha',
    'recipe5Moment': 'Chishi mikuy',
    'recipe5Desc':
        'Ñuñuta chaskik wawakunapak chirilla, tullpuyuk, hawalla chishi mikuy.',
    'recipe5Ing1': 'Mana azúcaryuk kikin yogur.',
    'recipe5Ing2': 'Pukushka, pitishka uta ñitishka muyu.',
    'recipe5Ing3': 'Munashpaka llampu avena.',
    'recipe5Step1': 'Uchilla porción kikin yogurta churay.',
    'recipe5Step2': 'Ñitishka uta kamashka pitikunapi pukushka muyuta yapay.',
    'recipe5Step3': 'Llankalla chapuy.',
    'recipe5Step4': 'Chirilla kuy, shinapash yapa chiri ama kachun.',
    'recipe5Rec':
        'Azúcaryuk yogurta ama kuy. Muyupa pitikuna tiyashpaka rikushpa katiy.',
    'languageTitle': 'Shimi, rimanakuy',
    'languageHeaderSubtitle':
        'Kallari shimikunata yachachinkapak hawalla ruraykuna',
    'touchActivityRecommendation': 'Yuyachiyta rikunkapak shuk rurayta llankay',
    'selectActivity': 'Shuk rurayta akllay',
    'languageDefaultRec':
        'Wasipi wawapa shimita imashina yachachina rikunkapak shuk tarjetata llankay.',
    'languageDefaultHome':
        'Kaypimi maykan ima, rikchay uta punchapa pachawanpash rurana usharik hawalla ruray rikurinka.',
    'languageDefaultParent':
        'Hawalla rimay, ñawita rikuy, pay rimanakunkapak rurashkata kushilla chaskiy.',
    'homeActivity': 'Wasipi ruray',
    'noActivityReviewed': 'Manarak shuk rurayta rikushkachu.',
    'activitiesReviewed': 'Rikushka ruraykuna',
    'languageFinalNote':
        'Sapa wawaka paypa kikin pachapi shimita wiñachin. Uyarikunaman mana kutichik, rimakpi mana rikuk, uta yachashka ushaykunata chinkachikpika hanpikman tapuy.',
    'nameObjectsTitle': 'Imakunata shutichiy',
    'nameObjectsDesc': 'Shimikunata kikin imakunawan tinkichin.',
    'nameObjectsRec':
        'Kuchulla imakunata uchilla, alli rimaykunawan shutichiy. Maykan imatapash ushana ushanki: churana, mikuy, pukllana, yanuna imakuna, aychapa rakikunapash.',
    'nameObjectsHome':
        'Wasipi sasachiy: wawapa kuchupi 3 imata akllay, rikuchiy, shutita llankalla rimay. Wawaka rikuk, rikuchik uta kutin rimankapak kallarikta shuyay.',
    'nameObjectsParent':
        'Wawaka manarak alli rimakpipash mana llakichu. Uyan, tinkichin, ruraypashmi ashtawan alli.',
    'readImagesTitle': 'Rikchaykunata ñawinchay',
    'readImagesDesc': 'Rikuyta, yuyayta, shimikunata sinchiyachin.',
    'readImagesRec':
        'Maykan willay panka, rikchay panka, foto uta shuyutapash usay. Chikan imakuna mana minishtinchu; tullpu, runa, ima, ruraykunata willana ushanki.',
    'readImagesHome':
        'Wasipi sasachiy: wawawan shuk rikchayta rikuy, ima rikurishkata willay. Hawalla tapuykunata ruray: “¿imatata rikunki?”, “¿maypita?”, “¿imatata rurakun?”.',
    'readImagesParent':
        'Shimiwan mana kutichikpipash, rikuy, rikuchiy, asiy uta uyariyta ruraypashmi kutichiy kan.',
    'singMoveTitle': 'Takiy, kuyuriy',
    'singMoveDesc': 'Ritmo, uyariy, rikuchiyta sinchiyachin.',
    'singMoveRec':
        'Uchilla takikunata maki ruraykunawan takiy. Makita waktay, maki kuyuy, llampu uyariykuna, shimi tikraykunatapash ushana ushanki.',
    'singMoveHome':
        'Wasipi sasachiy: uchilla takita takiy, kutin kutin shuk ruraywan ruray. Wawaka uyarita uta kuyuriyta katichun ashalla shuyay.',
    'singMoveParent':
        'Kutin kutin rurayka ashtaka yanapan. Achka chikan takikunamanta, shuk hawalla takita achka punchapi kutin takiy ashtawan alli.',
    'childPhoto': 'Wawapa foto',
    'addPhoto': 'Fotota yapay',
    'changePhoto': 'Fotota tikrachiy',
    'removePhoto': 'Fotota kichuy',
    'talkTitle': 'Rimanakuy',
    'talkDesc': 'Rimanakunkapak munayta sinchiyachin.',
    'talkRec':
        'Wawapa uyarikuna, rikuchikuna, rikuykunata rimanakuy shina kutichiy. Chaywan rimanakuy may alli kashkata yachan.',
    'talkHome':
        'Wasipi sasachiy: wawaka imata rurakushkata rikuy, hawalla shimiwan willay. Rikuy, ruray uta uyarita kutichichun wakin segundo shuyay.',
    'talkParent':
        'Tukuy upalla pachata ama huntachiychu. Shuyaypash wawata rimanakunkapak yanapan.',
    'childNotFound': 'Wawapa perfilta mana tarishkachu.',
    'imitateSoundsTitle': 'Uyarikunata katichiy',
    'imitateSoundsDesc': 'Hawalla uyarikunata kushilla yachachin.',
    'imitateSoundsRec':
        'Ruray, ima, pachamanta hawalla uyarikunata ruray. Shuktak imakuna mana minishtinchu: mancharishka uyariy, llampu waktay, antawakuna uta riksishka wiwakunapa uyarita ushana ushanki.',
    'imitateSoundsHome':
        'Wasipi sasachiy: 3 hawalla uyarita ruray, wawa katichinkapak shuyay. “pa-pa”, “ma-ma”, “toc toc”, “mmm”, “brum” shina uyarikunata usay.',
    'imitateSoundsParent':
        'Maykan kallari ruraytapash kushilla chaskiy. Sinchita ama allinchaychu; alli uyarita kikinlla kutin rimay.',
    'homeGreeting': 'Alli puncha 👋',
    'homeGreetingSubtitle':
        'Shuklla kitimanta wawapa wiñayta, hampiyta, yachaytapash katiy.',
    'selectChild': 'Wawata akllay',
    'tapToChangeChild': 'Perfilta tikrankapak llankay',
    'viewProfile': 'Perfilta rikuy',
    'healthSummary': 'Hampiy willay paktachiy',
    'nextVaccine': 'Katik vacuna',
    'viewVaccines': 'Vacunata rikuy',
    'lastGrowthCheck': 'Katik wiñay control',
    'growthDataPending': 'Manarak llasha, talla controlkuna killkachishkachu.',
    'viewGrowth': 'Wiñayta rikuy',
    'quickSummary': 'Hatun willaykuna',
    'homeNoChildTitle': 'Shuk perfilta rurashpa kallariy',
    'homeNoChildSubtitle':
        'Wiñayta, vacunata, hampiy katipayta allichinkapak kallari wawata killkachiy.',
    'addFirstChild': 'Kallari wawata killkachiy',
    'environmentTitle': 'Kamashka kawsaypachakuna',
    'environmentHeaderSubtitle':
        '0–3 watayuk wawakunapa kamana, hampiy, alli kawsaypak yanapak ñan',
    'touchEnvironmentActions':
        'Rurana yuyaykunata rikunkapak sapa rakita llankay',
    'safeSpacesTitle': 'Kamashka kitikuna',
    'safeSpacesSubtitle': 'Mana manchaywan maskankapak wakichishka wasi',
    'safeSpacesDesc':
        'Kamashka kawsaypachaka wawata pishi manchaywan maskankapak, pukllankapak, yachankapak sakina kan.',
    'safeSpacesA1':
        'Hampikunata, pichana productokunata, uchilla imakunata wawapa maki mana chayamunapi wakaychiy.',
    'safeSpacesA2': 'Enchufekunata killpay, cablekunata allichishpa charichiy.',
    'safeSpacesA3':
        'Kuchuk, rupak uta llashak imakunata mesa manyapi ama sakiychu.',
    'safeSpacesA4':
        'Wawa shimiman churana usharik uchilla pitikuna mana tiyachun pampata rikuy.',
    'safeSpacesAlert':
        'Grada, yanuna uku, armana uku, enchufe, uchilla imakunawan ashtawan rikushpa katiy.',
    'activeSupervisionTitle': 'Kuchupi rikushpa katipay',
    'activeSupervisionSubtitle': 'Mana chinkarishpa kuska yanapay',
    'activeSupervisionDesc':
        'Kuchupi rikushpa katipayka wawapa kuchupi kay, ima rurashkata rikuy, manarak mana alli ruray tiyashpa harkaymi kan.',
    'activeSupervisionA1':
        'Wawa pukllakpi, mikukpi uta purikpi ñawpakpi charichiy.',
    'activeSupervisionA2':
        'Yaku, yanuna uku, grada uta ventana kuchupi sapalla ama sakiychu.',
    'activeSupervisionA3': 'Karuyana kashpaka wawata kamashka kitipi churay.',
    'activeSupervisionA4':
        'Upalla kashkamanta mana tukuy alli kashkata yuyaychu; manchay imata maskakukta rikuy.',
    'activeSupervisionAlert':
        'Accidentekunaka shuk ratullapimi tukuna ushan, ashtawanka yaku uta hawa kitikunapi.',
    'protectiveRoutinesTitle': 'Kamachik punchan ruraykuna',
    'protectiveRoutinesSubtitle': 'Allichiy, samay, hawalla kay',
    'protectiveRoutinesDesc':
        'Punchapi ima katikta yachashpaka wawaka kamashka kashkata yuyan; chaymantami rutinkuna yanapan.',
    'protectiveRoutinesA1':
        'Puñuy, mikuy, pukllay, samay pachakunata ashtawan shina shina charichiy.',
    'protectiveRoutinesA2': 'Shuk ruray tikrarikpika hawalla ñawpata willay.',
    'protectiveRoutinesA3':
        'Puñunkapak ñawpaka uchilla rutina ruray: armachiy, willay ñawinchay uta llampu takiy.',
    'protectiveRoutinesA4':
        'Wawa shaykushka uta piñarishka kashpaka kunkaylla tikraykunata ama ruraychu.',
    'protectiveRoutinesAlert':
        'Mana alli puñuy uta yapa wakllichishka rutinakunaka piñariyta, wakayta mirachina ushan.',
    'affectionTitle': 'Kuyay, alli ruray',
    'affectionSubtitle': 'Kamayka hawalla shunkuwan kutichiyllapashmi',
    'affectionDesc':
        'Kuyay, shuyay, alli rurayka wawapa iñiyta, shunku wiñaytapash sinchiyachin.',
    'affectionA1': 'Ukllay, hawalla rimay, paypa minishtishkakunata kutichiy.',
    'affectionA2':
        'Paypa shunku ruraykunata chaskiy: shaykuy, manchay, piñay, kushipash.',
    'affectionA3': 'Kapariyta, makayta, manchachiyta ama ruraychu.',
    'affectionA4': 'Pantakpika hawalla shimikunawan, llampu shimiwan pushay.',
    'affectionAlert':
        'Hatun runa yapa llakishka kashpaka, piñashpa kutichina ñawpaka yanapayta mañay ashtawan alli.',
    'healthAlertTitle': 'Hampiy, manchay unanchakuna',
    'healthAlertSubtitle': 'Haykapika yanapayta maskana',
    'healthAlertDesc':
        'Wawapi tikraykunata rikuyka pachapi rurankapak, sinchi llakikunata harkankapak yanapan.',
    'healthAlertA1': 'Rupayta, samayta, mikuyta, kallpay kashkatapash rikuy.',
    'healthAlertA2':
        'Takarishka, urmashka, lansashka, kichay, mikuyta mana munashkatapash rikuy.',
    'healthAlertA3':
        'Watayukman rikushpa hanpi controlkunata, vacunakunatapash katichiy.',
    'healthAlertA4':
        'Hanpik mana nikpika wawata kikinmanta hampita ama kuychu.',
    'healthAlertAlert':
        'Samayta mana alli ushakpi, yapa rupaypi, yapa shaykushkapi, kuyurishpa sinchi apishkapi, sinchi takarishkapi uta yaku pishiyachik unanchakuna tiyashpaka utka hanpi yanapayta maskay.',
    'environmentFinalNote':
        'Kamashka kawsaypachaka seguridad, kuyay, rikushpa katipay, punchan rutinakunata tantachin. Punchan uchilla ruraykunaka wawata iñiywan, alli kawsaywan wiñachinkapak yanapan.',
    'kichwa': 'Kichwa',
    'lengthOrHeight': 'Suniyay uta talla',
    'headCircumference': 'Uma muyuntin tupu',
    'headCircumferenceOptional': 'Uma muyuntin tupu (munashpalla)',
    'headCircumferenceInvalid': 'Killkashka uma muyuntin tuputa alli rikuy.',
    'growthSelectorTitle': 'Shuk grafikata akllay',
    'growthSelectorSubtitle': 'Shuklla wiñay kurvata shuk pachapi rikuchin.',
    'growthSelectorWeight': 'Llasha/Watayuk',
    'growthSelectorHeight': 'Talla/Watayuk',
    'growthSelectorBmi': 'IMC/Watayuk',
    'growthSelectorHead': 'Uma muyuntin tupu',
    'growthSelectorWeightLength': 'Llasha/Suniyay',
    'growthSelectorWeightHeight': 'Llasha/Talla',
    'headCircumferenceForAgeChart': 'Watayukman rikushpa uma muyuntin tupu',
    'headCircumferenceForAgeChartDescription':
        'Killkachishka uma muyuntin tuputa watayukman rikushpa rikuchik kurvakunawan chimpapurachin.',
    'headCmShort': 'Uma (cm)',
  };
}
