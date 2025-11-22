rootProject.buildDir = file("../build")

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    // Mantém mesmo layout de build usado pelo template Flutter (../build/<module>)
    buildDir = File(rootProject.buildDir, name)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
