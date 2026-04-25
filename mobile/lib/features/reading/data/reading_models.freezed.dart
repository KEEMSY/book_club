// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReadingSessionDto _$ReadingSessionDtoFromJson(Map<String, dynamic> json) {
  return _ReadingSessionDto.fromJson(json);
}

/// @nodoc
mixin _$ReadingSessionDto {
  String get id => throw _privateConstructorUsedError;
  String get userBookId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  int? get durationSec => throw _privateConstructorUsedError;

  /// Serializes this ReadingSessionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingSessionDtoCopyWith<ReadingSessionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingSessionDtoCopyWith<$Res> {
  factory $ReadingSessionDtoCopyWith(
          ReadingSessionDto value, $Res Function(ReadingSessionDto) then) =
      _$ReadingSessionDtoCopyWithImpl<$Res, ReadingSessionDto>;
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
class _$ReadingSessionDtoCopyWithImpl<$Res, $Val extends ReadingSessionDto>
    implements $ReadingSessionDtoCopyWith<$Res> {
  _$ReadingSessionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _value.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadingSessionDtoImplCopyWith<$Res>
    implements $ReadingSessionDtoCopyWith<$Res> {
  factory _$$ReadingSessionDtoImplCopyWith(_$ReadingSessionDtoImpl value,
          $Res Function(_$ReadingSessionDtoImpl) then) =
      __$$ReadingSessionDtoImplCopyWithImpl<$Res>;
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
class __$$ReadingSessionDtoImplCopyWithImpl<$Res>
    extends _$ReadingSessionDtoCopyWithImpl<$Res, _$ReadingSessionDtoImpl>
    implements _$$ReadingSessionDtoImplCopyWith<$Res> {
  __$$ReadingSessionDtoImplCopyWithImpl(_$ReadingSessionDtoImpl _value,
      $Res Function(_$ReadingSessionDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$ReadingSessionDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _value.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingSessionDtoImpl extends _ReadingSessionDto {
  const _$ReadingSessionDtoImpl(
      {required this.id,
      required this.userBookId,
      required this.startedAt,
      required this.source,
      this.endedAt,
      this.durationSec})
      : super._();

  factory _$ReadingSessionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingSessionDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'ReadingSessionDto(id: $id, userBookId: $userBookId, startedAt: $startedAt, source: $source, endedAt: $endedAt, durationSec: $durationSec)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingSessionDtoImpl &&
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

  /// Create a copy of ReadingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingSessionDtoImplCopyWith<_$ReadingSessionDtoImpl> get copyWith =>
      __$$ReadingSessionDtoImplCopyWithImpl<_$ReadingSessionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingSessionDtoImplToJson(
      this,
    );
  }
}

abstract class _ReadingSessionDto extends ReadingSessionDto {
  const factory _ReadingSessionDto(
      {required final String id,
      required final String userBookId,
      required final DateTime startedAt,
      required final String source,
      final DateTime? endedAt,
      final int? durationSec}) = _$ReadingSessionDtoImpl;
  const _ReadingSessionDto._() : super._();

  factory _ReadingSessionDto.fromJson(Map<String, dynamic> json) =
      _$ReadingSessionDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get userBookId;
  @override
  DateTime get startedAt;
  @override
  String get source;
  @override
  DateTime? get endedAt;
  @override
  int? get durationSec;

  /// Create a copy of ReadingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingSessionDtoImplCopyWith<_$ReadingSessionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NextGradeThresholdsDto _$NextGradeThresholdsDtoFromJson(
    Map<String, dynamic> json) {
  return _NextGradeThresholdsDto.fromJson(json);
}

/// @nodoc
mixin _$NextGradeThresholdsDto {
  int get targetBooks => throw _privateConstructorUsedError;
  int get targetSeconds => throw _privateConstructorUsedError;

  /// Serializes this NextGradeThresholdsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NextGradeThresholdsDtoCopyWith<NextGradeThresholdsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NextGradeThresholdsDtoCopyWith<$Res> {
  factory $NextGradeThresholdsDtoCopyWith(NextGradeThresholdsDto value,
          $Res Function(NextGradeThresholdsDto) then) =
      _$NextGradeThresholdsDtoCopyWithImpl<$Res, NextGradeThresholdsDto>;
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class _$NextGradeThresholdsDtoCopyWithImpl<$Res,
        $Val extends NextGradeThresholdsDto>
    implements $NextGradeThresholdsDtoCopyWith<$Res> {
  _$NextGradeThresholdsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_value.copyWith(
      targetBooks: null == targetBooks
          ? _value.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _value.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NextGradeThresholdsDtoImplCopyWith<$Res>
    implements $NextGradeThresholdsDtoCopyWith<$Res> {
  factory _$$NextGradeThresholdsDtoImplCopyWith(
          _$NextGradeThresholdsDtoImpl value,
          $Res Function(_$NextGradeThresholdsDtoImpl) then) =
      __$$NextGradeThresholdsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class __$$NextGradeThresholdsDtoImplCopyWithImpl<$Res>
    extends _$NextGradeThresholdsDtoCopyWithImpl<$Res,
        _$NextGradeThresholdsDtoImpl>
    implements _$$NextGradeThresholdsDtoImplCopyWith<$Res> {
  __$$NextGradeThresholdsDtoImplCopyWithImpl(
      _$NextGradeThresholdsDtoImpl _value,
      $Res Function(_$NextGradeThresholdsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_$NextGradeThresholdsDtoImpl(
      targetBooks: null == targetBooks
          ? _value.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _value.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NextGradeThresholdsDtoImpl extends _NextGradeThresholdsDto {
  const _$NextGradeThresholdsDtoImpl(
      {required this.targetBooks, required this.targetSeconds})
      : super._();

  factory _$NextGradeThresholdsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NextGradeThresholdsDtoImplFromJson(json);

  @override
  final int targetBooks;
  @override
  final int targetSeconds;

  @override
  String toString() {
    return 'NextGradeThresholdsDto(targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextGradeThresholdsDtoImpl &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetBooks, targetSeconds);

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NextGradeThresholdsDtoImplCopyWith<_$NextGradeThresholdsDtoImpl>
      get copyWith => __$$NextGradeThresholdsDtoImplCopyWithImpl<
          _$NextGradeThresholdsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NextGradeThresholdsDtoImplToJson(
      this,
    );
  }
}

abstract class _NextGradeThresholdsDto extends NextGradeThresholdsDto {
  const factory _NextGradeThresholdsDto(
      {required final int targetBooks,
      required final int targetSeconds}) = _$NextGradeThresholdsDtoImpl;
  const _NextGradeThresholdsDto._() : super._();

  factory _NextGradeThresholdsDto.fromJson(Map<String, dynamic> json) =
      _$NextGradeThresholdsDtoImpl.fromJson;

  @override
  int get targetBooks;
  @override
  int get targetSeconds;

  /// Create a copy of NextGradeThresholdsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NextGradeThresholdsDtoImplCopyWith<_$NextGradeThresholdsDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GradeSummaryDto _$GradeSummaryDtoFromJson(Map<String, dynamic> json) {
  return _GradeSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$GradeSummaryDto {
  int get grade => throw _privateConstructorUsedError;
  int get totalBooks => throw _privateConstructorUsedError;
  int get totalSeconds => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  NextGradeThresholdsDto? get nextGradeThresholds =>
      throw _privateConstructorUsedError;
  int get tier => throw _privateConstructorUsedError;

  /// Serializes this GradeSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GradeSummaryDtoCopyWith<GradeSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeSummaryDtoCopyWith<$Res> {
  factory $GradeSummaryDtoCopyWith(
          GradeSummaryDto value, $Res Function(GradeSummaryDto) then) =
      _$GradeSummaryDtoCopyWithImpl<$Res, GradeSummaryDto>;
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
class _$GradeSummaryDtoCopyWithImpl<$Res, $Val extends GradeSummaryDto>
    implements $GradeSummaryDtoCopyWith<$Res> {
  _$GradeSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      totalBooks: null == totalBooks
          ? _value.totalBooks
          : totalBooks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      nextGradeThresholds: freezed == nextGradeThresholds
          ? _value.nextGradeThresholds
          : nextGradeThresholds // ignore: cast_nullable_to_non_nullable
              as NextGradeThresholdsDto?,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsDtoCopyWith<$Res>? get nextGradeThresholds {
    if (_value.nextGradeThresholds == null) {
      return null;
    }

    return $NextGradeThresholdsDtoCopyWith<$Res>(_value.nextGradeThresholds!,
        (value) {
      return _then(_value.copyWith(nextGradeThresholds: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GradeSummaryDtoImplCopyWith<$Res>
    implements $GradeSummaryDtoCopyWith<$Res> {
  factory _$$GradeSummaryDtoImplCopyWith(_$GradeSummaryDtoImpl value,
          $Res Function(_$GradeSummaryDtoImpl) then) =
      __$$GradeSummaryDtoImplCopyWithImpl<$Res>;
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
class __$$GradeSummaryDtoImplCopyWithImpl<$Res>
    extends _$GradeSummaryDtoCopyWithImpl<$Res, _$GradeSummaryDtoImpl>
    implements _$$GradeSummaryDtoImplCopyWith<$Res> {
  __$$GradeSummaryDtoImplCopyWithImpl(
      _$GradeSummaryDtoImpl _value, $Res Function(_$GradeSummaryDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$GradeSummaryDtoImpl(
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      totalBooks: null == totalBooks
          ? _value.totalBooks
          : totalBooks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      nextGradeThresholds: freezed == nextGradeThresholds
          ? _value.nextGradeThresholds
          : nextGradeThresholds // ignore: cast_nullable_to_non_nullable
              as NextGradeThresholdsDto?,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GradeSummaryDtoImpl extends _GradeSummaryDto {
  const _$GradeSummaryDtoImpl(
      {required this.grade,
      required this.totalBooks,
      required this.totalSeconds,
      required this.streakDays,
      required this.longestStreak,
      this.nextGradeThresholds,
      this.tier = 1})
      : super._();

  factory _$GradeSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GradeSummaryDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'GradeSummaryDto(grade: $grade, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak, nextGradeThresholds: $nextGradeThresholds, tier: $tier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeSummaryDtoImpl &&
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

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeSummaryDtoImplCopyWith<_$GradeSummaryDtoImpl> get copyWith =>
      __$$GradeSummaryDtoImplCopyWithImpl<_$GradeSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GradeSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _GradeSummaryDto extends GradeSummaryDto {
  const factory _GradeSummaryDto(
      {required final int grade,
      required final int totalBooks,
      required final int totalSeconds,
      required final int streakDays,
      required final int longestStreak,
      final NextGradeThresholdsDto? nextGradeThresholds,
      final int tier}) = _$GradeSummaryDtoImpl;
  const _GradeSummaryDto._() : super._();

  factory _GradeSummaryDto.fromJson(Map<String, dynamic> json) =
      _$GradeSummaryDtoImpl.fromJson;

  @override
  int get grade;
  @override
  int get totalBooks;
  @override
  int get totalSeconds;
  @override
  int get streakDays;
  @override
  int get longestStreak;
  @override
  NextGradeThresholdsDto? get nextGradeThresholds;
  @override
  int get tier;

  /// Create a copy of GradeSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeSummaryDtoImplCopyWith<_$GradeSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionCompletionDto _$SessionCompletionDtoFromJson(Map<String, dynamic> json) {
  return _SessionCompletionDto.fromJson(json);
}

/// @nodoc
mixin _$SessionCompletionDto {
  ReadingSessionDto get session => throw _privateConstructorUsedError;
  GradeSummaryDto get grade => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  bool get gradeUp => throw _privateConstructorUsedError;

  /// Serializes this SessionCompletionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCompletionDtoCopyWith<SessionCompletionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCompletionDtoCopyWith<$Res> {
  factory $SessionCompletionDtoCopyWith(SessionCompletionDto value,
          $Res Function(SessionCompletionDto) then) =
      _$SessionCompletionDtoCopyWithImpl<$Res, SessionCompletionDto>;
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
class _$SessionCompletionDtoCopyWithImpl<$Res,
        $Val extends SessionCompletionDto>
    implements $SessionCompletionDtoCopyWith<$Res> {
  _$SessionCompletionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ReadingSessionDto,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as GradeSummaryDto,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      gradeUp: null == gradeUp
          ? _value.gradeUp
          : gradeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingSessionDtoCopyWith<$Res> get session {
    return $ReadingSessionDtoCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeSummaryDtoCopyWith<$Res> get grade {
    return $GradeSummaryDtoCopyWith<$Res>(_value.grade, (value) {
      return _then(_value.copyWith(grade: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionCompletionDtoImplCopyWith<$Res>
    implements $SessionCompletionDtoCopyWith<$Res> {
  factory _$$SessionCompletionDtoImplCopyWith(_$SessionCompletionDtoImpl value,
          $Res Function(_$SessionCompletionDtoImpl) then) =
      __$$SessionCompletionDtoImplCopyWithImpl<$Res>;
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
class __$$SessionCompletionDtoImplCopyWithImpl<$Res>
    extends _$SessionCompletionDtoCopyWithImpl<$Res, _$SessionCompletionDtoImpl>
    implements _$$SessionCompletionDtoImplCopyWith<$Res> {
  __$$SessionCompletionDtoImplCopyWithImpl(_$SessionCompletionDtoImpl _value,
      $Res Function(_$SessionCompletionDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$SessionCompletionDtoImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ReadingSessionDto,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as GradeSummaryDto,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      gradeUp: null == gradeUp
          ? _value.gradeUp
          : gradeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionCompletionDtoImpl extends _SessionCompletionDto {
  const _$SessionCompletionDtoImpl(
      {required this.session,
      required this.grade,
      required this.streakDays,
      required this.gradeUp})
      : super._();

  factory _$SessionCompletionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionCompletionDtoImplFromJson(json);

  @override
  final ReadingSessionDto session;
  @override
  final GradeSummaryDto grade;
  @override
  final int streakDays;
  @override
  final bool gradeUp;

  @override
  String toString() {
    return 'SessionCompletionDto(session: $session, grade: $grade, streakDays: $streakDays, gradeUp: $gradeUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionCompletionDtoImpl &&
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

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionCompletionDtoImplCopyWith<_$SessionCompletionDtoImpl>
      get copyWith =>
          __$$SessionCompletionDtoImplCopyWithImpl<_$SessionCompletionDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionCompletionDtoImplToJson(
      this,
    );
  }
}

abstract class _SessionCompletionDto extends SessionCompletionDto {
  const factory _SessionCompletionDto(
      {required final ReadingSessionDto session,
      required final GradeSummaryDto grade,
      required final int streakDays,
      required final bool gradeUp}) = _$SessionCompletionDtoImpl;
  const _SessionCompletionDto._() : super._();

  factory _SessionCompletionDto.fromJson(Map<String, dynamic> json) =
      _$SessionCompletionDtoImpl.fromJson;

  @override
  ReadingSessionDto get session;
  @override
  GradeSummaryDto get grade;
  @override
  int get streakDays;
  @override
  bool get gradeUp;

  /// Create a copy of SessionCompletionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionCompletionDtoImplCopyWith<_$SessionCompletionDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HeatmapItemDto _$HeatmapItemDtoFromJson(Map<String, dynamic> json) {
  return _HeatmapItemDto.fromJson(json);
}

/// @nodoc
mixin _$HeatmapItemDto {
  String get date => throw _privateConstructorUsedError;
  int get totalSeconds => throw _privateConstructorUsedError;
  int get sessionCount => throw _privateConstructorUsedError;

  /// Serializes this HeatmapItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeatmapItemDtoCopyWith<HeatmapItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeatmapItemDtoCopyWith<$Res> {
  factory $HeatmapItemDtoCopyWith(
          HeatmapItemDto value, $Res Function(HeatmapItemDto) then) =
      _$HeatmapItemDtoCopyWithImpl<$Res, HeatmapItemDto>;
  @useResult
  $Res call({String date, int totalSeconds, int sessionCount});
}

/// @nodoc
class _$HeatmapItemDtoCopyWithImpl<$Res, $Val extends HeatmapItemDto>
    implements $HeatmapItemDtoCopyWith<$Res> {
  _$HeatmapItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _value.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeatmapItemDtoImplCopyWith<$Res>
    implements $HeatmapItemDtoCopyWith<$Res> {
  factory _$$HeatmapItemDtoImplCopyWith(_$HeatmapItemDtoImpl value,
          $Res Function(_$HeatmapItemDtoImpl) then) =
      __$$HeatmapItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, int totalSeconds, int sessionCount});
}

/// @nodoc
class __$$HeatmapItemDtoImplCopyWithImpl<$Res>
    extends _$HeatmapItemDtoCopyWithImpl<$Res, _$HeatmapItemDtoImpl>
    implements _$$HeatmapItemDtoImplCopyWith<$Res> {
  __$$HeatmapItemDtoImplCopyWithImpl(
      _$HeatmapItemDtoImpl _value, $Res Function(_$HeatmapItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
  }) {
    return _then(_$HeatmapItemDtoImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _value.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeatmapItemDtoImpl extends _HeatmapItemDto {
  const _$HeatmapItemDtoImpl(
      {required this.date,
      required this.totalSeconds,
      required this.sessionCount})
      : super._();

  factory _$HeatmapItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeatmapItemDtoImplFromJson(json);

  @override
  final String date;
  @override
  final int totalSeconds;
  @override
  final int sessionCount;

  @override
  String toString() {
    return 'HeatmapItemDto(date: $date, totalSeconds: $totalSeconds, sessionCount: $sessionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeatmapItemDtoImpl &&
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

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeatmapItemDtoImplCopyWith<_$HeatmapItemDtoImpl> get copyWith =>
      __$$HeatmapItemDtoImplCopyWithImpl<_$HeatmapItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeatmapItemDtoImplToJson(
      this,
    );
  }
}

abstract class _HeatmapItemDto extends HeatmapItemDto {
  const factory _HeatmapItemDto(
      {required final String date,
      required final int totalSeconds,
      required final int sessionCount}) = _$HeatmapItemDtoImpl;
  const _HeatmapItemDto._() : super._();

  factory _HeatmapItemDto.fromJson(Map<String, dynamic> json) =
      _$HeatmapItemDtoImpl.fromJson;

  @override
  String get date;
  @override
  int get totalSeconds;
  @override
  int get sessionCount;

  /// Create a copy of HeatmapItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeatmapItemDtoImplCopyWith<_$HeatmapItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeatmapResponseDto _$HeatmapResponseDtoFromJson(Map<String, dynamic> json) {
  return _HeatmapResponseDto.fromJson(json);
}

/// @nodoc
mixin _$HeatmapResponseDto {
  List<HeatmapItemDto> get items => throw _privateConstructorUsedError;

  /// Serializes this HeatmapResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeatmapResponseDtoCopyWith<HeatmapResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeatmapResponseDtoCopyWith<$Res> {
  factory $HeatmapResponseDtoCopyWith(
          HeatmapResponseDto value, $Res Function(HeatmapResponseDto) then) =
      _$HeatmapResponseDtoCopyWithImpl<$Res, HeatmapResponseDto>;
  @useResult
  $Res call({List<HeatmapItemDto> items});
}

/// @nodoc
class _$HeatmapResponseDtoCopyWithImpl<$Res, $Val extends HeatmapResponseDto>
    implements $HeatmapResponseDtoCopyWith<$Res> {
  _$HeatmapResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HeatmapItemDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeatmapResponseDtoImplCopyWith<$Res>
    implements $HeatmapResponseDtoCopyWith<$Res> {
  factory _$$HeatmapResponseDtoImplCopyWith(_$HeatmapResponseDtoImpl value,
          $Res Function(_$HeatmapResponseDtoImpl) then) =
      __$$HeatmapResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<HeatmapItemDto> items});
}

/// @nodoc
class __$$HeatmapResponseDtoImplCopyWithImpl<$Res>
    extends _$HeatmapResponseDtoCopyWithImpl<$Res, _$HeatmapResponseDtoImpl>
    implements _$$HeatmapResponseDtoImplCopyWith<$Res> {
  __$$HeatmapResponseDtoImplCopyWithImpl(_$HeatmapResponseDtoImpl _value,
      $Res Function(_$HeatmapResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$HeatmapResponseDtoImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HeatmapItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeatmapResponseDtoImpl implements _HeatmapResponseDto {
  const _$HeatmapResponseDtoImpl({required final List<HeatmapItemDto> items})
      : _items = items;

  factory _$HeatmapResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeatmapResponseDtoImplFromJson(json);

  final List<HeatmapItemDto> _items;
  @override
  List<HeatmapItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'HeatmapResponseDto(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeatmapResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeatmapResponseDtoImplCopyWith<_$HeatmapResponseDtoImpl> get copyWith =>
      __$$HeatmapResponseDtoImplCopyWithImpl<_$HeatmapResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeatmapResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _HeatmapResponseDto implements HeatmapResponseDto {
  const factory _HeatmapResponseDto(
      {required final List<HeatmapItemDto> items}) = _$HeatmapResponseDtoImpl;

  factory _HeatmapResponseDto.fromJson(Map<String, dynamic> json) =
      _$HeatmapResponseDtoImpl.fromJson;

  @override
  List<HeatmapItemDto> get items;

  /// Create a copy of HeatmapResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeatmapResponseDtoImplCopyWith<_$HeatmapResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoalDto _$GoalDtoFromJson(Map<String, dynamic> json) {
  return _GoalDto.fromJson(json);
}

/// @nodoc
mixin _$GoalDto {
  String get id => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  int get targetBooks => throw _privateConstructorUsedError;
  int get targetSeconds => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this GoalDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalDtoCopyWith<GoalDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalDtoCopyWith<$Res> {
  factory $GoalDtoCopyWith(GoalDto value, $Res Function(GoalDto) then) =
      _$GoalDtoCopyWithImpl<$Res, GoalDto>;
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
class _$GoalDtoCopyWithImpl<$Res, $Val extends GoalDto>
    implements $GoalDtoCopyWith<$Res> {
  _$GoalDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      targetBooks: null == targetBooks
          ? _value.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _value.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalDtoImplCopyWith<$Res> implements $GoalDtoCopyWith<$Res> {
  factory _$$GoalDtoImplCopyWith(
          _$GoalDtoImpl value, $Res Function(_$GoalDtoImpl) then) =
      __$$GoalDtoImplCopyWithImpl<$Res>;
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
class __$$GoalDtoImplCopyWithImpl<$Res>
    extends _$GoalDtoCopyWithImpl<$Res, _$GoalDtoImpl>
    implements _$$GoalDtoImplCopyWith<$Res> {
  __$$GoalDtoImplCopyWithImpl(
      _$GoalDtoImpl _value, $Res Function(_$GoalDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$GoalDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      targetBooks: null == targetBooks
          ? _value.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _value.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalDtoImpl extends _GoalDto {
  const _$GoalDtoImpl(
      {required this.id,
      required this.period,
      required this.targetBooks,
      required this.targetSeconds,
      required this.startDate,
      required this.endDate})
      : super._();

  factory _$GoalDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'GoalDto(id: $id, period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalDtoImpl &&
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

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalDtoImplCopyWith<_$GoalDtoImpl> get copyWith =>
      __$$GoalDtoImplCopyWithImpl<_$GoalDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalDtoImplToJson(
      this,
    );
  }
}

abstract class _GoalDto extends GoalDto {
  const factory _GoalDto(
      {required final String id,
      required final String period,
      required final int targetBooks,
      required final int targetSeconds,
      required final DateTime startDate,
      required final DateTime endDate}) = _$GoalDtoImpl;
  const _GoalDto._() : super._();

  factory _GoalDto.fromJson(Map<String, dynamic> json) = _$GoalDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get period;
  @override
  int get targetBooks;
  @override
  int get targetSeconds;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalDtoImplCopyWith<_$GoalDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoalProgressDto _$GoalProgressDtoFromJson(Map<String, dynamic> json) {
  return _GoalProgressDto.fromJson(json);
}

/// @nodoc
mixin _$GoalProgressDto {
  GoalDto get goal => throw _privateConstructorUsedError;
  int get booksDone => throw _privateConstructorUsedError;
  int get secondsDone => throw _privateConstructorUsedError;
  double get percent => throw _privateConstructorUsedError;

  /// Serializes this GoalProgressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalProgressDtoCopyWith<GoalProgressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalProgressDtoCopyWith<$Res> {
  factory $GoalProgressDtoCopyWith(
          GoalProgressDto value, $Res Function(GoalProgressDto) then) =
      _$GoalProgressDtoCopyWithImpl<$Res, GoalProgressDto>;
  @useResult
  $Res call({GoalDto goal, int booksDone, int secondsDone, double percent});

  $GoalDtoCopyWith<$Res> get goal;
}

/// @nodoc
class _$GoalProgressDtoCopyWithImpl<$Res, $Val extends GoalProgressDto>
    implements $GoalProgressDtoCopyWith<$Res> {
  _$GoalProgressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as GoalDto,
      booksDone: null == booksDone
          ? _value.booksDone
          : booksDone // ignore: cast_nullable_to_non_nullable
              as int,
      secondsDone: null == secondsDone
          ? _value.secondsDone
          : secondsDone // ignore: cast_nullable_to_non_nullable
              as int,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalDtoCopyWith<$Res> get goal {
    return $GoalDtoCopyWith<$Res>(_value.goal, (value) {
      return _then(_value.copyWith(goal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GoalProgressDtoImplCopyWith<$Res>
    implements $GoalProgressDtoCopyWith<$Res> {
  factory _$$GoalProgressDtoImplCopyWith(_$GoalProgressDtoImpl value,
          $Res Function(_$GoalProgressDtoImpl) then) =
      __$$GoalProgressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GoalDto goal, int booksDone, int secondsDone, double percent});

  @override
  $GoalDtoCopyWith<$Res> get goal;
}

/// @nodoc
class __$$GoalProgressDtoImplCopyWithImpl<$Res>
    extends _$GoalProgressDtoCopyWithImpl<$Res, _$GoalProgressDtoImpl>
    implements _$$GoalProgressDtoImplCopyWith<$Res> {
  __$$GoalProgressDtoImplCopyWithImpl(
      _$GoalProgressDtoImpl _value, $Res Function(_$GoalProgressDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$GoalProgressDtoImpl(
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as GoalDto,
      booksDone: null == booksDone
          ? _value.booksDone
          : booksDone // ignore: cast_nullable_to_non_nullable
              as int,
      secondsDone: null == secondsDone
          ? _value.secondsDone
          : secondsDone // ignore: cast_nullable_to_non_nullable
              as int,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalProgressDtoImpl extends _GoalProgressDto {
  const _$GoalProgressDtoImpl(
      {required this.goal,
      required this.booksDone,
      required this.secondsDone,
      required this.percent})
      : super._();

  factory _$GoalProgressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalProgressDtoImplFromJson(json);

  @override
  final GoalDto goal;
  @override
  final int booksDone;
  @override
  final int secondsDone;
  @override
  final double percent;

  @override
  String toString() {
    return 'GoalProgressDto(goal: $goal, booksDone: $booksDone, secondsDone: $secondsDone, percent: $percent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalProgressDtoImpl &&
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

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalProgressDtoImplCopyWith<_$GoalProgressDtoImpl> get copyWith =>
      __$$GoalProgressDtoImplCopyWithImpl<_$GoalProgressDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalProgressDtoImplToJson(
      this,
    );
  }
}

abstract class _GoalProgressDto extends GoalProgressDto {
  const factory _GoalProgressDto(
      {required final GoalDto goal,
      required final int booksDone,
      required final int secondsDone,
      required final double percent}) = _$GoalProgressDtoImpl;
  const _GoalProgressDto._() : super._();

  factory _GoalProgressDto.fromJson(Map<String, dynamic> json) =
      _$GoalProgressDtoImpl.fromJson;

  @override
  GoalDto get goal;
  @override
  int get booksDone;
  @override
  int get secondsDone;
  @override
  double get percent;

  /// Create a copy of GoalProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalProgressDtoImplCopyWith<_$GoalProgressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StartSessionRequest _$StartSessionRequestFromJson(Map<String, dynamic> json) {
  return _StartSessionRequest.fromJson(json);
}

/// @nodoc
mixin _$StartSessionRequest {
  String get userBookId => throw _privateConstructorUsedError;
  String get device => throw _privateConstructorUsedError;

  /// Serializes this StartSessionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartSessionRequestCopyWith<StartSessionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartSessionRequestCopyWith<$Res> {
  factory $StartSessionRequestCopyWith(
          StartSessionRequest value, $Res Function(StartSessionRequest) then) =
      _$StartSessionRequestCopyWithImpl<$Res, StartSessionRequest>;
  @useResult
  $Res call({String userBookId, String device});
}

/// @nodoc
class _$StartSessionRequestCopyWithImpl<$Res, $Val extends StartSessionRequest>
    implements $StartSessionRequestCopyWith<$Res> {
  _$StartSessionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBookId = null,
    Object? device = null,
  }) {
    return _then(_value.copyWith(
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StartSessionRequestImplCopyWith<$Res>
    implements $StartSessionRequestCopyWith<$Res> {
  factory _$$StartSessionRequestImplCopyWith(_$StartSessionRequestImpl value,
          $Res Function(_$StartSessionRequestImpl) then) =
      __$$StartSessionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userBookId, String device});
}

/// @nodoc
class __$$StartSessionRequestImplCopyWithImpl<$Res>
    extends _$StartSessionRequestCopyWithImpl<$Res, _$StartSessionRequestImpl>
    implements _$$StartSessionRequestImplCopyWith<$Res> {
  __$$StartSessionRequestImplCopyWithImpl(_$StartSessionRequestImpl _value,
      $Res Function(_$StartSessionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBookId = null,
    Object? device = null,
  }) {
    return _then(_$StartSessionRequestImpl(
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StartSessionRequestImpl implements _StartSessionRequest {
  const _$StartSessionRequestImpl(
      {required this.userBookId, required this.device});

  factory _$StartSessionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartSessionRequestImplFromJson(json);

  @override
  final String userBookId;
  @override
  final String device;

  @override
  String toString() {
    return 'StartSessionRequest(userBookId: $userBookId, device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartSessionRequestImpl &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.device, device) || other.device == device));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, device);

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartSessionRequestImplCopyWith<_$StartSessionRequestImpl> get copyWith =>
      __$$StartSessionRequestImplCopyWithImpl<_$StartSessionRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StartSessionRequestImplToJson(
      this,
    );
  }
}

abstract class _StartSessionRequest implements StartSessionRequest {
  const factory _StartSessionRequest(
      {required final String userBookId,
      required final String device}) = _$StartSessionRequestImpl;

  factory _StartSessionRequest.fromJson(Map<String, dynamic> json) =
      _$StartSessionRequestImpl.fromJson;

  @override
  String get userBookId;
  @override
  String get device;

  /// Create a copy of StartSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartSessionRequestImplCopyWith<_$StartSessionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EndSessionRequest _$EndSessionRequestFromJson(Map<String, dynamic> json) {
  return _EndSessionRequest.fromJson(json);
}

/// @nodoc
mixin _$EndSessionRequest {
  DateTime get endedAt => throw _privateConstructorUsedError;
  int get pausedMs => throw _privateConstructorUsedError;

  /// Serializes this EndSessionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EndSessionRequestCopyWith<EndSessionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EndSessionRequestCopyWith<$Res> {
  factory $EndSessionRequestCopyWith(
          EndSessionRequest value, $Res Function(EndSessionRequest) then) =
      _$EndSessionRequestCopyWithImpl<$Res, EndSessionRequest>;
  @useResult
  $Res call({DateTime endedAt, int pausedMs});
}

/// @nodoc
class _$EndSessionRequestCopyWithImpl<$Res, $Val extends EndSessionRequest>
    implements $EndSessionRequestCopyWith<$Res> {
  _$EndSessionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endedAt = null,
    Object? pausedMs = null,
  }) {
    return _then(_value.copyWith(
      endedAt: null == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pausedMs: null == pausedMs
          ? _value.pausedMs
          : pausedMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EndSessionRequestImplCopyWith<$Res>
    implements $EndSessionRequestCopyWith<$Res> {
  factory _$$EndSessionRequestImplCopyWith(_$EndSessionRequestImpl value,
          $Res Function(_$EndSessionRequestImpl) then) =
      __$$EndSessionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime endedAt, int pausedMs});
}

/// @nodoc
class __$$EndSessionRequestImplCopyWithImpl<$Res>
    extends _$EndSessionRequestCopyWithImpl<$Res, _$EndSessionRequestImpl>
    implements _$$EndSessionRequestImplCopyWith<$Res> {
  __$$EndSessionRequestImplCopyWithImpl(_$EndSessionRequestImpl _value,
      $Res Function(_$EndSessionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endedAt = null,
    Object? pausedMs = null,
  }) {
    return _then(_$EndSessionRequestImpl(
      endedAt: null == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pausedMs: null == pausedMs
          ? _value.pausedMs
          : pausedMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EndSessionRequestImpl implements _EndSessionRequest {
  const _$EndSessionRequestImpl(
      {required this.endedAt, required this.pausedMs});

  factory _$EndSessionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$EndSessionRequestImplFromJson(json);

  @override
  final DateTime endedAt;
  @override
  final int pausedMs;

  @override
  String toString() {
    return 'EndSessionRequest(endedAt: $endedAt, pausedMs: $pausedMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndSessionRequestImpl &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.pausedMs, pausedMs) ||
                other.pausedMs == pausedMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, endedAt, pausedMs);

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EndSessionRequestImplCopyWith<_$EndSessionRequestImpl> get copyWith =>
      __$$EndSessionRequestImplCopyWithImpl<_$EndSessionRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EndSessionRequestImplToJson(
      this,
    );
  }
}

abstract class _EndSessionRequest implements EndSessionRequest {
  const factory _EndSessionRequest(
      {required final DateTime endedAt,
      required final int pausedMs}) = _$EndSessionRequestImpl;

  factory _EndSessionRequest.fromJson(Map<String, dynamic> json) =
      _$EndSessionRequestImpl.fromJson;

  @override
  DateTime get endedAt;
  @override
  int get pausedMs;

  /// Create a copy of EndSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EndSessionRequestImplCopyWith<_$EndSessionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManualSessionRequest _$ManualSessionRequestFromJson(Map<String, dynamic> json) {
  return _ManualSessionRequest.fromJson(json);
}

/// @nodoc
mixin _$ManualSessionRequest {
  String get userBookId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime get endedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this ManualSessionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManualSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManualSessionRequestCopyWith<ManualSessionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManualSessionRequestCopyWith<$Res> {
  factory $ManualSessionRequestCopyWith(ManualSessionRequest value,
          $Res Function(ManualSessionRequest) then) =
      _$ManualSessionRequestCopyWithImpl<$Res, ManualSessionRequest>;
  @useResult
  $Res call(
      {String userBookId, DateTime startedAt, DateTime endedAt, String? note});
}

/// @nodoc
class _$ManualSessionRequestCopyWithImpl<$Res,
        $Val extends ManualSessionRequest>
    implements $ManualSessionRequestCopyWith<$Res> {
  _$ManualSessionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManualSessionRequestImplCopyWith<$Res>
    implements $ManualSessionRequestCopyWith<$Res> {
  factory _$$ManualSessionRequestImplCopyWith(_$ManualSessionRequestImpl value,
          $Res Function(_$ManualSessionRequestImpl) then) =
      __$$ManualSessionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userBookId, DateTime startedAt, DateTime endedAt, String? note});
}

/// @nodoc
class __$$ManualSessionRequestImplCopyWithImpl<$Res>
    extends _$ManualSessionRequestCopyWithImpl<$Res, _$ManualSessionRequestImpl>
    implements _$$ManualSessionRequestImplCopyWith<$Res> {
  __$$ManualSessionRequestImplCopyWithImpl(_$ManualSessionRequestImpl _value,
      $Res Function(_$ManualSessionRequestImpl) _then)
      : super(_value, _then);

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
    return _then(_$ManualSessionRequestImpl(
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManualSessionRequestImpl implements _ManualSessionRequest {
  const _$ManualSessionRequestImpl(
      {required this.userBookId,
      required this.startedAt,
      required this.endedAt,
      this.note});

  factory _$ManualSessionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManualSessionRequestImplFromJson(json);

  @override
  final String userBookId;
  @override
  final DateTime startedAt;
  @override
  final DateTime endedAt;
  @override
  final String? note;

  @override
  String toString() {
    return 'ManualSessionRequest(userBookId: $userBookId, startedAt: $startedAt, endedAt: $endedAt, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManualSessionRequestImpl &&
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

  /// Create a copy of ManualSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManualSessionRequestImplCopyWith<_$ManualSessionRequestImpl>
      get copyWith =>
          __$$ManualSessionRequestImplCopyWithImpl<_$ManualSessionRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManualSessionRequestImplToJson(
      this,
    );
  }
}

abstract class _ManualSessionRequest implements ManualSessionRequest {
  const factory _ManualSessionRequest(
      {required final String userBookId,
      required final DateTime startedAt,
      required final DateTime endedAt,
      final String? note}) = _$ManualSessionRequestImpl;

  factory _ManualSessionRequest.fromJson(Map<String, dynamic> json) =
      _$ManualSessionRequestImpl.fromJson;

  @override
  String get userBookId;
  @override
  DateTime get startedAt;
  @override
  DateTime get endedAt;
  @override
  String? get note;

  /// Create a copy of ManualSessionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManualSessionRequestImplCopyWith<_$ManualSessionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateGoalRequest _$CreateGoalRequestFromJson(Map<String, dynamic> json) {
  return _CreateGoalRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateGoalRequest {
  String get period => throw _privateConstructorUsedError;
  int get targetBooks => throw _privateConstructorUsedError;
  int get targetSeconds => throw _privateConstructorUsedError;

  /// Serializes this CreateGoalRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateGoalRequestCopyWith<CreateGoalRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateGoalRequestCopyWith<$Res> {
  factory $CreateGoalRequestCopyWith(
          CreateGoalRequest value, $Res Function(CreateGoalRequest) then) =
      _$CreateGoalRequestCopyWithImpl<$Res, CreateGoalRequest>;
  @useResult
  $Res call({String period, int targetBooks, int targetSeconds});
}

/// @nodoc
class _$CreateGoalRequestCopyWithImpl<$Res, $Val extends CreateGoalRequest>
    implements $CreateGoalRequestCopyWith<$Res> {
  _$CreateGoalRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      targetBooks: null == targetBooks
          ? _value.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _value.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateGoalRequestImplCopyWith<$Res>
    implements $CreateGoalRequestCopyWith<$Res> {
  factory _$$CreateGoalRequestImplCopyWith(_$CreateGoalRequestImpl value,
          $Res Function(_$CreateGoalRequestImpl) then) =
      __$$CreateGoalRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String period, int targetBooks, int targetSeconds});
}

/// @nodoc
class __$$CreateGoalRequestImplCopyWithImpl<$Res>
    extends _$CreateGoalRequestCopyWithImpl<$Res, _$CreateGoalRequestImpl>
    implements _$$CreateGoalRequestImplCopyWith<$Res> {
  __$$CreateGoalRequestImplCopyWithImpl(_$CreateGoalRequestImpl _value,
      $Res Function(_$CreateGoalRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_$CreateGoalRequestImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      targetBooks: null == targetBooks
          ? _value.targetBooks
          : targetBooks // ignore: cast_nullable_to_non_nullable
              as int,
      targetSeconds: null == targetSeconds
          ? _value.targetSeconds
          : targetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateGoalRequestImpl implements _CreateGoalRequest {
  const _$CreateGoalRequestImpl(
      {required this.period,
      required this.targetBooks,
      required this.targetSeconds});

  factory _$CreateGoalRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateGoalRequestImplFromJson(json);

  @override
  final String period;
  @override
  final int targetBooks;
  @override
  final int targetSeconds;

  @override
  String toString() {
    return 'CreateGoalRequest(period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateGoalRequestImpl &&
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

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateGoalRequestImplCopyWith<_$CreateGoalRequestImpl> get copyWith =>
      __$$CreateGoalRequestImplCopyWithImpl<_$CreateGoalRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateGoalRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateGoalRequest implements CreateGoalRequest {
  const factory _CreateGoalRequest(
      {required final String period,
      required final int targetBooks,
      required final int targetSeconds}) = _$CreateGoalRequestImpl;

  factory _CreateGoalRequest.fromJson(Map<String, dynamic> json) =
      _$CreateGoalRequestImpl.fromJson;

  @override
  String get period;
  @override
  int get targetBooks;
  @override
  int get targetSeconds;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateGoalRequestImplCopyWith<_$CreateGoalRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
