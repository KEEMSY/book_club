import 'package:book_club/app.dart';
import 'package:book_club/core/router/app_router.dart';
import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/presentation/dev_login_screen.dart';
import 'package:book_club/features/auth/presentation/login_screen.dart';
import 'package:book_club/features/onboarding/application/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/auth/fakes.dart';

/// BC-86: the hidden `/dev-login` route must stay reachable pre-auth when
/// [DevLoginGate] is enabled. `flutter test` always runs with `kDebugMode`
/// true, so this exercises exactly the "dev build" branch of the gate — the
/// complementary "disabled in a production release build" branch is covered
/// as pure logic in `dev_login_gate_test.dart`, since a real release binary
/// can't be produced inside a widget test.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets(
    'unauthenticated: navigating to /dev-login renders DevLoginScreen '
    'instead of the top-level redirect bouncing it back to /login',
    (tester) async {
      final storage = InMemorySecureStorage();
      final social = FakeSocialLoginPort(
        kakaoResult: const SocialLoginResult(accessToken: 'k-at'),
      );
      final repository = AuthRepository(
        api: FakeAuthApi(),
        secureStorage: storage,
        socialLogin: social,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[
            authRepositoryProvider.overrideWithValue(repository),
            secureStorageProvider.overrideWithValue(storage),
            socialLoginPortProvider.overrideWithValue(social),
            // Skip the first-run onboarding gate so rehydration lands on
            // /login (Unauthenticated) rather than /onboarding.
            onboardingCompletedProvider.overrideWith((ref) => true),
          ],
          child: const BookClubApp(),
        ),
      );
      await tester.pumpAndSettle();

      // No saved tokens → rehydrate resolves Unauthenticated → /login.
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(DevLoginScreen), findsNothing);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp).first),
      );
      container.read(appRouterProvider).go(AppRoutes.devLogin);
      await tester.pumpAndSettle();

      expect(find.byType(DevLoginScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    },
  );
}
