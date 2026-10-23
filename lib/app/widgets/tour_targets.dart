import 'package:flutter/widgets.dart';

/// Referencias visuales para iluminar controles reales durante el tour.
/// No cambian el aspecto ni el comportamiento de los botones.
class TourTargets {
  TourTargets._();

  static final GlobalKey settingsButton =
      GlobalKey(debugLabel: 'wawa_tour_settings');
}
