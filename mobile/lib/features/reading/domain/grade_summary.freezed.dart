// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NextGradeThresholds {
  int get targetBooks => throw _privateConstructorUsedError;
  int get targetSeconds => throw _privateConstructorUsedError;

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NextGradeThresholdsCopyWith<NextGradeThresholds> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NextGradeThresholdsCopyWith<$Res> {
  factory $NextGradeThresholdsCopyWith(
          NextGradeThresholds value, $Res Function(NextGradeThresholds) then) =
      _$NextGradeThresholdsCopyWithImpl<$Res, NextGradeThresholds>;
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class _$NextGradeThresholdsCopyWithImpl<$Res, $Val extends NextGradeThresholds>
    implements $NextGradeThresholdsCopyWith<$Res> {
  _$NextGradeThresholdsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NextGradeThresholds
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
abstract class _$$NextGradeThresholdsImplCopyWith<$Res>
    implements $NextGradeThresholdsCopyWith<$Res> {
  factory _$$NextGradeThresholdsImplCopyWith(_$NextGradeThresholdsImpl value,
          $Res Function(_$NextGradeThresholdsImpl) then) =
      __$$NextGradeThresholdsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int targetBooks, int targetSeconds});
}

/// @nodoc
class __$$NextGradeThresholdsImplCopyWithImpl<$Res>
    extends _$NextGradeThresholdsCopyWithImpl<$Res, _$NextGradeThresholdsImpl>
    implements _$$NextGradeThresholdsImplCopyWith<$Res> {
  __$$NextGradeThresholdsImplCopyWithImpl(_$NextGradeThresholdsImpl _value,
      $Res Function(_$NextGradeThresholdsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetBooks = null,
    Object? targetSeconds = null,
  }) {
    return _then(_$NextGradeThresholdsImpl(
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

class _$NextGradeThresholdsImpl implements _NextGradeThresholds {
  const _$NextGradeThresholdsImpl(
      {required this.targetBooks, required this.targetSeconds});

  @override
  final int targetBooks;
  @override
  final int targetSeconds;

  @override
  String toString() {
    return 'NextGradeThresholds(targetBooks: $targetBooks, targetSeconds: $targetSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextGradeThresholdsImpl &&
            (identical(other.targetBooks, targetBooks) ||
                other.targetBooks == targetBooks) &&
            (identical(other.targetSeconds, targetSeconds) ||
                other.targetSeconds == targetSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetBooks, targetSeconds);

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NextGradeThresholdsImplCopyWith<_$NextGradeThresholdsImpl> get copyWith =>
      __$$NextGradeThresholdsImplCopyWithImpl<_$NextGradeThresholdsImpl>(
          this, _$identity);
}

abstract class _NextGradeThresholds implements NextGradeThresholds {
  const factory _NextGradeThresholds(
      {required final int targetBooks,
      required final int targetSeconds}) = _$NextGradeThresholdsImpl;

  @override
  int get targetBooks;
  @override
  int get targetSeconds;

  /// Create a copy of NextGradeThresholds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NextGradeThresholdsImplCopyWith<_$NextGradeThresholdsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GradeSummary {
  int get grade => throw _privateConstructorUsedError;
  int get totalBooks => throw _privateConstructorUsedError;
  int get totalSeconds => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  NextGradeThresholds? get nextGradeThresholds =>
      throw _privateConstructorUsedError;

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GradeSummaryCopyWith<GradeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeSummaryCopyWith<$Res> {
  factory $GradeSummaryCopyWith(
          GradeSummary value, $Res Function(GradeSummary) then) =
      _$GradeSummaryCopyWithImpl<$Res, GradeSummary>;
  @useResult
  $Res call(
      {int grade,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak,
      NextGradeThresholds? nextGradeThresholds});

  $NextGradeThresholdsCopyWith<$Res>? get nextGradeThresholds;
}

/// @nodoc
class _$GradeSummaryCopyWithImpl<$Res, $Val extends GradeSummary>
    implements $GradeSummaryCopyWith<$Res> {
  _$GradeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
              as NextGradeThresholds?,
    ) as $Val);
  }

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextGradeThresholdsCopyWith<$Res>? get nextGradeThresholds {
    if (_value.nextGradeThresholds == null) {
      return null;
    }

    return $NextGradeThresholdsCopyWith<$Res>(_value.nextGradeThresholds!,
        (value) {
      return _then(_value.copyWith(nextGradeThresholds: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GradeSummaryImplCopyWith<$Res>
    implements $GradeSummaryCopyWith<$Res> {
  factory _$$GradeSummaryImplCopyWith(
          _$GradeSummaryImpl value, $Res Function(_$GradeSummaryImpl) then) =
      __$$GradeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int grade,
      int totalBooks,
      int totalSeconds,
      int streakDays,
      int longestStreak,
      NextGradeThresholds? nextGradeThresholds});

  @override
  $NextGradeThresholdsCopyWith<$Res>? get nextGradeThresholds;
}

/// @nodoc
class __$$GradeSummaryImplCopyWithImpl<$Res>
    extends _$GradeSummaryCopyWithImpl<$Res, _$GradeSummaryImpl>
    implements _$$GradeSummaryImplCopyWith<$Res> {
  __$$GradeSummaryImplCopyWithImpl(
      _$GradeSummaryImpl _value, $Res Function(_$GradeSummaryImpl) _then)
      : super(_value, _then);

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
  }) {
    return _then(_$GradeSummaryImpl(
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
              as NextGradeThresholds?,
    ));
  }
}

/// @nodoc

class _$GradeSummaryImpl extends _GradeSummary {
  const _$GradeSummaryImpl(
      {required this.grade,
      required this.totalBooks,
      required this.totalSeconds,
      required this.streakDays,
      required this.longestStreak,
      this.nextGradeThresholds})
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
  String toString() {
    return 'GradeSummary(grade: $grade, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays, longestStreak: $longestStreak, nextGradeThresholds: $nextGradeThresholds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeSummaryImpl &&
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
                other.nextGradeThresholds == nextGradeThresholds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, grade, totalBooks, totalSeconds,
      streakDays, longestStreak, nextGradeThresholds);

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeSummaryImplCopyWith<_$GradeSummaryImpl> get copyWith =>
      __$$GradeSummaryImplCopyWithImpl<_$GradeSummaryImpl>(this, _$identity);
}

abstract class _GradeSummary extends GradeSummary {
  const factory _GradeSummary(
      {required final int grade,
      required final int totalBooks,
      required final int totalSeconds,
      required final int streakDays,
      required final int longestStreak,
      final NextGradeThresholds? nextGradeThresholds}) = _$GradeSummaryImpl;
  const _GradeSummary._() : super._();

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
  NextGradeThresholds? get nextGradeThresholds;

  /// Create a copy of GradeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeSummaryImplCopyWith<_$GradeSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
