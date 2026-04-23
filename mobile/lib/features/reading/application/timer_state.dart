import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/reading_goal.dart';

part 'timer_state.freezed.dart';

/// Timer state machine consumed by the timer screen.
///
/// Transitions (enforced by [TimerNotifier]):
///
/// ```
///   Idle ── start(userBookId) ──▶ Running
///   Running ── pause() ──▶ Paused
///   Paused ── resume() ──▶ Running
///   Running|Paused ── end() ──▶ Ending ──▶ Completed
///   Running|Paused ── end() ──▶ Ending ──▶ Failure
/// ```
///
/// [pausedMs] tracks the total accumulated milliseconds the user has spent in
/// the Paused branch since start. The value is sent to the backend on end;
/// the backend does not re-verify it (see M3 contract).
@freezed
sealed class TimerState with _$TimerState {
  const factory TimerState.idle() = TimerIdle;

  /// Active run. [backgroundEnteredAt] is set only while the app is in
  /// background so the resume path can compute iOS-30min-gap auto-end.
  const factory TimerState.running({
    required String sessionId,
    required String userBookId,
    required DateTime startedAt,
    required int pausedMs,
    DateTime? backgroundEnteredAt,
  }) = TimerRunning;

  /// Paused state carries the running snapshot plus `pauseStartedAt` so the
  /// notifier can extend [accumulatedPausedMs] when the user resumes.
  const factory TimerState.paused({
    required String sessionId,
    required String userBookId,
    required DateTime startedAt,
    required int accumulatedPausedMs,
    required DateTime pauseStartedAt,
  }) = TimerPaused;

  /// End request in-flight. UI shows a spinner on the "종료" button.
  const factory TimerState.ending({
    required String sessionId,
    required String userBookId,
  }) = TimerEnding;

  /// Happy-path landing — session closed and grade summary delivered. The
  /// summary screen consumes this state once and then transitions back to
  /// [idle] via [TimerNotifier.acknowledgeCompletion].
  const factory TimerState.completed({
    required SessionCompletion completion,
  }) = TimerCompleted;

  /// Error surfaced by the repository. [code] lets the screen decide whether
  /// to show a snackbar vs. a recovery-prompt modal (e.g.
  /// `ACTIVE_SESSION_EXISTS` routes to the existing session).
  const factory TimerState.failure({
    required String code,
    required String message,
  }) = TimerFailure;
}
