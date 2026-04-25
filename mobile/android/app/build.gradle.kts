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
                ?: "0000000000000000000000000000"
        manifestPlaceholders["kakaoNativeAppKey"] = kakaoNativeAppKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
