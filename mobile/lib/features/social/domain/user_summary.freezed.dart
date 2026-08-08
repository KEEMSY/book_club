// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GradeStats {
  int get grade;
  int get tier;
  int get totalBooks;
  int get totalSeconds;
  int get streakDays;

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GradeStatsCopyWith<GradeStats> get copyWith =>
      _$GradeStatsCopyWithImpl<GradeStats>(this as GradeStats, _$identity);

  /// Serializes this GradeStats to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GradeStats &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.totalBooks, totalBooks) ||
                other.totalBooks == totalBooks) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, grade, tier, totalBooks, totalSeconds, streakDays);

  @override
  String toString() {
    return 'GradeStats(grade: $grade, tier: $tier, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays)';
  }
}

/// @nodoc
abstract mixin class $GradeStatsCopyWith<$Res> {
  factory $GradeStatsCopyWith(
          GradeStats value, $Res Function(GradeStats) _then) =
      _$GradeStatsCopyWithImpl;
  @useResult
  $Res call(
      {int grade, int tier, int totalBooks, int totalSeconds, int streakDays});
}

/// @nodoc
class _$GradeStatsCopyWithImpl<$Res> implements $GradeStatsCopyWith<$Res> {
  _$GradeStatsCopyWithImpl(this._self, this._then);

