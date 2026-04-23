import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/heatmap_day.dart';

part 'heatmap_state.freezed.dart';

/// Sealed state for the heatmap (`JanDeeGrid`).
///
/// [initial] is surfaced until the first fetch lands; [loaded] carries both
/// the raw day list and a fast-lookup map keyed by `YYYY-MM-DD` local date
/// so the grid can render without O(n) scans per cell.
@freezed
sealed class HeatmapState with _$HeatmapState {
  const factory HeatmapState.initial() = HeatmapInitial;
  const factory HeatmapState.loading() = HeatmapLoading;
  const factory HeatmapState.loaded({
    required List<HeatmapDay> days,
    required DateTime from,
    required DateTime to,
  }) = HeatmapLoaded;
  const factory HeatmapState.error({
    required String code,
    required String message,
  }) = HeatmapError;
}
