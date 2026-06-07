import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/goal_period.dart';
import '../domain/grade_summary.dart';
import '../domain/heatmap_day.dart';
import '../domain/monthly_recap.dart';
import '../domain/reading_goal.dart';
import '../domain/reading_recap.dart';
import '../domain/reading_session.dart';
import '../domain/reading_stats.dart';
import '../domain/reading_year_stats.dart';

part 'reading_models.freezed.dart';
part 'reading_models.g.dart';

/// Mirror of backend `ReadingSessionPublic`. Timer-completed sessions include
/// `ended_at` and `duration_sec`; in-flight sessions leave both null.
@freezed
abstract class ReadingSessionDto with _$ReadingSessionDto {
  const ReadingSessionDto._();

  const factory ReadingSessionDto({
    required String id,
    required String userBookId,
    required DateTime startedAt,
    required String source,
    DateTime? endedAt,
    int? durationSec,
  }) = _ReadingSessionDto;

  factory ReadingSessionDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingSessionDtoFromJson(json);

  ReadingSession toDomain() {
    return ReadingSession(
      id: id,
      userBookId: userBookId,
      startedAt: startedAt,
      source: ReadingSessionSource.fromWire(source),
      endedAt: endedAt,
      durationSec: durationSec,
    );
  }
}

/// Mirror of backend `NextGradeThresholdsPublic`.
@freezed
abstract class NextGradeThresholdsDto with _$NextGradeThresholdsDto {
  const NextGradeThresholdsDto._();

  const factory NextGradeThresholdsDto({
    required int targetBooks,
    required int targetSeconds,
  }) = _NextGradeThresholdsDto;

  factory NextGradeThresholdsDto.fromJson(Map<String, dynamic> json) =>
      _$NextGradeThresholdsDtoFromJson(json);

  NextGradeThresholds toDomain() {
    return NextGradeThresholds(
      targetBooks: targetBooks,
      targetSeconds: targetSeconds,
    );
  }
}

/// Mirror of backend `GradeSummaryPublic`.
///
/// [tier] defaults to 1 for API responses that predate the tier field.
@freezed
abstract class GradeSummaryDto with _$GradeSummaryDto {
  const GradeSummaryDto._();

  const factory GradeSummaryDto({
    required int grade,
    required int totalBooks,
    required int totalSeconds,
    required int streakDays,
    required int longestStreak,
    NextGradeThresholdsDto? nextGradeThresholds,
    @Default(1) int tier,
    @Default(0) int streakShields,
  }) = _GradeSummaryDto;

  factory GradeSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$GradeSummaryDtoFromJson(json);

  GradeSummary toDomain() {
    return GradeSummary(
      grade: grade,
      totalBooks: totalBooks,
      totalSeconds: totalSeconds,
      streakDays: streakDays,
      longestStreak: longestStreak,
      nextGradeThresholds: nextGradeThresholds?.toDomain(),
      tier: tier,
      streakShields: streakShields,
    );
  }
}

/// Mirror of `POST /reading/sessions/{id}/end` response.
@freezed
abstract class SessionCompletionDto with _$SessionCompletionDto {
  const SessionCompletionDto._();

  const factory SessionCompletionDto({
    required ReadingSessionDto session,
    required GradeSummaryDto grade,
    required int streakDays,
    required bool gradeUp,
  }) = _SessionCompletionDto;

  factory SessionCompletionDto.fromJson(Map<String, dynamic> json) =>
      _$SessionCompletionDtoFromJson(json);

  SessionCompletion toDomain() {
    return SessionCompletion(
      sessionId: session.id,
      userBookId: session.userBookId,
      startedAt: session.startedAt,
      endedAt: session.endedAt ?? DateTime.now().toUtc(),
      durationSec: session.durationSec ?? 0,
      grade: grade.grade,
      streakDays: streakDays,
      gradeUp: gradeUp,
    );
  }
}

