import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/feed_repository.dart';
import '../domain/comment.dart';
import 'comment_thread_state.dart';
import 'feed_providers.dart';

/// Drives the comments sheet — paginated comment list (ASC) plus an inline
/// composer state machine.
///
/// 1-level nesting: replies are siblings of root comments in the wire
/// payload (each carries its own `parent_id`). The UI groups them by parent
/// at render time; the backend rejects depth-2+ writes with 409
/// `COMMENT_DEPTH_EXCEEDED`. This notifier surfaces that code through
/// [CommentThreadLoaded.postError] so the composer can render an inline hint.
class CommentThreadNotifier extends StateNotifier<CommentThreadState> {
  CommentThreadNotifier(this._repository, this.postId)
      : super(const CommentThreadState.initial());

  final FeedRepository _repository;
  final String postId;
  int _requestSeq = 0;

  Future<void> load() async {
    state = const CommentThreadState.loading();
    final int seq = ++_requestSeq;
    try {
      final CommentPage page = await _repository.listComments(postId: postId);
      if (seq != _requestSeq) return;
      state = CommentThreadState.loaded(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } on FeedRepositoryException catch (e) {
      if (seq != _requestSeq) return;
      state = CommentThreadState.error(code: e.code, message: e.message);
    }
  }

  Future<void> loadMore() async {
    final CommentThreadState snapshot = state;
    if (snapshot is! CommentThreadLoaded) return;
    if (snapshot.nextCursor == null || snapshot.isLoadingMore) return;
    state = snapshot.copyWith(isLoadingMore: true);
    final int seq = ++_requestSeq;
    try {
      final CommentPage page = await _repository.listComments(
        postId: postId,
        cursor: snapshot.nextCursor,
      );
      if (seq != _requestSeq) return;
      state = CommentThreadState.loaded(
        items: <Comment>[...snapshot.items, ...page.items],
        nextCursor: page.nextCursor,
      );
    } on FeedRepositoryException {
      if (seq != _requestSeq) return;
      state = snapshot.copyWith(isLoadingMore: false);
    }
  }

  /// Posts a comment. [parentId] null for a root comment, set for a 1-level
  /// reply. Returns the inserted [Comment] or null when the post fails.
  Future<Comment?> postComment({
    required String content,
    String? parentId,
  }) async {
    final CommentThreadState snapshot = state;
    if (snapshot is! CommentThreadLoaded) return null;
    final String trimmed = content.trim();
    if (trimmed.isEmpty) {
      state = snapshot.copyWith(postError: '내용을 입력해주세요.');
      return null;
    }
    state = snapshot.copyWith(isPosting: true, postError: null);
    try {
      final Comment created = await _repository.createComment(
        postId: postId,
        content: trimmed,
        parentId: parentId,
      );
      // ASC order, so a freshly written comment goes at the end.
      state = snapshot.copyWith(
        items: <Comment>[...snapshot.items, created],
        isPosting: false,
      );
      return created;
    } on FeedRepositoryException catch (e) {
      state = snapshot.copyWith(
        isPosting: false,
        postError: e.code == 'COMMENT_DEPTH_EXCEEDED'
            ? '답글은 한 번까지만 달 수 있어요.'
            : e.message,
      );
      return null;
    }
  }

  /// Removes the supplied comment from the cached list after a successful
  /// `DELETE /comments/{id}`. Children of a deleted root are dropped too.
  Future<bool> deleteComment(String commentId) async {
    final CommentThreadState snapshot = state;
    if (snapshot is! CommentThreadLoaded) return false;
    try {
      await _repository.deleteComment(commentId);
    } on FeedRepositoryException catch (e) {
      state = snapshot.copyWith(postError: e.message);
      return false;
    }
    final Set<String> dropIds = <String>{commentId};
    for (final Comment c in snapshot.items) {
      if (c.parentId == commentId) {
        dropIds.add(c.id);
      }
    }
    state = snapshot.copyWith(
      items: <Comment>[
        for (final Comment c in snapshot.items)
          if (!dropIds.contains(c.id)) c,
      ],
    );
    return true;
  }

  /// Resets transient post-error so the inline hint disappears as the user
  /// edits the composer again.
  void clearPostError() {
    final CommentThreadState snapshot = state;
    if (snapshot is CommentThreadLoaded && snapshot.postError != null) {
      state = snapshot.copyWith(postError: null);
    }
  }
}

final commentThreadNotifierProvider = StateNotifierProvider.autoDispose
    .family<CommentThreadNotifier, CommentThreadState, String>((ref, postId) {
  return CommentThreadNotifier(ref.watch(feedRepositoryProvider), postId);
});
