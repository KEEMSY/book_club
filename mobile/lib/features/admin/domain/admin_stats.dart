import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_stats.freezed.dart';

/// Aggregate usage statistics shown on the admin dashboard overview.
///
/// Mirrors the backend `StatsResponse` (`GET /admin/stats`).
@freezed
abstract class AdminStats with _$AdminStats {
  const factory AdminStats({
    required int mau,
    required int dau,
    required int newUsers7d,
    required int proUsers,
  }) = _AdminStats;
}
