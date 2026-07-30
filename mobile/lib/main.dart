import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
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

/// Kakao JavaScript key. On web `KakaoSdk.appKey` resolves to this value rather
/// than the native key, and it is what gets sent as the OAuth `client_id` — so
/// leaving it empty makes every web login fail with KOE101 (BC-26). The Kakao
/// Map JS key belongs to the same Kakao app, so it doubles as the fallback when
/// only `KAKAO_MAP_KEY` is defined.
const String _kakaoJavaScriptAppKey = String.fromEnvironment(
  'KAKAO_JAVASCRIPT_APP_KEY',
  defaultValue: String.fromEnvironment('KAKAO_MAP_KEY', defaultValue: ''),
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

  KakaoSdk.init(
    nativeAppKey: _kakaoNativeAppKey,
    javaScriptAppKey: _kakaoJavaScriptAppKey,
  );

  if (kIsWeb && _kakaoJavaScriptAppKey.isEmpty && kDebugMode) {
    // ignore: avoid_print
    print(
      'KAKAO_JAVASCRIPT_APP_KEY (or KAKAO_MAP_KEY) is unset — web Kakao login '
      'will fail with KOE101. See docs/ops/kakao-login-setup.md.',
    );
  }

  // Kakao Map JavaScript key for the nearby-events map view (M71). Injected via
  // --dart-define=KAKAO_MAP_KEY; left unset in dev so the map renders empty
  // rather than crashing the rest of the app.
  const kakaoMapKey = String.fromEnvironment('KAKAO_MAP_KEY', defaultValue: '');
  if (kakaoMapKey.isNotEmpty) {
    AuthRepository.initialize(appKey: kakaoMapKey);
  }

  // RevenueCat init (M56). Skipped when the key is absent so local dev cold-
  // starts stay clean; the paywall then falls back to the backend test-receipt
  // path instead of touching the store SDK. purchases_flutter has no web
  // implementation (M73 web MVP defers IAP to Phase 17), so guard on !kIsWeb.
  const rcKey = String.fromEnvironment('REVENUECAT_API_KEY', defaultValue: '');
  if (rcKey.isNotEmpty && !kIsWeb) {
    await Purchases.configure(PurchasesConfiguration(rcKey));
  }

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
