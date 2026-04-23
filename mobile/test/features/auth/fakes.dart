import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/features/auth/data/auth_api.dart';
import 'package:book_club/features/auth/data/auth_models.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/auth/domain/auth_user.dart';

/// In-memory [SecureStorage] stand-in for tests. Bypasses the
/// `flutter_secure_storage` platform channel so unit / widget tests do not
/// need an integration harness.
class InMemorySecureStorage implements SecureStorage {
  String? _access;
  String? _refresh;
  final Map<String, String> _generic = <String, String>{};

  @override
  Future<String?> readAccessToken() async => _access;

  @override
  Future<String?> readRefreshToken() async => _refresh;

  @override
  Future<void> saveAccessToken(String token) async => _access = token;

  @override
  Future<void> saveRefreshToken(String token) async => _refresh = token;

  @override
  Future<void> clearTokens() async {
    _access = null;
    _refresh = null;
  }

  @override
  Future<String?> readRaw(String key) async => _generic[key];

  @override
  Future<void> writeRaw(String key, String value) async {
    _generic[key] = value;
  }

  @override
  Future<void> deleteRaw(String key) async {
    _generic.remove(key);
  }
}

/// Social-login port that replays a fixed sequence of results. Use one
/// factory per provider if you need divergent behaviour in the same test.
class FakeSocialLoginPort implements SocialLoginPort {
  FakeSocialLoginPort({
    this.kakaoResult,
    this.kakaoError,
    this.appleResult,
    this.appleError,
  });

  final SocialLoginResult? kakaoResult;
  final Object? kakaoError;
  final SocialLoginResult? appleResult;
  final Object? appleError;

  int kakaoCalls = 0;
  int appleCalls = 0;

  @override
  Future<SocialLoginResult> signInWithKakao() async {
    kakaoCalls++;
    if (kakaoError != null) throw kakaoError!;
    return kakaoResult!;
  }

  @override
  Future<SocialLoginResult> signInWithApple() async {
    appleCalls++;
    if (appleError != null) throw appleError!;
    return appleResult!;
  }
}

/// Fake AuthApi that lets tests inject deterministic login / /me responses.
class FakeAuthApi implements AuthApi {
  FakeAuthApi({
    this.loginKakaoResponse,
    this.loginAppleResponse,
    this.refreshResponse,
    this.meResponse,
    this.meError,
    this.loginKakaoError,
    this.loginAppleError,
  });

  LoginResponse? loginKakaoResponse;
  Object? loginKakaoError;
  LoginResponse? loginAppleResponse;
  Object? loginAppleError;
  RefreshResponse? refreshResponse;
  AuthUserDto? meResponse;
  Object? meError;

  int loginKakaoCalls = 0;
  int loginAppleCalls = 0;
  int refreshCalls = 0;
  int getMeCalls = 0;
  int registerDeviceTokenCalls = 0;
  int deleteMeCalls = 0;

  @override
  Future<LoginResponse> loginKakao(Map<String, dynamic> body) async {
    loginKakaoCalls++;
    if (loginKakaoError != null) throw loginKakaoError!;
    return loginKakaoResponse!;
  }

  @override
  Future<LoginResponse> loginApple(Map<String, dynamic> body) async {
    loginAppleCalls++;
    if (loginAppleError != null) throw loginAppleError!;
    return loginAppleResponse!;
  }

  @override
  Future<RefreshResponse> refresh(Map<String, dynamic> body) async {
    refreshCalls++;
    return refreshResponse!;
  }

  @override
  Future<void> registerDeviceToken(Map<String, dynamic> body) async {
    registerDeviceTokenCalls++;
  }

  @override
  Future<AuthUserDto> getMe() async {
    getMeCalls++;
    if (meError != null) throw meError!;
    return meResponse!;
  }

  @override
  Future<void> deleteMe() async {
    deleteMeCalls++;
  }
}

/// Helper that builds a canonical [AuthUserDto] for test fixtures.
AuthUserDto buildUserDto({
  String id = '00000000-0000-0000-0000-000000000001',
  String nickname = '희재',
  String provider = 'kakao',
  String? email,
}) {
  return AuthUserDto(
    id: id,
    nickname: nickname,
    provider: provider,
    createdAt: DateTime.utc(2026, 4, 20, 12),
    profileImageUrl: null,
    email: email,
  );
}

AuthUser buildUser({
  String id = '00000000-0000-0000-0000-000000000001',
  String nickname = '희재',
  AuthProvider provider = AuthProvider.kakao,
}) {
  return AuthUser(
    id: id,
    nickname: nickname,
    provider: provider,
    createdAt: DateTime.utc(2026, 4, 20, 12),
  );
}

LoginResponse buildLoginResponse({
  String access = 'access-token',
  String refresh = 'refresh-token',
  AuthUserDto? user,
  bool isNewUser = false,
}) {
  return LoginResponse(
    accessToken: access,
    refreshToken: refresh,
    tokenType: 'Bearer',
    expiresIn: 3600,
    user: user ?? buildUserDto(),
    isNewUser: isNewUser,
  );
}

AuthRepository buildRepository({
  AuthApi? api,
  SecureStorage? storage,
  SocialLoginPort? social,
}) {
  return AuthRepository(
    api: api ?? FakeAuthApi(),
    secureStorage: storage ?? InMemorySecureStorage(),
    socialLogin: social ??
        FakeSocialLoginPort(
          kakaoResult: const SocialLoginResult(accessToken: 'k-at'),
          appleResult: const SocialLoginResult(identityToken: 'a-id'),
        ),
  );
}
