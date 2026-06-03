// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimerState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TimerState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TimerState()';
  }
}

/// @nodoc
class $TimerStateCopyWith<$Res> {
  $TimerStateCopyWith(TimerState _, $Res Function(TimerState) __);
}

/// Adds pattern-matching-related methods to [TimerState].
extension TimerStatePatterns on TimerState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerRunning value)? running,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerEnding value)? ending,
    TResult Function(TimerCompleted value)? completed,
    TResult Function(TimerFailure value)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TimerIdle() when idle != null:
        return idle(_that);
      case TimerRunning() when running != null:
        return running(_that);
      case TimerPaused() when paused != null:
        return paused(_that);
      case TimerEnding() when ending != null:
        return ending(_that);
      case TimerCompleted() when completed != null:
        return completed(_that);
      case TimerFailure() when failure != null:
        return failure(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) {
    final _that = this;
    switch (_that) {
      case TimerIdle():
        return idle(_that);
      case TimerRunning():
        return running(_that);
      case TimerPaused():
        return paused(_that);
      case TimerEnding():
        return ending(_that);
      case TimerCompleted():
        return completed(_that);
      case TimerFailure():
        return failure(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case TimerIdle() when idle != null:
        return idle(_that);
      case TimerRunning() when running != null:
        return running(_that);
      case TimerPaused() when paused != null:
        return paused(_that);
      case TimerEnding() when ending != null:
        return ending(_that);
      case TimerCompleted() when completed != null:
        return completed(_that);
      case TimerFailure() when failure != null:
        return failure(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String sessionId, String userBookId, DateTime startedAt,
            int pausedMs, DateTime? backgroundEnteredAt)?
        running,
    TResult Function(String sessionId, String userBookId, DateTime startedAt,
            int accumulatedPausedMs, DateTime pauseStartedAt)?
        paused,
    TResult Function(String sessionId, String userBookId)? ending,
    TResult Function(SessionCompletion completion)? completed,
    TResult Function(String code, String message)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TimerIdle() when idle != null:
        return idle();
      case TimerRunning() when running != null:
        return running(_that.sessionId, _that.userBookId, _that.startedAt,
            _that.pausedMs, _that.backgroundEnteredAt);
      case TimerPaused() when paused != null:
        return paused(_that.sessionId, _that.userBookId, _that.startedAt,
            _that.accumulatedPausedMs, _that.pauseStartedAt);
      case TimerEnding() when ending != null:
        return ending(_that.sessionId, _that.userBookId);
      case TimerCompleted() when completed != null:
        return completed(_that.completion);
      case TimerFailure() when failure != null:
        return failure(_that.code, _that.message);
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
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String sessionId, String userBookId,
            DateTime startedAt, int pausedMs, DateTime? backgroundEnteredAt)
        running,
    required TResult Function(
            String sessionId,
            String userBookId,
            DateTime startedAt,
            int accumulatedPausedMs,
            DateTime pauseStartedAt)
        paused,
    required TResult Function(String sessionId, String userBookId) ending,
    required TResult Function(SessionCompletion completion) completed,
    required TResult Function(String code, String message) failure,
  }) {
    final _that = this;
    switch (_that) {
      case TimerIdle():
        return idle();
      case TimerRunning():
        return running(_that.sessionId, _that.userBookId, _that.startedAt,
            _that.pausedMs, _that.backgroundEnteredAt);
      case TimerPaused():
        return paused(_that.sessionId, _that.userBookId, _that.startedAt,
            _that.accumulatedPausedMs, _that.pauseStartedAt);
      case TimerEnding():
        return ending(_that.sessionId, _that.userBookId);
      case TimerCompleted():
        return completed(_that.completion);
      case TimerFailure():
        return failure(_that.code, _that.message);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String sessionId, String userBookId, DateTime startedAt,
            int pausedMs, DateTime? backgroundEnteredAt)?
        running,
    TResult? Function(String sessionId, String userBookId, DateTime startedAt,
            int accumulatedPausedMs, DateTime pauseStartedAt)?
        paused,
    TResult? Function(String sessionId, String userBookId)? ending,
    TResult? Function(SessionCompletion completion)? completed,
    TResult? Function(String code, String message)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case TimerIdle() when idle != null:
        return idle();
      case TimerRunning() when running != null:
        return running(_that.sessionId, _that.userBookId, _that.startedAt,
            _that.pausedMs, _that.backgroundEnteredAt);
      case TimerPaused() when paused != null:
        return paused(_that.sessionId, _that.userBookId, _that.startedAt,
            _that.accumulatedPausedMs, _that.pauseStartedAt);
      case TimerEnding() when ending != null:
        return ending(_that.sessionId, _that.userBookId);
      case TimerCompleted() when completed != null:
        return completed(_that.completion);
      case TimerFailure() when failure != null:
        return failure(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class TimerIdle implements TimerState {
  const TimerIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TimerIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TimerState.idle()';
  }
}

/// @nodoc

class TimerRunning implements TimerState {
  const TimerRunning(
      {required this.sessionId,
      required this.userBookId,
      required this.startedAt,
      required this.pausedMs,
      this.backgroundEnteredAt});

  final String sessionId;
  final String userBookId;
  final DateTime startedAt;
  final int pausedMs;
  final DateTime? backgroundEnteredAt;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimerRunningCopyWith<TimerRunning> get copyWith =>
      _$TimerRunningCopyWithImpl<TimerRunning>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimerRunning &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.pausedMs, pausedMs) ||
                other.pausedMs == pausedMs) &&
            (identical(other.backgroundEnteredAt, backgroundEnteredAt) ||
                other.backgroundEnteredAt == backgroundEnteredAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userBookId, startedAt,
      pausedMs, backgroundEnteredAt);

  @override
  String toString() {
    return 'TimerState.running(sessionId: $sessionId, userBookId: $userBookId, startedAt: $startedAt, pausedMs: $pausedMs, backgroundEnteredAt: $backgroundEnteredAt)';
  }
}

