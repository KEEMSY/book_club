allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// sentry_flutter 8.x (and potentially other older plugins) pin Kotlin
// languageVersion 1.6, which the Kotlin 2.2 compiler rejects ("Language version
// 1.6 is no longer supported; please, use version 1.8 or greater."). Force every
// subproject's Kotlin compilation to the minimum supported version (BC-24).
// configureEach is lazy, so it applies to each Kotlin task as it is realized —
// no afterEvaluate needed (subprojects are already evaluated here via the
// evaluationDependsOn above, which would make afterEvaluate throw).
subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            languageVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_8)
            apiVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_8)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
