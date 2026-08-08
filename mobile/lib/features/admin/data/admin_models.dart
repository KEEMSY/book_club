// @JsonKey on freezed factory params reports invalid_annotation_target; this
// is the documented freezed + json_serializable suppression.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/admin_stats.dart';
import '../domain/admin_user.dart';
import '../domain/conversion_funnel.dart';
import '../domain/revenue_metrics.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

/// Data-layer mirror of the backend `StatsResponse`.
@freezed
abstract class AdminStatsDto with _$AdminStatsDto {
  const AdminStatsDto._();

  const factory AdminStatsDto({
    required int mau,
    required int dau,
    // `field_rename: snake` (build.yaml) cannot recover the underscore in
    // front of a leading digit ("7d"), so this key is pinned explicitly to
    // match the backend's `new_users_7d`.
    @JsonKey(name: 'new_users_7d') required int newUsers7d,
    required int proUsers,
  }) = _AdminStatsDto;

  factory AdminStatsDto.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsDtoFromJson(json);

  AdminStats toDomain() => AdminStats(
        mau: mau,
        dau: dau,
        newUsers7d: newUsers7d,
        proUsers: proUsers,
      );
}

/// Data-layer mirror of the backend `ConversionFunnelResponse`.
@freezed
abstract class ConversionFunnelDto with _$ConversionFunnelDto {
  const ConversionFunnelDto._();

  const factory ConversionFunnelDto({
    required int paywallViews,
    required int paywallClicks,
    required int subscriptions,
    required double conversionRate,
  }) = _ConversionFunnelDto;

  factory ConversionFunnelDto.fromJson(Map<String, dynamic> json) =>
      _$ConversionFunnelDtoFromJson(json);

  ConversionFunnel toDomain() => ConversionFunnel(
        paywallViews: paywallViews,
        paywallClicks: paywallClicks,
        subscriptions: subscriptions,
        conversionRate: conversionRate,
      );
}

/// Data-layer mirror of one `MonthlyMrrPoint` entry.
@freezed
abstract class MonthlyMrrPointDto with _$MonthlyMrrPointDto {
  const MonthlyMrrPointDto._();

  const factory MonthlyMrrPointDto({
    required String month,
    required double mrr,
  }) = _MonthlyMrrPointDto;

  factory MonthlyMrrPointDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyMrrPointDtoFromJson(json);

  MonthlyMrrPoint toDomain() => MonthlyMrrPoint(month: month, mrr: mrr);
}

/// Data-layer mirror of the backend `RevenueMetricsResponse`.
@freezed
abstract class RevenueMetricsDto with _$RevenueMetricsDto {
  const RevenueMetricsDto._();

  const factory RevenueMetricsDto({
    required double mrr,
    required double arr,
    required int activeSubscribers,
    // Same digit-adjacency caveat as `newUsers7d` above — pin explicitly.
    @JsonKey(name: 'churned_30d') required int churned30d,
    required double teamMrr,
    required List<MonthlyMrrPointDto> monthlyTrend,
  }) = _RevenueMetricsDto;

  factory RevenueMetricsDto.fromJson(Map<String, dynamic> json) =>
      _$RevenueMetricsDtoFromJson(json);

  RevenueMetrics toDomain() => RevenueMetrics(
        mrr: mrr,
        arr: arr,
        activeSubscribers: activeSubscribers,
        churned30d: churned30d,
        teamMrr: teamMrr,
        monthlyTrend:
            monthlyTrend.map((dto) => dto.toDomain()).toList(growable: false),
      );
}

/// Data-layer mirror of the backend `UserAdminItem`.
@freezed
abstract class AdminUserDto with _$AdminUserDto {
  const AdminUserDto._();

  const factory AdminUserDto({
    required String id,
    required String nickname,
    String? email,
    required bool isActive,
    required bool isAdmin,
    required bool isPro,
    required DateTime createdAt,
  }) = _AdminUserDto;

  factory AdminUserDto.fromJson(Map<String, dynamic> json) =>
      _$AdminUserDtoFromJson(json);

  AdminUser toDomain() => AdminUser(
        id: id,
        nickname: nickname,
        email: email,
        isActive: isActive,
        isAdmin: isAdmin,
        isPro: isPro,
        createdAt: createdAt,
      );
}

/// Data-layer mirror of the backend `UserAdminPage`.
@freezed
abstract class AdminUserPageDto with _$AdminUserPageDto {
  const factory AdminUserPageDto({
    required List<AdminUserDto> items,
    required int total,
    required int page,
    required int pageSize,
  }) = _AdminUserPageDto;

  factory AdminUserPageDto.fromJson(Map<String, dynamic> json) =>
      _$AdminUserPageDtoFromJson(json);
}