/// Single day cell in the heatmap response. Date ships as `YYYY-MM-DD`.
@freezed
abstract class HeatmapItemDto with _$HeatmapItemDto {
  const HeatmapItemDto._();

  const factory HeatmapItemDto({
    required String date,
    required int totalSeconds,
    required int sessionCount,
  }) = _HeatmapItemDto;

  factory HeatmapItemDto.fromJson(Map<String, dynamic> json) =>
      _$HeatmapItemDtoFromJson(json);

  HeatmapDay toDomain() {
    final DateTime parsed = DateTime.parse(date);
    return HeatmapDay(
      date: DateTime(parsed.year, parsed.month, parsed.day),
      totalSeconds: totalSeconds,
      sessionCount: sessionCount,
    );
  }
}

/// Envelope for `GET /reading/heatmap`.
@freezed
abstract class HeatmapResponseDto with _$HeatmapResponseDto {
  const factory HeatmapResponseDto({
    required List<HeatmapItemDto> items,
  }) = _HeatmapResponseDto;

  factory HeatmapResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HeatmapResponseDtoFromJson(json);
}

/// Mirror of backend `GoalPublic`.
@freezed
abstract class GoalDto with _$GoalDto {
  const GoalDto._();

  const factory GoalDto({
    required String id,
    required String period,
    required int targetBooks,
    required int targetSeconds,
    required DateTime startDate,
    required DateTime endDate,
  }) = _GoalDto;

