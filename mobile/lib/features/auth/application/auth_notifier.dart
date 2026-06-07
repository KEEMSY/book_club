import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/fcm/fcm_service.dart';
import '../../../core/network/dio_provider.dart';
import '../data/auth_repository.dart';
import '../data/social_login_port.dart';
import '../domain/auth_state.dart';
import '../domain/auth_user.dart';
import 'auth_providers.dart';

part 'auth_notifier.g.dart';

/// Holds the [AuthState] sealed union and orchestrates the three public
/// flows (kakao login · apple login · logout · account delete).
///
/// State transitions are kept unidirectional — only [_setState] writes to
/// the underlying `state` so any future debug/logging hook can be attached
/// in one place. Token persistence is delegated to [AuthRepository].
@riverpod
class AuthNotifier extends _$AuthNotifier {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  /// Subscription to FCM token-refresh events. Cancelled on logout so we
  /// don't send stale tokens for a signed-out user.
  StreamSubscription<String>? _fcmTokenRefreshSub;

  @override
  AuthState build() {
    // Bridge the refresh-interceptor's session-expired broadcast into an
    // explicit logout. This stays here (not in core/) so the dio provider
    // does not depend on feature code.
    ref.listen<int>(sessionExpiredBroadcastProvider, (previous, next) {
      if (previous != null && next > previous) {
        logout();
      }
    });

    // Kick off rehydration once the first listener subscribes. The router gate
    // is the first listener, so this happens on app start before any route
    // resolves against the gate's current-state snapshot.
    Future.microtask(bootstrap);

    return const AuthState.initial();
  }

  /// Rehydrates the session on app start. The router gate waits for
  /// [AuthState] to leave [AuthInitial] before performing any redirects.
  Future<void> bootstrap() async {
    final AuthUser? user = await _repository.rehydrate();
    if (user == null) {
      _setState(const AuthState.unauthenticated());
    } else {
      _setState(AuthState.authenticated(user));
    }
  }

  Future<void> loginWithKakao() async {
    await _performLogin(_repository.loginWithKakao);
  }

  Future<void> loginWithApple() async {
    await _performLogin(_repository.loginWithApple);
  }

  /// Dev-only shortcut. Skips the social SDK path entirely and issues a
  /// backend JWT tied to a `dev:<nickname>` user. See
  /// `AuthRepository.loginDev` for the prod-safety guarantee.
  Future<void> loginDev({String nickname = '개발자'}) async {
    await _performLogin(() => _repository.loginDev(nickname: nickname));
  }

  Future<void> logout() async {
    await _fcmTokenRefreshSub?.cancel();
    _fcmTokenRefreshSub = null;
    await _repository.logout();
    _setState(const AuthState.unauthenticated());
  }

  Future<void> _performLogin(Future<AuthUser> Function() doLogin) async {
    _setState(const AuthState.authenticating());
    try {
      final AuthUser user = await doLogin();
      _setState(AuthState.authenticated(user));
    } on SocialLoginCancelled {
      _setState(const AuthState.unauthenticated());
      return;
    } on SocialLoginFailed catch (e) {
      _setState(
        AuthState.failure(
          code: 'SOCIAL_LOGIN_FAILED',
          message: _readableSocialMessage(e),
        ),
      );
      return;
    } on AuthRepositoryException catch (e) {
      _setState(AuthState.failure(code: e.code, message: e.message));
      return;
    } catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthNotifier unexpected error: $e\n$st');
      }
      _setState(
        const AuthState.failure(
          code: 'UNKNOWN',
          message: '로그인 중 예상치 못한 오류가 발생했습니다.',
        ),
      );
      return;
    }
    // FCM setup is best-effort. Firebase may not be initialised yet
    // (GoogleService-Info.plist / google-services.json absent in dev).
    // Failures here must NOT override the authenticated state already set above.
    // TODO(setup): Call Firebase.initializeApp() in main.dart once platform
    // config files are in place.
    unawaited(_registerFcmToken());
    try {
      await _fcmTokenRefreshSub?.cancel();
      _fcmTokenRefreshSub =
          FcmService.instance.tokenRefreshStream.listen(_onFcmTokenRefresh);
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthNotifier FCM subscription error (non-fatal): $e');
      }
    }
  }

  /// Fetches the FCM token and registers it with the backend. Best-effort:
  /// failures are swallowed here; [AuthRepository.registerDeviceToken] already
  /// swallows them internally as well.
  Future<void> _registerFcmToken() async {
    await FcmService.instance.requestPermission();
    final String? token = await FcmService.instance.getToken();
    if (token == null) return;
    await _repository.registerDeviceToken(
      token: token,
      platform: kIsWeb ? 'web' : (Platform.isIOS ? 'ios' : 'aos'),
    );
  }

  /// Called by the FCM SDK when the device is assigned a new registration
  /// token (e.g. after app reinstall or token expiry).
  Future<void> _onFcmTokenRefresh(String newToken) async {
    await _repository.registerDeviceToken(
      token: newToken,
      platform: kIsWeb ? 'web' : (Platform.isIOS ? 'ios' : 'aos'),
    );
  }

  String _readableSocialMessage(SocialLoginFailed e) {
    // Keep SDK error strings out of user copy — the cause is kept for logs
    // but the surface message stays 2030 여성 friendly.
    return '로그인을 완료하지 못했습니다. 잠시 후 다시 시도해주세요.';
  }

  void _setState(AuthState next) {
    state = next;
  }
}
