import 'package:book_club/features/reading/application/grade_notifier.dart';
import 'package:book_club/features/reading/application/grade_state.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('GradeNotifier', () {
    test('load surfaces summary on success', () async {
      final repo = FakeReadingRepository()
        ..gradeResult = buildGradeSummary(grade: 2, totalBooks: 5);
      final notifier = GradeNotifier(repo);

      await notifier.load();

      expect(notifier.state, isA<GradeLoaded>());
      final loaded = notifier.state as GradeLoaded;
      expect(loaded.summary.grade, 2);
      expect(loaded.summary.totalBooks, 5);
      expect(loaded.recentGradeUp, isFalse);
    });

    test('applySessionCompletion lights recentGradeUp when gradeUp is true',
        () async {
      final repo = FakeReadingRepository()
        ..gradeResult = buildGradeSummary(grade: 3);
      final notifier = GradeNotifier(repo);
      await notifier.load();

      notifier.applySessionCompletion(
        buildCompletion(
          grade: 3,
          gradeUp: true,
          durationSec: 600,
          streakDays: 2,
        ),
      );

      expect(notifier.state, isA<GradeLoaded>());
      final loaded = notifier.state as GradeLoaded;
      expect(loaded.recentGradeUp, isTrue);
      expect(loaded.summary.streakDays, 2);

      notifier.acknowledgeGradeUp();
      final acknowledged = notifier.state as GradeLoaded;
      expect(acknowledged.recentGradeUp, isFalse);
    });

    test('surfaces error on repository failure', () async {
      final repo = FakeReadingRepository()
        ..gradeError = const ReadingRepositoryException(
          code: 'NETWORK_ERROR',
          message: '네트워크 오류',
        );
      final notifier = GradeNotifier(repo);
      await notifier.load();

      expect(notifier.state, isA<GradeError>());
    });
  });
}
