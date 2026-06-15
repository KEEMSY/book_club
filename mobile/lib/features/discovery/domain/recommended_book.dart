/// Domain model for a single ML-recommended book entry.
///
/// [reason] is a human-readable label returned by the backend (e.g.
/// "비슷한 독서 패턴의 사용자가 읽은 책").
/// [strategy] identifies which ML strategy produced this recommendation
/// ("collaborative" | "similar_readers" | "taste_match").
class RecommendedBook {
  const RecommendedBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.score,
    required this.reason,
    required this.strategy,
  });

  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final double score;
  final String reason;
  final String strategy;
}
