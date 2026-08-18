// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KakaoLoginRequest {
  String get accessToken;

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KakaoLoginRequestCopyWith<KakaoLoginRequest> get copyWith =>
      _$KakaoLoginRequestCopyWithImpl<KakaoLoginRequest>(
          this as KakaoLoginRequest, _$identity);

  /// Serializes this KakaoLoginRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KakaoLoginRequest &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken);

  @override
  String toString() {
    return 'KakaoLoginRequest(accessToken: $accessToken)';
  }
}

/// @nodoc
abstract mixin class $KakaoLoginRequestCopyWith<$Res> {
  factory $KakaoLoginRequestCopyWith(
          KakaoLoginRequest value, $Res Function(KakaoLoginRequest) _then) =
      _$KakaoLoginRequestCopyWithImpl;
  @useResult
  $Res call({String accessToken});
}

/// @nodoc
class _$KakaoLoginRequestCopyWithImpl<$Res>
    implements $KakaoLoginRequestCopyWith<$Res> {
  _$KakaoLoginRequestCopyWithImpl(this._self, this._then);

  final KakaoLoginRequest _self;
  final $Res Function(KakaoLoginRequest) _then;

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
  }) {
    return _then(_self.copyWith(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [KakaoLoginRequest].
extension KakaoLoginRequestPatterns on KakaoLoginRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_KakaoLoginRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KakaoLoginRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_KakaoLoginRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KakaoLoginRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_KakaoLoginRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KakaoLoginRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String accessToken)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KakaoLoginRequest() when $default != null:
        return $default(_that.accessToken);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String accessToken) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KakaoLoginRequest():
        return $default(_that.accessToken);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String accessToken)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KakaoLoginRequest() when $default != null:
        return $default(_that.accessToken);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KakaoLoginRequest implements KakaoLoginRequest {
  const _KakaoLoginRequest({required this.accessToken});
  factory _KakaoLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$KakaoLoginRequestFromJson(json);

  @override
  final String accessToken;

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KakaoLoginRequestCopyWith<_KakaoLoginRequest> get copyWith =>
      __$KakaoLoginRequestCopyWithImpl<_KakaoLoginRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KakaoLoginRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KakaoLoginRequest &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken);

  @override
  String toString() {
    return 'KakaoLoginRequest(accessToken: $accessToken)';
  }
}

/// @nodoc
abstract mixin class _$KakaoLoginRequestCopyWith<$Res>
    implements $KakaoLoginRequestCopyWith<$Res> {
  factory _$KakaoLoginRequestCopyWith(
          _KakaoLoginRequest value, $Res Function(_KakaoLoginRequest) _then) =
      __$KakaoLoginRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String accessToken});
}

