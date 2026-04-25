import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_repository.dart';
import '../domain/goal_period.dart';
import '../domain/reading_goal.dart';
import 'goal_state.dart';
import 'reading_journey_inputs.dart';
import 'reading_providers.dart';

/// Tracks the active goals (weekly · monthly · yearly). Backend returns one
/// active goal per period via `GET /reading/goals/current`; we refresh after
/// every `createGoal()` so the UI reflects the newly-created entry.
class GoalNotifier extends StateNotifier<GoalState> {
  GoalNotifier(this._repository) : super(const GoalState.initial());

  final ReadingRepository _repository;

  Future<void> load({bool force = false}) async {
    if (!force && state is GoalLoaded) {
      return;
    }
    state = const GoalState.loading();
    await _refresh();
  }

  Future<void> refresh() => _refresh();

  /// Returns the created goal (for caller-side haptic feedback) after the
  /// subsequent list refresh completes. Surfaces `ReadingRepositoryException`
  /// to the caller so the create modal can show inline validation.
  Future<ReadingGoal> createGoal({
    required GoalPeriod period,
    required int targetBooks,
    required int targetSeconds,
  }) async {
    final goal = await _repository.createGoal(
      period: period,
      targetBooks: targetBooks,
      targetSeconds: targetSeconds,
    );
    await _refresh();
    return goal;
  }

  /// One-shot "독서 여정" setup: from the user's three high-level inputs we
  /// derive yearly / monthly / weekly targets so the three periods read as
  /// nested resolutions of the same journey rather than three independent
  /// goals. All three POSTs fire in parallel; a single `_refresh()` lands
  /// the GoalLoaded state with the new entries.
  Future<void> createJourney({
    required int yearlyBooks, // 5..365
    required int dailyMinutes, // 15..240
    required int weeklyDays, // 3..7
  }) async {
    final ReadingJourneyTargets targets = ReadingJourneyTargets.derive(
      yearlyBooks: yearlyBooks,
      dailyMinutes: dailyMinutes,
      weeklyDays: weeklyDays,
    );

    await Future.wait<ReadingGoal>(<Future<ReadingGoal>>[
      _repository.createGoal(
        period: GoalPeriod.weekly,
        targetBooks: targets.weeklyBooks,
        targetSeconds: targets.weeklySeconds,
      ),
      _repository.createGoal(
        period: GoalPeriod.monthly,
        targetBooks: targets.monthlyBooks,
        targetSeconds: targets.monthlySeconds,
      ),
      _repository.createGoal(
        period: GoalPeriod.yearly,
        targetBooks: targets.yearlyBooks,
        targetSeconds: targets.yearlySeconds,
      ),
    ]);

    await load(force: true);
  }

  GoalProgress? progressFor(GoalPeriod period) {
    final current = state;
    if (current is! GoalLoaded) return null;
    for (final GoalProgress p in current.items) {
      if (p.goal.period == period) return p;
    }
    return null;
  }

  Future<void> _refresh() async {
    try {
      final items = await _repository.getCurrentGoals();
      state = GoalState.loaded(items: items);
    } on ReadingRepositoryException catch (e) {
      state = GoalState.error(code: e.code, message: e.message);
    }
  }
}

final goalNotifierProvider = StateNotifierProvider<GoalNotifier, GoalState>(
  (ref) => GoalNotifier(ref.watch(readingRepositoryProvider)),
);
