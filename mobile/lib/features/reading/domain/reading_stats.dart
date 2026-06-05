/// Domain representation of the full reading analytics summary.
///
/// Mirrors `ReadingStatsResponse` from the backend M21 contract.
class ReadingStats {
  const ReadingStats({
    required this.avgMinutesPerPage,
    required this.avgPagesPerHour,
    required this.formatPaper,
    required this.formatEbook,
    required this.formatAudio,
    required this.monthlyHours,
    required this.genreBreakdown,
    required this.avgCompletionDays,
  });

  /// Average reading speed in minutes per page; null when no pages data.
  final double? avgMinutesPerPage;

  /// Derived speed in pages per hour; null when no data.
  final double? avgPagesPerHour;

  // Format counts — number of books read per medium.
  final int formatPaper;
  final int formatEbook;
  final int formatAudio;

  /// Last 6 months of reading hours, ordered oldest → newest.
  final List<MonthlyHours> monthlyHours;

  /// Top genres by completed book count.
  final List<GenreCount> genreBreakdown;

  /// Median days from start to completion across all completed books; null when
  /// fewer than 2 completed books exist.
  final double? avgCompletionDays;

  /// Total books across all formats.
  int get totalFormatBooks => formatPaper + formatEbook + formatAudio;
}

/// A single (month, hours) data point for the bar chart.
class MonthlyHours {
  const MonthlyHours({required this.month, required this.hours});

  /// Wire format "YYYY-MM".
  final String month;
  final double hours;
}

/// A single (genre, count) entry for the genre breakdown list.
class GenreCount {
  const GenreCount({required this.genre, required this.count});

  final String genre;
  final int count;
}
