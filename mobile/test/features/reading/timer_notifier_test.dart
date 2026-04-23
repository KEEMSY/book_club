import 'package:book_club/features/reading/application/timer_notifier.dart';
import 'package:book_club/features/reading/application/timer_state.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../auth/fakes.dart' show InMemorySecureStorage;
import 'fakes.dart';

/// Injectable clock that increments per `call()` so paused/resume spans are
/// deterministic. Seed with a base [DateTime] and tick manually via [advance].
class _ManualClock {
  _ManualClock(DateTime seed) : _now = seed;

  DateTime _now;

  DateTime now() => _now;

  void advance(Duration by) => _now = _now.add(by);
}

void main() {
  group('TimerNotifier · state machine', () {
    test('start surfaces Running with zero pausedMs on success', () async {
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1', userBookId: 'ub1');
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
      );

      await notifier.start('ub1');

      expect(notifier.state, isA<TimerRunning>());
      final running = notifier.state as TimerRunning;
      expect(running.sessionId, 's1');
      expect(running.userBookId, 'ub1');
      expect(running.pausedMs, 0);
      expect(repo.startCalls, hasLength(1));
    });

    test('start surfaces Failure on ACTIVE_SESSION_EXISTS', () async {
      final repo = FakeReadingRepository()
        ..startError = const ReadingRepositoryException(
          code: 'ACTIVE_SESSION_EXISTS',
          message: '이미 진행 중인 세션이 있어요',
          statusCode: 409,
        );
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
      );

      await notifier.start('ub1');

      expect(notifier.state, isA<TimerFailure>());
      final err = notifier.state as TimerFailure;
      expect(err.code, 'ACTIVE_SESSION_EXISTS');
    });

    test('Running → Paused → Running accumulates pausedMs', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(
          id: 's1',
          startedAt: DateTime.utc(2026, 4, 20, 12),
        );
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );

      await notifier.start('ub1');

      // 3 minutes of reading.
      clock.advance(const Duration(minutes: 3));
      await notifier.pause();
      expect(notifier.state, isA<TimerPaused>());

      // 90 seconds paused.
      clock.advance(const Duration(seconds: 90));
      await notifier.resume();

      final running = notifier.state as TimerRunning;
      expect(running.pausedMs, 90 * 1000);
    });

    test('multiple pause/resume cycles fold into a single pausedMs total',
        () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(
          id: 's1',
          startedAt: DateTime.utc(2026, 4, 20, 12),
        );
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );

      await notifier.start('ub1');

      clock.advance(const Duration(minutes: 2));
      await notifier.pause();
      clock.advance(const Duration(seconds: 30));
      await notifier.resume();

      clock.advance(const Duration(minutes: 1));
      await notifier.pause();
      clock.advance(const Duration(seconds: 45));
      await notifier.resume();

      final running = notifier.state as TimerRunning;
      expect(running.pausedMs, (30 + 45) * 1000);
    });

    test('end Running transitions through Ending to Completed', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion(sessionId: 's1', durationSec: 1200);
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );

      await notifier.start('ub1');
      clock.advance(const Duration(minutes: 20));
      await notifier.end();

      expect(notifier.state, isA<TimerCompleted>());
      final completed = notifier.state as TimerCompleted;
      expect(completed.completion.durationSec, 1200);
      expect(repo.endCalls, hasLength(1));
      expect(repo.endCalls.first.pausedMs, 0);
    });

    test('end from Paused includes in-flight pause window', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion();
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );

      await notifier.start('ub1');
      clock.advance(const Duration(minutes: 1));
      await notifier.pause();
      clock.advance(const Duration(seconds: 30));
      await notifier.end();

      expect(repo.endCalls.single.pausedMs, 30 * 1000);
    });

    test('end surfaces Failure on SESSION_TOO_SHORT', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endError = const ReadingRepositoryException(
          code: 'SESSION_TOO_SHORT',
          message: '세션이 너무 짧아요',
          statusCode: 409,
        );
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );

      await notifier.start('ub1');
      clock.advance(const Duration(milliseconds: 500));
      await notifier.end();

      expect(notifier.state, isA<TimerFailure>());
      final err = notifier.state as TimerFailure;
      expect(err.code, 'SESSION_TOO_SHORT');
    });

    test('persistence round-trip restores a running session', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final storage = InMemorySecureStorage();
      final repo = FakeReadingRepository()
        ..startResult = buildSession(
          id: 'persist-1',
          startedAt: DateTime.utc(2026, 4, 20, 12),
        );
      final notifierA = TimerNotifier(
        repository: repo,
        storage: storage,
        clock: clock.now,
      );
      await notifierA.start('ub1');

      // A fresh notifier instance (simulating app relaunch) picks up the
      // persisted session from the shared storage.
      final notifierB = TimerNotifier(
        repository: repo,
        storage: storage,
        clock: clock.now,
      );
      await notifierB.restore();

      expect(notifierB.state, isA<TimerRunning>());
      final running = notifierB.state as TimerRunning;
      expect(running.sessionId, 'persist-1');
    });

    test('appResumed auto-ends after 30-minute gap', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion();
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );

      await notifier.start('ub1');
      clock.advance(const Duration(seconds: 10));
      final DateTime backgroundedAt = clock.now();
      notifier.appBackgrounded();

      clock.advance(const Duration(minutes: 35));
      final result = await notifier.appResumed();

      expect(result, isNotNull);
      expect(notifier.state, isA<TimerCompleted>());
      // Forced end timestamp is exactly `backgroundedAt + 30min`.
      expect(
        repo.endCalls.single.endedAt,
        backgroundedAt.add(const Duration(minutes: 30)),
      );
    });

    test('appResumed under threshold drops background marker only', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1');
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );

      await notifier.start('ub1');
      clock.advance(const Duration(seconds: 10));
      notifier.appBackgrounded();
      clock.advance(const Duration(minutes: 5));
      final result = await notifier.appResumed();

      expect(result, isNull);
      expect(notifier.state, isA<TimerRunning>());
      final running = notifier.state as TimerRunning;
      expect(running.backgroundEnteredAt, isNull);
    });

    test('acknowledgeCompletion returns notifier to Idle', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion();
      final notifier = TimerNotifier(
        repository: repo,
        storage: InMemorySecureStorage(),
        clock: clock.now,
      );
      await notifier.start('ub1');
      clock.advance(const Duration(minutes: 20));
      await notifier.end();
      expect(notifier.state, isA<TimerCompleted>());

      notifier.acknowledgeCompletion();
      expect(notifier.state, isA<TimerIdle>());
    });
  });
}
