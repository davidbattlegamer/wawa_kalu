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
    // AGP 8.12.1 es compatible con Gradle 8.14 y los plugins actuales.
    id("com.android.application") version "8.12.1" apply false
    // Kotlin 2.3.20 es compatible con AGP 8.12.1 y Gradle 8.14.
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")
