import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/social_providers.dart';
import '../data/social_repository.dart';
import '../domain/user_summary.dart';

/// Lists the users the current account has blocked (`GET /social/blocks`),
/// with an inline 차단 해제 action (BC-82 settings-hub entry).
///
/// Mirrors the plain-`FutureBuilder` pattern used by `FollowerListScreen` /
/// `FollowingListScreen` (community feature) rather than a paginated
/// notifier — the block list is expected to stay small and this keeps the
/// screen simple.
class BlockedUsersScreen extends ConsumerStatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  ConsumerState<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends ConsumerState<BlockedUsersScreen> {
  late Future<UserSummaryPage> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(socialRepositoryProvider).getMyBlocks();
  }

  void _reload() {
    setState(() {
      _future = ref.read(socialRepositoryProvider).getMyBlocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('차단 목록')),
      body: FutureBuilder<UserSummaryPage>(
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
          final items = snapshot.data?.items ?? const <UserSummary>[];
          if (items.isEmpty) {
            return const Center(child: Text('차단한 사용자가 없어요'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _BlockedUserTile(user: items[index], onUnblocked: _reload),
          );
        },
      ),
    );
  }
}

class _BlockedUserTile extends ConsumerStatefulWidget {
  const _BlockedUserTile({required this.user, required this.onUnblocked});

  final UserSummary user;
  final VoidCallback onUnblocked;

  @override
  ConsumerState<_BlockedUserTile> createState() => _BlockedUserTileState();
}

class _BlockedUserTileState extends ConsumerState<_BlockedUserTile> {
  bool _loading = false;

  Future<void> _unblock() async {
    setState(() => _loading = true);
    try {
      await ref.read(socialRepositoryProvider).unblock(widget.user.id);
      if (mounted) widget.onUnblocked();
    } on SocialRepositoryException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final user = widget.user;
    final url = user.profileImageUrl;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      leading: url != null && url.isNotEmpty
          ? CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(url),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            )
          : CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user.nickname.isNotEmpty ? user.nickname[0].toUpperCase() : '?',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      title: Text(user.nickname),
      trailing: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : OutlinedButton(
              onPressed: _unblock,
              child: const Text('차단 해제'),
            ),
    );
  }
}
