// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminStatsDto {
  int get mau;
  int get dau; // `field_rename: snake` (build.yaml) cannot recover the underscore in
// front of a leading digit ("7d"), so this key is pinned explicitly to
// match the backend's `new_users_7d`.
  @JsonKey(name: 'new_users_7d')
  int get newUsers7d;
  int get proUsers;

  /// Create a copy of AdminStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminStatsDtoCopyWith<AdminStatsDto> get copyWith =>
      _$AdminStatsDtoCopyWithImpl<AdminStatsDto>(
          this as AdminStatsDto, _$identity);

  /// Serializes this AdminStatsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminStatsDto &&
            (identical(other.mau, mau) || other.mau == mau) &&
            (identical(other.dau, dau) || other.dau == dau) &&
            (identical(other.newUsers7d, newUsers7d) ||
                other.newUsers7d == newUsers7d) &&
            (identical(other.proUsers, proUsers) ||
                other.proUsers == proUsers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mau, dau, newUsers7d, proUsers);

  @override
  String toString() {
    return 'AdminStatsDto(mau: $mau, dau: $dau, newUsers7d: $newUsers7d, proUsers: $proUsers)';
  }
}

/// @nodoc
abstract mixin class $AdminStatsDtoCopyWith<$Res> {
  factory $AdminStatsDtoCopyWith(
          AdminStatsDto value, $Res Function(AdminStatsDto) _then) =
      _$AdminStatsDtoCopyWithImpl;
  @useResult
  $Res call(
      {int mau,
      int dau,
      @JsonKey(name: 'new_users_7d') int newUsers7d,
      int proUsers});
}

