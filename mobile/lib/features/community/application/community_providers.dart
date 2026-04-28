import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../feed/domain/post.dart';
import '../../feed/domain/reaction_type.dart';
import '../../social/domain/user_summary.dart';
import '../data/community_api.dart';
import '../data/community_repository.dart';

final communityApiProvider = Provider<CommunityApi>((ref) {
  return CommunityApi(ref.watch(dioProvider));
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(ref.watch(communityApiProvider));
});

/// Fetches and caches a user's full profile.
final userProfileProvider =
    AutoDisposeFutureProvider.family<UserProfile, String>((ref, userId) {
  return ref.watch(communityRepositoryProvider).getUserProfile(userId);
});

// ---------------------------------------------------------------------------
// Feed notifiers — following timeline + explore
// ---------------------------------------------------------------------------

/// State for an infinite-scroll post feed.
class FeedState {
  const FeedState({
    required this.posts,
    required this.nextCursor,
    required this.isLoading,
    required this.error,
  });

  const FeedState.initial()
      : posts = const <Post>[],
        nextCursor = null,
        isLoading = false,
        error = null;

  final List<Post> posts;
  final String? nextCursor;
  final bool isLoading;
  final Object? error;

  bool get hasMore => nextCursor != null;

  FeedState copyWith({
    List<Post>? posts,
    String? nextCursor,
    bool clearCursor = false,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class _FeedNotifier extends StateNotifier<FeedState> {
  _FeedNotifier(this._load) : super(const FeedState.initial()) {
    fetchFirst();
  }

  final Future<PostPage> Function({String? cursor}) _load;

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(
      posts: const <Post>[],
      clearCursor: true,
      isLoading: true,
      clearError: true,
    );
    try {
      final page = await _load(cursor: null);
      state = state.copyWith(
        posts: page.items,
        nextCursor: page.nextCursor,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final page = await _load(cursor: state.nextCursor);
      state = state.copyWith(
        posts: [...state.posts, ...page.items],
        nextCursor: page.nextCursor,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void applyReactionResult({
    required String postId,
    required ReactionType reactionType,
    required ReactionToggleState toggleState,
    required Map<ReactionType, int> counts,
  }) {
    final List<Post> next = <Post>[
      for (final Post p in state.posts)
        if (p.id == postId)
          p.copyWith(
            reactions: counts,
            myReactions: toggleState == ReactionToggleState.added
                ? <ReactionType>{...p.myReactions, reactionType}
                : (Set<ReactionType>.of(p.myReactions)..remove(reactionType)),
          )
        else
          p,
    ];
    state = state.copyWith(posts: next);
  }
}

final followingFeedProvider =
    StateNotifierProvider.autoDispose<_FeedNotifier, FeedState>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return _FeedNotifier(
    ({String? cursor}) => repo.getFollowingFeed(cursor: cursor),
  );
});

/// User posts feed — key is the target user's ID string.
final userPostsFeedProvider =
    StateNotifierProvider.autoDispose.family<_FeedNotifier, FeedState, String>(
  (ref, userId) {
    final repo = ref.watch(communityRepositoryProvider);
    return _FeedNotifier(
      ({String? cursor}) => repo.getUserPosts(userId, cursor: cursor),
    );
  },
);

/// Explore feed — key is sort string ("latest" | "popular").
final exploreFeedProvider =
    StateNotifierProvider.autoDispose.family<_FeedNotifier, FeedState, String>(
  (ref, sort) {
    final repo = ref.watch(communityRepositoryProvider);
    return _FeedNotifier(
      ({String? cursor}) => repo.getExploreFeed(sort: sort, cursor: cursor),
    );
  },
);
