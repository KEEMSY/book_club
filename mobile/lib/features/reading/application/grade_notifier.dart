import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/reading_repository.dart';
import '../domain/grade_summary.dart';
import '../domain/reading_goal.dart';
import 'grade_state.dart';
import 'reading_providers.dart';

part 'grade_notifier.g.dart';

/// Holds the current `GradeSummary` plus a `recentGradeUp` flag the
/// dashboard toasts the user about once on the next `/home` render.
@Riverpod(keepAlive: true)
class GradeNotifier extends _$GradeNotifier {
  @override
  GradeState build() {
    return const GradeState.initial();
  }

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
      // Preserve shields from the pre-session snapshot; the background
      // _refresh() will reconcile the authoritative count from the server.
      streakShields: previous?.streakShields ?? 0,
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
    final repo = ref.read(readingRepositoryProvider);
    try {
      final summary = await repo.getGrade();
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
