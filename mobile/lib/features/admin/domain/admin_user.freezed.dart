// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUser {
  String get id;
  String get nickname;
  String? get email;
  bool get isActive;
  bool get isAdmin;
  bool get isPro;
  DateTime get createdAt;

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminUserCopyWith<AdminUser> get copyWith =>
      _$AdminUserCopyWithImpl<AdminUser>(this as AdminUser, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.isPro, isPro) || other.isPro == isPro) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, nickname, email, isActive, isAdmin, isPro, createdAt);

  @override
  String toString() {
    return 'AdminUser(id: $id, nickname: $nickname, email: $email, isActive: $isActive, isAdmin: $isAdmin, isPro: $isPro, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AdminUserCopyWith<$Res> {
  factory $AdminUserCopyWith(AdminUser value, $Res Function(AdminUser) _then) =
      _$AdminUserCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? email,
      bool isActive,
      bool isAdmin,
      bool isPro,
      DateTime createdAt});
}

/// @nodoc
class _$AdminUserCopyWithImpl<$Res> implements $AdminUserCopyWith<$Res> {
  _$AdminUserCopyWithImpl(this._self, this._then);

  final AdminUser _self;
  final $Res Function(AdminUser) _then;

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? email = freezed,
    Object? isActive = null,
    Object? isAdmin = null,
    Object? isPro = null,
    Object? createdAt = null,
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
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isPro: null == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminUser].
extension AdminUserPatterns on AdminUser {
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
    TResult Function(_AdminUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminUser() when $default != null:
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
    TResult Function(_AdminUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUser():
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
    TResult? Function(_AdminUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUser() when $default != null:
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
    TResult Function(String id, String nickname, String? email, bool isActive,
            bool isAdmin, bool isPro, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminUser() when $default != null:
        return $default(_that.id, _that.nickname, _that.email, _that.isActive,
            _that.isAdmin, _that.isPro, _that.createdAt);
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
    TResult Function(String id, String nickname, String? email, bool isActive,
            bool isAdmin, bool isPro, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUser():
        return $default(_that.id, _that.nickname, _that.email, _that.isActive,
            _that.isAdmin, _that.isPro, _that.createdAt);
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
    TResult? Function(String id, String nickname, String? email, bool isActive,
            bool isAdmin, bool isPro, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUser() when $default != null:
        return $default(_that.id, _that.nickname, _that.email, _that.isActive,
            _that.isAdmin, _that.isPro, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AdminUser implements AdminUser {
  const _AdminUser(
      {required this.id,
      required this.nickname,
      this.email,
      required this.isActive,
      required this.isAdmin,
      required this.isPro,
      required this.createdAt});

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? email;
  @override
  final bool isActive;
  @override
  final bool isAdmin;
  @override
  final bool isPro;
  @override
  final DateTime createdAt;

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminUserCopyWith<_AdminUser> get copyWith =>
      __$AdminUserCopyWithImpl<_AdminUser>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.isPro, isPro) || other.isPro == isPro) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, nickname, email, isActive, isAdmin, isPro, createdAt);

  @override
  String toString() {
    return 'AdminUser(id: $id, nickname: $nickname, email: $email, isActive: $isActive, isAdmin: $isAdmin, isPro: $isPro, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AdminUserCopyWith<$Res>
    implements $AdminUserCopyWith<$Res> {
  factory _$AdminUserCopyWith(
          _AdminUser value, $Res Function(_AdminUser) _then) =
      __$AdminUserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? email,
      bool isActive,
      bool isAdmin,
      bool isPro,
      DateTime createdAt});
}

/// @nodoc
class __$AdminUserCopyWithImpl<$Res> implements _$AdminUserCopyWith<$Res> {
  __$AdminUserCopyWithImpl(this._self, this._then);

  final _AdminUser _self;
  final $Res Function(_AdminUser) _then;

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? email = freezed,
    Object? isActive = null,
    Object? isAdmin = null,
    Object? isPro = null,
    Object? createdAt = null,
  }) {
    return _then(_AdminUser(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isPro: null == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
