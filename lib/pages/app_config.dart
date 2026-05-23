import 'package:flutter/material.dart';

class AppConfig {
  static ValueNotifier<bool> sonidosActivos = ValueNotifier<bool>(true);
  static ValueNotifier<bool> vibracionActiva = ValueNotifier<bool>(true);
  static ValueNotifier<String> idioma = ValueNotifier<String>('es');

  static ValueNotifier<ThemeMode> temaApp = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static void cambiarSonidos(bool valor) {
    sonidosActivos.value = valor;
  }

  static void cambiarVibracion(bool valor) {
    vibracionActiva.value = valor;
  }

  static void cambiarIdioma(String nuevoIdioma) {
    idioma.value = nuevoIdioma;
  }

  static void cambiarTema(bool modoOscuro) {
    temaApp.value = modoOscuro ? ThemeMode.dark : ThemeMode.light;
  }

  static bool get sonidosEncendidos {
    return sonidosActivos.value;
  }

  static bool get vibracionEncendida {
    return vibracionActiva.value;
  }

  static bool get modoOscuroActivo {
    return temaApp.value == ThemeMode.dark;
  }

  static bool get idiomaEspanol {
    return idioma.value == 'es';
  }
}