/// @nodoc
class __$KakaoLoginRequestCopyWithImpl<$Res>
    implements _$KakaoLoginRequestCopyWith<$Res> {
  __$KakaoLoginRequestCopyWithImpl(this._self, this._then);

  final _KakaoLoginRequest _self;
  final $Res Function(_KakaoLoginRequest) _then;

  /// Create a copy of KakaoLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
  }) {
    return _then(_KakaoLoginRequest(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AppleLoginRequest {
  String get identityToken;
  String get nonce;
  String? get authorizationCode;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppleLoginRequestCopyWith<AppleLoginRequest> get copyWith =>
      _$AppleLoginRequestCopyWithImpl<AppleLoginRequest>(
          this as AppleLoginRequest, _$identity);

  /// Serializes this AppleLoginRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppleLoginRequest &&
            (identical(other.identityToken, identityToken) ||
                other.identityToken == identityToken) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.authorizationCode, authorizationCode) ||
                other.authorizationCode == authorizationCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, identityToken, nonce, authorizationCode);

  @override
  String toString() {
    return 'AppleLoginRequest(identityToken: $identityToken, nonce: $nonce, authorizationCode: $authorizationCode)';
  }
}

/// @nodoc
abstract mixin class $AppleLoginRequestCopyWith<$Res> {
  factory $AppleLoginRequestCopyWith(
          AppleLoginRequest value, $Res Function(AppleLoginRequest) _then) =
      _$AppleLoginRequestCopyWithImpl;
  @useResult
  $Res call({String identityToken, String nonce, String? authorizationCode});
}

/// @nodoc
class _$AppleLoginRequestCopyWithImpl<$Res>
    implements $AppleLoginRequestCopyWith<$Res> {
  _$AppleLoginRequestCopyWithImpl(this._self, this._then);

  final AppleLoginRequest _self;
  final $Res Function(AppleLoginRequest) _then;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identityToken = null,
    Object? nonce = null,
    Object? authorizationCode = freezed,
  }) {
    return _then(_self.copyWith(
      identityToken: null == identityToken
          ? _self.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _self.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as String,
      authorizationCode: freezed == authorizationCode
          ? _self.authorizationCode
          : authorizationCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppleLoginRequest].
extension AppleLoginRequestPatterns on AppleLoginRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AppleLoginRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppleLoginRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AppleLoginRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppleLoginRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AppleLoginRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppleLoginRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String identityToken, String nonce, String? authorizationCode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppleLoginRequest() when $default != null:
        return $default(
            _that.identityToken, _that.nonce, _that.authorizationCode);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String identityToken, String nonce, String? authorizationCode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppleLoginRequest():
        return $default(
            _that.identityToken, _that.nonce, _that.authorizationCode);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String identityToken, String nonce, String? authorizationCode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppleLoginRequest() when $default != null:
        return $default(
            _that.identityToken, _that.nonce, _that.authorizationCode);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AppleLoginRequest implements AppleLoginRequest {
  const _AppleLoginRequest(
      {required this.identityToken,
      required this.nonce,
      this.authorizationCode});
  factory _AppleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleLoginRequestFromJson(json);

  @override
  final String identityToken;
  @override
  final String nonce;
  @override
  final String? authorizationCode;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppleLoginRequestCopyWith<_AppleLoginRequest> get copyWith =>
      __$AppleLoginRequestCopyWithImpl<_AppleLoginRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppleLoginRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppleLoginRequest &&
            (identical(other.identityToken, identityToken) ||
                other.identityToken == identityToken) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.authorizationCode, authorizationCode) ||
                other.authorizationCode == authorizationCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, identityToken, nonce, authorizationCode);

  @override
  String toString() {
    return 'AppleLoginRequest(identityToken: $identityToken, nonce: $nonce, authorizationCode: $authorizationCode)';
  }
}

/// @nodoc
abstract mixin class _$AppleLoginRequestCopyWith<$Res>
    implements $AppleLoginRequestCopyWith<$Res> {
  factory _$AppleLoginRequestCopyWith(
          _AppleLoginRequest value, $Res Function(_AppleLoginRequest) _then) =
      __$AppleLoginRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String identityToken, String nonce, String? authorizationCode});
}

/// @nodoc
class __$AppleLoginRequestCopyWithImpl<$Res>
    implements _$AppleLoginRequestCopyWith<$Res> {
  __$AppleLoginRequestCopyWithImpl(this._self, this._then);

  final _AppleLoginRequest _self;
  final $Res Function(_AppleLoginRequest) _then;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? identityToken = null,
    Object? nonce = null,
    Object? authorizationCode = freezed,
  }) {
    return _then(_AppleLoginRequest(
      identityToken: null == identityToken
          ? _self.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _self.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as String,
      authorizationCode: freezed == authorizationCode
          ? _self.authorizationCode
          : authorizationCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$DevLoginRequest {
  String get nickname;
  String? get email;

  /// Create a copy of DevLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DevLoginRequestCopyWith<DevLoginRequest> get copyWith =>
      _$DevLoginRequestCopyWithImpl<DevLoginRequest>(
          this as DevLoginRequest, _$identity);

  /// Serializes this DevLoginRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DevLoginRequest &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickname, email);

  @override
  String toString() {
    return 'DevLoginRequest(nickname: $nickname, email: $email)';
  }
}

/// @nodoc
abstract mixin class $DevLoginRequestCopyWith<$Res> {
  factory $DevLoginRequestCopyWith(
          DevLoginRequest value, $Res Function(DevLoginRequest) _then) =
      _$DevLoginRequestCopyWithImpl;
  @useResult
  $Res call({String nickname, String? email});
}

/// @nodoc
class _$DevLoginRequestCopyWithImpl<$Res>
    implements $DevLoginRequestCopyWith<$Res> {
  _$DevLoginRequestCopyWithImpl(this._self, this._then);

  final DevLoginRequest _self;
  final $Res Function(DevLoginRequest) _then;

  /// Create a copy of DevLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickname = null,
    Object? email = freezed,
  }) {
    return _then(_self.copyWith(
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DevLoginRequest].
extension DevLoginRequestPatterns on DevLoginRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DevLoginRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DevLoginRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DevLoginRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DevLoginRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DevLoginRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DevLoginRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String nickname, String? email)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DevLoginRequest() when $default != null:
        return $default(_that.nickname, _that.email);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String nickname, String? email) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DevLoginRequest():
        return $default(_that.nickname, _that.email);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String nickname, String? email)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DevLoginRequest() when $default != null:
        return $default(_that.nickname, _that.email);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DevLoginRequest implements DevLoginRequest {
  const _DevLoginRequest({this.nickname = '개발자', this.email});
  factory _DevLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$DevLoginRequestFromJson(json);

  @override
  @JsonKey()
  final String nickname;
  @override
  final String? email;

  /// Create a copy of DevLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DevLoginRequestCopyWith<_DevLoginRequest> get copyWith =>
      __$DevLoginRequestCopyWithImpl<_DevLoginRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DevLoginRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DevLoginRequest &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickname, email);

  @override
  String toString() {
    return 'DevLoginRequest(nickname: $nickname, email: $email)';
  }
}

