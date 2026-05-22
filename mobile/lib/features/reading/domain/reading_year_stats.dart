class ReadingYearStats {
  const ReadingYearStats({
    required this.year,
    required this.yearBooks,
    required this.yearSeconds,
    this.yearBestDayDate,
    this.yearBestDaySeconds,
    required this.totalBooks,
    required this.totalSeconds,
    required this.streakDays,
    required this.longestStreak,
  });

  final int year;
  final int yearBooks;
  final int yearSeconds;
  final DateTime? yearBestDayDate;
  final int? yearBestDaySeconds;
  final int totalBooks;
  final int totalSeconds;
  final int streakDays;
  final int longestStreak;
}
