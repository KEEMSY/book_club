import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/feature_flags.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/grade_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../feed/presentation/comments_sheet.dart';
import '../../subscription/application/subscription_notifier.dart';
import '../../subscription/presentation/pro_badge.dart';
import '../../feed/presentation/widgets/post_card.dart';
import '../../reading/presentation/widgets/grade_badge.dart';
import '../../social/application/social_providers.dart';
import '../../social/data/social_repository.dart';
import '../../social/domain/user_summary.dart';
import '../application/community_providers.dart';

/// Full-page user profile screen.
///
/// Renders different actions depending on [UserProfile.isMe]:
///   * own profile  → "프로필 편집" button (navigates to [ProfileEditScreen])
///   * other user   → "팔로우" / "팔로잉" toggle + 3-dot menu
///
/// The profile header, stats, grade, badges, highlights, follow counts, and
/// action button are placed inside a [CustomScrollView] so the "게시글" section
/// can be added as an additional sliver without restructuring this widget.
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
  const _ProfileContent({required this.profile, required this.userId});

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
            ? <Widget>[
                PopupMenuButton<_OwnProfileAction>(
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (action) async {
                    if (action == _OwnProfileAction.language) {
                      await _showLanguagePicker(context, ref);
                      return;
                    }
                    if (action == _OwnProfileAction.privacy) {
                      context.push(AppRoutes.settingsPrivacy);
                      return;
                    }
                    if (action == _OwnProfileAction.terms) {
                      context.push(AppRoutes.settingsTerms);
                      return;
                    }
                    if (action == _OwnProfileAction.logout) {
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('로그아웃'),
                          content: const Text('정말 로그아웃할까요?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: Text(
                                '로그아웃',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true && context.mounted) {
                        await ref.read(authNotifierProvider.notifier).logout();
                      }
                    }
                  },
                  itemBuilder: (_) => <PopupMenuEntry<_OwnProfileAction>>[
                    PopupMenuItem<_OwnProfileAction>(
                      value: _OwnProfileAction.language,
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.language_outlined),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.of(context).settingsLanguage),
                        ],
                      ),
                    ),
                    const PopupMenuItem<_OwnProfileAction>(
                      value: _OwnProfileAction.privacy,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.privacy_tip_outlined),
                          SizedBox(width: 12),
                          Text('개인정보처리방침'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<_OwnProfileAction>(
                      value: _OwnProfileAction.terms,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.description_outlined),
                          SizedBox(width: 12),
                          Text('이용약관'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<_OwnProfileAction>(
                      value: _OwnProfileAction.logout,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.logout_outlined),
                          SizedBox(width: 12),
                          Text('로그아웃'),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : <Widget>[_ThreeDotMenu(profile: profile)],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.md,
              ),
              child: _ProfileHeader(profile: profile),
            ),
          ),
          if (profile.gradeStats != null) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.sm,
                ),
                child: _StatsRow(stats: profile.gradeStats!),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                child: _GradeSection(stats: profile.gradeStats!),
              ),
            ),
          ],
          if (profile.badges.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: spacing.sm, bottom: spacing.md),
                child: _BadgeShowcase(badges: profile.badges),
              ),
            ),
          if (profile.recentHighlights.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                child: _RecentHighlightsSection(
                  highlights: profile.recentHighlights,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.lg,
              ),
              child: Column(
                children: [
                  // Follow counts are a community feature; hidden when deferred
                  // (BC-40) so the profile still shows the "프로필 편집" action.
                  if (FeatureFlags.community) ...[
                    _FollowCounts(profile: profile, userId: userId),
                    SizedBox(height: spacing.lg),
                  ],
                  _ActionButton(profile: profile, userId: userId),
                ],
              ),
            ),
          ),
          // Posts feed hits the community endpoint; hidden when community is
          // deferred (BC-40).
          if (FeatureFlags.community) ...[
            SliverToBoxAdapter(
              child: Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            _UserPostsSliver(userId: userId),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile header — avatar + nickname + bio (grade placeholder removed)
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileAvatar(
          profileImageUrl: profile.profileImageUrl,
          nickname: profile.nickname,
        ),
        SizedBox(height: spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              profile.nickname,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 6),
            const ProBadge(),
          ],
        ),
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          SizedBox(height: spacing.sm),
          Text(
            profile.bio!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stats row — 완독 N권 | 총 Xh Ym | N일 스트릭
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final GradeStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatTile(label: '완독', value: '${stats.totalBooks}권'),
        _StatDivider(),
        _StatTile(label: '총 독서', value: _formatSeconds(stats.totalSeconds)),
        _StatDivider(),
        _StatTile(label: '스트릭', value: '${stats.streakDays}일'),
      ],
    );
  }

  /// Formats a raw second count into a compact human-readable string.
  ///
  /// Returns "Xh Ym" when an hour or more, "Ym" otherwise.
  static String _formatSeconds(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
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
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 32,
        child: VerticalDivider(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grade section — real GradeBadge with grade name
// ---------------------------------------------------------------------------

class _GradeSection extends StatelessWidget {
  const _GradeSection({required this.stats});

  final GradeStats stats;

  /// Maps the raw grade integer (1–5) to the Flutter [ReaderGrade] enum.
  static ReaderGrade _toReaderGrade(int grade) {
    switch (grade) {
      case 2:
        return ReaderGrade.explorer;
      case 3:
        return ReaderGrade.devoted;
      case 4:
        return ReaderGrade.passionate;
      case 5:
        return ReaderGrade.master;
      case 1:
      default:
        return ReaderGrade.sprout;
    }
  }

  @override
  Widget build(BuildContext context) {
    final readerGrade = _toReaderGrade(stats.grade);
    return Center(
      child: GradeBadge(
        grade: readerGrade,
        tier: stats.tier,
        size: 96,
        showLabel: true,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Badge showcase — horizontal scroll list
// ---------------------------------------------------------------------------

class _BadgeShowcase extends StatelessWidget {
  const _BadgeShowcase({required this.badges});

  final List<BadgeSummary> badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: Text('획득한 배지', style: theme.textTheme.titleSmall),
        ),
        SizedBox(height: spacing.sm),
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Padding(
                padding: EdgeInsets.only(right: spacing.md),
                child: _BadgeTile(badge: badge),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});

  final BadgeSummary badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge.iconUrl.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: badge.iconUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 28,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  errorWidget: (_, __, ___) => _BadgeFallbackIcon(),
                ),
              )
            : _BadgeFallbackIcon(),
        const SizedBox(height: 4),
        Text(
          badge.name,
          style: theme.textTheme.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _BadgeFallbackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.star_rounded,
        size: 28,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recent highlights section
// ---------------------------------------------------------------------------

class _RecentHighlightsSection extends StatelessWidget {
  const _RecentHighlightsSection({required this.highlights});

  final List<HighlightSummary> highlights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('최근 하이라이트', style: theme.textTheme.titleSmall),
        SizedBox(height: spacing.sm),
        ...highlights.map((h) => _HighlightCard(highlight: h)),
        SizedBox(height: spacing.md),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.highlight});

  final HighlightSummary highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.quote_bubble,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    highlight.quoteText,
                    style: theme.textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (highlight.bookTitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      highlight.bookTitle!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Existing widgets (preserved from original implementation)
// ---------------------------------------------------------------------------

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.profileImageUrl, required this.nickname});

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
      final subscriptionAsync = ref.watch(subscriptionNotifierProvider);
      final isPro = subscriptionAsync.maybeWhen(
        data: (s) => s.isPro,
        orElse: () => false,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            onPressed: () =>
                context.push(AppRoutes.profileEdit, extra: profile),
            child: const Text('프로필 편집'),
          ),
          // Reminder deferred (BC-20 scope cleanup): hide entry point when the
          // feature flag is off so no navigation to a disabled backend surface.
          if (FeatureFlags.reminder) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.reminders),
              icon: const Icon(Icons.alarm_outlined),
              label: const Text('독서 리마인더'),
            ),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.referral),
            icon: const Icon(Icons.people_alt_outlined),
            label: const Text('친구 초대'),
          ),
          // Subscription deferred (BC-41): hide the Pro upsell when the feature
          // is off, matching the reminder gating above — otherwise it navigates
          // to a paywall that redirects home.
          if (FeatureFlags.subscription && !isPro) ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.paywall),
              icon: const Icon(Icons.workspace_premium_rounded),
              label: const Text('Book Club Pro'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6B21A8),
              ),
            ),
          ],
        ],
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
        SnackBar(
          content: Text(
            (state.error as SocialRepositoryException?)?.message ??
                '팔로우에 실패했습니다.',
          ),
        ),
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
        SnackBar(
          content: Text(
            (state.error as SocialRepositoryException?)?.message ??
                '언팔로우에 실패했습니다.',
          ),
        ),
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
        PopupMenuItem(value: _MenuAction.report, child: Text('신고하기')),
        PopupMenuItem(value: _MenuAction.block, child: Text('차단하기')),
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('신고가 접수되었습니다.')));
          }
        case _MenuAction.block:
          await repo.block(profile.id);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('차단되었습니다.')));
            context.pop();
          }
      }
    } on SocialRepositoryException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
}