/// @nodoc
abstract mixin class $TimerRunningCopyWith<$Res>
    implements $TimerStateCopyWith<$Res> {
  factory $TimerRunningCopyWith(
          TimerRunning value, $Res Function(TimerRunning) _then) =
      _$TimerRunningCopyWithImpl;
  @useResult
  $Res call(
      {String sessionId,
      String userBookId,
      DateTime startedAt,
      int pausedMs,
      DateTime? backgroundEnteredAt});
}

/// @nodoc
class _$TimerRunningCopyWithImpl<$Res> implements $TimerRunningCopyWith<$Res> {
  _$TimerRunningCopyWithImpl(this._self, this._then);

  final TimerRunning _self;
  final $Res Function(TimerRunning) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? pausedMs = null,
    Object? backgroundEnteredAt = freezed,
  }) {
    return _then(TimerRunning(
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
      pausedMs: null == pausedMs
          ? _self.pausedMs
          : pausedMs // ignore: cast_nullable_to_non_nullable
              as int,
      backgroundEnteredAt: freezed == backgroundEnteredAt
          ? _self.backgroundEnteredAt
          : backgroundEnteredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class TimerPaused implements TimerState {
  const TimerPaused(
      {required this.sessionId,
      required this.userBookId,
      required this.startedAt,
      required this.accumulatedPausedMs,
      required this.pauseStartedAt});

  final String sessionId;
  final String userBookId;
  final DateTime startedAt;
  final int accumulatedPausedMs;
  final DateTime pauseStartedAt;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimerPausedCopyWith<TimerPaused> get copyWith =>
      _$TimerPausedCopyWithImpl<TimerPaused>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimerPaused &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.accumulatedPausedMs, accumulatedPausedMs) ||
                other.accumulatedPausedMs == accumulatedPausedMs) &&
            (identical(other.pauseStartedAt, pauseStartedAt) ||
                other.pauseStartedAt == pauseStartedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userBookId, startedAt,
      accumulatedPausedMs, pauseStartedAt);

  @override
  String toString() {
    return 'TimerState.paused(sessionId: $sessionId, userBookId: $userBookId, startedAt: $startedAt, accumulatedPausedMs: $accumulatedPausedMs, pauseStartedAt: $pauseStartedAt)';
  }
}

/// @nodoc
abstract mixin class $TimerPausedCopyWith<$Res>
    implements $TimerStateCopyWith<$Res> {
  factory $TimerPausedCopyWith(
          TimerPaused value, $Res Function(TimerPaused) _then) =
      _$TimerPausedCopyWithImpl;
  @useResult
  $Res call(
      {String sessionId,
      String userBookId,
      DateTime startedAt,
      int accumulatedPausedMs,
      DateTime pauseStartedAt});
}

/// @nodoc
class _$TimerPausedCopyWithImpl<$Res> implements $TimerPausedCopyWith<$Res> {
  _$TimerPausedCopyWithImpl(this._self, this._then);

  final TimerPaused _self;
  final $Res Function(TimerPaused) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? accumulatedPausedMs = null,
    Object? pauseStartedAt = null,
  }) {
    return _then(TimerPaused(
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
      accumulatedPausedMs: null == accumulatedPausedMs
          ? _self.accumulatedPausedMs
          : accumulatedPausedMs // ignore: cast_nullable_to_non_nullable
              as int,
      pauseStartedAt: null == pauseStartedAt
          ? _self.pauseStartedAt
          : pauseStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class TimerEnding implements TimerState {
  const TimerEnding({required this.sessionId, required this.userBookId});

  final String sessionId;
  final String userBookId;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimerEndingCopyWith<TimerEnding> get copyWith =>
      _$TimerEndingCopyWithImpl<TimerEnding>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimerEnding &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userBookId);

  @override
  String toString() {
    return 'TimerState.ending(sessionId: $sessionId, userBookId: $userBookId)';
  }
}

/// @nodoc
abstract mixin class $TimerEndingCopyWith<$Res>
    implements $TimerStateCopyWith<$Res> {
  factory $TimerEndingCopyWith(
          TimerEnding value, $Res Function(TimerEnding) _then) =
      _$TimerEndingCopyWithImpl;
  @useResult
  $Res call({String sessionId, String userBookId});
}

/// @nodoc
class _$TimerEndingCopyWithImpl<$Res> implements $TimerEndingCopyWith<$Res> {
  _$TimerEndingCopyWithImpl(this._self, this._then);

  final TimerEnding _self;
  final $Res Function(TimerEnding) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
  }) {
    return _then(TimerEnding(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class TimerCompleted implements TimerState {
  const TimerCompleted({required this.completion});

  final SessionCompletion completion;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimerCompletedCopyWith<TimerCompleted> get copyWith =>
      _$TimerCompletedCopyWithImpl<TimerCompleted>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimerCompleted &&
            (identical(other.completion, completion) ||
                other.completion == completion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, completion);

  @override
  String toString() {
    return 'TimerState.completed(completion: $completion)';
  }
}

/// @nodoc
abstract mixin class $TimerCompletedCopyWith<$Res>
    implements $TimerStateCopyWith<$Res> {
  factory $TimerCompletedCopyWith(
          TimerCompleted value, $Res Function(TimerCompleted) _then) =
      _$TimerCompletedCopyWithImpl;
  @useResult
  $Res call({SessionCompletion completion});

  $SessionCompletionCopyWith<$Res> get completion;
}

/// @nodoc
class _$TimerCompletedCopyWithImpl<$Res>
    implements $TimerCompletedCopyWith<$Res> {
  _$TimerCompletedCopyWithImpl(this._self, this._then);

  final TimerCompleted _self;
  final $Res Function(TimerCompleted) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? completion = null,
  }) {
    return _then(TimerCompleted(
      completion: null == completion
          ? _self.completion
          : completion // ignore: cast_nullable_to_non_nullable
              as SessionCompletion,
    ));
  }

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionCompletionCopyWith<$Res> get completion {
    return $SessionCompletionCopyWith<$Res>(_self.completion, (value) {
      return _then(_self.copyWith(completion: value));
    });
  }
}

/// @nodoc

class TimerFailure implements TimerState {
  const TimerFailure({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimerFailureCopyWith<TimerFailure> get copyWith =>
      _$TimerFailureCopyWithImpl<TimerFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimerFailure &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'TimerState.failure(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $TimerFailureCopyWith<$Res>
    implements $TimerStateCopyWith<$Res> {
  factory $TimerFailureCopyWith(
          TimerFailure value, $Res Function(TimerFailure) _then) =
      _$TimerFailureCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$TimerFailureCopyWithImpl<$Res> implements $TimerFailureCopyWith<$Res> {
  _$TimerFailureCopyWithImpl(this._self, this._then);

  final TimerFailure _self;
  final $Res Function(TimerFailure) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(TimerFailure(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
