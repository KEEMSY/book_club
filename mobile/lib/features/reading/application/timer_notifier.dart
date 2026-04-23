import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';
import '../data/reading_repository.dart';

import 'reading_providers.dart';
import 'timer_state.dart';

/// After this wall-clock gap the session auto-ends at `backgroundEnteredAt +
/// 30min`, matching the iOS background-execution risk documented in the
/// design doc's §"리스크 및 대응".
const Duration kBackgroundAutoEndThreshold = Duration(minutes: 30);

/// Payload persisted to secure storage so an app relaunch can restore an
/// active session and continue counting without losing elapsed time. Kept as
/// a plain map (not freezed) because the shape is trivial and evolves
/// independently from the on-wire DTO.
class PersistedTimerSession {
  const PersistedTimerSession({
    required this.sessionId,
    required this.userBookId,
    required this.startedAt,
    required this.pausedMs,
    this.pausedAt,
  });

  final String sessionId;
  final String userBookId;
  final DateTime startedAt;
  final int pausedMs;
  final DateTime? pausedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'session_id': sessionId,
        'user_book_id': userBookId,
        'started_at': startedAt.toUtc().toIso8601String(),
        'paused_ms': pausedMs,
        if (pausedAt != null) 'paused_at': pausedAt!.toUtc().toIso8601String(),
      };

  static PersistedTimerSession? tryFromJson(Map<String, dynamic> json) {
    try {
      return PersistedTimerSession(
        sessionId: json['session_id'] as String,
        userBookId: json['user_book_id'] as String,
        startedAt: DateTime.parse(json['started_at'] as String),
        pausedMs: (json['paused_ms'] as num).toInt(),
        pausedAt: json['paused_at'] is String
            ? DateTime.parse(json['paused_at'] as String)
            : null,
      );
    } catch (_) {
      return null;
    }
  }
}

/// Key under which [SecureStorage] persists the active session snapshot.
const String kTimerSecureStorageKey = 'reading.active_session';