/// @nodoc
abstract mixin class _$DevLoginRequestCopyWith<$Res>
    implements $DevLoginRequestCopyWith<$Res> {
  factory _$DevLoginRequestCopyWith(
          _DevLoginRequest value, $Res Function(_DevLoginRequest) _then) =
      __$DevLoginRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String nickname, String? email});
}

/// @nodoc
class __$DevLoginRequestCopyWithImpl<$Res>
    implements _$DevLoginRequestCopyWith<$Res> {
  __$DevLoginRequestCopyWithImpl(this._self, this._then);

  final _DevLoginRequest _self;
  final $Res Function(_DevLoginRequest) _then;

  /// Create a copy of DevLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nickname = null,
    Object? email = freezed,
  }) {
    return _then(_DevLoginRequest(
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RefreshRequest {
  String get refreshToken;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RefreshRequestCopyWith<RefreshRequest> get copyWith =>
      _$RefreshRequestCopyWithImpl<RefreshRequest>(
          this as RefreshRequest, _$identity);

  /// Serializes this RefreshRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RefreshRequest &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  @override
  String toString() {
    return 'RefreshRequest(refreshToken: $refreshToken)';
  }
}

/// @nodoc
abstract mixin class $RefreshRequestCopyWith<$Res> {
  factory $RefreshRequestCopyWith(
          RefreshRequest value, $Res Function(RefreshRequest) _then) =
      _$RefreshRequestCopyWithImpl;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class _$RefreshRequestCopyWithImpl<$Res>
    implements $RefreshRequestCopyWith<$Res> {
  _$RefreshRequestCopyWithImpl(this._self, this._then);

  final RefreshRequest _self;
  final $Res Function(RefreshRequest) _then;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
  }) {
    return _then(_self.copyWith(
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [RefreshRequest].
extension RefreshRequestPatterns on RefreshRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RefreshRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RefreshRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RefreshRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RefreshRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String refreshToken)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RefreshRequest() when $default != null:
        return $default(_that.refreshToken);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String refreshToken) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshRequest():
        return $default(_that.refreshToken);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String refreshToken)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshRequest() when $default != null:
        return $default(_that.refreshToken);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RefreshRequest implements RefreshRequest {
  const _RefreshRequest({required this.refreshToken});
  factory _RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);

  @override
  final String refreshToken;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RefreshRequestCopyWith<_RefreshRequest> get copyWith =>
      __$RefreshRequestCopyWithImpl<_RefreshRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RefreshRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RefreshRequest &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  @override
  String toString() {
    return 'RefreshRequest(refreshToken: $refreshToken)';
  }
}

/// @nodoc
abstract mixin class _$RefreshRequestCopyWith<$Res>
    implements $RefreshRequestCopyWith<$Res> {
  factory _$RefreshRequestCopyWith(
          _RefreshRequest value, $Res Function(_RefreshRequest) _then) =
      __$RefreshRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$RefreshRequestCopyWithImpl<$Res>
    implements _$RefreshRequestCopyWith<$Res> {
  __$RefreshRequestCopyWithImpl(this._self, this._then);

  final _RefreshRequest _self;
  final $Res Function(_RefreshRequest) _then;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? refreshToken = null,
  }) {
    return _then(_RefreshRequest(
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$DeviceTokenRegisterRequest {
  String get token;
  String get platform;

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceTokenRegisterRequestCopyWith<DeviceTokenRegisterRequest>
      get copyWith =>
          _$DeviceTokenRegisterRequestCopyWithImpl<DeviceTokenRegisterRequest>(
              this as DeviceTokenRegisterRequest, _$identity);

  /// Serializes this DeviceTokenRegisterRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeviceTokenRegisterRequest &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, platform);

  @override
  String toString() {
    return 'DeviceTokenRegisterRequest(token: $token, platform: $platform)';
  }
}

/// @nodoc
abstract mixin class $DeviceTokenRegisterRequestCopyWith<$Res> {
  factory $DeviceTokenRegisterRequestCopyWith(DeviceTokenRegisterRequest value,
          $Res Function(DeviceTokenRegisterRequest) _then) =
      _$DeviceTokenRegisterRequestCopyWithImpl;
  @useResult
  $Res call({String token, String platform});
}

/// @nodoc
class _$DeviceTokenRegisterRequestCopyWithImpl<$Res>
    implements $DeviceTokenRegisterRequestCopyWith<$Res> {
  _$DeviceTokenRegisterRequestCopyWithImpl(this._self, this._then);

  final DeviceTokenRegisterRequest _self;
  final $Res Function(DeviceTokenRegisterRequest) _then;

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? platform = null,
  }) {
    return _then(_self.copyWith(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [DeviceTokenRegisterRequest].
extension DeviceTokenRegisterRequestPatterns on DeviceTokenRegisterRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DeviceTokenRegisterRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DeviceTokenRegisterRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DeviceTokenRegisterRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeviceTokenRegisterRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DeviceTokenRegisterRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeviceTokenRegisterRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String token, String platform)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DeviceTokenRegisterRequest() when $default != null:
        return $default(_that.token, _that.platform);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String token, String platform) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeviceTokenRegisterRequest():
        return $default(_that.token, _that.platform);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String token, String platform)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeviceTokenRegisterRequest() when $default != null:
        return $default(_that.token, _that.platform);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DeviceTokenRegisterRequest implements DeviceTokenRegisterRequest {
  const _DeviceTokenRegisterRequest(
      {required this.token, required this.platform});
  factory _DeviceTokenRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenRegisterRequestFromJson(json);

  @override
  final String token;
  @override
  final String platform;

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeviceTokenRegisterRequestCopyWith<_DeviceTokenRegisterRequest>
      get copyWith => __$DeviceTokenRegisterRequestCopyWithImpl<
          _DeviceTokenRegisterRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeviceTokenRegisterRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeviceTokenRegisterRequest &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, platform);

  @override
  String toString() {
    return 'DeviceTokenRegisterRequest(token: $token, platform: $platform)';
  }
}

/// @nodoc
abstract mixin class _$DeviceTokenRegisterRequestCopyWith<$Res>
    implements $DeviceTokenRegisterRequestCopyWith<$Res> {
  factory _$DeviceTokenRegisterRequestCopyWith(
          _DeviceTokenRegisterRequest value,
          $Res Function(_DeviceTokenRegisterRequest) _then) =
      __$DeviceTokenRegisterRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String token, String platform});
}

/// @nodoc
class __$DeviceTokenRegisterRequestCopyWithImpl<$Res>
    implements _$DeviceTokenRegisterRequestCopyWith<$Res> {
  __$DeviceTokenRegisterRequestCopyWithImpl(this._self, this._then);

  final _DeviceTokenRegisterRequest _self;
  final $Res Function(_DeviceTokenRegisterRequest) _then;

  /// Create a copy of DeviceTokenRegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = null,
    Object? platform = null,
  }) {
    return _then(_DeviceTokenRegisterRequest(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AuthUserDto {
  String get id;
  String get nickname;
  String get provider;
  DateTime get createdAt;
  String? get profileImageUrl;
  String?
      get email; // BC-87: not yet sent by `UserPublic` (backend BC-81, parallel work) —
// defaults to false so today's `/me` payload still parses cleanly. Once
// BC-81 adds `is_admin`, `field_rename: snake` picks it up automatically.
  bool
      get isAdmin; // Profile expressiveness (backend BC-81, mobile UI BC-84) — mirrors
// `UserPublic.cover_image_url` / `.theme` / `.featured_book_id` /
// `.featured_quote`. Raw wire values; see `AuthUser` for why `theme`
// stays a `String?` here instead of the `ProfileTheme` enum.
  String? get coverImageUrl;
  String? get theme;
  String? get featuredBookId;
  String? get featuredQuote;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUserDtoCopyWith<AuthUserDto> get copyWith =>
      _$AuthUserDtoCopyWithImpl<AuthUserDto>(this as AuthUserDto, _$identity);

  /// Serializes this AuthUserDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.featuredBookId, featuredBookId) ||
                other.featuredBookId == featuredBookId) &&
            (identical(other.featuredQuote, featuredQuote) ||
                other.featuredQuote == featuredQuote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nickname,
      provider,
      createdAt,
      profileImageUrl,
      email,
      isAdmin,
      coverImageUrl,
      theme,
      featuredBookId,
      featuredQuote);

  @override
  String toString() {
    return 'AuthUserDto(id: $id, nickname: $nickname, provider: $provider, createdAt: $createdAt, profileImageUrl: $profileImageUrl, email: $email, isAdmin: $isAdmin, coverImageUrl: $coverImageUrl, theme: $theme, featuredBookId: $featuredBookId, featuredQuote: $featuredQuote)';
  }
}

/// @nodoc
abstract mixin class $AuthUserDtoCopyWith<$Res> {
  factory $AuthUserDtoCopyWith(
          AuthUserDto value, $Res Function(AuthUserDto) _then) =
      _$AuthUserDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String provider,
      DateTime createdAt,
      String? profileImageUrl,
      String? email,
      bool isAdmin,
      String? coverImageUrl,
      String? theme,
      String? featuredBookId,
      String? featuredQuote});
}

