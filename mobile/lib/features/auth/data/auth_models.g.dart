// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KakaoLoginRequest _$KakaoLoginRequestFromJson(Map<String, dynamic> json) =>
    _KakaoLoginRequest(
      accessToken: json['access_token'] as String,
    );

Map<String, dynamic> _$KakaoLoginRequestToJson(_KakaoLoginRequest instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
    };

_AppleLoginRequest _$AppleLoginRequestFromJson(Map<String, dynamic> json) =>
    _AppleLoginRequest(
      identityToken: json['identity_token'] as String,
      authorizationCode: json['authorization_code'] as String?,
    );

Map<String, dynamic> _$AppleLoginRequestToJson(_AppleLoginRequest instance) =>
    <String, dynamic>{
      'identity_token': instance.identityToken,
      'authorization_code': instance.authorizationCode,
    };

_DevLoginRequest _$DevLoginRequestFromJson(Map<String, dynamic> json) =>
    _DevLoginRequest(
      nickname: json['nickname'] as String? ?? '개발자',
      email: json['email'] as String?,
    );

Map<String, dynamic> _$DevLoginRequestToJson(_DevLoginRequest instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'email': instance.email,
    };

_RefreshRequest _$RefreshRequestFromJson(Map<String, dynamic> json) =>
    _RefreshRequest(
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$RefreshRequestToJson(_RefreshRequest instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
    };

_DeviceTokenRegisterRequest _$DeviceTokenRegisterRequestFromJson(
        Map<String, dynamic> json) =>
    _DeviceTokenRegisterRequest(
      token: json['token'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$DeviceTokenRegisterRequestToJson(
        _DeviceTokenRegisterRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'platform': instance.platform,
    };

_AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) => _AuthUserDto(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      provider: json['provider'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      profileImageUrl: json['profile_image_url'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AuthUserDtoToJson(_AuthUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'provider': instance.provider,
      'created_at': instance.createdAt.toIso8601String(),
      'profile_image_url': instance.profileImageUrl,
      'email': instance.email,
    };

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      user: AuthUserDto.fromJson(json['user'] as Map<String, dynamic>),
      isNewUser: json['is_new_user'] as bool,
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'user': instance.user.toJson(),
      'is_new_user': instance.isNewUser,
    };

_RefreshResponse _$RefreshResponseFromJson(Map<String, dynamic> json) =>
    _RefreshResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$RefreshResponseToJson(_RefreshResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };
