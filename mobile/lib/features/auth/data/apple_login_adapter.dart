import 'dart:convert' show utf8;
import 'dart:math' show Random;

import 'package:crypto/crypto.dart' show sha256;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'social_login_port.dart';

const String _nonceCharset =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';

/// Generates a cryptographically random raw nonce (BC-93).
///
/// [length] of 32 mirrors Apple/Firebase's reference implementation — long
/// enough that brute-forcing a specific value is infeasible within a login
/// attempt's lifetime.
String _generateRawNonce([int length = 32]) {
  final Random random = Random.secure();
  return List<String>.generate(
    length,
    (_) => _nonceCharset[random.nextInt(_nonceCharset.length)],
  ).join();
}

String _sha256OfString(String input) =>
    sha256.convert(utf8.encode(input)).toString();

/// Concrete Apple implementation. On Android the SDK is a no-op (Android has
/// no native Apple login flow); this adapter throws if called there so the UI
/// guard (`Platform.isIOS`) is enforced at runtime as well.
class AppleLoginAdapter {
  const AppleLoginAdapter();

  Future<SocialLoginResult> signIn() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      throw const SocialLoginFailed(
        'Apple Sign In is only supported on iOS in this build',
      );
    }

    // Nonce flow (BC-93): generate a raw nonce, hand its SHA256 hash to the
    // native SDK as the request nonce. Apple echoes that same hash back in
    // identity_token's `nonce` claim, so the backend can re-hash the raw
    // value we send alongside the token and confirm this identity_token was
    // minted for *this* login attempt — not replayed from another one.
    final String rawNonce = _generateRawNonce();
    final String hashedNonce = _sha256OfString(rawNonce);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
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
        rawNonce: rawNonce,
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
