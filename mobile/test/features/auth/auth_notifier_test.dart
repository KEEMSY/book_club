import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('AuthNotifier', () {
    test('bootstrap emits Unauthenticated when no session exists', () async {
      final AuthNotifier notifier =
          AuthNotifier(buildRepository(api: FakeAuthApi()));
      await notifier.bootstrap();
      expect(notifier.state, isA<Unauthenticated>());
    });

    test('bootstrap rehydrates into Authenticated when /me succeeds', () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('existing-access');
      await storage.saveRefreshToken('existing-refresh');

      final api = FakeAuthApi(meResponse: buildUserDto(nickname: '수민'));
      final AuthNotifier notifier = AuthNotifier(
        buildRepository(api: api, storage: storage),
      );
      await notifier.bootstrap();

      expect(notifier.state, isA<Authenticated>());
      final Authenticated authed = notifier.state as Authenticated;
      expect(authed.user.nickname, '수민');
      expect(api.getMeCalls, 1);
    });

    test('loginWithKakao persists tokens and transitions to Authenticated',
        () async {
      final storage = InMemorySecureStorage();
      final api = FakeAuthApi(
        loginKakaoResponse: buildLoginResponse(
          access: 'new-access',
          refresh: 'new-refresh',
        ),
      );
      final social = FakeSocialLoginPort(
        kakaoResult: const SocialLoginResult(accessToken: 'kakao-sdk-token'),
      );
      final notifier = AuthNotifier(
        buildRepository(api: api, storage: storage, social: social),
      );

      await notifier.loginWithKakao();

      expect(notifier.state, isA<Authenticated>());
      expect(await storage.readAccessToken(), 'new-access');
      expect(await storage.readRefreshToken(), 'new-refresh');
      expect(social.kakaoCalls, 1);
      expect(api.loginKakaoCalls, 1);
    });

    test(
        'loginWithKakao keeps state Unauthenticated when the user cancels '
        'the platform sheet', () async {
      final social = FakeSocialLoginPort(
        kakaoError: const SocialLoginCancelled(),
      );
      final notifier = AuthNotifier(buildRepository(social: social));

      await notifier.loginWithKakao();

      expect(notifier.state, isA<Unauthenticated>());
    });

    test('loginWithKakao surfaces the backend error code on 4xx failure',
        () async {
      final api = FakeAuthApi(
        loginKakaoError: const AuthRepositoryException(
          code: 'KAKAO_USER_INFO_FAILED',
          message: '카카오 사용자 정보를 가져올 수 없습니다.',
        ),
      );
      final social = FakeSocialLoginPort(
        kakaoResult: const SocialLoginResult(accessToken: 'kakao-sdk-token'),
      );
      final notifier = AuthNotifier(
        buildRepository(api: api, social: social),
      );

      await notifier.loginWithKakao();

      expect(notifier.state, isA<AuthFailure>());
      final failure = notifier.state as AuthFailure;
      expect(failure.code, 'KAKAO_USER_INFO_FAILED');
    });

    test('loginWithApple produces Authenticated when identity_token succeeds',
        () async {
      final api = FakeAuthApi(
        loginAppleResponse: buildLoginResponse(
          user: buildUserDto(provider: 'apple'),
        ),
      );
      final social = FakeSocialLoginPort(
        appleResult: const SocialLoginResult(identityToken: 'apple-id-jwt'),
      );
      final notifier = AuthNotifier(
        buildRepository(api: api, social: social),
      );

      await notifier.loginWithApple();

      expect(notifier.state, isA<Authenticated>());
      expect(social.appleCalls, 1);
    });

    test('logout clears tokens and emits Unauthenticated', () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('a');
      await storage.saveRefreshToken('r');
      final notifier = AuthNotifier(buildRepository(storage: storage));

      await notifier.logout();

      expect(notifier.state, isA<Unauthenticated>());
      expect(await storage.readAccessToken(), isNull);
      expect(await storage.readRefreshToken(), isNull);
    });
  });
}
