// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState()';
  }
}

/// @nodoc
class $AuthStateCopyWith<$Res> {
  $AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}

/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Authenticating value)? authenticating,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(AuthFailure value)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial(_that);
      case Unauthenticated() when unauthenticated != null:
        return unauthenticated(_that);
      case Authenticating() when authenticating != null:
        return authenticating(_that);
      case Authenticated() when authenticated != null:
        return authenticated(_that);
      case AuthFailure() when failure != null:
        return failure(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(Authenticating value) authenticating,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(AuthFailure value) failure,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial():
        return initial(_that);
      case Unauthenticated():
        return unauthenticated(_that);
      case Authenticating():
        return authenticating(_that);
      case Authenticated():
        return authenticated(_that);
      case AuthFailure():
        return failure(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(Authenticating value)? authenticating,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(AuthFailure value)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial(_that);
      case Unauthenticated() when unauthenticated != null:
        return unauthenticated(_that);
      case Authenticating() when authenticating != null:
        return authenticating(_that);
      case Authenticated() when authenticated != null:
        return authenticated(_that);
      case AuthFailure() when failure != null:
        return failure(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? authenticating,
    TResult Function(AuthUser user)? authenticated,
    TResult Function(String code, String message)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial();
      case Unauthenticated() when unauthenticated != null:
        return unauthenticated();
      case Authenticating() when authenticating != null:
        return authenticating();
      case Authenticated() when authenticated != null:
        return authenticated(_that.user);
      case AuthFailure() when failure != null:
        return failure(_that.code, _that.message);
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
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() authenticating,
    required TResult Function(AuthUser user) authenticated,
    required TResult Function(String code, String message) failure,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial():
        return initial();
      case Unauthenticated():
        return unauthenticated();
      case Authenticating():
        return authenticating();
      case Authenticated():
        return authenticated(_that.user);
      case AuthFailure():
        return failure(_that.code, _that.message);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? authenticating,
    TResult? Function(AuthUser user)? authenticated,
    TResult? Function(String code, String message)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial();
      case Unauthenticated() when unauthenticated != null:
        return unauthenticated();
      case Authenticating() when authenticating != null:
        return authenticating();
      case Authenticated() when authenticated != null:
        return authenticated(_that.user);
      case AuthFailure() when failure != null:
        return failure(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthInitial implements AuthState {
  const AuthInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.initial()';
  }
}

/// @nodoc

class Unauthenticated implements AuthState {
  const Unauthenticated();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Unauthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }
}

/// @nodoc

class Authenticating implements AuthState {
  const Authenticating();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Authenticating);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.authenticating()';
  }
}

/// @nodoc

class Authenticated implements AuthState {
  const Authenticated(this.user);

  final AuthUser user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthenticatedCopyWith<Authenticated> get copyWith =>
      _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Authenticated &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user)';
  }
}

/// @nodoc
abstract mixin class $AuthenticatedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedCopyWith(
          Authenticated value, $Res Function(Authenticated) _then) =
      _$AuthenticatedCopyWithImpl;
  @useResult
  $Res call({AuthUser user});

  $AuthUserCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(this._self, this._then);

  final Authenticated _self;
  final $Res Function(Authenticated) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
  }) {
    return _then(Authenticated(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUser,
    ));
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<$Res> get user {
    return $AuthUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc

class AuthFailure implements AuthState {
  const AuthFailure({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthFailureCopyWith<AuthFailure> get copyWith =>
      _$AuthFailureCopyWithImpl<AuthFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthFailure &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'AuthState.failure(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $AuthFailureCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory $AuthFailureCopyWith(
          AuthFailure value, $Res Function(AuthFailure) _then) =
      _$AuthFailureCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$AuthFailureCopyWithImpl<$Res> implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._self, this._then);

  final AuthFailure _self;
  final $Res Function(AuthFailure) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(AuthFailure(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
