// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heatmap_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeatmapState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HeatmapState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HeatmapState()';
  }
}

/// @nodoc
class $HeatmapStateCopyWith<$Res> {
  $HeatmapStateCopyWith(HeatmapState _, $Res Function(HeatmapState) __);
}

/// Adds pattern-matching-related methods to [HeatmapState].
extension HeatmapStatePatterns on HeatmapState {
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
    TResult Function(HeatmapInitial value)? initial,
    TResult Function(HeatmapLoading value)? loading,
    TResult Function(HeatmapLoaded value)? loaded,
    TResult Function(HeatmapError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HeatmapInitial() when initial != null:
        return initial(_that);
      case HeatmapLoading() when loading != null:
        return loading(_that);
      case HeatmapLoaded() when loaded != null:
        return loaded(_that);
      case HeatmapError() when error != null:
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
    required TResult Function(HeatmapInitial value) initial,
    required TResult Function(HeatmapLoading value) loading,
    required TResult Function(HeatmapLoaded value) loaded,
    required TResult Function(HeatmapError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case HeatmapInitial():
        return initial(_that);
      case HeatmapLoading():
        return loading(_that);
      case HeatmapLoaded():
        return loaded(_that);
      case HeatmapError():
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
    TResult? Function(HeatmapInitial value)? initial,
    TResult? Function(HeatmapLoading value)? loading,
    TResult? Function(HeatmapLoaded value)? loaded,
    TResult? Function(HeatmapError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HeatmapInitial() when initial != null:
        return initial(_that);
      case HeatmapLoading() when loading != null:
        return loading(_that);
      case HeatmapLoaded() when loaded != null:
        return loaded(_that);
      case HeatmapError() when error != null:
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
    TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HeatmapInitial() when initial != null:
        return initial();
      case HeatmapLoading() when loading != null:
        return loading();
      case HeatmapLoaded() when loaded != null:
        return loaded(_that.days, _that.from, _that.to);
      case HeatmapError() when error != null:
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
    required TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case HeatmapInitial():
        return initial();
      case HeatmapLoading():
        return loading();
      case HeatmapLoaded():
        return loaded(_that.days, _that.from, _that.to);
      case HeatmapError():
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
    TResult? Function(List<HeatmapDay> days, DateTime from, DateTime to)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HeatmapInitial() when initial != null:
        return initial();
      case HeatmapLoading() when loading != null:
        return loading();
      case HeatmapLoaded() when loaded != null:
        return loaded(_that.days, _that.from, _that.to);
      case HeatmapError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class HeatmapInitial implements HeatmapState {
  const HeatmapInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HeatmapInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HeatmapState.initial()';
  }
}

/// @nodoc

class HeatmapLoading implements HeatmapState {
  const HeatmapLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HeatmapLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HeatmapState.loading()';
  }
}

/// @nodoc

class HeatmapLoaded implements HeatmapState {
  const HeatmapLoaded(
      {required final List<HeatmapDay> days,
      required this.from,
      required this.to})
      : _days = days;

  final List<HeatmapDay> _days;
  List<HeatmapDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  final DateTime from;
  final DateTime to;

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeatmapLoadedCopyWith<HeatmapLoaded> get copyWith =>
      _$HeatmapLoadedCopyWithImpl<HeatmapLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeatmapLoaded &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_days), from, to);

  @override
  String toString() {
    return 'HeatmapState.loaded(days: $days, from: $from, to: $to)';
  }
}

/// @nodoc
abstract mixin class $HeatmapLoadedCopyWith<$Res>
    implements $HeatmapStateCopyWith<$Res> {
  factory $HeatmapLoadedCopyWith(
          HeatmapLoaded value, $Res Function(HeatmapLoaded) _then) =
      _$HeatmapLoadedCopyWithImpl;
  @useResult
  $Res call({List<HeatmapDay> days, DateTime from, DateTime to});
}

/// @nodoc
class _$HeatmapLoadedCopyWithImpl<$Res>
    implements $HeatmapLoadedCopyWith<$Res> {
  _$HeatmapLoadedCopyWithImpl(this._self, this._then);

  final HeatmapLoaded _self;
  final $Res Function(HeatmapLoaded) _then;

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? days = null,
    Object? from = null,
    Object? to = null,
  }) {
    return _then(HeatmapLoaded(
      days: null == days
          ? _self._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<HeatmapDay>,
      from: null == from
          ? _self.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: null == to
          ? _self.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class HeatmapError implements HeatmapState {
  const HeatmapError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeatmapErrorCopyWith<HeatmapError> get copyWith =>
      _$HeatmapErrorCopyWithImpl<HeatmapError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeatmapError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'HeatmapState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $HeatmapErrorCopyWith<$Res>
    implements $HeatmapStateCopyWith<$Res> {
  factory $HeatmapErrorCopyWith(
          HeatmapError value, $Res Function(HeatmapError) _then) =
      _$HeatmapErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$HeatmapErrorCopyWithImpl<$Res> implements $HeatmapErrorCopyWith<$Res> {
  _$HeatmapErrorCopyWithImpl(this._self, this._then);

  final HeatmapError _self;
  final $Res Function(HeatmapError) _then;

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(HeatmapError(
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
