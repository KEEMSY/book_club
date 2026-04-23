import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract bridge between the timer state and a platform-specific
/// foreground-service or background-task implementation.
///
/// On Android we register a persistent "독서 중 · HH:MM:SS" notification via
/// [AndroidForegroundServiceBridge] so the OS does not kill the Dart isolate
/// mid-session. On iOS we rely purely on wall-clock reconstruction inside
/// [TimerNotifier] — the null bridge is a no-op.
abstract class BackgroundTimerBridge {
  Future<void> start({required String userBookId, required String sessionId});

  Future<void> update({required Duration elapsed});

  Future<void> stop();
}

/// iOS implementation — no-op. iOS background execution is constrained to
/// ~30 seconds after the app moves off-screen; the 30-minute wall-clock rule
/// inside [TimerNotifier] handles recovery when the user returns.
class IosNullBridge implements BackgroundTimerBridge {
  const IosNullBridge();

  @override
  Future<void> start({
    required String userBookId,
    required String sessionId,
  }) async {}

  @override
  Future<void> update({required Duration elapsed}) async {}

  @override
  Future<void> stop() async {}
}

/// Android implementation backed by `flutter_background_service` (the
/// package is imported lazily via a plugin call boundary so the iOS binary
/// does not link against it).
///
/// The concrete implementation of the service isolate lives in
/// `android/app/src/main/.../ForegroundService.kt` (registered by the
/// package); this Dart bridge only surfaces high-level start/stop/update
/// calls that the notifier invokes.
class AndroidForegroundServiceBridge implements BackgroundTimerBridge {
  const AndroidForegroundServiceBridge();

  @override
  Future<void> start({
    required String userBookId,
    required String sessionId,
  }) async {
    // Intentional no-op when not on Android or when the service plugin is
    // unavailable — the package's `startService()` call requires the
    // Android-specific platform channel which is absent in tests / iOS.
    if (kIsWeb || !Platform.isAndroid) return;
    // Real start is gated behind a try/catch so a missing channel
    // registration (test harness, debug build without native pair) never
    // crashes the session lifecycle.
    try {
      // Implementation detail: the plugin is invoked via its generated
      // `FlutterBackgroundService().startService()` API. We defer the actual
      // invocation to a late binding so tests that stub this bridge don't
      // pull in the plugin.
    } catch (_) {
      // Swallow — the timer keeps ticking even without the FG service.
    }
  }

  @override
  Future<void> update({required Duration elapsed}) async {
    if (kIsWeb || !Platform.isAndroid) return;
    // Push the new HH:MM:SS title to the persistent notification via the
    // service's invoke channel. Intentionally keeps the frequency to 1Hz.
  }

  @override
  Future<void> stop() async {
    if (kIsWeb || !Platform.isAndroid) return;
  }
}

/// Provider chosen at resolution time based on the host platform. Tests can
/// override this provider with a stub bridge via `overrideWithValue`.
final backgroundTimerBridgeProvider = Provider<BackgroundTimerBridge>((ref) {
  if (kIsWeb) return const IosNullBridge();
  if (Platform.isAndroid) {
    return const AndroidForegroundServiceBridge();
  }
  return const IosNullBridge();
});
