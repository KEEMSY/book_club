// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Promo {
  String get promoCode;
  int get discountPct;
  DateTime get validUntil;

  /// Create a copy of Promo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PromoCopyWith<Promo> get copyWith =>
      _$PromoCopyWithImpl<Promo>(this as Promo, _$identity);

  /// Serializes this Promo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Promo &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.discountPct, discountPct) ||
                other.discountPct == discountPct) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, promoCode, discountPct, validUntil);

  @override
  String toString() {
    return 'Promo(promoCode: $promoCode, discountPct: $discountPct, validUntil: $validUntil)';
  }
}

/// @nodoc
abstract mixin class $PromoCopyWith<$Res> {
  factory $PromoCopyWith(Promo value, $Res Function(Promo) _then) =
      _$PromoCopyWithImpl;
  @useResult
  $Res call({String promoCode, int discountPct, DateTime validUntil});
}

/// @nodoc
class _$PromoCopyWithImpl<$Res> implements $PromoCopyWith<$Res> {
  _$PromoCopyWithImpl(this._self, this._then);

  final Promo _self;
  final $Res Function(Promo) _then;

  /// Create a copy of Promo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promoCode = null,
    Object? discountPct = null,
    Object? validUntil = null,
  }) {
    return _then(_self.copyWith(
      promoCode: null == promoCode
          ? _self.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String,
      discountPct: null == discountPct
          ? _self.discountPct
          : discountPct // ignore: cast_nullable_to_non_nullable
              as int,
      validUntil: null == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Promo].
extension PromoPatterns on Promo {
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
    TResult Function(_Promo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Promo() when $default != null:
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
    TResult Function(_Promo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Promo():
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
    TResult? Function(_Promo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Promo() when $default != null:
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
    TResult Function(String promoCode, int discountPct, DateTime validUntil)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Promo() when $default != null:
        return $default(_that.promoCode, _that.discountPct, _that.validUntil);
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
    TResult Function(String promoCode, int discountPct, DateTime validUntil)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Promo():
        return $default(_that.promoCode, _that.discountPct, _that.validUntil);
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
    TResult? Function(String promoCode, int discountPct, DateTime validUntil)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Promo() when $default != null:
        return $default(_that.promoCode, _that.discountPct, _that.validUntil);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Promo implements Promo {
  const _Promo(
      {required this.promoCode,
      required this.discountPct,
      required this.validUntil});
  factory _Promo.fromJson(Map<String, dynamic> json) => _$PromoFromJson(json);

  @override
  final String promoCode;
  @override
  final int discountPct;
  @override
  final DateTime validUntil;

  /// Create a copy of Promo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PromoCopyWith<_Promo> get copyWith =>
      __$PromoCopyWithImpl<_Promo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PromoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Promo &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.discountPct, discountPct) ||
                other.discountPct == discountPct) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, promoCode, discountPct, validUntil);

  @override
  String toString() {
    return 'Promo(promoCode: $promoCode, discountPct: $discountPct, validUntil: $validUntil)';
  }
}

/// @nodoc
abstract mixin class _$PromoCopyWith<$Res> implements $PromoCopyWith<$Res> {
  factory _$PromoCopyWith(_Promo value, $Res Function(_Promo) _then) =
      __$PromoCopyWithImpl;
  @override
  @useResult
  $Res call({String promoCode, int discountPct, DateTime validUntil});
}

/// @nodoc
class __$PromoCopyWithImpl<$Res> implements _$PromoCopyWith<$Res> {
  __$PromoCopyWithImpl(this._self, this._then);

  final _Promo _self;
  final $Res Function(_Promo) _then;

  /// Create a copy of Promo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? promoCode = null,
    Object? discountPct = null,
    Object? validUntil = null,
  }) {
    return _then(_Promo(
      promoCode: null == promoCode
          ? _self.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String,
      discountPct: null == discountPct
          ? _self.discountPct
          : discountPct // ignore: cast_nullable_to_non_nullable
              as int,
      validUntil: null == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
