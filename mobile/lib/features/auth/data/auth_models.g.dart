// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KakaoLoginRequestImpl _$$KakaoLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$KakaoLoginRequestImpl(
      accessToken: json['access_token'] as String,
    );

Map<String, dynamic> _$$KakaoLoginRequestImplToJson(
        _$KakaoLoginRequestImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
    };

_$AppleLoginRequestImpl _$$AppleLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AppleLoginRequestImpl(
      identityToken: json['identity_token'] as String,
      authorizationCode: json['authorization_code'] as String?,
    );

Map<String, dynamic> _$$AppleLoginRequestImplToJson(
        _$AppleLoginRequestImpl instance) =>
    <String, dynamic>{
      'identity_token': instance.identityToken,
      'authorization_code': instance.authorizationCode,
    };

_$RefreshRequestImpl _$$RefreshRequestImplFromJson(Map<String, dynamic> json) =>
    _$RefreshRequestImpl(
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$$RefreshRequestImplToJson(
        _$RefreshRequestImpl instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
    };

_$DeviceTokenRegisterRequestImpl _$$DeviceTokenRegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceTokenRegisterRequestImpl(
      token: json['token'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$$DeviceTokenRegisterRequestImplToJson(
        _$DeviceTokenRegisterRequestImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'platform': instance.platform,
    };

_$AuthUserDtoImpl _$$AuthUserDtoImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserDtoImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      provider: json['provider'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      profileImageUrl: json['profile_image_url'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$AuthUserDtoImplToJson(_$AuthUserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'provider': instance.provider,
      'created_at': instance.createdAt.toIso8601String(),
      'profile_image_url': instance.profileImageUrl,
      'email': instance.email,
    };

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      user: AuthUserDto.fromJson(json['user'] as Map<String, dynamic>),
      isNewUser: json['is_new_user'] as bool,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'user': instance.user.toJson(),
      'is_new_user': instance.isNewUser,
    };

_$RefreshResponseImpl _$$RefreshResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RefreshResponseImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$$RefreshResponseImplToJson(
        _$RefreshResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };
