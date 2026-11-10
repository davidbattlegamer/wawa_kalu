plugins {
    id("com.android.application")
    id("kotlin-android")

    // El plugin de Flutter debe ir después
    // de Android y Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.wawa_kalu"

    // flutter_local_notifications 20.1.0
    // requiere compileSdk 35 o superior.
    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion

    // ---------------------------------------------------------
    // JAVA + DESUGARING
    // ---------------------------------------------------------

    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17
    }

    // ---------------------------------------------------------
    // CONFIGURACIÓN DE LA APP
    // ---------------------------------------------------------

    defaultConfig {
        applicationId =
            "com.example.wawa_kalu"

        minSdk =
            flutter.minSdkVersion

        targetSdk =
            flutter.targetSdkVersion

        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName

        // Necesario para compatibilidad con
        // flutter_local_notifications.
        multiDexEnabled = true
    }

    // ---------------------------------------------------------
    // BUILD
    // ---------------------------------------------------------

    buildTypes {
        release {
            // Por ahora utiliza la firma debug.
            signingConfig =
                signingConfigs.getByName(
                    "debug"
                )
        }
    }
}

// Kotlin 2.3+: el DSL kotlinOptions.jvmTarget (String) está obsoleto.
// Mantener Java y Kotlin alineados en JVM 17 para AGP y los plugins.
kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

// -------------------------------------------------------------
// FLUTTER
// -------------------------------------------------------------

flutter {
    source = "../.."
}

// -------------------------------------------------------------
// DEPENDENCIAS ANDROID
// -------------------------------------------------------------

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )
}