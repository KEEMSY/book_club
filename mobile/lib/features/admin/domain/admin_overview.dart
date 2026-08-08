import 'package:freezed_annotation/freezed_annotation.dart';

import 'admin_stats.dart';
import 'conversion_funnel.dart';
import 'revenue_metrics.dart';

part 'admin_overview.freezed.dart';

/// Combined dashboard payload — the three admin metrics endpoints fetched
/// together so the console shows a single loading/error state for the
/// stats section instead of three independent spinners.
@freezed
abstract class AdminOverview with _$AdminOverview {
  const factory AdminOverview({
    required AdminStats stats,
    required ConversionFunnel funnel,
    required RevenueMetrics revenue,
  }) = _AdminOverview;
}
