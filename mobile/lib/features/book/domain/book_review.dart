class BookReview {
  const BookReview({
    required this.userBookId,
    required this.rating,
    this.oneLineReview,
    required this.authorNickname,
    this.authorProfileImageUrl,
    required this.reviewedAt,
  });

  final String userBookId;
  final int rating;
  final String? oneLineReview;
  final String authorNickname;
  final String? authorProfileImageUrl;
  final DateTime reviewedAt;
}
