class RecommendedBook {
  const RecommendedBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.reason,
  });

  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final String
      reason; // "community_popular" | "similar_readers" | "recently_added"

  factory RecommendedBook.fromJson(Map<String, dynamic> json) =>
      RecommendedBook(
        id: json['id'] as String,
        title: json['title'] as String,
        author: json['author'] as String,
        coverUrl: json['cover_url'] as String?,
        reason: json['reason'] as String,
      );
}
