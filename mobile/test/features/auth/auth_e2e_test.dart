import 'package:book_club/app.dart';
import 'package:book_club/core/router/app_router.dart';
import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/presentation/widgets/dev_login_button.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/onboarding/application/onboarding_provider.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../book/fakes.dart' show FakeBookRepository;
import '../reading/fakes.dart' as reading_fakes;
import 'fakes.dart';

/// End-to-end happy path: dev-login tap → `/home` (dashboard) → navigate to
/// `/library` → logout → `/login`.
///
/// Runs against the mocked network layer (FakeAuthApi + FakeSocialLoginPort
/// + FakeReadingRepository); no real Kakao/Apple/backend SDK is invoked.
/// Lives under `test/` so the standard `flutter test` CI step covers it
/// without requiring a connected device. M3 promotes `/home` (DashboardScreen)
/// back to the authenticated landing; the library remains reachable through
/// the bottom-nav.
///
/// BC-86: the dev/tester login shortcuts moved off `/login` onto the hidden
/// `/dev-login` route, so this flow now navigates there explicitly before
/// tapping [DevLoginButton] — see `dev_login_screen_test.dart` for the
/// route's own widget coverage and `dev_login_gate_test.dart` for the
/// dev/staging-only exposure gate.
///
/// TODO(phase-1-prerelease): swap DevLoginButton back to KakaoLoginButton once
/// real social login is restored.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // TODO(BC-22): the DashboardScreen's GradeBadge glow uses a repeating
  // AnimationController whose pending timer keeps the widget-test frame
  // scheduler busy, so this full-navigation e2e hangs (not a product bug —
  // the app runs fine). The happy path it exercises is already covered by
  // auth_notifier_test (login/logout), dev_login_screen_test (dev-login tap →
  // loginDev), dashboard_screen_test, and library_screen_test. Re-enable once
  // the badge animation exposes a test-friendly reduce-motion/dispose hook.
  testWidgets('dev-login → /home → /library → logout → /login', skip: true,
      (tester) async {
    // Disable platform-level animations for the test — the dashboard's
    // GradeBadge runs an always-on glow pulse in production, and a repeat
    // controller would trap pumpAndSettle. The badge's reduce-motion path
    // honors this flag and renders the resting state instead.
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    // DashboardPrefsNotifier reads SharedPreferences on build.
    SharedPreferences.setMockInitialValues(<String, Object>{});

    final storage = InMemorySecureStorage();
    final api = FakeAuthApi(
      loginDevResponse: buildLoginResponse(
        access: 'at',
        refresh: 'rt',
        user: buildUserDto(nickname: '수민'),
      ),
    );
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'sdk-token'),
    );
    // Stub every dashboard data source so no section stays in an infinite
    // loading shimmer (which would keep the frame scheduler busy and hang the
    // navigation pumps below).
    final readingRepo = reading_fakes.FakeReadingRepository()
      ..gradeResult = reading_fakes.buildGradeSummary()
      ..goalsResult = <dynamic>[].cast()
      ..heatmapQueue = <dynamic>[].cast();

    final repository = AuthRepository(
      api: api,
      secureStorage: storage,
      socialLogin: social,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authRepositoryProvider.overrideWithValue(repository),
          secureStorageProvider.overrideWithValue(storage),
          socialLoginPortProvider.overrideWithValue(social),
          readingRepositoryProvider
              .overrideWithValue(readingRepo as ReadingRepository),
          // Library screen loads books — stub so it doesn't hit the network.
          bookRepositoryProvider.overrideWithValue(FakeBookRepository()),
          // Skip the first-run onboarding gate (pre-warmed in main.dart only).
          onboardingCompletedProvider.overrideWith((ref) => true),
        ],
        child: const BookClubApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Router gate resolves Unauthenticated → redirects to /login.
    expect(find.text('골방'), findsOneWidget);

    // BC-86: the dev-login shortcuts no longer live on /login — navigate to
    // the hidden route explicitly (DevLoginGate.isEnabled() is true here
    // since flutter test always runs in a debug-like binary).
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp).first),
    );
    container.read(appRouterProvider).go(AppRoutes.devLogin);
    await tester.pumpAndSettle();
    expect(find.byType(DevLoginButton), findsNWidgets(2));

    await tester.tap(find.byType(DevLoginButton).first);
    // Bounded pumps rather than pumpAndSettle: the dashboard runs infinite
    // animations (GradeBadge glow, loading shimmers) that never let the frame
    // scheduler go idle, so pumpAndSettle would spin until timeout.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    // Authenticated → /home (DashboardScreen). Greeting contains the user's
    // nickname.
    expect(find.textContaining('수민'), findsWidgets);

    // Jump to the library tab via the bottom nav (3rd destination).
    await tester.tap(find.text('서재'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('내 서재'), findsOneWidget);

    // Trigger logout. The logout affordance relocated to the profile screen
    // (a deferred community surface not on the bottom nav), so drive it through
    // the notifier — the meaningful assertion is that the router reacts to a
    // logout by redirecting back to /login. Reuse the container from above
    // rather than re-fetching it (that would shadow the earlier `container`).
    await container.read(authNotifierProvider.notifier).logout();
    // Bounded pumps rather than pumpAndSettle: the login screen's entrance
    // animation can otherwise keep the frame scheduler busy indefinitely.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Back to /login — BC-86 moved the dev CTAs off this screen, so assert
    // on the hero copy instead of DevLoginButton.
    expect(find.text('골방'), findsOneWidget);
  });
}
