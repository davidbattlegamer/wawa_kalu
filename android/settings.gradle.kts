pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // AGP 9.0.1 con Gradle 9.1 y Flutter >=3.47 (Built-in Kotlin).
    id("com.android.application") version "9.0.1" apply false
    // KGP se declara solo para compatibilidad; no se aplica en :app.
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")
