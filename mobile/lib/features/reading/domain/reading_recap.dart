/// Half-year reading recap data for the recap card screen.
///
/// [half] is 1 (January–June) or 2 (July–December).
class ReadingRecap {
  const ReadingRecap({
    required this.year,
    required this.half,
    required this.totalBooks,
    required this.totalSeconds,
    required this.longestStreakDays,
    required this.topBooks,
  });

  final int year;
  final int half;
  final int totalBooks;
  final int totalSeconds;
  final int longestStreakDays;

  /// Up to 3 top books read during the period, ordered by reading time.
  final List<RecapBook> topBooks;

  /// Human-readable half label ("상반기" / "하반기").
  String get halfLabel => half == 1 ? '상반기' : '하반기';
}

/// Minimal book info bundled inside a [ReadingRecap].
class RecapBook {
  const RecapBook({
    required this.bookId,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.readSeconds,
  });

  final String bookId;
  final String title;
  final String author;
  final String? coverUrl;
  final int readSeconds;
}
