import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('AuthNotifier', () {
    test('bootstrap emits Unauthenticated when no session exists', () async {
      final c = ProviderContainer(overrides: [
        authRepositoryProvider
            .overrideWithValue(buildRepository(api: FakeAuthApi())),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);
      await notifier.bootstrap();
      expect(c.read(authNotifierProvider), isA<Unauthenticated>());
    });

    test('bootstrap rehydrates into Authenticated when /me succeeds', () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('existing-access');
      await storage.saveRefreshToken('existing-refresh');

      final api = FakeAuthApi(meResponse: buildUserDto(nickname: '수민'));
      final c = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(
          buildRepository(api: api, storage: storage),
        ),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);
      await notifier.bootstrap();

      expect(c.read(authNotifierProvider), isA<Authenticated>());
      final Authenticated authed =
          c.read(authNotifierProvider) as Authenticated;
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
      final c = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(
          buildRepository(api: api, storage: storage, social: social),
        ),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);

      await notifier.loginWithKakao();

      expect(c.read(authNotifierProvider), isA<Authenticated>());
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
      final c = ProviderContainer(overrides: [
        authRepositoryProvider
            .overrideWithValue(buildRepository(social: social)),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);

      await notifier.loginWithKakao();

      expect(c.read(authNotifierProvider), isA<Unauthenticated>());
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
      final c = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(
          buildRepository(api: api, social: social),
        ),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);

      await notifier.loginWithKakao();

      expect(c.read(authNotifierProvider), isA<AuthFailure>());
      final failure = c.read(authNotifierProvider) as AuthFailure;
      expect(failure.code, 'KAKAO_USER_INFO_FAILED');
    });

    test('loginDev persists tokens and transitions to Authenticated', () async {
      final storage = InMemorySecureStorage();
      final api = FakeAuthApi(
        loginDevResponse: buildLoginResponse(
          access: 'dev-access',
          refresh: 'dev-refresh',
          user: buildUserDto(nickname: '개발자'),
          isNewUser: true,
        ),
      );
      final c = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(
          buildRepository(api: api, storage: storage),
        ),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);

      await notifier.loginDev();

      expect(c.read(authNotifierProvider), isA<Authenticated>());
      final Authenticated authed =
          c.read(authNotifierProvider) as Authenticated;
      expect(authed.user.nickname, '개발자');
      expect(await storage.readAccessToken(), 'dev-access');
      expect(await storage.readRefreshToken(), 'dev-refresh');
      expect(api.loginDevCalls, 1);
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
      final c = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(
          buildRepository(api: api, social: social),
        ),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);

      await notifier.loginWithApple();

      expect(c.read(authNotifierProvider), isA<Authenticated>());
      expect(social.appleCalls, 1);
    });

    test('logout clears tokens and emits Unauthenticated', () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('a');
      await storage.saveRefreshToken('r');
      final c = ProviderContainer(overrides: [
        authRepositoryProvider
            .overrideWithValue(buildRepository(storage: storage)),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(authNotifierProvider.notifier);

      await notifier.logout();

      expect(c.read(authNotifierProvider), isA<Unauthenticated>());
      expect(await storage.readAccessToken(), isNull);
      expect(await storage.readRefreshToken(), isNull);
    });
  });
}
