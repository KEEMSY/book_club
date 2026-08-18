/// Result of a successful social SDK login — the raw tokens we hand to the
/// backend. Names mirror what the respective vendor SDK emits so the port
/// does not do per-provider normalization.
class SocialLoginResult {
  const SocialLoginResult({
    this.accessToken,
    this.identityToken,
    this.authorizationCode,
    this.rawNonce,
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

  /// Apple: the raw (unhashed) nonce generated before invoking the native
  /// Sign In with Apple sheet. Its SHA256 hash was handed to the SDK as the
  /// request nonce, so it only ever shows up hashed inside [identityToken]'s
  /// `nonce` claim (BC-93). The backend re-hashes this value and compares.
  /// Kakao: null.
  final String? rawNonce;
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
  const SocialLoginFailed(this.message, {this.code, this.cause});

  final String message;

  /// Stable classifier for the failure, used to pick user copy and to group
  /// crash reports. Null means "unclassified SDK failure"; see
  /// [socialLoginMisconfiguredCode] for the one case that must not be shown
  /// to the user as retryable.
  final String? code;

  final Object? cause;
}

/// The provider rejected the app's own registration — Kakao KOE101: wrong app
/// key, unregistered package name / bundle id / Android key hash, or Kakao
/// Login disabled in the developer console. Retrying never clears it, so the
/// UI must not tell the user to try again (BC-26).
const String socialLoginMisconfiguredCode = 'SOCIAL_LOGIN_MISCONFIGURED';

/// Abstraction over the two social SDKs (Kakao, Apple) so AuthRepository can
/// be unit-tested without plugging either vendor SDK into test binaries.
///
/// Real implementations live in `kakao_login_adapter.dart` /
/// `apple_login_adapter.dart`. Tests inject a FakeSocialLoginPort.
abstract class SocialLoginPort {
  Future<SocialLoginResult> signInWithKakao();
  Future<SocialLoginResult> signInWithApple();
}
