import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/challenge_providers.dart';
import '../data/challenge_models.dart';

/// Full-screen challenge detail — SliverAppBar header + leaderboard + badge.
class ChallengeDetailScreen extends ConsumerWidget {
  const ChallengeDetailScreen({super.key, required this.challengeId});

  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(challengeDetailProvider(challengeId));

    return async.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: _ErrorBody(
          onRetry: () =>
              ref.invalidate(challengeDetailProvider(challengeId)),
        ),
      ),
      data: (challenge) => _ChallengeDetailBody(challenge: challenge),
    );
  }
}

class _ChallengeDetailBody extends ConsumerWidget {
  const _ChallengeDetailBody({required this.challenge});

  final ChallengeDto challenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final joinState = ref.watch(joinNotifierProvider);
    final bool actionLoading = joinState is AsyncLoading;
    final bool achieved = challenge.achievedAt != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Collapsed header with join/leave button in the actions bar.
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: achieved
                    ? _StatusChip(
                        label: '달성 완료',
                        color: theme.colorScheme.primary,
                      )
                    : _InlineJoinButton(
                        challenge: challenge,
                        loading: actionLoading,
                        onJoin: () async {
                          await ref
                              .read(joinNotifierProvider.notifier)
                              .join(challenge.id);
                          ref.invalidate(challengeDetailProvider(challenge.id));
                          ref.invalidate(activeChallengesProvider);
                          ref.invalidate(myChallengesProvider);
                        },
                        onLeave: () async {
                          await ref
                              .read(joinNotifierProvider.notifier)
                              .leave(challenge.id);
                          ref.invalidate(challengeDetailProvider(challenge.id));
                          ref.invalidate(activeChallengesProvider);
                          ref.invalidate(myChallengesProvider);
                        },
                      ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                challenge.title,
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.emoji_events,
                    size: 72,
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Description
                  if (challenge.description != null &&
                      challenge.description!.isNotEmpty) ...<Widget>[
                    Text(
                      challenge.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: spacing.md),
                  ],

                  // Challenge condition card
                  _ConditionCard(challenge: challenge),
                  SizedBox(height: spacing.md),

                  // My progress card (when joined)
                  if (challenge.isJoined) ...<Widget>[
                    _ProgressCard(challenge: challenge),
                    SizedBox(height: spacing.md),
                  ],

                  // Badge section
                  if (challenge.badge != null) ...<Widget>[
                    _BadgeSection(badge: challenge.badge!),
                    SizedBox(height: spacing.md),
                  ],

                  // Leaderboard section
                  Text('리더보드', style: theme.textTheme.titleMedium),
                  SizedBox(height: spacing.sm),
                ],
              ),
            ),
          ),

          // Leaderboard list (lazy)
          _LeaderboardSliver(challengeId: challenge.id),

          SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Condition card
