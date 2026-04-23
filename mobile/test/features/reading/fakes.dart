import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:book_club/features/reading/domain/goal_period.dart';
import 'package:book_club/features/reading/domain/grade_summary.dart';
import 'package:book_club/features/reading/domain/heatmap_day.dart';
import 'package:book_club/features/reading/domain/reading_goal.dart';
import 'package:book_club/features/reading/domain/reading_session.dart';

/// Fake [ReadingRepository] that lets reading-feature tests queue
/// deterministic responses per endpoint.
class FakeReadingRepository implements ReadingRepository {
  FakeReadingRepository();

  // -- start --
  ReadingSession? startResult;
  Object? startError;
  final List<({String userBookId, String device})> startCalls =
      <({String userBookId, String device})>[];

  // -- end --
  SessionCompletion? endResult;
  Object? endError;
  final List<({String sessionId, DateTime endedAt, int pausedMs})> endCalls =
      <({String sessionId, DateTime endedAt, int pausedMs})>[];

  // -- manual --
  ReadingSession? manualResult;
  Object? manualError;
  final List<
      ({
        String userBookId,
        DateTime startedAt,
        DateTime endedAt,
        String? note
      })> manualCalls = <({
    String userBookId,
    DateTime startedAt,
    DateTime endedAt,
    String? note
  })>[];

  // -- heatmap --
  List<HeatmapDay> heatmapQueue = <HeatmapDay>[];
  Object? heatmapError;
  final List<({DateTime from, DateTime to})> heatmapCalls =
      <({DateTime from, DateTime to})>[];

  // -- grade --
  GradeSummary? gradeResult;
  Object? gradeError;
  int gradeCalls = 0;

  // -- goals --
  List<GoalProgress> goalsResult = <GoalProgress>[];
  ReadingGoal? createGoalResult;
  Object? goalError;
  final List<({GoalPeriod period, int targetBooks, int targetSeconds})>
      createGoalCalls =
      <({GoalPeriod period, int targetBooks, int targetSeconds})>[];
  int currentGoalsCalls = 0;

  @override
  Future<ReadingSession> startSession({
    required String userBookId,
    required String device,
  }) async {
    startCalls.add((userBookId: userBookId, device: device));
    if (startError != null) throw startError!;
    return startResult!;
  }

  @override
  Future<SessionCompletion> endSession({
    required String sessionId,
    required DateTime endedAt,
    required int pausedMs,
  }) async {
    endCalls.add((sessionId: sessionId, endedAt: endedAt, pausedMs: pausedMs));
    if (endError != null) throw endError!;
    return endResult!;
  }

  @override
  Future<ReadingSession> logManualSession({
    required String userBookId,
    required DateTime startedAt,
    required DateTime endedAt,
    String? note,
  }) async {
    manualCalls.add(
      (
        userBookId: userBookId,
        startedAt: startedAt,
        endedAt: endedAt,
        note: note
      ),
    );
    if (manualError != null) throw manualError!;
    return manualResult!;
  }

  @override
  Future<List<HeatmapDay>> getHeatmap({
    required DateTime from,
    required DateTime to,
  }) async {
    heatmapCalls.add((from: from, to: to));
    if (heatmapError != null) throw heatmapError!;
    return heatmapQueue;
  }

  @override
  Future<GradeSummary> getGrade() async {
    gradeCalls++;
    if (gradeError != null) throw gradeError!;
    return gradeResult!;
  }

  @override
  Future<ReadingGoal> createGoal({
    required GoalPeriod period,
    required int targetBooks,
    required int targetSeconds,
  }) async {
    createGoalCalls.add(
      (period: period, targetBooks: targetBooks, targetSeconds: targetSeconds),
    );
    if (goalError != null) throw goalError!;
    return createGoalResult!;
  }

  @override
  Future<List<GoalProgress>> getCurrentGoals() async {
    currentGoalsCalls++;
    if (goalError != null) throw goalError!;
    return goalsResult;
  }
}

// -- Builders --------------------------------------------------------------

ReadingSession buildSession({
  String id = 'session-1',
  String userBookId = 'user-book-1',
  DateTime? startedAt,
  ReadingSessionSource source = ReadingSessionSource.timer,
  DateTime? endedAt,
  int? durationSec,
}) {
  return ReadingSession(
    id: id,
    userBookId: userBookId,
    startedAt: startedAt ?? DateTime.utc(2026, 4, 20, 12),
    source: source,
    endedAt: endedAt,
    durationSec: durationSec,
  );
}

GradeSummary buildGradeSummary({
  int grade = 1,
  int totalBooks = 0,
  int totalSeconds = 0,
  int streakDays = 0,
  int longestStreak = 0,
  NextGradeThresholds? next,
}) {
  return GradeSummary(
    grade: grade,
    totalBooks: totalBooks,
    totalSeconds: totalSeconds,
    streakDays: streakDays,
    longestStreak: longestStreak,
    nextGradeThresholds:
        next ?? const NextGradeThresholds(targetBooks: 3, targetSeconds: 36000),
  );
}

SessionCompletion buildCompletion({
  String sessionId = 'session-1',
  String userBookId = 'user-book-1',
  DateTime? startedAt,
  DateTime? endedAt,
  int durationSec = 600,
  int grade = 1,
  int streakDays = 1,
  bool gradeUp = false,
}) {
  final DateTime started = startedAt ?? DateTime.utc(2026, 4, 20, 12);
  return SessionCompletion(
    sessionId: sessionId,
    userBookId: userBookId,
    startedAt: started,
    endedAt: endedAt ?? started.add(Duration(seconds: durationSec)),
    durationSec: durationSec,
    grade: grade,
    streakDays: streakDays,
    gradeUp: gradeUp,
  );
}

HeatmapDay buildHeatmapDay({
  DateTime? date,
  int totalSeconds = 0,
  int sessionCount = 0,
}) {
  return HeatmapDay(
    date: date ?? DateTime(2026, 4, 20),
    totalSeconds: totalSeconds,
    sessionCount: sessionCount,
  );
}

ReadingGoal buildGoal({
  String id = 'goal-1',
  GoalPeriod period = GoalPeriod.weekly,
  int targetBooks = 2,
  int targetSeconds = 7200,
  DateTime? startDate,
  DateTime? endDate,
}) {
  return ReadingGoal(
    id: id,
    period: period,
    targetBooks: targetBooks,
    targetSeconds: targetSeconds,
    startDate: startDate ?? DateTime(2026, 4, 20),
    endDate: endDate ?? DateTime(2026, 4, 27),
  );
}

GoalProgress buildGoalProgress({
  ReadingGoal? goal,
  int booksDone = 1,
  int secondsDone = 3600,
  double percent = 0.5,
}) {
  return GoalProgress(
    goal: goal ?? buildGoal(),
    booksDone: booksDone,
    secondsDone: secondsDone,
    percent: percent,
  );
}
