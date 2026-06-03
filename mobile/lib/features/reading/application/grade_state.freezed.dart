// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GradeState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GradeState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GradeState()';
  }
}

/// @nodoc
class $GradeStateCopyWith<$Res> {
  $GradeStateCopyWith(GradeState _, $Res Function(GradeState) __);
}

/// Adds pattern-matching-related methods to [GradeState].
extension GradeStatePatterns on GradeState {
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
    TResult Function(GradeInitial value)? initial,
    TResult Function(GradeLoading value)? loading,
    TResult Function(GradeLoaded value)? loaded,
    TResult Function(GradeError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GradeInitial() when initial != null:
        return initial(_that);
      case GradeLoading() when loading != null:
        return loading(_that);
      case GradeLoaded() when loaded != null:
        return loaded(_that);
      case GradeError() when error != null:
        return error(_that);
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
    required TResult Function(GradeInitial value) initial,
    required TResult Function(GradeLoading value) loading,
    required TResult Function(GradeLoaded value) loaded,
    required TResult Function(GradeError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case GradeInitial():
        return initial(_that);
      case GradeLoading():
        return loading(_that);
      case GradeLoaded():
        return loaded(_that);
      case GradeError():
        return error(_that);
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
    TResult? Function(GradeInitial value)? initial,
    TResult? Function(GradeLoading value)? loading,
    TResult? Function(GradeLoaded value)? loaded,
    TResult? Function(GradeError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case GradeInitial() when initial != null:
        return initial(_that);
      case GradeLoading() when loading != null:
        return loading(_that);
      case GradeLoaded() when loaded != null:
        return loaded(_that);
      case GradeError() when error != null:
        return error(_that);
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
    TResult Function()? loading,
    TResult Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GradeInitial() when initial != null:
        return initial();
      case GradeLoading() when loading != null:
        return loading();
      case GradeLoaded() when loaded != null:
        return loaded(_that.summary, _that.recentGradeUp);
      case GradeError() when error != null:
        return error(_that.code, _that.message);
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
    required TResult Function() loading,
    required TResult Function(GradeSummary summary, bool recentGradeUp) loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case GradeInitial():
        return initial();
      case GradeLoading():
        return loading();
      case GradeLoaded():
        return loaded(_that.summary, _that.recentGradeUp);
      case GradeError():
        return error(_that.code, _that.message);
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
    TResult? Function()? loading,
    TResult? Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case GradeInitial() when initial != null:
        return initial();
      case GradeLoading() when loading != null:
        return loading();
      case GradeLoaded() when loaded != null:
        return loaded(_that.summary, _that.recentGradeUp);
      case GradeError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class GradeInitial implements GradeState {
  const GradeInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GradeInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GradeState.initial()';
  }
}

/// @nodoc

class GradeLoading implements GradeState {
  const GradeLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GradeLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GradeState.loading()';
  }
}

/// @nodoc

class GradeLoaded implements GradeState {
  const GradeLoaded({required this.summary, this.recentGradeUp = false});

  final GradeSummary summary;
  @JsonKey()
  final bool recentGradeUp;

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GradeLoadedCopyWith<GradeLoaded> get copyWith =>
      _$GradeLoadedCopyWithImpl<GradeLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GradeLoaded &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.recentGradeUp, recentGradeUp) ||
                other.recentGradeUp == recentGradeUp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, summary, recentGradeUp);

  @override
  String toString() {
    return 'GradeState.loaded(summary: $summary, recentGradeUp: $recentGradeUp)';
  }
}

/// @nodoc
abstract mixin class $GradeLoadedCopyWith<$Res>
    implements $GradeStateCopyWith<$Res> {
  factory $GradeLoadedCopyWith(
          GradeLoaded value, $Res Function(GradeLoaded) _then) =
      _$GradeLoadedCopyWithImpl;
  @useResult
  $Res call({GradeSummary summary, bool recentGradeUp});

  $GradeSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$GradeLoadedCopyWithImpl<$Res> implements $GradeLoadedCopyWith<$Res> {
  _$GradeLoadedCopyWithImpl(this._self, this._then);

  final GradeLoaded _self;
  final $Res Function(GradeLoaded) _then;

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? summary = null,
    Object? recentGradeUp = null,
  }) {
    return _then(GradeLoaded(
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as GradeSummary,
      recentGradeUp: null == recentGradeUp
          ? _self.recentGradeUp
          : recentGradeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeSummaryCopyWith<$Res> get summary {
    return $GradeSummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc

class GradeError implements GradeState {
  const GradeError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GradeErrorCopyWith<GradeError> get copyWith =>
      _$GradeErrorCopyWithImpl<GradeError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GradeError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'GradeState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $GradeErrorCopyWith<$Res>
    implements $GradeStateCopyWith<$Res> {
  factory $GradeErrorCopyWith(
          GradeError value, $Res Function(GradeError) _then) =
      _$GradeErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$GradeErrorCopyWithImpl<$Res> implements $GradeErrorCopyWith<$Res> {
  _$GradeErrorCopyWithImpl(this._self, this._then);

  final GradeError _self;
  final $Res Function(GradeError) _then;

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(GradeError(
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