// ---------------------------------------------------------------------------

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({required this.challenge});

  final ChallengeDto challenge;

  String _conditionText() {
    switch (challenge.challengeType) {
      case 'books_count':
        return '${challenge.targetValue}권 완독';
      case 'reading_time':
        final hours = (challenge.targetValue / 3600).ceil();
        return '$hours시간 독서';
      case 'streak':
        return '${challenge.targetValue}일 연속 독서';
      case 'genre':
        final genre = challenge.genreFilter != null
            ? ' (장르: ${challenge.genreFilter})'
            : '';
        return '${challenge.targetValue}권 완독$genre';
      default:
        return '${challenge.targetValue} 달성';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radius = theme.extension<AppRadius>()!;
    final now = DateTime.now();

    final String period =
        '${_formatDate(challenge.startsAt)} – ${_formatDate(challenge.endsAt)}';

    final dDiff = challenge.endsAt.difference(now).inDays;
    final String dDay = now.isAfter(challenge.endsAt)
        ? '종료됨'
        : dDiff == 0
            ? '오늘 마감'
            : 'D-$dDiff';

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.flag_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text('달성 조건', style: theme.textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 8),
          Text(_conditionText(), style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            period,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dDay,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
}

// ---------------------------------------------------------------------------
// My progress card
// ---------------------------------------------------------------------------

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.challenge});

  final ChallengeDto challenge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radius = theme.extension<AppRadius>()!;
    final int progress = challenge.myProgress ?? 0;
    final double fraction =
        challenge.targetValue > 0 ? progress / challenge.targetValue : 0.0;
    final bool achieved = challenge.achievedAt != null;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.trending_up,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text('내 진행 상황', style: theme.textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 8),
          if (achieved)
            Text(
              '달성 완료!',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          else ...<Widget>[
            LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 6),
            Text(
              '$progress / ${challenge.targetValue} 달성',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Badge section
// ---------------------------------------------------------------------------

class _BadgeSection extends StatelessWidget {
  const _BadgeSection({required this.badge});

  final BadgeDto badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radius = theme.extension<AppRadius>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('달성 배지', style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(radius.md),
          ),
          child: Row(
            children: <Widget>[
              _BadgeIconWidget(badge: badge, size: 48),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(badge.name, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      badge.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Leaderboard sliver
// ---------------------------------------------------------------------------

class _LeaderboardSliver extends ConsumerWidget {
  const _LeaderboardSliver({required this.challengeId});

  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(leaderboardProvider(challengeId));
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return async.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Text(
            '리더보드를 불러오지 못했어요.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              child: Text(
                '아직 참여자가 없어요.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _LeaderboardTile(entry: entries[index]),
            childCount: entries.length,
          ),
        );
      },
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({required this.entry});

  final LeaderboardEntryDto entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bool isTop3 = entry.rank <= 3;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs / 2,
      ),
      child: Row(
        children: <Widget>[
          // Rank
          SizedBox(
            width: 32,
            child: Text(
              '${entry.rank}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,
                color: isTop3 ? theme.colorScheme.primary : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: spacing.sm),
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: entry.profileImageUrl != null
                ? CachedNetworkImageProvider(entry.profileImageUrl!)
                : null,
            child: entry.profileImageUrl == null
                ? Text(
                    (entry.nickname?.isNotEmpty ?? false)
                        ? entry.nickname![0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 13),
                  )
                : null,
          ),
          SizedBox(width: spacing.sm),
          // Nickname
          Expanded(
            child: Text(
              entry.nickname ?? '알 수 없음',
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Value
          Text(
            '${entry.currentValue}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (entry.achievedAt != null) ...<Widget>[
            const SizedBox(width: 4),
            Icon(
              Icons.check_circle,
              size: 14,
              color: theme.colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------

class _InlineJoinButton extends StatelessWidget {
  const _InlineJoinButton({
    required this.challenge,
    required this.loading,
    required this.onJoin,
    required this.onLeave,
  });

  final ChallengeDto challenge;
  final bool loading;
  final VoidCallback onJoin;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (challenge.isJoined) {
      return OutlinedButton(
        onPressed: onLeave,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: const Text('참여 중'),
      );
    }
    return FilledButton(
      onPressed: onJoin,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: const Text('참여하기'),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _BadgeIconWidget extends StatelessWidget {
  const _BadgeIconWidget({required this.badge, required this.size});

  final BadgeDto badge;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (badge.iconUrl != null) {
      return CachedNetworkImage(
        imageUrl: badge.iconUrl!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholder: (_, __) => _FallbackBadgeIcon(size: size),
        errorWidget: (_, __, ___) => _FallbackBadgeIcon(size: size),
      );
    }
    return _FallbackBadgeIcon(size: size);
  }
}

class _FallbackBadgeIcon extends StatelessWidget {
  const _FallbackBadgeIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primaryContainer,
      ),
      child: Icon(
        Icons.workspace_premium,
        size: size * 0.55,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('챌린지를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
          SizedBox(height: spacing.sm),
          FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
