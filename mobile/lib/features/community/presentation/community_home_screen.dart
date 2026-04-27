import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../feed/domain/post.dart';
import '../../feed/presentation/comments_sheet.dart';
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
    _tabController = TabController(length: 2, vsync: this);
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: '팔로잉'),
            Tab(text: '탐색'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _FollowingFeedTab(onExploreTap: () => _tabController.animateTo(1)),
          const _ExploreTab(),
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
    final state = ref.watch(followingFeedProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    if (state.isLoading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (state.error != null && state.posts.isEmpty) {
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

    if (state.posts.isEmpty) {
      return _EmptyFollowingState(
        onExploreTap: onExploreTap,
        spacing: spacing,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(followingFeedProvider.notifier).fetchFirst(),
      child: _PostFeedList(
        posts: state.posts,
        hasMore: state.hasMore,
        isLoading: state.isLoading,
        onLoadMore: () =>
            ref.read(followingFeedProvider.notifier).fetchMore(),
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
              '아직 팔로우한 독자가 없어요',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '관심 있는 독자를 팔로우하면\n이곳에서 피드를 볼 수 있어요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: onExploreTap,
              child: const Text('독자 탐색하기'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 탐색 탭 — 포스트 피드 + 닉네임 검색
// ---------------------------------------------------------------------------

class _ExploreTab extends ConsumerStatefulWidget {
  const _ExploreTab();

  @override
  ConsumerState<_ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<_ExploreTab>
    with SingleTickerProviderStateMixin {
  late final TabController _sortController;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<String> _sortOptions = <String>['latest', 'popular'];

  @override
  void initState() {
    super.initState();
    _sortController = TabController(length: _sortOptions.length, vsync: this);
  }

  @override
  void dispose() {
    _sortController.dispose();
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
          TabBar(
            controller: _sortController,
            isScrollable: false,
            labelColor: theme.colorScheme.primary,
            tabs: const <Tab>[
              Tab(text: '최신'),
              Tab(text: '인기'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _sortController,
              children: _sortOptions
                  .map((sort) => _SortedFeedView(sort: sort))
                  .toList(),
            ),
          ),
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
    final state = ref.watch(exploreFeedProvider(sort));
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    if (state.isLoading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (state.error != null && state.posts.isEmpty) {
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

    if (state.posts.isEmpty) {
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
        posts: state.posts,
        hasMore: state.hasMore,
        isLoading: state.isLoading,
        onLoadMore: () =>
            ref.read(exploreFeedProvider(sort).notifier).fetchMore(),
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
  });

  final List<Post> posts;
  final bool hasMore;
  final bool isLoading;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

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
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.md),
        itemCount: posts.length + (isLoading ? 1 : 0),
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
            onTapComments: () => CommentsSheet.show(
              context,
              bookId: post.bookId,
              postId: post.id,
              initialCommentCount: post.commentCount,
            ),
          );
        },
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
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
            ? NetworkImage(widget.user.profileImageUrl!)
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('팔로잉'),
            )
          : FilledButton(
              onPressed: _toggle,
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('팔로우'),
            ),
    );
  }
}