/// @nodoc
class _$AdminStatsDtoCopyWithImpl<$Res>
    implements $AdminStatsDtoCopyWith<$Res> {
  _$AdminStatsDtoCopyWithImpl(this._self, this._then);

  final AdminStatsDto _self;
  final $Res Function(AdminStatsDto) _then;

  /// Create a copy of AdminStatsDto
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

/// Adds pattern-matching-related methods to [AdminStatsDto].
extension AdminStatsDtoPatterns on AdminStatsDto {
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
    TResult Function(_AdminStatsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStatsDto() when $default != null:
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
    TResult Function(_AdminStatsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsDto():
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
    TResult? Function(_AdminStatsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsDto() when $default != null:
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
    TResult Function(int mau, int dau,
            @JsonKey(name: 'new_users_7d') int newUsers7d, int proUsers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStatsDto() when $default != null:
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
    TResult Function(int mau, int dau,
            @JsonKey(name: 'new_users_7d') int newUsers7d, int proUsers)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsDto():
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
    TResult? Function(int mau, int dau,
            @JsonKey(name: 'new_users_7d') int newUsers7d, int proUsers)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsDto() when $default != null:
        return $default(_that.mau, _that.dau, _that.newUsers7d, _that.proUsers);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminStatsDto extends AdminStatsDto {
  const _AdminStatsDto(
      {required this.mau,
      required this.dau,
      @JsonKey(name: 'new_users_7d') required this.newUsers7d,
      required this.proUsers})
      : super._();
  factory _AdminStatsDto.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsDtoFromJson(json);

  @override
  final int mau;
  @override
  final int dau;
// `field_rename: snake` (build.yaml) cannot recover the underscore in
// front of a leading digit ("7d"), so this key is pinned explicitly to
// match the backend's `new_users_7d`.
  @override
  @JsonKey(name: 'new_users_7d')
  final int newUsers7d;
  @override
  final int proUsers;

  /// Create a copy of AdminStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminStatsDtoCopyWith<_AdminStatsDto> get copyWith =>
      __$AdminStatsDtoCopyWithImpl<_AdminStatsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminStatsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminStatsDto &&
            (identical(other.mau, mau) || other.mau == mau) &&
            (identical(other.dau, dau) || other.dau == dau) &&
            (identical(other.newUsers7d, newUsers7d) ||
                other.newUsers7d == newUsers7d) &&
            (identical(other.proUsers, proUsers) ||
                other.proUsers == proUsers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mau, dau, newUsers7d, proUsers);

  @override
  String toString() {
    return 'AdminStatsDto(mau: $mau, dau: $dau, newUsers7d: $newUsers7d, proUsers: $proUsers)';
  }
}

/// @nodoc
abstract mixin class _$AdminStatsDtoCopyWith<$Res>
    implements $AdminStatsDtoCopyWith<$Res> {
  factory _$AdminStatsDtoCopyWith(
          _AdminStatsDto value, $Res Function(_AdminStatsDto) _then) =
      __$AdminStatsDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int mau,
      int dau,
      @JsonKey(name: 'new_users_7d') int newUsers7d,
      int proUsers});
}

/// @nodoc
class __$AdminStatsDtoCopyWithImpl<$Res>
    implements _$AdminStatsDtoCopyWith<$Res> {
  __$AdminStatsDtoCopyWithImpl(this._self, this._then);

  final _AdminStatsDto _self;
  final $Res Function(_AdminStatsDto) _then;

  /// Create a copy of AdminStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mau = null,
    Object? dau = null,
    Object? newUsers7d = null,
    Object? proUsers = null,
  }) {
    return _then(_AdminStatsDto(
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

/// @nodoc
mixin _$ConversionFunnelDto {
  int get paywallViews;
  int get paywallClicks;
  int get subscriptions;
  double get conversionRate;

  /// Create a copy of ConversionFunnelDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversionFunnelDtoCopyWith<ConversionFunnelDto> get copyWith =>
      _$ConversionFunnelDtoCopyWithImpl<ConversionFunnelDto>(
          this as ConversionFunnelDto, _$identity);

  /// Serializes this ConversionFunnelDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversionFunnelDto &&
            (identical(other.paywallViews, paywallViews) ||
                other.paywallViews == paywallViews) &&
            (identical(other.paywallClicks, paywallClicks) ||
                other.paywallClicks == paywallClicks) &&
            (identical(other.subscriptions, subscriptions) ||
                other.subscriptions == subscriptions) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, paywallViews, paywallClicks, subscriptions, conversionRate);

  @override
  String toString() {
    return 'ConversionFunnelDto(paywallViews: $paywallViews, paywallClicks: $paywallClicks, subscriptions: $subscriptions, conversionRate: $conversionRate)';
  }
}

/// @nodoc
abstract mixin class $ConversionFunnelDtoCopyWith<$Res> {
  factory $ConversionFunnelDtoCopyWith(
          ConversionFunnelDto value, $Res Function(ConversionFunnelDto) _then) =
      _$ConversionFunnelDtoCopyWithImpl;
  @useResult
  $Res call(
      {int paywallViews,
      int paywallClicks,
      int subscriptions,
      double conversionRate});
}

/// @nodoc
class _$ConversionFunnelDtoCopyWithImpl<$Res>
    implements $ConversionFunnelDtoCopyWith<$Res> {
  _$ConversionFunnelDtoCopyWithImpl(this._self, this._then);

  final ConversionFunnelDto _self;
  final $Res Function(ConversionFunnelDto) _then;

  /// Create a copy of ConversionFunnelDto
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

/// Adds pattern-matching-related methods to [ConversionFunnelDto].
extension ConversionFunnelDtoPatterns on ConversionFunnelDto {
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
    TResult Function(_ConversionFunnelDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnelDto() when $default != null:
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
    TResult Function(_ConversionFunnelDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnelDto():
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
    TResult? Function(_ConversionFunnelDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversionFunnelDto() when $default != null:
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
      case _ConversionFunnelDto() when $default != null:
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
      case _ConversionFunnelDto():
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
      case _ConversionFunnelDto() when $default != null:
        return $default(_that.paywallViews, _that.paywallClicks,
            _that.subscriptions, _that.conversionRate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConversionFunnelDto extends ConversionFunnelDto {
  const _ConversionFunnelDto(
      {required this.paywallViews,
      required this.paywallClicks,
      required this.subscriptions,
      required this.conversionRate})
      : super._();
  factory _ConversionFunnelDto.fromJson(Map<String, dynamic> json) =>
      _$ConversionFunnelDtoFromJson(json);

  @override
  final int paywallViews;
  @override
  final int paywallClicks;
  @override
  final int subscriptions;
  @override
  final double conversionRate;

  /// Create a copy of ConversionFunnelDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversionFunnelDtoCopyWith<_ConversionFunnelDto> get copyWith =>
      __$ConversionFunnelDtoCopyWithImpl<_ConversionFunnelDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversionFunnelDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversionFunnelDto &&
            (identical(other.paywallViews, paywallViews) ||
                other.paywallViews == paywallViews) &&
            (identical(other.paywallClicks, paywallClicks) ||
                other.paywallClicks == paywallClicks) &&
            (identical(other.subscriptions, subscriptions) ||
                other.subscriptions == subscriptions) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, paywallViews, paywallClicks, subscriptions, conversionRate);

  @override
  String toString() {
    return 'ConversionFunnelDto(paywallViews: $paywallViews, paywallClicks: $paywallClicks, subscriptions: $subscriptions, conversionRate: $conversionRate)';
  }
}

/// @nodoc
abstract mixin class _$ConversionFunnelDtoCopyWith<$Res>
    implements $ConversionFunnelDtoCopyWith<$Res> {
  factory _$ConversionFunnelDtoCopyWith(_ConversionFunnelDto value,
          $Res Function(_ConversionFunnelDto) _then) =
      __$ConversionFunnelDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int paywallViews,
      int paywallClicks,
      int subscriptions,
      double conversionRate});
}

/// @nodoc
class __$ConversionFunnelDtoCopyWithImpl<$Res>
    implements _$ConversionFunnelDtoCopyWith<$Res> {
  __$ConversionFunnelDtoCopyWithImpl(this._self, this._then);

  final _ConversionFunnelDto _self;
  final $Res Function(_ConversionFunnelDto) _then;

  /// Create a copy of ConversionFunnelDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? paywallViews = null,
    Object? paywallClicks = null,
    Object? subscriptions = null,
    Object? conversionRate = null,
  }) {
    return _then(_ConversionFunnelDto(
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

/// @nodoc
mixin _$MonthlyMrrPointDto {
  String get month;
  double get mrr;

  /// Create a copy of MonthlyMrrPointDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyMrrPointDtoCopyWith<MonthlyMrrPointDto> get copyWith =>
      _$MonthlyMrrPointDtoCopyWithImpl<MonthlyMrrPointDto>(
          this as MonthlyMrrPointDto, _$identity);

  /// Serializes this MonthlyMrrPointDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyMrrPointDto &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.mrr, mrr) || other.mrr == mrr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, mrr);

  @override
  String toString() {
    return 'MonthlyMrrPointDto(month: $month, mrr: $mrr)';
  }
}

/// @nodoc
abstract mixin class $MonthlyMrrPointDtoCopyWith<$Res> {
  factory $MonthlyMrrPointDtoCopyWith(
          MonthlyMrrPointDto value, $Res Function(MonthlyMrrPointDto) _then) =
      _$MonthlyMrrPointDtoCopyWithImpl;
  @useResult
  $Res call({String month, double mrr});
}

/// @nodoc
class _$MonthlyMrrPointDtoCopyWithImpl<$Res>
    implements $MonthlyMrrPointDtoCopyWith<$Res> {
  _$MonthlyMrrPointDtoCopyWithImpl(this._self, this._then);

  final MonthlyMrrPointDto _self;
  final $Res Function(MonthlyMrrPointDto) _then;

  /// Create a copy of MonthlyMrrPointDto
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

/// Adds pattern-matching-related methods to [MonthlyMrrPointDto].
extension MonthlyMrrPointDtoPatterns on MonthlyMrrPointDto {
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
    TResult Function(_MonthlyMrrPointDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPointDto() when $default != null:
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
    TResult Function(_MonthlyMrrPointDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPointDto():
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
    TResult? Function(_MonthlyMrrPointDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyMrrPointDto() when $default != null:
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
      case _MonthlyMrrPointDto() when $default != null:
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
      case _MonthlyMrrPointDto():
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
      case _MonthlyMrrPointDto() when $default != null:
        return $default(_that.month, _that.mrr);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MonthlyMrrPointDto extends MonthlyMrrPointDto {
  const _MonthlyMrrPointDto({required this.month, required this.mrr})
      : super._();
  factory _MonthlyMrrPointDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyMrrPointDtoFromJson(json);

  @override
  final String month;
  @override
  final double mrr;

  /// Create a copy of MonthlyMrrPointDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlyMrrPointDtoCopyWith<_MonthlyMrrPointDto> get copyWith =>
      __$MonthlyMrrPointDtoCopyWithImpl<_MonthlyMrrPointDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MonthlyMrrPointDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlyMrrPointDto &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.mrr, mrr) || other.mrr == mrr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, mrr);

  @override
  String toString() {
    return 'MonthlyMrrPointDto(month: $month, mrr: $mrr)';
  }
}

/// @nodoc
abstract mixin class _$MonthlyMrrPointDtoCopyWith<$Res>
    implements $MonthlyMrrPointDtoCopyWith<$Res> {
  factory _$MonthlyMrrPointDtoCopyWith(
          _MonthlyMrrPointDto value, $Res Function(_MonthlyMrrPointDto) _then) =
      __$MonthlyMrrPointDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String month, double mrr});
}

/// @nodoc
class __$MonthlyMrrPointDtoCopyWithImpl<$Res>
    implements _$MonthlyMrrPointDtoCopyWith<$Res> {
  __$MonthlyMrrPointDtoCopyWithImpl(this._self, this._then);

  final _MonthlyMrrPointDto _self;
  final $Res Function(_MonthlyMrrPointDto) _then;

  /// Create a copy of MonthlyMrrPointDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? month = null,
    Object? mrr = null,
  }) {
    return _then(_MonthlyMrrPointDto(
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
mixin _$RevenueMetricsDto {
  double get mrr;
  double get arr;
  int get activeSubscribers; // Same digit-adjacency caveat as `newUsers7d` above — pin explicitly.
  @JsonKey(name: 'churned_30d')
  int get churned30d;
  double get teamMrr;
  List<MonthlyMrrPointDto> get monthlyTrend;

  /// Create a copy of RevenueMetricsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RevenueMetricsDtoCopyWith<RevenueMetricsDto> get copyWith =>
      _$RevenueMetricsDtoCopyWithImpl<RevenueMetricsDto>(
          this as RevenueMetricsDto, _$identity);

  /// Serializes this RevenueMetricsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RevenueMetricsDto &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mrr, arr, activeSubscribers,
      churned30d, teamMrr, const DeepCollectionEquality().hash(monthlyTrend));

  @override
  String toString() {
    return 'RevenueMetricsDto(mrr: $mrr, arr: $arr, activeSubscribers: $activeSubscribers, churned30d: $churned30d, teamMrr: $teamMrr, monthlyTrend: $monthlyTrend)';
  }
}

/// @nodoc
abstract mixin class $RevenueMetricsDtoCopyWith<$Res> {
  factory $RevenueMetricsDtoCopyWith(
          RevenueMetricsDto value, $Res Function(RevenueMetricsDto) _then) =
      _$RevenueMetricsDtoCopyWithImpl;
  @useResult
  $Res call(
      {double mrr,
      double arr,
      int activeSubscribers,
      @JsonKey(name: 'churned_30d') int churned30d,
      double teamMrr,
      List<MonthlyMrrPointDto> monthlyTrend});
}

/// @nodoc
class _$RevenueMetricsDtoCopyWithImpl<$Res>
    implements $RevenueMetricsDtoCopyWith<$Res> {
  _$RevenueMetricsDtoCopyWithImpl(this._self, this._then);

  final RevenueMetricsDto _self;
  final $Res Function(RevenueMetricsDto) _then;

  /// Create a copy of RevenueMetricsDto
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
              as List<MonthlyMrrPointDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RevenueMetricsDto].
extension RevenueMetricsDtoPatterns on RevenueMetricsDto {
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
    TResult Function(_RevenueMetricsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RevenueMetricsDto() when $default != null:
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
    TResult Function(_RevenueMetricsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetricsDto():
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
    TResult? Function(_RevenueMetricsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetricsDto() when $default != null:
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
            double mrr,
            double arr,
            int activeSubscribers,
            @JsonKey(name: 'churned_30d') int churned30d,
            double teamMrr,
            List<MonthlyMrrPointDto> monthlyTrend)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RevenueMetricsDto() when $default != null:
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
    TResult Function(
            double mrr,
            double arr,
            int activeSubscribers,
            @JsonKey(name: 'churned_30d') int churned30d,
            double teamMrr,
            List<MonthlyMrrPointDto> monthlyTrend)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetricsDto():
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
    TResult? Function(
            double mrr,
            double arr,
            int activeSubscribers,
            @JsonKey(name: 'churned_30d') int churned30d,
            double teamMrr,
            List<MonthlyMrrPointDto> monthlyTrend)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RevenueMetricsDto() when $default != null:
        return $default(_that.mrr, _that.arr, _that.activeSubscribers,
            _that.churned30d, _that.teamMrr, _that.monthlyTrend);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RevenueMetricsDto extends RevenueMetricsDto {
  const _RevenueMetricsDto(
      {required this.mrr,
      required this.arr,
      required this.activeSubscribers,
      @JsonKey(name: 'churned_30d') required this.churned30d,
      required this.teamMrr,
      required final List<MonthlyMrrPointDto> monthlyTrend})
      : _monthlyTrend = monthlyTrend,
        super._();
  factory _RevenueMetricsDto.fromJson(Map<String, dynamic> json) =>
      _$RevenueMetricsDtoFromJson(json);

  @override
  final double mrr;
  @override
  final double arr;
  @override
  final int activeSubscribers;
// Same digit-adjacency caveat as `newUsers7d` above — pin explicitly.
  @override
  @JsonKey(name: 'churned_30d')
  final int churned30d;
  @override
  final double teamMrr;
  final List<MonthlyMrrPointDto> _monthlyTrend;
  @override
  List<MonthlyMrrPointDto> get monthlyTrend {
    if (_monthlyTrend is EqualUnmodifiableListView) return _monthlyTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyTrend);
  }

  /// Create a copy of RevenueMetricsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RevenueMetricsDtoCopyWith<_RevenueMetricsDto> get copyWith =>
      __$RevenueMetricsDtoCopyWithImpl<_RevenueMetricsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RevenueMetricsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RevenueMetricsDto &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mrr, arr, activeSubscribers,
      churned30d, teamMrr, const DeepCollectionEquality().hash(_monthlyTrend));

  @override
  String toString() {
    return 'RevenueMetricsDto(mrr: $mrr, arr: $arr, activeSubscribers: $activeSubscribers, churned30d: $churned30d, teamMrr: $teamMrr, monthlyTrend: $monthlyTrend)';
  }
}

/// @nodoc
abstract mixin class _$RevenueMetricsDtoCopyWith<$Res>
    implements $RevenueMetricsDtoCopyWith<$Res> {
  factory _$RevenueMetricsDtoCopyWith(
          _RevenueMetricsDto value, $Res Function(_RevenueMetricsDto) _then) =
      __$RevenueMetricsDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double mrr,
      double arr,
      int activeSubscribers,
      @JsonKey(name: 'churned_30d') int churned30d,
      double teamMrr,
      List<MonthlyMrrPointDto> monthlyTrend});
}

/// @nodoc
class __$RevenueMetricsDtoCopyWithImpl<$Res>
    implements _$RevenueMetricsDtoCopyWith<$Res> {
  __$RevenueMetricsDtoCopyWithImpl(this._self, this._then);

  final _RevenueMetricsDto _self;
  final $Res Function(_RevenueMetricsDto) _then;

  /// Create a copy of RevenueMetricsDto
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
    return _then(_RevenueMetricsDto(
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
              as List<MonthlyMrrPointDto>,
    ));
  }
}

/// @nodoc
mixin _$AdminUserDto {
  String get id;
  String get nickname;
  String? get email;
  bool get isActive;
  bool get isAdmin;
  bool get isPro;
  DateTime get createdAt;

  /// Create a copy of AdminUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminUserDtoCopyWith<AdminUserDto> get copyWith =>
      _$AdminUserDtoCopyWithImpl<AdminUserDto>(
          this as AdminUserDto, _$identity);

  /// Serializes this AdminUserDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminUserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.isPro, isPro) || other.isPro == isPro) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nickname, email, isActive, isAdmin, isPro, createdAt);

  @override
  String toString() {
    return 'AdminUserDto(id: $id, nickname: $nickname, email: $email, isActive: $isActive, isAdmin: $isAdmin, isPro: $isPro, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AdminUserDtoCopyWith<$Res> {
  factory $AdminUserDtoCopyWith(
          AdminUserDto value, $Res Function(AdminUserDto) _then) =
      _$AdminUserDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? email,
      bool isActive,
      bool isAdmin,
      bool isPro,
      DateTime createdAt});
}

/// @nodoc
class _$AdminUserDtoCopyWithImpl<$Res> implements $AdminUserDtoCopyWith<$Res> {
  _$AdminUserDtoCopyWithImpl(this._self, this._then);

  final AdminUserDto _self;
  final $Res Function(AdminUserDto) _then;

  /// Create a copy of AdminUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? email = freezed,
    Object? isActive = null,
    Object? isAdmin = null,
    Object? isPro = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isPro: null == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminUserDto].
extension AdminUserDtoPatterns on AdminUserDto {
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
    TResult Function(_AdminUserDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminUserDto() when $default != null:
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
    TResult Function(_AdminUserDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserDto():
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
    TResult? Function(_AdminUserDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserDto() when $default != null:
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
    TResult Function(String id, String nickname, String? email, bool isActive,
            bool isAdmin, bool isPro, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminUserDto() when $default != null:
        return $default(_that.id, _that.nickname, _that.email, _that.isActive,
            _that.isAdmin, _that.isPro, _that.createdAt);
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
    TResult Function(String id, String nickname, String? email, bool isActive,
            bool isAdmin, bool isPro, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserDto():
        return $default(_that.id, _that.nickname, _that.email, _that.isActive,
            _that.isAdmin, _that.isPro, _that.createdAt);
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
    TResult? Function(String id, String nickname, String? email, bool isActive,
            bool isAdmin, bool isPro, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserDto() when $default != null:
        return $default(_that.id, _that.nickname, _that.email, _that.isActive,
            _that.isAdmin, _that.isPro, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminUserDto extends AdminUserDto {
  const _AdminUserDto(
      {required this.id,
      required this.nickname,
      this.email,
      required this.isActive,
      required this.isAdmin,
      required this.isPro,
      required this.createdAt})
      : super._();
  factory _AdminUserDto.fromJson(Map<String, dynamic> json) =>
      _$AdminUserDtoFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? email;
  @override
  final bool isActive;
  @override
  final bool isAdmin;
  @override
  final bool isPro;
  @override
  final DateTime createdAt;

  /// Create a copy of AdminUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminUserDtoCopyWith<_AdminUserDto> get copyWith =>
      __$AdminUserDtoCopyWithImpl<_AdminUserDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminUserDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminUserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.isPro, isPro) || other.isPro == isPro) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nickname, email, isActive, isAdmin, isPro, createdAt);

  @override
  String toString() {
    return 'AdminUserDto(id: $id, nickname: $nickname, email: $email, isActive: $isActive, isAdmin: $isAdmin, isPro: $isPro, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AdminUserDtoCopyWith<$Res>
    implements $AdminUserDtoCopyWith<$Res> {
  factory _$AdminUserDtoCopyWith(
          _AdminUserDto value, $Res Function(_AdminUserDto) _then) =
      __$AdminUserDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? email,
      bool isActive,
      bool isAdmin,
      bool isPro,
      DateTime createdAt});
}

/// @nodoc
class __$AdminUserDtoCopyWithImpl<$Res>
    implements _$AdminUserDtoCopyWith<$Res> {
  __$AdminUserDtoCopyWithImpl(this._self, this._then);

  final _AdminUserDto _self;
  final $Res Function(_AdminUserDto) _then;

  /// Create a copy of AdminUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? email = freezed,
    Object? isActive = null,
    Object? isAdmin = null,
    Object? isPro = null,
    Object? createdAt = null,
  }) {
    return _then(_AdminUserDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isPro: null == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$AdminUserPageDto {
  List<AdminUserDto> get items;
  int get total;
  int get page;
  int get pageSize;

  /// Create a copy of AdminUserPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminUserPageDtoCopyWith<AdminUserPageDto> get copyWith =>
      _$AdminUserPageDtoCopyWithImpl<AdminUserPageDto>(
          this as AdminUserPageDto, _$identity);

  /// Serializes this AdminUserPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminUserPageDto &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), total, page, pageSize);

  @override
  String toString() {
    return 'AdminUserPageDto(items: $items, total: $total, page: $page, pageSize: $pageSize)';
  }
}

/// @nodoc
abstract mixin class $AdminUserPageDtoCopyWith<$Res> {
  factory $AdminUserPageDtoCopyWith(
          AdminUserPageDto value, $Res Function(AdminUserPageDto) _then) =
      _$AdminUserPageDtoCopyWithImpl;
  @useResult
  $Res call({List<AdminUserDto> items, int total, int page, int pageSize});
}

/// @nodoc
class _$AdminUserPageDtoCopyWithImpl<$Res>
    implements $AdminUserPageDtoCopyWith<$Res> {
  _$AdminUserPageDtoCopyWithImpl(this._self, this._then);

  final AdminUserPageDto _self;
  final $Res Function(AdminUserPageDto) _then;

  /// Create a copy of AdminUserPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AdminUserDto>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _self.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminUserPageDto].
extension AdminUserPageDtoPatterns on AdminUserPageDto {
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
    TResult Function(_AdminUserPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminUserPageDto() when $default != null:
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
    TResult Function(_AdminUserPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserPageDto():
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
    TResult? Function(_AdminUserPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserPageDto() when $default != null:
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
            List<AdminUserDto> items, int total, int page, int pageSize)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminUserPageDto() when $default != null:
        return $default(_that.items, _that.total, _that.page, _that.pageSize);
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
            List<AdminUserDto> items, int total, int page, int pageSize)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserPageDto():
        return $default(_that.items, _that.total, _that.page, _that.pageSize);
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
            List<AdminUserDto> items, int total, int page, int pageSize)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminUserPageDto() when $default != null:
        return $default(_that.items, _that.total, _that.page, _that.pageSize);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminUserPageDto implements AdminUserPageDto {
  const _AdminUserPageDto(
      {required final List<AdminUserDto> items,
      required this.total,
      required this.page,
      required this.pageSize})
      : _items = items;
  factory _AdminUserPageDto.fromJson(Map<String, dynamic> json) =>
      _$AdminUserPageDtoFromJson(json);

  final List<AdminUserDto> _items;
  @override
  List<AdminUserDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int pageSize;

  /// Create a copy of AdminUserPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminUserPageDtoCopyWith<_AdminUserPageDto> get copyWith =>
      __$AdminUserPageDtoCopyWithImpl<_AdminUserPageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminUserPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminUserPageDto &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), total, page, pageSize);

  @override
  String toString() {
    return 'AdminUserPageDto(items: $items, total: $total, page: $page, pageSize: $pageSize)';
  }
}

/// @nodoc
abstract mixin class _$AdminUserPageDtoCopyWith<$Res>
    implements $AdminUserPageDtoCopyWith<$Res> {
  factory _$AdminUserPageDtoCopyWith(
          _AdminUserPageDto value, $Res Function(_AdminUserPageDto) _then) =
      __$AdminUserPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<AdminUserDto> items, int total, int page, int pageSize});
}

/// @nodoc
class __$AdminUserPageDtoCopyWithImpl<$Res>
    implements _$AdminUserPageDtoCopyWith<$Res> {
  __$AdminUserPageDtoCopyWithImpl(this._self, this._then);

  final _AdminUserPageDto _self;
  final $Res Function(_AdminUserPageDto) _then;

  /// Create a copy of AdminUserPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(_AdminUserPageDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AdminUserDto>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _self.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
