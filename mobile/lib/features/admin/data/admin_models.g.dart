// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminStatsDto _$AdminStatsDtoFromJson(Map<String, dynamic> json) =>
    _AdminStatsDto(
      mau: (json['mau'] as num).toInt(),
      dau: (json['dau'] as num).toInt(),
      newUsers7d: (json['new_users_7d'] as num).toInt(),
      proUsers: (json['pro_users'] as num).toInt(),
    );

Map<String, dynamic> _$AdminStatsDtoToJson(_AdminStatsDto instance) =>
    <String, dynamic>{
      'mau': instance.mau,
      'dau': instance.dau,
      'new_users_7d': instance.newUsers7d,
      'pro_users': instance.proUsers,
    };

_ConversionFunnelDto _$ConversionFunnelDtoFromJson(Map<String, dynamic> json) =>
    _ConversionFunnelDto(
      paywallViews: (json['paywall_views'] as num).toInt(),
      paywallClicks: (json['paywall_clicks'] as num).toInt(),
      subscriptions: (json['subscriptions'] as num).toInt(),
      conversionRate: (json['conversion_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$ConversionFunnelDtoToJson(
        _ConversionFunnelDto instance) =>
    <String, dynamic>{
      'paywall_views': instance.paywallViews,
      'paywall_clicks': instance.paywallClicks,
      'subscriptions': instance.subscriptions,
      'conversion_rate': instance.conversionRate,
    };

_MonthlyMrrPointDto _$MonthlyMrrPointDtoFromJson(Map<String, dynamic> json) =>
    _MonthlyMrrPointDto(
      month: json['month'] as String,
      mrr: (json['mrr'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyMrrPointDtoToJson(_MonthlyMrrPointDto instance) =>
    <String, dynamic>{
      'month': instance.month,
      'mrr': instance.mrr,
    };

_RevenueMetricsDto _$RevenueMetricsDtoFromJson(Map<String, dynamic> json) =>
    _RevenueMetricsDto(
      mrr: (json['mrr'] as num).toDouble(),
      arr: (json['arr'] as num).toDouble(),
      activeSubscribers: (json['active_subscribers'] as num).toInt(),
      churned30d: (json['churned_30d'] as num).toInt(),
      teamMrr: (json['team_mrr'] as num).toDouble(),
      monthlyTrend: (json['monthly_trend'] as List<dynamic>)
          .map((e) => MonthlyMrrPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RevenueMetricsDtoToJson(_RevenueMetricsDto instance) =>
    <String, dynamic>{
      'mrr': instance.mrr,
      'arr': instance.arr,
      'active_subscribers': instance.activeSubscribers,
      'churned_30d': instance.churned30d,
      'team_mrr': instance.teamMrr,
      'monthly_trend': instance.monthlyTrend.map((e) => e.toJson()).toList(),
    };

_AdminUserDto _$AdminUserDtoFromJson(Map<String, dynamic> json) =>
    _AdminUserDto(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String?,
      isActive: json['is_active'] as bool,
      isAdmin: json['is_admin'] as bool,
      isPro: json['is_pro'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AdminUserDtoToJson(_AdminUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'email': instance.email,
      'is_active': instance.isActive,
      'is_admin': instance.isAdmin,
      'is_pro': instance.isPro,
      'created_at': instance.createdAt.toIso8601String(),
    };

_AdminUserPageDto _$AdminUserPageDtoFromJson(Map<String, dynamic> json) =>
    _AdminUserPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => AdminUserDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
    );

Map<String, dynamic> _$AdminUserPageDtoToJson(_AdminUserPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
    };
