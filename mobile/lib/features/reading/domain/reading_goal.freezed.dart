// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReadingGoal {
  String get id => throw _privateConstructorUsedError;
  GoalPeriod get period => throw _privateConstructorUsedError;
  int get targetBooks => throw _privateConstructorUsedError;
  int get targetSeconds => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Create a copy of ReadingGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingGoalCopyWith<ReadingGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingGoalCopyWith<$Res> {
  factory $ReadingGoalCopyWith(
          ReadingGoal value, $Res Function(ReadingGoal) then) =
      _$ReadingGoalCopyWithImpl<$Res, ReadingGoal>;
  @useResult
  $Res call(
      {String id,
      GoalPeriod period,
      int targetBooks,
      int targetSeconds,
      DateTime startDate,
      DateTime endDate});
}

/// @nodoc
class _$ReadingGoalCopyWithImpl<$Res, $Val extends ReadingGoal>
    implements $ReadingGoalCopyWith<$Res> {
  _$ReadingGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingGoal
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
              as GoalPeriod,
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
abstract class _$$ReadingGoalImplCopyWith<$Res>
    implements $ReadingGoalCopyWith<$Res> {
  factory _$$ReadingGoalImplCopyWith(
          _$ReadingGoalImpl value, $Res Function(_$ReadingGoalImpl) then) =
      __$$ReadingGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      GoalPeriod period,
      int targetBooks,
      int targetSeconds,
      DateTime startDate,
      DateTime endDate});
}

