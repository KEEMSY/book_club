// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shield_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShieldBalanceDto {
  int get streakShields;

  /// Create a copy of ShieldBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShieldBalanceDtoCopyWith<ShieldBalanceDto> get copyWith =>
      _$ShieldBalanceDtoCopyWithImpl<ShieldBalanceDto>(
          this as ShieldBalanceDto, _$identity);

  /// Serializes this ShieldBalanceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShieldBalanceDto &&
            (identical(other.streakShields, streakShields) ||
                other.streakShields == streakShields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, streakShields);

  @override
  String toString() {
    return 'ShieldBalanceDto(streakShields: $streakShields)';
  }
}

/// @nodoc
abstract mixin class $ShieldBalanceDtoCopyWith<$Res> {
  factory $ShieldBalanceDtoCopyWith(
          ShieldBalanceDto value, $Res Function(ShieldBalanceDto) _then) =
      _$ShieldBalanceDtoCopyWithImpl;
  @useResult
  $Res call({int streakShields});
}

/// @nodoc
class _$ShieldBalanceDtoCopyWithImpl<$Res>
    implements $ShieldBalanceDtoCopyWith<$Res> {
  _$ShieldBalanceDtoCopyWithImpl(this._self, this._then);

  final ShieldBalanceDto _self;
  final $Res Function(ShieldBalanceDto) _then;

  /// Create a copy of ShieldBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streakShields = null,
  }) {
    return _then(_self.copyWith(
      streakShields: null == streakShields
          ? _self.streakShields
          : streakShields // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShieldBalanceDto].
extension ShieldBalanceDtoPatterns on ShieldBalanceDto {
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
    TResult Function(_ShieldBalanceDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShieldBalanceDto() when $default != null:
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
    TResult Function(_ShieldBalanceDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldBalanceDto():
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
    TResult? Function(_ShieldBalanceDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldBalanceDto() when $default != null:
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
    TResult Function(int streakShields)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShieldBalanceDto() when $default != null:
        return $default(_that.streakShields);
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
    TResult Function(int streakShields) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldBalanceDto():
        return $default(_that.streakShields);
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
    TResult? Function(int streakShields)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldBalanceDto() when $default != null:
        return $default(_that.streakShields);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ShieldBalanceDto implements ShieldBalanceDto {
  const _ShieldBalanceDto({required this.streakShields});
  factory _ShieldBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$ShieldBalanceDtoFromJson(json);

  @override
  final int streakShields;

  /// Create a copy of ShieldBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShieldBalanceDtoCopyWith<_ShieldBalanceDto> get copyWith =>
      __$ShieldBalanceDtoCopyWithImpl<_ShieldBalanceDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShieldBalanceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShieldBalanceDto &&
            (identical(other.streakShields, streakShields) ||
                other.streakShields == streakShields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, streakShields);

  @override
  String toString() {
    return 'ShieldBalanceDto(streakShields: $streakShields)';
  }
}

/// @nodoc
abstract mixin class _$ShieldBalanceDtoCopyWith<$Res>
    implements $ShieldBalanceDtoCopyWith<$Res> {
  factory _$ShieldBalanceDtoCopyWith(
          _ShieldBalanceDto value, $Res Function(_ShieldBalanceDto) _then) =
      __$ShieldBalanceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int streakShields});
}

/// @nodoc
class __$ShieldBalanceDtoCopyWithImpl<$Res>
    implements _$ShieldBalanceDtoCopyWith<$Res> {
  __$ShieldBalanceDtoCopyWithImpl(this._self, this._then);

  final _ShieldBalanceDto _self;
  final $Res Function(_ShieldBalanceDto) _then;

  /// Create a copy of ShieldBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? streakShields = null,
  }) {
    return _then(_ShieldBalanceDto(
      streakShields: null == streakShields
          ? _self.streakShields
          : streakShields // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$PurchaseShieldRequestDto {
  String get productId;
  String get receiptData;

  /// Create a copy of PurchaseShieldRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseShieldRequestDtoCopyWith<PurchaseShieldRequestDto> get copyWith =>
      _$PurchaseShieldRequestDtoCopyWithImpl<PurchaseShieldRequestDto>(
          this as PurchaseShieldRequestDto, _$identity);

  /// Serializes this PurchaseShieldRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseShieldRequestDto &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.receiptData, receiptData) ||
                other.receiptData == receiptData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, receiptData);

  @override
  String toString() {
    return 'PurchaseShieldRequestDto(productId: $productId, receiptData: $receiptData)';
  }
}

/// @nodoc
abstract mixin class $PurchaseShieldRequestDtoCopyWith<$Res> {
  factory $PurchaseShieldRequestDtoCopyWith(PurchaseShieldRequestDto value,
          $Res Function(PurchaseShieldRequestDto) _then) =
      _$PurchaseShieldRequestDtoCopyWithImpl;
  @useResult
  $Res call({String productId, String receiptData});
}

/// @nodoc
class _$PurchaseShieldRequestDtoCopyWithImpl<$Res>
    implements $PurchaseShieldRequestDtoCopyWith<$Res> {
  _$PurchaseShieldRequestDtoCopyWithImpl(this._self, this._then);

  final PurchaseShieldRequestDto _self;
  final $Res Function(PurchaseShieldRequestDto) _then;

  /// Create a copy of PurchaseShieldRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? receiptData = null,
  }) {
    return _then(_self.copyWith(
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      receiptData: null == receiptData
          ? _self.receiptData
          : receiptData // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PurchaseShieldRequestDto].
extension PurchaseShieldRequestDtoPatterns on PurchaseShieldRequestDto {
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
    TResult Function(_PurchaseShieldRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseShieldRequestDto() when $default != null:
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
    TResult Function(_PurchaseShieldRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseShieldRequestDto():
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
    TResult? Function(_PurchaseShieldRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseShieldRequestDto() when $default != null:
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
    TResult Function(String productId, String receiptData)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseShieldRequestDto() when $default != null:
        return $default(_that.productId, _that.receiptData);
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
    TResult Function(String productId, String receiptData) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseShieldRequestDto():
        return $default(_that.productId, _that.receiptData);
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
    TResult? Function(String productId, String receiptData)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseShieldRequestDto() when $default != null:
        return $default(_that.productId, _that.receiptData);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseShieldRequestDto implements PurchaseShieldRequestDto {
  const _PurchaseShieldRequestDto(
      {required this.productId, required this.receiptData});
  factory _PurchaseShieldRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseShieldRequestDtoFromJson(json);

  @override
  final String productId;
  @override
  final String receiptData;

  /// Create a copy of PurchaseShieldRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseShieldRequestDtoCopyWith<_PurchaseShieldRequestDto> get copyWith =>
      __$PurchaseShieldRequestDtoCopyWithImpl<_PurchaseShieldRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseShieldRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseShieldRequestDto &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.receiptData, receiptData) ||
                other.receiptData == receiptData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, receiptData);

  @override
  String toString() {
    return 'PurchaseShieldRequestDto(productId: $productId, receiptData: $receiptData)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseShieldRequestDtoCopyWith<$Res>
    implements $PurchaseShieldRequestDtoCopyWith<$Res> {
  factory _$PurchaseShieldRequestDtoCopyWith(_PurchaseShieldRequestDto value,
          $Res Function(_PurchaseShieldRequestDto) _then) =
      __$PurchaseShieldRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String productId, String receiptData});
}

/// @nodoc
class __$PurchaseShieldRequestDtoCopyWithImpl<$Res>
    implements _$PurchaseShieldRequestDtoCopyWith<$Res> {
  __$PurchaseShieldRequestDtoCopyWithImpl(this._self, this._then);

  final _PurchaseShieldRequestDto _self;
  final $Res Function(_PurchaseShieldRequestDto) _then;

  /// Create a copy of PurchaseShieldRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? productId = null,
    Object? receiptData = null,
  }) {
    return _then(_PurchaseShieldRequestDto(
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      receiptData: null == receiptData
          ? _self.receiptData
          : receiptData // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ShieldPurchaseResultDto {
  int get shieldsGranted;
  int get totalShields;

  /// Create a copy of ShieldPurchaseResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShieldPurchaseResultDtoCopyWith<ShieldPurchaseResultDto> get copyWith =>
      _$ShieldPurchaseResultDtoCopyWithImpl<ShieldPurchaseResultDto>(
          this as ShieldPurchaseResultDto, _$identity);

  /// Serializes this ShieldPurchaseResultDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShieldPurchaseResultDto &&
            (identical(other.shieldsGranted, shieldsGranted) ||
                other.shieldsGranted == shieldsGranted) &&
            (identical(other.totalShields, totalShields) ||
                other.totalShields == totalShields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shieldsGranted, totalShields);

  @override
  String toString() {
    return 'ShieldPurchaseResultDto(shieldsGranted: $shieldsGranted, totalShields: $totalShields)';
  }
}

/// @nodoc
abstract mixin class $ShieldPurchaseResultDtoCopyWith<$Res> {
  factory $ShieldPurchaseResultDtoCopyWith(ShieldPurchaseResultDto value,
          $Res Function(ShieldPurchaseResultDto) _then) =
      _$ShieldPurchaseResultDtoCopyWithImpl;
  @useResult
  $Res call({int shieldsGranted, int totalShields});
}

/// @nodoc
class _$ShieldPurchaseResultDtoCopyWithImpl<$Res>
    implements $ShieldPurchaseResultDtoCopyWith<$Res> {
  _$ShieldPurchaseResultDtoCopyWithImpl(this._self, this._then);

  final ShieldPurchaseResultDto _self;
  final $Res Function(ShieldPurchaseResultDto) _then;

  /// Create a copy of ShieldPurchaseResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shieldsGranted = null,
    Object? totalShields = null,
  }) {
    return _then(_self.copyWith(
      shieldsGranted: null == shieldsGranted
          ? _self.shieldsGranted
          : shieldsGranted // ignore: cast_nullable_to_non_nullable
              as int,
      totalShields: null == totalShields
          ? _self.totalShields
          : totalShields // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShieldPurchaseResultDto].
extension ShieldPurchaseResultDtoPatterns on ShieldPurchaseResultDto {
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
    TResult Function(_ShieldPurchaseResultDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShieldPurchaseResultDto() when $default != null:
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
    TResult Function(_ShieldPurchaseResultDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldPurchaseResultDto():
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
    TResult? Function(_ShieldPurchaseResultDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldPurchaseResultDto() when $default != null:
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
    TResult Function(int shieldsGranted, int totalShields)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShieldPurchaseResultDto() when $default != null:
        return $default(_that.shieldsGranted, _that.totalShields);
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
    TResult Function(int shieldsGranted, int totalShields) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldPurchaseResultDto():
        return $default(_that.shieldsGranted, _that.totalShields);
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
    TResult? Function(int shieldsGranted, int totalShields)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShieldPurchaseResultDto() when $default != null:
        return $default(_that.shieldsGranted, _that.totalShields);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ShieldPurchaseResultDto implements ShieldPurchaseResultDto {
  const _ShieldPurchaseResultDto(
      {required this.shieldsGranted, required this.totalShields});
  factory _ShieldPurchaseResultDto.fromJson(Map<String, dynamic> json) =>
      _$ShieldPurchaseResultDtoFromJson(json);

  @override
  final int shieldsGranted;
  @override
  final int totalShields;

  /// Create a copy of ShieldPurchaseResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShieldPurchaseResultDtoCopyWith<_ShieldPurchaseResultDto> get copyWith =>
      __$ShieldPurchaseResultDtoCopyWithImpl<_ShieldPurchaseResultDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShieldPurchaseResultDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShieldPurchaseResultDto &&
            (identical(other.shieldsGranted, shieldsGranted) ||
                other.shieldsGranted == shieldsGranted) &&
            (identical(other.totalShields, totalShields) ||
                other.totalShields == totalShields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shieldsGranted, totalShields);

  @override
  String toString() {
    return 'ShieldPurchaseResultDto(shieldsGranted: $shieldsGranted, totalShields: $totalShields)';
  }
}

/// @nodoc
abstract mixin class _$ShieldPurchaseResultDtoCopyWith<$Res>
    implements $ShieldPurchaseResultDtoCopyWith<$Res> {
  factory _$ShieldPurchaseResultDtoCopyWith(_ShieldPurchaseResultDto value,
          $Res Function(_ShieldPurchaseResultDto) _then) =
      __$ShieldPurchaseResultDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int shieldsGranted, int totalShields});
}

/// @nodoc
class __$ShieldPurchaseResultDtoCopyWithImpl<$Res>
    implements _$ShieldPurchaseResultDtoCopyWith<$Res> {
  __$ShieldPurchaseResultDtoCopyWithImpl(this._self, this._then);

  final _ShieldPurchaseResultDto _self;
  final $Res Function(_ShieldPurchaseResultDto) _then;

  /// Create a copy of ShieldPurchaseResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? shieldsGranted = null,
    Object? totalShields = null,
  }) {
    return _then(_ShieldPurchaseResultDto(
      shieldsGranted: null == shieldsGranted
          ? _self.shieldsGranted
          : shieldsGranted // ignore: cast_nullable_to_non_nullable
              as int,
      totalShields: null == totalShields
          ? _self.totalShields
          : totalShields // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
