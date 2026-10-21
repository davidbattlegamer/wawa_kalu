import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wawa_kalu/features/learning/data/parent_activity_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Solo los 16 juegos y actividades tienen fotos locales',
      (tester) async {
    expect(parentActivityCatalog, hasLength(21));

    final games = parentActivityCatalog
        .where((activity) => activity.area != ActivityArea.protection)
        .toList();
    final protection = parentActivityCatalog
        .where((activity) => activity.area == ActivityArea.protection)
        .toList();

    expect(games, hasLength(16));
    expect(protection, hasLength(5));

    for (final activity in games) {
      final imagePath = activity.imageAsset;
      expect(imagePath, isNotNull, reason: activity.id);
      expect(imagePath, 'assets/images/learning/${activity.id}.webp');

      // No dependemos de Image.network: cada recurso forma parte del APK.
      final bytes = await rootBundle.load(imagePath!);
      expect(bytes.lengthInBytes, greaterThan(3000), reason: activity.id);
    }

    for (final activity in protection) {
      expect(activity.imageAsset, isNull, reason: activity.id);
    }
  });
}