/// Orchestrates the timer state machine. Owns the wall-clock tick stream so
/// the TimerScreen can stay declarative (it only watches [TimerState] and
/// the separate [timerElapsedProvider] for the seconds-updating clock).
class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier({
    required ReadingRepository repository,
    required SecureStorage storage,
    DateTime Function()? clock,
    String Function()? devicePlatform,
  })  : _repository = repository,
        _storage = storage,
        _clock = clock ?? DateTime.now,
        _devicePlatform = devicePlatform ?? _defaultDevicePlatform,
        super(const TimerState.idle());

  final ReadingRepository _repository;
  final SecureStorage _storage;
  final DateTime Function() _clock;
  final String Function() _devicePlatform;

  static String _defaultDevicePlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'aos';
    return 'web';
  }

  /// Re-hydrates an active session from secure storage on app launch. No-op
  /// if the stored blob is missing or malformed.
  Future<void> restore() async {
    final String? raw = await _readPersisted();
    if (raw == null) {
      return;
    }
    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      final PersistedTimerSession? persisted =
          PersistedTimerSession.tryFromJson(json);
      if (persisted == null) {
        await _clearPersisted();
        return;
      }
      if (persisted.pausedAt != null) {
        state = TimerState.paused(
          sessionId: persisted.sessionId,
          userBookId: persisted.userBookId,
          startedAt: persisted.startedAt,
          accumulatedPausedMs: persisted.pausedMs,
          pauseStartedAt: persisted.pausedAt!,
        );
      } else {
        state = TimerState.running(
          sessionId: persisted.sessionId,
          userBookId: persisted.userBookId,
          startedAt: persisted.startedAt,
          pausedMs: persisted.pausedMs,
        );
      }
    } catch (_) {
      await _clearPersisted();
    }
  }

  /// Kicks off a new timer session. Surfaces repository errors via
  /// [TimerFailure] so the screen can route `ACTIVE_SESSION_EXISTS` to a
  /// recovery action.
  Future<void> start(String userBookId) async {
    if (state is TimerRunning || state is TimerPaused || state is TimerEnding) {
      return;
    }
    try {
      final session = await _repository.startSession(
        userBookId: userBookId,
        device: _devicePlatform(),
      );
      state = TimerState.running(
        sessionId: session.id,
        userBookId: session.userBookId,
        startedAt: session.startedAt,
        pausedMs: 0,
      );
      await _persist();
    } on ReadingRepositoryException catch (e) {
      state = TimerState.failure(code: e.code, message: e.message);
    }
  }

  /// Flips Running → Paused. Paused state carries a wall-clock snapshot so
  /// resume can add the paused-span into the accumulated total.
  Future<void> pause() async {
    final current = state;
    if (current is! TimerRunning) return;
    state = TimerState.paused(
      sessionId: current.sessionId,
      userBookId: current.userBookId,
      startedAt: current.startedAt,
      accumulatedPausedMs: current.pausedMs,
      pauseStartedAt: _clock(),
    );
    await _persist();
  }

  /// Flips Paused → Running and folds the paused span into `pausedMs`.
  Future<void> resume() async {
    final current = state;
    if (current is! TimerPaused) return;
    final int addedMs =
        _clock().difference(current.pauseStartedAt).inMilliseconds;
    state = TimerState.running(
      sessionId: current.sessionId,
      userBookId: current.userBookId,
      startedAt: current.startedAt,
      pausedMs: current.accumulatedPausedMs + (addedMs < 0 ? 0 : addedMs),
    );
    await _persist();
  }

  /// Closes the session and surfaces the post-end grade summary. When
  /// [overrideEndedAt] is supplied the caller is force-ending the session
  /// (e.g. iOS 30-minute background gap resume) — it becomes the backend's
  /// `ended_at` timestamp verbatim.
  Future<void> end({DateTime? overrideEndedAt}) async {
    final current = state;
    String sessionId;
    String userBookId;
    int pausedMs;
    DateTime endedAt;

    if (current is TimerRunning) {
      sessionId = current.sessionId;
      userBookId = current.userBookId;
      pausedMs = current.pausedMs;
      endedAt = overrideEndedAt ?? _clock();
    } else if (current is TimerPaused) {
      sessionId = current.sessionId;
      userBookId = current.userBookId;
      // Include the in-progress pause window in the reported total.
      final int inFlightPause =
          _clock().difference(current.pauseStartedAt).inMilliseconds;
      pausedMs =
          current.accumulatedPausedMs + (inFlightPause < 0 ? 0 : inFlightPause);
      endedAt = overrideEndedAt ?? _clock();
    } else {
      return;
    }

    state = TimerState.ending(sessionId: sessionId, userBookId: userBookId);
    try {
      final completion = await _repository.endSession(
        sessionId: sessionId,
        endedAt: endedAt,
        pausedMs: pausedMs,
      );
      state = TimerState.completed(completion: completion);
      await _clearPersisted();
    } on ReadingRepositoryException catch (e) {
      state = TimerState.failure(code: e.code, message: e.message);
      // Do not clear the persisted session on failure — user may retry.
    }
  }

  /// Called after the summary screen has been acknowledged; returns the
  /// notifier back to idle so the dashboard can show the start-reading CTA.
  void acknowledgeCompletion() {
    if (state is TimerCompleted || state is TimerFailure) {
      state = const TimerState.idle();
    }
  }

  /// Clears a failure surface without losing an active session.
  void clearFailure() {
    if (state is TimerFailure) {
      state = const TimerState.idle();
    }
  }

  /// Marks the moment the app went to background. Running-state only.
  void appBackgrounded() {
    final current = state;
    if (current is TimerRunning) {
      state = TimerState.running(
        sessionId: current.sessionId,
        userBookId: current.userBookId,
        startedAt: current.startedAt,
        pausedMs: current.pausedMs,
        backgroundEnteredAt: _clock(),
      );
    }
  }

  /// Resume-from-background hook. Returns the auto-ended completion if the
  /// iOS 30-minute rule tripped so the caller can surface the disposition
  /// modal.
  Future<SessionAutoEndResult?> appResumed() async {
    final current = state;
    if (current is! TimerRunning || current.backgroundEnteredAt == null) {
      // Clear any stale background marker.
      if (current is TimerRunning && current.backgroundEnteredAt != null) {
        state = TimerState.running(
          sessionId: current.sessionId,
          userBookId: current.userBookId,
          startedAt: current.startedAt,
          pausedMs: current.pausedMs,
        );
      }
      return null;
    }
    final DateTime enteredAt = current.backgroundEnteredAt!;
    final Duration gap = _clock().difference(enteredAt);
    if (gap >= kBackgroundAutoEndThreshold) {
      final DateTime forcedEnd = enteredAt.add(kBackgroundAutoEndThreshold);
      await end(overrideEndedAt: forcedEnd);
      return SessionAutoEndResult(
        forcedEndedAt: forcedEnd,
        gap: gap,
      );
    }
    // Under threshold — just drop the background marker; the elapsed clock
    // naturally resumes because it is wall-clock based.
    state = TimerState.running(
      sessionId: current.sessionId,
      userBookId: current.userBookId,
      startedAt: current.startedAt,
      pausedMs: current.pausedMs,
    );
    return null;
  }

  /// Computes the displayable elapsed duration given the current state. For
  /// Completed / Failure / Idle returns [Duration.zero]; the summary screen
  /// has its own formatting fed directly from [SessionCompletion].
  Duration elapsedAt(DateTime now) {
    final current = state;
    if (current is TimerRunning) {
      final int total =
          now.difference(current.startedAt).inMilliseconds - current.pausedMs;
      return Duration(milliseconds: total < 0 ? 0 : total);
    }
    if (current is TimerPaused) {
      final int total =
          current.pauseStartedAt.difference(current.startedAt).inMilliseconds -
              current.accumulatedPausedMs;
      return Duration(milliseconds: total < 0 ? 0 : total);
    }
    return Duration.zero;
  }

  Future<void> _persist() async {
    final current = state;
    PersistedTimerSession? snapshot;
    if (current is TimerRunning) {
      snapshot = PersistedTimerSession(
        sessionId: current.sessionId,
        userBookId: current.userBookId,
        startedAt: current.startedAt,
        pausedMs: current.pausedMs,
      );
    } else if (current is TimerPaused) {
      snapshot = PersistedTimerSession(
        sessionId: current.sessionId,
        userBookId: current.userBookId,
        startedAt: current.startedAt,
        pausedMs: current.accumulatedPausedMs,
        pausedAt: current.pauseStartedAt,
      );
    }
    if (snapshot != null) {
      await _writePersisted(jsonEncode(snapshot.toJson()));
    }
  }

  Future<String?> _readPersisted() {
    return _storage.readRaw(kTimerSecureStorageKey);
  }

  Future<void> _writePersisted(String value) {
    return _storage.writeRaw(kTimerSecureStorageKey, value);
  }

  Future<void> _clearPersisted() {
    return _storage.deleteRaw(kTimerSecureStorageKey);
  }
}

/// Emitted by [TimerNotifier.appResumed] when the iOS 30-minute background
/// rule triggered an automatic end. The dashboard surfaces a modal asking
/// the user whether to keep or discard the forced-end session.
class SessionAutoEndResult {
  const SessionAutoEndResult({required this.forcedEndedAt, required this.gap});

  final DateTime forcedEndedAt;
  final Duration gap;
}

final timerNotifierProvider =
    StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier(
    repository: ref.watch(readingRepositoryProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

/// Ticks once a second whenever the timer is running/paused, so the screen
/// can rebuild its HH:MM:SS string. Consumers watch this provider alongside
/// [timerNotifierProvider] and recompute `elapsedAt(DateTime.now())`.
final timerTickProvider = StreamProvider<DateTime>((ref) {
  final state = ref.watch(timerNotifierProvider);
  if (state is TimerRunning) {
    return Stream<DateTime>.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    );
  }
  // Paused, Idle, Completed, Failure: single-shot emit so the screen shows a
  // frozen elapsed count without a leaking timer.
  return Stream<DateTime>.value(DateTime.now());
});
