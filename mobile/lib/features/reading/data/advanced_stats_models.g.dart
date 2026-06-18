// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_stats_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpeedTrendItem _$SpeedTrendItemFromJson(Map<String, dynamic> json) =>
    _SpeedTrendItem(
      weekStart: DateTime.parse(json['week_start'] as String),
      minutesPerPage: (json['minutes_per_page'] as num).toDouble(),
    );

Map<String, dynamic> _$SpeedTrendItemToJson(_SpeedTrendItem instance) =>
    <String, dynamic>{
      'week_start': instance.weekStart.toIso8601String(),
      'minutes_per_page': instance.minutesPerPage,
    };

_GenreDistributionItem _$GenreDistributionItemFromJson(
        Map<String, dynamic> json) =>
    _GenreDistributionItem(
      genre: json['genre'] as String,
      count: (json['count'] as num).toInt(),
      pct: (json['pct'] as num).toDouble(),
    );

Map<String, dynamic> _$GenreDistributionItemToJson(
        _GenreDistributionItem instance) =>
    <String, dynamic>{
      'genre': instance.genre,
      'count': instance.count,
      'pct': instance.pct,
    };

_AdvancedStatsDto _$AdvancedStatsDtoFromJson(Map<String, dynamic> json) =>
    _AdvancedStatsDto(
      speedTrend: (json['speed_trend'] as List<dynamic>)
          .map((e) => SpeedTrendItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      genreDistribution: (json['genre_distribution'] as List<dynamic>)
          .map((e) => GenreDistributionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      yearlyComparison: Map<String, int>.from(json['yearly_comparison'] as Map),
      longestStreakDays: (json['longest_streak_days'] as num).toInt(),
    );

Map<String, dynamic> _$AdvancedStatsDtoToJson(_AdvancedStatsDto instance) =>
    <String, dynamic>{
      'speed_trend': instance.speedTrend.map((e) => e.toJson()).toList(),
      'genre_distribution':
          instance.genreDistribution.map((e) => e.toJson()).toList(),
      'yearly_comparison': instance.yearlyComparison,
      'longest_streak_days': instance.longestStreakDays,
    };
