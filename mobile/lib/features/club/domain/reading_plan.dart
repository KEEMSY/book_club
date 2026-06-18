import '../data/reading_plan_models.dart';

/// A club's shared reading plan (M52).
///
/// [weeklyPages] is the target pace the backend derives from the book's page
/// count and the plan's duration; the UI surfaces it as the weekly goal.
class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.clubId,
    required this.bookId,
    required this.startDate,
    required this.endDate,
    required this.weeklyPages,
    required this.createdAt,
  });

  final String id;
  final String clubId;
  final String bookId;
  final DateTime startDate;
  final DateTime endDate;
  final int weeklyPages;
  final DateTime createdAt;

  factory ReadingPlan.fromDto(ReadingPlanDto dto) => ReadingPlan(
        id: dto.id,
        clubId: dto.clubId,
        bookId: dto.bookId,
        startDate: dto.startDate,
        endDate: dto.endDate,
        weeklyPages: dto.weeklyPages,
        createdAt: dto.createdAt,
      );
}

/// One member's reading progress within a club plan.
///
/// [progressPct] is a 0–100 percentage resolved server-side against the plan's
/// total pages.
class MemberProgress {
  const MemberProgress({
    required this.userId,
    required this.nickname,
    required this.currentPage,
    required this.progressPct,
    this.lastPageUpdatedAt,
  });

  final String userId;
  final String nickname;
  final int currentPage;
  final double progressPct;
  final DateTime? lastPageUpdatedAt;

  factory MemberProgress.fromDto(MemberProgressDto dto) => MemberProgress(
        userId: dto.userId,
        nickname: dto.nickname,
        currentPage: dto.currentPage,
        progressPct: dto.progressPct,
        lastPageUpdatedAt: dto.lastPageUpdatedAt,
      );
}

/// Aggregate progress for a club: the plan (if any) plus every member's pace.
class ClubProgress {
  const ClubProgress({
    this.plan,
    this.members = const [],
  });

  final ReadingPlan? plan;
  final List<MemberProgress> members;

  factory ClubProgress.fromDto(ClubProgressDto dto) => ClubProgress(
        plan: dto.plan == null ? null : ReadingPlan.fromDto(dto.plan!),
        members: dto.members.map(MemberProgress.fromDto).toList(),
      );
}
