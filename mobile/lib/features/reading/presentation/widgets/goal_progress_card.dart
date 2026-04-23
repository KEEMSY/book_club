import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/reading_goal.dart';
import 'elapsed_formatter.dart';

/// Active-goal card rendered on the GoalScreen per-period tab. Shows the
/// averaged percent (matches backend), current progress, and the D-N badge
/// until the end of the period.
class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({
    super.key,
    required this.progress,
    required this.accent,
  });

  final GoalProgress progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final ReadingGoal goal = progress.goal;
    final DateTime now = DateTime.now();
    final DateTime todayLocal = DateTime(now.year, now.month, now.day);
    final DateTime endDate = DateTime(
      goal.endDate.year,
      goal.endDate.month,
      goal.endDate.day,
    );
    final int daysRemaining = endDate.difference(todayLocal).inDays;

    final AppShadows shadows = theme.extension<AppShadows>()!;
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: shadows.elevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _periodHeadline(goal),
                style: theme.textTheme.titleMedium,
              ),
              _Countdown(days: daysRemaining, accent: accent),
            ],
          ),
          SizedBox(height: spacing.sm),
          Text(
            '${progress.booksDone}권 · ${formatDurationKorean(progress.secondsDone)} 완료',
            style: theme.textTheme.headlineMedium?.copyWith(color: accent),
          ),
          SizedBox(height: spacing.sm),
          Text(
            '목표: ${goal.targetBooks}권 · ${formatDurationKorean(goal.targetSeconds)}',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: spacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.percent.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(progress.percent * 100).clamp(0, 100).toStringAsFixed(0)}% 달성',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _periodHeadline(ReadingGoal goal) {
    final fmt = DateFormat('M월 d일');
    return '${fmt.format(goal.startDate)} ~ ${fmt.format(goal.endDate)}';
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown({required this.days, required this.accent});

  final int days;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String label = days <= 0 ? '종료' : 'D-$days';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(color: accent),
      ),
    );
  }
}