/// @nodoc
class _$AuthUserDtoCopyWithImpl<$Res> implements $AuthUserDtoCopyWith<$Res> {
  _$AuthUserDtoCopyWithImpl(this._self, this._then);

  final AuthUserDto _self;
  final $Res Function(AuthUserDto) _then;

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
    Object? isAdmin = null,
    Object? coverImageUrl = freezed,
    Object? theme = freezed,
    Object? featuredBookId = freezed,
    Object? featuredQuote = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      coverImageUrl: freezed == coverImageUrl
          ? _self.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: freezed == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredBookId: freezed == featuredBookId
          ? _self.featuredBookId
          : featuredBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredQuote: freezed == featuredQuote
          ? _self.featuredQuote
          : featuredQuote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthUserDto].
extension AuthUserDtoPatterns on AuthUserDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthUserDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUserDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthUserDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUserDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthUserDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUserDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String nickname,
            String provider,
            DateTime createdAt,
            String? profileImageUrl,
            String? email,
            bool isAdmin,
            String? coverImageUrl,
            String? theme,
            String? featuredBookId,
            String? featuredQuote)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUserDto() when $default != null:
        return $default(
            _that.id,
            _that.nickname,
            _that.provider,
            _that.createdAt,
            _that.profileImageUrl,
            _that.email,
            _that.isAdmin,
            _that.coverImageUrl,
            _that.theme,
            _that.featuredBookId,
            _that.featuredQuote);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String nickname,
            String provider,
            DateTime createdAt,
            String? profileImageUrl,
            String? email,
            bool isAdmin,
            String? coverImageUrl,
            String? theme,
            String? featuredBookId,
            String? featuredQuote)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUserDto():
        return $default(
            _that.id,
            _that.nickname,
            _that.provider,
            _that.createdAt,
            _that.profileImageUrl,
            _that.email,
            _that.isAdmin,
            _that.coverImageUrl,
            _that.theme,
            _that.featuredBookId,
            _that.featuredQuote);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String nickname,
            String provider,
            DateTime createdAt,
            String? profileImageUrl,
            String? email,
            bool isAdmin,
            String? coverImageUrl,
            String? theme,
            String? featuredBookId,
            String? featuredQuote)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUserDto() when $default != null:
        return $default(
            _that.id,
            _that.nickname,
            _that.provider,
            _that.createdAt,
            _that.profileImageUrl,
            _that.email,
            _that.isAdmin,
            _that.coverImageUrl,
            _that.theme,
            _that.featuredBookId,
            _that.featuredQuote);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthUserDto extends AuthUserDto {
  const _AuthUserDto(
      {required this.id,
      required this.nickname,
      required this.provider,
      required this.createdAt,
      this.profileImageUrl,
      this.email,
      this.isAdmin = false,
      this.coverImageUrl,
      this.theme,
      this.featuredBookId,
      this.featuredQuote})
      : super._();
  factory _AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);

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
// BC-87: not yet sent by `UserPublic` (backend BC-81, parallel work) —
// defaults to false so today's `/me` payload still parses cleanly. Once
// BC-81 adds `is_admin`, `field_rename: snake` picks it up automatically.
  @override
  @JsonKey()
  final bool isAdmin;
