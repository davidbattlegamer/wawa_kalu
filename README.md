# 🌈 Wawa Kalú

**Wawa Kalú** es una aplicación móvil desarrollada con **Flutter** para acompañar a madres, padres y cuidadores durante el crecimiento, el bienestar y el aprendizaje temprano de sus hijos.

Su propuesta combina seguimiento infantil, orientaciones para las familias y experiencias de aprendizaje que pueden realizarse **fuera de la pantalla**, con materiales cotidianos.

## ✨ Funciones principales

- 📚 **Aprender:** una sola guía continua que reúne actividades por edad, lenguaje y entornos protectores sin menús intermedios.
- ❤️ **Salud:** vacunas, crecimiento y nutrición sin destinos repetidos.
- 👨‍👩‍👧 **Mis niños:** perfiles individuales que reutilizan las mismas herramientas de Salud y Aprender.
- 💉 **Vacunación:** consulta del esquema, registro de dosis y estados de seguimiento.
- 📈 **Crecimiento:** mediciones y curvas de referencia de la OMS.
- 📖 **Guía para familias:** 12 propuestas de aprendizaje para niñas y niños de 1 a 5 años.
- 🗣️ **Lenguaje y entornos protectores:** integrados directamente dentro de Aprender como secciones de la misma experiencia.
- 🥗 **Nutrición:** una guía continua por edad con hábitos, seguridad alimentaria y recetas ecuatorianas adaptadas a la primera infancia.
- 🎨 **Personalización:** modo claro, oscuro o automático; opciones de idioma, sonido y vibración.

## 🧭 Navegación actual

La barra principal está organizada como **Inicio → Aprender → Salud → Mis niños**. **Aprender ya no tiene tarjetas de navegación**: abre directamente una guía única con actividades por edad, lenguaje y entornos protectores. **Nutrición tampoco usa pestañas ni una página de Recetas separada**: es una sola guía continua con selector de edad, orientaciones y recetas ecuatorianas filtradas por etapa. Desde un perfil infantil se abren las mismas pantallas canónicas de vacunas, crecimiento, aprendizaje y nutrición.

## 📖 Guía para familias (1 a 5 años)

La sección **Aprender** abre directamente una guía integral. Su bloque de actividades se organiza por etapas orientativas:

- **1–2 años:** exploración de texturas, construcción con cajas y canciones con gestos.
- **2–3 años:** clasificación de ropa, movimiento con cojines y juego simbólico de cuidados.
- **3–4 años:** creación de cuentos, dibujo libre y representación de un mercado.
- **4–5 años:** secuencias de colores, dibujo del barrio y expresión de emociones.

Cada propuesta ofrece:

1. **Propósito** de la experiencia.
2. **Materiales** sencillos y accesibles.
3. **Recomendaciones de seguridad** para el adulto.
4. **Instrucciones paso a paso**, con lista interactiva.
5. **Qué observar** durante la actividad.
6. **Cómo adaptar** la experiencia a las capacidades e intereses del niño.

Las edades son orientativas. La participación de un adulto es esencial, especialmente al seleccionar y supervisar los materiales.

## 🗂️ Organización del código

```text
lib/
├── main.dart
├── app/
│   ├── app_shell.dart
│   └── widgets/
│       ├── liquid_glass_bottom_bar.dart
│       └── family_content_ui.dart
├── core/
│   ├── database/
│   ├── notifications/
│   └── privacy/
├── features/
│   ├── children/
│   ├── growth/
│   ├── health/
│   ├── learning/
│   │   ├── data/
│   │   │   └── parent_activity_catalog.dart
│   │   └── pages/
│   │       └── guia_familias_page.dart
│   ├── privacy/
│   └── vaccines/
└── pages/
    ├── app_config.dart
    ├── app_texts.dart
    ├── home_page.dart
    ├── nutricion_page.dart
    ├── recetas_page.dart
    └── widgets/
        └── config_sheet.dart
```

La guía familiar se encuentra en `lib/features/learning/`. Los contenidos están separados de la interfaz para facilitar su ampliación.

## 🚀 Instalación

Requisitos: Flutter y un dispositivo o emulador compatible.

```bash
git clone https://github.com/davidbattlegamer/wawa_kalu.git
cd wawa_kalu
flutter pub get
flutter run
```

### Verificación y mantenimiento

```bash
dart format lib
flutter analyze
flutter test
```

Para generar una versión Android:

```bash
flutter build apk --release
```


## 🥗 Nutrición por edad y recetas ecuatorianas

La sección **Salud → Nutrición** funciona como una guía familiar continua. Si existe un niño seleccionado, la aplicación utiliza su fecha de nacimiento para abrir la etapa correspondiente; también se puede cambiar manualmente entre **0–5 meses, 6–8 meses, 9–11 meses, 1–2 años, 2–3 años y 3–5 años**.

La guía combina hábitos cotidianos con un catálogo de recetas de identidad ecuatoriana. Incluye preparaciones con **quinua, papa, plátano verde, pescado, coco, yuca, maíz y aguacate**, organizadas por edad, región, textura y recomendaciones de seguridad.

Las referencias editoriales principales son materiales de **UNICEF Ecuador** sobre alimentación complementaria por edad y el **Recetario saludable para niños** del Ministerio de Educación del Ecuador. Las versiones incluidas en la app son adaptaciones propias para primera infancia y no sustituyen la valoración profesional individual.

## 🌐 Idiomas y apariencia

La interfaz utiliza `lib/pages/app_texts.dart` para gestionar español, inglés y una opción de kichwa ecuatoriano. Algunas traducciones al kichwa son parciales y requieren revisión lingüística; los textos no disponibles usan español como respaldo.

La apariencia se configura desde la aplicación y permite usar el tema del sistema, modo claro o modo oscuro.

## 🔐 Información de salud

Los contenidos de salud, vacunación y crecimiento son orientativos. No sustituyen el carné de vacunación, la valoración profesional ni las recomendaciones del personal sanitario.

## 👨‍🎓 Proyecto

Aplicación en desarrollo orientada al acompañamiento familiar y al aprendizaje temprano.

**Repositorio:** [davidbattlegamer/wawa_kalu](https://github.com/davidbattlegamer/wawa_kalu)
