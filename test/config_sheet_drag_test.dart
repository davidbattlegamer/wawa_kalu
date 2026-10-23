import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wawa_kalu/pages/widgets/config_sheet.dart';

void main() {
  testWidgets('Configuración se puede arrastrar hacia abajo', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showConfigSheet(context),
                child: const Text('Abrir configuración'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir configuración'));
    await tester.pumpAndSettle();

    final draggable = find.byType(DraggableScrollableSheet);
    expect(draggable, findsOneWidget);
    final sheet = tester.widget<DraggableScrollableSheet>(draggable);
    expect(sheet.expand, isFalse);
    expect(sheet.minChildSize, lessThan(sheet.initialChildSize));
    expect(sheet.shouldCloseOnMinExtent, isTrue);

    // Deslizar desde el interior también debe desplazar el panel,
    // no únicamente la lista de ajustes.
    final rect = tester.getRect(draggable);
    await tester.timedDragFrom(
      Offset(rect.center.dx, rect.top + 46),
      const Offset(0, 720),
      const Duration(milliseconds: 450),
    );
    await tester.pumpAndSettle();
    expect(draggable, findsNothing);
  });
}
