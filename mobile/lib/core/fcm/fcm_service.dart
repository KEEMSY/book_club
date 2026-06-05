import 'dart:developer' as dev;

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
/// TODO(setup): Call `Firebase.initializeApp()` in main.dart once the Firebase
/// project has been created and the platform config files have been added:
///   - iOS:     ios/Runner/GoogleService-Info.plist
///   - Android: android/app/google-services.json
class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  /// Returns the current FCM registration token, or `null` when Firebase is
  /// not initialised or the device cannot reach FCM servers.
  Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      // Non-fatal: token registration is best-effort at login time.
      dev.log(
        'FCM getToken failed — Firebase may not be initialised yet.',
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
  Stream<String> get tokenRefreshStream =>
      FirebaseMessaging.instance.onTokenRefresh;

  /// Requests push notification permission from the OS.
  ///
  /// On iOS this surfaces the system permission dialog. On Android 13+ it
  /// requests the POST_NOTIFICATIONS runtime permission. Safe to call before
  /// `Firebase.initializeApp()` — the call is silently skipped if Firebase
  /// is uninitialised.
  Future<void> requestPermission() async {
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
        'FCM requestPermission failed — Firebase may not be initialised yet.',
        name: 'FcmService',
        error: e,
      );
    }
  }
}
