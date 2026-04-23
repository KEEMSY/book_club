// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimerState {
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerRunning value)? running,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerEnding value)? ending,
    TResult Function(TimerCompleted value)? completed,
    TResult Function(TimerFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerStateCopyWith<$Res> {
  factory $TimerStateCopyWith(
          TimerState value, $Res Function(TimerState) then) =
      _$TimerStateCopyWithImpl<$Res, TimerState>;
}

/// @nodoc
class _$TimerStateCopyWithImpl<$Res, $Val extends TimerState>
    implements $TimerStateCopyWith<$Res> {
  _$TimerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TimerIdleImplCopyWith<$Res> {
  factory _$$TimerIdleImplCopyWith(
          _$TimerIdleImpl value, $Res Function(_$TimerIdleImpl) then) =
      __$$TimerIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TimerIdleImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerIdleImpl>
    implements _$$TimerIdleImplCopyWith<$Res> {
  __$$TimerIdleImplCopyWithImpl(
      _$TimerIdleImpl _value, $Res Function(_$TimerIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TimerIdleImpl implements TimerIdle {
  const _$TimerIdleImpl();

  @override
  String toString() {
    return 'TimerState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TimerIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
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
    return idle();
  }

  @override
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
    return idle?.call();
  }

  @override
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
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) {
    return idle?.call(this);
  }

  @override
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
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class TimerIdle implements TimerState {
  const factory TimerIdle() = _$TimerIdleImpl;
}

/// @nodoc
abstract class _$$TimerRunningImplCopyWith<$Res> {
  factory _$$TimerRunningImplCopyWith(
          _$TimerRunningImpl value, $Res Function(_$TimerRunningImpl) then) =
      __$$TimerRunningImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String sessionId,
      String userBookId,
      DateTime startedAt,
      int pausedMs,
      DateTime? backgroundEnteredAt});
}

/// @nodoc
class __$$TimerRunningImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerRunningImpl>
    implements _$$TimerRunningImplCopyWith<$Res> {
  __$$TimerRunningImplCopyWithImpl(
      _$TimerRunningImpl _value, $Res Function(_$TimerRunningImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? pausedMs = null,
    Object? backgroundEnteredAt = freezed,
  }) {
    return _then(_$TimerRunningImpl(
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
      pausedMs: null == pausedMs
          ? _value.pausedMs
          : pausedMs // ignore: cast_nullable_to_non_nullable
              as int,
      backgroundEnteredAt: freezed == backgroundEnteredAt
          ? _value.backgroundEnteredAt
          : backgroundEnteredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$TimerRunningImpl implements TimerRunning {
  const _$TimerRunningImpl(
      {required this.sessionId,
      required this.userBookId,
      required this.startedAt,
      required this.pausedMs,
      this.backgroundEnteredAt});

  @override
  final String sessionId;
  @override
  final String userBookId;
  @override
  final DateTime startedAt;
  @override
  final int pausedMs;
  @override
  final DateTime? backgroundEnteredAt;

  @override
  String toString() {
    return 'TimerState.running(sessionId: $sessionId, userBookId: $userBookId, startedAt: $startedAt, pausedMs: $pausedMs, backgroundEnteredAt: $backgroundEnteredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerRunningImpl &&
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

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerRunningImplCopyWith<_$TimerRunningImpl> get copyWith =>
      __$$TimerRunningImplCopyWithImpl<_$TimerRunningImpl>(this, _$identity);

  @override
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
    return running(
        sessionId, userBookId, startedAt, pausedMs, backgroundEnteredAt);
  }

  @override
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
    return running?.call(
        sessionId, userBookId, startedAt, pausedMs, backgroundEnteredAt);
  }

  @override
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
    if (running != null) {
      return running(
          sessionId, userBookId, startedAt, pausedMs, backgroundEnteredAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) {
    return running(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) {
    return running?.call(this);
  }

  @override
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
    if (running != null) {
      return running(this);
    }
    return orElse();
  }
}

abstract class TimerRunning implements TimerState {
  const factory TimerRunning(
      {required final String sessionId,
      required final String userBookId,
      required final DateTime startedAt,
      required final int pausedMs,
      final DateTime? backgroundEnteredAt}) = _$TimerRunningImpl;

  String get sessionId;
  String get userBookId;
  DateTime get startedAt;
  int get pausedMs;
  DateTime? get backgroundEnteredAt;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerRunningImplCopyWith<_$TimerRunningImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerPausedImplCopyWith<$Res> {
  factory _$$TimerPausedImplCopyWith(
          _$TimerPausedImpl value, $Res Function(_$TimerPausedImpl) then) =
      __$$TimerPausedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String sessionId,
      String userBookId,
      DateTime startedAt,
      int accumulatedPausedMs,
      DateTime pauseStartedAt});
}

/// @nodoc
class __$$TimerPausedImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerPausedImpl>
    implements _$$TimerPausedImplCopyWith<$Res> {
  __$$TimerPausedImplCopyWithImpl(
      _$TimerPausedImpl _value, $Res Function(_$TimerPausedImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? accumulatedPausedMs = null,
    Object? pauseStartedAt = null,
  }) {
    return _then(_$TimerPausedImpl(
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
      accumulatedPausedMs: null == accumulatedPausedMs
          ? _value.accumulatedPausedMs
          : accumulatedPausedMs // ignore: cast_nullable_to_non_nullable
              as int,
      pauseStartedAt: null == pauseStartedAt
          ? _value.pauseStartedAt
          : pauseStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$TimerPausedImpl implements TimerPaused {
  const _$TimerPausedImpl(
      {required this.sessionId,
      required this.userBookId,
      required this.startedAt,
      required this.accumulatedPausedMs,
      required this.pauseStartedAt});

  @override
  final String sessionId;
  @override
  final String userBookId;
  @override
  final DateTime startedAt;
  @override
  final int accumulatedPausedMs;
  @override
  final DateTime pauseStartedAt;

  @override
  String toString() {
    return 'TimerState.paused(sessionId: $sessionId, userBookId: $userBookId, startedAt: $startedAt, accumulatedPausedMs: $accumulatedPausedMs, pauseStartedAt: $pauseStartedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerPausedImpl &&
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

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerPausedImplCopyWith<_$TimerPausedImpl> get copyWith =>
      __$$TimerPausedImplCopyWithImpl<_$TimerPausedImpl>(this, _$identity);

  @override
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
    return paused(
        sessionId, userBookId, startedAt, accumulatedPausedMs, pauseStartedAt);
  }

  @override
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
    return paused?.call(
        sessionId, userBookId, startedAt, accumulatedPausedMs, pauseStartedAt);
  }

  @override
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
    if (paused != null) {
      return paused(sessionId, userBookId, startedAt, accumulatedPausedMs,
          pauseStartedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) {
    return paused(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) {
    return paused?.call(this);
  }

  @override
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
    if (paused != null) {
      return paused(this);
    }
    return orElse();
  }
}

abstract class TimerPaused implements TimerState {
  const factory TimerPaused(
      {required final String sessionId,
      required final String userBookId,
      required final DateTime startedAt,
      required final int accumulatedPausedMs,
      required final DateTime pauseStartedAt}) = _$TimerPausedImpl;

  String get sessionId;
  String get userBookId;
  DateTime get startedAt;
  int get accumulatedPausedMs;
  DateTime get pauseStartedAt;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerPausedImplCopyWith<_$TimerPausedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerEndingImplCopyWith<$Res> {
  factory _$$TimerEndingImplCopyWith(
          _$TimerEndingImpl value, $Res Function(_$TimerEndingImpl) then) =
      __$$TimerEndingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sessionId, String userBookId});
}

/// @nodoc
class __$$TimerEndingImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerEndingImpl>
    implements _$$TimerEndingImplCopyWith<$Res> {
  __$$TimerEndingImplCopyWithImpl(
      _$TimerEndingImpl _value, $Res Function(_$TimerEndingImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userBookId = null,
  }) {
    return _then(_$TimerEndingImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TimerEndingImpl implements TimerEnding {
  const _$TimerEndingImpl({required this.sessionId, required this.userBookId});

  @override
  final String sessionId;
  @override
  final String userBookId;

  @override
  String toString() {
    return 'TimerState.ending(sessionId: $sessionId, userBookId: $userBookId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerEndingImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userBookId);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerEndingImplCopyWith<_$TimerEndingImpl> get copyWith =>
      __$$TimerEndingImplCopyWithImpl<_$TimerEndingImpl>(this, _$identity);

  @override
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
    return ending(sessionId, userBookId);
  }

  @override
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
    return ending?.call(sessionId, userBookId);
  }

  @override
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
    if (ending != null) {
      return ending(sessionId, userBookId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) {
    return ending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) {
    return ending?.call(this);
  }

  @override
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
    if (ending != null) {
      return ending(this);
    }
    return orElse();
  }
}

abstract class TimerEnding implements TimerState {
  const factory TimerEnding(
      {required final String sessionId,
      required final String userBookId}) = _$TimerEndingImpl;

  String get sessionId;
  String get userBookId;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerEndingImplCopyWith<_$TimerEndingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerCompletedImplCopyWith<$Res> {
  factory _$$TimerCompletedImplCopyWith(_$TimerCompletedImpl value,
          $Res Function(_$TimerCompletedImpl) then) =
      __$$TimerCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SessionCompletion completion});

  $SessionCompletionCopyWith<$Res> get completion;
}

/// @nodoc
class __$$TimerCompletedImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerCompletedImpl>
    implements _$$TimerCompletedImplCopyWith<$Res> {
  __$$TimerCompletedImplCopyWithImpl(
      _$TimerCompletedImpl _value, $Res Function(_$TimerCompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completion = null,
  }) {
    return _then(_$TimerCompletedImpl(
      completion: null == completion
          ? _value.completion
          : completion // ignore: cast_nullable_to_non_nullable
              as SessionCompletion,
    ));
  }

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionCompletionCopyWith<$Res> get completion {
    return $SessionCompletionCopyWith<$Res>(_value.completion, (value) {
      return _then(_value.copyWith(completion: value));
    });
  }
}

/// @nodoc

class _$TimerCompletedImpl implements TimerCompleted {
  const _$TimerCompletedImpl({required this.completion});

  @override
  final SessionCompletion completion;

  @override
  String toString() {
    return 'TimerState.completed(completion: $completion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerCompletedImpl &&
            (identical(other.completion, completion) ||
                other.completion == completion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, completion);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerCompletedImplCopyWith<_$TimerCompletedImpl> get copyWith =>
      __$$TimerCompletedImplCopyWithImpl<_$TimerCompletedImpl>(
          this, _$identity);

  @override
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
    return completed(completion);
  }

  @override
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
    return completed?.call(completion);
  }

  @override
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
    if (completed != null) {
      return completed(completion);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) {
    return completed?.call(this);
  }

  @override
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
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class TimerCompleted implements TimerState {
  const factory TimerCompleted({required final SessionCompletion completion}) =
      _$TimerCompletedImpl;

  SessionCompletion get completion;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerCompletedImplCopyWith<_$TimerCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerFailureImplCopyWith<$Res> {
  factory _$$TimerFailureImplCopyWith(
          _$TimerFailureImpl value, $Res Function(_$TimerFailureImpl) then) =
      __$$TimerFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$TimerFailureImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerFailureImpl>
    implements _$$TimerFailureImplCopyWith<$Res> {
  __$$TimerFailureImplCopyWithImpl(
      _$TimerFailureImpl _value, $Res Function(_$TimerFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$TimerFailureImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TimerFailureImpl implements TimerFailure {
  const _$TimerFailureImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'TimerState.failure(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerFailureImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerFailureImplCopyWith<_$TimerFailureImpl> get copyWith =>
      __$$TimerFailureImplCopyWithImpl<_$TimerFailureImpl>(this, _$identity);

  @override
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
    return failure(code, message);
  }

  @override
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
    return failure?.call(code, message);
  }

  @override
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
    if (failure != null) {
      return failure(code, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerEnding value) ending,
    required TResult Function(TimerCompleted value) completed,
    required TResult Function(TimerFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerEnding value)? ending,
    TResult? Function(TimerCompleted value)? completed,
    TResult? Function(TimerFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
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
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class TimerFailure implements TimerState {
  const factory TimerFailure(
      {required final String code,
      required final String message}) = _$TimerFailureImpl;

  String get code;
  String get message;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerFailureImplCopyWith<_$TimerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
