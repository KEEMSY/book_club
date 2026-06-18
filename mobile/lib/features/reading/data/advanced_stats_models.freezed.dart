// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_stats_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeedTrendItem {
  DateTime get weekStart;
  double get minutesPerPage;

  /// Create a copy of SpeedTrendItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpeedTrendItemCopyWith<SpeedTrendItem> get copyWith =>
      _$SpeedTrendItemCopyWithImpl<SpeedTrendItem>(
          this as SpeedTrendItem, _$identity);

  /// Serializes this SpeedTrendItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpeedTrendItem &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.minutesPerPage, minutesPerPage) ||
                other.minutesPerPage == minutesPerPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, weekStart, minutesPerPage);

  @override
  String toString() {
    return 'SpeedTrendItem(weekStart: $weekStart, minutesPerPage: $minutesPerPage)';
  }
}

/// @nodoc
abstract mixin class $SpeedTrendItemCopyWith<$Res> {
  factory $SpeedTrendItemCopyWith(
          SpeedTrendItem value, $Res Function(SpeedTrendItem) _then) =
      _$SpeedTrendItemCopyWithImpl;
  @useResult
  $Res call({DateTime weekStart, double minutesPerPage});
}

/// @nodoc
class _$SpeedTrendItemCopyWithImpl<$Res>
    implements $SpeedTrendItemCopyWith<$Res> {
  _$SpeedTrendItemCopyWithImpl(this._self, this._then);

  final SpeedTrendItem _self;
  final $Res Function(SpeedTrendItem) _then;

  /// Create a copy of SpeedTrendItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? minutesPerPage = null,
  }) {
    return _then(_self.copyWith(
      weekStart: null == weekStart
          ? _self.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      minutesPerPage: null == minutesPerPage
          ? _self.minutesPerPage
          : minutesPerPage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [SpeedTrendItem].
extension SpeedTrendItemPatterns on SpeedTrendItem {
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
    TResult Function(_SpeedTrendItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpeedTrendItem() when $default != null:
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
    TResult Function(_SpeedTrendItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpeedTrendItem():
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
    TResult? Function(_SpeedTrendItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpeedTrendItem() when $default != null:
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
    TResult Function(DateTime weekStart, double minutesPerPage)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpeedTrendItem() when $default != null:
        return $default(_that.weekStart, _that.minutesPerPage);
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
    TResult Function(DateTime weekStart, double minutesPerPage) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpeedTrendItem():
        return $default(_that.weekStart, _that.minutesPerPage);
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
    TResult? Function(DateTime weekStart, double minutesPerPage)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpeedTrendItem() when $default != null:
        return $default(_that.weekStart, _that.minutesPerPage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SpeedTrendItem implements SpeedTrendItem {
  const _SpeedTrendItem(
      {required this.weekStart, required this.minutesPerPage});
  factory _SpeedTrendItem.fromJson(Map<String, dynamic> json) =>
      _$SpeedTrendItemFromJson(json);

  @override
  final DateTime weekStart;
  @override
  final double minutesPerPage;

  /// Create a copy of SpeedTrendItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpeedTrendItemCopyWith<_SpeedTrendItem> get copyWith =>
      __$SpeedTrendItemCopyWithImpl<_SpeedTrendItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpeedTrendItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SpeedTrendItem &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.minutesPerPage, minutesPerPage) ||
                other.minutesPerPage == minutesPerPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, weekStart, minutesPerPage);

  @override
  String toString() {
    return 'SpeedTrendItem(weekStart: $weekStart, minutesPerPage: $minutesPerPage)';
  }
}

/// @nodoc
abstract mixin class _$SpeedTrendItemCopyWith<$Res>
    implements $SpeedTrendItemCopyWith<$Res> {
  factory _$SpeedTrendItemCopyWith(
          _SpeedTrendItem value, $Res Function(_SpeedTrendItem) _then) =
      __$SpeedTrendItemCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime weekStart, double minutesPerPage});
}

/// @nodoc
class __$SpeedTrendItemCopyWithImpl<$Res>
    implements _$SpeedTrendItemCopyWith<$Res> {
  __$SpeedTrendItemCopyWithImpl(this._self, this._then);

  final _SpeedTrendItem _self;
  final $Res Function(_SpeedTrendItem) _then;

  /// Create a copy of SpeedTrendItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? weekStart = null,
    Object? minutesPerPage = null,
  }) {
    return _then(_SpeedTrendItem(
      weekStart: null == weekStart
          ? _self.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      minutesPerPage: null == minutesPerPage
          ? _self.minutesPerPage
          : minutesPerPage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$GenreDistributionItem {
  String get genre;
  int get count;
  double get pct;

  /// Create a copy of GenreDistributionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GenreDistributionItemCopyWith<GenreDistributionItem> get copyWith =>
      _$GenreDistributionItemCopyWithImpl<GenreDistributionItem>(
          this as GenreDistributionItem, _$identity);

  /// Serializes this GenreDistributionItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GenreDistributionItem &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.pct, pct) || other.pct == pct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, genre, count, pct);

  @override
  String toString() {
    return 'GenreDistributionItem(genre: $genre, count: $count, pct: $pct)';
  }
}

/// @nodoc
abstract mixin class $GenreDistributionItemCopyWith<$Res> {
  factory $GenreDistributionItemCopyWith(GenreDistributionItem value,
          $Res Function(GenreDistributionItem) _then) =
      _$GenreDistributionItemCopyWithImpl;
  @useResult
  $Res call({String genre, int count, double pct});
}

/// @nodoc
class _$GenreDistributionItemCopyWithImpl<$Res>
    implements $GenreDistributionItemCopyWith<$Res> {
  _$GenreDistributionItemCopyWithImpl(this._self, this._then);

  final GenreDistributionItem _self;
  final $Res Function(GenreDistributionItem) _then;

  /// Create a copy of GenreDistributionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genre = null,
    Object? count = null,
    Object? pct = null,
  }) {
    return _then(_self.copyWith(
      genre: null == genre
          ? _self.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      pct: null == pct
          ? _self.pct
          : pct // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [GenreDistributionItem].
extension GenreDistributionItemPatterns on GenreDistributionItem {
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
    TResult Function(_GenreDistributionItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GenreDistributionItem() when $default != null:
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
    TResult Function(_GenreDistributionItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreDistributionItem():
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
    TResult? Function(_GenreDistributionItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreDistributionItem() when $default != null:
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
    TResult Function(String genre, int count, double pct)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GenreDistributionItem() when $default != null:
        return $default(_that.genre, _that.count, _that.pct);
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
    TResult Function(String genre, int count, double pct) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreDistributionItem():
        return $default(_that.genre, _that.count, _that.pct);
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
    TResult? Function(String genre, int count, double pct)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreDistributionItem() when $default != null:
        return $default(_that.genre, _that.count, _that.pct);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GenreDistributionItem implements GenreDistributionItem {
  const _GenreDistributionItem(
      {required this.genre, required this.count, required this.pct});
  factory _GenreDistributionItem.fromJson(Map<String, dynamic> json) =>
      _$GenreDistributionItemFromJson(json);

  @override
  final String genre;
  @override
  final int count;
  @override
  final double pct;

  /// Create a copy of GenreDistributionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GenreDistributionItemCopyWith<_GenreDistributionItem> get copyWith =>
      __$GenreDistributionItemCopyWithImpl<_GenreDistributionItem>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GenreDistributionItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GenreDistributionItem &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.pct, pct) || other.pct == pct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, genre, count, pct);

  @override
  String toString() {
    return 'GenreDistributionItem(genre: $genre, count: $count, pct: $pct)';
  }
}

/// @nodoc
abstract mixin class _$GenreDistributionItemCopyWith<$Res>
    implements $GenreDistributionItemCopyWith<$Res> {
  factory _$GenreDistributionItemCopyWith(_GenreDistributionItem value,
          $Res Function(_GenreDistributionItem) _then) =
      __$GenreDistributionItemCopyWithImpl;
  @override
  @useResult
  $Res call({String genre, int count, double pct});
}

/// @nodoc
class __$GenreDistributionItemCopyWithImpl<$Res>
    implements _$GenreDistributionItemCopyWith<$Res> {
  __$GenreDistributionItemCopyWithImpl(this._self, this._then);

  final _GenreDistributionItem _self;
  final $Res Function(_GenreDistributionItem) _then;

  /// Create a copy of GenreDistributionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? genre = null,
    Object? count = null,
    Object? pct = null,
  }) {
    return _then(_GenreDistributionItem(
      genre: null == genre
          ? _self.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      pct: null == pct
          ? _self.pct
          : pct // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$AdvancedStatsDto {
  List<SpeedTrendItem> get speedTrend;
  List<GenreDistributionItem> get genreDistribution;
  Map<String, int> get yearlyComparison;
  int get longestStreakDays;

  /// Create a copy of AdvancedStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdvancedStatsDtoCopyWith<AdvancedStatsDto> get copyWith =>
      _$AdvancedStatsDtoCopyWithImpl<AdvancedStatsDto>(
          this as AdvancedStatsDto, _$identity);

  /// Serializes this AdvancedStatsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdvancedStatsDto &&
            const DeepCollectionEquality()
                .equals(other.speedTrend, speedTrend) &&
            const DeepCollectionEquality()
                .equals(other.genreDistribution, genreDistribution) &&
            const DeepCollectionEquality()
                .equals(other.yearlyComparison, yearlyComparison) &&
            (identical(other.longestStreakDays, longestStreakDays) ||
                other.longestStreakDays == longestStreakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(speedTrend),
      const DeepCollectionEquality().hash(genreDistribution),
      const DeepCollectionEquality().hash(yearlyComparison),
      longestStreakDays);

  @override
  String toString() {
    return 'AdvancedStatsDto(speedTrend: $speedTrend, genreDistribution: $genreDistribution, yearlyComparison: $yearlyComparison, longestStreakDays: $longestStreakDays)';
  }
}

/// @nodoc
abstract mixin class $AdvancedStatsDtoCopyWith<$Res> {
  factory $AdvancedStatsDtoCopyWith(
          AdvancedStatsDto value, $Res Function(AdvancedStatsDto) _then) =
      _$AdvancedStatsDtoCopyWithImpl;
  @useResult
  $Res call(
      {List<SpeedTrendItem> speedTrend,
      List<GenreDistributionItem> genreDistribution,
      Map<String, int> yearlyComparison,
      int longestStreakDays});
}

/// @nodoc
class _$AdvancedStatsDtoCopyWithImpl<$Res>
    implements $AdvancedStatsDtoCopyWith<$Res> {
  _$AdvancedStatsDtoCopyWithImpl(this._self, this._then);

  final AdvancedStatsDto _self;
  final $Res Function(AdvancedStatsDto) _then;

  /// Create a copy of AdvancedStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? speedTrend = null,
    Object? genreDistribution = null,
    Object? yearlyComparison = null,
    Object? longestStreakDays = null,
  }) {
    return _then(_self.copyWith(
      speedTrend: null == speedTrend
          ? _self.speedTrend
          : speedTrend // ignore: cast_nullable_to_non_nullable
              as List<SpeedTrendItem>,
      genreDistribution: null == genreDistribution
          ? _self.genreDistribution
          : genreDistribution // ignore: cast_nullable_to_non_nullable
              as List<GenreDistributionItem>,
      yearlyComparison: null == yearlyComparison
          ? _self.yearlyComparison
          : yearlyComparison // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      longestStreakDays: null == longestStreakDays
          ? _self.longestStreakDays
          : longestStreakDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdvancedStatsDto].
extension AdvancedStatsDtoPatterns on AdvancedStatsDto {
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
    TResult Function(_AdvancedStatsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdvancedStatsDto() when $default != null:
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
    TResult Function(_AdvancedStatsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdvancedStatsDto():
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
    TResult? Function(_AdvancedStatsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdvancedStatsDto() when $default != null:
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
            List<SpeedTrendItem> speedTrend,
            List<GenreDistributionItem> genreDistribution,
            Map<String, int> yearlyComparison,
            int longestStreakDays)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdvancedStatsDto() when $default != null:
        return $default(_that.speedTrend, _that.genreDistribution,
            _that.yearlyComparison, _that.longestStreakDays);
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
            List<SpeedTrendItem> speedTrend,
            List<GenreDistributionItem> genreDistribution,
            Map<String, int> yearlyComparison,
            int longestStreakDays)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdvancedStatsDto():
        return $default(_that.speedTrend, _that.genreDistribution,
            _that.yearlyComparison, _that.longestStreakDays);
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
            List<SpeedTrendItem> speedTrend,
            List<GenreDistributionItem> genreDistribution,
            Map<String, int> yearlyComparison,
            int longestStreakDays)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdvancedStatsDto() when $default != null:
        return $default(_that.speedTrend, _that.genreDistribution,
            _that.yearlyComparison, _that.longestStreakDays);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdvancedStatsDto implements AdvancedStatsDto {
  const _AdvancedStatsDto(
      {required final List<SpeedTrendItem> speedTrend,
      required final List<GenreDistributionItem> genreDistribution,
      required final Map<String, int> yearlyComparison,
      required this.longestStreakDays})
      : _speedTrend = speedTrend,
        _genreDistribution = genreDistribution,
        _yearlyComparison = yearlyComparison;
  factory _AdvancedStatsDto.fromJson(Map<String, dynamic> json) =>
      _$AdvancedStatsDtoFromJson(json);

  final List<SpeedTrendItem> _speedTrend;
  @override
  List<SpeedTrendItem> get speedTrend {
    if (_speedTrend is EqualUnmodifiableListView) return _speedTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_speedTrend);
  }

  final List<GenreDistributionItem> _genreDistribution;
  @override
  List<GenreDistributionItem> get genreDistribution {
    if (_genreDistribution is EqualUnmodifiableListView)
      return _genreDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genreDistribution);
  }

  final Map<String, int> _yearlyComparison;
  @override
  Map<String, int> get yearlyComparison {
    if (_yearlyComparison is EqualUnmodifiableMapView) return _yearlyComparison;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_yearlyComparison);
  }

  @override
  final int longestStreakDays;

  /// Create a copy of AdvancedStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdvancedStatsDtoCopyWith<_AdvancedStatsDto> get copyWith =>
      __$AdvancedStatsDtoCopyWithImpl<_AdvancedStatsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdvancedStatsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdvancedStatsDto &&
            const DeepCollectionEquality()
                .equals(other._speedTrend, _speedTrend) &&
            const DeepCollectionEquality()
                .equals(other._genreDistribution, _genreDistribution) &&
            const DeepCollectionEquality()
                .equals(other._yearlyComparison, _yearlyComparison) &&
            (identical(other.longestStreakDays, longestStreakDays) ||
                other.longestStreakDays == longestStreakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_speedTrend),
      const DeepCollectionEquality().hash(_genreDistribution),
      const DeepCollectionEquality().hash(_yearlyComparison),
      longestStreakDays);

  @override
  String toString() {
    return 'AdvancedStatsDto(speedTrend: $speedTrend, genreDistribution: $genreDistribution, yearlyComparison: $yearlyComparison, longestStreakDays: $longestStreakDays)';
  }
}

/// @nodoc
abstract mixin class _$AdvancedStatsDtoCopyWith<$Res>
    implements $AdvancedStatsDtoCopyWith<$Res> {
  factory _$AdvancedStatsDtoCopyWith(
          _AdvancedStatsDto value, $Res Function(_AdvancedStatsDto) _then) =
      __$AdvancedStatsDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<SpeedTrendItem> speedTrend,
      List<GenreDistributionItem> genreDistribution,
      Map<String, int> yearlyComparison,
      int longestStreakDays});
}

/// @nodoc
class __$AdvancedStatsDtoCopyWithImpl<$Res>
    implements _$AdvancedStatsDtoCopyWith<$Res> {
  __$AdvancedStatsDtoCopyWithImpl(this._self, this._then);

  final _AdvancedStatsDto _self;
  final $Res Function(_AdvancedStatsDto) _then;

  /// Create a copy of AdvancedStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? speedTrend = null,
    Object? genreDistribution = null,
    Object? yearlyComparison = null,
    Object? longestStreakDays = null,
  }) {
    return _then(_AdvancedStatsDto(
      speedTrend: null == speedTrend
          ? _self._speedTrend
          : speedTrend // ignore: cast_nullable_to_non_nullable
              as List<SpeedTrendItem>,
      genreDistribution: null == genreDistribution
          ? _self._genreDistribution
          : genreDistribution // ignore: cast_nullable_to_non_nullable
              as List<GenreDistributionItem>,
      yearlyComparison: null == yearlyComparison
          ? _self._yearlyComparison
          : yearlyComparison // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      longestStreakDays: null == longestStreakDays
          ? _self.longestStreakDays
          : longestStreakDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
