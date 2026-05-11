import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_repository.dart';
import '../domain/heatmap_day.dart';
import 'heatmap_state.dart';
import 'reading_providers.dart';

/// Manages the heatmap fetch for a specific [year].
///
/// Parameterised as a family provider so the dashboard can always watch
/// the current-year notifier for `todaySeconds`, while the `_HeatmapCard`
/// independently loads whichever year the user has navigated to. Each year's
/// data is cached for the lifetime of its listener.
///
/// Date range:
///   * Current year: Jan 1 → today (live window, re-fetched on invalidate).
///   * Past year:    Jan 1 → Dec 31 (static; re-fetched only when forced).
class HeatmapNotifier extends StateNotifier<HeatmapState> {
  HeatmapNotifier(this._repository, this._year)
      : super(const HeatmapState.initial());

  final ReadingRepository _repository;
  final int _year;

  Future<void> load({bool force = false}) async {
    final DateTime now = DateTime.now();
    final DateTime from;
    final DateTime to;

    if (_year == now.year) {
      // GitHub-style rolling window: trailing 365 days ending today.
      to = DateTime(now.year, now.month, now.day);
      from = to.subtract(const Duration(days: 364));
    } else {
      // Full calendar year for past years.
      from = DateTime(_year, 1, 1);
      to = DateTime(_year, 12, 31);
    }

    if (!force && state is HeatmapLoaded) {
      final HeatmapLoaded loaded = state as HeatmapLoaded;
      if (loaded.from == from && loaded.to == to) return;
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

  Future<void> invalidate() => load(force: true);
}

final heatmapNotifierProvider =
    StateNotifierProvider.family<HeatmapNotifier, HeatmapState, int>(
  (ref, year) => HeatmapNotifier(ref.watch(readingRepositoryProvider), year),
);
