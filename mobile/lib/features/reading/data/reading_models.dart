import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/goal_period.dart';
import '../domain/grade_summary.dart';
import '../domain/heatmap_day.dart';
import '../domain/reading_goal.dart';
import '../domain/reading_session.dart';

part 'reading_models.freezed.dart';
part 'reading_models.g.dart';

/// Mirror of backend `ReadingSessionPublic`. Timer-completed sessions include
/// `ended_at` and `duration_sec`; in-flight sessions leave both null.
@freezed
class ReadingSessionDto with _$ReadingSessionDto {
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
class NextGradeThresholdsDto with _$NextGradeThresholdsDto {
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
@freezed
class GradeSummaryDto with _$GradeSummaryDto {
  const GradeSummaryDto._();

  const factory GradeSummaryDto({
    required int grade,
    required int totalBooks,
    required int totalSeconds,
    required int streakDays,
    required int longestStreak,
    NextGradeThresholdsDto? nextGradeThresholds,
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
    );
  }
}

/// Mirror of `POST /reading/sessions/{id}/end` response.
@freezed
class SessionCompletionDto with _$SessionCompletionDto {
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
class HeatmapItemDto with _$HeatmapItemDto {
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
class HeatmapResponseDto with _$HeatmapResponseDto {
  const factory HeatmapResponseDto({
    required List<HeatmapItemDto> items,
  }) = _HeatmapResponseDto;

  factory HeatmapResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HeatmapResponseDtoFromJson(json);
}

/// Mirror of backend `GoalPublic`.
@freezed
class GoalDto with _$GoalDto {
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
class GoalProgressDto with _$GoalProgressDto {
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

// -- Request bodies --------------------------------------------------------

/// Body for `POST /reading/sessions/start`.
@freezed
class StartSessionRequest with _$StartSessionRequest {
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
class EndSessionRequest with _$EndSessionRequest {
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
class ManualSessionRequest with _$ManualSessionRequest {
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
class CreateGoalRequest with _$CreateGoalRequest {
  const factory CreateGoalRequest({
    required String period,
    required int targetBooks,
    required int targetSeconds,
  }) = _CreateGoalRequest;

  factory CreateGoalRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGoalRequestFromJson(json);
}
