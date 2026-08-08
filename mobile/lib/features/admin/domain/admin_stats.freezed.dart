// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminStats {
  int get mau;
  int get dau;
  int get newUsers7d;
  int get proUsers;

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminStatsCopyWith<AdminStats> get copyWith =>
      _$AdminStatsCopyWithImpl<AdminStats>(this as AdminStats, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminStats &&
            (identical(other.mau, mau) || other.mau == mau) &&
            (identical(other.dau, dau) || other.dau == dau) &&
            (identical(other.newUsers7d, newUsers7d) ||
                other.newUsers7d == newUsers7d) &&
            (identical(other.proUsers, proUsers) ||
                other.proUsers == proUsers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mau, dau, newUsers7d, proUsers);

  @override
  String toString() {
    return 'AdminStats(mau: $mau, dau: $dau, newUsers7d: $newUsers7d, proUsers: $proUsers)';
  }
}

/// @nodoc
abstract mixin class $AdminStatsCopyWith<$Res> {
  factory $AdminStatsCopyWith(
          AdminStats value, $Res Function(AdminStats) _then) =
      _$AdminStatsCopyWithImpl;
  @useResult
  $Res call({int mau, int dau, int newUsers7d, int proUsers});
}

/// @nodoc
class _$AdminStatsCopyWithImpl<$Res> implements $AdminStatsCopyWith<$Res> {
  _$AdminStatsCopyWithImpl(this._self, this._then);

  final AdminStats _self;
  final $Res Function(AdminStats) _then;

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mau = null,
    Object? dau = null,
    Object? newUsers7d = null,
    Object? proUsers = null,
  }) {
    return _then(_self.copyWith(
      mau: null == mau
          ? _self.mau
          : mau // ignore: cast_nullable_to_non_nullable
              as int,
      dau: null == dau
          ? _self.dau
          : dau // ignore: cast_nullable_to_non_nullable
              as int,
      newUsers7d: null == newUsers7d
          ? _self.newUsers7d
          : newUsers7d // ignore: cast_nullable_to_non_nullable
              as int,
      proUsers: null == proUsers
          ? _self.proUsers
          : proUsers // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminStats].
extension AdminStatsPatterns on AdminStats {
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
    TResult Function(_AdminStats value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
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
    TResult Function(_AdminStats value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats():
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
    TResult? Function(_AdminStats value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
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
    TResult Function(int mau, int dau, int newUsers7d, int proUsers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(_that.mau, _that.dau, _that.newUsers7d, _that.proUsers);
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
    TResult Function(int mau, int dau, int newUsers7d, int proUsers) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats():
        return $default(_that.mau, _that.dau, _that.newUsers7d, _that.proUsers);
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
    TResult? Function(int mau, int dau, int newUsers7d, int proUsers)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(_that.mau, _that.dau, _that.newUsers7d, _that.proUsers);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AdminStats implements AdminStats {
  const _AdminStats(
      {required this.mau,
      required this.dau,
      required this.newUsers7d,
      required this.proUsers});

  @override
  final int mau;
  @override
  final int dau;
  @override
  final int newUsers7d;
  @override
  final int proUsers;

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminStatsCopyWith<_AdminStats> get copyWith =>
      __$AdminStatsCopyWithImpl<_AdminStats>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminStats &&
            (identical(other.mau, mau) || other.mau == mau) &&
            (identical(other.dau, dau) || other.dau == dau) &&
            (identical(other.newUsers7d, newUsers7d) ||
                other.newUsers7d == newUsers7d) &&
            (identical(other.proUsers, proUsers) ||
                other.proUsers == proUsers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mau, dau, newUsers7d, proUsers);

  @override
  String toString() {
    return 'AdminStats(mau: $mau, dau: $dau, newUsers7d: $newUsers7d, proUsers: $proUsers)';
  }
}

/// @nodoc
abstract mixin class _$AdminStatsCopyWith<$Res>
    implements $AdminStatsCopyWith<$Res> {
  factory _$AdminStatsCopyWith(
          _AdminStats value, $Res Function(_AdminStats) _then) =
      __$AdminStatsCopyWithImpl;
  @override
  @useResult
  $Res call({int mau, int dau, int newUsers7d, int proUsers});
}

/// @nodoc
class __$AdminStatsCopyWithImpl<$Res> implements _$AdminStatsCopyWith<$Res> {
  __$AdminStatsCopyWithImpl(this._self, this._then);

  final _AdminStats _self;
  final $Res Function(_AdminStats) _then;

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mau = null,
    Object? dau = null,
    Object? newUsers7d = null,
    Object? proUsers = null,
  }) {
    return _then(_AdminStats(
      mau: null == mau
          ? _self.mau
          : mau // ignore: cast_nullable_to_non_nullable
              as int,
      dau: null == dau
          ? _self.dau
          : dau // ignore: cast_nullable_to_non_nullable
              as int,
      newUsers7d: null == newUsers7d
          ? _self.newUsers7d
          : newUsers7d // ignore: cast_nullable_to_non_nullable
              as int,
      proUsers: null == proUsers
          ? _self.proUsers
          : proUsers // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
