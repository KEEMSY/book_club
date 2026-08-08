// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversion_funnel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversionFunnel {
  int get paywallViews;
  int get paywallClicks;
  int get subscriptions;
  double get conversionRate;

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversionFunnelCopyWith<ConversionFunnel> get copyWith =>
      _$ConversionFunnelCopyWithImpl<ConversionFunnel>(
          this as ConversionFunnel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversionFunnel &&
            (identical(other.paywallViews, paywallViews) ||
                other.paywallViews == paywallViews) &&
            (identical(other.paywallClicks, paywallClicks) ||
                other.paywallClicks == paywallClicks) &&
            (identical(other.subscriptions, subscriptions) ||
                other.subscriptions == subscriptions) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, paywallViews, paywallClicks, subscriptions, conversionRate);

  @override
  String toString() {
    return 'ConversionFunnel(paywallViews: $paywallViews, paywallClicks: $paywallClicks, subscriptions: $subscriptions, conversionRate: $conversionRate)';
  }
}

/// @nodoc
abstract mixin class $ConversionFunnelCopyWith<$Res> {
  factory $ConversionFunnelCopyWith(
          ConversionFunnel value, $Res Function(ConversionFunnel) _then) =
      _$ConversionFunnelCopyWithImpl;
  @useResult
  $Res call(
      {int paywallViews,
      int paywallClicks,
      int subscriptions,
      double conversionRate});
}

/// @nodoc
class _$ConversionFunnelCopyWithImpl<$Res>
    implements $ConversionFunnelCopyWith<$Res> {
  _$ConversionFunnelCopyWithImpl(this._self, this._then);

  final ConversionFunnel _self;
  final $Res Function(ConversionFunnel) _then;

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paywallViews = null,
    Object? paywallClicks = null,
    Object? subscriptions = null,
    Object? conversionRate = null,
  }) {
    return _then(_self.copyWith(
      paywallViews: null == paywallViews
          ? _self.paywallViews
          : paywallViews // ignore: cast_nullable_to_non_nullable
              as int,
      paywallClicks: null == paywallClicks
          ? _self.paywallClicks
          : paywallClicks // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptions: null == subscriptions
          ? _self.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _self.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConversionFunnel].
extension ConversionFunnelPatterns on ConversionFunnel {
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
    TResult Function(_ConversionFunnel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnel() when $default != null:
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
    TResult Function(_ConversionFunnel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnel():
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
    TResult? Function(_ConversionFunnel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnel() when $default != null:
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
    TResult Function(int paywallViews, int paywallClicks, int subscriptions,
            double conversionRate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnel() when $default != null:
        return $default(_that.paywallViews, _that.paywallClicks,
            _that.subscriptions, _that.conversionRate);
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
    TResult Function(int paywallViews, int paywallClicks, int subscriptions,
            double conversionRate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnel():
        return $default(_that.paywallViews, _that.paywallClicks,
            _that.subscriptions, _that.conversionRate);
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
    TResult? Function(int paywallViews, int paywallClicks, int subscriptions,
            double conversionRate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnel() when $default != null:
        return $default(_that.paywallViews, _that.paywallClicks,
            _that.subscriptions, _that.conversionRate);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConversionFunnel implements ConversionFunnel {
  const _ConversionFunnel(
      {required this.paywallViews,
      required this.paywallClicks,
      required this.subscriptions,
      required this.conversionRate});

  @override
  final int paywallViews;
  @override
  final int paywallClicks;
  @override
  final int subscriptions;
  @override
  final double conversionRate;

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversionFunnelCopyWith<_ConversionFunnel> get copyWith =>
      __$ConversionFunnelCopyWithImpl<_ConversionFunnel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversionFunnel &&
            (identical(other.paywallViews, paywallViews) ||
                other.paywallViews == paywallViews) &&
            (identical(other.paywallClicks, paywallClicks) ||
                other.paywallClicks == paywallClicks) &&
            (identical(other.subscriptions, subscriptions) ||
                other.subscriptions == subscriptions) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, paywallViews, paywallClicks, subscriptions, conversionRate);

  @override
  String toString() {
    return 'ConversionFunnel(paywallViews: $paywallViews, paywallClicks: $paywallClicks, subscriptions: $subscriptions, conversionRate: $conversionRate)';
  }
}

/// @nodoc
abstract mixin class _$ConversionFunnelCopyWith<$Res>
    implements $ConversionFunnelCopyWith<$Res> {
  factory _$ConversionFunnelCopyWith(
          _ConversionFunnel value, $Res Function(_ConversionFunnel) _then) =
      __$ConversionFunnelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int paywallViews,
      int paywallClicks,
      int subscriptions,
      double conversionRate});
}

/// @nodoc
class __$ConversionFunnelCopyWithImpl<$Res>
    implements _$ConversionFunnelCopyWith<$Res> {
  __$ConversionFunnelCopyWithImpl(this._self, this._then);

  final _ConversionFunnel _self;
  final $Res Function(_ConversionFunnel) _then;

  /// Create a copy of ConversionFunnel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? paywallViews = null,
    Object? paywallClicks = null,
    Object? subscriptions = null,
    Object? conversionRate = null,
  }) {
    return _then(_ConversionFunnel(
      paywallViews: null == paywallViews
          ? _self.paywallViews
          : paywallViews // ignore: cast_nullable_to_non_nullable
              as int,
      paywallClicks: null == paywallClicks
          ? _self.paywallClicks
          : paywallClicks // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptions: null == subscriptions
          ? _self.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _self.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
