import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_api.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/presentation/login_screen.dart';
import 'package:book_club/features/auth/presentation/widgets/dev_login_button.dart';
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

  testWidgets('renders hero, dev-login CTA and legal caption', (tester) async {
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
    expect(find.byType(DevLoginButton), findsOneWidget);
    expect(find.text('개발용 로그인'), findsOneWidget);
    expect(find.text('Dev 환경 전용입니다'), findsOneWidget);
    expect(
      find.text('로그인하면 Book Club 이용약관 및 개인정보처리방침에 동의합니다.'),
      findsOneWidget,
    );
  });

  testWidgets('tapping the dev-login button invokes AuthNotifier.loginDev',
      (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi(
      loginDevResponse: buildLoginResponse(
        user: buildUserDto(nickname: '개발자'),
        isNewUser: true,
      ),
    );
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'kakao-sdk-token'),
    );

    await tester.pumpWidget(
      buildApp(social: social, api: api, storage: storage),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DevLoginButton));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(api.loginDevCalls, 1);
    // Dev flow skips the social port — no Kakao/Apple calls should fire.
    expect(social.kakaoCalls, 0);
    expect(social.appleCalls, 0);
  });

  testWidgets('failure code from backend is surfaced inline', (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi(
      loginDevError: const AuthRepositoryException(
        code: 'DEV_LOGIN_FAILED',
        message: '개발용 로그인에 실패했습니다.',
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

    await container.read(authNotifierProvider.notifier).loginDev();
    await tester.pumpAndSettle();

    expect(container.read(authNotifierProvider), isA<AuthFailure>());
    expect(find.text('개발용 로그인에 실패했습니다.'), findsOneWidget);
  });
}
