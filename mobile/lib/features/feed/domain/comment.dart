import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_author.dart';

part 'comment.freezed.dart';

/// Domain-layer projection of `CommentPublic`.
///
/// Backend enforces 1-level nesting via the `parent_id` column — the server
/// returns 409 `COMMENT_DEPTH_EXCEEDED` if a client tries to reply to a
/// reply. The UI honours this by disabling the "답글" affordance on tiles
/// that already carry a [parentId].
@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required PostAuthor user,
    required String content,
    String? parentId,
    required DateTime createdAt,
  }) = _Comment;
}

/// Cursor-paginated page returned by `GET /posts/{id}/comments`. ASC order
/// (oldest first) so the sheet can append fresh pages naturally as the user
/// scrolls down.
@freezed
class CommentPage with _$CommentPage {
  const factory CommentPage({
    required List<Comment> items,
    String? nextCursor,
  }) = _CommentPage;
}
