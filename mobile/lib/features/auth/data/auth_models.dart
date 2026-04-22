import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/auth_user.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// Request to POST /auth/kakao.
///
/// The Kakao Flutter SDK on native iOS/Android never surfaces an OAuth
/// authorization code — it hands the client an [accessToken] directly. The
/// backend therefore accepts the access_token verbatim and calls Kakao's
/// `/v2/user/me` endpoint itself; no server-side token exchange takes place.
/// Snake-case JSON keys are handled globally via `build.yaml`.
@freezed
class KakaoLoginRequest with _$KakaoLoginRequest {
  const factory KakaoLoginRequest({
    required String accessToken,
  }) = _KakaoLoginRequest;

  factory KakaoLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$KakaoLoginRequestFromJson(json);
}

/// Request to POST /auth/apple. [authorizationCode] is forward-compat for a
/// future server-side Apple refresh exchange — M1 backend ignores it.
@freezed
class AppleLoginRequest with _$AppleLoginRequest {
  const factory AppleLoginRequest({
    required String identityToken,
    String? authorizationCode,
  }) = _AppleLoginRequest;

  factory AppleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleLoginRequestFromJson(json);
}

@freezed
class RefreshRequest with _$RefreshRequest {
  const factory RefreshRequest({
    required String refreshToken,
  }) = _RefreshRequest;

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
}

@freezed
class DeviceTokenRegisterRequest with _$DeviceTokenRegisterRequest {
  const factory DeviceTokenRegisterRequest({
    required String token,
    required String platform,
  }) = _DeviceTokenRegisterRequest;

  factory DeviceTokenRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenRegisterRequestFromJson(json);
}

/// Data-layer mirror of the backend `UserPublic` response.
///
/// Keeps [provider] as a raw string so json_serializable can round-trip
/// without a custom converter. Conversion to the domain enum happens at the
/// repository boundary ([AuthUserDto.toDomain]).
@freezed
class AuthUserDto with _$AuthUserDto {
  const AuthUserDto._();

  const factory AuthUserDto({
    required String id,
    required String nickname,
    required String provider,
    required DateTime createdAt,
    String? profileImageUrl,
    String? email,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);

  AuthUser toDomain() {
    return AuthUser(
      id: id,
      nickname: nickname,
      provider: AuthProvider.fromWire(provider),
      createdAt: createdAt,
      profileImageUrl: profileImageUrl,
      email: email,
    );
  }
}

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
    required AuthUserDto user,
    required bool isNewUser,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class RefreshResponse with _$RefreshResponse {
  const factory RefreshResponse({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
  }) = _RefreshResponse;

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
}
