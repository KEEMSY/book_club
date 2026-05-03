/// Represents a saved reading position for a user book.
class Bookmark {
  const Bookmark({
    required this.id,
    required this.userBookId,
    required this.page,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String userBookId;
  final int page;
  final String? note;
  final DateTime createdAt;

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['id'] as String,
        userBookId: json['user_book_id'] as String,
        page: json['page'] as int,
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
