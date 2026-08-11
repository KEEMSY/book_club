import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/feature_flags.dart';
import '../../../core/network/dio_provider.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../../feed/domain/post.dart';
import '../../feed/domain/reaction_type.dart';
import '../../reading/application/reading_providers.dart';
import '../../social/domain/user_summary.dart';
import '../data/community_api.dart';
import '../data/community_repository.dart';
import '../domain/my_activity.dart';

part 'community_providers.g.dart';

final communityApiProvider = Provider<CommunityApi>((ref) {
  return CommunityApi(ref.watch(dioProvider));
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(ref.watch(communityApiProvider));
});

/// Fetches and caches a user's full profile.
///
/// When the community feature is deferred (BC-40) its `/community/users/{id}/
/// profile` endpoint is unmounted (404), so the profile is rebuilt from `/me`
/// + the reading grade for the current user. Community-only fields (follow
/// counts, posts) are zeroed/empty and the profile screen hides those sections.
final userProfileProvider =
    AutoDisposeFutureProvider.family<UserProfile, String>((ref, userId) async {
  if (FeatureFlags.community) {
    return ref.watch(communityRepositoryProvider).getUserProfile(userId);
  }
  final AuthState auth = ref.watch(authNotifierProvider);
  final user = auth is Authenticated ? auth.user : null;
  if (user == null) {
    throw StateError('cannot load profile: not authenticated');
  }
  final grade = await ref.watch(readingRepositoryProvider).getGrade();
  return UserProfile(
    id: user.id,
    nickname: user.nickname,
    profileImageUrl: user.profileImageUrl,
    bio: null,
    followerCount: 0,
    followingCount: 0,
    isFollowing: false,
    isMe: true,
    gradeStats: GradeStats(
      grade: grade.grade,
      tier: grade.tier,
      totalBooks: grade.totalBooks,
      totalSeconds: grade.totalSeconds,
      streakDays: grade.streakDays,
    ),
    badges: const <BadgeSummary>[],
    recentHighlights: const <HighlightSummary>[],
    // BC-84: `/me` (UserPublic) already carries these, so the own-profile
    // header still renders expressiveness while community is deferred.
    coverImageUrl: user.coverImageUrl,
    theme: user.theme,
    featuredBookId: user.featuredBookId,
    featuredQuote: user.featuredQuote,
  );
});

/// "내 활동" summary (BC-83) — counts + a 5-item preview per category, shown
/// on the caller's own profile. Only meaningful for `isMe` profiles (the
/// endpoint is always scoped to the authenticated user), so the profile
/// screen only watches this when rendering its own profile.
///
/// Unlike the rest of this file's providers, this is NOT gated behind
/// [FeatureFlags.community]: BC-90 relocated the backing endpoint to
/// `GET /me/activity`, mounted unconditionally regardless of
/// `feature_community_enabled`, so the summary stays visible while
/// community is deferred (BC-40).
final myActivityProvider = FutureProvider.autoDispose<MyActivitySummary>((ref) {
  return ref.watch(communityRepositoryProvider).getMyActivity();
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

// ---------------------------------------------------------------------------
// Following feed
// ---------------------------------------------------------------------------

@riverpod
class FollowingFeed extends _$FollowingFeed {
  @override
  FeedState build() {
    Future.microtask(fetchFirst);
    return const FeedState.initial();
  }

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(
      posts: const <Post>[],
      clearCursor: true,
      isLoading: true,
      clearError: true,
    );
    try {
      final page =
          await ref.read(communityRepositoryProvider).getFollowingFeed();
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
      final page = await ref
          .read(communityRepositoryProvider)
          .getFollowingFeed(cursor: state.nextCursor);
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

// ---------------------------------------------------------------------------
// User posts feed — keyed by userId
// ---------------------------------------------------------------------------

@riverpod
class UserPostsFeed extends _$UserPostsFeed {
  @override
  FeedState build(String userId) {
    Future.microtask(fetchFirst);
    return const FeedState.initial();
  }

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(
      posts: const <Post>[],
      clearCursor: true,
      isLoading: true,
      clearError: true,
    );
    try {
      final page =
          await ref.read(communityRepositoryProvider).getUserPosts(userId);
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
      final page = await ref
          .read(communityRepositoryProvider)
          .getUserPosts(userId, cursor: state.nextCursor);
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

// ---------------------------------------------------------------------------
// Explore feed — keyed by sort string ("latest" | "popular")
// ---------------------------------------------------------------------------

@riverpod
class ExploreFeed extends _$ExploreFeed {
  @override
  FeedState build(String sort) {
    Future.microtask(fetchFirst);
    return const FeedState.initial();
  }

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(
      posts: const <Post>[],
      clearCursor: true,
      isLoading: true,
      clearError: true,
    );
    try {
      final page = await ref
          .read(communityRepositoryProvider)
          .getExploreFeed(sort: sort);
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
      final page = await ref
          .read(communityRepositoryProvider)
          .getExploreFeed(sort: sort, cursor: state.nextCursor);
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

// ---------------------------------------------------------------------------
// Highlight-only feed (community "인용" tab)
// ---------------------------------------------------------------------------

@riverpod
class HighlightFeed extends _$HighlightFeed {
  @override
  FeedState build() {
    Future.microtask(fetchFirst);
    return const FeedState.initial();
  }

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(
      posts: const <Post>[],
      clearCursor: true,
      isLoading: true,
      clearError: true,
    );
    try {
      final page = await ref
          .read(communityRepositoryProvider)
          .getExploreFeed(sort: 'latest', postType: 'highlight');
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
      final page = await ref.read(communityRepositoryProvider).getExploreFeed(
            sort: 'latest',
            postType: 'highlight',
            cursor: state.nextCursor,
          );
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
