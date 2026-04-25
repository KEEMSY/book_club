// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReadingSessionDtoImpl _$$ReadingSessionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReadingSessionDtoImpl(
      id: json['id'] as String,
      userBookId: json['user_book_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      source: json['source'] as String,
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      durationSec: (json['duration_sec'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ReadingSessionDtoImplToJson(
        _$ReadingSessionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_book_id': instance.userBookId,
      'started_at': instance.startedAt.toIso8601String(),
      'source': instance.source,
      'ended_at': instance.endedAt?.toIso8601String(),
      'duration_sec': instance.durationSec,
    };

_$NextGradeThresholdsDtoImpl _$$NextGradeThresholdsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$NextGradeThresholdsDtoImpl(
      targetBooks: (json['target_books'] as num).toInt(),
      targetSeconds: (json['target_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$$NextGradeThresholdsDtoImplToJson(
        _$NextGradeThresholdsDtoImpl instance) =>
    <String, dynamic>{
      'target_books': instance.targetBooks,
      'target_seconds': instance.targetSeconds,
    };

_$GradeSummaryDtoImpl _$$GradeSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$GradeSummaryDtoImpl(
      grade: (json['grade'] as num).toInt(),
      totalBooks: (json['total_books'] as num).toInt(),
      totalSeconds: (json['total_seconds'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
      longestStreak: (json['longest_streak'] as num).toInt(),
      nextGradeThresholds: json['next_grade_thresholds'] == null
          ? null
          : NextGradeThresholdsDto.fromJson(
              json['next_grade_thresholds'] as Map<String, dynamic>),
      tier: (json['tier'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$GradeSummaryDtoImplToJson(
        _$GradeSummaryDtoImpl instance) =>
    <String, dynamic>{
      'grade': instance.grade,
      'total_books': instance.totalBooks,
      'total_seconds': instance.totalSeconds,
      'streak_days': instance.streakDays,
      'longest_streak': instance.longestStreak,
      'next_grade_thresholds': instance.nextGradeThresholds?.toJson(),
      'tier': instance.tier,
    };

_$SessionCompletionDtoImpl _$$SessionCompletionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionCompletionDtoImpl(
      session:
          ReadingSessionDto.fromJson(json['session'] as Map<String, dynamic>),
      grade: GradeSummaryDto.fromJson(json['grade'] as Map<String, dynamic>),
      streakDays: (json['streak_days'] as num).toInt(),
      gradeUp: json['grade_up'] as bool,
    );

Map<String, dynamic> _$$SessionCompletionDtoImplToJson(
        _$SessionCompletionDtoImpl instance) =>
    <String, dynamic>{
      'session': instance.session.toJson(),
      'grade': instance.grade.toJson(),
      'streak_days': instance.streakDays,
      'grade_up': instance.gradeUp,
    };

_$HeatmapItemDtoImpl _$$HeatmapItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$HeatmapItemDtoImpl(
      date: json['date'] as String,
      totalSeconds: (json['total_seconds'] as num).toInt(),
      sessionCount: (json['session_count'] as num).toInt(),
    );

Map<String, dynamic> _$$HeatmapItemDtoImplToJson(
        _$HeatmapItemDtoImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total_seconds': instance.totalSeconds,
      'session_count': instance.sessionCount,
    };

_$HeatmapResponseDtoImpl _$$HeatmapResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HeatmapResponseDtoImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => HeatmapItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HeatmapResponseDtoImplToJson(
        _$HeatmapResponseDtoImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_$GoalDtoImpl _$$GoalDtoImplFromJson(Map<String, dynamic> json) =>
    _$GoalDtoImpl(
      id: json['id'] as String,
      period: json['period'] as String,
      targetBooks: (json['target_books'] as num).toInt(),
      targetSeconds: (json['target_seconds'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$$GoalDtoImplToJson(_$GoalDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'period': instance.period,
      'target_books': instance.targetBooks,
      'target_seconds': instance.targetSeconds,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };

_$GoalProgressDtoImpl _$$GoalProgressDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$GoalProgressDtoImpl(
      goal: GoalDto.fromJson(json['goal'] as Map<String, dynamic>),
      booksDone: (json['books_done'] as num).toInt(),
      secondsDone: (json['seconds_done'] as num).toInt(),
      percent: (json['percent'] as num).toDouble(),
    );

Map<String, dynamic> _$$GoalProgressDtoImplToJson(
        _$GoalProgressDtoImpl instance) =>
    <String, dynamic>{
      'goal': instance.goal.toJson(),
      'books_done': instance.booksDone,
      'seconds_done': instance.secondsDone,
      'percent': instance.percent,
    };

_$StartSessionRequestImpl _$$StartSessionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$StartSessionRequestImpl(
      userBookId: json['user_book_id'] as String,
      device: json['device'] as String,
    );

Map<String, dynamic> _$$StartSessionRequestImplToJson(
        _$StartSessionRequestImpl instance) =>
    <String, dynamic>{
      'user_book_id': instance.userBookId,
      'device': instance.device,
    };

_$EndSessionRequestImpl _$$EndSessionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$EndSessionRequestImpl(
      endedAt: DateTime.parse(json['ended_at'] as String),
      pausedMs: (json['paused_ms'] as num).toInt(),
    );

Map<String, dynamic> _$$EndSessionRequestImplToJson(
        _$EndSessionRequestImpl instance) =>
    <String, dynamic>{
      'ended_at': instance.endedAt.toIso8601String(),
      'paused_ms': instance.pausedMs,
    };

_$ManualSessionRequestImpl _$$ManualSessionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ManualSessionRequestImpl(
      userBookId: json['user_book_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$ManualSessionRequestImplToJson(
        _$ManualSessionRequestImpl instance) =>
    <String, dynamic>{
      'user_book_id': instance.userBookId,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt.toIso8601String(),
      'note': instance.note,
    };

_$CreateGoalRequestImpl _$$CreateGoalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateGoalRequestImpl(
      period: json['period'] as String,
      targetBooks: (json['target_books'] as num).toInt(),
      targetSeconds: (json['target_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$$CreateGoalRequestImplToJson(
        _$CreateGoalRequestImpl instance) =>
    <String, dynamic>{
      'period': instance.period,
      'target_books': instance.targetBooks,
      'target_seconds': instance.targetSeconds,
    };
