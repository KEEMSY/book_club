import 'package:freezed_annotation/freezed_annotation.dart';

part 'advanced_stats_models.freezed.dart';
part 'advanced_stats_models.g.dart';

/// One weekly reading-speed sample for the advanced stats trend chart.
///
/// Mirrors `GET /me/stats/advanced` → `speed_trend[]`. Field names rely on the
/// global `field_rename: snake` config (see build.yaml), so [weekStart] maps to
/// `week_start` and [minutesPerPage] to `minutes_per_page`.
@freezed
abstract class SpeedTrendItem with _$SpeedTrendItem {
  const factory SpeedTrendItem({
    required DateTime weekStart,
    required double minutesPerPage,
  }) = _SpeedTrendItem;

  factory SpeedTrendItem.fromJson(Map<String, dynamic> json) =>
      _$SpeedTrendItemFromJson(json);
}

/// One genre slice of the lifetime reading distribution.
///
/// Mirrors `GET /me/stats/advanced` → `genre_distribution[]`. [pct] is the
/// server-computed share (0–100) so the client never re-derives totals.
@freezed
abstract class GenreDistributionItem with _$GenreDistributionItem {
  const factory GenreDistributionItem({
    required String genre,
    required int count,
    required double pct,
  }) = _GenreDistributionItem;

  factory GenreDistributionItem.fromJson(Map<String, dynamic> json) =>
      _$GenreDistributionItemFromJson(json);
}

/// Envelope for `GET /me/stats/advanced` (Pro-only).
///
/// [yearlyComparison] keeps the raw `{current_year, prev_year}` map rather than
/// flattening to named fields, so the backend can add comparison buckets
/// without a client schema change.
@freezed
abstract class AdvancedStatsDto with _$AdvancedStatsDto {
  const factory AdvancedStatsDto({
    required List<SpeedTrendItem> speedTrend,
    required List<GenreDistributionItem> genreDistribution,
    required Map<String, int> yearlyComparison,
    required int longestStreakDays,
  }) = _AdvancedStatsDto;

  factory AdvancedStatsDto.fromJson(Map<String, dynamic> json) =>
      _$AdvancedStatsDtoFromJson(json);
}
