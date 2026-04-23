import 'package:book_club/features/reading/application/goal_notifier.dart';
import 'package:book_club/features/reading/application/goal_state.dart';
import 'package:book_club/features/reading/domain/goal_period.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('GoalNotifier', () {
    test('load populates items from repository', () async {
      final repo = FakeReadingRepository()
        ..goalsResult = <dynamic>[
          buildGoalProgress(
            goal: buildGoal(period: GoalPeriod.weekly),
            booksDone: 2,
            secondsDone: 7200,
            percent: 0.75,
          ),
        ].cast();

      final notifier = GoalNotifier(repo);
      await notifier.load();

      expect(notifier.state, isA<GoalLoaded>());
      final loaded = notifier.state as GoalLoaded;
      expect(loaded.items, hasLength(1));
      expect(loaded.items.first.goal.period, GoalPeriod.weekly);
    });

    test('createGoal triggers a refresh and returns the created goal',
        () async {
      final repo = FakeReadingRepository()
        ..createGoalResult =
            buildGoal(period: GoalPeriod.monthly, targetBooks: 4);

      final notifier = GoalNotifier(repo);
      final result = await notifier.createGoal(
        period: GoalPeriod.monthly,
        targetBooks: 4,
        targetSeconds: 3600 * 10,
      );

      expect(result.targetBooks, 4);
      expect(repo.createGoalCalls, hasLength(1));
      expect(repo.currentGoalsCalls, greaterThan(0));
    });

    test('progressFor returns null when the period has no active goal',
        () async {
      final repo = FakeReadingRepository()
        ..goalsResult = <dynamic>[
          buildGoalProgress(goal: buildGoal(period: GoalPeriod.weekly)),
        ].cast();
      final notifier = GoalNotifier(repo);
      await notifier.load();

      expect(notifier.progressFor(GoalPeriod.weekly), isNotNull);
      expect(notifier.progressFor(GoalPeriod.yearly), isNull);
    });
  });
}
