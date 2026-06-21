// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trial_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrialStatus {
  bool get isInTrial;
  DateTime? get trialEndsAt;
  int get daysRemaining;

  /// Create a copy of TrialStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrialStatusCopyWith<TrialStatus> get copyWith =>
      _$TrialStatusCopyWithImpl<TrialStatus>(this as TrialStatus, _$identity);

  /// Serializes this TrialStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrialStatus &&
            (identical(other.isInTrial, isInTrial) ||
                other.isInTrial == isInTrial) &&
            (identical(other.trialEndsAt, trialEndsAt) ||
                other.trialEndsAt == trialEndsAt) &&
            (identical(other.daysRemaining, daysRemaining) ||
                other.daysRemaining == daysRemaining));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isInTrial, trialEndsAt, daysRemaining);

  @override
  String toString() {
    return 'TrialStatus(isInTrial: $isInTrial, trialEndsAt: $trialEndsAt, daysRemaining: $daysRemaining)';
  }
}

/// @nodoc
abstract mixin class $TrialStatusCopyWith<$Res> {
  factory $TrialStatusCopyWith(
          TrialStatus value, $Res Function(TrialStatus) _then) =
      _$TrialStatusCopyWithImpl;
  @useResult
  $Res call({bool isInTrial, DateTime? trialEndsAt, int daysRemaining});
}

/// @nodoc
class _$TrialStatusCopyWithImpl<$Res> implements $TrialStatusCopyWith<$Res> {
  _$TrialStatusCopyWithImpl(this._self, this._then);

  final TrialStatus _self;
  final $Res Function(TrialStatus) _then;

  /// Create a copy of TrialStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInTrial = null,
    Object? trialEndsAt = freezed,
    Object? daysRemaining = null,
  }) {
    return _then(_self.copyWith(
      isInTrial: null == isInTrial
          ? _self.isInTrial
          : isInTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      trialEndsAt: freezed == trialEndsAt
          ? _self.trialEndsAt
          : trialEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysRemaining: null == daysRemaining
          ? _self.daysRemaining
          : daysRemaining // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrialStatus].
extension TrialStatusPatterns on TrialStatus {
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
    TResult Function(_TrialStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrialStatus() when $default != null:
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
    TResult Function(_TrialStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrialStatus():
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
    TResult? Function(_TrialStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrialStatus() when $default != null:
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
    TResult Function(bool isInTrial, DateTime? trialEndsAt, int daysRemaining)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrialStatus() when $default != null:
        return $default(
            _that.isInTrial, _that.trialEndsAt, _that.daysRemaining);
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
    TResult Function(bool isInTrial, DateTime? trialEndsAt, int daysRemaining)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrialStatus():
        return $default(
            _that.isInTrial, _that.trialEndsAt, _that.daysRemaining);
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
    TResult? Function(bool isInTrial, DateTime? trialEndsAt, int daysRemaining)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrialStatus() when $default != null:
        return $default(
            _that.isInTrial, _that.trialEndsAt, _that.daysRemaining);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TrialStatus implements TrialStatus {
  const _TrialStatus(
      {this.isInTrial = false, this.trialEndsAt, this.daysRemaining = 0});
  factory _TrialStatus.fromJson(Map<String, dynamic> json) =>
      _$TrialStatusFromJson(json);

  @override
  @JsonKey()
  final bool isInTrial;
  @override
  final DateTime? trialEndsAt;
  @override
  @JsonKey()
  final int daysRemaining;

  /// Create a copy of TrialStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrialStatusCopyWith<_TrialStatus> get copyWith =>
      __$TrialStatusCopyWithImpl<_TrialStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrialStatusToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrialStatus &&
            (identical(other.isInTrial, isInTrial) ||
                other.isInTrial == isInTrial) &&
            (identical(other.trialEndsAt, trialEndsAt) ||
                other.trialEndsAt == trialEndsAt) &&
            (identical(other.daysRemaining, daysRemaining) ||
                other.daysRemaining == daysRemaining));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isInTrial, trialEndsAt, daysRemaining);

  @override
  String toString() {
    return 'TrialStatus(isInTrial: $isInTrial, trialEndsAt: $trialEndsAt, daysRemaining: $daysRemaining)';
  }
}

/// @nodoc
abstract mixin class _$TrialStatusCopyWith<$Res>
    implements $TrialStatusCopyWith<$Res> {
  factory _$TrialStatusCopyWith(
          _TrialStatus value, $Res Function(_TrialStatus) _then) =
      __$TrialStatusCopyWithImpl;
  @override
  @useResult
  $Res call({bool isInTrial, DateTime? trialEndsAt, int daysRemaining});
}

/// @nodoc
class __$TrialStatusCopyWithImpl<$Res> implements _$TrialStatusCopyWith<$Res> {
  __$TrialStatusCopyWithImpl(this._self, this._then);

  final _TrialStatus _self;
  final $Res Function(_TrialStatus) _then;

  /// Create a copy of TrialStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isInTrial = null,
    Object? trialEndsAt = freezed,
    Object? daysRemaining = null,
  }) {
    return _then(_TrialStatus(
      isInTrial: null == isInTrial
          ? _self.isInTrial
          : isInTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      trialEndsAt: freezed == trialEndsAt
          ? _self.trialEndsAt
          : trialEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysRemaining: null == daysRemaining
          ? _self.daysRemaining
          : daysRemaining // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
