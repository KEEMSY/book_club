import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/challenge_providers.dart';
import '../data/challenge_models.dart';

/// Challenge landing screen — 3 tabs: active / my / ended.
class ChallengeListScreen extends ConsumerStatefulWidget {
  const ChallengeListScreen({super.key});

  @override
  ConsumerState<ChallengeListScreen> createState() =>
      _ChallengeListScreenState();
}

class _ChallengeListScreenState extends ConsumerState<ChallengeListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text('챌린지', style: theme.textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: '진행 중'),
            Tab(text: '내 챌린지'),
            Tab(text: '지난 챌린지'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          _ActiveChallengeTab(),
          _MyChallengeTab(),
          _EndedChallengeTab(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab bodies
// ---------------------------------------------------------------------------

class _ActiveChallengeTab extends ConsumerWidget {
  const _ActiveChallengeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(activeChallengesProvider);
    return async.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => _ErrorView(
        onRetry: () => ref.invalidate(activeChallengesProvider),
      ),
      data: (items) => items.isEmpty
          ? const _EmptyTab(message: '현재 진행 중인 챌린지가 없어요.\n곧 새로운 챌린지가 시작될 거예요!')
          : _ChallengeList(
              challenges: items,
              onRefresh: () async => ref.invalidate(activeChallengesProvider),
            ),
    );
  }
}

class _MyChallengeTab extends ConsumerWidget {
  const _MyChallengeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myChallengesProvider);
    return async.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => _ErrorView(
        onRetry: () => ref.invalidate(myChallengesProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const _EmptyTab(
            message: '아직 참여한 챌린지가 없어요.\n진행 중 탭에서 챌린지에 참여해보세요!',
          );
        }
        return _MyChallengeList(
          items: items,
          onRefresh: () async => ref.invalidate(myChallengesProvider),
        );
      },
    );
  }
}

class _EndedChallengeTab extends ConsumerWidget {
  const _EndedChallengeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(endedChallengesProvider);
    return async.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => _ErrorView(
        onRetry: () => ref.invalidate(endedChallengesProvider),
      ),
      data: (items) => items.isEmpty
          ? const _EmptyTab(message: '종료된 챌린지가 없어요.')
          : _ChallengeList(
              challenges: items,
              onRefresh: () async => ref.invalidate(endedChallengesProvider),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Challenge list with refresh
// ---------------------------------------------------------------------------

class _ChallengeList extends StatelessWidget {
  const _ChallengeList({
    required this.challenges,
    required this.onRefresh,
  });

  final List<ChallengeDto> challenges;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.md),
        itemCount: challenges.length,
        separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
        itemBuilder: (context, index) =>
            _ChallengeCard(challenge: challenges[index]),
      ),
    );
  }
}

class _MyChallengeList extends StatelessWidget {
  const _MyChallengeList({required this.items, required this.onRefresh});

  final List<MyChallengeDto> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
        itemBuilder: (context, index) => _ChallengeCard(
          challenge: items[index].challenge,
          currentValue: items[index].currentValue,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Challenge card
// ---------------------------------------------------------------------------

class _ChallengeCard extends ConsumerWidget {
  const _ChallengeCard({required this.challenge, this.currentValue});

  final ChallengeDto challenge;

  /// Progress override from MyChallengeDto — used in "my challenges" tab.
  final int? currentValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radius = theme.extension<AppRadius>()!;

    final int progress = currentValue ?? challenge.myProgress ?? 0;
    final double progressFraction =
        challenge.targetValue > 0 ? progress / challenge.targetValue : 0.0;
    final bool achieved = challenge.achievedAt != null;
    final bool isJoined = challenge.isJoined;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius.md),
        onTap: () => context.push(AppRoutes.challengeDetail(challenge.id)),
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title row + status chip
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      challenge.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (achieved)
                    _StatusChip(
                      label: '완료',
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
              SizedBox(height: spacing.xs),

              // Date / D-day row
              _DateLine(challenge: challenge),
              SizedBox(height: spacing.xs),

              // Participant count
              Row(
                children: <Widget>[
                  Icon(
                    Icons.people_outline,
                    size: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${challenge.participantCount}명 참여 중',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),

              // Progress bar (only when joined)
              if (isJoined && !achieved) ...<Widget>[
                SizedBox(height: spacing.sm),
                LinearProgressIndicator(
                  value: progressFraction.clamp(0.0, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '$progress / ${challenge.targetValue}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],

              SizedBox(height: spacing.sm),

              // Join / leave button
              _JoinButton(challenge: challenge),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Join button — handles join/leave with optimistic UI feedback
// ---------------------------------------------------------------------------

class _JoinButton extends ConsumerWidget {
  const _JoinButton({required this.challenge});

  final ChallengeDto challenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinState = ref.watch(joinNotifierProvider);
    final bool loading = joinState is AsyncLoading;
    final bool achieved = challenge.achievedAt != null;

    if (achieved) {
      return const SizedBox.shrink();
    }

    if (challenge.isJoined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: loading
              ? null
              : () async {
                  await ref
                      .read(joinNotifierProvider.notifier)
                      .leave(challenge.id);
                  ref.invalidate(activeChallengesProvider);
                  ref.invalidate(myChallengesProvider);
                  ref.invalidate(challengeDetailProvider(challenge.id));
                },
          child: loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('참여 중'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: loading
            ? null
            : () async {
                await ref
                    .read(joinNotifierProvider.notifier)
                    .join(challenge.id);
                ref.invalidate(activeChallengesProvider);
                ref.invalidate(myChallengesProvider);
                ref.invalidate(challengeDetailProvider(challenge.id));
              },
        child: loading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('참여하기'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------

class _DateLine extends StatelessWidget {
  const _DateLine({required this.challenge});

  final ChallengeDto challenge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final bool started = now.isAfter(challenge.startsAt);
    String label;

    if (!started) {
      final diff = challenge.startsAt.difference(now).inDays;
      label = diff == 0 ? '오늘 시작' : '$diff일 후 시작';
    } else {
      final diff = challenge.endsAt.difference(now).inDays;
      if (diff < 0) {
        label = '종료됨';
      } else if (diff == 0) {
        label = '오늘 마감';
      } else {
        label = 'D-$diff';
      }
    }

    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              message,
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
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

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