// Profile expressiveness (backend BC-81, mobile UI BC-84) — mirrors
// `UserPublic.cover_image_url` / `.theme` / `.featured_book_id` /
// `.featured_quote`. Raw wire values; see `AuthUser` for why `theme`
// stays a `String?` here instead of the `ProfileTheme` enum.
  @override
  final String? coverImageUrl;
  @override
  final String? theme;
  @override
  final String? featuredBookId;
  @override
  final String? featuredQuote;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthUserDtoCopyWith<_AuthUserDto> get copyWith =>
      __$AuthUserDtoCopyWithImpl<_AuthUserDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthUserDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthUserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.featuredBookId, featuredBookId) ||
                other.featuredBookId == featuredBookId) &&
            (identical(other.featuredQuote, featuredQuote) ||
                other.featuredQuote == featuredQuote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nickname,
      provider,
      createdAt,
      profileImageUrl,
      email,
      isAdmin,
      coverImageUrl,
      theme,
      featuredBookId,
      featuredQuote);

  @override
  String toString() {
    return 'AuthUserDto(id: $id, nickname: $nickname, provider: $provider, createdAt: $createdAt, profileImageUrl: $profileImageUrl, email: $email, isAdmin: $isAdmin, coverImageUrl: $coverImageUrl, theme: $theme, featuredBookId: $featuredBookId, featuredQuote: $featuredQuote)';
  }
}

