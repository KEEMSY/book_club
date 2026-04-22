import 'package:freezed_annotation/freezed_annotation.dart';

import 'book.dart';
import 'book_status.dart';

part 'user_book.freezed.dart';

/// Domain-layer projection of `UserBookPublic`. Embeds a full [Book] so the
/// library list can render cover + title without an extra fetch.
@freezed
class UserBook with _$UserBook {
  const factory UserBook({
    required String id,
    required Book book,
    required BookStatus status,
    required DateTime startedAt,
    DateTime? finishedAt,
    int? rating,
    String? oneLineReview,
  }) = _UserBook;
}
