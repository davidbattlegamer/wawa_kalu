import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static ValueNotifier<bool> sonidosActivos = ValueNotifier<bool>(true);
  static ValueNotifier<bool> vibracionActiva = ValueNotifier<bool>(true);

  static ValueNotifier<String> idioma = ValueNotifier<String>('es');
  static ValueNotifier<bool> idiomaAuto = ValueNotifier<bool>(true);

  static ValueNotifier<bool> bienvenidaVista = ValueNotifier<bool>(false);

  static ValueNotifier<ThemeMode> temaApp = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  static Future<void> cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();

    sonidosActivos.value = prefs.getBool('sonidosActivos') ?? true;
    vibracionActiva.value = prefs.getBool('vibracionActiva') ?? true;
    bienvenidaVista.value = prefs.getBool('bienvenidaVista') ?? false;

    final String? idiomaGuardado = prefs.getString('idioma');

    if (idiomaGuardado != null) {
      idiomaAuto.value = false;
      idioma.value = idiomaGuardado;
    } else {
      idiomaAuto.value = true;
      detectarIdiomaDelCelular();
    }

    final String temaGuardado = prefs.getString('temaApp') ?? 'system';

    if (temaGuardado == 'light') {
      temaApp.value = ThemeMode.light;
    } else if (temaGuardado == 'dark') {
      temaApp.value = ThemeMode.dark;
    } else {
      temaApp.value = ThemeMode.system;
    }
  }

  static void detectarIdiomaDelCelular() {
    final String idiomaCelular =
        PlatformDispatcher.instance.locale.languageCode;

    if (idiomaCelular == 'en') {
      idioma.value = 'en';
    } else {
      idioma.value = 'es';
    }
  }

  static Future<void> cambiarSonidos(bool valor) async {
    sonidosActivos.value = valor;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sonidosActivos', valor);
  }

  static Future<void> cambiarVibracion(bool valor) async {
    vibracionActiva.value = valor;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibracionActiva', valor);
  }

  static Future<void> cambiarIdioma(String nuevoIdioma) async {
    idiomaAuto.value = false;
    idioma.value = nuevoIdioma;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idioma', nuevoIdioma);
  }

  static Future<void> cambiarIdiomaAutomatico() async {
    idiomaAuto.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('idioma');

    detectarIdiomaDelCelular();
  }

  static Future<void> cambiarTema(ThemeMode nuevoTema) async {
    temaApp.value = nuevoTema;

    final prefs = await SharedPreferences.getInstance();

    if (nuevoTema == ThemeMode.light) {
      await prefs.setString('temaApp', 'light');
    } else if (nuevoTema == ThemeMode.dark) {
      await prefs.setString('temaApp', 'dark');
    } else {
      await prefs.setString('temaApp', 'system');
    }
  }

  static Future<void> marcarBienvenidaVista() async {
    bienvenidaVista.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bienvenidaVista', true);
  }

  static Future<void> reiniciarBienvenida() async {
    bienvenidaVista.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bienvenidaVista', false);
  }

  static bool get sonidosEncendidos => sonidosActivos.value;

  static bool get vibracionEncendida => vibracionActiva.value;

  static bool get idiomaEspanol => idioma.value == 'es';

  static bool get temaAutomatico => temaApp.value == ThemeMode.system;

  static bool get temaClaro => temaApp.value == ThemeMode.light;

  static bool get temaOscuro => temaApp.value == ThemeMode.dark;
}