/// @nodoc
abstract mixin class _$AuthUserDtoCopyWith<$Res>
    implements $AuthUserDtoCopyWith<$Res> {
  factory _$AuthUserDtoCopyWith(
          _AuthUserDto value, $Res Function(_AuthUserDto) _then) =
      __$AuthUserDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String provider,
      DateTime createdAt,
      String? profileImageUrl,
      String? email,
      bool isAdmin,
      String? coverImageUrl,
      String? theme,
      String? featuredBookId,
      String? featuredQuote});
}

/// @nodoc
class __$AuthUserDtoCopyWithImpl<$Res> implements _$AuthUserDtoCopyWith<$Res> {
  __$AuthUserDtoCopyWithImpl(this._self, this._then);

  final _AuthUserDto _self;
  final $Res Function(_AuthUserDto) _then;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? provider = null,
    Object? createdAt = null,
    Object? profileImageUrl = freezed,
    Object? email = freezed,
    Object? isAdmin = null,
    Object? coverImageUrl = freezed,
    Object? theme = freezed,
    Object? featuredBookId = freezed,
    Object? featuredQuote = freezed,
  }) {
    return _then(_AuthUserDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      coverImageUrl: freezed == coverImageUrl
          ? _self.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: freezed == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredBookId: freezed == featuredBookId
          ? _self.featuredBookId
          : featuredBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredQuote: freezed == featuredQuote
          ? _self.featuredQuote
          : featuredQuote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$LoginResponse {
  String get accessToken;
  String get refreshToken;
  String get tokenType;
  int get expiresIn;
  AuthUserDto get user;
  bool get isNewUser;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      _$LoginResponseCopyWithImpl<LoginResponse>(
          this as LoginResponse, _$identity);

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginResponse &&
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

  @override
  String toString() {
    return 'LoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, user: $user, isNewUser: $isNewUser)';
  }
}

/// @nodoc
abstract mixin class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) _then) =
      _$LoginResponseCopyWithImpl;
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
class _$LoginResponseCopyWithImpl<$Res>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._self, this._then);

  final LoginResponse _self;
  final $Res Function(LoginResponse) _then;

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
    return _then(_self.copyWith(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _self.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUserDto,
      isNewUser: null == isNewUser
          ? _self.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserDtoCopyWith<$Res> get user {
    return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [LoginResponse].
extension LoginResponsePatterns on LoginResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String accessToken, String refreshToken, String tokenType,
            int expiresIn, AuthUserDto user, bool isNewUser)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(_that.accessToken, _that.refreshToken, _that.tokenType,
            _that.expiresIn, _that.user, _that.isNewUser);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String accessToken, String refreshToken, String tokenType,
            int expiresIn, AuthUserDto user, bool isNewUser)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse():
        return $default(_that.accessToken, _that.refreshToken, _that.tokenType,
            _that.expiresIn, _that.user, _that.isNewUser);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String accessToken, String refreshToken, String tokenType,
            int expiresIn, AuthUserDto user, bool isNewUser)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(_that.accessToken, _that.refreshToken, _that.tokenType,
            _that.expiresIn, _that.user, _that.isNewUser);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LoginResponse implements LoginResponse {
  const _LoginResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
      required this.expiresIn,
      required this.user,
      required this.isNewUser});
  factory _LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

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

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginResponseCopyWith<_LoginResponse> get copyWith =>
      __$LoginResponseCopyWithImpl<_LoginResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoginResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginResponse &&
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

  @override
  String toString() {
    return 'LoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, user: $user, isNewUser: $isNewUser)';
  }
}

