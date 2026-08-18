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
abstract class KakaoLoginRequest with _$KakaoLoginRequest {
  const factory KakaoLoginRequest({
    required String accessToken,
  }) = _KakaoLoginRequest;

  factory KakaoLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$KakaoLoginRequestFromJson(json);
}

/// Request to POST /auth/apple. [authorizationCode] is forward-compat for a
/// future server-side Apple refresh exchange — M1 backend ignores it.
/// [nonce] is the raw (unhashed) value generated before the Sign In with
/// Apple sheet was shown — the backend re-hashes it and checks it against
/// identityToken's `nonce` claim to reject replayed tokens (BC-93).
@freezed
abstract class AppleLoginRequest with _$AppleLoginRequest {
  const factory AppleLoginRequest({
    required String identityToken,
    required String nonce,
    String? authorizationCode,
  }) = _AppleLoginRequest;

  factory AppleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleLoginRequestFromJson(json);
}

/// Request to POST /auth/dev-login.
///
/// Dev-only surface — the backend gates this on `settings.env == "dev"` and
/// returns 404 elsewhere. The mobile side still ships the DTO so release
/// builds that hit a non-dev backend fail with the normal 404 repository
/// mapping instead of a freezed/json_serializable compile error.
@freezed
abstract class DevLoginRequest with _$DevLoginRequest {
  const factory DevLoginRequest({
    @Default('개발자') String nickname,
    String? email,
  }) = _DevLoginRequest;

  factory DevLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$DevLoginRequestFromJson(json);
}

@freezed
abstract class RefreshRequest with _$RefreshRequest {
  const factory RefreshRequest({
    required String refreshToken,
  }) = _RefreshRequest;

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
}

@freezed
abstract class DeviceTokenRegisterRequest with _$DeviceTokenRegisterRequest {
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
abstract class AuthUserDto with _$AuthUserDto {
  const AuthUserDto._();

  const factory AuthUserDto({
    required String id,
    required String nickname,
    required String provider,
    required DateTime createdAt,
    String? profileImageUrl,
    String? email,
    // BC-87: not yet sent by `UserPublic` (backend BC-81, parallel work) —
    // defaults to false so today's `/me` payload still parses cleanly. Once
    // BC-81 adds `is_admin`, `field_rename: snake` picks it up automatically.
    @Default(false) bool isAdmin,
    // Profile expressiveness (backend BC-81, mobile UI BC-84) — mirrors
    // `UserPublic.cover_image_url` / `.theme` / `.featured_book_id` /
    // `.featured_quote`. Raw wire values; see `AuthUser` for why `theme`
    // stays a `String?` here instead of the `ProfileTheme` enum.
    String? coverImageUrl,
    String? theme,
    String? featuredBookId,
    String? featuredQuote,
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
      isAdmin: isAdmin,
      coverImageUrl: coverImageUrl,
      theme: theme,
      featuredBookId: featuredBookId,
      featuredQuote: featuredQuote,
    );
  }
}

@freezed
abstract class LoginResponse with _$LoginResponse {
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
abstract class RefreshResponse with _$RefreshResponse {
  const factory RefreshResponse({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
  }) = _RefreshResponse;

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
}
