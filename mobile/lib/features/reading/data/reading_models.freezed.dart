// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingSessionDto {
  String get id;
  String get userBookId;
  DateTime get startedAt;
  String get source;
  DateTime? get endedAt;
  int? get durationSec;

  /// Create a copy of ReadingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadingSessionDtoCopyWith<ReadingSessionDto> get copyWith =>
      _$ReadingSessionDtoCopyWithImpl<ReadingSessionDto>(
          this as ReadingSessionDto, _$identity);

  /// Serializes this ReadingSessionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadingSessionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, startedAt, source, endedAt, durationSec);

  @override
  String toString() {
    return 'ReadingSessionDto(id: $id, userBookId: $userBookId, startedAt: $startedAt, source: $source, endedAt: $endedAt, durationSec: $durationSec)';
  }
}

/// @nodoc
abstract mixin class $ReadingSessionDtoCopyWith<$Res> {
  factory $ReadingSessionDtoCopyWith(
          ReadingSessionDto value, $Res Function(ReadingSessionDto) _then) =
      _$ReadingSessionDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userBookId,
      DateTime startedAt,
      String source,
      DateTime? endedAt,
      int? durationSec});
}

/// @nodoc
class _$ReadingSessionDtoCopyWithImpl<$Res>
    implements $ReadingSessionDtoCopyWith<$Res> {
  _$ReadingSessionDtoCopyWithImpl(this._self, this._then);

  final ReadingSessionDto _self;
  final $Res Function(ReadingSessionDto) _then;

  /// Create a copy of ReadingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? source = null,
    Object? endedAt = freezed,
    Object? durationSec = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReadingSessionDto].
