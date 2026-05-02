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

# General — keep data classes used by JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
