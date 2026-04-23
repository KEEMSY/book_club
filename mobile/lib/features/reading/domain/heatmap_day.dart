import 'package:freezed_annotation/freezed_annotation.dart';

part 'heatmap_day.freezed.dart';

/// One day-cell in the jan-dee heatmap. [date] is normalised to local
/// calendar day (backend ships ISO date; we parse in the DTO adapter).
@freezed
class HeatmapDay with _$HeatmapDay {
  const factory HeatmapDay({
    required DateTime date,
    required int totalSeconds,
    required int sessionCount,
  }) = _HeatmapDay;
}
