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
```

---

## 🚀 Instalación del proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/davidbattlegamer/wawa_kalu.git
```

### 2. Entrar a la carpeta del proyecto

```bash
cd wawa_kalu
```

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Ejecutar la aplicación

```bash
flutter run
```

---

## 📦 Dependencias principales

El proyecto puede incluir dependencias como:

```yaml
dependencies:
  flutter:
    sdk: flutter

  google_fonts: ^6.2.1
  shared_preferences: ^2.3.2
  vibration: ^2.0.1
  flutter_blue_plus: ^1.32.12
  audioplayers: ^6.1.0
```

> Las versiones pueden variar según el archivo `pubspec.yaml` del proyecto.

---

## ⚙️ Configuración de la app

La aplicación cuenta con una pantalla de configuración donde el usuario puede modificar:

- 🔊 Sonidos.
- 📳 Vibración.
- 🌐 Idioma.
- 🌙 Apariencia.

Las configuraciones se guardan localmente usando `SharedPreferences`.

---

## 🌐 Idiomas disponibles

Los textos de la app están centralizados en:

```text
lib/pages/app_texts.dart
```

Actualmente la app soporta:

- Español.
- Inglés.
- Detección automática según el idioma del celular.

---

## 🎮 Sección de juegos

La app cuenta con una zona de juegos donde se integran varias actividades educativas.

### 🧩 Juego de Paty

Juego de figuras donde el niño puede tocar formas básicas como:

- Círculo.
- Cuadrado.
- Triángulo.
- Estrella.

El juego registra aciertos y entrega recompensas visuales.

### ❓ Juego de Andrés

Juego tipo trivia diseñado para reforzar el aprendizaje mediante preguntas, respuestas y retos sencillos.

### 🐾 Juego David

Juego de animales donde el niño puede tocar diferentes animales, escuchar sonidos y ganar estrellas o medallas.

Animales incluidos:

- Perro.
- Gato.
- Pollito.
- Vaca.

---

## 🤖 Sección CPS con ESP32

La sección CPS permite conectar la aplicación con un **ESP32** mediante Bluetooth BLE.

Su objetivo es detectar figuras físicas colocadas por el niño y reflejar los resultados en pantalla.

Funciones principales:

- Conexión Bluetooth BLE.
- Detección de figuras.
- Historial offline.
- Recompensas por detecciones.
- Estrellas y medallas según el avance.

---

## 🥗 Nutrición infantil

La sección de nutrición ofrece recomendaciones para padres y cuidadores de niños de 0 a 3 años.

Incluye consejos sobre:

- Alimentos adecuados.
- Rutinas de comida.
- Hidratación.
- Señales de hambre y saciedad.
- Seguridad al comer.
- Acompañamiento familiar.

---

## 🍲 Recetas

La aplicación incluye recetas sencillas y seguras para niños pequeños, como:

- Cremita de zapallo y pollo.
- Avena cremosa con banano.
- Tortillita suave de huevo y espinaca.
- Bolitas blandas de arroz y lenteja.
- Yogur natural con fruta.

---

## 🗣️ Lenguaje y comunicación

Esta sección contiene actividades para estimular el lenguaje infantil mediante acciones simples en casa.

Ejemplos de actividades:

- Nombrar objetos.
- Leer imágenes.
- Cantar y moverse.
- Conversar.
- Imitar sonidos.

---

## 🏡 Entornos protectores

La sección de entornos protectores brinda recomendaciones sobre seguridad, cuidado y bienestar infantil.

Incluye temas como:

- Espacios seguros.
- Supervisión activa.
- Rutinas protectoras.
- Afecto y buen trato.
- Salud y señales de alerta.

---

## 📲 Compatibilidad

El proyecto está pensado para funcionar en:

- Android.
- iOS, con configuración adicional desde macOS.
- Emuladores Android.
- Dispositivos físicos Android.

> Para compilar en iOS se requiere macOS, Xcode o una plataforma de compilación en la nube como Codemagic.

---

## 🧪 Comandos útiles

### Verificar Flutter

```bash
flutter doctor
```

### Limpiar el proyecto

```bash
flutter clean
```

### Obtener dependencias

```bash
flutter pub get
```

### Ejecutar la app

```bash
flutter run
```

### Formatear código

```bash
dart format lib
```

### Generar APK

```bash
flutter build apk --release
```

---

## 📁 Archivos importantes

### `main.dart`

Archivo principal de la aplicación. Carga la configuración inicial y decide si mostrar la bienvenida o el menú principal.

### `app_config.dart`

Controla las configuraciones globales de la app:

- Idioma.
- Idioma automático.
- Sonidos.
- Vibración.
- Tema claro, oscuro o automático.
- Estado de bienvenida.

### `app_texts.dart`

Contiene los textos de la aplicación en español e inglés.

### `config_sheet.dart`

Contiene la ventana de configuración de la app.

### `juego_page.dart`

Contiene la pantalla principal de la zona de juegos.

### `cps_page.dart`

Contiene la lógica de conexión con ESP32 y detección de figuras.

---

## 📌 Estado del proyecto

Actualmente el proyecto se encuentra en desarrollo y mejora continua.

Funciones implementadas:

- Diseño principal de la app.
- Pantalla de bienvenida.
- Configuración global.
- Modo claro, oscuro y automático.
- Idioma español, inglés y automático.
- Juegos educativos.
- Conexión CPS con ESP32.
- Recomendaciones para padres.
- Secciones de nutrición, recetas, lenguaje y entornos protectores.

---

## 👨‍🎓 Autor

Proyecto desarrollado como propuesta educativa y tecnológica basada en sistemas interactivos para niños.

**Autor:** David Santana  
**GitHub:** [davidbattlegamer](https://github.com/davidbattlegamer)

---

## 📄 Licencia

Este proyecto puede ser usado con fines educativos y académicos.

Puedes modificar esta sección si deseas usar una licencia específica, por ejemplo:

- MIT License.
- Apache License 2.0.
- GNU GPL.

---

## 💙 Agradecimiento

Wawa Kalú nace como una propuesta para unir tecnología, educación y cuidado infantil, demostrando cómo una aplicación móvil puede apoyar el aprendizaje temprano y la participación familiar.
