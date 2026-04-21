import 'dart:io' show Platform;

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'social_login_port.dart';

/// Concrete Kakao implementation of [SocialLoginPort.signInWithKakao].
///
/// Prefers the KakaoTalk app flow when KakaoTalk is installed (the Korean
/// default — ~90%+ install rate for the 20–30대 여성 target segment), and
/// falls back to the web account flow otherwise. Apple flow is delegated to
/// [AppleLoginAdapter]; keeping both in a single class would force
/// `sign_in_with_apple` to link on Android, which we don't want.
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
        cause: e,
      );
    } catch (e) {
      throw SocialLoginFailed('Kakao SDK failed', cause: e);
    }
  }

  Future<OAuthToken> _requestToken() async {
    // Android/iOS both have KakaoTalk; web fallback is defined by the SDK.
    if (!Platform.isIOS && !Platform.isAndroid) {
      return UserApi.instance.loginWithKakaoAccount();
    }
    final bool talkInstalled = await isKakaoTalkInstalled();
    if (talkInstalled) {
      try {
        return await UserApi.instance.loginWithKakaoTalk();
      } catch (_) {
        // KakaoTalk app may be installed but not signed in; fall back to the
        // web account flow so the user can complete sign-in without leaving.
        return UserApi.instance.loginWithKakaoAccount();
      }
    }
    return UserApi.instance.loginWithKakaoAccount();
  }
}
