import 'package:flutter/widgets.dart';

/// Referencias visuales para iluminar controles reales durante el tour.
/// No cambian el aspecto ni el comportamiento de los botones.
class TourTargets {
  TourTargets._();

  static final GlobalKey settingsButton =
      GlobalKey(debugLabel: 'wawa_tour_settings');

  // Entradas reales de la pantalla Salud.
  static final GlobalKey vaccinesCard =
      GlobalKey(debugLabel: 'wawa_tour_vaccines');
  static final GlobalKey growthCard =
      GlobalKey(debugLabel: 'wawa_tour_growth');
  static final GlobalKey nutritionCard =
      GlobalKey(debugLabel: 'wawa_tour_nutrition');

  static GlobalKey? healthCardForStep(int step) => switch (step) {
    2 => vaccinesCard,
    3 => growthCard,
    4 => nutritionCard,
    _ => null,
  };
}
