import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_author.dart';
import 'post_type.dart';
import 'reaction_type.dart';

part 'post.freezed.dart';

/// Domain-layer projection of `PostPublic`.
///
/// [reactions] is keyed by [ReactionType] so widgets can iterate enum values
/// in display order (avoids a stable-sort dance on every rebuild) and so the
/// reaction bar can short-circuit zero counts without parsing strings.
///
/// [myReactions] is the set of reactions the current user has applied. The
/// reaction bar uses `myReactions.contains(...)` to drive the active state.
@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String bookId,
    required PostAuthor user,
    required PostType postType,
    required String content,
    required List<String> imageUrls,
    required Map<ReactionType, int> reactions,
    required Set<ReactionType> myReactions,
    required int commentCount,
    required DateTime createdAt,
  }) = _Post;
}

/// Cursor-paginated page returned by `list_posts_by_book`. [nextCursor] is
/// `null` when the server has no more rows; the notifier stops requesting
/// further pages at that point.
@freezed
class PostPage with _$PostPage {
  const factory PostPage({
    required List<Post> items,
    String? nextCursor,
  }) = _PostPage;
}

/// Returned by `POST /posts/{id}/reactions`. The server is authoritative on
/// the resulting state — clients use [counts] to update the cached card
/// without a follow-up GET, and [state] tells us whether to add or remove the
/// reaction from `myReactions`.
@freezed
class ReactionToggleResult with _$ReactionToggleResult {
  const factory ReactionToggleResult({
    required ReactionToggleState state,
    required Map<ReactionType, int> counts,
  }) = _ReactionToggleResult;
}

enum ReactionToggleState {
  added,
  removed;

  static ReactionToggleState fromWire(String value) {
    switch (value) {
      case 'added':
        return ReactionToggleState.added;
      case 'removed':
        return ReactionToggleState.removed;
      default:
        return ReactionToggleState.added;
    }
  }
}
