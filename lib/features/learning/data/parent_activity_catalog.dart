import '../../../pages/app_texts.dart';

// Actividades originales para el acompañamiento familiar de 1 a 5 años.
// Las edades son orientativas: adaptar a intereses y capacidades de cada niño.
enum ActivityArea { exploration, movement, language, protection, thinking, creativity, life, feelings }

class ActivityCopy {
  final String title;
  final String subtitle;
  final String goal;
  final List<String> materials;
  final List<String> steps;
  final String observe;
  final String adapt;
  final String safety;

  const ActivityCopy({
    required this.title,
    required this.subtitle,
    required this.goal,
    required this.materials,
    required this.steps,
    required this.observe,
    required this.adapt,
    required this.safety,
  });
}

class ActivityCopyKeys {
  const ActivityCopyKeys({
    required this.titleKey,
    required this.subtitleKey,
    required this.goalKey,
    required this.materialKeys,
    required this.stepKeys,
    required this.observeKey,
    required this.adaptKey,
    required this.safetyKey,
  });

  final String titleKey;
  final String subtitleKey;
  final String goalKey;
  final List<String> materialKeys;
  final List<String> stepKeys;
  final String observeKey;
  final String adaptKey;
  final String safetyKey;

  ActivityCopy resolve() {
    return ActivityCopy(
      title: T.txt(titleKey),
      subtitle: T.txt(subtitleKey),
      goal: T.txt(goalKey),
      materials: materialKeys.map(T.txt).toList(growable: false),
      steps: stepKeys.map(T.txt).toList(growable: false),
      observe: T.txt(observeKey),
      adapt: T.txt(adaptKey),
      safety: T.txt(safetyKey),
    );
  }
}

class ParentActivity {
  final String id;
  // 0 = 12-23 meses, 1 = 24-35, 2 = 36-47, 3 = 48-71.
  final int ageGroup;
  final ActivityArea area;
  final int minutes;
  final ActivityCopyKeys copyKeys;

  const ParentActivity.localized({
    required this.id,
    required this.ageGroup,
    required this.area,
    required this.minutes,
    required this.copyKeys,
  });

  ActivityCopy copyFor(String language) {
    return copyKeys.resolve();
  }
}

