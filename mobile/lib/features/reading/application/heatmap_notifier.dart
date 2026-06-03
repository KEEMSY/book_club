import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/reading_repository.dart';
import '../domain/heatmap_day.dart';
import 'heatmap_state.dart';
import 'reading_providers.dart';

part 'heatmap_notifier.g.dart';

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
@riverpod
class HeatmapNotifier extends _$HeatmapNotifier {
  @override
  HeatmapState build(int year) {
    return const HeatmapState.initial();
  }

  Future<void> load({bool force = false}) async {
    final DateTime now = DateTime.now();
    final DateTime from;
    final DateTime to;

    if (year == now.year) {
      // GitHub-style rolling window: trailing 365 days ending today.
      to = DateTime(now.year, now.month, now.day);
      from = to.subtract(const Duration(days: 364));
    } else {
      // Full calendar year for past years.
      from = DateTime(year, 1, 1);
      to = DateTime(year, 12, 31);
    }

    if (!force && state is HeatmapLoaded) {
      final HeatmapLoaded loaded = state as HeatmapLoaded;
      if (loaded.from == from && loaded.to == to) return;
    }

    state = const HeatmapState.loading();
    final repo = ref.read(readingRepositoryProvider);
    try {
      final List<HeatmapDay> days =
          await repo.getHeatmap(from: from, to: to);
      state = HeatmapState.loaded(days: days, from: from, to: to);
    } on ReadingRepositoryException catch (e) {
      state = HeatmapState.error(code: e.code, message: e.message);
    }
  }

  Future<void> invalidate() => load(force: true);
}
