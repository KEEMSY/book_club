// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingSessionDto _$ReadingSessionDtoFromJson(Map<String, dynamic> json) =>
    _ReadingSessionDto(
      id: json['id'] as String,
      userBookId: json['user_book_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      source: json['source'] as String,
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      durationSec: (json['duration_sec'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReadingSessionDtoToJson(_ReadingSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_book_id': instance.userBookId,
      'started_at': instance.startedAt.toIso8601String(),
      'source': instance.source,
      'ended_at': instance.endedAt?.toIso8601String(),
      'duration_sec': instance.durationSec,
    };

_NextGradeThresholdsDto _$NextGradeThresholdsDtoFromJson(
        Map<String, dynamic> json) =>
    _NextGradeThresholdsDto(
      targetBooks: (json['target_books'] as num).toInt(),
      targetSeconds: (json['target_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$NextGradeThresholdsDtoToJson(
        _NextGradeThresholdsDto instance) =>
    <String, dynamic>{
      'target_books': instance.targetBooks,
      'target_seconds': instance.targetSeconds,
    };

_GradeSummaryDto _$GradeSummaryDtoFromJson(Map<String, dynamic> json) =>
    _GradeSummaryDto(
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

Map<String, dynamic> _$GradeSummaryDtoToJson(_GradeSummaryDto instance) =>
    <String, dynamic>{
      'grade': instance.grade,
      'total_books': instance.totalBooks,
      'total_seconds': instance.totalSeconds,
      'streak_days': instance.streakDays,
      'longest_streak': instance.longestStreak,
      'next_grade_thresholds': instance.nextGradeThresholds?.toJson(),
      'tier': instance.tier,
    };

_SessionCompletionDto _$SessionCompletionDtoFromJson(
        Map<String, dynamic> json) =>
    _SessionCompletionDto(
      session:
          ReadingSessionDto.fromJson(json['session'] as Map<String, dynamic>),
      grade: GradeSummaryDto.fromJson(json['grade'] as Map<String, dynamic>),
      streakDays: (json['streak_days'] as num).toInt(),
      gradeUp: json['grade_up'] as bool,
    );

Map<String, dynamic> _$SessionCompletionDtoToJson(
        _SessionCompletionDto instance) =>
    <String, dynamic>{
      'session': instance.session.toJson(),
      'grade': instance.grade.toJson(),
      'streak_days': instance.streakDays,
      'grade_up': instance.gradeUp,
    };

_HeatmapItemDto _$HeatmapItemDtoFromJson(Map<String, dynamic> json) =>
    _HeatmapItemDto(
      date: json['date'] as String,
      totalSeconds: (json['total_seconds'] as num).toInt(),
      sessionCount: (json['session_count'] as num).toInt(),
    );

Map<String, dynamic> _$HeatmapItemDtoToJson(_HeatmapItemDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total_seconds': instance.totalSeconds,
      'session_count': instance.sessionCount,
    };

_HeatmapResponseDto _$HeatmapResponseDtoFromJson(Map<String, dynamic> json) =>
    _HeatmapResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => HeatmapItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HeatmapResponseDtoToJson(_HeatmapResponseDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_GoalDto _$GoalDtoFromJson(Map<String, dynamic> json) => _GoalDto(
      id: json['id'] as String,
      period: json['period'] as String,
      targetBooks: (json['target_books'] as num).toInt(),
      targetSeconds: (json['target_seconds'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$GoalDtoToJson(_GoalDto instance) => <String, dynamic>{
      'id': instance.id,
      'period': instance.period,
      'target_books': instance.targetBooks,
      'target_seconds': instance.targetSeconds,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };

_GoalProgressDto _$GoalProgressDtoFromJson(Map<String, dynamic> json) =>
    _GoalProgressDto(
      goal: GoalDto.fromJson(json['goal'] as Map<String, dynamic>),
      booksDone: (json['books_done'] as num).toInt(),
      secondsDone: (json['seconds_done'] as num).toInt(),
      percent: (json['percent'] as num).toDouble(),
    );

Map<String, dynamic> _$GoalProgressDtoToJson(_GoalProgressDto instance) =>
    <String, dynamic>{
      'goal': instance.goal.toJson(),
      'books_done': instance.booksDone,
      'seconds_done': instance.secondsDone,
      'percent': instance.percent,
    };

_DailySessionDto _$DailySessionDtoFromJson(Map<String, dynamic> json) =>
    _DailySessionDto(
      sessionId: json['session_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      durationSec: (json['duration_sec'] as num).toInt(),
      source: json['source'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String,
      bookAuthor: json['book_author'] as String,
      bookCoverUrl: json['book_cover_url'] as String?,
    );

Map<String, dynamic> _$DailySessionDtoToJson(_DailySessionDto instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt.toIso8601String(),
      'duration_sec': instance.durationSec,
      'source': instance.source,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'book_author': instance.bookAuthor,
      'book_cover_url': instance.bookCoverUrl,
    };

_DailySessionsResponseDto _$DailySessionsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    _DailySessionsResponseDto(
      date: json['date'] as String,
      totalSeconds: (json['total_seconds'] as num).toInt(),
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) => DailySessionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailySessionsResponseDtoToJson(
        _DailySessionsResponseDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total_seconds': instance.totalSeconds,
      'sessions': instance.sessions.map((e) => e.toJson()).toList(),
    };

_StartSessionRequest _$StartSessionRequestFromJson(Map<String, dynamic> json) =>
    _StartSessionRequest(
      userBookId: json['user_book_id'] as String,
      device: json['device'] as String,
    );

Map<String, dynamic> _$StartSessionRequestToJson(
        _StartSessionRequest instance) =>
    <String, dynamic>{
      'user_book_id': instance.userBookId,
      'device': instance.device,
    };

_EndSessionRequest _$EndSessionRequestFromJson(Map<String, dynamic> json) =>
    _EndSessionRequest(
      endedAt: DateTime.parse(json['ended_at'] as String),
      pausedMs: (json['paused_ms'] as num).toInt(),
    );

Map<String, dynamic> _$EndSessionRequestToJson(_EndSessionRequest instance) =>
    <String, dynamic>{
      'ended_at': instance.endedAt.toIso8601String(),
      'paused_ms': instance.pausedMs,
    };

_ManualSessionRequest _$ManualSessionRequestFromJson(
        Map<String, dynamic> json) =>
    _ManualSessionRequest(
      userBookId: json['user_book_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ManualSessionRequestToJson(
        _ManualSessionRequest instance) =>
    <String, dynamic>{
      'user_book_id': instance.userBookId,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt.toIso8601String(),
      'note': instance.note,
    };

_CreateGoalRequest _$CreateGoalRequestFromJson(Map<String, dynamic> json) =>
    _CreateGoalRequest(
      period: json['period'] as String,
      targetBooks: (json['target_books'] as num).toInt(),
      targetSeconds: (json['target_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$CreateGoalRequestToJson(_CreateGoalRequest instance) =>
    <String, dynamic>{
      'period': instance.period,
      'target_books': instance.targetBooks,
      'target_seconds': instance.targetSeconds,
    };

_ReadingYearStatsDto _$ReadingYearStatsDtoFromJson(Map<String, dynamic> json) =>
    _ReadingYearStatsDto(
      year: (json['year'] as num).toInt(),
      yearBooks: (json['year_books'] as num).toInt(),
      yearSeconds: (json['year_seconds'] as num).toInt(),
      yearBestDayDate: json['year_best_day_date'] as String?,
      yearBestDaySeconds: (json['year_best_day_seconds'] as num?)?.toInt(),
      totalBooks: (json['total_books'] as num).toInt(),
      totalSeconds: (json['total_seconds'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
      longestStreak: (json['longest_streak'] as num).toInt(),
    );

Map<String, dynamic> _$ReadingYearStatsDtoToJson(
        _ReadingYearStatsDto instance) =>
    <String, dynamic>{
      'year': instance.year,
      'year_books': instance.yearBooks,
      'year_seconds': instance.yearSeconds,
      'year_best_day_date': instance.yearBestDayDate,
      'year_best_day_seconds': instance.yearBestDaySeconds,
      'total_books': instance.totalBooks,
      'total_seconds': instance.totalSeconds,
      'streak_days': instance.streakDays,
      'longest_streak': instance.longestStreak,
    };

_RecapBookDto _$RecapBookDtoFromJson(Map<String, dynamic> json) =>
    _RecapBookDto(
      bookId: json['book_id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      coverUrl: json['cover_url'] as String?,
      readSeconds: (json['read_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$RecapBookDtoToJson(_RecapBookDto instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'title': instance.title,
      'author': instance.author,
      'cover_url': instance.coverUrl,
      'read_seconds': instance.readSeconds,
    };

_ReadingRecapDto _$ReadingRecapDtoFromJson(Map<String, dynamic> json) =>
    _ReadingRecapDto(
      year: (json['year'] as num).toInt(),
      half: (json['half'] as num).toInt(),
      totalBooks: (json['total_books'] as num).toInt(),
      totalSeconds: (json['total_seconds'] as num).toInt(),
      longestStreakDays: (json['longest_streak_days'] as num).toInt(),
      topBooks: (json['top_books'] as List<dynamic>?)
              ?.map((e) => RecapBookDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RecapBookDto>[],
    );

Map<String, dynamic> _$ReadingRecapDtoToJson(_ReadingRecapDto instance) =>
    <String, dynamic>{
      'year': instance.year,
      'half': instance.half,
      'total_books': instance.totalBooks,
      'total_seconds': instance.totalSeconds,
      'longest_streak_days': instance.longestStreakDays,
      'top_books': instance.topBooks.map((e) => e.toJson()).toList(),
    };

_ReadingSpeedStatsDto _$ReadingSpeedStatsDtoFromJson(
        Map<String, dynamic> json) =>
    _ReadingSpeedStatsDto(
      avgMinutesPerPage: (json['avg_minutes_per_page'] as num?)?.toDouble(),
      avgPagesPerHour: (json['avg_pages_per_hour'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReadingSpeedStatsDtoToJson(
        _ReadingSpeedStatsDto instance) =>
    <String, dynamic>{
      'avg_minutes_per_page': instance.avgMinutesPerPage,
      'avg_pages_per_hour': instance.avgPagesPerHour,
    };

_FormatBreakdownDto _$FormatBreakdownDtoFromJson(Map<String, dynamic> json) =>
    _FormatBreakdownDto(
      paper: (json['paper'] as num).toInt(),
      ebook: (json['ebook'] as num).toInt(),
      audio: (json['audio'] as num).toInt(),
    );

Map<String, dynamic> _$FormatBreakdownDtoToJson(_FormatBreakdownDto instance) =>
    <String, dynamic>{
      'paper': instance.paper,
      'ebook': instance.ebook,
      'audio': instance.audio,
    };

_MonthlyHoursDto _$MonthlyHoursDtoFromJson(Map<String, dynamic> json) =>
    _MonthlyHoursDto(
      month: json['month'] as String,
      hours: (json['hours'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyHoursDtoToJson(_MonthlyHoursDto instance) =>
    <String, dynamic>{
      'month': instance.month,
      'hours': instance.hours,
    };

_GenreBreakdownDto _$GenreBreakdownDtoFromJson(Map<String, dynamic> json) =>
    _GenreBreakdownDto(
      genre: json['genre'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$GenreBreakdownDtoToJson(_GenreBreakdownDto instance) =>
    <String, dynamic>{
      'genre': instance.genre,
      'count': instance.count,
    };

_ReadingStatsDto _$ReadingStatsDtoFromJson(Map<String, dynamic> json) =>
    _ReadingStatsDto(
      speed:
          ReadingSpeedStatsDto.fromJson(json['speed'] as Map<String, dynamic>),
      formatBreakdown: FormatBreakdownDto.fromJson(
          json['format_breakdown'] as Map<String, dynamic>),
      monthlyHours: (json['monthly_hours'] as List<dynamic>)
          .map((e) => MonthlyHoursDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      genreBreakdown: (json['genre_breakdown'] as List<dynamic>)
          .map((e) => GenreBreakdownDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      avgCompletionDays: (json['avg_completion_days'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReadingStatsDtoToJson(_ReadingStatsDto instance) =>
    <String, dynamic>{
      'speed': instance.speed.toJson(),
      'format_breakdown': instance.formatBreakdown.toJson(),
      'monthly_hours': instance.monthlyHours.map((e) => e.toJson()).toList(),
      'genre_breakdown':
          instance.genreBreakdown.map((e) => e.toJson()).toList(),
      'avg_completion_days': instance.avgCompletionDays,
    };
