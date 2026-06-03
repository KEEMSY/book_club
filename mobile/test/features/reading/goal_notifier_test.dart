import 'package:book_club/features/reading/application/goal_notifier.dart';
import 'package:book_club/features/reading/application/goal_state.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/domain/goal_period.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      final c = ProviderContainer(overrides: [
        readingRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(goalNotifierProvider.notifier);
      await notifier.load();

      expect(c.read(goalNotifierProvider), isA<GoalLoaded>());
      final loaded = c.read(goalNotifierProvider) as GoalLoaded;
      expect(loaded.items, hasLength(1));
      expect(loaded.items.first.goal.period, GoalPeriod.weekly);
    });

    test('createGoal triggers a refresh and returns the created goal',
        () async {
      final repo = FakeReadingRepository()
        ..createGoalResult =
            buildGoal(period: GoalPeriod.monthly, targetBooks: 4);

      final c = ProviderContainer(overrides: [
        readingRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(goalNotifierProvider.notifier);
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
      final c = ProviderContainer(overrides: [
        readingRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(goalNotifierProvider.notifier);
      await notifier.load();

      expect(notifier.progressFor(GoalPeriod.weekly), isNotNull);
      expect(notifier.progressFor(GoalPeriod.yearly), isNull);
    });

    test(
        'createJourney calls createGoal three times with derived targets'
        ' and refreshes afterwards', () async {
      // Inputs from the brief: 52 books / yr, 30 min/day, 7 days/week.
      // Derived per ReadingJourneyTargets:
      //   weekly  = ceil(52/52)  =  1 권 · 30·60·7        = 12600 sec
      //   monthly = ceil(52/12)  =  5 권 · round(12600·52/12) = 54600 sec
      //   yearly  = 52 권 · 12600 · 52                 = 655200 sec
      final repo = FakeReadingRepository()
        ..createGoalResult = buildGoal(period: GoalPeriod.weekly);

      final c = ProviderContainer(overrides: [
        readingRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(goalNotifierProvider.notifier);
      await notifier.createJourney(
        yearlyBooks: 52,
        dailyMinutes: 30,
        weeklyDays: 7,
      );

      expect(repo.createGoalCalls, hasLength(3));

      final weekly =
          repo.createGoalCalls.firstWhere((c) => c.period == GoalPeriod.weekly);
      expect(weekly.targetBooks, 1);
      expect(weekly.targetSeconds, 30 * 60 * 7);
      expect(weekly.targetSeconds, 12600);

      final monthly = repo.createGoalCalls
          .firstWhere((c) => c.period == GoalPeriod.monthly);
      expect(monthly.targetBooks, 5);
      expect(monthly.targetSeconds, ((30 * 60 * 7) * 52 / 12).round());
      expect(monthly.targetSeconds, 54600);

      final yearly =
          repo.createGoalCalls.firstWhere((c) => c.period == GoalPeriod.yearly);
      expect(yearly.targetBooks, 52);
      expect(yearly.targetSeconds, 30 * 60 * 7 * 52);
      expect(yearly.targetSeconds, 655200);

      // load(force: true) follows the three creates and lands a GoalLoaded.
      expect(repo.currentGoalsCalls, greaterThan(0));
      expect(c.read(goalNotifierProvider), isA<GoalLoaded>());
    });
  });
}
