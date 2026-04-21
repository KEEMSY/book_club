/// Result of a successful social SDK login — the raw tokens we hand to the
/// backend. Names mirror what the respective vendor SDK emits so the port
/// does not do per-provider normalization.
class SocialLoginResult {
  const SocialLoginResult({
    this.accessToken,
    this.identityToken,
    this.authorizationCode,
  });

  /// Kakao: OAuth access_token.
  /// Apple: always null (Apple does not issue an access_token to the client).
  final String? accessToken;

  /// Apple: JWT identity_token. Kakao: null.
  final String? identityToken;

  /// Apple: server-exchange authorization_code (forwarded but backend ignores
  /// at M1). Kakao: null — the Kakao SDK on Korean apps never surfaces the
  /// auth code to the client.
  final String? authorizationCode;
}

/// Thrown when the user cancels the platform login sheet. Handled distinctly
/// from network / server errors so the UI stays silent on intentional dismiss.
class SocialLoginCancelled implements Exception {
  const SocialLoginCancelled();
}

/// Thrown when the platform SDK fails (user denied, SDK mis-initialized,
/// network unreachable, etc.). Wraps the underlying cause so repositories can
/// surface platform-specific error codes to the UI.
class SocialLoginFailed implements Exception {
  const SocialLoginFailed(this.message, {this.cause});

  final String message;
  final Object? cause;
}

/// Abstraction over the two social SDKs (Kakao, Apple) so AuthRepository can
/// be unit-tested without plugging either vendor SDK into test binaries.
///
/// Real implementations live in `kakao_login_adapter.dart` /
/// `apple_login_adapter.dart`. Tests inject a FakeSocialLoginPort.
abstract class SocialLoginPort {
  Future<SocialLoginResult> signInWithKakao();
  Future<SocialLoginResult> signInWithApple();
}
