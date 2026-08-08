// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthUser {
  String get id;
  String get nickname;
  AuthProvider get provider;
  DateTime get createdAt;
  String? get profileImageUrl;
  String?
      get email; // BC-87: gates the admin console entry point / route. Defaults to false
// so call sites that predate this field (tests, other builders) still
// compile without passing it explicitly.
  bool
      get isAdmin; // Profile expressiveness (backend BC-81, mobile UI BC-84). Raw wire
// values — see the matching comment on `UserProfile`
// (features/social/domain/user_summary.dart) for why `theme` isn't the
// `ProfileTheme` enum here. Populated from `/me` (`UserPublic`) and used
// to build the own-profile header when `FeatureFlags.community` is off
// (community_providers.dart's degrade branch).
  String? get coverImageUrl;
  String? get theme;
  String? get featuredBookId;
  String? get featuredQuote;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<AuthUser> get copyWith =>
      _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUser &&
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
    return 'AuthUser(id: $id, nickname: $nickname, provider: $provider, createdAt: $createdAt, profileImageUrl: $profileImageUrl, email: $email, isAdmin: $isAdmin, coverImageUrl: $coverImageUrl, theme: $theme, featuredBookId: $featuredBookId, featuredQuote: $featuredQuote)';
  }
}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) =
      _$AuthUserCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nickname,
      AuthProvider provider,
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
class _$AuthUserCopyWithImpl<$Res> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

  /// Create a copy of AuthUser
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
              as AuthProvider,
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

/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
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
    TResult Function(_AuthUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
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
    TResult Function(_AuthUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser():
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
    TResult? Function(_AuthUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
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
            AuthProvider provider,
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
      case _AuthUser() when $default != null:
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
            AuthProvider provider,
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
      case _AuthUser():
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
            AuthProvider provider,
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
      case _AuthUser() when $default != null:
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

class _AuthUser implements AuthUser {
  const _AuthUser(
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
      this.featuredQuote});

  @override
  final String id;
  @override
  final String nickname;
  @override
  final AuthProvider provider;
  @override
  final DateTime createdAt;
  @override
  final String? profileImageUrl;
  @override
  final String? email;
// BC-87: gates the admin console entry point / route. Defaults to false
// so call sites that predate this field (tests, other builders) still
// compile without passing it explicitly.
  @override
  @JsonKey()
  final bool isAdmin;
// Profile expressiveness (backend BC-81, mobile UI BC-84). Raw wire
// values — see the matching comment on `UserProfile`
// (features/social/domain/user_summary.dart) for why `theme` isn't the
// `ProfileTheme` enum here. Populated from `/me` (`UserPublic`) and used
// to build the own-profile header when `FeatureFlags.community` is off
// (community_providers.dart's degrade branch).
  @override
  final String? coverImageUrl;
  @override
  final String? theme;
  @override
  final String? featuredBookId;
  @override
  final String? featuredQuote;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthUserCopyWith<_AuthUser> get copyWith =>
      __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthUser &&
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
    return 'AuthUser(id: $id, nickname: $nickname, provider: $provider, createdAt: $createdAt, profileImageUrl: $profileImageUrl, email: $email, isAdmin: $isAdmin, coverImageUrl: $coverImageUrl, theme: $theme, featuredBookId: $featuredBookId, featuredQuote: $featuredQuote)';
  }
}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) =
      __$AuthUserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      AuthProvider provider,
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
class __$AuthUserCopyWithImpl<$Res> implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

  /// Create a copy of AuthUser
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
    return _then(_AuthUser(
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
              as AuthProvider,
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

// dart format on
