import 'package:book_club/app.dart';
import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/presentation/widgets/kakao_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

/// End-to-end happy path: Kakao tap → `/library` → logout → `/login`.
///
/// Runs against the mocked network layer (FakeAuthApi + FakeSocialLoginPort);
/// no real Kakao or Apple SDK is invoked. Lives under `test/` so the standard
/// `flutter test` CI step covers it without requiring a connected device. M2
/// moves the authenticated landing from the former `/home` placeholder to
/// `/library`, so the post-login assertions now target the "내 서재" header
/// and the library's logout IconButton instead of the old home CTAs.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Kakao login → /library → logout → /login', (tester) async {
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
        ],
        child: const BookClubApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Router gate resolves Unauthenticated → redirects to /login.
    expect(find.byType(KakaoLoginButton), findsOneWidget);

    await tester.tap(find.byType(KakaoLoginButton));
    await tester.pumpAndSettle();

    // Authenticated -> /library. The library screen renders the Playfair
    // "내 서재" header plus a logout IconButton in the top-right.
    expect(find.text('내 서재'), findsOneWidget);

    // Trigger logout via the AppBar icon.
    final logoutIcon = find.byIcon(Icons.logout_outlined);
    expect(logoutIcon, findsOneWidget);
    await tester.tap(logoutIcon);
    await tester.pumpAndSettle();

    // Back to /login.
    expect(find.byType(KakaoLoginButton), findsOneWidget);
  });
}
