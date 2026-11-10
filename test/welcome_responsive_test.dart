import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wawa_kalu/pages/app_config.dart';
import 'package:wawa_kalu/pages/app_texts.dart';
import 'package:wawa_kalu/pages/welcome_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> buildWelcome(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    AppConfig.idioma.value = 'es';
    AppConfig.temaApp.value = ThemeMode.light;

    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomePage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('En teléfono vertical se mantiene la bienvenida original',
      (tester) async {
    await buildWelcome(tester, const Size(390, 844));

    expect(find.text(T.txt('welcomeHeroTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeTrustTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeFooterNote')), findsOneWidget);
    expect(find.text(T.txt('welcomeStartButton')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('En tablet horizontal se muestra la composición de dos columnas',
      (tester) async {
    await buildWelcome(tester, const Size(1366, 768));

    expect(find.text(T.txt('welcomeHeroTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeFeatureHealthTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeFeatureLearnTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeFeatureFamilyTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeStartButton')), findsOneWidget);

    // La vista panorámica omite la banda y nota propias del diseño
    // vertical: no duplica contenido ni modifica ese diseño.
    expect(find.text(T.txt('welcomeTrustTitle')), findsNothing);
    expect(find.text(T.txt('welcomeFooterNote')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('En tablet vertical también se usa el diseño para tablet',
      (tester) async {
    await buildWelcome(tester, const Size(834, 1112));
    expect(find.text(T.txt('welcomeTrustTitle')), findsNothing);
    expect(find.text(T.txt('welcomeStartButton')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('En teléfono horizontal compacto no hay desbordamientos',
      (tester) async {
    await buildWelcome(tester, const Size(640, 360));
    expect(find.text(T.txt('welcomeHeroTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeStartButton')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('La vista horizontal mantiene las traducciones',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    AppConfig.idioma.value = 'en';
    await tester.pumpWidget(const MaterialApp(home: WelcomePage()));
    await tester.pumpAndSettle();
    expect(find.text(T.txt('welcomeFeatureHealthTitle')), findsOneWidget);
    expect(find.text(T.txt('welcomeStartButton')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
