// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heatmap_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeatmapDay {
  DateTime get date;
  int get totalSeconds;
  int get sessionCount;

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeatmapDayCopyWith<HeatmapDay> get copyWith =>
      _$HeatmapDayCopyWithImpl<HeatmapDay>(this as HeatmapDay, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeatmapDay &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, totalSeconds, sessionCount);

  @override
  String toString() {
    return 'HeatmapDay(date: $date, totalSeconds: $totalSeconds, sessionCount: $sessionCount)';
  }
}

/// @nodoc
abstract mixin class $HeatmapDayCopyWith<$Res> {
  factory $HeatmapDayCopyWith(
          HeatmapDay value, $Res Function(HeatmapDay) _then) =
      _$HeatmapDayCopyWithImpl;
  @useResult
  $Res call({DateTime date, int totalSeconds, int sessionCount});
}

/// @nodoc
class _$HeatmapDayCopyWithImpl<$Res> implements $HeatmapDayCopyWith<$Res> {
  _$HeatmapDayCopyWithImpl(this._self, this._then);

  final HeatmapDay _self;
  final $Res Function(HeatmapDay) _then;

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _self.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeatmapDay].
extension HeatmapDayPatterns on HeatmapDay {
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
    TResult Function(_HeatmapDay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatmapDay() when $default != null:
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
    TResult Function(_HeatmapDay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapDay():
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
    TResult? Function(_HeatmapDay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapDay() when $default != null:
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
    TResult Function(DateTime date, int totalSeconds, int sessionCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatmapDay() when $default != null:
        return $default(_that.date, _that.totalSeconds, _that.sessionCount);
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
    TResult Function(DateTime date, int totalSeconds, int sessionCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapDay():
        return $default(_that.date, _that.totalSeconds, _that.sessionCount);
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
    TResult? Function(DateTime date, int totalSeconds, int sessionCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapDay() when $default != null:
        return $default(_that.date, _that.totalSeconds, _that.sessionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HeatmapDay implements HeatmapDay {
  const _HeatmapDay(
      {required this.date,
      required this.totalSeconds,
      required this.sessionCount});

  @override
  final DateTime date;
  @override
  final int totalSeconds;
  @override
  final int sessionCount;

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeatmapDayCopyWith<_HeatmapDay> get copyWith =>
      __$HeatmapDayCopyWithImpl<_HeatmapDay>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeatmapDay &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, totalSeconds, sessionCount);

  @override
  String toString() {
    return 'HeatmapDay(date: $date, totalSeconds: $totalSeconds, sessionCount: $sessionCount)';
  }
}

/// @nodoc
abstract mixin class _$HeatmapDayCopyWith<$Res>
    implements $HeatmapDayCopyWith<$Res> {
  factory _$HeatmapDayCopyWith(
          _HeatmapDay value, $Res Function(_HeatmapDay) _then) =
      __$HeatmapDayCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, int totalSeconds, int sessionCount});
}

/// @nodoc
class __$HeatmapDayCopyWithImpl<$Res> implements _$HeatmapDayCopyWith<$Res> {
  __$HeatmapDayCopyWithImpl(this._self, this._then);

  final _HeatmapDay _self;
  final $Res Function(_HeatmapDay) _then;

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
  }) {
    return _then(_HeatmapDay(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _self.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
