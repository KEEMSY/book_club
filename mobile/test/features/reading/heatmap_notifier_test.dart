import 'package:book_club/features/reading/application/heatmap_notifier.dart';
import 'package:book_club/features/reading/application/heatmap_state.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('HeatmapNotifier', () {
    test('load fetches a trailing 365-day window and caches the result',
        () async {
      final repo = FakeReadingRepository()
        ..heatmapQueue = <dynamic>[
          buildHeatmapDay(
            date: DateTime(2026, 4, 20),
            totalSeconds: 1800,
            sessionCount: 1,
          ),
        ].cast();

      final notifier = HeatmapNotifier(repo);

      await notifier.load();
      expect(notifier.state, isA<HeatmapLoaded>());
      expect(repo.heatmapCalls, hasLength(1));
      final call = repo.heatmapCalls.single;
      expect(call.to.difference(call.from).inDays, 364);

      // A subsequent non-forced load is a no-op.
      await notifier.load();
      expect(repo.heatmapCalls, hasLength(1));

      // Force refresh re-fires the request.
      await notifier.load(force: true);
      expect(repo.heatmapCalls.length, greaterThan(1));
    });

    test('surfaces error state on network failure', () async {
      final repo = FakeReadingRepository()
        ..heatmapError = const ReadingRepositoryException(
          code: 'NETWORK_ERROR',
          message: '네트워크 오류가 발생했습니다',
        );

      final notifier = HeatmapNotifier(repo);
      await notifier.load();

      expect(notifier.state, isA<HeatmapError>());
      final err = notifier.state as HeatmapError;
      expect(err.code, 'NETWORK_ERROR');
    });

    test('invalidate triggers a forced refresh', () async {
      final repo = FakeReadingRepository();
      final notifier = HeatmapNotifier(repo);
      await notifier.load();
      final int before = repo.heatmapCalls.length;
      await notifier.invalidate();
      expect(repo.heatmapCalls.length, greaterThan(before));
    });
  });
}
