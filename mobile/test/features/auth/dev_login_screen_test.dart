import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_api.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/presentation/dev_login_screen.dart';
import 'package:book_club/features/auth/presentation/widgets/dev_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

/// BC-86: [DevLoginScreen] is the hidden `/dev-login` route the two dev/tester
/// login shortcuts moved to. The screen itself renders unconditionally — the
/// dev/staging-only gate is enforced one layer up, at the route's redirect in
/// `app_router.dart` (see `DevLoginGate`) — so these tests only cover the
/// screen's own content and its wiring to `AuthNotifier`.
void main() {
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
        home: const DevLoginScreen(),
      ),
    );
  }

  testWidgets('renders both dev/tester login entry points', (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi();
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'k-at'),
    );

    await tester.pumpWidget(
      buildApp(social: social, api: api, storage: storage),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DevLoginButton), findsNWidgets(2));
    expect(find.text('개발용 로그인'), findsOneWidget);
    expect(find.text('테스트 데이터 로그인'), findsOneWidget);
    expect(find.textContaining('Dev 환경 전용'), findsOneWidget);
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

    await tester.tap(find.text('개발용 로그인'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(api.loginDevCalls, 1);
    // Dev flow skips the social port — no Kakao/Apple calls should fire.
    expect(social.kakaoCalls, 0);
    expect(social.appleCalls, 0);
  });

  testWidgets(
      'tapping the tester-login button invokes AuthNotifier.loginTester '
      'and seeds test data', (tester) async {
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi(
      loginDevResponse: buildLoginResponse(
        user: buildUserDto(nickname: '테스터'),
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

    await tester.tap(find.text('테스트 데이터 로그인'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(api.loginDevCalls, 1);
    expect(api.seedTesterDataCalls, 1);
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
          home: const DevLoginScreen(),
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
