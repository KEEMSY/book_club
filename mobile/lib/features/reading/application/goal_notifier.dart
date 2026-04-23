import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_repository.dart';
import '../domain/goal_period.dart';
import '../domain/reading_goal.dart';
import 'goal_state.dart';
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
