// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionStatus {
  bool get isPro;
  DateTime? get proExpiresAt;
  String? get proProductId;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscriptionStatusCopyWith<SubscriptionStatus> get copyWith =>
      _$SubscriptionStatusCopyWithImpl<SubscriptionStatus>(
          this as SubscriptionStatus, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubscriptionStatus &&
            (identical(other.isPro, isPro) || other.isPro == isPro) &&
            (identical(other.proExpiresAt, proExpiresAt) ||
                other.proExpiresAt == proExpiresAt) &&
            (identical(other.proProductId, proProductId) ||
                other.proProductId == proProductId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isPro, proExpiresAt, proProductId);

  @override
  String toString() {
    return 'SubscriptionStatus(isPro: $isPro, proExpiresAt: $proExpiresAt, proProductId: $proProductId)';
  }
}

/// @nodoc
abstract mixin class $SubscriptionStatusCopyWith<$Res> {
  factory $SubscriptionStatusCopyWith(
          SubscriptionStatus value, $Res Function(SubscriptionStatus) _then) =
      _$SubscriptionStatusCopyWithImpl;
  @useResult
  $Res call({bool isPro, DateTime? proExpiresAt, String? proProductId});
}

/// @nodoc
class _$SubscriptionStatusCopyWithImpl<$Res>
    implements $SubscriptionStatusCopyWith<$Res> {
  _$SubscriptionStatusCopyWithImpl(this._self, this._then);

  final SubscriptionStatus _self;
  final $Res Function(SubscriptionStatus) _then;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPro = null,
    Object? proExpiresAt = freezed,
    Object? proProductId = freezed,
  }) {
    return _then(_self.copyWith(
      isPro: null == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool,
      proExpiresAt: freezed == proExpiresAt
          ? _self.proExpiresAt
          : proExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      proProductId: freezed == proProductId
          ? _self.proProductId
          : proProductId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubscriptionStatus].
extension SubscriptionStatusPatterns on SubscriptionStatus {
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
    TResult Function(_SubscriptionStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
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
    TResult Function(_SubscriptionStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus():
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
    TResult? Function(_SubscriptionStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
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
    TResult Function(bool isPro, DateTime? proExpiresAt, String? proProductId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
        return $default(_that.isPro, _that.proExpiresAt, _that.proProductId);
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
    TResult Function(bool isPro, DateTime? proExpiresAt, String? proProductId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus():
        return $default(_that.isPro, _that.proExpiresAt, _that.proProductId);
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
    TResult? Function(bool isPro, DateTime? proExpiresAt, String? proProductId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
        return $default(_that.isPro, _that.proExpiresAt, _that.proProductId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SubscriptionStatus implements SubscriptionStatus {
  const _SubscriptionStatus(
      {this.isPro = false, this.proExpiresAt, this.proProductId});

  @override
  @JsonKey()
  final bool isPro;
  @override
  final DateTime? proExpiresAt;
  @override
  final String? proProductId;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscriptionStatusCopyWith<_SubscriptionStatus> get copyWith =>
      __$SubscriptionStatusCopyWithImpl<_SubscriptionStatus>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubscriptionStatus &&
            (identical(other.isPro, isPro) || other.isPro == isPro) &&
            (identical(other.proExpiresAt, proExpiresAt) ||
                other.proExpiresAt == proExpiresAt) &&
            (identical(other.proProductId, proProductId) ||
                other.proProductId == proProductId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isPro, proExpiresAt, proProductId);

  @override
  String toString() {
    return 'SubscriptionStatus(isPro: $isPro, proExpiresAt: $proExpiresAt, proProductId: $proProductId)';
  }
}

/// @nodoc
abstract mixin class _$SubscriptionStatusCopyWith<$Res>
    implements $SubscriptionStatusCopyWith<$Res> {
  factory _$SubscriptionStatusCopyWith(
          _SubscriptionStatus value, $Res Function(_SubscriptionStatus) _then) =
      __$SubscriptionStatusCopyWithImpl;
  @override
  @useResult
  $Res call({bool isPro, DateTime? proExpiresAt, String? proProductId});
}

/// @nodoc
class __$SubscriptionStatusCopyWithImpl<$Res>
    implements _$SubscriptionStatusCopyWith<$Res> {
  __$SubscriptionStatusCopyWithImpl(this._self, this._then);

  final _SubscriptionStatus _self;
  final $Res Function(_SubscriptionStatus) _then;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isPro = null,
    Object? proExpiresAt = freezed,
    Object? proProductId = freezed,
  }) {
    return _then(_SubscriptionStatus(
      isPro: null == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool,
      proExpiresAt: freezed == proExpiresAt
          ? _self.proExpiresAt
          : proExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      proProductId: freezed == proProductId
          ? _self.proProductId
          : proProductId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
