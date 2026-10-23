import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  AppConfig._();

  static final ValueNotifier<bool> vibracionActiva = ValueNotifier<bool>(true);

  static final ValueNotifier<String> idioma = ValueNotifier<String>('es');

  static final ValueNotifier<bool> idiomaAuto = ValueNotifier<bool>(true);

  static final ValueNotifier<bool> bienvenidaVista = ValueNotifier<bool>(false);

  // Recorrido único tras entrar a la aplicación por primera vez.
  static final ValueNotifier<bool> recorridoVisto = ValueNotifier<bool>(false);
  static final ValueNotifier<int> recorridoSolicitud = ValueNotifier<int>(0);

  // Guía específica para familias justo después de registrar el primer niño.
  static final ValueNotifier<bool> guiaPrimerNinoVista =
      ValueNotifier<bool>(false);
  static final ValueNotifier<bool> guiaPrimerNinoPendiente =
      ValueNotifier<bool>(false);
  static final ValueNotifier<int> guiaPrimerNinoSolicitud =
      ValueNotifier<int>(0);

  static final ValueNotifier<ThemeMode> temaApp = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  static const Set<String> idiomasSoportados = <String>{'es', 'en', 'qu'};

  // ==========================================================================
  // CARGAR CONFIGURACIÓN
  // ==========================================================================

  static Future<void> cargarConfiguracion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    vibracionActiva.value = prefs.getBool('vibracionActiva') ?? true;

    bienvenidaVista.value = prefs.getBool('bienvenidaVista') ?? false;
    recorridoVisto.value = prefs.getBool('recorridoGuiadoVisto') ?? false;
    guiaPrimerNinoVista.value = prefs.getBool('guiaPrimerNinoVista') ?? false;
    guiaPrimerNinoPendiente.value =
        prefs.getBool('guiaPrimerNinoPendiente') ?? false;

    // ------------------------------------------------------------------------
    // IDIOMA
    //
    // Si existe la clave "idioma", el usuario eligió un idioma manualmente.
    // Si no existe, se usa el idioma del dispositivo.
    // ------------------------------------------------------------------------

    final String? idiomaGuardado = prefs.getString('idioma');

    if (idiomaGuardado != null && idiomasSoportados.contains(idiomaGuardado)) {
      idiomaAuto.value = false;

      idioma.value = idiomaGuardado;
    } else {
      // Limpia valores antiguos o inválidos.
      if (idiomaGuardado != null) {
        await prefs.remove('idioma');
      }

      idiomaAuto.value = true;

      detectarIdiomaDelCelular();
    }

    // ------------------------------------------------------------------------
    // TEMA
    // ------------------------------------------------------------------------

    final String temaGuardado = prefs.getString('temaApp') ?? 'system';

    switch (temaGuardado) {
      case 'light':
        temaApp.value = ThemeMode.light;
        break;

      case 'dark':
        temaApp.value = ThemeMode.dark;
        break;

      case 'system':
      default:
        temaApp.value = ThemeMode.system;
        break;
    }
  }

  // ==========================================================================
  // IDIOMA DEL DISPOSITIVO
  // ==========================================================================

  static void detectarIdiomaDelCelular() {
    final Locale locale = PlatformDispatcher.instance.locale;

    final String languageCode = locale.languageCode.toLowerCase();

    switch (languageCode) {
      case 'en':
        idioma.value = 'en';
        break;

      // BCP-47 / ISO 639:
      // "qu" corresponde a Quechua.
      // Para Wawa Kalú esta opción se presenta al usuario como
      // Kichwa del Ecuador.
      case 'qu':
      case 'quz':
        idioma.value = 'qu';
        break;

      case 'es':
      default:
        idioma.value = 'es';
        break;
    }
  }

  // ==========================================================================
  // VIBRACIÓN
  // ==========================================================================

  static Future<void> cambiarVibracion(bool valor) async {
    vibracionActiva.value = valor;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('vibracionActiva', valor);
  }

  // ==========================================================================
  // IDIOMA MANUAL
  // ==========================================================================

  static Future<void> cambiarIdioma(String nuevoIdioma) async {
    if (!idiomasSoportados.contains(nuevoIdioma)) {
      throw ArgumentError.value(
        nuevoIdioma,
        'nuevoIdioma',
        'Idioma no soportado.',
      );
    }

    idiomaAuto.value = false;

    idioma.value = nuevoIdioma;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('idioma', nuevoIdioma);
  }

  // ==========================================================================
  // IDIOMA AUTOMÁTICO
  // ==========================================================================

  static Future<void> cambiarIdiomaAutomatico() async {
    idiomaAuto.value = true;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Sin clave guardada = modo automático.
    await prefs.remove('idioma');

    detectarIdiomaDelCelular();
  }

  // ==========================================================================
  // TEMA
  // ==========================================================================

  static Future<void> cambiarTema(ThemeMode nuevoTema) async {
    temaApp.value = nuevoTema;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (nuevoTema) {
      case ThemeMode.light:
        await prefs.setString('temaApp', 'light');
        break;

      case ThemeMode.dark:
        await prefs.setString('temaApp', 'dark');
        break;

      case ThemeMode.system:
        await prefs.setString('temaApp', 'system');
        break;
    }
  }

  // ==========================================================================
  // BIENVENIDA
  // ==========================================================================

  static Future<void> marcarBienvenidaVista() async {
    bienvenidaVista.value = true;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('bienvenidaVista', true);
  }

  static Future<void> reiniciarBienvenida() async {
    bienvenidaVista.value = false;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('bienvenidaVista', false);
  }

  // ==========================================================================
  // RECORRIDO DE BIENVENIDA
  // ==========================================================================

  static Future<void> marcarRecorridoVisto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('recorridoGuiadoVisto', true);
    recorridoVisto.value = true;
  }

  /// Permite repetirlo desde Configuración, sin alterar perfiles ni fechas.
  static void solicitarRecorrido() {
    recorridoSolicitud.value++;
  }

  /// Iniciar después del primer registro; también permite repetir la guía.
  static void solicitarGuiaPrimerNino() {
    guiaPrimerNinoSolicitud.value++;
  }

  static Future<void> prepararGuiaPrimerNino() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guiaPrimerNinoPendiente', true);
    guiaPrimerNinoPendiente.value = true;
  }

  static Future<void> marcarGuiaPrimerNinoVista() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guiaPrimerNinoVista', true);
    await prefs.setBool('guiaPrimerNinoPendiente', false);
    guiaPrimerNinoPendiente.value = false;
    guiaPrimerNinoVista.value = true;
  }

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  static bool get vibracionEncendida => vibracionActiva.value;

  static bool get idiomaEspanol => idioma.value == 'es';

  static bool get idiomaIngles => idioma.value == 'en';

  static bool get idiomaKichwa => idioma.value == 'qu';

  static bool get temaAutomatico => temaApp.value == ThemeMode.system;

  static bool get temaClaro => temaApp.value == ThemeMode.light;

  static bool get temaOscuro => temaApp.value == ThemeMode.dark;
}
