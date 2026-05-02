plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "kr.missiondriven.bookclub"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Android applicationId cannot contain hyphens, so the organization
        // name `mission-driven` is collapsed to `missiondriven` on Android.
        // iOS bundle identifier keeps the hyphen per spec.
        applicationId = "kr.missiondriven.bookclub"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Kakao SDK: the OAuth redirect scheme is `kakao<NATIVE_APP_KEY>`.
        // CI / release builds inject the real key via the
        // `KAKAO_NATIVE_APP_KEY` gradle property (`-PkakaoNativeAppKey=...`).
        // Local dev uses the placeholder so `flutter run` succeeds without
        // secrets. Runtime login will error out until a real key is set.
        val kakaoNativeAppKey: String =
            (project.findProperty("kakaoNativeAppKey") as String?)
                ?: "82781f9e394c2f5f3e29e499c080c956"
        manifestPlaceholders["kakaoNativeAppKey"] = kakaoNativeAppKey
    }

    // Release signing: inject keystore via CI environment variables.
    // Required env vars: KEYSTORE_PATH, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD.
    // Falls back to debug signing for local `flutter run --release`.
    val keystorePath: String? = System.getenv("KEYSTORE_PATH")
    if (keystorePath != null) {
        signingConfigs {
            create("release") {
                storeFile = file(keystorePath)
                storePassword = System.getenv("KEYSTORE_PASSWORD")
                keyAlias = System.getenv("KEY_ALIAS")
                keyPassword = System.getenv("KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePath != null)
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}
