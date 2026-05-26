# 🌈 Wawa Kalú

**Wawa Kalú** es una aplicación móvil educativa desarrollada en **Flutter**, orientada al aprendizaje infantil, la estimulación temprana y el acompañamiento familiar mediante juegos, actividades interactivas, recomendaciones para padres y conexión con sistemas embebidos como el **ESP32**.

La aplicación integra secciones de juegos, nutrición, lenguaje, entornos protectores y un sistema CPS con figuras inteligentes.

---

## 📱 Descripción del proyecto

Wawa Kalú busca apoyar el aprendizaje de niños pequeños mediante una experiencia visual, sencilla e interactiva.

El proyecto incluye:

- 🎮 Juegos educativos.
- 🧩 Juego de Paty con figuras y recompensas.
- ❓ Juego de Andrés tipo trivia.
- 🐾 Juego David con animales, sonidos, estrellas y medallas.
- 🤖 Sección CPS con conexión a ESP32 mediante Bluetooth BLE.
- 🥗 Consejos de nutrición infantil.
- 🍲 Recetas para niños de 0 a 3 años.
- 🗣️ Actividades para estimular lenguaje y comunicación.
- 🏡 Recomendaciones sobre entornos protectores.
- ⚙️ Configuración de idioma, sonidos, vibración y apariencia.
- 🌙 Modo claro, oscuro y automático.
- 🌐 Soporte para español, inglés e idioma automático.

---

## 🛠️ Tecnologías utilizadas

- Flutter
- Dart
- Android Studio
- Visual Studio Code
- ESP32
- Bluetooth BLE
- Shared Preferences
- Vibration
- Google Fonts

---

## 📂 Estructura general del proyecto

```text
lib/
│
├── main.dart
│
├── pages/
│   ├── app_config.dart
│   ├── app_texts.dart
│   ├── home_page.dart
│   ├── welcome_page.dart
│   ├── juego_page.dart
│   ├── cps_page.dart
│   ├── nutrition_page.dart
│   ├── recipes_page.dart
│   ├── language_page.dart
│   ├── environment_page.dart
│   │
│   ├── alumnos/
│   │   ├── juego_david.dart
│   │   ├── juego_paty.dart
│   │   └── juego_andres.dart
│   │
│   └── widgets/
│       └── config_sheet.dart
│
assets/
│
├── images/
│   └── familia_kalu.png
│
└── sounds/
    ├── dog.mp3
    ├── cat.mp3
    ├── chick.mp3
    └── cow.mp3
