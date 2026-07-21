import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/grade_theme.dart';
import '../application/leaderboard_notifier.dart';
import '../domain/leaderboard_entry.dart';

/// `/community/leaderboard` — weekly reading-time leaderboard among followees.
///
/// Ranks are sorted by the server. Top-3 entries display a medal emoji; the
/// authenticated user's row is highlighted with the primary container colour.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final async = ref.watch(weeklyLeaderboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('이번 주 리더보드', style: theme.textTheme.titleLarge),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.lg,
              spacing.sm,
              spacing.lg,
              spacing.xs,
            ),
            child: Text(
              '지난 7일 독서 시간 기준',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) => _ErrorBody(
                onRetry: () => ref.invalidate(weeklyLeaderboardProvider),
              ),
              data: (entries) => entries.isEmpty
                  ? _EmptyState(spacing: spacing)
                  : _LeaderboardList(entries: entries, spacing: spacing),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List body
// ---------------------------------------------------------------------------

class _LeaderboardList extends ConsumerWidget {
  const _LeaderboardList({
    required this.entries,
    required this.spacing,
  });

  final List<LeaderboardEntry> entries;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(weeklyLeaderboardProvider);
        // Await the next value so the indicator dismisses after the fetch.
        await ref.read(weeklyLeaderboardProvider.future);
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        itemCount: entries.length,
        separatorBuilder: (_, __) => SizedBox(height: spacing.xs),
        itemBuilder: (context, index) => _EntryTile(entry: entries[index]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual leaderboard row
// ---------------------------------------------------------------------------

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

  final LeaderboardEntry entry;

  static const List<String> _medals = <String>['', '🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final bool isTop3 = entry.rank <= 3;

    // Highlight the current user's row with the primary container tint.
    final Color? rowColor = entry.isMe
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.38)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(radii.md),
        border: entry.isMe
            ? Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.35),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Medal or rank number
            SizedBox(
              width: 32,
              child: isTop3
                  ? Text(
                      _medals[entry.rank],
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      '${entry.rank}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.55,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            SizedBox(width: spacing.sm),
            // Avatar
            CircleAvatar(
              radius: 22,
              backgroundImage: entry.profileImageUrl != null
                  ? NetworkImage(entry.profileImageUrl!)
                  : null,
              child: entry.profileImageUrl == null
                  ? Text(
                      entry.nickname.isNotEmpty
                          ? entry.nickname[0].toUpperCase()
                          : '?',
                    )
                  : null,
            ),
          ],
        ),
        title: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                entry.nickname,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: entry.isMe ? FontWeight.w700 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (entry.gradeTier != null) ...<Widget>[
              SizedBox(width: spacing.xs),
              _GradePill(tier: entry.gradeTier!),
            ],
          ],
        ),
        trailing: _DurationLabel(minutes: entry.weeklyMinutes),
        onTap: () => context.push(AppRoutes.userProfile(entry.userId)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grade pill — compact inline badge showing the grade tier hue
// ---------------------------------------------------------------------------

class _GradePill extends StatelessWidget {
  const _GradePill({required this.tier});

  // gradeTier from server maps 1-5 → ReaderGrade ordinal
  final int tier;

  static ReaderGrade? _gradeFromTier(int t) {
    final values = ReaderGrade.values;
    final index = t - 1;
    if (index < 0 || index >= values.length) return null;
    return values[index];
  }

  @override
  Widget build(BuildContext context) {
    final grade = _gradeFromTier(tier);
    if (grade == null) return const SizedBox.shrink();
    final color = GradeTheme.primaryOf(grade);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ---------------------------------------------------------------------------
// Duration label — "X시간 Y분" or "Y분" when under an hour
// ---------------------------------------------------------------------------

class _DurationLabel extends StatelessWidget {
  const _DurationLabel({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int h = minutes ~/ 60;
    final int m = minutes % 60;

    String text;
    if (h > 0 && m > 0) {
      text = '$h시간 $m분';
    } else if (h > 0) {
      text = '$h시간';
    } else {
      text = '$m분';
    }

    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.spacing});

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
              Icons.leaderboard_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.28),
            ),
            SizedBox(height: spacing.md),
            Text(
              '팔로우한 친구가 없어요',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '친구를 팔로우하면 이번 주 독서 순위를\n함께 확인할 수 있어요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, size: 40),
            SizedBox(height: spacing.md),
            Text(
              '리더보드를 불러오지 못했어요',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: spacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
