import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../data/social_login_port.dart';
import '../domain/auth_state.dart';
import '../domain/auth_user.dart';

/// Holds the [AuthState] sealed union and orchestrates the three public
/// flows (kakao login · apple login · logout · account delete).
///
/// State transitions are kept unidirectional — only [_setState] writes to
/// the underlying `state` so any future debug/logging hook can be attached
/// in one place. Token persistence is delegated to [AuthRepository].
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.initial());

  final AuthRepository _repository;

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
    await _repository.logout();
    _setState(const AuthState.unauthenticated());
  }

  Future<void> _performLogin(Future<AuthUser> Function() doLogin) async {
    _setState(const AuthState.authenticating());
    try {
      final AuthUser user = await doLogin();
      _setState(AuthState.authenticated(user));
      // Device token registration is deferred to M5 per the Phase 1 plan —
      // we don't have FCM wired yet, and passing a placeholder would pollute
      // the backend DeviceToken table with noise. See report.
    } on SocialLoginCancelled {
      _setState(const AuthState.unauthenticated());
    } on SocialLoginFailed catch (e) {
      _setState(
        AuthState.failure(
          code: 'SOCIAL_LOGIN_FAILED',
          message: _readableSocialMessage(e),
        ),
      );
    } on AuthRepositoryException catch (e) {
      _setState(AuthState.failure(code: e.code, message: e.message));
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
    }
  }

  String _readableSocialMessage(SocialLoginFailed e) {
    // Keep SDK error strings out of user copy — the cause is kept for logs
    // but the surface message stays 2030 여성 friendly.
    return '로그인을 완료하지 못했습니다. 잠시 후 다시 시도해주세요.';
  }

  void _setState(AuthState next) {
    if (mounted) {
      state = next;
    }
  }
}
