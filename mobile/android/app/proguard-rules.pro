# Flutter — keep all Flutter classes intact
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Retrofit / OkHttp
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Kakao SDK
-keep class com.kakao.** { *; }
-dontwarn com.kakao.**

# Firebase / FCM
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Play Core — Flutter's PlayStoreDeferredComponentManager references these
# classes, but we don't ship deferred components, so the Play Core lib isn't on
# the classpath. Tell R8 to ignore the missing references (BC-24).
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# General — keep data classes used by JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
