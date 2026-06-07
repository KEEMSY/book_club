/// Aggregated stats for a single calendar month (M28 domain models).
class MonthlyRecap {
  const MonthlyRecap({
    required this.year,
    required this.month,
    required this.booksCompleted,
    required this.totalHours,
    required this.avgDailyMinutes,
    required this.longestStreak,
    this.topGenre,
    this.prevMonthHours,
  });

  final int year;
  final int month;
  final int booksCompleted;

  /// Total reading hours (fractional) for the month.
  final double totalHours;

  /// Average minutes of reading per calendar day.
  final double avgDailyMinutes;

  /// Longest consecutive-day reading streak within the month.
  final int longestStreak;

  /// Most-read genre for the month; null when genre data is unavailable.
  final String? topGenre;

  /// Total hours read in the immediately preceding month, for trend comparison.
  final double? prevMonthHours;

  /// Returns the Korean month label, e.g. "6월".
  String get monthLabel => '$month월';

  /// Returns a full label like "2026년 6월".
  String get fullLabel => '$year년 $month월';

  /// Positive when this month surpassed the previous month, negative otherwise.
  double? get hoursDelta {
    if (prevMonthHours == null) return null;
    return totalHours - prevMonthHours!;
  }
}

// ---------------------------------------------------------------------------
// Milestones
// ---------------------------------------------------------------------------

/// Enumeration of trackable reading milestones.
enum MilestoneType {
  books5,
  books10,
  books20,
  books50,
  hours10,
  hours50,
  hours100,
  streak7,
  streak30;

  /// Human-readable celebration label shown in [MilestoneToast].
  String get celebrationText {
    switch (this) {
      case MilestoneType.books5:
        return '책 5권 완독 달성!';
      case MilestoneType.books10:
        return '책 10권 완독 달성!';
      case MilestoneType.books20:
        return '책 20권 완독 달성!';
      case MilestoneType.books50:
        return '책 50권 완독 달성!';
      case MilestoneType.hours10:
        return '10시간 독서 달성!';
      case MilestoneType.hours50:
        return '50시간 독서 달성!';
      case MilestoneType.hours100:
        return '100시간 독서 달성!';
      case MilestoneType.streak7:
        return '7일 연속 독서 달성!';
      case MilestoneType.streak30:
        return '30일 연속 독서 달성!';
    }
  }

  /// Wire string used by the backend.
  String get wire {
    switch (this) {
      case MilestoneType.books5:
        return 'books_5';
      case MilestoneType.books10:
        return 'books_10';
      case MilestoneType.books20:
        return 'books_20';
      case MilestoneType.books50:
        return 'books_50';
      case MilestoneType.hours10:
        return 'hours_10';
      case MilestoneType.hours50:
        return 'hours_50';
      case MilestoneType.hours100:
        return 'hours_100';
      case MilestoneType.streak7:
        return 'streak_7';
      case MilestoneType.streak30:
        return 'streak_30';
    }
  }

  static MilestoneType fromWire(String raw) {
    return MilestoneType.values.firstWhere(
      (e) => e.wire == raw,
      orElse: () => MilestoneType.books5,
    );
  }
}

/// A single achieved milestone for the current user.
class MilestoneItem {
  const MilestoneItem({
    required this.type,
    required this.achievedAt,
    required this.value,
  });

  final MilestoneType type;

  /// UTC timestamp when the milestone was first triggered.
  final DateTime achievedAt;

  /// Numeric value that triggered the milestone (e.g. 100 for hours_100).
  final double value;
}
