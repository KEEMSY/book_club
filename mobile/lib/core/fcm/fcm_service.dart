import 'dart:developer' as dev;

// firebase_core is pulled in transitively via firebase_messaging and used
// directly for Firebase.initializeApp().
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around [FirebaseMessaging] that isolates token retrieval and
/// listener setup from the auth layer.
///
/// All methods are no-ops when Firebase is not yet initialised (i.e. before
/// `Firebase.initializeApp()` is called in main.dart). This lets the rest of
/// the codebase compile and run in dev/CI environments where
/// GoogleService-Info.plist / google-services.json are absent.
///
/// SETUP: To enable Firebase push notifications:
///   1. Create a Firebase project at https://console.firebase.google.com
///   2. Add the iOS app (bundle ID from Xcode → Runner target) and download
///      GoogleService-Info.plist → place at ios/Runner/GoogleService-Info.plist
///   3. Add the Android app and download google-services.json
///      → place at android/app/google-services.json
///   4. In main.dart, call `await Firebase.initializeApp()` before runApp().
///      Import: package:firebase_core/firebase_core.dart
///   Once Firebase.apps is non-empty, all methods below activate automatically.
class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  /// Returns the current FCM registration token, or `null` when Firebase is
  /// not initialised or the device cannot reach FCM servers.
  Future<String?> getToken() async {
    if (Firebase.apps.isEmpty) {
      dev.log(
        'Firebase not initialised — skipping FCM token.',
        name: 'FcmService',
      );
      return null;
    }
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      // Non-fatal: token registration is best-effort at login time.
      dev.log(
        'FCM getToken failed.',
        name: 'FcmService',
        error: e,
      );
      return null;
    }
  }

  /// Subscribes [onTokenRefresh] to FCM's token-refresh stream.
  ///
  /// Call once after a successful login. The returned [Stream] subscription
  /// should be cancelled when the user logs out.
  ///
  /// [onTokenRefresh] receives the new token string and is responsible for
  /// sending it to the backend.
  Stream<String> get tokenRefreshStream => Firebase.apps.isEmpty
      ? const Stream<String>.empty()
      : FirebaseMessaging.instance.onTokenRefresh;

  /// Requests push notification permission from the OS.
  ///
  /// On iOS this surfaces the system permission dialog. On Android 13+ it
  /// requests the POST_NOTIFICATIONS runtime permission. Safe to call before
  /// `Firebase.initializeApp()` — the call is silently skipped if Firebase
  /// is uninitialised.
  Future<void> requestPermission() async {
    if (Firebase.apps.isEmpty) {
      dev.log(
        'Firebase not initialised — skipping permission request.',
        name: 'FcmService',
      );
      return;
    }
    try {
      final NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        dev.log(
          'FCM permission status: ${settings.authorizationStatus}',
          name: 'FcmService',
        );
      }
    } catch (e) {
      dev.log(
        'FCM requestPermission failed.',
        name: 'FcmService',
        error: e,
      );
    }
  }
}
