// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revenue_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyMrrPoint {
  String get month;
  double get mrr;

  /// Create a copy of MonthlyMrrPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyMrrPointCopyWith<MonthlyMrrPoint> get copyWith =>
      _$MonthlyMrrPointCopyWithImpl<MonthlyMrrPoint>(
          this as MonthlyMrrPoint, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyMrrPoint &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.mrr, mrr) || other.mrr == mrr));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, mrr);

  @override
  String toString() {
    return 'MonthlyMrrPoint(month: $month, mrr: $mrr)';
  }
}

/// @nodoc
abstract mixin class $MonthlyMrrPointCopyWith<$Res> {
  factory $MonthlyMrrPointCopyWith(
          MonthlyMrrPoint value, $Res Function(MonthlyMrrPoint) _then) =
      _$MonthlyMrrPointCopyWithImpl;
  @useResult
  $Res call({String month, double mrr});
}

/// @nodoc
class _$MonthlyMrrPointCopyWithImpl<$Res>
    implements $MonthlyMrrPointCopyWith<$Res> {
  _$MonthlyMrrPointCopyWithImpl(this._self, this._then);

  final MonthlyMrrPoint _self;
  final $Res Function(MonthlyMrrPoint) _then;

  /// Create a copy of MonthlyMrrPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? mrr = null,
  }) {
    return _then(_self.copyWith(
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      mrr: null == mrr
          ? _self.mrr
          : mrr // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [MonthlyMrrPoint].
extension MonthlyMrrPointPatterns on MonthlyMrrPoint {
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
    TResult Function(_MonthlyMrrPoint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPoint() when $default != null:
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
    TResult Function(_MonthlyMrrPoint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPoint():
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
    TResult? Function(_MonthlyMrrPoint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPoint() when $default != null:
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
    TResult Function(String month, double mrr)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPoint() when $default != null:
        return $default(_that.month, _that.mrr);
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
    TResult Function(String month, double mrr) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPoint():
        return $default(_that.month, _that.mrr);
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
    TResult? Function(String month, double mrr)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPoint() when $default != null:
        return $default(_that.month, _that.mrr);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MonthlyMrrPoint implements MonthlyMrrPoint {
  const _MonthlyMrrPoint({required this.month, required this.mrr});

  @override
  final String month;
  @override
  final double mrr;

  /// Create a copy of MonthlyMrrPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlyMrrPointCopyWith<_MonthlyMrrPoint> get copyWith =>
      __$MonthlyMrrPointCopyWithImpl<_MonthlyMrrPoint>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlyMrrPoint &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.mrr, mrr) || other.mrr == mrr));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, mrr);

  @override
  String toString() {
    return 'MonthlyMrrPoint(month: $month, mrr: $mrr)';
  }
}

/// @nodoc
abstract mixin class _$MonthlyMrrPointCopyWith<$Res>
    implements $MonthlyMrrPointCopyWith<$Res> {
  factory _$MonthlyMrrPointCopyWith(
          _MonthlyMrrPoint value, $Res Function(_MonthlyMrrPoint) _then) =
      __$MonthlyMrrPointCopyWithImpl;
  @override
  @useResult
  $Res call({String month, double mrr});
}

/// @nodoc
class __$MonthlyMrrPointCopyWithImpl<$Res>
    implements _$MonthlyMrrPointCopyWith<$Res> {
  __$MonthlyMrrPointCopyWithImpl(this._self, this._then);

  final _MonthlyMrrPoint _self;
  final $Res Function(_MonthlyMrrPoint) _then;

  /// Create a copy of MonthlyMrrPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? month = null,
    Object? mrr = null,
  }) {
    return _then(_MonthlyMrrPoint(
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      mrr: null == mrr
          ? _self.mrr
          : mrr // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$RevenueMetrics {
  double get mrr;
  double get arr;
  int get activeSubscribers;
  int get churned30d;
  double get teamMrr;
  List<MonthlyMrrPoint> get monthlyTrend;

  /// Create a copy of RevenueMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RevenueMetricsCopyWith<RevenueMetrics> get copyWith =>
      _$RevenueMetricsCopyWithImpl<RevenueMetrics>(
          this as RevenueMetrics, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RevenueMetrics &&
            (identical(other.mrr, mrr) || other.mrr == mrr) &&
            (identical(other.arr, arr) || other.arr == arr) &&
            (identical(other.activeSubscribers, activeSubscribers) ||
                other.activeSubscribers == activeSubscribers) &&
            (identical(other.churned30d, churned30d) ||
                other.churned30d == churned30d) &&
            (identical(other.teamMrr, teamMrr) || other.teamMrr == teamMrr) &&
            const DeepCollectionEquality()
                .equals(other.monthlyTrend, monthlyTrend));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mrr, arr, activeSubscribers,
      churned30d, teamMrr, const DeepCollectionEquality().hash(monthlyTrend));

  @override
  String toString() {
    return 'RevenueMetrics(mrr: $mrr, arr: $arr, activeSubscribers: $activeSubscribers, churned30d: $churned30d, teamMrr: $teamMrr, monthlyTrend: $monthlyTrend)';
  }
}

/// @nodoc
abstract mixin class $RevenueMetricsCopyWith<$Res> {
  factory $RevenueMetricsCopyWith(
          RevenueMetrics value, $Res Function(RevenueMetrics) _then) =
      _$RevenueMetricsCopyWithImpl;
  @useResult
  $Res call(
      {double mrr,
      double arr,
      int activeSubscribers,
      int churned30d,
      double teamMrr,
      List<MonthlyMrrPoint> monthlyTrend});
}

/// @nodoc
class _$RevenueMetricsCopyWithImpl<$Res>
    implements $RevenueMetricsCopyWith<$Res> {
  _$RevenueMetricsCopyWithImpl(this._self, this._then);

  final RevenueMetrics _self;
  final $Res Function(RevenueMetrics) _then;

  /// Create a copy of RevenueMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mrr = null,
    Object? arr = null,
    Object? activeSubscribers = null,
    Object? churned30d = null,
    Object? teamMrr = null,
    Object? monthlyTrend = null,
  }) {
    return _then(_self.copyWith(
      mrr: null == mrr
          ? _self.mrr
          : mrr // ignore: cast_nullable_to_non_nullable
              as double,
      arr: null == arr
          ? _self.arr
          : arr // ignore: cast_nullable_to_non_nullable
              as double,
      activeSubscribers: null == activeSubscribers
          ? _self.activeSubscribers
          : activeSubscribers // ignore: cast_nullable_to_non_nullable
              as int,
      churned30d: null == churned30d
          ? _self.churned30d
          : churned30d // ignore: cast_nullable_to_non_nullable
              as int,
      teamMrr: null == teamMrr
          ? _self.teamMrr
          : teamMrr // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyTrend: null == monthlyTrend
          ? _self.monthlyTrend
          : monthlyTrend // ignore: cast_nullable_to_non_nullable
              as List<MonthlyMrrPoint>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RevenueMetrics].
extension RevenueMetricsPatterns on RevenueMetrics {
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
    TResult Function(_RevenueMetrics value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RevenueMetrics() when $default != null:
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
    TResult Function(_RevenueMetrics value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetrics():
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
    TResult? Function(_RevenueMetrics value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetrics() when $default != null:
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
    TResult Function(double mrr, double arr, int activeSubscribers,
            int churned30d, double teamMrr, List<MonthlyMrrPoint> monthlyTrend)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RevenueMetrics() when $default != null:
        return $default(_that.mrr, _that.arr, _that.activeSubscribers,
            _that.churned30d, _that.teamMrr, _that.monthlyTrend);
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
    TResult Function(double mrr, double arr, int activeSubscribers,
            int churned30d, double teamMrr, List<MonthlyMrrPoint> monthlyTrend)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetrics():
        return $default(_that.mrr, _that.arr, _that.activeSubscribers,
            _that.churned30d, _that.teamMrr, _that.monthlyTrend);
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
    TResult? Function(double mrr, double arr, int activeSubscribers,
            int churned30d, double teamMrr, List<MonthlyMrrPoint> monthlyTrend)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetrics() when $default != null:
        return $default(_that.mrr, _that.arr, _that.activeSubscribers,
            _that.churned30d, _that.teamMrr, _that.monthlyTrend);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RevenueMetrics implements RevenueMetrics {
  const _RevenueMetrics(
      {required this.mrr,
      required this.arr,
      required this.activeSubscribers,
      required this.churned30d,
      required this.teamMrr,
      required final List<MonthlyMrrPoint> monthlyTrend})
      : _monthlyTrend = monthlyTrend;

  @override
  final double mrr;
  @override
  final double arr;
  @override
  final int activeSubscribers;
  @override
  final int churned30d;
  @override
  final double teamMrr;
  final List<MonthlyMrrPoint> _monthlyTrend;
  @override
  List<MonthlyMrrPoint> get monthlyTrend {
    if (_monthlyTrend is EqualUnmodifiableListView) return _monthlyTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyTrend);
  }

  /// Create a copy of RevenueMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RevenueMetricsCopyWith<_RevenueMetrics> get copyWith =>
      __$RevenueMetricsCopyWithImpl<_RevenueMetrics>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RevenueMetrics &&
            (identical(other.mrr, mrr) || other.mrr == mrr) &&
            (identical(other.arr, arr) || other.arr == arr) &&
            (identical(other.activeSubscribers, activeSubscribers) ||
                other.activeSubscribers == activeSubscribers) &&
            (identical(other.churned30d, churned30d) ||
                other.churned30d == churned30d) &&
            (identical(other.teamMrr, teamMrr) || other.teamMrr == teamMrr) &&
            const DeepCollectionEquality()
                .equals(other._monthlyTrend, _monthlyTrend));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mrr, arr, activeSubscribers,
      churned30d, teamMrr, const DeepCollectionEquality().hash(_monthlyTrend));

  @override
  String toString() {
    return 'RevenueMetrics(mrr: $mrr, arr: $arr, activeSubscribers: $activeSubscribers, churned30d: $churned30d, teamMrr: $teamMrr, monthlyTrend: $monthlyTrend)';
  }
}

/// @nodoc
abstract mixin class _$RevenueMetricsCopyWith<$Res>
    implements $RevenueMetricsCopyWith<$Res> {
  factory _$RevenueMetricsCopyWith(
          _RevenueMetrics value, $Res Function(_RevenueMetrics) _then) =
      __$RevenueMetricsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double mrr,
      double arr,
      int activeSubscribers,
      int churned30d,
      double teamMrr,
      List<MonthlyMrrPoint> monthlyTrend});
}

/// @nodoc
class __$RevenueMetricsCopyWithImpl<$Res>
    implements _$RevenueMetricsCopyWith<$Res> {
  __$RevenueMetricsCopyWithImpl(this._self, this._then);

  final _RevenueMetrics _self;
  final $Res Function(_RevenueMetrics) _then;

  /// Create a copy of RevenueMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mrr = null,
    Object? arr = null,
    Object? activeSubscribers = null,
    Object? churned30d = null,
    Object? teamMrr = null,
    Object? monthlyTrend = null,
  }) {
    return _then(_RevenueMetrics(
      mrr: null == mrr
          ? _self.mrr
          : mrr // ignore: cast_nullable_to_non_nullable
              as double,
      arr: null == arr
          ? _self.arr
          : arr // ignore: cast_nullable_to_non_nullable
              as double,
      activeSubscribers: null == activeSubscribers
          ? _self.activeSubscribers
          : activeSubscribers // ignore: cast_nullable_to_non_nullable
              as int,
      churned30d: null == churned30d
          ? _self.churned30d
          : churned30d // ignore: cast_nullable_to_non_nullable
              as int,
      teamMrr: null == teamMrr
          ? _self.teamMrr
          : teamMrr // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyTrend: null == monthlyTrend
          ? _self._monthlyTrend
          : monthlyTrend // ignore: cast_nullable_to_non_nullable
              as List<MonthlyMrrPoint>,
    ));
  }
}

// dart format on
