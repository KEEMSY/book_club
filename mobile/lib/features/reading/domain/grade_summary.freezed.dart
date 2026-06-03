// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NextGradeThresholds {
  int get targetBooks;
  int get targetSeconds;

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsCopyWith<NextGradeThresholds> get copyWith =>
      _$NextGradeThresholdsCopyWithImpl<NextGradeThresholds>(
          this as NextGradeThresholds, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NextGradeThresholds &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetBooks, targetSeconds);

  @override
  String toString() {
    return 'NextGradeThresholds(targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }
}

/// @nodoc
abstract mixin class $NextGradeThresholdsCopyWith<$Res> {
  factory $NextGradeThresholdsCopyWith(
          NextGradeThresholds value, $Res Function(NextGradeThresholds) _then) =
      _$NextGradeThresholdsCopyWithImpl;
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class _$NextGradeThresholdsCopyWithImpl<$Res>
    implements $NextGradeThresholdsCopyWith<$Res> {
  _$NextGradeThresholdsCopyWithImpl(this._self, this._then);

  final NextGradeThresholds _self;
  final $Res Function(NextGradeThresholds) _then;

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_self.copyWith(
      targetBooks: null == targetBooks
          ? _self.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _self.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [NextGradeThresholds].
extension NextGradeThresholdsPatterns on NextGradeThresholds {
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
    TResult Function(_NextGradeThresholds value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholds() when $default != null:
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
    TResult Function(_NextGradeThresholds value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholds():
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
    TResult? Function(_NextGradeThresholds value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholds() when $default != null:
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
    TResult Function(int targetBooks, int targetSeconds)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholds() when $default != null:
        return $default(_that.targetBooks, _that.targetSeconds);
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
    TResult Function(int targetBooks, int targetSeconds) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholds():
        return $default(_that.targetBooks, _that.targetSeconds);
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
    TResult? Function(int targetBooks, int targetSeconds)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholds() when $default != null:
        return $default(_that.targetBooks, _that.targetSeconds);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NextGradeThresholds implements NextGradeThresholds {
  const _NextGradeThresholds(
      {required this.targetBooks, required this.targetSeconds});

  @override
  final int targetBooks;
  @override
  final int targetSeconds;

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NextGradeThresholdsCopyWith<_NextGradeThresholds> get copyWith =>
      __$NextGradeThresholdsCopyWithImpl<_NextGradeThresholds>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NextGradeThresholds &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetBooks, targetSeconds);

  @override
  String toString() {
    return 'NextGradeThresholds(targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }
}

/// @nodoc
abstract mixin class _$NextGradeThresholdsCopyWith<$Res>
    implements $NextGradeThresholdsCopyWith<$Res> {
  factory _$NextGradeThresholdsCopyWith(_NextGradeThresholds value,
          $Res Function(_NextGradeThresholds) _then) =
      __$NextGradeThresholdsCopyWithImpl;
  @override
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class __$NextGradeThresholdsCopyWithImpl<$Res>
    implements _$NextGradeThresholdsCopyWith<$Res> {
  __$NextGradeThresholdsCopyWithImpl(this._self, this._then);

  final _NextGradeThresholds _self;
  final $Res Function(_NextGradeThresholds) _then;

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_NextGradeThresholds(
      targetBooks: null == targetBooks
          ? _self.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _self.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$GradeSummary {
  int get grade;
  int get totalBooks;
  int get totalSeconds;
  int get streakDays;
  int get longestStreak;
  NextGradeThresholds? get nextGradeThresholds;
  int get tier;

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GradeSummaryCopyWith<GradeSummary> get copyWith =>
      _$GradeSummaryCopyWithImpl<GradeSummary>(
          this as GradeSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GradeSummary &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.totalBooks, totalBooks) ||
                other.totalBooks == totalBooks) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.nextGradeThresholds, nextGradeThresholds) ||
                other.nextGradeThresholds == nextGradeThresholds) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @override
  int get hashCode => Object.hash(runtimeType, grade, totalBooks, totalSeconds,
      streakDays, longestStreak, nextGradeThresholds, tier);

  @override
  String toString() {
    return 'GradeSummary(grade: $grade, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak, nextGradeThresholds: $nextGradeThresholds, tier: $tier)';
  }
}

/// @nodoc
abstract mixin class $GradeSummaryCopyWith<$Res> {
  factory $GradeSummaryCopyWith(
          GradeSummary value, $Res Function(GradeSummary) _then) =
      _$GradeSummaryCopyWithImpl;
  @useResult
  $Res call(
      {int grade,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak,
      NextGradeThresholds? nextGradeThresholds,
      int tier});

  $NextGradeThresholdsCopyWith<$Res>? get nextGradeThresholds;
}

/// @nodoc
class _$GradeSummaryCopyWithImpl<$Res> implements $GradeSummaryCopyWith<$Res> {
  _$GradeSummaryCopyWithImpl(this._self, this._then);

  final GradeSummary _self;
  final $Res Function(GradeSummary) _then;

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
    Object? longestStreak = null,
    Object? nextGradeThresholds = freezed,
    Object? tier = null,
  }) {
    return _then(_self.copyWith(
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
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
      longestStreak: null == longestStreak
          ? _self.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      nextGradeThresholds: freezed == nextGradeThresholds
          ? _self.nextGradeThresholds
          : nextGradeThresholds // ignore: cast_nullable_to_non_nullable
              as NextGradeThresholds?,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsCopyWith<$Res>? get nextGradeThresholds {
    if (_self.nextGradeThresholds == null) {
      return null;
    }

    return $NextGradeThresholdsCopyWith<$Res>(_self.nextGradeThresholds!,
        (value) {
      return _then(_self.copyWith(nextGradeThresholds: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GradeSummary].
extension GradeSummaryPatterns on GradeSummary {
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
    TResult Function(_GradeSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GradeSummary() when $default != null:
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
    TResult Function(_GradeSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummary():
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
    TResult? Function(_GradeSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummary() when $default != null:
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
            int grade,
            int totalBooks,
            int totalSeconds,
            int streakDays,
            int longestStreak,
            NextGradeThresholds? nextGradeThresholds,
            int tier)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GradeSummary() when $default != null:
        return $default(
            _that.grade,
            _that.totalBooks,
            _that.totalSeconds,
            _that.streakDays,
            _that.longestStreak,
            _that.nextGradeThresholds,
            _that.tier);
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
            int grade,
            int totalBooks,
            int totalSeconds,
            int streakDays,
            int longestStreak,
            NextGradeThresholds? nextGradeThresholds,
            int tier)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummary():
        return $default(
            _that.grade,
            _that.totalBooks,
            _that.totalSeconds,
            _that.streakDays,
            _that.longestStreak,
            _that.nextGradeThresholds,
            _that.tier);
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
            int grade,
            int totalBooks,
            int totalSeconds,
            int streakDays,
            int longestStreak,
            NextGradeThresholds? nextGradeThresholds,
            int tier)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummary() when $default != null:
        return $default(
            _that.grade,
            _that.totalBooks,
            _that.totalSeconds,
            _that.streakDays,
            _that.longestStreak,
            _that.nextGradeThresholds,
            _that.tier);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GradeSummary extends GradeSummary {
  const _GradeSummary(
      {required this.grade,
      required this.totalBooks,
      required this.totalSeconds,
      required this.streakDays,
      required this.longestStreak,
      this.nextGradeThresholds,
      this.tier = 1})
      : super._();

  @override
  final int grade;
  @override
  final int totalBooks;
  @override
  final int totalSeconds;
  @override
  final int streakDays;
  @override
  final int longestStreak;
  @override
  final NextGradeThresholds? nextGradeThresholds;
  @override
  @JsonKey()
  final int tier;

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GradeSummaryCopyWith<_GradeSummary> get copyWith =>
      __$GradeSummaryCopyWithImpl<_GradeSummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GradeSummary &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.totalBooks, totalBooks) ||
                other.totalBooks == totalBooks) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.nextGradeThresholds, nextGradeThresholds) ||
                other.nextGradeThresholds == nextGradeThresholds) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @override
  int get hashCode => Object.hash(runtimeType, grade, totalBooks, totalSeconds,
      streakDays, longestStreak, nextGradeThresholds, tier);

  @override
  String toString() {
    return 'GradeSummary(grade: $grade, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak, nextGradeThresholds: $nextGradeThresholds, tier: $tier)';
  }
}

/// @nodoc
abstract mixin class _$GradeSummaryCopyWith<$Res>
    implements $GradeSummaryCopyWith<$Res> {
  factory _$GradeSummaryCopyWith(
          _GradeSummary value, $Res Function(_GradeSummary) _then) =
      __$GradeSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int grade,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak,
      NextGradeThresholds? nextGradeThresholds,
      int tier});

  @override
  $NextGradeThresholdsCopyWith<$Res>? get nextGradeThresholds;
}

/// @nodoc
class __$GradeSummaryCopyWithImpl<$Res>
    implements _$GradeSummaryCopyWith<$Res> {
  __$GradeSummaryCopyWithImpl(this._self, this._then);

  final _GradeSummary _self;
  final $Res Function(_GradeSummary) _then;

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? grade = null,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
    Object? longestStreak = null,
    Object? nextGradeThresholds = freezed,
    Object? tier = null,
  }) {
    return _then(_GradeSummary(
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
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
      longestStreak: null == longestStreak
          ? _self.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      nextGradeThresholds: freezed == nextGradeThresholds
          ? _self.nextGradeThresholds
          : nextGradeThresholds // ignore: cast_nullable_to_non_nullable
              as NextGradeThresholds?,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsCopyWith<$Res>? get nextGradeThresholds {
    if (_self.nextGradeThresholds == null) {
      return null;
    }

    return $NextGradeThresholdsCopyWith<$Res>(_self.nextGradeThresholds!,
        (value) {
      return _then(_self.copyWith(nextGradeThresholds: value));
    });
  }
}

// dart format on