enum _MenuAction { report, block }

class _UserPostsSliver extends ConsumerStatefulWidget {
  const _UserPostsSliver({required this.userId});

  final String userId;

  @override
  ConsumerState<_UserPostsSliver> createState() => _UserPostsSliverState();
}

class _UserPostsSliverState extends ConsumerState<_UserPostsSliver> {
  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(userPostsFeedProvider(widget.userId));
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    if (feedState.isLoading && feedState.posts.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (feedState.error != null && feedState.posts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('게시글을 불러오지 못했어요', style: theme.textTheme.bodyMedium),
              SizedBox(height: spacing.sm),
              FilledButton(
                onPressed: () => ref
                    .read(userPostsFeedProvider(widget.userId).notifier)
                    .fetchFirst(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    if (feedState.posts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
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
                  '아직 게시글이 없어요',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(spacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == feedState.posts.length) {
            if (feedState.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            return null;
          }
          if (index == feedState.posts.length - 1 &&
              feedState.hasMore &&
              !feedState.isLoading) {
            ref.read(userPostsFeedProvider(widget.userId).notifier).fetchMore();
          }
          final post = feedState.posts[index];
          return Padding(
            padding: EdgeInsets.only(bottom: spacing.md),
            child: PostCard(
              bookId: post.bookId,
              post: post,
              onTapComments: () => CommentsSheet.show(
                context,
                bookId: post.bookId,
                postId: post.id,
                initialCommentCount: post.commentCount,
              ),
              onReactionApplied: (postId, type, toggleState, counts) => ref
                  .read(userPostsFeedProvider(widget.userId).notifier)
                  .applyReactionResult(
                    postId: postId,
                    reactionType: type,
                    toggleState: toggleState,
                    counts: counts,
                  ),
            ),
          );
        }, childCount: feedState.posts.length + (feedState.hasMore ? 1 : 0)),
      ),
    );
  }
}

enum _OwnProfileAction { language, privacy, terms, logout }

/// Lets the signed-in user switch the app language (M72 · i18n). Presented as a
/// [SimpleDialog] from the own-profile overflow menu; the choice is persisted by
/// [LocalePod] so it survives cold restarts.
Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
  final Locale current = ref.read(localePodProvider);
  final Locale? picked = await showDialog<Locale>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text(AppLocalizations.of(ctx).settingsLanguage),
      children: <Widget>[
        for (final ({Locale locale, String label}) option in _languageOptions)
          ListTile(
            title: Text(option.label),
            trailing: option.locale.languageCode == current.languageCode
                ? const Icon(Icons.check_rounded)
                : null,
            onTap: () => Navigator.of(ctx).pop(option.locale),
          ),
      ],
    ),
  );
  if (picked != null) {
    await ref.read(localePodProvider.notifier).setLocale(picked);
  }
}

/// Endonyms (each language named in itself) so the list is legible regardless
/// of the currently active locale.
const List<({Locale locale, String label})> _languageOptions =
    <({Locale locale, String label})>[
  (locale: Locale('ko'), label: '한국어'),
  (locale: Locale('en'), label: 'English'),
  (locale: Locale('ja'), label: '日本語'),
];
