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
  test('La guía del primer niño se recuerda al finalizar u omitir', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await AppConfig.cargarConfiguracion();
    expect(AppConfig.guiaPrimerNinoVista.value, isFalse);

    await AppConfig.prepararGuiaPrimerNino();
    expect(AppConfig.guiaPrimerNinoPendiente.value, isTrue);

    final originalRequest = AppConfig.guiaPrimerNinoSolicitud.value;
    AppConfig.solicitarGuiaPrimerNino();
    expect(AppConfig.guiaPrimerNinoSolicitud.value, originalRequest + 1);

    await AppConfig.marcarGuiaPrimerNinoVista();
    expect(AppConfig.guiaPrimerNinoVista.value, isTrue);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('guiaPrimerNinoVista'), isTrue);
    expect(prefs.getBool('guiaPrimerNinoPendiente'), isFalse);
    expect(AppConfig.guiaPrimerNinoPendiente.value, isFalse);

    await AppConfig.cargarConfiguracion();
    expect(AppConfig.guiaPrimerNinoVista.value, isTrue);
  });

  testWidgets('La segunda guía enseña vacunas, gráficas y recetas',
      (tester) async {
    AppConfig.idioma.value = 'es';
    final cases = <int, String>{
      0: '¡Ana ya tiene su espacio!',
      1: 'Todo comienza en Salud',
      2: 'Vacunas y recordatorios',
      3: 'Sus gráficas de crecimiento',
      4: 'Recetas adecuadas a su edad',
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTourOverlay(
              variant: AppTourVariant.firstChild,
              childName: 'Ana',
              step: entry.key,
              focusRect: entry.key == 0
                  ? null
                  : const Rect.fromLTWH(120, 430, 95, 65),
              onNext: () {},
              onBack: () {},
              onSkip: () {},
            ),
          ),
        ),
      );
      expect(find.text(entry.value), findsOneWidget);
      expect(find.text('Paso ${entry.key + 1} de 5'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    expect(find.text('¡Entendido!'), findsOneWidget);
  });

}
