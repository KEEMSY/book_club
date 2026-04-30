import 'highlight.dart';

/// Domain model for a user_book's highlights enriched with book metadata.
///
/// Mirrors ``BookHighlightGroup`` on the backend service layer.
class BookHighlightGroup {
  const BookHighlightGroup({
    required this.userBookId,
    required this.bookId,
    this.bookTitle,
    this.bookCoverUrl,
    required this.highlights,
  });

  final String userBookId;
  final String bookId;
  final String? bookTitle;
  final String? bookCoverUrl;
  final List<Highlight> highlights;
}