  factory GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);

  ReadingGoal toDomain() {
    return ReadingGoal(
      id: id,
      period: GoalPeriod.fromWire(period),
      targetBooks: targetBooks,
      targetSeconds: targetSeconds,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

/// Mirror of backend `GoalProgressPublic`.
@freezed
abstract class GoalProgressDto with _$GoalProgressDto {
  const GoalProgressDto._();

  const factory GoalProgressDto({
    required GoalDto goal,
    required int booksDone,
    required int secondsDone,
    required double percent,
  }) = _GoalProgressDto;

  factory GoalProgressDto.fromJson(Map<String, dynamic> json) =>
      _$GoalProgressDtoFromJson(json);

  GoalProgress toDomain() {
    return GoalProgress(
      goal: goal.toDomain(),
      booksDone: booksDone,
      secondsDone: secondsDone,
      percent: percent,
    );
  }
}

/// Mirror of a single session row in `GET /reading/sessions/daily` response.
@freezed
abstract class DailySessionDto with _$DailySessionDto {
  const factory DailySessionDto({
    required String sessionId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSec,
    required String source,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
    String? bookCoverUrl,
  }) = _DailySessionDto;

  factory DailySessionDto.fromJson(Map<String, dynamic> json) =>
      _$DailySessionDtoFromJson(json);
}

/// Envelope for `GET /reading/sessions/daily`.
@freezed
abstract class DailySessionsResponseDto with _$DailySessionsResponseDto {
  const factory DailySessionsResponseDto({
    required String date,
    required int totalSeconds,
    required List<DailySessionDto> sessions,
  }) = _DailySessionsResponseDto;

  factory DailySessionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DailySessionsResponseDtoFromJson(json);
}

// -- Request bodies --------------------------------------------------------

/// Body for `POST /reading/sessions/start`.
@freezed
abstract class StartSessionRequest with _$StartSessionRequest {
  const factory StartSessionRequest({
    required String userBookId,
    required String device,
  }) = _StartSessionRequest;

  factory StartSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$StartSessionRequestFromJson(json);
}

/// Body for `POST /reading/sessions/{id}/end`. [pausedMs] is the client's
/// locally-tracked paused-total and is not re-verified on the server.
@freezed
abstract class EndSessionRequest with _$EndSessionRequest {
  const factory EndSessionRequest({
    required DateTime endedAt,
    required int pausedMs,
  }) = _EndSessionRequest;

  factory EndSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$EndSessionRequestFromJson(json);
}

/// Body for `POST /reading/sessions/manual`. Backend enforces duration in
/// `[60, 14400]` seconds and note length `<=200`.
@freezed
abstract class ManualSessionRequest with _$ManualSessionRequest {
  const factory ManualSessionRequest({
    required String userBookId,
    required DateTime startedAt,
    required DateTime endedAt,
    String? note,
  }) = _ManualSessionRequest;

  factory ManualSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$ManualSessionRequestFromJson(json);
}

/// Body for `POST /reading/goals`.
@freezed
abstract class CreateGoalRequest with _$CreateGoalRequest {
  const factory CreateGoalRequest({
    required String period,
    required int targetBooks,
    required int targetSeconds,
  }) = _CreateGoalRequest;

  factory CreateGoalRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGoalRequestFromJson(json);
}

/// Mirror of `GET /reading/stats` response.
@freezed
abstract class ReadingYearStatsDto with _$ReadingYearStatsDto {
  const ReadingYearStatsDto._();

  const factory ReadingYearStatsDto({
    required int year,
    required int yearBooks,
    required int yearSeconds,
    String? yearBestDayDate,
    int? yearBestDaySeconds,
    required int totalBooks,
    required int totalSeconds,
    required int streakDays,
    required int longestStreak,
  }) = _ReadingYearStatsDto;

  factory ReadingYearStatsDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingYearStatsDtoFromJson(json);

  ReadingYearStats toDomain() {
    return ReadingYearStats(
      year: year,
      yearBooks: yearBooks,
      yearSeconds: yearSeconds,
      yearBestDayDate:
          yearBestDayDate != null ? DateTime.parse(yearBestDayDate!) : null,
      yearBestDaySeconds: yearBestDaySeconds,
      totalBooks: totalBooks,
      totalSeconds: totalSeconds,
      streakDays: streakDays,
      longestStreak: longestStreak,
    );
  }
}

/// Mirror of a single book entry in `GET /reading/recap` response.
@freezed
abstract class RecapBookDto with _$RecapBookDto {
  const RecapBookDto._();

  const factory RecapBookDto({
    required String bookId,
    required String title,
    required String author,
    String? coverUrl,
    required int readSeconds,
  }) = _RecapBookDto;

  factory RecapBookDto.fromJson(Map<String, dynamic> json) =>
      _$RecapBookDtoFromJson(json);

  RecapBook toDomain() {
    return RecapBook(
      bookId: bookId,
      title: title,
      author: author,
      coverUrl: coverUrl,
      readSeconds: readSeconds,
    );
  }
}

/// Mirror of `GET /reading/recap?year=&half=` response.
@freezed
abstract class ReadingRecapDto with _$ReadingRecapDto {
  const ReadingRecapDto._();

  const factory ReadingRecapDto({
    required int year,
    required int half,
    required int totalBooks,
    required int totalSeconds,
    required int longestStreakDays,
    @Default(<RecapBookDto>[]) List<RecapBookDto> topBooks,
  }) = _ReadingRecapDto;

  factory ReadingRecapDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingRecapDtoFromJson(json);

  ReadingRecap toDomain() {
    return ReadingRecap(
      year: year,
      half: half,
      totalBooks: totalBooks,
      totalSeconds: totalSeconds,
      longestStreakDays: longestStreakDays,
      topBooks: topBooks.map((b) => b.toDomain()).toList(growable: false),
    );
  }
}

// ---------------------------------------------------------------------------
// M21 Reading Stats DTOs
// ---------------------------------------------------------------------------

/// Mirror of `ReadingSpeedStatsPublic`.
@freezed
abstract class ReadingSpeedStatsDto with _$ReadingSpeedStatsDto {
  const factory ReadingSpeedStatsDto({
    double? avgMinutesPerPage,
    double? avgPagesPerHour,
  }) = _ReadingSpeedStatsDto;

  factory ReadingSpeedStatsDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingSpeedStatsDtoFromJson(json);
}

/// Mirror of `FormatBreakdownPublic`.
@freezed
abstract class FormatBreakdownDto with _$FormatBreakdownDto {
  const factory FormatBreakdownDto({
    required int paper,
    required int ebook,
    required int audio,
  }) = _FormatBreakdownDto;

  factory FormatBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$FormatBreakdownDtoFromJson(json);
}

/// Mirror of `MonthlyHoursPublic`.
@freezed
abstract class MonthlyHoursDto with _$MonthlyHoursDto {
  const factory MonthlyHoursDto({
    required String month,
    required double hours,
  }) = _MonthlyHoursDto;

  factory MonthlyHoursDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyHoursDtoFromJson(json);
}

/// Mirror of `GenreBreakdownPublic`.
@freezed
abstract class GenreBreakdownDto with _$GenreBreakdownDto {
  const factory GenreBreakdownDto({
    required String genre,
    required int count,
  }) = _GenreBreakdownDto;

  factory GenreBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$GenreBreakdownDtoFromJson(json);
}

/// Mirror of `ReadingStatsResponse` — envelope for `GET /me/reading-stats`.
@freezed
abstract class ReadingStatsDto with _$ReadingStatsDto {
  const ReadingStatsDto._();

  const factory ReadingStatsDto({
    required ReadingSpeedStatsDto speed,
    required FormatBreakdownDto formatBreakdown,
    required List<MonthlyHoursDto> monthlyHours,
    required List<GenreBreakdownDto> genreBreakdown,
    double? avgCompletionDays,
  }) = _ReadingStatsDto;

  factory ReadingStatsDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingStatsDtoFromJson(json);

  ReadingStats toDomain() {
    return ReadingStats(
      avgMinutesPerPage: speed.avgMinutesPerPage,
      avgPagesPerHour: speed.avgPagesPerHour,
      formatPaper: formatBreakdown.paper,
      formatEbook: formatBreakdown.ebook,
      formatAudio: formatBreakdown.audio,
      monthlyHours: monthlyHours
          .map((m) => MonthlyHours(month: m.month, hours: m.hours))
          .toList(growable: false),
      genreBreakdown: genreBreakdown
          .map((g) => GenreCount(genre: g.genre, count: g.count))
          .toList(growable: false),
      avgCompletionDays: avgCompletionDays,
    );
  }
}

// ---------------------------------------------------------------------------
// M28 Monthly Recap DTOs
// ---------------------------------------------------------------------------

/// Mirror of `GET /me/recap/monthly` response.
@freezed
abstract class MonthlyRecapDto with _$MonthlyRecapDto {
  const MonthlyRecapDto._();

  const factory MonthlyRecapDto({
    required int year,
    required int month,
    required int booksCompleted,
    required double totalHours,
    required double avgDailyMinutes,
    required int longestStreak,
    String? topGenre,
    double? prevMonthHours,
  }) = _MonthlyRecapDto;

  factory MonthlyRecapDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyRecapDtoFromJson(json);

  MonthlyRecap toDomain() {
    return MonthlyRecap(
      year: year,
      month: month,
      booksCompleted: booksCompleted,
      totalHours: totalHours,
      avgDailyMinutes: avgDailyMinutes,
      longestStreak: longestStreak,
      topGenre: topGenre,
      prevMonthHours: prevMonthHours,
    );
  }
}

/// Mirror of a single entry in `GET /me/recap/milestones` response.
@freezed
abstract class MilestoneItemDto with _$MilestoneItemDto {
  const MilestoneItemDto._();

  const factory MilestoneItemDto({
    required String type,
    required DateTime achievedAt,
    required double value,
  }) = _MilestoneItemDto;

  factory MilestoneItemDto.fromJson(Map<String, dynamic> json) =>
      _$MilestoneItemDtoFromJson(json);

  MilestoneItem toDomain() {
    return MilestoneItem(
      type: MilestoneType.fromWire(type),
      achievedAt: achievedAt,
      value: value,
    );
  }
}