extension ReadingSessionDtoPatterns on ReadingSessionDto {
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
    TResult Function(_ReadingSessionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingSessionDto() when $default != null:
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
    TResult Function(_ReadingSessionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSessionDto():
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
    TResult? Function(_ReadingSessionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSessionDto() when $default != null:
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
    TResult Function(String id, String userBookId, DateTime startedAt,
            String source, DateTime? endedAt, int? durationSec)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingSessionDto() when $default != null:
        return $default(_that.id, _that.userBookId, _that.startedAt,
            _that.source, _that.endedAt, _that.durationSec);
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
    TResult Function(String id, String userBookId, DateTime startedAt,
            String source, DateTime? endedAt, int? durationSec)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSessionDto():
        return $default(_that.id, _that.userBookId, _that.startedAt,
            _that.source, _that.endedAt, _that.durationSec);
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
    TResult? Function(String id, String userBookId, DateTime startedAt,
            String source, DateTime? endedAt, int? durationSec)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSessionDto() when $default != null:
        return $default(_that.id, _that.userBookId, _that.startedAt,
            _that.source, _that.endedAt, _that.durationSec);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReadingSessionDto extends ReadingSessionDto {
  const _ReadingSessionDto(
      {required this.id,
      required this.userBookId,
      required this.startedAt,
      required this.source,
      this.endedAt,
      this.durationSec})
      : super._();
  factory _ReadingSessionDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingSessionDtoFromJson(json);

  @override
  final String id;
  @override
  final String userBookId;
  @override
  final DateTime startedAt;
  @override
  final String source;
  @override
  final DateTime? endedAt;
  @override
  final int? durationSec;

  /// Create a copy of ReadingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReadingSessionDtoCopyWith<_ReadingSessionDto> get copyWith =>
      __$ReadingSessionDtoCopyWithImpl<_ReadingSessionDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReadingSessionDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReadingSessionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, startedAt, source, endedAt, durationSec);

  @override
  String toString() {
    return 'ReadingSessionDto(id: $id, userBookId: $userBookId, startedAt: $startedAt, source: $source, endedAt: $endedAt, durationSec: $durationSec)';
  }
}

/// @nodoc
abstract mixin class _$ReadingSessionDtoCopyWith<$Res>
    implements $ReadingSessionDtoCopyWith<$Res> {
  factory _$ReadingSessionDtoCopyWith(
          _ReadingSessionDto value, $Res Function(_ReadingSessionDto) _then) =
      __$ReadingSessionDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userBookId,
      DateTime startedAt,
      String source,
      DateTime? endedAt,
      int? durationSec});
}

/// @nodoc
class __$ReadingSessionDtoCopyWithImpl<$Res>
    implements _$ReadingSessionDtoCopyWith<$Res> {
  __$ReadingSessionDtoCopyWithImpl(this._self, this._then);

  final _ReadingSessionDto _self;
  final $Res Function(_ReadingSessionDto) _then;

  /// Create a copy of ReadingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? source = null,
    Object? endedAt = freezed,
    Object? durationSec = freezed,
  }) {
    return _then(_ReadingSessionDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$NextGradeThresholdsDto {
  int get targetBooks;
  int get targetSeconds;

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsDtoCopyWith<NextGradeThresholdsDto> get copyWith =>
      _$NextGradeThresholdsDtoCopyWithImpl<NextGradeThresholdsDto>(
          this as NextGradeThresholdsDto, _$identity);

  /// Serializes this NextGradeThresholdsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NextGradeThresholdsDto &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetBooks, targetSeconds);

  @override
  String toString() {
    return 'NextGradeThresholdsDto(targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }
}

/// @nodoc
abstract mixin class $NextGradeThresholdsDtoCopyWith<$Res> {
  factory $NextGradeThresholdsDtoCopyWith(NextGradeThresholdsDto value,
          $Res Function(NextGradeThresholdsDto) _then) =
      _$NextGradeThresholdsDtoCopyWithImpl;
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class _$NextGradeThresholdsDtoCopyWithImpl<$Res>
    implements $NextGradeThresholdsDtoCopyWith<$Res> {
  _$NextGradeThresholdsDtoCopyWithImpl(this._self, this._then);

  final NextGradeThresholdsDto _self;
  final $Res Function(NextGradeThresholdsDto) _then;

  /// Create a copy of NextGradeThresholdsDto
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

/// Adds pattern-matching-related methods to [NextGradeThresholdsDto].
extension NextGradeThresholdsDtoPatterns on NextGradeThresholdsDto {
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
    TResult Function(_NextGradeThresholdsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholdsDto() when $default != null:
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
    TResult Function(_NextGradeThresholdsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholdsDto():
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
    TResult? Function(_NextGradeThresholdsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NextGradeThresholdsDto() when $default != null:
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
      case _NextGradeThresholdsDto() when $default != null:
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
      case _NextGradeThresholdsDto():
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
      case _NextGradeThresholdsDto() when $default != null:
        return $default(_that.targetBooks, _that.targetSeconds);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NextGradeThresholdsDto extends NextGradeThresholdsDto {
  const _NextGradeThresholdsDto(
      {required this.targetBooks, required this.targetSeconds})
      : super._();
  factory _NextGradeThresholdsDto.fromJson(Map<String, dynamic> json) =>
      _$NextGradeThresholdsDtoFromJson(json);

  @override
  final int targetBooks;
  @override
  final int targetSeconds;

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NextGradeThresholdsDtoCopyWith<_NextGradeThresholdsDto> get copyWith =>
      __$NextGradeThresholdsDtoCopyWithImpl<_NextGradeThresholdsDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NextGradeThresholdsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NextGradeThresholdsDto &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetBooks, targetSeconds);

  @override
  String toString() {
    return 'NextGradeThresholdsDto(targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }
}

/// @nodoc
abstract mixin class _$NextGradeThresholdsDtoCopyWith<$Res>
    implements $NextGradeThresholdsDtoCopyWith<$Res> {
  factory _$NextGradeThresholdsDtoCopyWith(_NextGradeThresholdsDto value,
          $Res Function(_NextGradeThresholdsDto) _then) =
      __$NextGradeThresholdsDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class __$NextGradeThresholdsDtoCopyWithImpl<$Res>
    implements _$NextGradeThresholdsDtoCopyWith<$Res> {
  __$NextGradeThresholdsDtoCopyWithImpl(this._self, this._then);

  final _NextGradeThresholdsDto _self;
  final $Res Function(_NextGradeThresholdsDto) _then;

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_NextGradeThresholdsDto(
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
mixin _$GradeSummaryDto {
  int get grade;
  int get totalBooks;
  int get totalSeconds;
  int get streakDays;
  int get longestStreak;
  NextGradeThresholdsDto? get nextGradeThresholds;
  int get tier;

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GradeSummaryDtoCopyWith<GradeSummaryDto> get copyWith =>
      _$GradeSummaryDtoCopyWithImpl<GradeSummaryDto>(
          this as GradeSummaryDto, _$identity);

  /// Serializes this GradeSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GradeSummaryDto &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, grade, totalBooks, totalSeconds,
      streakDays, longestStreak, nextGradeThresholds, tier);

  @override
  String toString() {
    return 'GradeSummaryDto(grade: $grade, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak, nextGradeThresholds: $nextGradeThresholds, tier: $tier)';
  }
}

/// @nodoc
abstract mixin class $GradeSummaryDtoCopyWith<$Res> {
  factory $GradeSummaryDtoCopyWith(
          GradeSummaryDto value, $Res Function(GradeSummaryDto) _then) =
      _$GradeSummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {int grade,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak,
      NextGradeThresholdsDto? nextGradeThresholds,
      int tier});

  $NextGradeThresholdsDtoCopyWith<$Res>? get nextGradeThresholds;
}

/// @nodoc
class _$GradeSummaryDtoCopyWithImpl<$Res>
    implements $GradeSummaryDtoCopyWith<$Res> {
  _$GradeSummaryDtoCopyWithImpl(this._self, this._then);

  final GradeSummaryDto _self;
  final $Res Function(GradeSummaryDto) _then;

  /// Create a copy of GradeSummaryDto
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
              as NextGradeThresholdsDto?,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsDtoCopyWith<$Res>? get nextGradeThresholds {
    if (_self.nextGradeThresholds == null) {
      return null;
    }

    return $NextGradeThresholdsDtoCopyWith<$Res>(_self.nextGradeThresholds!,
        (value) {
      return _then(_self.copyWith(nextGradeThresholds: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GradeSummaryDto].
extension GradeSummaryDtoPatterns on GradeSummaryDto {
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
    TResult Function(_GradeSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GradeSummaryDto() when $default != null:
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
    TResult Function(_GradeSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummaryDto():
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
    TResult? Function(_GradeSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummaryDto() when $default != null:
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
            NextGradeThresholdsDto? nextGradeThresholds,
            int tier)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GradeSummaryDto() when $default != null:
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
            NextGradeThresholdsDto? nextGradeThresholds,
            int tier)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummaryDto():
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
            NextGradeThresholdsDto? nextGradeThresholds,
            int tier)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GradeSummaryDto() when $default != null:
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
@JsonSerializable()
class _GradeSummaryDto extends GradeSummaryDto {
  const _GradeSummaryDto(
      {required this.grade,
      required this.totalBooks,
      required this.totalSeconds,
      required this.streakDays,
      required this.longestStreak,
      this.nextGradeThresholds,
      this.tier = 1})
      : super._();
  factory _GradeSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$GradeSummaryDtoFromJson(json);

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
  final NextGradeThresholdsDto? nextGradeThresholds;
  @override
  @JsonKey()
  final int tier;

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GradeSummaryDtoCopyWith<_GradeSummaryDto> get copyWith =>
      __$GradeSummaryDtoCopyWithImpl<_GradeSummaryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GradeSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GradeSummaryDto &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, grade, totalBooks, totalSeconds,
      streakDays, longestStreak, nextGradeThresholds, tier);

  @override
  String toString() {
    return 'GradeSummaryDto(grade: $grade, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak, nextGradeThresholds: $nextGradeThresholds, tier: $tier)';
  }
}

/// @nodoc
abstract mixin class _$GradeSummaryDtoCopyWith<$Res>
    implements $GradeSummaryDtoCopyWith<$Res> {
  factory _$GradeSummaryDtoCopyWith(
          _GradeSummaryDto value, $Res Function(_GradeSummaryDto) _then) =
      __$GradeSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int grade,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak,
      NextGradeThresholdsDto? nextGradeThresholds,
      int tier});

  @override
  $NextGradeThresholdsDtoCopyWith<$Res>? get nextGradeThresholds;
}

/// @nodoc
class __$GradeSummaryDtoCopyWithImpl<$Res>
    implements _$GradeSummaryDtoCopyWith<$Res> {
  __$GradeSummaryDtoCopyWithImpl(this._self, this._then);

  final _GradeSummaryDto _self;
  final $Res Function(_GradeSummaryDto) _then;

  /// Create a copy of GradeSummaryDto
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
    return _then(_GradeSummaryDto(
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
              as NextGradeThresholdsDto?,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsDtoCopyWith<$Res>? get nextGradeThresholds {
    if (_self.nextGradeThresholds == null) {
      return null;
    }

    return $NextGradeThresholdsDtoCopyWith<$Res>(_self.nextGradeThresholds!,
        (value) {
      return _then(_self.copyWith(nextGradeThresholds: value));
    });
  }
}

/// @nodoc
mixin _$SessionCompletionDto {
  ReadingSessionDto get session;
  GradeSummaryDto get grade;
  int get streakDays;
  bool get gradeUp;

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionCompletionDtoCopyWith<SessionCompletionDto> get copyWith =>
      _$SessionCompletionDtoCopyWithImpl<SessionCompletionDto>(
          this as SessionCompletionDto, _$identity);

  /// Serializes this SessionCompletionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionCompletionDto &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.gradeUp, gradeUp) || other.gradeUp == gradeUp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, session, grade, streakDays, gradeUp);

  @override
  String toString() {
    return 'SessionCompletionDto(session: $session, grade: $grade, streakDays: $streakDays, gradeUp: $gradeUp)';
  }
}

/// @nodoc
abstract mixin class $SessionCompletionDtoCopyWith<$Res> {
  factory $SessionCompletionDtoCopyWith(SessionCompletionDto value,
          $Res Function(SessionCompletionDto) _then) =
      _$SessionCompletionDtoCopyWithImpl;
  @useResult
  $Res call(
      {ReadingSessionDto session,
      GradeSummaryDto grade,
      int streakDays,
      bool gradeUp});

  $ReadingSessionDtoCopyWith<$Res> get session;
  $GradeSummaryDtoCopyWith<$Res> get grade;
}

/// @nodoc
class _$SessionCompletionDtoCopyWithImpl<$Res>
    implements $SessionCompletionDtoCopyWith<$Res> {
  _$SessionCompletionDtoCopyWithImpl(this._self, this._then);

  final SessionCompletionDto _self;
  final $Res Function(SessionCompletionDto) _then;

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? grade = null,
    Object? streakDays = null,
    Object? gradeUp = null,
  }) {
    return _then(_self.copyWith(
      session: null == session
          ? _self.session
          : session // ignore: cast_nullable_to_non_nullable
              as ReadingSessionDto,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as GradeSummaryDto,
      streakDays: null == streakDays
          ? _self.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      gradeUp: null == gradeUp
          ? _self.gradeUp
          : gradeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingSessionDtoCopyWith<$Res> get session {
    return $ReadingSessionDtoCopyWith<$Res>(_self.session, (value) {
      return _then(_self.copyWith(session: value));
    });
  }

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeSummaryDtoCopyWith<$Res> get grade {
    return $GradeSummaryDtoCopyWith<$Res>(_self.grade, (value) {
      return _then(_self.copyWith(grade: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SessionCompletionDto].
extension SessionCompletionDtoPatterns on SessionCompletionDto {
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
    TResult Function(_SessionCompletionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionCompletionDto() when $default != null:
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
    TResult Function(_SessionCompletionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletionDto():
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
    TResult? Function(_SessionCompletionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletionDto() when $default != null:
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
    TResult Function(ReadingSessionDto session, GradeSummaryDto grade,
            int streakDays, bool gradeUp)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionCompletionDto() when $default != null:
        return $default(
            _that.session, _that.grade, _that.streakDays, _that.gradeUp);
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
    TResult Function(ReadingSessionDto session, GradeSummaryDto grade,
            int streakDays, bool gradeUp)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletionDto():
        return $default(
            _that.session, _that.grade, _that.streakDays, _that.gradeUp);
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
    TResult? Function(ReadingSessionDto session, GradeSummaryDto grade,
            int streakDays, bool gradeUp)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletionDto() when $default != null:
        return $default(
            _that.session, _that.grade, _that.streakDays, _that.gradeUp);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SessionCompletionDto extends SessionCompletionDto {
  const _SessionCompletionDto(
      {required this.session,
      required this.grade,
      required this.streakDays,
      required this.gradeUp})
      : super._();
  factory _SessionCompletionDto.fromJson(Map<String, dynamic> json) =>
      _$SessionCompletionDtoFromJson(json);

  @override
  final ReadingSessionDto session;
  @override
  final GradeSummaryDto grade;
  @override
  final int streakDays;
  @override
  final bool gradeUp;

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionCompletionDtoCopyWith<_SessionCompletionDto> get copyWith =>
      __$SessionCompletionDtoCopyWithImpl<_SessionCompletionDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionCompletionDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionCompletionDto &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.gradeUp, gradeUp) || other.gradeUp == gradeUp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, session, grade, streakDays, gradeUp);

  @override
  String toString() {
    return 'SessionCompletionDto(session: $session, grade: $grade, streakDays: $streakDays, gradeUp: $gradeUp)';
  }
}

/// @nodoc
abstract mixin class _$SessionCompletionDtoCopyWith<$Res>
    implements $SessionCompletionDtoCopyWith<$Res> {
  factory _$SessionCompletionDtoCopyWith(_SessionCompletionDto value,
          $Res Function(_SessionCompletionDto) _then) =
      __$SessionCompletionDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ReadingSessionDto session,
      GradeSummaryDto grade,
      int streakDays,
      bool gradeUp});

  @override
  $ReadingSessionDtoCopyWith<$Res> get session;
  @override
  $GradeSummaryDtoCopyWith<$Res> get grade;
}

/// @nodoc
class __$SessionCompletionDtoCopyWithImpl<$Res>
    implements _$SessionCompletionDtoCopyWith<$Res> {
  __$SessionCompletionDtoCopyWithImpl(this._self, this._then);

  final _SessionCompletionDto _self;
  final $Res Function(_SessionCompletionDto) _then;

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? session = null,
    Object? grade = null,
    Object? streakDays = null,
    Object? gradeUp = null,
  }) {
    return _then(_SessionCompletionDto(
      session: null == session
          ? _self.session
          : session // ignore: cast_nullable_to_non_nullable
              as ReadingSessionDto,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as GradeSummaryDto,
      streakDays: null == streakDays
          ? _self.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      gradeUp: null == gradeUp
          ? _self.gradeUp
          : gradeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingSessionDtoCopyWith<$Res> get session {
    return $ReadingSessionDtoCopyWith<$Res>(_self.session, (value) {
      return _then(_self.copyWith(session: value));
    });
  }

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeSummaryDtoCopyWith<$Res> get grade {
    return $GradeSummaryDtoCopyWith<$Res>(_self.grade, (value) {
      return _then(_self.copyWith(grade: value));
    });
  }
}

/// @nodoc
mixin _$HeatmapItemDto {
  String get date;
  int get totalSeconds;
  int get sessionCount;

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeatmapItemDtoCopyWith<HeatmapItemDto> get copyWith =>
      _$HeatmapItemDtoCopyWithImpl<HeatmapItemDto>(
          this as HeatmapItemDto, _$identity);

  /// Serializes this HeatmapItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeatmapItemDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, totalSeconds, sessionCount);

  @override
  String toString() {
    return 'HeatmapItemDto(date: $date, totalSeconds: $totalSeconds, sessionCount: $sessionCount)';
  }
}

/// @nodoc
abstract mixin class $HeatmapItemDtoCopyWith<$Res> {
  factory $HeatmapItemDtoCopyWith(
          HeatmapItemDto value, $Res Function(HeatmapItemDto) _then) =
      _$HeatmapItemDtoCopyWithImpl;
  @useResult
  $Res call({String date, int totalSeconds, int sessionCount});
}

/// @nodoc
class _$HeatmapItemDtoCopyWithImpl<$Res>
    implements $HeatmapItemDtoCopyWith<$Res> {
  _$HeatmapItemDtoCopyWithImpl(this._self, this._then);

  final HeatmapItemDto _self;
  final $Res Function(HeatmapItemDto) _then;

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _self.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeatmapItemDto].
extension HeatmapItemDtoPatterns on HeatmapItemDto {
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
    TResult Function(_HeatmapItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatmapItemDto() when $default != null:
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
    TResult Function(_HeatmapItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapItemDto():
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
    TResult? Function(_HeatmapItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapItemDto() when $default != null:
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
    TResult Function(String date, int totalSeconds, int sessionCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatmapItemDto() when $default != null:
        return $default(_that.date, _that.totalSeconds, _that.sessionCount);
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
    TResult Function(String date, int totalSeconds, int sessionCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapItemDto():
        return $default(_that.date, _that.totalSeconds, _that.sessionCount);
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
    TResult? Function(String date, int totalSeconds, int sessionCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapItemDto() when $default != null:
        return $default(_that.date, _that.totalSeconds, _that.sessionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeatmapItemDto extends HeatmapItemDto {
  const _HeatmapItemDto(
      {required this.date,
      required this.totalSeconds,
      required this.sessionCount})
      : super._();
  factory _HeatmapItemDto.fromJson(Map<String, dynamic> json) =>
      _$HeatmapItemDtoFromJson(json);

  @override
  final String date;
  @override
  final int totalSeconds;
  @override
  final int sessionCount;

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeatmapItemDtoCopyWith<_HeatmapItemDto> get copyWith =>
      __$HeatmapItemDtoCopyWithImpl<_HeatmapItemDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeatmapItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeatmapItemDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, totalSeconds, sessionCount);

  @override
  String toString() {
    return 'HeatmapItemDto(date: $date, totalSeconds: $totalSeconds, sessionCount: $sessionCount)';
  }
}

/// @nodoc
abstract mixin class _$HeatmapItemDtoCopyWith<$Res>
    implements $HeatmapItemDtoCopyWith<$Res> {
  factory _$HeatmapItemDtoCopyWith(
          _HeatmapItemDto value, $Res Function(_HeatmapItemDto) _then) =
      __$HeatmapItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String date, int totalSeconds, int sessionCount});
}

/// @nodoc
class __$HeatmapItemDtoCopyWithImpl<$Res>
    implements _$HeatmapItemDtoCopyWith<$Res> {
  __$HeatmapItemDtoCopyWithImpl(this._self, this._then);

  final _HeatmapItemDto _self;
  final $Res Function(_HeatmapItemDto) _then;

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
  }) {
    return _then(_HeatmapItemDto(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _self.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$HeatmapResponseDto {
  List<HeatmapItemDto> get items;

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeatmapResponseDtoCopyWith<HeatmapResponseDto> get copyWith =>
      _$HeatmapResponseDtoCopyWithImpl<HeatmapResponseDto>(
          this as HeatmapResponseDto, _$identity);

  /// Serializes this HeatmapResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeatmapResponseDto &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'HeatmapResponseDto(items: $items)';
  }
}

/// @nodoc
abstract mixin class $HeatmapResponseDtoCopyWith<$Res> {
  factory $HeatmapResponseDtoCopyWith(
          HeatmapResponseDto value, $Res Function(HeatmapResponseDto) _then) =
      _$HeatmapResponseDtoCopyWithImpl;
  @useResult
  $Res call({List<HeatmapItemDto> items});
}

/// @nodoc
class _$HeatmapResponseDtoCopyWithImpl<$Res>
    implements $HeatmapResponseDtoCopyWith<$Res> {
  _$HeatmapResponseDtoCopyWithImpl(this._self, this._then);

  final HeatmapResponseDto _self;
  final $Res Function(HeatmapResponseDto) _then;

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HeatmapItemDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeatmapResponseDto].
extension HeatmapResponseDtoPatterns on HeatmapResponseDto {
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
    TResult Function(_HeatmapResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatmapResponseDto() when $default != null:
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
    TResult Function(_HeatmapResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapResponseDto():
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
    TResult? Function(_HeatmapResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapResponseDto() when $default != null:
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
    TResult Function(List<HeatmapItemDto> items)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatmapResponseDto() when $default != null:
        return $default(_that.items);
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
    TResult Function(List<HeatmapItemDto> items) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapResponseDto():
        return $default(_that.items);
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
    TResult? Function(List<HeatmapItemDto> items)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatmapResponseDto() when $default != null:
        return $default(_that.items);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeatmapResponseDto implements HeatmapResponseDto {
  const _HeatmapResponseDto({required final List<HeatmapItemDto> items})
      : _items = items;
  factory _HeatmapResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HeatmapResponseDtoFromJson(json);

  final List<HeatmapItemDto> _items;
  @override
  List<HeatmapItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeatmapResponseDtoCopyWith<_HeatmapResponseDto> get copyWith =>
      __$HeatmapResponseDtoCopyWithImpl<_HeatmapResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeatmapResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeatmapResponseDto &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'HeatmapResponseDto(items: $items)';
  }
}

/// @nodoc
abstract mixin class _$HeatmapResponseDtoCopyWith<$Res>
    implements $HeatmapResponseDtoCopyWith<$Res> {
  factory _$HeatmapResponseDtoCopyWith(
          _HeatmapResponseDto value, $Res Function(_HeatmapResponseDto) _then) =
      __$HeatmapResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<HeatmapItemDto> items});
}

/// @nodoc
class __$HeatmapResponseDtoCopyWithImpl<$Res>
    implements _$HeatmapResponseDtoCopyWith<$Res> {
  __$HeatmapResponseDtoCopyWithImpl(this._self, this._then);

  final _HeatmapResponseDto _self;
  final $Res Function(_HeatmapResponseDto) _then;

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
  }) {
    return _then(_HeatmapResponseDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HeatmapItemDto>,
    ));
  }
}

/// @nodoc
mixin _$GoalDto {
  String get id;
  String get period;
  int get targetBooks;
  int get targetSeconds;
  DateTime get startDate;
  DateTime get endDate;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalDtoCopyWith<GoalDto> get copyWith =>
      _$GoalDtoCopyWithImpl<GoalDto>(this as GoalDto, _$identity);

  /// Serializes this GoalDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, period, targetBooks, targetSeconds, startDate, endDate);

  @override
  String toString() {
    return 'GoalDto(id: $id, period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $GoalDtoCopyWith<$Res> {
  factory $GoalDtoCopyWith(GoalDto value, $Res Function(GoalDto) _then) =
      _$GoalDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String period,
      int targetBooks,
      int targetSeconds,
      DateTime startDate,
      DateTime endDate});
}

/// @nodoc
class _$GoalDtoCopyWithImpl<$Res> implements $GoalDtoCopyWith<$Res> {
  _$GoalDtoCopyWithImpl(this._self, this._then);

  final GoalDto _self;
  final $Res Function(GoalDto) _then;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? period = null,
    Object? targetBooks = null,
    Object? targetSeconds = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      targetBooks: null == targetBooks
          ? _self.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _self.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [GoalDto].
extension GoalDtoPatterns on GoalDto {
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
    TResult Function(_GoalDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
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
    TResult Function(_GoalDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto():
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
    TResult? Function(_GoalDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
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
    TResult Function(String id, String period, int targetBooks,
            int targetSeconds, DateTime startDate, DateTime endDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
        return $default(_that.id, _that.period, _that.targetBooks,
            _that.targetSeconds, _that.startDate, _that.endDate);
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
    TResult Function(String id, String period, int targetBooks,
            int targetSeconds, DateTime startDate, DateTime endDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto():
        return $default(_that.id, _that.period, _that.targetBooks,
            _that.targetSeconds, _that.startDate, _that.endDate);
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
    TResult? Function(String id, String period, int targetBooks,
            int targetSeconds, DateTime startDate, DateTime endDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
        return $default(_that.id, _that.period, _that.targetBooks,
            _that.targetSeconds, _that.startDate, _that.endDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GoalDto extends GoalDto {
  const _GoalDto(
      {required this.id,
      required this.period,
      required this.targetBooks,
      required this.targetSeconds,
      required this.startDate,
      required this.endDate})
      : super._();
  factory _GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);

  @override
  final String id;
  @override
  final String period;
  @override
  final int targetBooks;
  @override
  final int targetSeconds;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalDtoCopyWith<_GoalDto> get copyWith =>
      __$GoalDtoCopyWithImpl<_GoalDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, period, targetBooks, targetSeconds, startDate, endDate);

  @override
  String toString() {
    return 'GoalDto(id: $id, period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$GoalDtoCopyWith<$Res> implements $GoalDtoCopyWith<$Res> {
  factory _$GoalDtoCopyWith(_GoalDto value, $Res Function(_GoalDto) _then) =
      __$GoalDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String period,
      int targetBooks,
      int targetSeconds,
      DateTime startDate,
      DateTime endDate});
}

/// @nodoc
class __$GoalDtoCopyWithImpl<$Res> implements _$GoalDtoCopyWith<$Res> {
  __$GoalDtoCopyWithImpl(this._self, this._then);

  final _GoalDto _self;
  final $Res Function(_GoalDto) _then;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? period = null,
    Object? targetBooks = null,
    Object? targetSeconds = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_GoalDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      targetBooks: null == targetBooks
          ? _self.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _self.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$GoalProgressDto {
  GoalDto get goal;
  int get booksDone;
  int get secondsDone;
  double get percent;

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalProgressDtoCopyWith<GoalProgressDto> get copyWith =>
      _$GoalProgressDtoCopyWithImpl<GoalProgressDto>(
          this as GoalProgressDto, _$identity);

  /// Serializes this GoalProgressDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalProgressDto &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.booksDone, booksDone) ||
                other.booksDone == booksDone) &&
            (identical(other.secondsDone, secondsDone) ||
                other.secondsDone == secondsDone) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, goal, booksDone, secondsDone, percent);

  @override
  String toString() {
    return 'GoalProgressDto(goal: $goal, booksDone: $booksDone, secondsDone: $secondsDone, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class $GoalProgressDtoCopyWith<$Res> {
  factory $GoalProgressDtoCopyWith(
          GoalProgressDto value, $Res Function(GoalProgressDto) _then) =
      _$GoalProgressDtoCopyWithImpl;
  @useResult
  $Res call({GoalDto goal, int booksDone, int secondsDone, double percent});

  $GoalDtoCopyWith<$Res> get goal;
}

/// @nodoc
class _$GoalProgressDtoCopyWithImpl<$Res>
    implements $GoalProgressDtoCopyWith<$Res> {
  _$GoalProgressDtoCopyWithImpl(this._self, this._then);

  final GoalProgressDto _self;
  final $Res Function(GoalProgressDto) _then;

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goal = null,
    Object? booksDone = null,
    Object? secondsDone = null,
    Object? percent = null,
  }) {
    return _then(_self.copyWith(
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as GoalDto,
      booksDone: null == booksDone
          ? _self.booksDone
          : booksDone // ignore: cast_nullable_to_non_nullable
              as int,
      secondsDone: null == secondsDone
          ? _self.secondsDone
          : secondsDone // ignore: cast_nullable_to_non_nullable
              as int,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalDtoCopyWith<$Res> get goal {
    return $GoalDtoCopyWith<$Res>(_self.goal, (value) {
      return _then(_self.copyWith(goal: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GoalProgressDto].
extension GoalProgressDtoPatterns on GoalProgressDto {
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
    TResult Function(_GoalProgressDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalProgressDto() when $default != null:
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
    TResult Function(_GoalProgressDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgressDto():
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
    TResult? Function(_GoalProgressDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgressDto() when $default != null:
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
            GoalDto goal, int booksDone, int secondsDone, double percent)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalProgressDto() when $default != null:
        return $default(
            _that.goal, _that.booksDone, _that.secondsDone, _that.percent);
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
            GoalDto goal, int booksDone, int secondsDone, double percent)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgressDto():
        return $default(
            _that.goal, _that.booksDone, _that.secondsDone, _that.percent);
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
            GoalDto goal, int booksDone, int secondsDone, double percent)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgressDto() when $default != null:
        return $default(
            _that.goal, _that.booksDone, _that.secondsDone, _that.percent);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GoalProgressDto extends GoalProgressDto {
  const _GoalProgressDto(
      {required this.goal,
      required this.booksDone,
      required this.secondsDone,
      required this.percent})
      : super._();
  factory _GoalProgressDto.fromJson(Map<String, dynamic> json) =>
      _$GoalProgressDtoFromJson(json);

  @override
  final GoalDto goal;
  @override
  final int booksDone;
  @override
  final int secondsDone;
  @override
  final double percent;

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalProgressDtoCopyWith<_GoalProgressDto> get copyWith =>
      __$GoalProgressDtoCopyWithImpl<_GoalProgressDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalProgressDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalProgressDto &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.booksDone, booksDone) ||
                other.booksDone == booksDone) &&
            (identical(other.secondsDone, secondsDone) ||
                other.secondsDone == secondsDone) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, goal, booksDone, secondsDone, percent);

  @override
  String toString() {
    return 'GoalProgressDto(goal: $goal, booksDone: $booksDone, secondsDone: $secondsDone, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class _$GoalProgressDtoCopyWith<$Res>
    implements $GoalProgressDtoCopyWith<$Res> {
  factory _$GoalProgressDtoCopyWith(
          _GoalProgressDto value, $Res Function(_GoalProgressDto) _then) =
      __$GoalProgressDtoCopyWithImpl;
  @override
  @useResult
  $Res call({GoalDto goal, int booksDone, int secondsDone, double percent});

  @override
  $GoalDtoCopyWith<$Res> get goal;
}

/// @nodoc
class __$GoalProgressDtoCopyWithImpl<$Res>
    implements _$GoalProgressDtoCopyWith<$Res> {
  __$GoalProgressDtoCopyWithImpl(this._self, this._then);

  final _GoalProgressDto _self;
  final $Res Function(_GoalProgressDto) _then;

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? goal = null,
    Object? booksDone = null,
    Object? secondsDone = null,
    Object? percent = null,
  }) {
    return _then(_GoalProgressDto(
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as GoalDto,
      booksDone: null == booksDone
          ? _self.booksDone
          : booksDone // ignore: cast_nullable_to_non_nullable
              as int,
      secondsDone: null == secondsDone
          ? _self.secondsDone
          : secondsDone // ignore: cast_nullable_to_non_nullable
              as int,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalDtoCopyWith<$Res> get goal {
    return $GoalDtoCopyWith<$Res>(_self.goal, (value) {
      return _then(_self.copyWith(goal: value));
    });
  }
}

/// @nodoc
mixin _$DailySessionDto {
  String get sessionId;
  DateTime get startedAt;
  DateTime get endedAt;
  int get durationSec;
  String get source;
  String get bookId;
  String get bookTitle;
  String get bookAuthor;
  String? get bookCoverUrl;

  /// Create a copy of DailySessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailySessionDtoCopyWith<DailySessionDto> get copyWith =>
      _$DailySessionDtoCopyWithImpl<DailySessionDto>(
          this as DailySessionDto, _$identity);

  /// Serializes this DailySessionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailySessionDto &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookAuthor, bookAuthor) ||
                other.bookAuthor == bookAuthor) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, startedAt, endedAt,
      durationSec, source, bookId, bookTitle, bookAuthor, bookCoverUrl);

  @override
  String toString() {
    return 'DailySessionDto(sessionId: $sessionId, startedAt: $startedAt, endedAt: $endedAt, durationSec: $durationSec, source: $source, bookId: $bookId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookCoverUrl: $bookCoverUrl)';
  }
}

/// @nodoc
abstract mixin class $DailySessionDtoCopyWith<$Res> {
  factory $DailySessionDtoCopyWith(
          DailySessionDto value, $Res Function(DailySessionDto) _then) =
      _$DailySessionDtoCopyWithImpl;
  @useResult
  $Res call(
      {String sessionId,
      DateTime startedAt,
      DateTime endedAt,
      int durationSec,
      String source,
      String bookId,
      String bookTitle,
      String bookAuthor,
      String? bookCoverUrl});
}

/// @nodoc
class _$DailySessionDtoCopyWithImpl<$Res>
    implements $DailySessionDtoCopyWith<$Res> {
  _$DailySessionDtoCopyWithImpl(this._self, this._then);

  final DailySessionDto _self;
  final $Res Function(DailySessionDto) _then;

  /// Create a copy of DailySessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? durationSec = null,
    Object? source = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? bookCoverUrl = freezed,
  }) {
    return _then(_self.copyWith(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationSec: null == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: null == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      bookAuthor: null == bookAuthor
          ? _self.bookAuthor
          : bookAuthor // ignore: cast_nullable_to_non_nullable
              as String,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DailySessionDto].
extension DailySessionDtoPatterns on DailySessionDto {
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
    TResult Function(_DailySessionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailySessionDto() when $default != null:
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
    TResult Function(_DailySessionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionDto():
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
    TResult? Function(_DailySessionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionDto() when $default != null:
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
            String sessionId,
            DateTime startedAt,
            DateTime endedAt,
            int durationSec,
            String source,
            String bookId,
            String bookTitle,
            String bookAuthor,
            String? bookCoverUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailySessionDto() when $default != null:
        return $default(
            _that.sessionId,
            _that.startedAt,
            _that.endedAt,
            _that.durationSec,
            _that.source,
            _that.bookId,
            _that.bookTitle,
            _that.bookAuthor,
            _that.bookCoverUrl);
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
            String sessionId,
            DateTime startedAt,
            DateTime endedAt,
            int durationSec,
            String source,
            String bookId,
            String bookTitle,
            String bookAuthor,
            String? bookCoverUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionDto():
        return $default(
            _that.sessionId,
            _that.startedAt,
            _that.endedAt,
            _that.durationSec,
            _that.source,
            _that.bookId,
            _that.bookTitle,
            _that.bookAuthor,
            _that.bookCoverUrl);
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
            String sessionId,
            DateTime startedAt,
            DateTime endedAt,
            int durationSec,
            String source,
            String bookId,
            String bookTitle,
            String bookAuthor,
            String? bookCoverUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionDto() when $default != null:
        return $default(
            _that.sessionId,
            _that.startedAt,
            _that.endedAt,
            _that.durationSec,
            _that.source,
            _that.bookId,
            _that.bookTitle,
            _that.bookAuthor,
            _that.bookCoverUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DailySessionDto implements DailySessionDto {
  const _DailySessionDto(
      {required this.sessionId,
      required this.startedAt,
      required this.endedAt,
      required this.durationSec,
      required this.source,
      required this.bookId,
      required this.bookTitle,
      required this.bookAuthor,
      this.bookCoverUrl});
  factory _DailySessionDto.fromJson(Map<String, dynamic> json) =>
      _$DailySessionDtoFromJson(json);

  @override
  final String sessionId;
  @override
  final DateTime startedAt;
  @override
  final DateTime endedAt;
  @override
  final int durationSec;
  @override
  final String source;
  @override
  final String bookId;
  @override
  final String bookTitle;
  @override
  final String bookAuthor;
  @override
  final String? bookCoverUrl;

  /// Create a copy of DailySessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DailySessionDtoCopyWith<_DailySessionDto> get copyWith =>
      __$DailySessionDtoCopyWithImpl<_DailySessionDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DailySessionDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DailySessionDto &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookAuthor, bookAuthor) ||
                other.bookAuthor == bookAuthor) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, startedAt, endedAt,
      durationSec, source, bookId, bookTitle, bookAuthor, bookCoverUrl);

  @override
  String toString() {
    return 'DailySessionDto(sessionId: $sessionId, startedAt: $startedAt, endedAt: $endedAt, durationSec: $durationSec, source: $source, bookId: $bookId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookCoverUrl: $bookCoverUrl)';
  }
}

/// @nodoc
abstract mixin class _$DailySessionDtoCopyWith<$Res>
    implements $DailySessionDtoCopyWith<$Res> {
  factory _$DailySessionDtoCopyWith(
          _DailySessionDto value, $Res Function(_DailySessionDto) _then) =
      __$DailySessionDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String sessionId,
      DateTime startedAt,
      DateTime endedAt,
      int durationSec,
      String source,
      String bookId,
      String bookTitle,
      String bookAuthor,
      String? bookCoverUrl});
}

/// @nodoc
class __$DailySessionDtoCopyWithImpl<$Res>
    implements _$DailySessionDtoCopyWith<$Res> {
  __$DailySessionDtoCopyWithImpl(this._self, this._then);

  final _DailySessionDto _self;
  final $Res Function(_DailySessionDto) _then;

  /// Create a copy of DailySessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sessionId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? durationSec = null,
    Object? source = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? bookCoverUrl = freezed,
  }) {
    return _then(_DailySessionDto(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationSec: null == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: null == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      bookAuthor: null == bookAuthor
          ? _self.bookAuthor
          : bookAuthor // ignore: cast_nullable_to_non_nullable
              as String,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$DailySessionsResponseDto {
  String get date;
  int get totalSeconds;
  List<DailySessionDto> get sessions;

  /// Create a copy of DailySessionsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailySessionsResponseDtoCopyWith<DailySessionsResponseDto> get copyWith =>
      _$DailySessionsResponseDtoCopyWithImpl<DailySessionsResponseDto>(
          this as DailySessionsResponseDto, _$identity);

  /// Serializes this DailySessionsResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailySessionsResponseDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            const DeepCollectionEquality().equals(other.sessions, sessions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalSeconds,
      const DeepCollectionEquality().hash(sessions));

  @override
  String toString() {
    return 'DailySessionsResponseDto(date: $date, totalSeconds: $totalSeconds, sessions: $sessions)';
  }
}

/// @nodoc
abstract mixin class $DailySessionsResponseDtoCopyWith<$Res> {
  factory $DailySessionsResponseDtoCopyWith(DailySessionsResponseDto value,
          $Res Function(DailySessionsResponseDto) _then) =
      _$DailySessionsResponseDtoCopyWithImpl;
  @useResult
  $Res call({String date, int totalSeconds, List<DailySessionDto> sessions});
}

/// @nodoc
class _$DailySessionsResponseDtoCopyWithImpl<$Res>
    implements $DailySessionsResponseDtoCopyWith<$Res> {
  _$DailySessionsResponseDtoCopyWithImpl(this._self, this._then);

  final DailySessionsResponseDto _self;
  final $Res Function(DailySessionsResponseDto) _then;

  /// Create a copy of DailySessionsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessions = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessions: null == sessions
          ? _self.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<DailySessionDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DailySessionsResponseDto].
extension DailySessionsResponseDtoPatterns on DailySessionsResponseDto {
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
    TResult Function(_DailySessionsResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailySessionsResponseDto() when $default != null:
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
    TResult Function(_DailySessionsResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionsResponseDto():
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
    TResult? Function(_DailySessionsResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionsResponseDto() when $default != null:
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
            String date, int totalSeconds, List<DailySessionDto> sessions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailySessionsResponseDto() when $default != null:
        return $default(_that.date, _that.totalSeconds, _that.sessions);
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
            String date, int totalSeconds, List<DailySessionDto> sessions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionsResponseDto():
        return $default(_that.date, _that.totalSeconds, _that.sessions);
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
            String date, int totalSeconds, List<DailySessionDto> sessions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailySessionsResponseDto() when $default != null:
        return $default(_that.date, _that.totalSeconds, _that.sessions);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DailySessionsResponseDto implements DailySessionsResponseDto {
  const _DailySessionsResponseDto(
      {required this.date,
      required this.totalSeconds,
      required final List<DailySessionDto> sessions})
      : _sessions = sessions;
  factory _DailySessionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DailySessionsResponseDtoFromJson(json);

  @override
  final String date;
  @override
  final int totalSeconds;
  final List<DailySessionDto> _sessions;
  @override
  List<DailySessionDto> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  /// Create a copy of DailySessionsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DailySessionsResponseDtoCopyWith<_DailySessionsResponseDto> get copyWith =>
      __$DailySessionsResponseDtoCopyWithImpl<_DailySessionsResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DailySessionsResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DailySessionsResponseDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            const DeepCollectionEquality().equals(other._sessions, _sessions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalSeconds,
      const DeepCollectionEquality().hash(_sessions));

  @override
  String toString() {
    return 'DailySessionsResponseDto(date: $date, totalSeconds: $totalSeconds, sessions: $sessions)';
  }
}

/// @nodoc
abstract mixin class _$DailySessionsResponseDtoCopyWith<$Res>
    implements $DailySessionsResponseDtoCopyWith<$Res> {
  factory _$DailySessionsResponseDtoCopyWith(_DailySessionsResponseDto value,
          $Res Function(_DailySessionsResponseDto) _then) =
      __$DailySessionsResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String date, int totalSeconds, List<DailySessionDto> sessions});
}

/// @nodoc
class __$DailySessionsResponseDtoCopyWithImpl<$Res>
    implements _$DailySessionsResponseDtoCopyWith<$Res> {
  __$DailySessionsResponseDtoCopyWithImpl(this._self, this._then);

  final _DailySessionsResponseDto _self;
  final $Res Function(_DailySessionsResponseDto) _then;

  /// Create a copy of DailySessionsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessions = null,
  }) {
    return _then(_DailySessionsResponseDto(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessions: null == sessions
          ? _self._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<DailySessionDto>,
    ));
  }
}

/// @nodoc
mixin _$StartSessionRequest {
  String get userBookId;
  String get device;

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StartSessionRequestCopyWith<StartSessionRequest> get copyWith =>
      _$StartSessionRequestCopyWithImpl<StartSessionRequest>(
          this as StartSessionRequest, _$identity);

  /// Serializes this StartSessionRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StartSessionRequest &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.device, device) || other.device == device));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, device);

  @override
  String toString() {
    return 'StartSessionRequest(userBookId: $userBookId, device: $device)';
  }
}

/// @nodoc
abstract mixin class $StartSessionRequestCopyWith<$Res> {
  factory $StartSessionRequestCopyWith(
          StartSessionRequest value, $Res Function(StartSessionRequest) _then) =
      _$StartSessionRequestCopyWithImpl;
  @useResult
  $Res call({String userBookId, String device});
}

/// @nodoc
class _$StartSessionRequestCopyWithImpl<$Res>
    implements $StartSessionRequestCopyWith<$Res> {
  _$StartSessionRequestCopyWithImpl(this._self, this._then);

  final StartSessionRequest _self;
  final $Res Function(StartSessionRequest) _then;

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBookId = null,
    Object? device = null,
  }) {
    return _then(_self.copyWith(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _self.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [StartSessionRequest].
extension StartSessionRequestPatterns on StartSessionRequest {
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
    TResult Function(_StartSessionRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StartSessionRequest() when $default != null:
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
    TResult Function(_StartSessionRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StartSessionRequest():
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
    TResult? Function(_StartSessionRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StartSessionRequest() when $default != null:
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
    TResult Function(String userBookId, String device)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StartSessionRequest() when $default != null:
        return $default(_that.userBookId, _that.device);
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
    TResult Function(String userBookId, String device) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StartSessionRequest():
        return $default(_that.userBookId, _that.device);
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
    TResult? Function(String userBookId, String device)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StartSessionRequest() when $default != null:
        return $default(_that.userBookId, _that.device);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StartSessionRequest implements StartSessionRequest {
  const _StartSessionRequest({required this.userBookId, required this.device});
  factory _StartSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$StartSessionRequestFromJson(json);

  @override
  final String userBookId;
  @override
  final String device;

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StartSessionRequestCopyWith<_StartSessionRequest> get copyWith =>
      __$StartSessionRequestCopyWithImpl<_StartSessionRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StartSessionRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StartSessionRequest &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.device, device) || other.device == device));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, device);

  @override
  String toString() {
    return 'StartSessionRequest(userBookId: $userBookId, device: $device)';
  }
}

/// @nodoc
abstract mixin class _$StartSessionRequestCopyWith<$Res>
    implements $StartSessionRequestCopyWith<$Res> {
  factory _$StartSessionRequestCopyWith(_StartSessionRequest value,
          $Res Function(_StartSessionRequest) _then) =
      __$StartSessionRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String userBookId, String device});
}

/// @nodoc
class __$StartSessionRequestCopyWithImpl<$Res>
    implements _$StartSessionRequestCopyWith<$Res> {
  __$StartSessionRequestCopyWithImpl(this._self, this._then);

  final _StartSessionRequest _self;
  final $Res Function(_StartSessionRequest) _then;

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userBookId = null,
    Object? device = null,
  }) {
    return _then(_StartSessionRequest(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _self.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$EndSessionRequest {
  DateTime get endedAt;
  int get pausedMs;

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EndSessionRequestCopyWith<EndSessionRequest> get copyWith =>
      _$EndSessionRequestCopyWithImpl<EndSessionRequest>(
          this as EndSessionRequest, _$identity);

  /// Serializes this EndSessionRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EndSessionRequest &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.pausedMs, pausedMs) ||
                other.pausedMs == pausedMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, endedAt, pausedMs);

  @override
  String toString() {
    return 'EndSessionRequest(endedAt: $endedAt, pausedMs: $pausedMs)';
  }
}

/// @nodoc
abstract mixin class $EndSessionRequestCopyWith<$Res> {
  factory $EndSessionRequestCopyWith(
          EndSessionRequest value, $Res Function(EndSessionRequest) _then) =
      _$EndSessionRequestCopyWithImpl;
  @useResult
  $Res call({DateTime endedAt, int pausedMs});
}

/// @nodoc
class _$EndSessionRequestCopyWithImpl<$Res>
    implements $EndSessionRequestCopyWith<$Res> {
  _$EndSessionRequestCopyWithImpl(this._self, this._then);

  final EndSessionRequest _self;
  final $Res Function(EndSessionRequest) _then;

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endedAt = null,
    Object? pausedMs = null,
  }) {
    return _then(_self.copyWith(
      endedAt: null == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pausedMs: null == pausedMs
          ? _self.pausedMs
          : pausedMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [EndSessionRequest].
extension EndSessionRequestPatterns on EndSessionRequest {
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
    TResult Function(_EndSessionRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EndSessionRequest() when $default != null:
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
    TResult Function(_EndSessionRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EndSessionRequest():
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
    TResult? Function(_EndSessionRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EndSessionRequest() when $default != null:
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
    TResult Function(DateTime endedAt, int pausedMs)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EndSessionRequest() when $default != null:
        return $default(_that.endedAt, _that.pausedMs);
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
    TResult Function(DateTime endedAt, int pausedMs) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EndSessionRequest():
        return $default(_that.endedAt, _that.pausedMs);
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
    TResult? Function(DateTime endedAt, int pausedMs)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EndSessionRequest() when $default != null:
        return $default(_that.endedAt, _that.pausedMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EndSessionRequest implements EndSessionRequest {
  const _EndSessionRequest({required this.endedAt, required this.pausedMs});
  factory _EndSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$EndSessionRequestFromJson(json);

  @override
  final DateTime endedAt;
  @override
  final int pausedMs;

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EndSessionRequestCopyWith<_EndSessionRequest> get copyWith =>
      __$EndSessionRequestCopyWithImpl<_EndSessionRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EndSessionRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EndSessionRequest &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.pausedMs, pausedMs) ||
                other.pausedMs == pausedMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, endedAt, pausedMs);

  @override
  String toString() {
    return 'EndSessionRequest(endedAt: $endedAt, pausedMs: $pausedMs)';
  }
}

/// @nodoc
abstract mixin class _$EndSessionRequestCopyWith<$Res>
    implements $EndSessionRequestCopyWith<$Res> {
  factory _$EndSessionRequestCopyWith(
          _EndSessionRequest value, $Res Function(_EndSessionRequest) _then) =
      __$EndSessionRequestCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime endedAt, int pausedMs});
}

/// @nodoc
class __$EndSessionRequestCopyWithImpl<$Res>
    implements _$EndSessionRequestCopyWith<$Res> {
  __$EndSessionRequestCopyWithImpl(this._self, this._then);

  final _EndSessionRequest _self;
  final $Res Function(_EndSessionRequest) _then;

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? endedAt = null,
    Object? pausedMs = null,
  }) {
    return _then(_EndSessionRequest(
      endedAt: null == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pausedMs: null == pausedMs
          ? _self.pausedMs
          : pausedMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ManualSessionRequest {
  String get userBookId;
  DateTime get startedAt;
  DateTime get endedAt;
  String? get note;

  /// Create a copy of ManualSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ManualSessionRequestCopyWith<ManualSessionRequest> get copyWith =>
      _$ManualSessionRequestCopyWithImpl<ManualSessionRequest>(
          this as ManualSessionRequest, _$identity);

  /// Serializes this ManualSessionRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ManualSessionRequest &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userBookId, startedAt, endedAt, note);

  @override
  String toString() {
    return 'ManualSessionRequest(userBookId: $userBookId, startedAt: $startedAt, endedAt: $endedAt, note: $note)';
  }
}

/// @nodoc
abstract mixin class $ManualSessionRequestCopyWith<$Res> {
  factory $ManualSessionRequestCopyWith(ManualSessionRequest value,
          $Res Function(ManualSessionRequest) _then) =
      _$ManualSessionRequestCopyWithImpl;
  @useResult
  $Res call(
      {String userBookId, DateTime startedAt, DateTime endedAt, String? note});
}

/// @nodoc
class _$ManualSessionRequestCopyWithImpl<$Res>
    implements $ManualSessionRequestCopyWith<$Res> {
  _$ManualSessionRequestCopyWithImpl(this._self, this._then);

  final ManualSessionRequest _self;
  final $Res Function(ManualSessionRequest) _then;

  /// Create a copy of ManualSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBookId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? note = freezed,
  }) {
    return _then(_self.copyWith(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ManualSessionRequest].
extension ManualSessionRequestPatterns on ManualSessionRequest {
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
    TResult Function(_ManualSessionRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ManualSessionRequest() when $default != null:
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
    TResult Function(_ManualSessionRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManualSessionRequest():
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
    TResult? Function(_ManualSessionRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManualSessionRequest() when $default != null:
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
    TResult Function(String userBookId, DateTime startedAt, DateTime endedAt,
            String? note)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ManualSessionRequest() when $default != null:
        return $default(
            _that.userBookId, _that.startedAt, _that.endedAt, _that.note);
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
    TResult Function(String userBookId, DateTime startedAt, DateTime endedAt,
            String? note)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManualSessionRequest():
        return $default(
            _that.userBookId, _that.startedAt, _that.endedAt, _that.note);
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
    TResult? Function(String userBookId, DateTime startedAt, DateTime endedAt,
            String? note)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManualSessionRequest() when $default != null:
        return $default(
            _that.userBookId, _that.startedAt, _that.endedAt, _that.note);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ManualSessionRequest implements ManualSessionRequest {
  const _ManualSessionRequest(
      {required this.userBookId,
      required this.startedAt,
      required this.endedAt,
      this.note});
  factory _ManualSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$ManualSessionRequestFromJson(json);

  @override
  final String userBookId;
  @override
  final DateTime startedAt;
  @override
  final DateTime endedAt;
  @override
  final String? note;

  /// Create a copy of ManualSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ManualSessionRequestCopyWith<_ManualSessionRequest> get copyWith =>
      __$ManualSessionRequestCopyWithImpl<_ManualSessionRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ManualSessionRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ManualSessionRequest &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userBookId, startedAt, endedAt, note);

  @override
  String toString() {
    return 'ManualSessionRequest(userBookId: $userBookId, startedAt: $startedAt, endedAt: $endedAt, note: $note)';
  }
}

/// @nodoc
abstract mixin class _$ManualSessionRequestCopyWith<$Res>
    implements $ManualSessionRequestCopyWith<$Res> {
  factory _$ManualSessionRequestCopyWith(_ManualSessionRequest value,
          $Res Function(_ManualSessionRequest) _then) =
      __$ManualSessionRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userBookId, DateTime startedAt, DateTime endedAt, String? note});
}

/// @nodoc
class __$ManualSessionRequestCopyWithImpl<$Res>
    implements _$ManualSessionRequestCopyWith<$Res> {
  __$ManualSessionRequestCopyWithImpl(this._self, this._then);

  final _ManualSessionRequest _self;
  final $Res Function(_ManualSessionRequest) _then;

  /// Create a copy of ManualSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userBookId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? note = freezed,
  }) {
    return _then(_ManualSessionRequest(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CreateGoalRequest {
  String get period;
  int get targetBooks;
  int get targetSeconds;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateGoalRequestCopyWith<CreateGoalRequest> get copyWith =>
      _$CreateGoalRequestCopyWithImpl<CreateGoalRequest>(
          this as CreateGoalRequest, _$identity);

  /// Serializes this CreateGoalRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateGoalRequest &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, period, targetBooks, targetSeconds);

  @override
  String toString() {
    return 'CreateGoalRequest(period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }
}

/// @nodoc
abstract mixin class $CreateGoalRequestCopyWith<$Res> {
  factory $CreateGoalRequestCopyWith(
          CreateGoalRequest value, $Res Function(CreateGoalRequest) _then) =
      _$CreateGoalRequestCopyWithImpl;
  @useResult
  $Res call({String period, int targetBooks, int targetSeconds});
}

/// @nodoc
class _$CreateGoalRequestCopyWithImpl<$Res>
    implements $CreateGoalRequestCopyWith<$Res> {
  _$CreateGoalRequestCopyWithImpl(this._self, this._then);

  final CreateGoalRequest _self;
  final $Res Function(CreateGoalRequest) _then;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_self.copyWith(
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
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

/// Adds pattern-matching-related methods to [CreateGoalRequest].
extension CreateGoalRequestPatterns on CreateGoalRequest {
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
    TResult Function(_CreateGoalRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateGoalRequest() when $default != null:
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
    TResult Function(_CreateGoalRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateGoalRequest():
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
    TResult? Function(_CreateGoalRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateGoalRequest() when $default != null:
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
    TResult Function(String period, int targetBooks, int targetSeconds)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateGoalRequest() when $default != null:
        return $default(_that.period, _that.targetBooks, _that.targetSeconds);
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
    TResult Function(String period, int targetBooks, int targetSeconds)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateGoalRequest():
        return $default(_that.period, _that.targetBooks, _that.targetSeconds);
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
    TResult? Function(String period, int targetBooks, int targetSeconds)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateGoalRequest() when $default != null:
        return $default(_that.period, _that.targetBooks, _that.targetSeconds);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateGoalRequest implements CreateGoalRequest {
  const _CreateGoalRequest(
      {required this.period,
      required this.targetBooks,
      required this.targetSeconds});
  factory _CreateGoalRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGoalRequestFromJson(json);

  @override
  final String period;
  @override
  final int targetBooks;
  @override
  final int targetSeconds;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateGoalRequestCopyWith<_CreateGoalRequest> get copyWith =>
      __$CreateGoalRequestCopyWithImpl<_CreateGoalRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateGoalRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateGoalRequest &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, period, targetBooks, targetSeconds);

  @override
  String toString() {
    return 'CreateGoalRequest(period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }
}

/// @nodoc
abstract mixin class _$CreateGoalRequestCopyWith<$Res>
    implements $CreateGoalRequestCopyWith<$Res> {
  factory _$CreateGoalRequestCopyWith(
          _CreateGoalRequest value, $Res Function(_CreateGoalRequest) _then) =
      __$CreateGoalRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String period, int targetBooks, int targetSeconds});
}

/// @nodoc
class __$CreateGoalRequestCopyWithImpl<$Res>
    implements _$CreateGoalRequestCopyWith<$Res> {
  __$CreateGoalRequestCopyWithImpl(this._self, this._then);

  final _CreateGoalRequest _self;
  final $Res Function(_CreateGoalRequest) _then;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? period = null,
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_CreateGoalRequest(
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
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
mixin _$ReadingYearStatsDto {
  int get year;
  int get yearBooks;
  int get yearSeconds;
  String? get yearBestDayDate;
  int? get yearBestDaySeconds;
  int get totalBooks;
  int get totalSeconds;
  int get streakDays;
  int get longestStreak;

  /// Create a copy of ReadingYearStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadingYearStatsDtoCopyWith<ReadingYearStatsDto> get copyWith =>
      _$ReadingYearStatsDtoCopyWithImpl<ReadingYearStatsDto>(
          this as ReadingYearStatsDto, _$identity);

  /// Serializes this ReadingYearStatsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadingYearStatsDto &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.yearBooks, yearBooks) ||
                other.yearBooks == yearBooks) &&
            (identical(other.yearSeconds, yearSeconds) ||
                other.yearSeconds == yearSeconds) &&
            (identical(other.yearBestDayDate, yearBestDayDate) ||
                other.yearBestDayDate == yearBestDayDate) &&
            (identical(other.yearBestDaySeconds, yearBestDaySeconds) ||
                other.yearBestDaySeconds == yearBestDaySeconds) &&
            (identical(other.totalBooks, totalBooks) ||
                other.totalBooks == totalBooks) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      year,
      yearBooks,
      yearSeconds,
      yearBestDayDate,
      yearBestDaySeconds,
      totalBooks,
      totalSeconds,
      streakDays,
      longestStreak);

  @override
  String toString() {
    return 'ReadingYearStatsDto(year: $year, yearBooks: $yearBooks, yearSeconds: $yearSeconds, yearBestDayDate: $yearBestDayDate, yearBestDaySeconds: $yearBestDaySeconds, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak)';
  }
}

/// @nodoc
abstract mixin class $ReadingYearStatsDtoCopyWith<$Res> {
  factory $ReadingYearStatsDtoCopyWith(
          ReadingYearStatsDto value, $Res Function(ReadingYearStatsDto) _then) =
      _$ReadingYearStatsDtoCopyWithImpl;
  @useResult
  $Res call(
      {int year,
      int yearBooks,
      int yearSeconds,
      String? yearBestDayDate,
      int? yearBestDaySeconds,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak});
}

/// @nodoc
class _$ReadingYearStatsDtoCopyWithImpl<$Res>
    implements $ReadingYearStatsDtoCopyWith<$Res> {
  _$ReadingYearStatsDtoCopyWithImpl(this._self, this._then);

  final ReadingYearStatsDto _self;
  final $Res Function(ReadingYearStatsDto) _then;

  /// Create a copy of ReadingYearStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? yearBooks = null,
    Object? yearSeconds = null,
    Object? yearBestDayDate = freezed,
    Object? yearBestDaySeconds = freezed,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
    Object? longestStreak = null,
  }) {
    return _then(_self.copyWith(
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      yearBooks: null == yearBooks
          ? _self.yearBooks
          : yearBooks // ignore: cast_nullable_to_non_nullable
              as int,
      yearSeconds: null == yearSeconds
          ? _self.yearSeconds
          : yearSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      yearBestDayDate: freezed == yearBestDayDate
          ? _self.yearBestDayDate
          : yearBestDayDate // ignore: cast_nullable_to_non_nullable
              as String?,
      yearBestDaySeconds: freezed == yearBestDaySeconds
          ? _self.yearBestDaySeconds
          : yearBestDaySeconds // ignore: cast_nullable_to_non_nullable
              as int?,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [ReadingYearStatsDto].
extension ReadingYearStatsDtoPatterns on ReadingYearStatsDto {
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
    TResult Function(_ReadingYearStatsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingYearStatsDto() when $default != null:
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
    TResult Function(_ReadingYearStatsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingYearStatsDto():
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
    TResult? Function(_ReadingYearStatsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingYearStatsDto() when $default != null:
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
            int year,
            int yearBooks,
            int yearSeconds,
            String? yearBestDayDate,
            int? yearBestDaySeconds,
            int totalBooks,
            int totalSeconds,
            int streakDays,
            int longestStreak)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingYearStatsDto() when $default != null:
        return $default(
            _that.year,
            _that.yearBooks,
            _that.yearSeconds,
            _that.yearBestDayDate,
            _that.yearBestDaySeconds,
            _that.totalBooks,
            _that.totalSeconds,
            _that.streakDays,
            _that.longestStreak);
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
            int year,
            int yearBooks,
            int yearSeconds,
            String? yearBestDayDate,
            int? yearBestDaySeconds,
            int totalBooks,
            int totalSeconds,
            int streakDays,
            int longestStreak)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingYearStatsDto():
        return $default(
            _that.year,
            _that.yearBooks,
            _that.yearSeconds,
            _that.yearBestDayDate,
            _that.yearBestDaySeconds,
            _that.totalBooks,
            _that.totalSeconds,
            _that.streakDays,
            _that.longestStreak);
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
            int year,
            int yearBooks,
            int yearSeconds,
            String? yearBestDayDate,
            int? yearBestDaySeconds,
            int totalBooks,
            int totalSeconds,
            int streakDays,
            int longestStreak)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingYearStatsDto() when $default != null:
        return $default(
            _that.year,
            _that.yearBooks,
            _that.yearSeconds,
            _that.yearBestDayDate,
            _that.yearBestDaySeconds,
            _that.totalBooks,
            _that.totalSeconds,
            _that.streakDays,
            _that.longestStreak);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReadingYearStatsDto extends ReadingYearStatsDto {
  const _ReadingYearStatsDto(
      {required this.year,
      required this.yearBooks,
      required this.yearSeconds,
      this.yearBestDayDate,
      this.yearBestDaySeconds,
      required this.totalBooks,
      required this.totalSeconds,
      required this.streakDays,
      required this.longestStreak})
      : super._();
  factory _ReadingYearStatsDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingYearStatsDtoFromJson(json);

  @override
  final int year;
  @override
  final int yearBooks;
  @override
  final int yearSeconds;
  @override
  final String? yearBestDayDate;
  @override
  final int? yearBestDaySeconds;
  @override
  final int totalBooks;
  @override
  final int totalSeconds;
  @override
  final int streakDays;
  @override
  final int longestStreak;

  /// Create a copy of ReadingYearStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReadingYearStatsDtoCopyWith<_ReadingYearStatsDto> get copyWith =>
      __$ReadingYearStatsDtoCopyWithImpl<_ReadingYearStatsDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReadingYearStatsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReadingYearStatsDto &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.yearBooks, yearBooks) ||
                other.yearBooks == yearBooks) &&
            (identical(other.yearSeconds, yearSeconds) ||
                other.yearSeconds == yearSeconds) &&
            (identical(other.yearBestDayDate, yearBestDayDate) ||
                other.yearBestDayDate == yearBestDayDate) &&
            (identical(other.yearBestDaySeconds, yearBestDaySeconds) ||
                other.yearBestDaySeconds == yearBestDaySeconds) &&
            (identical(other.totalBooks, totalBooks) ||
                other.totalBooks == totalBooks) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      year,
      yearBooks,
      yearSeconds,
      yearBestDayDate,
      yearBestDaySeconds,
      totalBooks,
      totalSeconds,
      streakDays,
      longestStreak);

  @override
  String toString() {
    return 'ReadingYearStatsDto(year: $year, yearBooks: $yearBooks, yearSeconds: $yearSeconds, yearBestDayDate: $yearBestDayDate, yearBestDaySeconds: $yearBestDaySeconds, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak)';
  }
}

/// @nodoc
abstract mixin class _$ReadingYearStatsDtoCopyWith<$Res>
    implements $ReadingYearStatsDtoCopyWith<$Res> {
  factory _$ReadingYearStatsDtoCopyWith(_ReadingYearStatsDto value,
          $Res Function(_ReadingYearStatsDto) _then) =
      __$ReadingYearStatsDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int year,
      int yearBooks,
      int yearSeconds,
      String? yearBestDayDate,
      int? yearBestDaySeconds,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak});
}

/// @nodoc
class __$ReadingYearStatsDtoCopyWithImpl<$Res>
    implements _$ReadingYearStatsDtoCopyWith<$Res> {
  __$ReadingYearStatsDtoCopyWithImpl(this._self, this._then);

  final _ReadingYearStatsDto _self;
  final $Res Function(_ReadingYearStatsDto) _then;

  /// Create a copy of ReadingYearStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? year = null,
    Object? yearBooks = null,
    Object? yearSeconds = null,
    Object? yearBestDayDate = freezed,
    Object? yearBestDaySeconds = freezed,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
    Object? longestStreak = null,
  }) {
    return _then(_ReadingYearStatsDto(
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      yearBooks: null == yearBooks
          ? _self.yearBooks
          : yearBooks // ignore: cast_nullable_to_non_nullable
              as int,
      yearSeconds: null == yearSeconds
          ? _self.yearSeconds
          : yearSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      yearBestDayDate: freezed == yearBestDayDate
          ? _self.yearBestDayDate
          : yearBestDayDate // ignore: cast_nullable_to_non_nullable
              as String?,
      yearBestDaySeconds: freezed == yearBestDaySeconds
          ? _self.yearBestDaySeconds
          : yearBestDaySeconds // ignore: cast_nullable_to_non_nullable
              as int?,
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
    ));
  }
}

// dart format on
