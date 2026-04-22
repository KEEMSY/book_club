// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KakaoLoginRequest _$KakaoLoginRequestFromJson(Map<String, dynamic> json) {
  return _KakaoLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$KakaoLoginRequest {
  String get accessToken => throw _privateConstructorUsedError;

  /// Serializes this KakaoLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KakaoLoginRequestCopyWith<KakaoLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KakaoLoginRequestCopyWith<$Res> {
  factory $KakaoLoginRequestCopyWith(
          KakaoLoginRequest value, $Res Function(KakaoLoginRequest) then) =
      _$KakaoLoginRequestCopyWithImpl<$Res, KakaoLoginRequest>;
  @useResult
  $Res call({String accessToken});
}

/// @nodoc
class _$KakaoLoginRequestCopyWithImpl<$Res, $Val extends KakaoLoginRequest>
    implements $KakaoLoginRequestCopyWith<$Res> {
  _$KakaoLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KakaoLoginRequestImplCopyWith<$Res>
    implements $KakaoLoginRequestCopyWith<$Res> {
  factory _$$KakaoLoginRequestImplCopyWith(_$KakaoLoginRequestImpl value,
          $Res Function(_$KakaoLoginRequestImpl) then) =
      __$$KakaoLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String accessToken});
}

/// @nodoc
class __$$KakaoLoginRequestImplCopyWithImpl<$Res>
    extends _$KakaoLoginRequestCopyWithImpl<$Res, _$KakaoLoginRequestImpl>
    implements _$$KakaoLoginRequestImplCopyWith<$Res> {
  __$$KakaoLoginRequestImplCopyWithImpl(_$KakaoLoginRequestImpl _value,
      $Res Function(_$KakaoLoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
  }) {
    return _then(_$KakaoLoginRequestImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KakaoLoginRequestImpl implements _KakaoLoginRequest {
  const _$KakaoLoginRequestImpl({required this.accessToken});

  factory _$KakaoLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$KakaoLoginRequestImplFromJson(json);

  @override
  final String accessToken;

  @override
  String toString() {
    return 'KakaoLoginRequest(accessToken: $accessToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KakaoLoginRequestImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken);

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KakaoLoginRequestImplCopyWith<_$KakaoLoginRequestImpl> get copyWith =>
      __$$KakaoLoginRequestImplCopyWithImpl<_$KakaoLoginRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KakaoLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _KakaoLoginRequest implements KakaoLoginRequest {
  const factory _KakaoLoginRequest({required final String accessToken}) =
      _$KakaoLoginRequestImpl;

  factory _KakaoLoginRequest.fromJson(Map<String, dynamic> json) =
      _$KakaoLoginRequestImpl.fromJson;

  @override
  String get accessToken;

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KakaoLoginRequestImplCopyWith<_$KakaoLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppleLoginRequest _$AppleLoginRequestFromJson(Map<String, dynamic> json) {
  return _AppleLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$AppleLoginRequest {
  String get identityToken => throw _privateConstructorUsedError;
  String? get authorizationCode => throw _privateConstructorUsedError;

  /// Serializes this AppleLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppleLoginRequestCopyWith<AppleLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppleLoginRequestCopyWith<$Res> {
  factory $AppleLoginRequestCopyWith(
          AppleLoginRequest value, $Res Function(AppleLoginRequest) then) =
      _$AppleLoginRequestCopyWithImpl<$Res, AppleLoginRequest>;
  @useResult
  $Res call({String identityToken, String? authorizationCode});
}

/// @nodoc
class _$AppleLoginRequestCopyWithImpl<$Res, $Val extends AppleLoginRequest>
    implements $AppleLoginRequestCopyWith<$Res> {
  _$AppleLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identityToken = null,
    Object? authorizationCode = freezed,
  }) {
    return _then(_value.copyWith(
      identityToken: null == identityToken
          ? _value.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      authorizationCode: freezed == authorizationCode
          ? _value.authorizationCode
          : authorizationCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppleLoginRequestImplCopyWith<$Res>
    implements $AppleLoginRequestCopyWith<$Res> {
  factory _$$AppleLoginRequestImplCopyWith(_$AppleLoginRequestImpl value,
          $Res Function(_$AppleLoginRequestImpl) then) =
      __$$AppleLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String identityToken, String? authorizationCode});
}

/// @nodoc
class __$$AppleLoginRequestImplCopyWithImpl<$Res>
    extends _$AppleLoginRequestCopyWithImpl<$Res, _$AppleLoginRequestImpl>
    implements _$$AppleLoginRequestImplCopyWith<$Res> {
  __$$AppleLoginRequestImplCopyWithImpl(_$AppleLoginRequestImpl _value,
      $Res Function(_$AppleLoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identityToken = null,
    Object? authorizationCode = freezed,
  }) {
    return _then(_$AppleLoginRequestImpl(
      identityToken: null == identityToken
          ? _value.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      authorizationCode: freezed == authorizationCode
          ? _value.authorizationCode
          : authorizationCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppleLoginRequestImpl implements _AppleLoginRequest {
  const _$AppleLoginRequestImpl(
      {required this.identityToken, this.authorizationCode});

  factory _$AppleLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppleLoginRequestImplFromJson(json);

  @override
  final String identityToken;
  @override
  final String? authorizationCode;

  @override
  String toString() {
    return 'AppleLoginRequest(identityToken: $identityToken, authorizationCode: $authorizationCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppleLoginRequestImpl &&
            (identical(other.identityToken, identityToken) ||
                other.identityToken == identityToken) &&
            (identical(other.authorizationCode, authorizationCode) ||
                other.authorizationCode == authorizationCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, identityToken, authorizationCode);

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppleLoginRequestImplCopyWith<_$AppleLoginRequestImpl> get copyWith =>
      __$$AppleLoginRequestImplCopyWithImpl<_$AppleLoginRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppleLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _AppleLoginRequest implements AppleLoginRequest {
  const factory _AppleLoginRequest(
      {required final String identityToken,
      final String? authorizationCode}) = _$AppleLoginRequestImpl;

  factory _AppleLoginRequest.fromJson(Map<String, dynamic> json) =
      _$AppleLoginRequestImpl.fromJson;

  @override
  String get identityToken;
  @override
  String? get authorizationCode;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppleLoginRequestImplCopyWith<_$AppleLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefreshRequest _$RefreshRequestFromJson(Map<String, dynamic> json) {
  return _RefreshRequest.fromJson(json);
}

/// @nodoc
mixin _$RefreshRequest {
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this RefreshRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshRequestCopyWith<RefreshRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshRequestCopyWith<$Res> {
  factory $RefreshRequestCopyWith(
          RefreshRequest value, $Res Function(RefreshRequest) then) =
      _$RefreshRequestCopyWithImpl<$Res, RefreshRequest>;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class _$RefreshRequestCopyWithImpl<$Res, $Val extends RefreshRequest>
    implements $RefreshRequestCopyWith<$Res> {
  _$RefreshRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
  }) {
    return _then(_value.copyWith(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefreshRequestImplCopyWith<$Res>
    implements $RefreshRequestCopyWith<$Res> {
  factory _$$RefreshRequestImplCopyWith(_$RefreshRequestImpl value,
          $Res Function(_$RefreshRequestImpl) then) =
      __$$RefreshRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$$RefreshRequestImplCopyWithImpl<$Res>
    extends _$RefreshRequestCopyWithImpl<$Res, _$RefreshRequestImpl>
    implements _$$RefreshRequestImplCopyWith<$Res> {
  __$$RefreshRequestImplCopyWithImpl(
      _$RefreshRequestImpl _value, $Res Function(_$RefreshRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
  }) {
    return _then(_$RefreshRequestImpl(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshRequestImpl implements _RefreshRequest {
  const _$RefreshRequestImpl({required this.refreshToken});

  factory _$RefreshRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshRequestImplFromJson(json);

  @override
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshRequest(refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshRequestImplCopyWith<_$RefreshRequestImpl> get copyWith =>
      __$$RefreshRequestImplCopyWithImpl<_$RefreshRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshRequestImplToJson(
      this,
    );
  }
}

abstract class _RefreshRequest implements RefreshRequest {
  const factory _RefreshRequest({required final String refreshToken}) =
      _$RefreshRequestImpl;

  factory _RefreshRequest.fromJson(Map<String, dynamic> json) =
      _$RefreshRequestImpl.fromJson;

  @override
  String get refreshToken;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshRequestImplCopyWith<_$RefreshRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceTokenRegisterRequest _$DeviceTokenRegisterRequestFromJson(
    Map<String, dynamic> json) {
  return _DeviceTokenRegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$DeviceTokenRegisterRequest {
  String get token => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  /// Serializes this DeviceTokenRegisterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceTokenRegisterRequestCopyWith<DeviceTokenRegisterRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceTokenRegisterRequestCopyWith<$Res> {
  factory $DeviceTokenRegisterRequestCopyWith(DeviceTokenRegisterRequest value,
          $Res Function(DeviceTokenRegisterRequest) then) =
      _$DeviceTokenRegisterRequestCopyWithImpl<$Res,
          DeviceTokenRegisterRequest>;
  @useResult
  $Res call({String token, String platform});
}

/// @nodoc
class _$DeviceTokenRegisterRequestCopyWithImpl<$Res,
        $Val extends DeviceTokenRegisterRequest>
    implements $DeviceTokenRegisterRequestCopyWith<$Res> {
  _$DeviceTokenRegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? platform = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceTokenRegisterRequestImplCopyWith<$Res>
    implements $DeviceTokenRegisterRequestCopyWith<$Res> {
  factory _$$DeviceTokenRegisterRequestImplCopyWith(
          _$DeviceTokenRegisterRequestImpl value,
          $Res Function(_$DeviceTokenRegisterRequestImpl) then) =
      __$$DeviceTokenRegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String platform});
}

/// @nodoc
class __$$DeviceTokenRegisterRequestImplCopyWithImpl<$Res>
    extends _$DeviceTokenRegisterRequestCopyWithImpl<$Res,
        _$DeviceTokenRegisterRequestImpl>
    implements _$$DeviceTokenRegisterRequestImplCopyWith<$Res> {
  __$$DeviceTokenRegisterRequestImplCopyWithImpl(
      _$DeviceTokenRegisterRequestImpl _value,
      $Res Function(_$DeviceTokenRegisterRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? platform = null,
  }) {
    return _then(_$DeviceTokenRegisterRequestImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceTokenRegisterRequestImpl implements _DeviceTokenRegisterRequest {
  const _$DeviceTokenRegisterRequestImpl(
      {required this.token, required this.platform});

  factory _$DeviceTokenRegisterRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$DeviceTokenRegisterRequestImplFromJson(json);

  @override
  final String token;
  @override
  final String platform;

  @override
  String toString() {
    return 'DeviceTokenRegisterRequest(token: $token, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceTokenRegisterRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, platform);

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceTokenRegisterRequestImplCopyWith<_$DeviceTokenRegisterRequestImpl>
      get copyWith => __$$DeviceTokenRegisterRequestImplCopyWithImpl<
          _$DeviceTokenRegisterRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceTokenRegisterRequestImplToJson(
      this,
    );
  }
}

abstract class _DeviceTokenRegisterRequest
    implements DeviceTokenRegisterRequest {
  const factory _DeviceTokenRegisterRequest(
      {required final String token,
      required final String platform}) = _$DeviceTokenRegisterRequestImpl;

  factory _DeviceTokenRegisterRequest.fromJson(Map<String, dynamic> json) =
      _$DeviceTokenRegisterRequestImpl.fromJson;

  @override
  String get token;
  @override
  String get platform;

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceTokenRegisterRequestImplCopyWith<_$DeviceTokenRegisterRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) {
  return _AuthUserDto.fromJson(json);
}

/// @nodoc
mixin _$AuthUserDto {
  String get id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this AuthUserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserDtoCopyWith<AuthUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserDtoCopyWith<$Res> {
  factory $AuthUserDtoCopyWith(
          AuthUserDto value, $Res Function(AuthUserDto) then) =
      _$AuthUserDtoCopyWithImpl<$Res, AuthUserDto>;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String provider,
      DateTime createdAt,
      String? profileImageUrl,
      String? email});
}

/// @nodoc
class _$AuthUserDtoCopyWithImpl<$Res, $Val extends AuthUserDto>
    implements $AuthUserDtoCopyWith<$Res> {
  _$AuthUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? provider = null,
    Object? createdAt = null,
    Object? profileImageUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthUserDtoImplCopyWith<$Res>
    implements $AuthUserDtoCopyWith<$Res> {
  factory _$$AuthUserDtoImplCopyWith(
          _$AuthUserDtoImpl value, $Res Function(_$AuthUserDtoImpl) then) =
      __$$AuthUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String provider,
      DateTime createdAt,
      String? profileImageUrl,
      String? email});
}

/// @nodoc
class __$$AuthUserDtoImplCopyWithImpl<$Res>
    extends _$AuthUserDtoCopyWithImpl<$Res, _$AuthUserDtoImpl>
    implements _$$AuthUserDtoImplCopyWith<$Res> {
  __$$AuthUserDtoImplCopyWithImpl(
      _$AuthUserDtoImpl _value, $Res Function(_$AuthUserDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? provider = null,
    Object? createdAt = null,
    Object? profileImageUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(_$AuthUserDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserDtoImpl extends _AuthUserDto {
  const _$AuthUserDtoImpl(
      {required this.id,
      required this.nickname,
      required this.provider,
      required this.createdAt,
      this.profileImageUrl,
      this.email})
      : super._();

  factory _$AuthUserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String provider;
  @override
  final DateTime createdAt;
  @override
  final String? profileImageUrl;
  @override
  final String? email;

  @override
  String toString() {
    return 'AuthUserDto(id: $id, nickname: $nickname, provider: $provider, createdAt: $createdAt, profileImageUrl: $profileImageUrl, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nickname, provider, createdAt, profileImageUrl, email);

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserDtoImplCopyWith<_$AuthUserDtoImpl> get copyWith =>
      __$$AuthUserDtoImplCopyWithImpl<_$AuthUserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserDtoImplToJson(
      this,
    );
  }
}

abstract class _AuthUserDto extends AuthUserDto {
  const factory _AuthUserDto(
      {required final String id,
      required final String nickname,
      required final String provider,
      required final DateTime createdAt,
      final String? profileImageUrl,
      final String? email}) = _$AuthUserDtoImpl;
  const _AuthUserDto._() : super._();

  factory _AuthUserDto.fromJson(Map<String, dynamic> json) =
      _$AuthUserDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get nickname;
  @override
  String get provider;
  @override
  DateTime get createdAt;
  @override
  String? get profileImageUrl;
  @override
  String? get email;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserDtoImplCopyWith<_$AuthUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  AuthUserDto get user => throw _privateConstructorUsedError;
  bool get isNewUser => throw _privateConstructorUsedError;

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn,
      AuthUserDto user,
      bool isNewUser});

  $AuthUserDtoCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? user = null,
    Object? isNewUser = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUserDto,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserDtoCopyWith<$Res> get user {
    return $AuthUserDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
          _$LoginResponseImpl value, $Res Function(_$LoginResponseImpl) then) =
      __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn,
      AuthUserDto user,
      bool isNewUser});

  @override
  $AuthUserDtoCopyWith<$Res> get user;
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
      _$LoginResponseImpl _value, $Res Function(_$LoginResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? user = null,
    Object? isNewUser = null,
  }) {
    return _then(_$LoginResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUserDto,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl(
      {required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
      required this.expiresIn,
      required this.user,
      required this.isNewUser});

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final String tokenType;
  @override
  final int expiresIn;
  @override
  final AuthUserDto user;
  @override
  final bool isNewUser;

  @override
  String toString() {
    return 'LoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, user: $user, isNewUser: $isNewUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken,
      tokenType, expiresIn, user, isNewUser);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(
      this,
    );
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse(
      {required final String accessToken,
      required final String refreshToken,
      required final String tokenType,
      required final int expiresIn,
      required final AuthUserDto user,
      required final bool isNewUser}) = _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  String get tokenType;
  @override
  int get expiresIn;
  @override
  AuthUserDto get user;
  @override
  bool get isNewUser;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefreshResponse _$RefreshResponseFromJson(Map<String, dynamic> json) {
  return _RefreshResponse.fromJson(json);
}

/// @nodoc
mixin _$RefreshResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;

  /// Serializes this RefreshResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshResponseCopyWith<RefreshResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshResponseCopyWith<$Res> {
  factory $RefreshResponseCopyWith(
          RefreshResponse value, $Res Function(RefreshResponse) then) =
      _$RefreshResponseCopyWithImpl<$Res, RefreshResponse>;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn});
}

/// @nodoc
class _$RefreshResponseCopyWithImpl<$Res, $Val extends RefreshResponse>
    implements $RefreshResponseCopyWith<$Res> {
  _$RefreshResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefreshResponseImplCopyWith<$Res>
    implements $RefreshResponseCopyWith<$Res> {
  factory _$$RefreshResponseImplCopyWith(_$RefreshResponseImpl value,
          $Res Function(_$RefreshResponseImpl) then) =
      __$$RefreshResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn});
}

/// @nodoc
class __$$RefreshResponseImplCopyWithImpl<$Res>
    extends _$RefreshResponseCopyWithImpl<$Res, _$RefreshResponseImpl>
    implements _$$RefreshResponseImplCopyWith<$Res> {
  __$$RefreshResponseImplCopyWithImpl(
      _$RefreshResponseImpl _value, $Res Function(_$RefreshResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
  }) {
    return _then(_$RefreshResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshResponseImpl implements _RefreshResponse {
  const _$RefreshResponseImpl(
      {required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
      required this.expiresIn});

  factory _$RefreshResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final String tokenType;
  @override
  final int expiresIn;

  @override
  String toString() {
    return 'RefreshResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, tokenType, expiresIn);

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshResponseImplCopyWith<_$RefreshResponseImpl> get copyWith =>
      __$$RefreshResponseImplCopyWithImpl<_$RefreshResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshResponseImplToJson(
      this,
    );
  }
}

abstract class _RefreshResponse implements RefreshResponse {
  const factory _RefreshResponse(
      {required final String accessToken,
      required final String refreshToken,
      required final String tokenType,
      required final int expiresIn}) = _$RefreshResponseImpl;

  factory _RefreshResponse.fromJson(Map<String, dynamic> json) =
      _$RefreshResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  String get tokenType;
  @override
  int get expiresIn;

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshResponseImplCopyWith<_$RefreshResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
