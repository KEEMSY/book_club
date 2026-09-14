import 'package:dio/dio.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/auth_user.dart';
import 'auth_api.dart';
import 'auth_models.dart';
import 'social_login_port.dart';

/// Typed domain failure surfaced to the notifier layer.
///
/// Carries the backend error envelope `code` (e.g. `APPLE_TOKEN_EXPIRED`)
/// + a human message suitable for Korean UI copy. Keeping this separate
/// from [AppException] lets the notifier distinguish "login failed, stay on
/// login screen" from lower-level network/timeouts that we already map in
/// `core/network/error_interceptor.dart`.
class AuthRepositoryException implements Exception {
  const AuthRepositoryException({
    required this.code,
    required this.message,
    this.cause,
  });

  final String code;
  final String message;
  final Object? cause;

  @override
  String toString() =>
      'AuthRepositoryException(code: $code, message: $message)';
}

/// Orchestrates social login, token persistence, and backend sync.
///
/// Stays thin on purpose — the only pieces of logic it owns are:
///   1. translating a [SocialLoginResult] into the correct backend call
///   2. persisting the resulting tokens through [SecureStorage]
///   3. fetching `/me` on rehydrate
///
/// Decoding HTTP errors into [AuthRepositoryException] lives here (not in
/// the API client) so retrofit stays declarative.
class AuthRepository {
  AuthRepository({
    required AuthApi api,
    required SecureStorage secureStorage,
    required SocialLoginPort socialLogin,
  })  : _api = api,
        _storage = secureStorage,
        _social = socialLogin;

  final AuthApi _api;
  final SecureStorage _storage;
  final SocialLoginPort _social;

  Future<AuthUser> loginWithKakao() async {
    final SocialLoginResult social = await _social.signInWithKakao();
    final String? accessToken = social.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw const AuthRepositoryException(
        code: 'KAKAO_EMPTY_TOKEN',
        message: '카카오 로그인에 실패했습니다. 다시 시도해주세요.',
      );
    }
    final LoginResponse resp = await _call(
      () =>
          _api.loginKakao(KakaoLoginRequest(accessToken: accessToken).toJson()),
    );
    await _persistTokens(resp.accessToken, resp.refreshToken);
    return resp.user.toDomain();
  }

  /// Dev-only login that mints a real backend JWT tied to a real `User` row
  /// without invoking any social SDK. Mirrors [loginWithKakao] for token
  /// persistence so the rest of the app (including /me rehydrate) works
  /// unchanged. Calling this against a non-dev backend yields a 404 that the
  /// backend serves as an envelope-less body; [_fromDio] maps it to
  /// NETWORK_ERROR so the UI shows the generic failure copy.
  Future<AuthUser> loginDev({
    String nickname = '개발자',
    String? email,
  }) async {
    final LoginResponse resp = await _call(
      () => _api.loginDev(
        DevLoginRequest(nickname: nickname, email: email).toJson(),
      ),
    );
    await _persistTokens(resp.accessToken, resp.refreshToken);
    return resp.user.toDomain();
  }

  Future<AuthUser> loginWithApple() async {
    final SocialLoginResult social = await _social.signInWithApple();
    final String? identityToken = social.identityToken;
    if (identityToken == null || identityToken.isEmpty) {
      throw const AuthRepositoryException(
        code: 'APPLE_EMPTY_TOKEN',
        message: 'Apple 로그인에 실패했습니다. 다시 시도해주세요.',
      );
    }
    // rawNonce is always set by AppleLoginAdapter.signIn() alongside
    // identityToken — this branch guards the SocialLoginPort contract, not a
    // real runtime path (BC-93 nonce replay check requires it server-side).
    final String? rawNonce = social.rawNonce;
    if (rawNonce == null || rawNonce.isEmpty) {
      throw const AuthRepositoryException(
        code: 'APPLE_EMPTY_TOKEN',
        message: 'Apple 로그인에 실패했습니다. 다시 시도해주세요.',
      );
    }
    final LoginResponse resp = await _call(
      () => _api.loginApple(
        AppleLoginRequest(
          identityToken: identityToken,
          nonce: rawNonce,
          authorizationCode: social.authorizationCode,
        ).toJson(),
      ),
    );
    await _persistTokens(resp.accessToken, resp.refreshToken);
    return resp.user.toDomain();
  }

  /// Rehydrates the current user on app start. Returns `null` when there is
  /// no valid session — the notifier converts that into `Unauthenticated`.
  Future<AuthUser?> rehydrate() async {
    String? access;
    try {
      access = await _storage.readAccessToken();
    } catch (_) {
      // flutter_secure_storage throws MissingPluginException in pure Dart
      // test zones; treat as "no session" instead of crashing the bootstrap.
      return null;
    }
    if (access == null || access.isEmpty) {
      return null;
    }
    try {
      final AuthUserDto me = await _api.getMe();
      return me.toDomain();
    } on DioException {
      // Interceptors already attempted a refresh; if we still hit an error
      // the session is unrecoverable. Clear tokens so we don't loop.
      await _storage.clearTokens();
      return null;
    } on AppException {
      await _storage.clearTokens();
      return null;
    }
  }

  Future<void> logout() => _storage.clearTokens();

  /// Soft-deletes the current user (BC-82 account-management entry) and
  /// clears the local session the same way [logout] does — a deleted user
  /// has no valid session left to keep around.
  Future<void> deleteAccount() async {
    await _call(() => _api.deleteMe());
    await _storage.clearTokens();
  }

  /// Seeds realistic test data for the current dev-login user.
  ///
  /// Idempotent — calling it again clears the previous seed and re-creates it.
  /// Throws [AuthRepositoryException] with code `DEV_SEED_FORBIDDEN` when
  /// called on the protected 개발자 account.
  Future<void> seedTesterData() => _call(() => _api.seedTesterData());

  /// Updates the authenticated user's profile fields.
  ///
  /// Three-state per field (BC-100): omit the argument to leave it unchanged,
  /// pass an explicit `null` to clear it back to NULL, or pass a value to set
  /// it. Only supplied keys are sent, and an explicit `null` reaches the backend
  /// as JSON `null`, which `PATCH /me` reads (via `model_fields_set`) as clear.
  /// `nickname` is required, so `null`/omitted always means "unchanged".
  static const Object _unset = Object();

  Future<void> updateProfile({
    String? nickname,
    Object? bio = _unset,
    Object? coverImageUrl = _unset,
    Object? theme = _unset,
    Object? featuredBookId = _unset,
    Object? featuredQuote = _unset,
  }) =>
      _call(
        () => _api.updateProfile({
          if (nickname != null) 'nickname': nickname,
          if (!identical(bio, _unset)) 'bio': bio,
          if (!identical(coverImageUrl, _unset))
            'cover_image_url': coverImageUrl,
          if (!identical(theme, _unset)) 'theme': theme,
          if (!identical(featuredBookId, _unset))
            'featured_book_id': featuredBookId,
          if (!identical(featuredQuote, _unset))
            'featured_quote': featuredQuote,
        }),
      );

  /// Registers the device's push token. Swallows all errors because push
  /// registration is best-effort at login time; M5 will introduce a proper
  /// retry queue.
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
  }) async {
    try {
      await _api.registerDeviceToken(
        DeviceTokenRegisterRequest(token: token, platform: platform).toJson(),
      );
    } catch (_) {
      // Non-fatal at M1. See M5 for full device-token lifecycle.
    }
  }

  Future<void> _persistTokens(String access, String refresh) async {
    await _storage.saveAccessToken(access);
    await _storage.saveRefreshToken(refresh);
  }

  /// Wraps a retrofit call so the backend error envelope is translated into
  /// a typed [AuthRepositoryException] instead of a raw [DioException].
  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  AuthRepositoryException _fromDio(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return AuthRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '로그인에 실패했습니다.',
          cause: err,
        );
      }
    }
    return AuthRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      cause: err,
    );
  }
}
