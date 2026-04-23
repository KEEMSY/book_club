import 'package:book_club/app.dart';
import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/presentation/widgets/kakao_login_button.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../reading/fakes.dart' as reading_fakes;
import 'fakes.dart';

/// End-to-end happy path: Kakao tap → `/home` (dashboard) → navigate to
/// `/library` → logout → `/login`.
///
/// Runs against the mocked network layer (FakeAuthApi + FakeSocialLoginPort
/// + FakeReadingRepository); no real Kakao/Apple/backend SDK is invoked.
/// Lives under `test/` so the standard `flutter test` CI step covers it
/// without requiring a connected device. M3 promotes `/home` (DashboardScreen)
/// back to the authenticated landing; the library remains reachable through
/// the bottom-nav.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Kakao login → /home → /library → logout → /login',
      (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi(
      loginKakaoResponse: buildLoginResponse(
        access: 'at',
        refresh: 'rt',
        user: buildUserDto(nickname: '수민'),
      ),
    );
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'sdk-token'),
    );
    final readingRepo = reading_fakes.FakeReadingRepository()
      ..gradeResult = reading_fakes.buildGradeSummary();

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
        ],
        child: const BookClubApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Router gate resolves Unauthenticated → redirects to /login.
    expect(find.byType(KakaoLoginButton), findsOneWidget);

    await tester.tap(find.byType(KakaoLoginButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Authenticated → /home (DashboardScreen). Greeting contains the user's
    // nickname.
    expect(find.textContaining('수민'), findsWidgets);

    // Jump to the library tab via the bottom nav (3rd destination).
    await tester.tap(find.text('서재'));
    await tester.pumpAndSettle();

    expect(find.text('내 서재'), findsOneWidget);

    // Trigger logout via the library AppBar icon.
    final logoutIcon = find.byIcon(Icons.logout_outlined);
    expect(logoutIcon, findsOneWidget);
    await tester.tap(logoutIcon);
    await tester.pumpAndSettle();

    // Back to /login.
    expect(find.byType(KakaoLoginButton), findsOneWidget);
  });
}
