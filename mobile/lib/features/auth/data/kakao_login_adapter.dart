import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'social_login_port.dart';

/// Concrete Kakao implementation of [SocialLoginPort.signInWithKakao].
///
/// Login priority:
///   1. KakaoTalk app — preferred when installed (~90%+ install rate in KR).
///   2. Web account flow — fallback when KakaoTalk is absent OR when KakaoTalk
///      returns error 101 (account not linked to a Kakao account).
///
/// Error 101 scenario: KakaoTalk is installed but the user's KakaoTalk account
/// is not linked to a full Kakao account. Per Kakao SDK docs, the correct
/// response is to redirect the user to [loginWithKakaoAccount] so they can
/// complete the account link in a web flow. We do NOT swallow a CANCELED
/// PlatformException in that branch — intentional cancels should surface as
/// [SocialLoginCancelled] rather than silently opening a browser.
class KakaoLoginAdapter {
  const KakaoLoginAdapter();

  Future<SocialLoginResult> signIn() async {
    try {
      final OAuthToken token = await _requestToken();
      return SocialLoginResult(accessToken: token.accessToken);
    } on KakaoClientException catch (e) {
      if (e.reason == ClientErrorCause.cancelled) {
        throw const SocialLoginCancelled();
      }
      throw SocialLoginFailed('Kakao client error: ${e.reason}', cause: e);
    } on KakaoAuthException catch (e) {
      if (e.error == AuthErrorCause.accessDenied) {
        throw const SocialLoginCancelled();
      }
      throw SocialLoginFailed(
        'Kakao auth error: ${e.error}',
        code:
            _isMisconfiguration(e.error) ? socialLoginMisconfiguredCode : null,
        cause: e,
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') throw const SocialLoginCancelled();
      throw SocialLoginFailed('Kakao platform error: ${e.code}', cause: e);
    } catch (e) {
      throw SocialLoginFailed('Kakao SDK failed', cause: e);
    }
  }

  /// KOE101 surfaces as `misconfigured` (platform settings) or
  /// `invalid_client` (unknown app key). Both mean the console registration is
  /// wrong, never that the user did something wrong.
  static bool _isMisconfiguration(AuthErrorCause cause) =>
      cause == AuthErrorCause.misconfigured ||
      cause == AuthErrorCause.invalidClient;

  Future<OAuthToken> _requestToken() async {
    // Web can't call Platform.isIOS/isAndroid — always use account flow there.
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      return UserApi.instance.loginWithKakaoAccount();
    }

    final bool talkInstalled = await isKakaoTalkInstalled();
    if (!talkInstalled) {
      return UserApi.instance.loginWithKakaoAccount();
    }

    // Try KakaoTalk app first.
    try {
      return await UserApi.instance.loginWithKakaoTalk();
    } on PlatformException catch (e) {
      // User intentionally cancelled inside KakaoTalk — do not retry.
      if (e.code == 'CANCELED') rethrow;
      // Error 101 (account not linked) or any other KakaoTalk failure →
      // fall through to web account login below.
    } catch (_) {
      // Any Dart-layer exception from KakaoTalk → fall through.
    }

    // Fallback: Kakao web account login (handles error 101 account linking).
    return UserApi.instance.loginWithKakaoAccount();
  }
}
