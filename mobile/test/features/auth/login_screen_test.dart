import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_api.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/presentation/login_screen.dart';
import 'package:book_club/features/auth/presentation/widgets/apple_login_button.dart';
import 'package:book_club/features/auth/presentation/widgets/kakao_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  // Keep google_fonts offline in the test zone (see theme_test.dart for the
  // same pattern). Runtime fetching is the default, and it causes
  // tester.pumpAndSettle to hang on HTTP retries.
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildApp({
    required SocialLoginPort social,
    required AuthApi api,
    required SecureStorage storage,
  }) {
    final repository = AuthRepository(
      api: api,
      secureStorage: storage,
      socialLogin: social,
    );
    return ProviderScope(
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(repository),
        secureStorageProvider.overrideWithValue(storage),
        socialLoginPortProvider.overrideWithValue(social),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );
  }

  testWidgets('renders Airbnb-toned hero, Kakao button and legal caption',
      (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi();
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'k-at'),
    );

    await tester.pumpWidget(
      buildApp(social: social, api: api, storage: storage),
    );
    await tester.pumpAndSettle();

    expect(find.text('Book Club'), findsOneWidget);
    expect(find.text('책으로 연결되는 모든 순간'), findsOneWidget);
    expect(find.byType(KakaoLoginButton), findsOneWidget);
    expect(
      find.text('로그인하면 Book Club 이용약관 및 개인정보처리방침에 동의합니다.'),
      findsOneWidget,
    );
  });

  testWidgets('Apple button is hidden on non-iOS platforms', (tester) async {
    // debugDefaultTargetPlatformOverride defaults to Android in widget tests.
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi();
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'k-at'),
    );

    await tester.pumpWidget(
      buildApp(social: social, api: api, storage: storage),
    );
    await tester.pumpAndSettle();

    // Login screen uses `Platform.isIOS` — the non-test macOS host this test
    // runs on reports isIOS=false. The Apple button should not render.
    expect(find.byType(AppleLoginButton), findsNothing);
  });

  testWidgets('tapping the Kakao button invokes AuthNotifier.loginWithKakao',
      (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi(
      loginKakaoResponse: buildLoginResponse(),
    );
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'kakao-sdk-token'),
    );

    await tester.pumpWidget(
      buildApp(social: social, api: api, storage: storage),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(KakaoLoginButton));
    // Pump one frame to let the notifier flip to Authenticating, then settle
    // the async login call.
    await tester.pump();
    await tester.pumpAndSettle();

    expect(social.kakaoCalls, 1);
    expect(api.loginKakaoCalls, 1);
  });

  testWidgets('failure code from backend is surfaced inline', (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi(
      loginKakaoError: const AuthRepositoryException(
        code: 'KAKAO_USER_INFO_FAILED',
        message: '카카오 사용자 정보를 가져올 수 없습니다.',
      ),
    );
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'k-at'),
    );

    // Drive the notifier directly via a ProviderContainer so we can await
    // the login completion before re-pumping the screen.
    final container = ProviderContainer(
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(
          AuthRepository(api: api, secureStorage: storage, socialLogin: social),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await container.read(authNotifierProvider.notifier).loginWithKakao();
    await tester.pumpAndSettle();

    expect(container.read(authNotifierProvider), isA<AuthFailure>());
    expect(find.text('카카오 사용자 정보를 가져올 수 없습니다.'), findsOneWidget);
  });
}
