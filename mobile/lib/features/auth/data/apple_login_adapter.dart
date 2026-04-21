import 'dart:io' show Platform;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'social_login_port.dart';

/// Concrete Apple implementation. On Android the SDK is a no-op (Android has
/// no native Apple login flow); this adapter throws if called there so the UI
/// guard (`Platform.isIOS`) is enforced at runtime as well.
class AppleLoginAdapter {
  const AppleLoginAdapter();

  Future<SocialLoginResult> signIn() async {
    if (!Platform.isIOS) {
      throw const SocialLoginFailed(
        'Apple Sign In is only supported on iOS in this build',
      );
    }

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final String? identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw const SocialLoginFailed(
          'Apple Sign In returned empty identity_token',
        );
      }
      return SocialLoginResult(
        identityToken: identityToken,
        authorizationCode: credential.authorizationCode,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const SocialLoginCancelled();
      }
      throw SocialLoginFailed('Apple auth error: ${e.code}', cause: e);
    } catch (e) {
      throw SocialLoginFailed('Apple SDK failed', cause: e);
    }
  }
}
