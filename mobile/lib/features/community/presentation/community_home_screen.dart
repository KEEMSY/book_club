import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/skeleton.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../../club/presentation/clubs_tab.dart';
import '../../feed/application/global_feed_notifier.dart';
import '../../feed/domain/feed_event.dart';
import '../../feed/domain/post.dart';
import '../../feed/domain/reaction_type.dart';
import '../../feed/presentation/comments_sheet.dart';
import '../../feed/presentation/feed_comment_sheet.dart';
import '../../feed/presentation/widgets/feed_event_card.dart';
import '../../feed/presentation/widgets/post_card.dart';
import '../../social/application/social_providers.dart';
import '../../social/domain/user_summary.dart';
import '../application/community_providers.dart';

/// Community landing screen — "팔로잉" and "탐색" tabs.
class CommunityHomeScreen extends ConsumerStatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  ConsumerState<CommunityHomeScreen> createState() =>
      _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends ConsumerState<CommunityHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티', style: theme.textTheme.titleLarge),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.leaderboard_outlined),
            tooltip: '리더보드',
            onPressed: () => context.push(AppRoutes.leaderboard),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: '챌린지',
            onPressed: () => context.push(AppRoutes.challenges),
          ),
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined),
            tooltip: '배지',
            onPressed: () => context.push(AppRoutes.badges),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const <Tab>[
            Tab(text: '피드'),
            Tab(text: '팔로잉'),
            Tab(text: '탐색'),
            Tab(text: '인용'),
            Tab(text: '그룹'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          const _GlobalEventFeedSection(),
          _FollowingFeedTab(onExploreTap: () => _tabController.animateTo(2)),
          const _ExploreTab(),
          const _HighlightFeedTab(),
          const ClubsTab(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 피드 탭 — global activity event feed with 전체 / 팔로우 sub-tabs (M47)
// ---------------------------------------------------------------------------

class _GlobalEventFeedSection extends ConsumerStatefulWidget {
  const _GlobalEventFeedSection();

  @override
  ConsumerState<_GlobalEventFeedSection> createState() =>
      _GlobalEventFeedSectionState();
}

class _GlobalEventFeedSectionState
    extends ConsumerState<_GlobalEventFeedSection>
    with SingleTickerProviderStateMixin {
  late final TabController _subTabController;

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        TabBar(
          controller: _subTabController,
          tabs: const <Tab>[
            Tab(text: '전체'),
            Tab(text: '팔로우'),
          ],
          labelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: const <Widget>[
              _GlobalEventFeedTab(tab: FeedTab.global),
              _GlobalEventFeedTab(tab: FeedTab.following),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlobalEventFeedTab extends ConsumerWidget {
  const _GlobalEventFeedTab({required this.tab});

  final FeedTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    // Watch the correct notifier based on the active tab.
    final GlobalFeedState state = tab == FeedTab.global
        ? ref.watch(globalFeedNotifierProvider)
        : ref.watch(followingEventFeedNotifierProvider);

    // Fetch-first is triggered by notifier build(); just handle UI states.
    if (state.isLoading && state.items.isEmpty) {
      return const FeedSkeletonList();
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('피드를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
            SizedBox(height: spacing.sm),
            FilledButton(
              onPressed: () => tab == FeedTab.global
                  ? ref.read(globalFeedNotifierProvider.notifier).fetchFirst()
                  : ref
                      .read(followingEventFeedNotifierProvider.notifier)
                      .fetchFirst(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.dynamic_feed_outlined,
                size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              SizedBox(height: spacing.md),
              Text(
                tab == FeedTab.following ? '팔로우한 독자의 활동이 없어요' : '아직 활동 피드가 없어요',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final auth = ref.watch(authNotifierProvider);
    final String currentUserId = auth is Authenticated ? auth.user.id : '';

    return RefreshIndicator(
      onRefresh: () => tab == FeedTab.global
          ? ref.read(globalFeedNotifierProvider.notifier).fetchFirst()
          : ref.read(followingEventFeedNotifierProvider.notifier).fetchFirst(),
      child: _EventFeedList(
        items: state.items,
        hasMore: state.hasMore,
        isLoading: state.isLoading,
        currentUserId: currentUserId,
        onLoadMore: () => tab == FeedTab.global
            ? ref.read(globalFeedNotifierProvider.notifier).fetchMore()
            : ref.read(followingEventFeedNotifierProvider.notifier).fetchMore(),
        onReactionToggled: (eventId, emoji, added) {
          if (tab == FeedTab.global) {
            ref.read(globalFeedNotifierProvider.notifier).applyReactionToggle(
                  eventId: eventId,
                  emoji: emoji,
                  added: added,
                  currentUserId: currentUserId,
                );
          } else {
            ref
                .read(followingEventFeedNotifierProvider.notifier)
                .applyReactionToggle(
                  eventId: eventId,
                  emoji: emoji,
                  added: added,
                  currentUserId: currentUserId,
                );
          }
        },
        onCommentCountChanged: (eventId, delta) {
          if (tab == FeedTab.global) {
            ref
                .read(globalFeedNotifierProvider.notifier)
                .incrementCommentCount(eventId, delta);
          } else {
            ref
                .read(followingEventFeedNotifierProvider.notifier)
                .incrementCommentCount(eventId, delta);
          }
        },
      ),
    );
  }
}

class _EventFeedList extends StatelessWidget {
  const _EventFeedList({
    required this.items,
    required this.hasMore,
    required this.isLoading,
    required this.currentUserId,
    required this.onLoadMore,
    required this.onReactionToggled,
    required this.onCommentCountChanged,
  });

  final List<FeedEvent> items;
  final bool hasMore;
  final bool isLoading;
  final String currentUserId;
  final VoidCallback onLoadMore;
  final void Function(String eventId, String emoji, bool added)
      onReactionToggled;
  final void Function(String eventId, int delta) onCommentCountChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final int itemCount = items.length + (isLoading ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollEndNotification &&
            n.metrics.extentAfter < 200 &&
            hasMore &&
            !isLoading) {
          onLoadMore();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.all(spacing.md),
            sliver: SliverList.separated(
              itemCount: itemCount,
              separatorBuilder: (_, __) => SizedBox(height: spacing.md),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                final FeedEvent event = items[index];
                final deepLink = clubSessionDeepLinkFor(event);
                return FeedEventCard(
                  event: event,
                  currentUserId: currentUserId,
                  onTapCard: deepLink == null
                      ? null
                      : () => context.push(
                            AppRoutes.sessionDetail(
                              deepLink.clubId,
                              deepLink.sessionId,
                              topicId: deepLink.topicId,
                            ),
                          ),
                  onTapComments: () => FeedCommentSheet.show(
                    context,
                    eventId: event.id,
                    currentUserId: currentUserId,
                    initialCommentCount: event.commentCount,
                    onCommentCountChanged: (delta) =>
                        onCommentCountChanged(event.id, delta),
                  ),
                  onReactionToggled: (emoji, added) =>
                      onReactionToggled(event.id, emoji, added),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 팔로잉 피드
// ---------------------------------------------------------------------------

class _FollowingFeedTab extends ConsumerWidget {
  const _FollowingFeedTab({required this.onExploreTap});

  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(followingFeedProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    if (feedState.isLoading && feedState.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (feedState.error != null && feedState.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('피드를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
            SizedBox(height: spacing.sm),
            FilledButton(
              onPressed: () =>
                  ref.read(followingFeedProvider.notifier).fetchFirst(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (feedState.posts.isEmpty) {
      return _EmptyFollowingState(onExploreTap: onExploreTap, spacing: spacing);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(followingFeedProvider.notifier).fetchFirst(),
      child: _PostFeedList(
        posts: feedState.posts,
        hasMore: feedState.hasMore,
        isLoading: feedState.isLoading,
        onLoadMore: () => ref.read(followingFeedProvider.notifier).fetchMore(),
        onReactionApplied: (postId, type, toggleState, counts) =>
            ref.read(followingFeedProvider.notifier).applyReactionResult(
                  postId: postId,
                  reactionType: type,
                  toggleState: toggleState,
                  counts: counts,
                ),
      ),
    );
  }
}

class _EmptyFollowingState extends StatelessWidget {
  const _EmptyFollowingState({
    required this.onExploreTap,
    required this.spacing,
  });

  final VoidCallback onExploreTap;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '아직 게시물이 없어요',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '관심 있는 독자를 팔로우하거나\n팔로우한 독자가 글을 올리면 여기에 나타나요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            FilledButton(onPressed: onExploreTap, child: const Text('독자 탐색하기')),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 탐색 탭 — SegmentedButton 정렬 + 닉네임 검색
// ---------------------------------------------------------------------------

class _ExploreTab extends ConsumerStatefulWidget {
  const _ExploreTab();

  @override
  ConsumerState<_ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<_ExploreTab> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _sort = 'latest';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.md,
            spacing.md,
            spacing.md,
            spacing.sm,
          ),
          child: SearchBar(
            controller: _searchController,
            hintText: '닉네임으로 독자 검색',
            leading: const Icon(CupertinoIcons.search),
            trailing: _query.isNotEmpty
                ? <Widget>[
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
                  ]
                : null,
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        if (_query.isNotEmpty)
          Expanded(child: _SearchResults(query: _query))
        else ...<Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.xs,
            ),
            child: SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment(value: 'latest', label: Text('최신')),
                ButtonSegment(value: 'popular', label: Text('인기')),
              ],
              selected: <String>{_sort},
              onSelectionChanged: (s) => setState(() => _sort = s.first),
              style: SegmentedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ),
          Expanded(child: _SortedFeedView(sort: _sort)),
        ],
      ],
    );
  }
}

class _SortedFeedView extends ConsumerWidget {
  const _SortedFeedView({required this.sort});

  final String sort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(exploreFeedProvider(sort));
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    if (feedState.isLoading && feedState.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (feedState.error != null && feedState.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('피드를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
            SizedBox(height: spacing.sm),
            FilledButton(
              onPressed: () =>
                  ref.read(exploreFeedProvider(sort).notifier).fetchFirst(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (feedState.posts.isEmpty) {
      return Center(
        child: Text(
          '아직 게시물이 없어요',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(exploreFeedProvider(sort).notifier).fetchFirst(),
      child: _PostFeedList(
        posts: feedState.posts,
        hasMore: feedState.hasMore,
        isLoading: feedState.isLoading,
        onLoadMore: () =>
            ref.read(exploreFeedProvider(sort).notifier).fetchMore(),
        onReactionApplied: (postId, type, toggleState, counts) =>
            ref.read(exploreFeedProvider(sort).notifier).applyReactionResult(
                  postId: postId,
                  reactionType: type,
                  toggleState: toggleState,
                  counts: counts,
                ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared post list with infinite scroll
// ---------------------------------------------------------------------------

class _PostFeedList extends StatelessWidget {
  const _PostFeedList({
    required this.posts,
    required this.hasMore,
    required this.isLoading,
    required this.onLoadMore,
    required this.onReactionApplied,
  });

  final List<Post> posts;
  final bool hasMore;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final void Function(
    String postId,
    ReactionType type,
    ReactionToggleState toggleState,
    Map<ReactionType, int> counts,
  ) onReactionApplied;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    // Build item count including the optional loading sentinel at the end.
    final itemCount = posts.length + (isLoading ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollEndNotification &&
            n.metrics.extentAfter < 200 &&
            hasMore &&
            !isLoading) {
          onLoadMore();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(spacing.md),
            sliver: SliverList.separated(
              itemCount: itemCount,
              separatorBuilder: (_, __) => SizedBox(height: spacing.md),
              itemBuilder: (context, index) {
                if (index == posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                final post = posts[index];
                return PostCard(
                  bookId: post.bookId,
                  post: post,
                  onTapAuthor: (userId) =>
                      context.push(AppRoutes.userProfile(userId)),
                  onTapComments: () => CommentsSheet.show(
                    context,
                    bookId: post.bookId,
                    postId: post.id,
                    initialCommentCount: post.commentCount,
                  ),
                  onReactionApplied: onReactionApplied,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 닉네임 검색 결과
// ---------------------------------------------------------------------------

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(exploreUsersProvider(query));

    return async.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => const Center(child: Text('검색 중 오류가 발생했어요')),
      data: (page) {
        if (page.items.isEmpty) {
          return Center(
            child: Text(
              '"$query"에 해당하는 독자가 없어요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
          );
        }
        return ListView.builder(
          itemCount: page.items.length,
          itemBuilder: (context, index) =>
              _UserSearchTile(user: page.items[index]),
        );
      },
    );
  }
}

class _UserSearchTile extends ConsumerStatefulWidget {
  const _UserSearchTile({required this.user});

  final UserSummary user;

  @override
  ConsumerState<_UserSearchTile> createState() => _UserSearchTileState();
}

class _UserSearchTileState extends ConsumerState<_UserSearchTile> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowing;
  }

  Future<void> _toggle() async {
    final repo = ref.read(socialRepositoryProvider);
    final next = !_isFollowing;
    setState(() => _isFollowing = next);
    try {
      if (next) {
        await repo.follow(widget.user.id);
        // Refresh the following feed so the new followee's posts appear.
        ref.read(followingFeedProvider.notifier).fetchFirst();
      } else {
        await repo.unfollow(widget.user.id);
      }
    } catch (_) {
      if (mounted) setState(() => _isFollowing = !next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.push(AppRoutes.userProfile(widget.user.id)),
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: widget.user.profileImageUrl != null
            ? CachedNetworkImageProvider(widget.user.profileImageUrl!)
            : null,
        child: widget.user.profileImageUrl == null
            ? Text(
                widget.user.nickname.isNotEmpty
                    ? widget.user.nickname[0].toUpperCase()
                    : '?',
              )
            : null,
      ),
      title: Text(widget.user.nickname, style: theme.textTheme.bodyLarge),
      subtitle: widget.user.bio != null && widget.user.bio!.isNotEmpty
          ? Text(
              widget.user.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            )
          : null,
      trailing: _isFollowing
          ? OutlinedButton(
              onPressed: _toggle,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('팔로잉'),
            )
          : FilledButton(
              onPressed: _toggle,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('팔로우'),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// 인용 피드 탭 — highlight-type posts only
// ---------------------------------------------------------------------------

class _HighlightFeedTab extends ConsumerWidget {
  const _HighlightFeedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(highlightFeedProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    if (feedState.isLoading && feedState.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (feedState.error != null && feedState.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('피드를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
            SizedBox(height: spacing.sm),
            FilledButton(
              onPressed: () =>
                  ref.read(highlightFeedProvider.notifier).fetchFirst(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (feedState.posts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.format_quote_rounded,
                size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              SizedBox(height: spacing.md),
              Text(
                '아직 공유된 인용이 없어요',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.sm),
              Text(
                '책을 읽으며 기억하고 싶은 문장을\n피드에 공유해보세요',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(highlightFeedProvider.notifier).fetchFirst(),
      child: _PostFeedList(
        posts: feedState.posts,
        hasMore: feedState.hasMore,
        isLoading: feedState.isLoading,
        onLoadMore: () => ref.read(highlightFeedProvider.notifier).fetchMore(),
        onReactionApplied: (postId, type, toggleState, counts) =>
            ref.read(highlightFeedProvider.notifier).applyReactionResult(
                  postId: postId,
                  reactionType: type,
                  toggleState: toggleState,
                  counts: counts,
                ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 로딩 스켈레톤 (M55)
// ---------------------------------------------------------------------------

/// Shimmer placeholder shown while the first feed page loads — mirrors the
/// rough shape of a stack of [FeedEventCard]s so the layout doesn't jump when
/// real content arrives.
class FeedSkeletonList extends StatelessWidget {
  const FeedSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Shimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.md),
        itemCount: 5,
        separatorBuilder: (_, __) => SizedBox(height: spacing.md),
        itemBuilder: (_, __) => const _FeedSkeletonCard(),
      ),
    );
  }
}

class _FeedSkeletonCard extends StatelessWidget {
  const _FeedSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radii = Theme.of(context).extension<AppRadius>()!;
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SkeletonBox(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              SizedBox(width: spacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SkeletonBox(width: 120, height: 12),
                  SizedBox(height: spacing.xs),
                  const SkeletonBox(width: 80, height: 10),
                ],
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          const SkeletonBox(width: double.infinity, height: 12),
          SizedBox(height: spacing.xs),
          const SkeletonBox(width: double.infinity, height: 12),
          SizedBox(height: spacing.xs),
          const SkeletonBox(width: 180, height: 12),
        ],
      ),
    );
  }
}
