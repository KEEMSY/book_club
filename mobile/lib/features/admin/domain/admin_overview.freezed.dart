// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminOverview {
  AdminStats get stats;
  ConversionFunnel get funnel;
  RevenueMetrics get revenue;

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminOverviewCopyWith<AdminOverview> get copyWith =>
      _$AdminOverviewCopyWithImpl<AdminOverview>(
          this as AdminOverview, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminOverview &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.funnel, funnel) || other.funnel == funnel) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stats, funnel, revenue);

  @override
  String toString() {
    return 'AdminOverview(stats: $stats, funnel: $funnel, revenue: $revenue)';
  }
}

/// @nodoc
abstract mixin class $AdminOverviewCopyWith<$Res> {
  factory $AdminOverviewCopyWith(
          AdminOverview value, $Res Function(AdminOverview) _then) =
      _$AdminOverviewCopyWithImpl;
  @useResult
  $Res call(
      {AdminStats stats, ConversionFunnel funnel, RevenueMetrics revenue});

  $AdminStatsCopyWith<$Res> get stats;
  $ConversionFunnelCopyWith<$Res> get funnel;
  $RevenueMetricsCopyWith<$Res> get revenue;
}

/// @nodoc
class _$AdminOverviewCopyWithImpl<$Res>
    implements $AdminOverviewCopyWith<$Res> {
  _$AdminOverviewCopyWithImpl(this._self, this._then);

  final AdminOverview _self;
  final $Res Function(AdminOverview) _then;

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? funnel = null,
    Object? revenue = null,
  }) {
    return _then(_self.copyWith(
      stats: null == stats
          ? _self.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as AdminStats,
      funnel: null == funnel
          ? _self.funnel
          : funnel // ignore: cast_nullable_to_non_nullable
              as ConversionFunnel,
      revenue: null == revenue
          ? _self.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as RevenueMetrics,
    ));
  }

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdminStatsCopyWith<$Res> get stats {
    return $AdminStatsCopyWith<$Res>(_self.stats, (value) {
      return _then(_self.copyWith(stats: value));
    });
  }

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversionFunnelCopyWith<$Res> get funnel {
    return $ConversionFunnelCopyWith<$Res>(_self.funnel, (value) {
      return _then(_self.copyWith(funnel: value));
    });
  }

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RevenueMetricsCopyWith<$Res> get revenue {
    return $RevenueMetricsCopyWith<$Res>(_self.revenue, (value) {
      return _then(_self.copyWith(revenue: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AdminOverview].
extension AdminOverviewPatterns on AdminOverview {
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
    TResult Function(_AdminOverview value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminOverview() when $default != null:
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
    TResult Function(_AdminOverview value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminOverview():
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
    TResult? Function(_AdminOverview value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminOverview() when $default != null:
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
            AdminStats stats, ConversionFunnel funnel, RevenueMetrics revenue)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminOverview() when $default != null:
        return $default(_that.stats, _that.funnel, _that.revenue);
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
            AdminStats stats, ConversionFunnel funnel, RevenueMetrics revenue)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminOverview():
        return $default(_that.stats, _that.funnel, _that.revenue);
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
            AdminStats stats, ConversionFunnel funnel, RevenueMetrics revenue)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminOverview() when $default != null:
        return $default(_that.stats, _that.funnel, _that.revenue);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AdminOverview implements AdminOverview {
  const _AdminOverview(
      {required this.stats, required this.funnel, required this.revenue});

  @override
  final AdminStats stats;
  @override
  final ConversionFunnel funnel;
  @override
  final RevenueMetrics revenue;

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminOverviewCopyWith<_AdminOverview> get copyWith =>
      __$AdminOverviewCopyWithImpl<_AdminOverview>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminOverview &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.funnel, funnel) || other.funnel == funnel) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stats, funnel, revenue);

  @override
  String toString() {
    return 'AdminOverview(stats: $stats, funnel: $funnel, revenue: $revenue)';
  }
}

/// @nodoc
abstract mixin class _$AdminOverviewCopyWith<$Res>
    implements $AdminOverviewCopyWith<$Res> {
  factory _$AdminOverviewCopyWith(
          _AdminOverview value, $Res Function(_AdminOverview) _then) =
      __$AdminOverviewCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AdminStats stats, ConversionFunnel funnel, RevenueMetrics revenue});

  @override
  $AdminStatsCopyWith<$Res> get stats;
  @override
  $ConversionFunnelCopyWith<$Res> get funnel;
  @override
  $RevenueMetricsCopyWith<$Res> get revenue;
}

/// @nodoc
class __$AdminOverviewCopyWithImpl<$Res>
    implements _$AdminOverviewCopyWith<$Res> {
  __$AdminOverviewCopyWithImpl(this._self, this._then);

  final _AdminOverview _self;
  final $Res Function(_AdminOverview) _then;

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stats = null,
    Object? funnel = null,
    Object? revenue = null,
  }) {
    return _then(_AdminOverview(
      stats: null == stats
          ? _self.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as AdminStats,
      funnel: null == funnel
          ? _self.funnel
          : funnel // ignore: cast_nullable_to_non_nullable
              as ConversionFunnel,
      revenue: null == revenue
          ? _self.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as RevenueMetrics,
    ));
  }

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdminStatsCopyWith<$Res> get stats {
    return $AdminStatsCopyWith<$Res>(_self.stats, (value) {
      return _then(_self.copyWith(stats: value));
    });
  }

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversionFunnelCopyWith<$Res> get funnel {
    return $ConversionFunnelCopyWith<$Res>(_self.funnel, (value) {
      return _then(_self.copyWith(funnel: value));
    });
  }

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RevenueMetricsCopyWith<$Res> get revenue {
    return $RevenueMetricsCopyWith<$Res>(_self.revenue, (value) {
      return _then(_self.copyWith(revenue: value));
    });
  }
}

// dart format on