final List<ParentActivity> parentActivityCatalog = <ParentActivity>[
  ParentActivity.localized(
    id: "texturas",
    ageGroup: 0,
    area: ActivityArea.exploration,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActTexturesTitle',
      subtitleKey: 'guideActTexturesSubtitle',
      goalKey: 'guideActTexturesGoal',
      materialKeys: [
        'guideActTexturesMaterial1',
        'guideActTexturesMaterial2',
      ],
      stepKeys: [
        'guideActTexturesStep1',
        'guideActTexturesStep2',
        'guideActTexturesStep3',
      ],
      observeKey: 'guideActTexturesObserve',
      adaptKey: 'guideActTexturesAdapt',
      safetyKey: 'guideActTexturesSafety',
    ),
  ),
  ParentActivity.localized(
    id: "torres",
    ageGroup: 0,
    area: ActivityArea.thinking,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActTowersTitle',
      subtitleKey: 'guideActTowersSubtitle',
      goalKey: 'guideActTowersGoal',
      materialKeys: [
        'guideActTowersMaterial1',
        'guideActTowersMaterial2',
      ],
      stepKeys: [
        'guideActTowersStep1',
        'guideActTowersStep2',
        'guideActTowersStep3',
      ],
      observeKey: 'guideActTowersObserve',
      adaptKey: 'guideActTowersAdapt',
      safetyKey: 'guideActTowersSafety',
    ),
  ),
  ParentActivity.localized(
    id: "canciones",
    ageGroup: 0,
    area: ActivityArea.language,
    minutes: 8,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActSongsTitle',
      subtitleKey: 'guideActSongsSubtitle',
      goalKey: 'guideActSongsGoal',
      materialKeys: [
        'guideActSongsMaterial1',
        'guideActSongsMaterial2',
      ],
      stepKeys: [
        'guideActSongsStep1',
        'guideActSongsStep2',
        'guideActSongsStep3',
      ],
      observeKey: 'guideActSongsObserve',
      adaptKey: 'guideActSongsAdapt',
      safetyKey: 'guideActSongsSafety',
    ),
  ),
  ParentActivity.localized(
    id: "ropa",
    ageGroup: 1,
    area: ActivityArea.life,
    minutes: 12,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActLaundryTitle',
      subtitleKey: 'guideActLaundrySubtitle',
      goalKey: 'guideActLaundryGoal',
      materialKeys: [
        'guideActLaundryMaterial1',
        'guideActLaundryMaterial2',
      ],
      stepKeys: [
        'guideActLaundryStep1',
        'guideActLaundryStep2',
        'guideActLaundryStep3',
      ],
      observeKey: 'guideActLaundryObserve',
      adaptKey: 'guideActLaundryAdapt',
      safetyKey: 'guideActLaundrySafety',
    ),
  ),
  ParentActivity.localized(
    id: "cojines",
    ageGroup: 1,
    area: ActivityArea.movement,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActCushionsTitle',
      subtitleKey: 'guideActCushionsSubtitle',
      goalKey: 'guideActCushionsGoal',
      materialKeys: [
        'guideActCushionsMaterial1',
        'guideActCushionsMaterial2',
      ],
      stepKeys: [
        'guideActCushionsStep1',
        'guideActCushionsStep2',
        'guideActCushionsStep3',
      ],
      observeKey: 'guideActCushionsObserve',
      adaptKey: 'guideActCushionsAdapt',
      safetyKey: 'guideActCushionsSafety',
    ),
  ),
  ParentActivity.localized(
    id: "casita",
    ageGroup: 1,
    area: ActivityArea.feelings,
    minutes: 12,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActCareHomeTitle',
      subtitleKey: 'guideActCareHomeSubtitle',
      goalKey: 'guideActCareHomeGoal',
      materialKeys: [
        'guideActCareHomeMaterial1',
        'guideActCareHomeMaterial2',
      ],
      stepKeys: [
        'guideActCareHomeStep1',
        'guideActCareHomeStep2',
        'guideActCareHomeStep3',
      ],
      observeKey: 'guideActCareHomeObserve',
      adaptKey: 'guideActCareHomeAdapt',
      safetyKey: 'guideActCareHomeSafety',
    ),
  ),
  ParentActivity.localized(
    id: "cuento",
    ageGroup: 2,
    area: ActivityArea.language,
    minutes: 15,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActStoriesTitle',
      subtitleKey: 'guideActStoriesSubtitle',
      goalKey: 'guideActStoriesGoal',
      materialKeys: [
        'guideActStoriesMaterial1',
        'guideActStoriesMaterial2',
      ],
      stepKeys: [
        'guideActStoriesStep1',
        'guideActStoriesStep2',
        'guideActStoriesStep3',
      ],
      observeKey: 'guideActStoriesObserve',
      adaptKey: 'guideActStoriesAdapt',
      safetyKey: 'guideActStoriesSafety',
    ),
  ),
  ParentActivity.localized(
    id: "pintura",
    ageGroup: 2,
    area: ActivityArea.creativity,
    minutes: 15,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActDrawingTitle',
      subtitleKey: 'guideActDrawingSubtitle',
      goalKey: 'guideActDrawingGoal',
      materialKeys: [
        'guideActDrawingMaterial1',
        'guideActDrawingMaterial2',
      ],
      stepKeys: [
        'guideActDrawingStep1',
        'guideActDrawingStep2',
        'guideActDrawingStep3',
      ],
      observeKey: 'guideActDrawingObserve',
      adaptKey: 'guideActDrawingAdapt',
      safetyKey: 'guideActDrawingSafety',
    ),
  ),
  ParentActivity.localized(
    id: "mercado",
    ageGroup: 2,
    area: ActivityArea.thinking,
    minutes: 15,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActMarketTitle',
      subtitleKey: 'guideActMarketSubtitle',
      goalKey: 'guideActMarketGoal',
      materialKeys: [
        'guideActMarketMaterial1',
        'guideActMarketMaterial2',
      ],
      stepKeys: [
        'guideActMarketStep1',
        'guideActMarketStep2',
        'guideActMarketStep3',
      ],
      observeKey: 'guideActMarketObserve',
      adaptKey: 'guideActMarketAdapt',
      safetyKey: 'guideActMarketSafety',
    ),
  ),
  ParentActivity.localized(
    id: "patrones",
    ageGroup: 3,
    area: ActivityArea.thinking,
    minutes: 15,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActPatternsTitle',
      subtitleKey: 'guideActPatternsSubtitle',
      goalKey: 'guideActPatternsGoal',
      materialKeys: [
        'guideActPatternsMaterial1',
        'guideActPatternsMaterial2',
      ],
      stepKeys: [
        'guideActPatternsStep1',
        'guideActPatternsStep2',
        'guideActPatternsStep3',
      ],
      observeKey: 'guideActPatternsObserve',
      adaptKey: 'guideActPatternsAdapt',
      safetyKey: 'guideActPatternsSafety',
    ),
  ),
  ParentActivity.localized(
    id: "barrio",
    ageGroup: 3,
    area: ActivityArea.creativity,
    minutes: 20,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActNeighborhoodTitle',
      subtitleKey: 'guideActNeighborhoodSubtitle',
      goalKey: 'guideActNeighborhoodGoal',
      materialKeys: [
        'guideActNeighborhoodMaterial1',
        'guideActNeighborhoodMaterial2',
        'guideActNeighborhoodMaterial3',
      ],
      stepKeys: [
        'guideActNeighborhoodStep1',
        'guideActNeighborhoodStep2',
        'guideActNeighborhoodStep3',
      ],
      observeKey: 'guideActNeighborhoodObserve',
      adaptKey: 'guideActNeighborhoodAdapt',
      safetyKey: 'guideActNeighborhoodSafety',
    ),
  ),
  ParentActivity.localized(
    id: "emociones",
    ageGroup: 3,
    area: ActivityArea.feelings,
    minutes: 15,
    copyKeys: ActivityCopyKeys(
      titleKey: 'guideActFeelingsTitle',
      subtitleKey: 'guideActFeelingsSubtitle',
      goalKey: 'guideActFeelingsGoal',
      materialKeys: [
        'guideActFeelingsMaterial1',
        'guideActFeelingsMaterial2',
      ],
      stepKeys: [
        'guideActFeelingsStep1',
        'guideActFeelingsStep2',
        'guideActFeelingsStep3',
      ],
      observeKey: 'guideActFeelingsObserve',
      adaptKey: 'guideActFeelingsAdapt',
      safetyKey: 'guideActFeelingsSafety',
    ),
  ),
  ParentActivity.localized(
    id: "nombrar_objetos",
    ageGroup: 0,
    area: ActivityArea.language,
    minutes: 8,
    copyKeys: ActivityCopyKeys(
      titleKey: 'nameObjectsTitle',
      subtitleKey: 'nameObjectsDesc',
      goalKey: 'nameObjectsRec',
      materialKeys: [
        'guideMaterialEverydayObjects',
        'guideMaterialCalmSpace',
      ],
      stepKeys: ['nameObjectsHome'],
      observeKey: 'guideObserveCommunication',
      adaptKey: 'guideAdaptCommunication',
      safetyKey: 'guideSafetyCommunication',
    ),
  ),
  ParentActivity.localized(
    id: "leer_imagenes",
    ageGroup: 1,
    area: ActivityArea.language,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'readImagesTitle',
      subtitleKey: 'readImagesDesc',
      goalKey: 'readImagesRec',
      materialKeys: [
        'guideMaterialPicture',
        'guideMaterialCalmSpace',
      ],
      stepKeys: ['readImagesHome'],
      observeKey: 'guideObserveCommunication',
      adaptKey: 'guideAdaptCommunication',
      safetyKey: 'guideSafetyCommunication',
    ),
  ),
  ParentActivity.localized(
    id: "turnos_conversacion",
    ageGroup: 2,
    area: ActivityArea.language,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'talkTitle',
      subtitleKey: 'talkDesc',
      goalKey: 'talkRec',
      materialKeys: [
        'guideMaterialDailyRoutine',
        'guideMaterialCalmSpace',
      ],
      stepKeys: ['talkHome'],
      observeKey: 'guideObserveCommunication',
      adaptKey: 'guideAdaptCommunication',
      safetyKey: 'guideSafetyCommunication',
    ),
  ),
  ParentActivity.localized(
    id: "juego_sonidos",
    ageGroup: 3,
    area: ActivityArea.language,
    minutes: 12,
    copyKeys: ActivityCopyKeys(
      titleKey: 'imitateSoundsTitle',
      subtitleKey: 'imitateSoundsDesc',
      goalKey: 'imitateSoundsRec',
      materialKeys: [
        'guideMaterialVoice',
        'guideMaterialCalmSpace',
      ],
      stepKeys: ['imitateSoundsHome'],
      observeKey: 'guideObserveCommunication',
      adaptKey: 'guideAdaptCommunication',
      safetyKey: 'guideSafetyCommunication',
    ),
  ),
  ParentActivity.localized(
    id: "casa_segura",
    ageGroup: 0,
    area: ActivityArea.protection,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'safeSpacesTitle',
      subtitleKey: 'safeSpacesSubtitle',
      goalKey: 'safeSpacesDesc',
      materialKeys: [
        'guideMaterialSafeRoom',
        'guideMaterialTrustedAdult',
      ],
      stepKeys: [
        'safeSpacesA1',
        'safeSpacesA2',
        'safeSpacesA3',
        'safeSpacesA4',
      ],
      observeKey: 'guideObserveProtection',
      adaptKey: 'guideAdaptProtection',
      safetyKey: 'safeSpacesAlert',
    ),
  ),
  ParentActivity.localized(
    id: "supervision_activa",
    ageGroup: 1,
    area: ActivityArea.protection,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'activeSupervisionTitle',
      subtitleKey: 'activeSupervisionSubtitle',
      goalKey: 'activeSupervisionDesc',
      materialKeys: [
        'guideMaterialSafeRoom',
        'guideMaterialTrustedAdult',
      ],
      stepKeys: [
        'activeSupervisionA1',
        'activeSupervisionA2',
        'activeSupervisionA3',
        'activeSupervisionA4',
      ],
      observeKey: 'guideObserveProtection',
      adaptKey: 'guideAdaptProtection',
      safetyKey: 'activeSupervisionAlert',
    ),
  ),
  ParentActivity.localized(
    id: "rutina_protectora",
    ageGroup: 2,
    area: ActivityArea.protection,
    minutes: 12,
    copyKeys: ActivityCopyKeys(
      titleKey: 'protectiveRoutinesTitle',
      subtitleKey: 'protectiveRoutinesSubtitle',
      goalKey: 'protectiveRoutinesDesc',
      materialKeys: [
        'guideMaterialRoutineImages',
        'guideMaterialTrustedAdult',
      ],
      stepKeys: [
        'protectiveRoutinesA1',
        'protectiveRoutinesA2',
        'protectiveRoutinesA3',
        'protectiveRoutinesA4',
      ],
      observeKey: 'guideObserveProtection',
      adaptKey: 'guideAdaptProtection',
      safetyKey: 'protectiveRoutinesAlert',
    ),
  ),
  ParentActivity.localized(
    id: "buen_trato",
    ageGroup: 3,
    area: ActivityArea.protection,
    minutes: 12,
    copyKeys: ActivityCopyKeys(
      titleKey: 'affectionTitle',
      subtitleKey: 'affectionSubtitle',
      goalKey: 'affectionDesc',
      materialKeys: [
        'guideMaterialDolls',
        'guideMaterialCalmSpace',
      ],
      stepKeys: [
        'affectionA1',
        'affectionA2',
        'affectionA3',
        'affectionA4',
      ],
      observeKey: 'guideObserveProtection',
      adaptKey: 'guideAdaptProtection',
      safetyKey: 'affectionAlert',
    ),
  ),
  ParentActivity.localized(
    id: "senales_ayuda",
    ageGroup: 3,
    area: ActivityArea.protection,
    minutes: 10,
    copyKeys: ActivityCopyKeys(
      titleKey: 'healthAlertTitle',
      subtitleKey: 'healthAlertSubtitle',
      goalKey: 'healthAlertDesc',
      materialKeys: [
        'guideMaterialDolls',
        'guideMaterialTrustedAdult',
      ],
      stepKeys: [
        'healthAlertA1',
        'healthAlertA2',
        'healthAlertA3',
        'healthAlertA4',
      ],
      observeKey: 'guideObserveProtection',
      adaptKey: 'guideAdaptProtection',
      safetyKey: 'healthAlertAlert',
    ),
  )
];
