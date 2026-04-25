import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/feed_repository.dart';
import '../domain/post.dart';
import '../domain/reaction_type.dart';
import 'book_feed_state.dart';
import 'feed_providers.dart';

/// Notifier for the per-book feed list.
///
/// Cursor pagination on `created_at DESC`: the first page hits without
/// a cursor; subsequent pages pass the previous response's `next_cursor`.
/// `loadMore` is a no-op once the server returns `next_cursor: null`.
class BookFeedNotifier extends StateNotifier<BookFeedState> {
  BookFeedNotifier(this._repository, this.bookId)
      : super(const BookFeedState.initial());

  final FeedRepository _repository;
  final String bookId;
  int _requestSeq = 0;

  /// Loads the first page. Triggered by the screen's mount frame.
  Future<void> load() async {
    state = const BookFeedState.loading();
    final int seq = ++_requestSeq;
    try {
      final PostPage page = await _repository.listPosts(bookId: bookId);
      if (seq != _requestSeq) return;
      state = BookFeedState.loaded(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } on FeedRepositoryException catch (e) {
      if (seq != _requestSeq) return;
      state = BookFeedState.error(code: e.code, message: e.message);
    }
  }

  /// Forces a fresh first-page fetch, replacing the current items. Used by
  /// pull-to-refresh and after a successful post composition.
  Future<void> refresh() async {
    final int seq = ++_requestSeq;
    try {
      final PostPage page = await _repository.listPosts(bookId: bookId);
      if (seq != _requestSeq) return;
      state = BookFeedState.loaded(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } on FeedRepositoryException catch (e) {
      if (seq != _requestSeq) return;
      state = BookFeedState.error(code: e.code, message: e.message);
    }
  }

  /// Appends the next page when the list approaches its end. No-ops in
  /// non-loaded states or when there is no next cursor.
  Future<void> loadMore() async {
    final BookFeedState snapshot = state;
    if (snapshot is! BookFeedLoaded) return;
    if (snapshot.nextCursor == null || snapshot.isLoadingMore) return;
    state = snapshot.copyWith(isLoadingMore: true);
    final int seq = ++_requestSeq;
    try {
      final PostPage page = await _repository.listPosts(
        bookId: bookId,
        cursor: snapshot.nextCursor,
      );
      if (seq != _requestSeq) return;
      state = BookFeedState.loaded(
        items: <Post>[...snapshot.items, ...page.items],
        nextCursor: page.nextCursor,
      );
    } on FeedRepositoryException {
      if (seq != _requestSeq) return;
      // Keep visible results; drop the spinner. Reaching the bottom again
      // re-triggers naturally.
      state = snapshot.copyWith(isLoadingMore: false);
    }
  }

  /// Inserts a freshly created post at the top of the cached list (DESC
  /// order). Falls back to a refresh if the notifier is not yet loaded.
  void prependPost(Post post) {
    final BookFeedState snapshot = state;
    if (snapshot is BookFeedLoaded) {
      state = snapshot.copyWith(
        items: <Post>[post, ...snapshot.items],
      );
    } else {
      // Notifier was Initial/Error; let the next load() call pick up the
      // server-canonical ordering.
      load();
    }
  }

  /// Reconciles a post's reaction map after a toggle response. Other fields
  /// stay intact so we don't have to re-fetch the entire post.
  void applyReactionResult({
    required String postId,
    required ReactionType reactionType,
    required ReactionToggleState toggleState,
    required Map<ReactionType, int> counts,
  }) {
    final BookFeedState snapshot = state;
    if (snapshot is! BookFeedLoaded) return;
    final List<Post> next = <Post>[
      for (final Post post in snapshot.items)
        if (post.id == postId)
          post.copyWith(
            reactions: counts,
            myReactions: toggleState == ReactionToggleState.added
                ? <ReactionType>{...post.myReactions, reactionType}
                : (Set<ReactionType>.of(post.myReactions)
                  ..remove(reactionType)),
          )
        else
          post,
    ];
    state = snapshot.copyWith(items: next);
  }

  /// Bumps a post's `commentCount` (e.g. after a successful comment write
  /// inside the comments sheet) without forcing the feed to refetch.
  void incrementCommentCount(String postId, [int delta = 1]) {
    final BookFeedState snapshot = state;
    if (snapshot is! BookFeedLoaded) return;
    final List<Post> next = <Post>[
      for (final Post post in snapshot.items)
        if (post.id == postId)
          post.copyWith(
            commentCount: (post.commentCount + delta).clamp(0, 1 << 31),
          )
        else
          post,
    ];
    state = snapshot.copyWith(items: next);
  }
}

/// Family keyed by `bookId` so each book detail screen owns its own feed
/// state. autoDispose so leaving the screen frees the cache.
final bookFeedNotifierProvider = StateNotifierProvider.autoDispose
    .family<BookFeedNotifier, BookFeedState, String>((ref, bookId) {
  // Keep alive as long as something is listening; auto-disposes when the
  // book detail unmounts. ref.keepAlive is intentionally NOT called — we
  // want the cache to drop on screen exit so re-entry shows fresh data.
  return BookFeedNotifier(ref.watch(feedRepositoryProvider), bookId);
});