/// @nodoc
abstract mixin class _$LoginResponseCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$LoginResponseCopyWith(
          _LoginResponse value, $Res Function(_LoginResponse) _then) =
      __$LoginResponseCopyWithImpl;
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
class __$LoginResponseCopyWithImpl<$Res>
    implements _$LoginResponseCopyWith<$Res> {
  __$LoginResponseCopyWithImpl(this._self, this._then);

  final _LoginResponse _self;
  final $Res Function(_LoginResponse) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? user = null,
    Object? isNewUser = null,
  }) {
    return _then(_LoginResponse(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _self.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUserDto,
      isNewUser: null == isNewUser
          ? _self.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserDtoCopyWith<$Res> get user {
    return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
mixin _$RefreshResponse {
  String get accessToken;
  String get refreshToken;
  String get tokenType;
  int get expiresIn;

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RefreshResponseCopyWith<RefreshResponse> get copyWith =>
      _$RefreshResponseCopyWithImpl<RefreshResponse>(
          this as RefreshResponse, _$identity);

  /// Serializes this RefreshResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RefreshResponse &&
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

  @override
  String toString() {
    return 'RefreshResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class $RefreshResponseCopyWith<$Res> {
  factory $RefreshResponseCopyWith(
          RefreshResponse value, $Res Function(RefreshResponse) _then) =
      _$RefreshResponseCopyWithImpl;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn});
}

/// @nodoc
class _$RefreshResponseCopyWithImpl<$Res>
    implements $RefreshResponseCopyWith<$Res> {
  _$RefreshResponseCopyWithImpl(this._self, this._then);

  final RefreshResponse _self;
  final $Res Function(RefreshResponse) _then;

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
    return _then(_self.copyWith(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _self.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [RefreshResponse].
extension RefreshResponsePatterns on RefreshResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RefreshResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RefreshResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RefreshResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String accessToken, String refreshToken, String tokenType,
            int expiresIn)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(_that.accessToken, _that.refreshToken, _that.tokenType,
            _that.expiresIn);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String accessToken, String refreshToken, String tokenType,
            int expiresIn)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse():
        return $default(_that.accessToken, _that.refreshToken, _that.tokenType,
            _that.expiresIn);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String accessToken, String refreshToken, String tokenType,
            int expiresIn)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(_that.accessToken, _that.refreshToken, _that.tokenType,
            _that.expiresIn);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RefreshResponse implements RefreshResponse {
  const _RefreshResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
      required this.expiresIn});
  factory _RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final String tokenType;
  @override
  final int expiresIn;

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RefreshResponseCopyWith<_RefreshResponse> get copyWith =>
      __$RefreshResponseCopyWithImpl<_RefreshResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RefreshResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RefreshResponse &&
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

  @override
  String toString() {
    return 'RefreshResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class _$RefreshResponseCopyWith<$Res>
    implements $RefreshResponseCopyWith<$Res> {
  factory _$RefreshResponseCopyWith(
          _RefreshResponse value, $Res Function(_RefreshResponse) _then) =
      __$RefreshResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn});
}

/// @nodoc
class __$RefreshResponseCopyWithImpl<$Res>
    implements _$RefreshResponseCopyWith<$Res> {
  __$RefreshResponseCopyWithImpl(this._self, this._then);

  final _RefreshResponse _self;
  final $Res Function(_RefreshResponse) _then;

  /// Create a copy of RefreshResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
  }) {
    return _then(_RefreshResponse(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _self.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
