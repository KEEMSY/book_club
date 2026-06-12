// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReferralStats {
  String get code;
  int get invitedCount;
  int get completedCount;

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReferralStatsCopyWith<ReferralStats> get copyWith =>
      _$ReferralStatsCopyWithImpl<ReferralStats>(
          this as ReferralStats, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReferralStats &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.invitedCount, invitedCount) ||
                other.invitedCount == invitedCount) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, code, invitedCount, completedCount);

  @override
  String toString() {
    return 'ReferralStats(code: $code, invitedCount: $invitedCount, completedCount: $completedCount)';
  }
}

/// @nodoc
abstract mixin class $ReferralStatsCopyWith<$Res> {
  factory $ReferralStatsCopyWith(
          ReferralStats value, $Res Function(ReferralStats) _then) =
      _$ReferralStatsCopyWithImpl;
  @useResult
  $Res call({String code, int invitedCount, int completedCount});
}

/// @nodoc
class _$ReferralStatsCopyWithImpl<$Res>
    implements $ReferralStatsCopyWith<$Res> {
  _$ReferralStatsCopyWithImpl(this._self, this._then);

  final ReferralStats _self;
  final $Res Function(ReferralStats) _then;

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? invitedCount = null,
    Object? completedCount = null,
  }) {
    return _then(_self.copyWith(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      invitedCount: null == invitedCount
          ? _self.invitedCount
          : invitedCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _self.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReferralStats].
extension ReferralStatsPatterns on ReferralStats {
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
    TResult Function(_ReferralStats value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReferralStats() when $default != null:
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
    TResult Function(_ReferralStats value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferralStats():
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
    TResult? Function(_ReferralStats value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferralStats() when $default != null:
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
    TResult Function(String code, int invitedCount, int completedCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReferralStats() when $default != null:
        return $default(_that.code, _that.invitedCount, _that.completedCount);
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
    TResult Function(String code, int invitedCount, int completedCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferralStats():
        return $default(_that.code, _that.invitedCount, _that.completedCount);
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
    TResult? Function(String code, int invitedCount, int completedCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferralStats() when $default != null:
        return $default(_that.code, _that.invitedCount, _that.completedCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReferralStats implements ReferralStats {
  const _ReferralStats(
      {required this.code,
      required this.invitedCount,
      required this.completedCount});

  @override
  final String code;
  @override
  final int invitedCount;
  @override
  final int completedCount;

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReferralStatsCopyWith<_ReferralStats> get copyWith =>
      __$ReferralStatsCopyWithImpl<_ReferralStats>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReferralStats &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.invitedCount, invitedCount) ||
                other.invitedCount == invitedCount) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, code, invitedCount, completedCount);

  @override
  String toString() {
    return 'ReferralStats(code: $code, invitedCount: $invitedCount, completedCount: $completedCount)';
  }
}

/// @nodoc
abstract mixin class _$ReferralStatsCopyWith<$Res>
    implements $ReferralStatsCopyWith<$Res> {
  factory _$ReferralStatsCopyWith(
          _ReferralStats value, $Res Function(_ReferralStats) _then) =
      __$ReferralStatsCopyWithImpl;
  @override
  @useResult
  $Res call({String code, int invitedCount, int completedCount});
}

/// @nodoc
class __$ReferralStatsCopyWithImpl<$Res>
    implements _$ReferralStatsCopyWith<$Res> {
  __$ReferralStatsCopyWithImpl(this._self, this._then);

  final _ReferralStats _self;
  final $Res Function(_ReferralStats) _then;

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? invitedCount = null,
    Object? completedCount = null,
  }) {
    return _then(_ReferralStats(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      invitedCount: null == invitedCount
          ? _self.invitedCount
          : invitedCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _self.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
