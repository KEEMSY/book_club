import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../social/application/social_providers.dart';
import '../../social/data/social_repository.dart';
import '../../social/domain/user_summary.dart';
import '../application/community_providers.dart';

/// Full-page user profile screen.
///
/// Renders different actions depending on [UserProfile.isMe]:
///   * own profile  → "프로필 편집" button
///   * other user   → "팔로우" / "팔로잉" toggle + 3-dot menu
///
/// The profile header, counts, and action button are placed inside a
/// [CustomScrollView] so the "게시글" section (M8) can be added as an
/// additional sliver without restructuring this widget.
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider(userId));

    return profileAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            '프로필을 불러오지 못했습니다.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
      data: (profile) => _ProfileContent(profile: profile, userId: userId),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({
    required this.profile,
    required this.userId,
  });

  final UserProfile profile;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.nickname),
        actions: profile.isMe
            ? null
            : [
                _ThreeDotMenu(profile: profile),
              ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ProfileAvatar(
                    profileImageUrl: profile.profileImageUrl,
                    nickname: profile.nickname,
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    profile.nickname,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                    SizedBox(height: spacing.sm),
                    Text(
                      profile.bio!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: spacing.sm),
                  // Grade badge placeholder — M8 will wire real grade data
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '독서 등급 —',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.lg),
                  _FollowCounts(profile: profile, userId: userId),
                  SizedBox(height: spacing.lg),
                  _ActionButton(profile: profile, userId: userId),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          // Posts section — M8 will replace this placeholder.
          SliverFillRemaining(
            child: _PostsPlaceholder(isBlocked: false, spacing: spacing),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.profileImageUrl,
    required this.nickname,
  });

  final String? profileImageUrl;
  final String nickname;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = profileImageUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: CachedNetworkImageProvider(url),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      );
    }
    return CircleAvatar(
      radius: 40,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        nickname.isNotEmpty ? nickname[0].toUpperCase() : '?',
        style: theme.textTheme.headlineMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _FollowCounts extends StatelessWidget {
  const _FollowCounts({required this.profile, required this.userId});

  final UserProfile profile;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CountTile(
          count: profile.followerCount,
          label: '팔로워',
          onTap: () => context.push(AppRoutes.userFollowers(userId)),
        ),
        const SizedBox(width: 32),
        _CountTile(
          count: profile.followingCount,
          label: '팔로잉',
          onTap: () => context.push(AppRoutes.userFollowing(userId)),
        ),
      ],
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.count,
    required this.label,
    required this.onTap,
  });

  final int count;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            '$count',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends ConsumerWidget {
  const _ActionButton({required this.profile, required this.userId});

  final UserProfile profile;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (profile.isMe) {
      return OutlinedButton(
        onPressed: () {
          // Profile edit navigation — routed through auth/me PATCH in M8.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필 편집은 M8에서 오픈 예정이에요')),
          );
        },
        child: const Text('프로필 편집'),
      );
    }

    final followAsync = ref.watch(followNotifierProvider);
    final isLoading = followAsync is AsyncLoading;

    if (profile.isFollowing) {
      return OutlinedButton(
        onPressed: isLoading ? null : () => _unfollow(context, ref),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('팔로잉'),
      );
    }

    return FilledButton(
      onPressed: isLoading ? null : () => _follow(context, ref),
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('팔로우'),
    );
  }

  Future<void> _follow(BuildContext context, WidgetRef ref) async {
    await ref.read(followNotifierProvider.notifier).follow(userId);
    if (!context.mounted) return;
    final state = ref.read(followNotifierProvider);
    if (state is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((state.error as SocialRepositoryException?)?.message ?? '팔로우에 실패했습니다.')),
      );
    } else {
      ref.invalidate(userProfileProvider(userId));
    }
  }

  Future<void> _unfollow(BuildContext context, WidgetRef ref) async {
    await ref.read(followNotifierProvider.notifier).unfollow(userId);
    if (!context.mounted) return;
    final state = ref.read(followNotifierProvider);
    if (state is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((state.error as SocialRepositoryException?)?.message ?? '언팔로우에 실패했습니다.')),
      );
    } else {
      ref.invalidate(userProfileProvider(userId));
    }
  }
}

class _ThreeDotMenu extends ConsumerWidget {
  const _ThreeDotMenu({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_MenuAction>(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      onSelected: (action) => _onSelected(context, ref, action),
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: _MenuAction.report,
          child: Text('신고하기'),
        ),
        PopupMenuItem(
          value: _MenuAction.block,
          child: Text('차단하기'),
        ),
      ],
    );
  }

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    _MenuAction action,
  ) async {
    final repo = ref.read(socialRepositoryProvider);
    try {
      switch (action) {
        case _MenuAction.report:
          await repo.reportUser(profile.id, reason: 'spam');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('신고가 접수되었습니다.')),
            );
          }
        case _MenuAction.block:
          await repo.block(profile.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('차단되었습니다.')),
            );
            context.pop();
          }
      }
    } on SocialRepositoryException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}

enum _MenuAction { report, block }

class _PostsPlaceholder extends StatelessWidget {
  const _PostsPlaceholder({
    required this.isBlocked,
    required this.spacing,
  });

  final bool isBlocked;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isBlocked) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Text(
            '이 사용자의 콘텐츠를 볼 수 없습니다',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.book,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '게시글',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: spacing.sm),
            Text(
              'M8에서 게시글 목록이 표시됩니다',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
