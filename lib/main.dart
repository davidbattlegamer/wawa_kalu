import 'package:flutter/material.dart';

import 'pages/app_config.dart';
import 'pages/home_page.dart';
import 'pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.cargarConfiguracion();

  runApp(const WawaKaluApp());
}

class WawaKaluApp extends StatelessWidget {
  const WawaKaluApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppConfig.temaApp,
      builder: (context, temaActual, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: AppConfig.bienvenidaVista,
          builder: (context, bienvenidaVista, _) {
            return MaterialApp(
              title: 'Wawa Kalú',
              debugShowCheckedModeBanner: false,
              themeMode: temaActual,
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFFAF7F2),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF7B2CBF),
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF15131A),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF7B2CBF),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              home: bienvenidaVista ? const HomePage() : const WelcomePage(),
            );
          },
        );
      },
    );
  }
}
