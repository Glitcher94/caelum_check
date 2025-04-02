import java.util.Properties
import java.io.FileInputStream
//import io.github.cdimascio.dotenv.Dotenv

//val dotenv = Dotenv.configure()
//    .directory(rootDir.absolutePath)
//    .ignoreIfMissing()
//    .load()

//val keystorePath: String = dotenv["KEYSTORE_PATH"] ?: throw GradleException("Missing KEYSTORE_PATH")
//val keystoreAlias: String = dotenv["KEYSTORE_ALIAS"] ?: throw GradleException("Missing KEYSTORE_ALIAS")
//val keystorePassword: String = dotenv["KEYSTORE_PASSWORD"] ?: throw GradleException("Missing KEYSTORE_PASSWORD")
//val keyPassword: String = dotenv["KEY_PASSWORD"] ?: throw GradleException("Missing KEY_PASSWORD")

val keystorePath: String = System.getenv("KEYSTORE_PATH") ?: throw GradleException("Missing KEYSTORE_PATH")
val keystoreAlias: String = System.getenv("KEYSTORE_ALIAS") ?: throw GradleException("Missing KEYSTORE_ALIAS")
val keystorePassword: String = System.getenv("KEYSTORE_PASSWORD") ?: throw GradleException("Missing KEYSTORE_PASSWORD")
val keyPassword: String = System.getenv("KEY_PASSWORD") ?: throw GradleException("Missing KEY_PASSWORD")

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

tasks.withType<JavaCompile> {
    options.isIncremental = false
}

android {
    namespace = "com.example.caelum"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.caelum"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreAlias
            keyPassword = keyPassword
            storeFile = file(keystorePath)
            storePassword = keystorePassword
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