/// @nodoc
class __$$ReadingGoalImplCopyWithImpl<$Res>
    extends _$ReadingGoalCopyWithImpl<$Res, _$ReadingGoalImpl>
    implements _$$ReadingGoalImplCopyWith<$Res> {
  __$$ReadingGoalImplCopyWithImpl(
      _$ReadingGoalImpl _value, $Res Function(_$ReadingGoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReadingGoal
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
    return _then(_$ReadingGoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as GoalPeriod,
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

class _$ReadingGoalImpl implements _ReadingGoal {
  const _$ReadingGoalImpl(
      {required this.id,
      required this.period,
      required this.targetBooks,
      required this.targetSeconds,
      required this.startDate,
      required this.endDate});

  @override
  final String id;
  @override
  final GoalPeriod period;
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
    return 'ReadingGoal(id: $id, period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingGoalImpl &&
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

  @override
  int get hashCode => Object.hash(
      runtimeType, id, period, targetBooks, targetSeconds, startDate, endDate);

  /// Create a copy of ReadingGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingGoalImplCopyWith<_$ReadingGoalImpl> get copyWith =>
      __$$ReadingGoalImplCopyWithImpl<_$ReadingGoalImpl>(this, _$identity);
}

abstract class _ReadingGoal implements ReadingGoal {
  const factory _ReadingGoal(
      {required final String id,
      required final GoalPeriod period,
      required final int targetBooks,
      required final int targetSeconds,
      required final DateTime startDate,
      required final DateTime endDate}) = _$ReadingGoalImpl;

  @override
  String get id;
  @override
  GoalPeriod get period;
  @override
  int get targetBooks;
  @override
  int get targetSeconds;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// Create a copy of ReadingGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingGoalImplCopyWith<_$ReadingGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GoalProgress {
  ReadingGoal get goal => throw _privateConstructorUsedError;
  int get booksDone => throw _privateConstructorUsedError;
  int get secondsDone => throw _privateConstructorUsedError;
  double get percent => throw _privateConstructorUsedError;

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalProgressCopyWith<GoalProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalProgressCopyWith<$Res> {
  factory $GoalProgressCopyWith(
          GoalProgress value, $Res Function(GoalProgress) then) =
      _$GoalProgressCopyWithImpl<$Res, GoalProgress>;
  @useResult
  $Res call({ReadingGoal goal, int booksDone, int secondsDone, double percent});

  $ReadingGoalCopyWith<$Res> get goal;
}

/// @nodoc
class _$GoalProgressCopyWithImpl<$Res, $Val extends GoalProgress>
    implements $GoalProgressCopyWith<$Res> {
  _$GoalProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalProgress
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
              as ReadingGoal,
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

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingGoalCopyWith<$Res> get goal {
    return $ReadingGoalCopyWith<$Res>(_value.goal, (value) {
      return _then(_value.copyWith(goal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GoalProgressImplCopyWith<$Res>
    implements $GoalProgressCopyWith<$Res> {
  factory _$$GoalProgressImplCopyWith(
          _$GoalProgressImpl value, $Res Function(_$GoalProgressImpl) then) =
      __$$GoalProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ReadingGoal goal, int booksDone, int secondsDone, double percent});

  @override
  $ReadingGoalCopyWith<$Res> get goal;
}

/// @nodoc
class __$$GoalProgressImplCopyWithImpl<$Res>
    extends _$GoalProgressCopyWithImpl<$Res, _$GoalProgressImpl>
    implements _$$GoalProgressImplCopyWith<$Res> {
  __$$GoalProgressImplCopyWithImpl(
      _$GoalProgressImpl _value, $Res Function(_$GoalProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goal = null,
    Object? booksDone = null,
    Object? secondsDone = null,
    Object? percent = null,
  }) {
    return _then(_$GoalProgressImpl(
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as ReadingGoal,
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

class _$GoalProgressImpl implements _GoalProgress {
  const _$GoalProgressImpl(
      {required this.goal,
      required this.booksDone,
      required this.secondsDone,
      required this.percent});

  @override
  final ReadingGoal goal;
  @override
  final int booksDone;
  @override
  final int secondsDone;
  @override
  final double percent;

  @override
  String toString() {
    return 'GoalProgress(goal: $goal, booksDone: $booksDone, secondsDone: $secondsDone, percent: $percent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalProgressImpl &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.booksDone, booksDone) ||
                other.booksDone == booksDone) &&
            (identical(other.secondsDone, secondsDone) ||
                other.secondsDone == secondsDone) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, goal, booksDone, secondsDone, percent);

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalProgressImplCopyWith<_$GoalProgressImpl> get copyWith =>
      __$$GoalProgressImplCopyWithImpl<_$GoalProgressImpl>(this, _$identity);
}

abstract class _GoalProgress implements GoalProgress {
  const factory _GoalProgress(
      {required final ReadingGoal goal,
      required final int booksDone,
      required final int secondsDone,
      required final double percent}) = _$GoalProgressImpl;

  @override
  ReadingGoal get goal;
  @override
  int get booksDone;
  @override
  int get secondsDone;
  @override
  double get percent;

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalProgressImplCopyWith<_$GoalProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SessionCompletion {
  String get sessionId => throw _privateConstructorUsedError;
  String get userBookId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime get endedAt => throw _privateConstructorUsedError;
  int get durationSec => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  bool get gradeUp => throw _privateConstructorUsedError;

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCompletionCopyWith<SessionCompletion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCompletionCopyWith<$Res> {
  factory $SessionCompletionCopyWith(
          SessionCompletion value, $Res Function(SessionCompletion) then) =
      _$SessionCompletionCopyWithImpl<$Res, SessionCompletion>;
  @useResult
  $Res call(
      {String sessionId,
      String userBookId,
      DateTime startedAt,
      DateTime endedAt,
      int durationSec,
      int grade,
      int streakDays,
      bool gradeUp});
}

/// @nodoc
class _$SessionCompletionCopyWithImpl<$Res, $Val extends SessionCompletion>
    implements $SessionCompletionCopyWith<$Res> {
  _$SessionCompletionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? durationSec = null,
    Object? grade = null,
    Object? streakDays = null,
    Object? gradeUp = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
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
      durationSec: null == durationSec
          ? _value.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc
abstract class _$$SessionCompletionImplCopyWith<$Res>
    implements $SessionCompletionCopyWith<$Res> {
  factory _$$SessionCompletionImplCopyWith(_$SessionCompletionImpl value,
          $Res Function(_$SessionCompletionImpl) then) =
      __$$SessionCompletionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String userBookId,
      DateTime startedAt,
      DateTime endedAt,
      int durationSec,
      int grade,
      int streakDays,
      bool gradeUp});
}

/// @nodoc
class __$$SessionCompletionImplCopyWithImpl<$Res>
    extends _$SessionCompletionCopyWithImpl<$Res, _$SessionCompletionImpl>
    implements _$$SessionCompletionImplCopyWith<$Res> {
  __$$SessionCompletionImplCopyWithImpl(_$SessionCompletionImpl _value,
      $Res Function(_$SessionCompletionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? durationSec = null,
    Object? grade = null,
    Object? streakDays = null,
    Object? gradeUp = null,
  }) {
    return _then(_$SessionCompletionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
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
      durationSec: null == durationSec
          ? _value.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
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

class _$SessionCompletionImpl implements _SessionCompletion {
  const _$SessionCompletionImpl(
      {required this.sessionId,
      required this.userBookId,
      required this.startedAt,
      required this.endedAt,
      required this.durationSec,
      required this.grade,
      required this.streakDays,
      required this.gradeUp});

  @override
  final String sessionId;
  @override
  final String userBookId;
  @override
  final DateTime startedAt;
  @override
  final DateTime endedAt;
  @override
  final int durationSec;
  @override
  final int grade;
  @override
  final int streakDays;
  @override
  final bool gradeUp;

  @override
  String toString() {
    return 'SessionCompletion(sessionId: $sessionId, userBookId: $userBookId, startedAt: $startedAt, endedAt: $endedAt, durationSec: $durationSec, grade: $grade, streakDays: $streakDays, gradeUp: $gradeUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionCompletionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.gradeUp, gradeUp) || other.gradeUp == gradeUp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userBookId, startedAt,
      endedAt, durationSec, grade, streakDays, gradeUp);

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionCompletionImplCopyWith<_$SessionCompletionImpl> get copyWith =>
      __$$SessionCompletionImplCopyWithImpl<_$SessionCompletionImpl>(
          this, _$identity);
}

abstract class _SessionCompletion implements SessionCompletion {
  const factory _SessionCompletion(
      {required final String sessionId,
      required final String userBookId,
      required final DateTime startedAt,
      required final DateTime endedAt,
      required final int durationSec,
      required final int grade,
      required final int streakDays,
      required final bool gradeUp}) = _$SessionCompletionImpl;

  @override
  String get sessionId;
  @override
  String get userBookId;
  @override
  DateTime get startedAt;
  @override
  DateTime get endedAt;
  @override
  int get durationSec;
  @override
  int get grade;
  @override
  int get streakDays;
  @override
  bool get gradeUp;

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionCompletionImplCopyWith<_$SessionCompletionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
