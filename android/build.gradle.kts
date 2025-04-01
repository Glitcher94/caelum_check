// Modifica el bloque buildscript para añadir la dependencia de java-dotenv
buildscript {
    val kotlin_version = "1.9.0"

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.2.0")
        classpath("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.22")
        classpath("io.github.cdimascio:java-dotenv:5.2.2") // Añade esta línea
    }
}

// Configuración de repositorios
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://api.mapbox.com/downloads/v2/releases/maven")
            authentication {
                create<BasicAuthentication>("basic")
            }
            credentials {
                username = "mapbox"
                password = (project.findProperty("MAPBOX_DOWNLOADS_TOKEN") as String?) ?: System.getenv("MAPBOX_DOWNLOADS_TOKEN") ?: ""
            }
        }
    }
}

// Configuración de directorios de compilación
gradle.projectsEvaluated {
    val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
    rootProject.layout.buildDirectory.value(newBuildDir)

    subprojects {
        val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubprojectBuildDir)
    }
    
    subprojects {
        project.evaluationDependsOn(":app")
    }
}

// Tarea para limpiar la compilación
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
