import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wawa_kalu/app/widgets/liquid_glass_bottom_bar.dart';

void main() {
  final tabs = <LiquidGlassNavItem>[
    const LiquidGlassNavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Inicio',
      color: Color(0xFF7B2CBF),
    ),
    const LiquidGlassNavItem(
      icon: Icons.auto_stories_outlined,
      selectedIcon: Icons.auto_stories_rounded,
      label: 'Aprender',
      color: Color(0xFFFF9F1C),
    ),
    const LiquidGlassNavItem(
      icon: Icons.favorite_border_rounded,
      selectedIcon: Icons.favorite_rounded,
      label: 'Salud',
      color: Color(0xFFEF476F),
    ),
    const LiquidGlassNavItem(
      icon: Icons.child_care_outlined,
      selectedIcon: Icons.child_care_rounded,
      label: 'Mis niños',
      color: Color(0xFF6E56C6),
    ),
  ];

  Future<void> openBar(
    WidgetTester tester, {
    required double width,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Center(child: Text('Wawa Kalú')),
          bottomNavigationBar: LiquidGlassBottomBar(
            selectedIndex: 1,
            items: tabs,
            darkMode: false,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Cuatro pestañas y cápsula activa en pantalla compacta',
      (tester) async {
    await openBar(tester, width: 320);
    for (final label in ['Inicio', 'Aprender', 'Salud', 'Mis niños']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.byIcon(Icons.auto_stories_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Se adapta a una pantalla de tablet', (tester) async {
    await openBar(tester, width: 960);
    expect(find.byType(LiquidGlassBottomBar), findsOneWidget);
    expect(find.text('Mis niños'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Conserva el gesto de selección de otra pestaña', (tester) async {
    int selected = -1;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: LiquidGlassBottomBar(
            selectedIndex: 1,
            items: tabs,
            darkMode: false,
            onSelected: (index) => selected = index,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salud'));
    expect(selected, 2);
  });

  testWidgets('Las GlobalKeys para el recorrido siguen presentes',
      (tester) async {
    final keys = List<GlobalKey>.generate(4, (_) => GlobalKey());
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: LiquidGlassBottomBar(
            selectedIndex: 1,
            items: tabs,
            darkMode: false,
            itemKeys: keys,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final key in keys) {
      expect(key.currentContext, isNotNull);
    }
  });
}
