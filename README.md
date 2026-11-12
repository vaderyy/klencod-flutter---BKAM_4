# بكم؟ – Bekam | Flutter 3.47.2 compatible Android setup

This package contains the Bekam Flutter starter and a modern Android v2 embedding setup.

## Apply to an existing Klencod IDE project
1. Back up your current project first.
2. Copy `lib/main.dart` and merge the dependencies in `pubspec.yaml`.
3. Replace the matching Android files with the files in this package:
   - `android/settings.gradle`
   - `android/build.gradle`
   - `android/gradle.properties`
   - `android/gradle/wrapper/gradle-wrapper.properties`
   - `android/app/build.gradle`
   - `android/app/src/main/AndroidManifest.xml`
   - `android/app/src/main/kotlin/com/webkam/app/MainActivity.kt`
   - `android/app/src/main/res/values/styles.xml`
4. Ensure `android/local.properties` exists on your own computer and contains the correct local Flutter SDK path. Do not copy a local.properties file from another computer.
5. In Android Studio / Klencod terminal, run:
   `flutter clean`
   `flutter pub get`
   `flutter build apk --release`
6. The APK is normally generated at `build/app/outputs/flutter-apk/app-release.apk`.

## Important
- MainActivity uses `io.flutter.embedding.android.FlutterActivity` (Android embedding v2). There is no v1 `GeneratedPluginRegistrant` code.
- Package ID and namespace are `com.webkam.app`.
- Java/Kotlin target is 17. The Gradle wrapper is 8.14.3; Android Gradle Plugin is 8.11.1; Kotlin Gradle plugin is 2.2.20.
- If your project has custom signing, Firebase, flavors, app icons, or other Gradle plugins, merge those settings instead of deleting them.
- Do not overwrite the entire Android folder if you have custom configuration you need.
- Camera/gallery access is handled through `image_picker`; Android's system photo picker is used for gallery selection on supported versions. CAMERA permission is declared in the manifest.
- Product image matching in this starter is approximate image-hash matching, not robust AI object recognition.
