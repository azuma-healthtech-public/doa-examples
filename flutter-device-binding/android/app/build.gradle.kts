import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload-key credentials, kept out of the repo. Copy key.properties.example to
// android/key.properties and fill it in; android/.gitignore already excludes it.
// Absent - which is the normal case for a checkout - the release build falls back
// to the debug key, so `flutter build apk --release` keeps working for anyone who
// only wants to run the sample.
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
val hasUploadKey = keystoreProperties.getProperty("storeFile") != null

android {
    // Matches examples/android-device-binding so the two samples are the same
    // app in two stacks. They therefore cannot be installed side by side.
    namespace = "com.doa.example.devicebinding.flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.doa.example.devicebinding.flutter"
        // API 28+ for the full Biometric/KeyStore feature set, as the Kotlin
        // example requires. Flutter's own floor is lower, so pin it here.
        minSdk = 28
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["healthIdCallbackHost"] = providers.gradleProperty("healthIdCallbackHost").getOrElse("example.invalid")
        manifestPlaceholders["healthIdCallbackPath"] = providers.gradleProperty("healthIdCallbackPath").getOrElse("/health-id/callback")
        manifestPlaceholders["transferCallbackHost"] = providers.gradleProperty("transferCallbackHost").getOrElse("example.invalid")
        manifestPlaceholders["transferCallbackPath"] = providers.gradleProperty("transferCallbackPath").getOrElse("/callback/transfer")
    }

    signingConfigs {
        if (hasUploadKey) {
            create("upload") {
                storeFile = rootProject.file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // The upload key when one is configured, the debug key otherwise, so
            // a plain checkout can still build a release APK.
            //
            // The signing certificate matters beyond Play: Android's Credential
            // Manager will only issue a passkey for an RP domain whose
            // assetlinks.json lists this package together with the signing key's
            // SHA-256. Play App Signing re-signs with a different key, so the
            // delivered app has a different fingerprint from anything built here
            // - see the README before handing builds to testers.
            signingConfig = if (hasUploadKey) {
                signingConfigs.getByName("upload")
            } else {
                signingConfigs.getByName("debug")
            }

            // R8 is on by default for Flutter release builds, and two of our
            // dependencies break under it in ways that only show up there - see
            // proguard-rules.pro. Declared explicitly so the rules are applied
            // and so it is obvious that this build is minified at all.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // The three platform channels in src/main/kotlin: BiometricPrompt for the
    // biometric-gated key, Credential Manager for passkeys, and the lifecycle
    // scope the passkey channel launches its suspend calls on. Versions match
    // examples/android-device-binding/app/build.gradle.
    implementation("androidx.biometric:biometric:1.1.0")
    implementation("androidx.credentials:credentials:1.3.0")
    implementation("androidx.credentials:credentials-play-services-auth:1.3.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.2")
    // Play Integrity standard requests for the customer journey (IntegrityChannel.kt),
    // BSI TR-03161-1 O.Resi_2. The verdict is decoded and judged by DOA.
    implementation("com.google.android.play:integrity:1.4.0")
}

flutter {
    source = "../.."
}