  final GradeStats _self;
  final $Res Function(GradeStats) _then;

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? tier = null,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
  }) {
    return _then(_self.copyWith(
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      totalBooks: null == totalBooks
          ? _self.totalBooks
          : totalBooks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _self.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [GradeStats].
extension GradeStatsPatterns on GradeStats {
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
    TResult Function(_GradeStats value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GradeStats() when $default != null:
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
    TResult Function(_GradeStats value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeStats():
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
    TResult? Function(_GradeStats value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeStats() when $default != null:
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
    TResult Function(int grade, int tier, int totalBooks, int totalSeconds,
            int streakDays)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GradeStats() when $default != null:
        return $default(_that.grade, _that.tier, _that.totalBooks,
            _that.totalSeconds, _that.streakDays);
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
    TResult Function(int grade, int tier, int totalBooks, int totalSeconds,
            int streakDays)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeStats():
        return $default(_that.grade, _that.tier, _that.totalBooks,
            _that.totalSeconds, _that.streakDays);
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
    TResult? Function(int grade, int tier, int totalBooks, int totalSeconds,
            int streakDays)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeStats() when $default != null:
        return $default(_that.grade, _that.tier, _that.totalBooks,
            _that.totalSeconds, _that.streakDays);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GradeStats implements GradeStats {
  const _GradeStats(
      {required this.grade,
      required this.tier,
      required this.totalBooks,
      required this.totalSeconds,
      required this.streakDays});
  factory _GradeStats.fromJson(Map<String, dynamic> json) =>
      _$GradeStatsFromJson(json);

  @override
  final int grade;
  @override
  final int tier;
  @override
  final int totalBooks;
  @override
  final int totalSeconds;
  @override
  final int streakDays;

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GradeStatsCopyWith<_GradeStats> get copyWith =>
      __$GradeStatsCopyWithImpl<_GradeStats>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GradeStatsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GradeStats &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.totalBooks, totalBooks) ||
                other.totalBooks == totalBooks) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, grade, tier, totalBooks, totalSeconds, streakDays);

  @override
  String toString() {
    return 'GradeStats(grade: $grade, tier: $tier, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays)';
  }
}

/// @nodoc
abstract mixin class _$GradeStatsCopyWith<$Res>
    implements $GradeStatsCopyWith<$Res> {
  factory _$GradeStatsCopyWith(
          _GradeStats value, $Res Function(_GradeStats) _then) =
      __$GradeStatsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int grade, int tier, int totalBooks, int totalSeconds, int streakDays});
}

/// @nodoc
class __$GradeStatsCopyWithImpl<$Res> implements _$GradeStatsCopyWith<$Res> {
  __$GradeStatsCopyWithImpl(this._self, this._then);

  final _GradeStats _self;
  final $Res Function(_GradeStats) _then;

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? grade = null,
    Object? tier = null,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
  }) {
    return _then(_GradeStats(
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      totalBooks: null == totalBooks
          ? _self.totalBooks
          : totalBooks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _self.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$BadgeSummary {
  String get id;
  String get name;
  String get iconUrl;
  String get category;
  DateTime get earnedAt;

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BadgeSummaryCopyWith<BadgeSummary> get copyWith =>
      _$BadgeSummaryCopyWithImpl<BadgeSummary>(
          this as BadgeSummary, _$identity);

  /// Serializes this BadgeSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BadgeSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, iconUrl, category, earnedAt);

  @override
  String toString() {
    return 'BadgeSummary(id: $id, name: $name, iconUrl: $iconUrl, category: $category, earnedAt: $earnedAt)';
  }
}

/// @nodoc
abstract mixin class $BadgeSummaryCopyWith<$Res> {
  factory $BadgeSummaryCopyWith(
          BadgeSummary value, $Res Function(BadgeSummary) _then) =
      _$BadgeSummaryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String iconUrl,
      String category,
      DateTime earnedAt});
}

/// @nodoc
class _$BadgeSummaryCopyWithImpl<$Res> implements $BadgeSummaryCopyWith<$Res> {
  _$BadgeSummaryCopyWithImpl(this._self, this._then);

  final BadgeSummary _self;
  final $Res Function(BadgeSummary) _then;

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = null,
    Object? category = null,
    Object? earnedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: null == iconUrl
          ? _self.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      earnedAt: null == earnedAt
          ? _self.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [BadgeSummary].
extension BadgeSummaryPatterns on BadgeSummary {
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
    TResult Function(_BadgeSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BadgeSummary() when $default != null:
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
    TResult Function(_BadgeSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BadgeSummary():
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
    TResult? Function(_BadgeSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BadgeSummary() when $default != null:
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
    TResult Function(String id, String name, String iconUrl, String category,
            DateTime earnedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BadgeSummary() when $default != null:
        return $default(_that.id, _that.name, _that.iconUrl, _that.category,
            _that.earnedAt);
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
    TResult Function(String id, String name, String iconUrl, String category,
            DateTime earnedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BadgeSummary():
        return $default(_that.id, _that.name, _that.iconUrl, _that.category,
            _that.earnedAt);
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
    TResult? Function(String id, String name, String iconUrl, String category,
            DateTime earnedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BadgeSummary() when $default != null:
        return $default(_that.id, _that.name, _that.iconUrl, _that.category,
            _that.earnedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BadgeSummary implements BadgeSummary {
  const _BadgeSummary(
      {required this.id,
      required this.name,
      required this.iconUrl,
      required this.category,
      required this.earnedAt});
  factory _BadgeSummary.fromJson(Map<String, dynamic> json) =>
      _$BadgeSummaryFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String iconUrl;
  @override
  final String category;
  @override
  final DateTime earnedAt;

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BadgeSummaryCopyWith<_BadgeSummary> get copyWith =>
      __$BadgeSummaryCopyWithImpl<_BadgeSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BadgeSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BadgeSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, iconUrl, category, earnedAt);

  @override
  String toString() {
    return 'BadgeSummary(id: $id, name: $name, iconUrl: $iconUrl, category: $category, earnedAt: $earnedAt)';
  }
}

/// @nodoc
abstract mixin class _$BadgeSummaryCopyWith<$Res>
    implements $BadgeSummaryCopyWith<$Res> {
  factory _$BadgeSummaryCopyWith(
          _BadgeSummary value, $Res Function(_BadgeSummary) _then) =
      __$BadgeSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String iconUrl,
      String category,
      DateTime earnedAt});
}

/// @nodoc
class __$BadgeSummaryCopyWithImpl<$Res>
    implements _$BadgeSummaryCopyWith<$Res> {
  __$BadgeSummaryCopyWithImpl(this._self, this._then);

  final _BadgeSummary _self;
  final $Res Function(_BadgeSummary) _then;

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = null,
    Object? category = null,
    Object? earnedAt = null,
  }) {
    return _then(_BadgeSummary(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: null == iconUrl
          ? _self.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      earnedAt: null == earnedAt
          ? _self.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$HighlightSummary {
  String get id;
  String get quoteText;
  String? get bookTitle;
  DateTime get createdAt;

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightSummaryCopyWith<HighlightSummary> get copyWith =>
      _$HighlightSummaryCopyWithImpl<HighlightSummary>(
          this as HighlightSummary, _$identity);

  /// Serializes this HighlightSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quoteText, bookTitle, createdAt);

  @override
  String toString() {
    return 'HighlightSummary(id: $id, quoteText: $quoteText, bookTitle: $bookTitle, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $HighlightSummaryCopyWith<$Res> {
  factory $HighlightSummaryCopyWith(
          HighlightSummary value, $Res Function(HighlightSummary) _then) =
      _$HighlightSummaryCopyWithImpl;
  @useResult
  $Res call(
      {String id, String quoteText, String? bookTitle, DateTime createdAt});
}

/// @nodoc
class _$HighlightSummaryCopyWithImpl<$Res>
    implements $HighlightSummaryCopyWith<$Res> {
  _$HighlightSummaryCopyWithImpl(this._self, this._then);

  final HighlightSummary _self;
  final $Res Function(HighlightSummary) _then;

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteText = null,
    Object? bookTitle = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [HighlightSummary].
extension HighlightSummaryPatterns on HighlightSummary {
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
    TResult Function(_HighlightSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightSummary() when $default != null:
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
    TResult Function(_HighlightSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightSummary():
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
    TResult? Function(_HighlightSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightSummary() when $default != null:
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
            String id, String quoteText, String? bookTitle, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightSummary() when $default != null:
        return $default(
            _that.id, _that.quoteText, _that.bookTitle, _that.createdAt);
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
            String id, String quoteText, String? bookTitle, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightSummary():
        return $default(
            _that.id, _that.quoteText, _that.bookTitle, _that.createdAt);
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
            String id, String quoteText, String? bookTitle, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightSummary() when $default != null:
        return $default(
            _that.id, _that.quoteText, _that.bookTitle, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HighlightSummary implements HighlightSummary {
  const _HighlightSummary(
      {required this.id,
      required this.quoteText,
      this.bookTitle,
      required this.createdAt});
  factory _HighlightSummary.fromJson(Map<String, dynamic> json) =>
      _$HighlightSummaryFromJson(json);

  @override
  final String id;
  @override
  final String quoteText;
  @override
  final String? bookTitle;
  @override
  final DateTime createdAt;

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightSummaryCopyWith<_HighlightSummary> get copyWith =>
      __$HighlightSummaryCopyWithImpl<_HighlightSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HighlightSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HighlightSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quoteText, bookTitle, createdAt);

  @override
  String toString() {
    return 'HighlightSummary(id: $id, quoteText: $quoteText, bookTitle: $bookTitle, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$HighlightSummaryCopyWith<$Res>
    implements $HighlightSummaryCopyWith<$Res> {
  factory _$HighlightSummaryCopyWith(
          _HighlightSummary value, $Res Function(_HighlightSummary) _then) =
      __$HighlightSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String quoteText, String? bookTitle, DateTime createdAt});
}

/// @nodoc
class __$HighlightSummaryCopyWithImpl<$Res>
    implements _$HighlightSummaryCopyWith<$Res> {
  __$HighlightSummaryCopyWithImpl(this._self, this._then);

  final _HighlightSummary _self;
  final $Res Function(_HighlightSummary) _then;

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quoteText = null,
    Object? bookTitle = freezed,
    Object? createdAt = null,
  }) {
    return _then(_HighlightSummary(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$UserSummary {
  String get id;
  String get nickname;
  String? get profileImageUrl;
  String? get bio;
  bool get isFollowing;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserSummaryCopyWith<UserSummary> get copyWith =>
      _$UserSummaryCopyWithImpl<UserSummary>(this as UserSummary, _$identity);

  /// Serializes this UserSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nickname, profileImageUrl, bio, isFollowing);

  @override
  String toString() {
    return 'UserSummary(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl, bio: $bio, isFollowing: $isFollowing)';
  }
}

/// @nodoc
abstract mixin class $UserSummaryCopyWith<$Res> {
  factory $UserSummaryCopyWith(
          UserSummary value, $Res Function(UserSummary) _then) =
      _$UserSummaryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      bool isFollowing});
}

/// @nodoc
class _$UserSummaryCopyWithImpl<$Res> implements $UserSummaryCopyWith<$Res> {
  _$UserSummaryCopyWithImpl(this._self, this._then);

  final UserSummary _self;
  final $Res Function(UserSummary) _then;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? isFollowing = null,
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
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isFollowing: null == isFollowing
          ? _self.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserSummary].
extension UserSummaryPatterns on UserSummary {
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
    TResult Function(_UserSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSummary() when $default != null:
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
    TResult Function(_UserSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummary():
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
    TResult? Function(_UserSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummary() when $default != null:
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
    TResult Function(String id, String nickname, String? profileImageUrl,
            String? bio, bool isFollowing)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSummary() when $default != null:
        return $default(_that.id, _that.nickname, _that.profileImageUrl,
            _that.bio, _that.isFollowing);
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
    TResult Function(String id, String nickname, String? profileImageUrl,
            String? bio, bool isFollowing)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummary():
        return $default(_that.id, _that.nickname, _that.profileImageUrl,
            _that.bio, _that.isFollowing);
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
    TResult? Function(String id, String nickname, String? profileImageUrl,
            String? bio, bool isFollowing)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummary() when $default != null:
        return $default(_that.id, _that.nickname, _that.profileImageUrl,
            _that.bio, _that.isFollowing);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserSummary implements UserSummary {
  const _UserSummary(
      {required this.id,
      required this.nickname,
      this.profileImageUrl,
      this.bio,
      required this.isFollowing});
  factory _UserSummary.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  final bool isFollowing;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserSummaryCopyWith<_UserSummary> get copyWith =>
      __$UserSummaryCopyWithImpl<_UserSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nickname, profileImageUrl, bio, isFollowing);

  @override
  String toString() {
    return 'UserSummary(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl, bio: $bio, isFollowing: $isFollowing)';
  }
}

/// @nodoc
abstract mixin class _$UserSummaryCopyWith<$Res>
    implements $UserSummaryCopyWith<$Res> {
  factory _$UserSummaryCopyWith(
          _UserSummary value, $Res Function(_UserSummary) _then) =
      __$UserSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      bool isFollowing});
}

/// @nodoc
class __$UserSummaryCopyWithImpl<$Res> implements _$UserSummaryCopyWith<$Res> {
  __$UserSummaryCopyWithImpl(this._self, this._then);

  final _UserSummary _self;
  final $Res Function(_UserSummary) _then;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? isFollowing = null,
  }) {
    return _then(_UserSummary(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isFollowing: null == isFollowing
          ? _self.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$UserSummaryPage {
  List<UserSummary> get items;
  String? get nextCursor;

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserSummaryPageCopyWith<UserSummaryPage> get copyWith =>
      _$UserSummaryPageCopyWithImpl<UserSummaryPage>(
          this as UserSummaryPage, _$identity);

  /// Serializes this UserSummaryPage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserSummaryPage &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), nextCursor);

  @override
  String toString() {
    return 'UserSummaryPage(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $UserSummaryPageCopyWith<$Res> {
  factory $UserSummaryPageCopyWith(
          UserSummaryPage value, $Res Function(UserSummaryPage) _then) =
      _$UserSummaryPageCopyWithImpl;
  @useResult
  $Res call({List<UserSummary> items, String? nextCursor});
}

/// @nodoc
class _$UserSummaryPageCopyWithImpl<$Res>
    implements $UserSummaryPageCopyWith<$Res> {
  _$UserSummaryPageCopyWithImpl(this._self, this._then);

  final UserSummaryPage _self;
  final $Res Function(UserSummaryPage) _then;

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserSummary>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserSummaryPage].
extension UserSummaryPagePatterns on UserSummaryPage {
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
    TResult Function(_UserSummaryPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSummaryPage() when $default != null:
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
    TResult Function(_UserSummaryPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummaryPage():
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
    TResult? Function(_UserSummaryPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummaryPage() when $default != null:
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
    TResult Function(List<UserSummary> items, String? nextCursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSummaryPage() when $default != null:
        return $default(_that.items, _that.nextCursor);
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
    TResult Function(List<UserSummary> items, String? nextCursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummaryPage():
        return $default(_that.items, _that.nextCursor);
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
    TResult? Function(List<UserSummary> items, String? nextCursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSummaryPage() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserSummaryPage implements UserSummaryPage {
  const _UserSummaryPage(
      {required final List<UserSummary> items, this.nextCursor})
      : _items = items;
  factory _UserSummaryPage.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryPageFromJson(json);

  final List<UserSummary> _items;
  @override
  List<UserSummary> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserSummaryPageCopyWith<_UserSummaryPage> get copyWith =>
      __$UserSummaryPageCopyWithImpl<_UserSummaryPage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserSummaryPageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserSummaryPage &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'UserSummaryPage(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$UserSummaryPageCopyWith<$Res>
    implements $UserSummaryPageCopyWith<$Res> {
  factory _$UserSummaryPageCopyWith(
          _UserSummaryPage value, $Res Function(_UserSummaryPage) _then) =
      __$UserSummaryPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<UserSummary> items, String? nextCursor});
}

/// @nodoc
class __$UserSummaryPageCopyWithImpl<$Res>
    implements _$UserSummaryPageCopyWith<$Res> {
  __$UserSummaryPageCopyWithImpl(this._self, this._then);

  final _UserSummaryPage _self;
  final $Res Function(_UserSummaryPage) _then;

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_UserSummaryPage(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserSummary>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$UserProfile {
  String get id;
  String get nickname;
  String? get profileImageUrl;
  String? get bio;
  int get followerCount;
  int get followingCount;
  bool get isFollowing;
  bool get isMe;
  GradeStats? get gradeStats;
  List<BadgeSummary> get badges;
  List<HighlightSummary>
      get recentHighlights; // Profile expressiveness (backend BC-81, mobile UI BC-84). Kept as raw
// wire values here (not the `ProfileTheme` enum) so this DTO's
// json_serializable codegen stays trivial — [ProfileTheme.fromWire]
// converts `theme` at the presentation layer. [featuredBookId] is a bare
// id; the profile header fetches title/cover via the existing
// `GET /books/{id}` (see `featuredBookProvider`).
  String? get coverImageUrl;
  String? get theme;
  String? get featuredBookId;
  String? get featuredQuote;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<UserProfile> get copyWith =>
      _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.gradeStats, gradeStats) ||
                other.gradeStats == gradeStats) &&
            const DeepCollectionEquality().equals(other.badges, badges) &&
            const DeepCollectionEquality()
                .equals(other.recentHighlights, recentHighlights) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.featuredBookId, featuredBookId) ||
                other.featuredBookId == featuredBookId) &&
            (identical(other.featuredQuote, featuredQuote) ||
                other.featuredQuote == featuredQuote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nickname,
      profileImageUrl,
      bio,
      followerCount,
      followingCount,
      isFollowing,
      isMe,
      gradeStats,
      const DeepCollectionEquality().hash(badges),
      const DeepCollectionEquality().hash(recentHighlights),
      coverImageUrl,
      theme,
      featuredBookId,
      featuredQuote);

  @override
  String toString() {
    return 'UserProfile(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl, bio: $bio, followerCount: $followerCount, followingCount: $followingCount, isFollowing: $isFollowing, isMe: $isMe, gradeStats: $gradeStats, badges: $badges, recentHighlights: $recentHighlights, coverImageUrl: $coverImageUrl, theme: $theme, featuredBookId: $featuredBookId, featuredQuote: $featuredQuote)';
  }
}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) _then) =
      _$UserProfileCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      int followerCount,
      int followingCount,
      bool isFollowing,
      bool isMe,
      GradeStats? gradeStats,
      List<BadgeSummary> badges,
      List<HighlightSummary> recentHighlights,
      String? coverImageUrl,
      String? theme,
      String? featuredBookId,
      String? featuredQuote});

  $GradeStatsCopyWith<$Res>? get gradeStats;
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res> implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowing = null,
    Object? isMe = null,
    Object? gradeStats = freezed,
    Object? badges = null,
    Object? recentHighlights = null,
    Object? coverImageUrl = freezed,
    Object? theme = freezed,
    Object? featuredBookId = freezed,
    Object? featuredQuote = freezed,
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
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      followerCount: null == followerCount
          ? _self.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _self.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFollowing: null == isFollowing
          ? _self.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      gradeStats: freezed == gradeStats
          ? _self.gradeStats
          : gradeStats // ignore: cast_nullable_to_non_nullable
              as GradeStats?,
      badges: null == badges
          ? _self.badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<BadgeSummary>,
      recentHighlights: null == recentHighlights
          ? _self.recentHighlights
          : recentHighlights // ignore: cast_nullable_to_non_nullable
              as List<HighlightSummary>,
      coverImageUrl: freezed == coverImageUrl
          ? _self.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: freezed == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredBookId: freezed == featuredBookId
          ? _self.featuredBookId
          : featuredBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredQuote: freezed == featuredQuote
          ? _self.featuredQuote
          : featuredQuote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeStatsCopyWith<$Res>? get gradeStats {
    if (_self.gradeStats == null) {
      return null;
    }

    return $GradeStatsCopyWith<$Res>(_self.gradeStats!, (value) {
      return _then(_self.copyWith(gradeStats: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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
    TResult Function(_UserProfile value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
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
    TResult Function(_UserProfile value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile():
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
    TResult? Function(_UserProfile value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
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
            String id,
            String nickname,
            String? profileImageUrl,
            String? bio,
            int followerCount,
            int followingCount,
            bool isFollowing,
            bool isMe,
            GradeStats? gradeStats,
            List<BadgeSummary> badges,
            List<HighlightSummary> recentHighlights,
            String? coverImageUrl,
            String? theme,
            String? featuredBookId,
            String? featuredQuote)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
        return $default(
            _that.id,
            _that.nickname,
            _that.profileImageUrl,
            _that.bio,
            _that.followerCount,
            _that.followingCount,
            _that.isFollowing,
            _that.isMe,
            _that.gradeStats,
            _that.badges,
            _that.recentHighlights,
            _that.coverImageUrl,
            _that.theme,
            _that.featuredBookId,
            _that.featuredQuote);
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
            String id,
            String nickname,
            String? profileImageUrl,
            String? bio,
            int followerCount,
            int followingCount,
            bool isFollowing,
            bool isMe,
            GradeStats? gradeStats,
            List<BadgeSummary> badges,
            List<HighlightSummary> recentHighlights,
            String? coverImageUrl,
            String? theme,
            String? featuredBookId,
            String? featuredQuote)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile():
        return $default(
            _that.id,
            _that.nickname,
            _that.profileImageUrl,
            _that.bio,
            _that.followerCount,
            _that.followingCount,
            _that.isFollowing,
            _that.isMe,
            _that.gradeStats,
            _that.badges,
            _that.recentHighlights,
            _that.coverImageUrl,
            _that.theme,
            _that.featuredBookId,
            _that.featuredQuote);
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
            String id,
            String nickname,
            String? profileImageUrl,
            String? bio,
            int followerCount,
            int followingCount,
            bool isFollowing,
            bool isMe,
            GradeStats? gradeStats,
            List<BadgeSummary> badges,
            List<HighlightSummary> recentHighlights,
            String? coverImageUrl,
            String? theme,
            String? featuredBookId,
            String? featuredQuote)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
        return $default(
            _that.id,
            _that.nickname,
            _that.profileImageUrl,
            _that.bio,
            _that.followerCount,
            _that.followingCount,
            _that.isFollowing,
            _that.isMe,
            _that.gradeStats,
            _that.badges,
            _that.recentHighlights,
            _that.coverImageUrl,
            _that.theme,
            _that.featuredBookId,
            _that.featuredQuote);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserProfile implements UserProfile {
  const _UserProfile(
      {required this.id,
      required this.nickname,
      this.profileImageUrl,
      this.bio,
      required this.followerCount,
      required this.followingCount,
      required this.isFollowing,
      required this.isMe,
      this.gradeStats,
      final List<BadgeSummary> badges = const [],
      final List<HighlightSummary> recentHighlights = const [],
      this.coverImageUrl,
      this.theme,
      this.featuredBookId,
      this.featuredQuote})
      : _badges = badges,
        _recentHighlights = recentHighlights;
  factory _UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  final int followerCount;
  @override
  final int followingCount;
  @override
  final bool isFollowing;
  @override
  final bool isMe;
  @override
  final GradeStats? gradeStats;
  final List<BadgeSummary> _badges;
  @override
  @JsonKey()
  List<BadgeSummary> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  final List<HighlightSummary> _recentHighlights;
  @override
  @JsonKey()
  List<HighlightSummary> get recentHighlights {
    if (_recentHighlights is EqualUnmodifiableListView)
      return _recentHighlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentHighlights);
  }

// Profile expressiveness (backend BC-81, mobile UI BC-84). Kept as raw
// wire values here (not the `ProfileTheme` enum) so this DTO's
// json_serializable codegen stays trivial — [ProfileTheme.fromWire]
// converts `theme` at the presentation layer. [featuredBookId] is a bare
// id; the profile header fetches title/cover via the existing
// `GET /books/{id}` (see `featuredBookProvider`).
  @override
  final String? coverImageUrl;
  @override
  final String? theme;
  @override
  final String? featuredBookId;
  @override
  final String? featuredQuote;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserProfileCopyWith<_UserProfile> get copyWith =>
      __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.gradeStats, gradeStats) ||
                other.gradeStats == gradeStats) &&
            const DeepCollectionEquality().equals(other._badges, _badges) &&
            const DeepCollectionEquality()
                .equals(other._recentHighlights, _recentHighlights) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.featuredBookId, featuredBookId) ||
                other.featuredBookId == featuredBookId) &&
            (identical(other.featuredQuote, featuredQuote) ||
                other.featuredQuote == featuredQuote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nickname,
      profileImageUrl,
      bio,
      followerCount,
      followingCount,
      isFollowing,
      isMe,
      gradeStats,
      const DeepCollectionEquality().hash(_badges),
      const DeepCollectionEquality().hash(_recentHighlights),
      coverImageUrl,
      theme,
      featuredBookId,
      featuredQuote);

  @override
  String toString() {
    return 'UserProfile(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl, bio: $bio, followerCount: $followerCount, followingCount: $followingCount, isFollowing: $isFollowing, isMe: $isMe, gradeStats: $gradeStats, badges: $badges, recentHighlights: $recentHighlights, coverImageUrl: $coverImageUrl, theme: $theme, featuredBookId: $featuredBookId, featuredQuote: $featuredQuote)';
  }
}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(
          _UserProfile value, $Res Function(_UserProfile) _then) =
      __$UserProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      int followerCount,
      int followingCount,
      bool isFollowing,
      bool isMe,
      GradeStats? gradeStats,
      List<BadgeSummary> badges,
      List<HighlightSummary> recentHighlights,
      String? coverImageUrl,
      String? theme,
      String? featuredBookId,
      String? featuredQuote});

  @override
  $GradeStatsCopyWith<$Res>? get gradeStats;
}

/// @nodoc
class __$UserProfileCopyWithImpl<$Res> implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowing = null,
    Object? isMe = null,
    Object? gradeStats = freezed,
    Object? badges = null,
    Object? recentHighlights = null,
    Object? coverImageUrl = freezed,
    Object? theme = freezed,
    Object? featuredBookId = freezed,
    Object? featuredQuote = freezed,
  }) {
    return _then(_UserProfile(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      followerCount: null == followerCount
          ? _self.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _self.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFollowing: null == isFollowing
          ? _self.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      gradeStats: freezed == gradeStats
          ? _self.gradeStats
          : gradeStats // ignore: cast_nullable_to_non_nullable
              as GradeStats?,
      badges: null == badges
          ? _self._badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<BadgeSummary>,
      recentHighlights: null == recentHighlights
          ? _self._recentHighlights
          : recentHighlights // ignore: cast_nullable_to_non_nullable
              as List<HighlightSummary>,
      coverImageUrl: freezed == coverImageUrl
          ? _self.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: freezed == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredBookId: freezed == featuredBookId
          ? _self.featuredBookId
          : featuredBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredQuote: freezed == featuredQuote
          ? _self.featuredQuote
          : featuredQuote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeStatsCopyWith<$Res>? get gradeStats {
    if (_self.gradeStats == null) {
      return null;
    }

    return $GradeStatsCopyWith<$Res>(_self.gradeStats!, (value) {
      return _then(_self.copyWith(gradeStats: value));
    });
  }
}

// dart format on
