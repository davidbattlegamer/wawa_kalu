import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wawa_kalu/app/widgets/app_tour_overlay.dart';
import 'package:wawa_kalu/pages/app_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('El tour se muestra una sola vez y se recuerda en el dispositivo',
      () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await AppConfig.cargarConfiguracion();
    expect(AppConfig.recorridoVisto.value, isFalse);

    await AppConfig.marcarRecorridoVisto();
    expect(AppConfig.recorridoVisto.value, isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('recorridoGuiadoVisto'), isTrue);

    // La preferencia sigue disponible tras volver a cargar la app.
    await AppConfig.cargarConfiguracion();
    expect(AppConfig.recorridoVisto.value, isTrue);
  });

  test('Solicitar el tour de nuevo no borra el estado guardado', () async {
    final previous = AppConfig.recorridoSolicitud.value;
    AppConfig.solicitarRecorrido();
    expect(AppConfig.recorridoSolicitud.value, previous + 1);
    expect(AppConfig.recorridoVisto.value, isTrue);
  });

  testWidgets('El panel tiene opciones reales para continuar y omitir',
      (tester) async {
    AppConfig.idioma.value = 'es';
    int nextCalls = 0;
    int skips = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTourOverlay(
            step: 0,
            focusRect: null,
            onNext: () => nextCalls++,
            onBack: () {},
            onSkip: () => skips++,
          ),
        ),
      ),
    );

    expect(find.text('¡Descubre Wawa Kalú!'), findsOneWidget);
    expect(find.text('Paso 1 de 5'), findsOneWidget);
    expect(find.text('Omitir'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    expect(nextCalls, 1);

    await tester.tap(find.text('Omitir'));
    expect(skips, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El último paso se puede finalizar', (tester) async {
    int finishes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTourOverlay(
            step: 4,
            focusRect: const Rect.fromLTWH(300, 40, 42, 42),
            onNext: () => finishes++,
            onBack: () {},
            onSkip: () {},
          ),
        ),
      ),
    );
    expect(find.text('Todo a tu gusto'), findsOneWidget);
    await tester.tap(find.text('¡Entendido!'));
    expect(finishes, 1);
    expect(tester.takeException(), isNull);
  });
}
