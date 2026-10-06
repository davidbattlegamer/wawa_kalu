import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app/app_shell.dart';

import 'core/notifications/notification_service.dart';
import 'core/privacy/privacy_service.dart';

import 'features/children/data/child_repository.dart';
import 'features/vaccines/services/vaccine_notification_service.dart';

import 'pages/app_config.dart';
import 'pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // SQLITE EN WINDOWS / LINUX / MACOS
  // ============================================================

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // ============================================================
  // CONFIGURACIÓN GENERAL
  // ============================================================

  await AppConfig.cargarConfiguracion();

  // ============================================================
  // PRIVACIDAD
  // ============================================================

  await PrivacyService.instance.initialize();

  // ============================================================
  // BASE DE DATOS / NIÑOS
  // ============================================================

  await ChildRepository.instance.initialize();

  // ============================================================
  // NOTIFICACIONES
  // ============================================================

  await NotificationService.instance.initialize();

  // Si los recordatorios de vacunas ya estaban activados,
  // volvemos a comprobar y programar los pendientes.
  await VaccineNotificationService.instance.refreshIfEnabled();

  // ============================================================
  // INICIAR APLICACIÓN
  // ============================================================

  runApp(
    const WawaKaluApp(),
  );
}

class WawaKaluApp extends StatelessWidget {
  const WawaKaluApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppConfig.temaApp,
      builder: (
        context,
        temaActual,
        _,
      ) {
        return ValueListenableBuilder<bool>(
          valueListenable:
              AppConfig.bienvenidaVista,
          builder: (
            context,
            bienvenidaVista,
            _,
          ) {
            return MaterialApp(
              title: 'Wawa Kalú',

              debugShowCheckedModeBanner:
                  false,

              themeMode: temaActual,

              // =================================================
              // TEMA CLARO
              // =================================================

              theme: ThemeData(
                brightness:
                    Brightness.light,

                useMaterial3: true,

                scaffoldBackgroundColor:
                    const Color(
                  0xFFFAF7F2,
                ),

                colorScheme:
                    ColorScheme.fromSeed(
                  seedColor:
                      const Color(
                    0xFF7B2CBF,
                  ),
                  brightness:
                      Brightness.light,
                ),

                appBarTheme:
                    const AppBarTheme(
                  centerTitle: false,
                  elevation: 0,
                ),

                inputDecorationTheme:
                    InputDecorationTheme(
                  filled: true,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                  ),
                ),
              ),

              // =================================================
              // TEMA OSCURO
              // =================================================

              darkTheme: ThemeData(
                brightness:
                    Brightness.dark,

                useMaterial3: true,

                scaffoldBackgroundColor:
                    const Color(
                  0xFF15131A,
                ),

                colorScheme:
                    ColorScheme.fromSeed(
                  seedColor:
                      const Color(
                    0xFF7B2CBF,
                  ),
                  brightness:
                      Brightness.dark,
                ),

                appBarTheme:
                    const AppBarTheme(
                  centerTitle: false,
                  elevation: 0,
                ),

                inputDecorationTheme:
                    InputDecorationTheme(
                  filled: true,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                  ),
                ),
              ),

              // =================================================
              // ALTO CONTRASTE CLARO
              // =================================================

              highContrastTheme:
                  ThemeData(
                brightness:
                    Brightness.light,

                useMaterial3: true,

                scaffoldBackgroundColor:
                    Colors.white,

                colorScheme:
                    ColorScheme.fromSeed(
                  seedColor:
                      const Color(
                    0xFF5A189A,
                  ),
                  brightness:
                      Brightness.light,
                  contrastLevel: 1.0,
                ),
              ),

              // =================================================
              // ALTO CONTRASTE OSCURO
              // =================================================

              highContrastDarkTheme:
                  ThemeData(
                brightness:
                    Brightness.dark,

                useMaterial3: true,

                scaffoldBackgroundColor:
                    Colors.black,

                colorScheme:
                    ColorScheme.fromSeed(
                  seedColor:
                      const Color(
                    0xFFC77DFF,
                  ),
                  brightness:
                      Brightness.dark,
                  contrastLevel: 1.0,
                ),
              ),

              // =================================================
              // INICIO
              // =================================================

              home: bienvenidaVista
                  ? const AppShell()
                  : const WelcomePage(),
            );
          },
        );
      },
    );
  }
}