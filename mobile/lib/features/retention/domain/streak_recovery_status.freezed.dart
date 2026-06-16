// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_recovery_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreakRecoveryStatus {
  int get recoveriesUsed;
  int get recoveriesRemaining;
  bool get canRecover;

  /// Create a copy of StreakRecoveryStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StreakRecoveryStatusCopyWith<StreakRecoveryStatus> get copyWith =>
      _$StreakRecoveryStatusCopyWithImpl<StreakRecoveryStatus>(
          this as StreakRecoveryStatus, _$identity);

  /// Serializes this StreakRecoveryStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StreakRecoveryStatus &&
            (identical(other.recoveriesUsed, recoveriesUsed) ||
                other.recoveriesUsed == recoveriesUsed) &&
            (identical(other.recoveriesRemaining, recoveriesRemaining) ||
                other.recoveriesRemaining == recoveriesRemaining) &&
            (identical(other.canRecover, canRecover) ||
                other.canRecover == canRecover));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, recoveriesUsed, recoveriesRemaining, canRecover);

  @override
  String toString() {
    return 'StreakRecoveryStatus(recoveriesUsed: $recoveriesUsed, recoveriesRemaining: $recoveriesRemaining, canRecover: $canRecover)';
  }
}

/// @nodoc
abstract mixin class $StreakRecoveryStatusCopyWith<$Res> {
  factory $StreakRecoveryStatusCopyWith(StreakRecoveryStatus value,
          $Res Function(StreakRecoveryStatus) _then) =
      _$StreakRecoveryStatusCopyWithImpl;
  @useResult
  $Res call({int recoveriesUsed, int recoveriesRemaining, bool canRecover});
}

/// @nodoc
class _$StreakRecoveryStatusCopyWithImpl<$Res>
    implements $StreakRecoveryStatusCopyWith<$Res> {
  _$StreakRecoveryStatusCopyWithImpl(this._self, this._then);

  final StreakRecoveryStatus _self;
  final $Res Function(StreakRecoveryStatus) _then;

  /// Create a copy of StreakRecoveryStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recoveriesUsed = null,
    Object? recoveriesRemaining = null,
    Object? canRecover = null,
  }) {
    return _then(_self.copyWith(
      recoveriesUsed: null == recoveriesUsed
          ? _self.recoveriesUsed
          : recoveriesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      recoveriesRemaining: null == recoveriesRemaining
          ? _self.recoveriesRemaining
          : recoveriesRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      canRecover: null == canRecover
          ? _self.canRecover
          : canRecover // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [StreakRecoveryStatus].
extension StreakRecoveryStatusPatterns on StreakRecoveryStatus {
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
    TResult Function(_StreakRecoveryStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StreakRecoveryStatus() when $default != null:
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
    TResult Function(_StreakRecoveryStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StreakRecoveryStatus():
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
    TResult? Function(_StreakRecoveryStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StreakRecoveryStatus() when $default != null:
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
            int recoveriesUsed, int recoveriesRemaining, bool canRecover)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StreakRecoveryStatus() when $default != null:
        return $default(
            _that.recoveriesUsed, _that.recoveriesRemaining, _that.canRecover);
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
            int recoveriesUsed, int recoveriesRemaining, bool canRecover)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StreakRecoveryStatus():
        return $default(
            _that.recoveriesUsed, _that.recoveriesRemaining, _that.canRecover);
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
            int recoveriesUsed, int recoveriesRemaining, bool canRecover)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StreakRecoveryStatus() when $default != null:
        return $default(
            _that.recoveriesUsed, _that.recoveriesRemaining, _that.canRecover);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StreakRecoveryStatus implements StreakRecoveryStatus {
  const _StreakRecoveryStatus(
      {required this.recoveriesUsed,
      required this.recoveriesRemaining,
      required this.canRecover});
  factory _StreakRecoveryStatus.fromJson(Map<String, dynamic> json) =>
      _$StreakRecoveryStatusFromJson(json);

  @override
  final int recoveriesUsed;
  @override
  final int recoveriesRemaining;
  @override
  final bool canRecover;

  /// Create a copy of StreakRecoveryStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StreakRecoveryStatusCopyWith<_StreakRecoveryStatus> get copyWith =>
      __$StreakRecoveryStatusCopyWithImpl<_StreakRecoveryStatus>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StreakRecoveryStatusToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StreakRecoveryStatus &&
            (identical(other.recoveriesUsed, recoveriesUsed) ||
                other.recoveriesUsed == recoveriesUsed) &&
            (identical(other.recoveriesRemaining, recoveriesRemaining) ||
                other.recoveriesRemaining == recoveriesRemaining) &&
            (identical(other.canRecover, canRecover) ||
                other.canRecover == canRecover));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, recoveriesUsed, recoveriesRemaining, canRecover);

  @override
  String toString() {
    return 'StreakRecoveryStatus(recoveriesUsed: $recoveriesUsed, recoveriesRemaining: $recoveriesRemaining, canRecover: $canRecover)';
  }
}

/// @nodoc
abstract mixin class _$StreakRecoveryStatusCopyWith<$Res>
    implements $StreakRecoveryStatusCopyWith<$Res> {
  factory _$StreakRecoveryStatusCopyWith(_StreakRecoveryStatus value,
          $Res Function(_StreakRecoveryStatus) _then) =
      __$StreakRecoveryStatusCopyWithImpl;
  @override
  @useResult
  $Res call({int recoveriesUsed, int recoveriesRemaining, bool canRecover});
}

/// @nodoc
class __$StreakRecoveryStatusCopyWithImpl<$Res>
    implements _$StreakRecoveryStatusCopyWith<$Res> {
  __$StreakRecoveryStatusCopyWithImpl(this._self, this._then);

  final _StreakRecoveryStatus _self;
  final $Res Function(_StreakRecoveryStatus) _then;

  /// Create a copy of StreakRecoveryStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? recoveriesUsed = null,
    Object? recoveriesRemaining = null,
    Object? canRecover = null,
  }) {
    return _then(_StreakRecoveryStatus(
      recoveriesUsed: null == recoveriesUsed
          ? _self.recoveriesUsed
          : recoveriesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      recoveriesRemaining: null == recoveriesRemaining
          ? _self.recoveriesRemaining
          : recoveriesRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      canRecover: null == canRecover
          ? _self.canRecover
          : canRecover // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
