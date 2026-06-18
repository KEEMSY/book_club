import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'features/onboarding/application/onboarding_provider.dart';

/// Kakao native-app key. Supplied via `--dart-define=KAKAO_NATIVE_APP_KEY=...`
/// in CI/release builds. Falls back to the registered key so `flutter run`
/// works without extra flags — the same key is already embedded in Info.plist
/// and AndroidManifest.xml, so there is no additional secret exposure here.
const String _kakaoNativeAppKey = String.fromEnvironment(
  'KAKAO_NATIVE_APP_KEY',
  defaultValue: '82781f9e394c2f5f3e29e499c080c956',
);

Future<void> main() async {
  const dsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  // Skip Sentry entirely in local dev to keep cold-start overhead minimal.
  if (dsn.isEmpty) {
    await _runApp();
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = dsn;
      // Sample 10 % of transactions to stay within the free quota.
      options.tracesSampleRate = 0.1;
      options.environment = const String.fromEnvironment(
        'APP_ENV',
        defaultValue: 'development',
      );
    },
    appRunner: _runApp,
  );
}

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload Playfair Display before the first frame so CanvasKit has the Latin
  // serif registered before text layout begins. NotoSansKR is bundled as a
  // Flutter font asset and is always available without a network fetch.
  await GoogleFonts.pendingFonts([GoogleFonts.playfairDisplay()]);

  KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);

  // Pre-warm the onboarding-complete flag so the router redirect can read it
  // synchronously on the first navigation tick (avoids a spurious /login flash).
  final container = ProviderContainer();
  await container.read(onboardingCompletedProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BookClubApp(),
    ),
  );
}
