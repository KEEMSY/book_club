import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_metrics.freezed.dart';

/// One month of the MRR trend series.
@freezed
abstract class MonthlyMrrPoint with _$MonthlyMrrPoint {
  const factory MonthlyMrrPoint({
    required String month,
    required double mrr,
  }) = _MonthlyMrrPoint;
}

/// Recurring-revenue snapshot shown on the admin dashboard.
///
/// Mirrors the backend `RevenueMetricsResponse`
/// (`GET /admin/revenue-metrics`).
@freezed
abstract class RevenueMetrics with _$RevenueMetrics {
  const factory RevenueMetrics({
    required double mrr,
    required double arr,
    required int activeSubscribers,
    required int churned30d,
    required double teamMrr,
    required List<MonthlyMrrPoint> monthlyTrend,
  }) = _RevenueMetrics;
}
