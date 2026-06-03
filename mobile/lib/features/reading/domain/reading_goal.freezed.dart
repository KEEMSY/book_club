// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingGoal {
  String get id;
  GoalPeriod get period;
  int get targetBooks;
  int get targetSeconds;
  DateTime get startDate;
  DateTime get endDate;

  /// Create a copy of ReadingGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadingGoalCopyWith<ReadingGoal> get copyWith =>
      _$ReadingGoalCopyWithImpl<ReadingGoal>(this as ReadingGoal, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadingGoal &&
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

  @override
  String toString() {
    return 'ReadingGoal(id: $id, period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $ReadingGoalCopyWith<$Res> {
  factory $ReadingGoalCopyWith(
          ReadingGoal value, $Res Function(ReadingGoal) _then) =
      _$ReadingGoalCopyWithImpl;
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
class _$ReadingGoalCopyWithImpl<$Res> implements $ReadingGoalCopyWith<$Res> {
  _$ReadingGoalCopyWithImpl(this._self, this._then);

  final ReadingGoal _self;
  final $Res Function(ReadingGoal) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as GoalPeriod,
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

/// Adds pattern-matching-related methods to [ReadingGoal].
extension ReadingGoalPatterns on ReadingGoal {
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
    TResult Function(_ReadingGoal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingGoal() when $default != null:
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
    TResult Function(_ReadingGoal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingGoal():
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
    TResult? Function(_ReadingGoal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingGoal() when $default != null:
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
    TResult Function(String id, GoalPeriod period, int targetBooks,
            int targetSeconds, DateTime startDate, DateTime endDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingGoal() when $default != null:
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
    TResult Function(String id, GoalPeriod period, int targetBooks,
            int targetSeconds, DateTime startDate, DateTime endDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingGoal():
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
    TResult? Function(String id, GoalPeriod period, int targetBooks,
            int targetSeconds, DateTime startDate, DateTime endDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingGoal() when $default != null:
        return $default(_that.id, _that.period, _that.targetBooks,
            _that.targetSeconds, _that.startDate, _that.endDate);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReadingGoal implements ReadingGoal {
  const _ReadingGoal(
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

  /// Create a copy of ReadingGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReadingGoalCopyWith<_ReadingGoal> get copyWith =>
      __$ReadingGoalCopyWithImpl<_ReadingGoal>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReadingGoal &&
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

  @override
  String toString() {
    return 'ReadingGoal(id: $id, period: $period, targetBooks: $targetBooks, targetSeconds: $targetSeconds, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$ReadingGoalCopyWith<$Res>
    implements $ReadingGoalCopyWith<$Res> {
  factory _$ReadingGoalCopyWith(
          _ReadingGoal value, $Res Function(_ReadingGoal) _then) =
      __$ReadingGoalCopyWithImpl;
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
class __$ReadingGoalCopyWithImpl<$Res> implements _$ReadingGoalCopyWith<$Res> {
  __$ReadingGoalCopyWithImpl(this._self, this._then);

  final _ReadingGoal _self;
  final $Res Function(_ReadingGoal) _then;

  /// Create a copy of ReadingGoal
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
    return _then(_ReadingGoal(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as GoalPeriod,
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
mixin _$GoalProgress {
  ReadingGoal get goal;
  int get booksDone;
  int get secondsDone;
  double get percent;

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalProgressCopyWith<GoalProgress> get copyWith =>
      _$GoalProgressCopyWithImpl<GoalProgress>(
          this as GoalProgress, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalProgress &&
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

  @override
  String toString() {
    return 'GoalProgress(goal: $goal, booksDone: $booksDone, secondsDone: $secondsDone, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class $GoalProgressCopyWith<$Res> {
  factory $GoalProgressCopyWith(
          GoalProgress value, $Res Function(GoalProgress) _then) =
      _$GoalProgressCopyWithImpl;
  @useResult
  $Res call({ReadingGoal goal, int booksDone, int secondsDone, double percent});

  $ReadingGoalCopyWith<$Res> get goal;
}

/// @nodoc
class _$GoalProgressCopyWithImpl<$Res> implements $GoalProgressCopyWith<$Res> {
  _$GoalProgressCopyWithImpl(this._self, this._then);

  final GoalProgress _self;
  final $Res Function(GoalProgress) _then;

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
    return _then(_self.copyWith(
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as ReadingGoal,
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

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingGoalCopyWith<$Res> get goal {
    return $ReadingGoalCopyWith<$Res>(_self.goal, (value) {
      return _then(_self.copyWith(goal: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GoalProgress].
extension GoalProgressPatterns on GoalProgress {
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
    TResult Function(_GoalProgress value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalProgress() when $default != null:
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
    TResult Function(_GoalProgress value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgress():
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
    TResult? Function(_GoalProgress value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgress() when $default != null:
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
            ReadingGoal goal, int booksDone, int secondsDone, double percent)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalProgress() when $default != null:
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
            ReadingGoal goal, int booksDone, int secondsDone, double percent)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgress():
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
            ReadingGoal goal, int booksDone, int secondsDone, double percent)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalProgress() when $default != null:
        return $default(
            _that.goal, _that.booksDone, _that.secondsDone, _that.percent);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GoalProgress implements GoalProgress {
  const _GoalProgress(
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

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalProgressCopyWith<_GoalProgress> get copyWith =>
      __$GoalProgressCopyWithImpl<_GoalProgress>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalProgress &&
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

  @override
  String toString() {
    return 'GoalProgress(goal: $goal, booksDone: $booksDone, secondsDone: $secondsDone, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class _$GoalProgressCopyWith<$Res>
    implements $GoalProgressCopyWith<$Res> {
  factory _$GoalProgressCopyWith(
          _GoalProgress value, $Res Function(_GoalProgress) _then) =
      __$GoalProgressCopyWithImpl;
  @override
  @useResult
  $Res call({ReadingGoal goal, int booksDone, int secondsDone, double percent});

  @override
  $ReadingGoalCopyWith<$Res> get goal;
}

/// @nodoc
class __$GoalProgressCopyWithImpl<$Res>
    implements _$GoalProgressCopyWith<$Res> {
  __$GoalProgressCopyWithImpl(this._self, this._then);

  final _GoalProgress _self;
  final $Res Function(_GoalProgress) _then;

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? goal = null,
    Object? booksDone = null,
    Object? secondsDone = null,
    Object? percent = null,
  }) {
    return _then(_GoalProgress(
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as ReadingGoal,
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

  /// Create a copy of GoalProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingGoalCopyWith<$Res> get goal {
    return $ReadingGoalCopyWith<$Res>(_self.goal, (value) {
      return _then(_self.copyWith(goal: value));
    });
  }
}

/// @nodoc
mixin _$SessionCompletion {
  String get sessionId;
  String get userBookId;
  DateTime get startedAt;
  DateTime get endedAt;
  int get durationSec;
  int get grade;
  int get streakDays;
  bool get gradeUp;

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionCompletionCopyWith<SessionCompletion> get copyWith =>
      _$SessionCompletionCopyWithImpl<SessionCompletion>(
          this as SessionCompletion, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionCompletion &&
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

  @override
  String toString() {
    return 'SessionCompletion(sessionId: $sessionId, userBookId: $userBookId, startedAt: $startedAt, endedAt: $endedAt, durationSec: $durationSec, grade: $grade, streakDays: $streakDays, gradeUp: $gradeUp)';
  }
}

/// @nodoc
abstract mixin class $SessionCompletionCopyWith<$Res> {
  factory $SessionCompletionCopyWith(
          SessionCompletion value, $Res Function(SessionCompletion) _then) =
      _$SessionCompletionCopyWithImpl;
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
class _$SessionCompletionCopyWithImpl<$Res>
    implements $SessionCompletionCopyWith<$Res> {
  _$SessionCompletionCopyWithImpl(this._self, this._then);

  final SessionCompletion _self;
  final $Res Function(SessionCompletion) _then;

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
    return _then(_self.copyWith(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
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
      durationSec: null == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// Adds pattern-matching-related methods to [SessionCompletion].
extension SessionCompletionPatterns on SessionCompletion {
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
    TResult Function(_SessionCompletion value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionCompletion() when $default != null:
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
    TResult Function(_SessionCompletion value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletion():
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
    TResult? Function(_SessionCompletion value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletion() when $default != null:
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
            String userBookId,
            DateTime startedAt,
            DateTime endedAt,
            int durationSec,
            int grade,
            int streakDays,
            bool gradeUp)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionCompletion() when $default != null:
        return $default(
            _that.sessionId,
            _that.userBookId,
            _that.startedAt,
            _that.endedAt,
            _that.durationSec,
            _that.grade,
            _that.streakDays,
            _that.gradeUp);
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
            String userBookId,
            DateTime startedAt,
            DateTime endedAt,
            int durationSec,
            int grade,
            int streakDays,
            bool gradeUp)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletion():
        return $default(
            _that.sessionId,
            _that.userBookId,
            _that.startedAt,
            _that.endedAt,
            _that.durationSec,
            _that.grade,
            _that.streakDays,
            _that.gradeUp);
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
            String userBookId,
            DateTime startedAt,
            DateTime endedAt,
            int durationSec,
            int grade,
            int streakDays,
            bool gradeUp)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionCompletion() when $default != null:
        return $default(
            _that.sessionId,
            _that.userBookId,
            _that.startedAt,
            _that.endedAt,
            _that.durationSec,
            _that.grade,
            _that.streakDays,
            _that.gradeUp);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SessionCompletion implements SessionCompletion {
  const _SessionCompletion(
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

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionCompletionCopyWith<_SessionCompletion> get copyWith =>
      __$SessionCompletionCopyWithImpl<_SessionCompletion>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionCompletion &&
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

  @override
  String toString() {
    return 'SessionCompletion(sessionId: $sessionId, userBookId: $userBookId, startedAt: $startedAt, endedAt: $endedAt, durationSec: $durationSec, grade: $grade, streakDays: $streakDays, gradeUp: $gradeUp)';
  }
}

/// @nodoc
abstract mixin class _$SessionCompletionCopyWith<$Res>
    implements $SessionCompletionCopyWith<$Res> {
  factory _$SessionCompletionCopyWith(
          _SessionCompletion value, $Res Function(_SessionCompletion) _then) =
      __$SessionCompletionCopyWithImpl;
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
class __$SessionCompletionCopyWithImpl<$Res>
    implements _$SessionCompletionCopyWith<$Res> {
  __$SessionCompletionCopyWithImpl(this._self, this._then);

  final _SessionCompletion _self;
  final $Res Function(_SessionCompletion) _then;

  /// Create a copy of SessionCompletion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_SessionCompletion(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
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
      durationSec: null == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
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
}

// dart format on
