import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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

/// Initializes the flutter_background_service plugin on first call so the
/// foreground notification channel is registered before [start] fires.
Future<void> initBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: _onServiceStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'book_club_timer',
      initialNotificationTitle: '독서 중',
      initialNotificationContent: '00:00:00',
      foregroundServiceNotificationId: 8801,
      foregroundServiceTypes: <AndroidForegroundType>[
        AndroidForegroundType.dataSync,
      ],
    ),
    iosConfiguration: IosConfiguration(autoStart: false),
  );
}

@pragma('vm:entry-point')
void _onServiceStart(ServiceInstance service) {
  service.on('update').listen((Map<String, dynamic>? data) {
    final String elapsed = data?['elapsed'] as String? ?? '00:00:00';
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: '독서 중',
        content: elapsed,
      );
    }
  });
  service.on('stop').listen((_) => service.stopSelf());
}

/// Android implementation backed by `flutter_background_service`.
/// The manifest entries (service declaration + FOREGROUND_SERVICE permissions)
/// live in `android/app/src/main/AndroidManifest.xml`.
class AndroidForegroundServiceBridge implements BackgroundTimerBridge {
  const AndroidForegroundServiceBridge();

  @override
  Future<void> start({
    required String userBookId,
    required String sessionId,
  }) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await initBackgroundService();
      await FlutterBackgroundService().startService();
    } catch (_) {
      // Timer keeps ticking even if the FG service fails to start.
    }
  }

  @override
  Future<void> update({required Duration elapsed}) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final String label = '${elapsed.inHours.toString().padLeft(2, '0')}:'
          '${(elapsed.inMinutes % 60).toString().padLeft(2, '0')}:'
          '${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      FlutterBackgroundService().invoke('update', <String, dynamic>{
        'elapsed': label,
      });
    } catch (_) {}
  }

  @override
  Future<void> stop() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      FlutterBackgroundService().invoke('stop');
    } catch (_) {}
  }
}

/// Provider chosen at resolution time based on the host platform. Tests can
/// override this provider with a stub bridge via `overrideWithValue`.
final backgroundTimerBridgeProvider = Provider<BackgroundTimerBridge>((ref) {
  if (kIsWeb) return const IosNullBridge();
  if (defaultTargetPlatform == TargetPlatform.android) {
    return const AndroidForegroundServiceBridge();
  }
  return const IosNullBridge();
});
