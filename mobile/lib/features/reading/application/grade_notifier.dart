import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_repository.dart';
import '../domain/grade_summary.dart';
import '../domain/reading_goal.dart';
import 'grade_state.dart';
import 'reading_providers.dart';

/// Holds the current `GradeSummary` plus a `recentGradeUp` flag the
/// dashboard toasts the user about once on the next `/home` render.
class GradeNotifier extends StateNotifier<GradeState> {
  GradeNotifier(this._repository) : super(const GradeState.initial());

  final ReadingRepository _repository;

  Future<void> load({bool force = false}) async {
    if (!force && state is GradeLoaded) {
      return;
    }
    state = const GradeState.loading();
    await _refresh();
  }

  Future<void> refresh() => _refresh();

  /// Called by the timer notifier after a `Completed` state lands — folds
  /// the new grade summary in and lights `recentGradeUp` when the session
  /// triggered a tier transition.
  void applySessionCompletion(SessionCompletion completion) {
    final GradeSummary? previous = switch (state) {
      GradeLoaded(:final summary) => summary,
      _ => null,
    };
    final GradeSummary next = GradeSummary(
      grade: completion.grade,
      totalBooks: previous?.totalBooks ?? 0,
      totalSeconds: (previous?.totalSeconds ?? 0) + completion.durationSec,
      streakDays: completion.streakDays,
      longestStreak: (previous?.longestStreak ?? 0) < completion.streakDays
          ? completion.streakDays
          : previous?.longestStreak ?? completion.streakDays,
      nextGradeThresholds: previous?.nextGradeThresholds,
    );
    state = GradeState.loaded(summary: next, recentGradeUp: completion.gradeUp);
    // Kick a background refresh to reconcile totals with server truth.
    // ignore: discarded_futures
    _refresh();
  }

  void acknowledgeGradeUp() {
    final current = state;
    if (current is GradeLoaded && current.recentGradeUp) {
      state = GradeState.loaded(summary: current.summary);
    }
  }

  Future<void> _refresh() async {
    try {
      final summary = await _repository.getGrade();
      state = GradeState.loaded(
        summary: summary,
        recentGradeUp: switch (state) {
          GradeLoaded(:final recentGradeUp) => recentGradeUp,
          _ => false,
        },
      );
    } on ReadingRepositoryException catch (e) {
      state = GradeState.error(code: e.code, message: e.message);
    }
  }
}

final gradeNotifierProvider =
    StateNotifierProvider<GradeNotifier, GradeState>((ref) {
  return GradeNotifier(ref.watch(readingRepositoryProvider));
});
