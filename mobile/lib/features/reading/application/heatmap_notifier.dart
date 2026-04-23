import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_repository.dart';
import '../domain/heatmap_day.dart';
import 'heatmap_state.dart';
import 'reading_providers.dart';

/// Manages the rolling 365-day jan-dee heatmap fetch.
///
/// Cache policy:
///   * Single fetch on `load()`; subsequent calls return the cached result
///     unless `force: true` is passed (pull-to-refresh) or a completed timer
///     session invalidates the window.
///   * Backend clamps the range to <= 366 days so we never ask for more than
///     a year at a time.
class HeatmapNotifier extends StateNotifier<HeatmapState> {
  HeatmapNotifier(this._repository) : super(const HeatmapState.initial());

  final ReadingRepository _repository;

  /// Loads the trailing 365-day window ending on `today`. Idempotent when a
  /// loaded state already covers an overlapping window unless [force] is set.
  Future<void> load({bool force = false}) async {
    final DateTime now = DateTime.now();
    final DateTime to = DateTime(now.year, now.month, now.day);
    final DateTime from = to.subtract(const Duration(days: 364));

    if (!force && state is HeatmapLoaded) {
      final loaded = state as HeatmapLoaded;
      if (loaded.to == to && loaded.from == from) {
        return;
      }
    }

    state = const HeatmapState.loading();
    try {
      final List<HeatmapDay> days =
          await _repository.getHeatmap(from: from, to: to);
      state = HeatmapState.loaded(days: days, from: from, to: to);
    } on ReadingRepositoryException catch (e) {
      state = HeatmapState.error(code: e.code, message: e.message);
    }
  }

  /// Called by the timer notifier's completion observer to force a refresh
  /// without touching the UI caller.
  Future<void> invalidate() => load(force: true);
}

final heatmapNotifierProvider =
    StateNotifierProvider<HeatmapNotifier, HeatmapState>((ref) {
  return HeatmapNotifier(ref.watch(readingRepositoryProvider));
});
