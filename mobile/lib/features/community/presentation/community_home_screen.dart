import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../social/application/social_providers.dart';
import '../../social/domain/user_summary.dart';

/// Community landing screen — "팔로잉" and "탐색" tabs.
///
/// 팔로잉: empty state until M8 wires the real timeline.
/// 탐색: live user search via GET /social/users/explore.
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
    final spacing = theme.extension<AppSpacing>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티', style: theme.textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: '팔로잉'),
            Tab(text: '독자 탐색'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _FollowingTab(
            onExploreTap: () => _tabController.animateTo(1),
            spacing: spacing,
          ),
          const _ExploreTab(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 팔로잉 탭 — M8에서 피드 연결 예정
// ---------------------------------------------------------------------------

class _FollowingTab extends StatelessWidget {
  const _FollowingTab({required this.onExploreTap, required this.spacing});

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
// 탐색 탭 — 닉네임 검색 + 결과 리스트
// ---------------------------------------------------------------------------

class _ExploreTab extends ConsumerStatefulWidget {
  const _ExploreTab();

  @override
  ConsumerState<_ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<_ExploreTab> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

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
            spacing.md, spacing.md, spacing.md, spacing.sm,
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
        Expanded(
          child: _query.isEmpty
              ? _EmptySearchHint(spacing: spacing)
              : _SearchResults(query: _query),
        ),
      ],
    );
  }
}

class _EmptySearchHint extends StatelessWidget {
  const _EmptySearchHint({required this.spacing});

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            CupertinoIcons.person_2,
            size: 56,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          SizedBox(height: spacing.md),
          Text(
            '닉네임으로 다른 독자를 찾아보세요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

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
          itemBuilder: (context, index) {
            final UserSummary user = page.items[index];
            return _UserSearchTile(user: user);
          },
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
