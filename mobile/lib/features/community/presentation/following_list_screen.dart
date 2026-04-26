import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../social/application/social_providers.dart';
import '../../social/data/social_repository.dart';
import '../../social/domain/user_summary.dart';

/// Displays the following list for a given user.
///
/// When [userId] is empty the screen loads the current user's own following
/// via `GET /social/following`; otherwise it loads `GET /social/users/{id}/following`.
class FollowingListScreen extends ConsumerWidget {
  const FollowingListScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('팔로잉')),
      body: _UserList(
        futureProvider: userId.isEmpty
            ? ref.watch(socialRepositoryProvider).getMyFollowing
            : () => ref.watch(socialRepositoryProvider).getUserFollowing(userId),
      ),
    );
  }
}

class _UserList extends StatefulWidget {
  const _UserList({required this.futureProvider});

  final Future<UserSummaryPage> Function() futureProvider;

  @override
  State<_UserList> createState() => _UserListState();
}

class _UserListState extends State<_UserList> {
  late Future<UserSummaryPage> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.futureProvider();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSummaryPage>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '목록을 불러오지 못했습니다.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        final items = snapshot.data?.items ?? const [];
        if (items.isEmpty) {
          return const Center(child: Text('아직 팔로잉하는 사람이 없어요'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) =>
              _UserSummaryTile(user: items[index]),
        );
      },
    );
  }
}

class _UserSummaryTile extends ConsumerWidget {
  const _UserSummaryTile({required this.user});

  final UserSummary user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      leading: _Avatar(user: user),
      title: Text(
        user.nickname,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: user.bio != null && user.bio!.isNotEmpty
          ? Text(
              user.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            )
          : null,
      trailing: _FollowChip(user: user),
      onTap: () => context.push(AppRoutes.userProfile(user.id)),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final UserSummary user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = user.profileImageUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(url),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      );
    }
    return CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        user.nickname.isNotEmpty ? user.nickname[0].toUpperCase() : '?',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _FollowChip extends ConsumerStatefulWidget {
  const _FollowChip({required this.user});

  final UserSummary user;

  @override
  ConsumerState<_FollowChip> createState() => _FollowChipState();
}

class _FollowChipState extends ConsumerState<_FollowChip> {
  late bool _isFollowing;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowing;
  }

  Future<void> _toggle() async {
    if (_loading) return;
    setState(() => _loading = true);
    final repo = ref.read(socialRepositoryProvider);
    try {
      if (_isFollowing) {
        await repo.unfollow(widget.user.id);
        if (mounted) setState(() => _isFollowing = false);
      } else {
        await repo.follow(widget.user.id);
        if (mounted) setState(() => _isFollowing = true);
      }
    } on SocialRepositoryException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (_isFollowing) {
      return ActionChip(
        label: const Text('팔로잉'),
        onPressed: _toggle,
      );
    }
    return ActionChip(
      label: const Text('팔로우'),
      onPressed: _toggle,
      backgroundColor:
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
    );
  }
}
