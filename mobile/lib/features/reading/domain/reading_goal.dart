import 'package:freezed_annotation/freezed_annotation.dart';

import 'goal_period.dart';

part 'reading_goal.freezed.dart';

/// Domain-layer projection of `GoalPublic`. Start/end dates are calendar
/// boundaries of the period (local) so the D-N countdown on the Goals screen
/// lines up with the user's clock rather than the server's.
@freezed
class ReadingGoal with _$ReadingGoal {
  const factory ReadingGoal({
    required String id,
    required GoalPeriod period,
    required int targetBooks,
    required int targetSeconds,
    required DateTime startDate,
    required DateTime endDate,
  }) = _ReadingGoal;
}

/// Progress snapshot against a [ReadingGoal]. [percent] is the backend's
/// averaged ratio in `[0, 1]` — we clamp on the UI side to keep the progress
/// bar from overshooting when the backend's rounding nudges above 1.0.
@freezed
class GoalProgress with _$GoalProgress {
  const factory GoalProgress({
    required ReadingGoal goal,
    required int booksDone,
    required int secondsDone,
    required double percent,
  }) = _GoalProgress;
}

/// Post-completion celebration payload surfaced by `POST /reading/sessions/{id}/end`.
@freezed
class SessionCompletion with _$SessionCompletion {
  const factory SessionCompletion({
    required String sessionId,
    required String userBookId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSec,
    required int grade,
    required int streakDays,
    required bool gradeUp,
  }) = _SessionCompletion;
}
