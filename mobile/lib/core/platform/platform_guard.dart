import 'package:flutter/foundation.dart';

/// Whether the app is running as a Flutter Web build. Prefer this over
/// referencing [kIsWeb] directly so call sites read intent, not platform flags.
bool get isWeb => kIsWeb;

/// Inverse of [isWeb] — true on iOS/Android native builds.
bool get isNativeMobile => !kIsWeb;

/// Records that [featureName] was skipped because it has no web implementation
/// yet (FCM push, Agora RTC, RevenueCat IAP — see Phase 16 M73 web MVP scope).
/// Debug-only; compiled out of release builds via the assert.
void webUnsupported(String featureName) {
  if (kIsWeb) {
    assert(() {
      debugPrint('[$featureName] not supported on web — skipped');
      return true;
    }());
  }
}
