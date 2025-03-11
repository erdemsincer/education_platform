plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin
}

android {
    namespace = "com.erdem.education.education_platform"
    compileSdk = 35 // Güncel Android SDK sürümü

    defaultConfig {
        applicationId = "com.erdem.education.education_platform"
        minSdk = 21  // Minimum SDK seviyesi
        targetSdk = 35 // Hedef SDK sürümü
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
             // "release" signingConfig eklemeyi düşünün
        }
        debug {
            isMinifyEnabled = true
        }
    }
}

flutter {
    source = "../.."
}
