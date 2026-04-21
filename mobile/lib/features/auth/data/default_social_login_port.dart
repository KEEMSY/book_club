import 'apple_login_adapter.dart';
import 'kakao_login_adapter.dart';
import 'social_login_port.dart';

/// Production [SocialLoginPort] that delegates to the real Kakao and Apple
/// SDK adapters. Tests inject a fake port directly and never see this class.
class DefaultSocialLoginPort implements SocialLoginPort {
  const DefaultSocialLoginPort({
    this.kakao = const KakaoLoginAdapter(),
    this.apple = const AppleLoginAdapter(),
  });

  final KakaoLoginAdapter kakao;
  final AppleLoginAdapter apple;

  @override
  Future<SocialLoginResult> signInWithKakao() => kakao.signIn();

  @override
  Future<SocialLoginResult> signInWithApple() => apple.signIn();
}
