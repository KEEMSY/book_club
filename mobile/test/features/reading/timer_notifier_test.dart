import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/application/timer_notifier.dart';
import 'package:book_club/features/reading/application/timer_state.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Builds a [ProviderContainer] with the fake repo, storage, and an optional
/// manual clock. Registers teardown automatically via [addTearDown].
ProviderContainer _makeContainer({
  required FakeReadingRepository repo,
  InMemorySecureStorage? storage,
  _ManualClock? clock,
}) {
  final st = storage ?? InMemorySecureStorage();
  final container = ProviderContainer(
    overrides: [
      readingRepositoryProvider.overrideWithValue(repo),
      secureStorageProvider.overrideWithValue(st),
      if (clock != null) timerClockProvider.overrideWith((_) => clock.now),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('TimerNotifier · state machine', () {
    test('start surfaces Running with zero pausedMs on success', () async {
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1', userBookId: 'ub1');
      final c = _makeContainer(repo: repo);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');

      expect(c.read(timerNotifierProvider), isA<TimerRunning>());
      final running = c.read(timerNotifierProvider) as TimerRunning;
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
      final c = _makeContainer(repo: repo);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');

      expect(c.read(timerNotifierProvider), isA<TimerFailure>());
      final err = c.read(timerNotifierProvider) as TimerFailure;
      expect(err.code, 'ACTIVE_SESSION_EXISTS');
    });

    test('Running → Paused → Running accumulates pausedMs', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(
          id: 's1',
          startedAt: DateTime.utc(2026, 4, 20, 12),
        );
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');

      // 3 minutes of reading.
      clock.advance(const Duration(minutes: 3));
      await notifier.pause();
      expect(c.read(timerNotifierProvider), isA<TimerPaused>());

      // 90 seconds paused.
      clock.advance(const Duration(seconds: 90));
      await notifier.resume();

      final running = c.read(timerNotifierProvider) as TimerRunning;
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
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');

      clock.advance(const Duration(minutes: 2));
      await notifier.pause();
      clock.advance(const Duration(seconds: 30));
      await notifier.resume();

      clock.advance(const Duration(minutes: 1));
      await notifier.pause();
      clock.advance(const Duration(seconds: 45));
      await notifier.resume();

      final running = c.read(timerNotifierProvider) as TimerRunning;
      expect(running.pausedMs, (30 + 45) * 1000);
    });

    test('end Running transitions through Ending to Completed', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion(sessionId: 's1', durationSec: 1200);
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');
      clock.advance(const Duration(minutes: 20));
      await notifier.end();

      expect(c.read(timerNotifierProvider), isA<TimerCompleted>());
      final completed = c.read(timerNotifierProvider) as TimerCompleted;
      expect(completed.completion.durationSec, 1200);
      expect(repo.endCalls, hasLength(1));
      expect(repo.endCalls.first.pausedMs, 0);
    });

    test('end from Paused includes in-flight pause window', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion();
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

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
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');
      clock.advance(const Duration(milliseconds: 500));
      await notifier.end();

      expect(c.read(timerNotifierProvider), isA<TimerFailure>());
      final err = c.read(timerNotifierProvider) as TimerFailure;
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

      // Session A writes to storage.
      final cA = _makeContainer(repo: repo, storage: storage, clock: clock);
      await cA.read(timerNotifierProvider.notifier).start('ub1');

      // Session B (fresh container, same storage) restores.
      final cB = _makeContainer(repo: repo, storage: storage, clock: clock);
      await cB.read(timerNotifierProvider.notifier).restore();

      expect(cB.read(timerNotifierProvider), isA<TimerRunning>());
      final running = cB.read(timerNotifierProvider) as TimerRunning;
      expect(running.sessionId, 'persist-1');
    });

    test('appResumed auto-ends after 30-minute gap', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion();
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');
      clock.advance(const Duration(seconds: 10));
      final DateTime backgroundedAt = clock.now();
      notifier.appBackgrounded();

      clock.advance(const Duration(minutes: 35));
      final result = await notifier.appResumed();

      expect(result, isNotNull);
      expect(c.read(timerNotifierProvider), isA<TimerCompleted>());
      expect(
        repo.endCalls.single.endedAt,
        backgroundedAt.add(const Duration(minutes: 30)),
      );
    });

    test('appResumed under threshold drops background marker only', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1');
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');
      clock.advance(const Duration(seconds: 10));
      notifier.appBackgrounded();
      clock.advance(const Duration(minutes: 5));
      final result = await notifier.appResumed();

      expect(result, isNull);
      expect(c.read(timerNotifierProvider), isA<TimerRunning>());
      final running = c.read(timerNotifierProvider) as TimerRunning;
      expect(running.backgroundEnteredAt, isNull);
    });

    test('end returns to Idle on SESSION_NOT_FOUND without persisting failure',
        () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final storage = InMemorySecureStorage();
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endError = const ReadingRepositoryException(
          code: 'SESSION_NOT_FOUND',
          message: '세션을 찾을 수 없어요',
          statusCode: 404,
        );
      final c = _makeContainer(repo: repo, storage: storage, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');
      clock.advance(const Duration(minutes: 5));
      await notifier.end();

      expect(c.read(timerNotifierProvider), isA<TimerIdle>());
      expect(await storage.readRaw('reading.active_session'), isNull);
    });

    test(
        'end returns to Idle on SESSION_ALREADY_ENDED without persisting failure',
        () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final storage = InMemorySecureStorage();
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endError = const ReadingRepositoryException(
          code: 'SESSION_ALREADY_ENDED',
          message: '이미 종료된 세션이에요',
          statusCode: 409,
        );
      final c = _makeContainer(repo: repo, storage: storage, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');
      clock.advance(const Duration(minutes: 5));
      await notifier.end();

      expect(c.read(timerNotifierProvider), isA<TimerIdle>());
      expect(await storage.readRaw('reading.active_session'), isNull);
    });

    test('acknowledgeCompletion returns notifier to Idle', () async {
      final clock = _ManualClock(DateTime.utc(2026, 4, 20, 12));
      final repo = FakeReadingRepository()
        ..startResult = buildSession(id: 's1')
        ..endResult = buildCompletion();
      final c = _makeContainer(repo: repo, clock: clock);
      final notifier = c.read(timerNotifierProvider.notifier);

      await notifier.start('ub1');
      clock.advance(const Duration(minutes: 20));
      await notifier.end();
      expect(c.read(timerNotifierProvider), isA<TimerCompleted>());

      notifier.acknowledgeCompletion();
      expect(c.read(timerNotifierProvider), isA<TimerIdle>());
    });
  });
}
