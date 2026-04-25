import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/goal_period.dart';
import '../../domain/reading_goal.dart';

/// Compact multi-goal summary card shown on the dashboard.
///
/// When [items] is non-empty, renders yearly → monthly → weekly progress rows
/// with a LinearProgressIndicator and "Xh / 목표 Yh" annotation.
/// When [items] is empty, renders a CTA shell so the card never collapses to
/// nothing — the user sees an invitation to set a first goal rather than a
/// missing section.
class DashboardGoalCard extends StatelessWidget {
  const DashboardGoalCard({
    super.key,
    required this.items,
    required this.accent,
    this.onAddGoal,
  });

  /// Active goal progress list from [GoalLoaded.items].
  final List<GoalProgress> items;
  final Color accent;

  /// Optional tap handler for the empty-state CTA ("목표 추가" button).
  final VoidCallback? onAddGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    // Show yearly first, then monthly, then weekly — largest period on top so
    // the annual goal anchors the "올해의 독서 여정" framing.
    final List<GoalProgress> ordered = _ordered(items);

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
                '목표 진행률',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (ordered.isEmpty)
                TextButton.icon(
                  onPressed: onAddGoal,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('목표 추가'),
                  style: TextButton.styleFrom(
                    foregroundColor: accent,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          if (ordered.isEmpty) ...<Widget>[
            SizedBox(height: spacing.md),
            Row(
              children: <Widget>[
                Icon(
                  Icons.flag_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: spacing.xs),
                Text(
                  '아직 설정된 목표가 없어요',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ] else ...<Widget>[
            SizedBox(height: spacing.md),
            for (int i = 0; i < ordered.length; i++) ...<Widget>[
              _GoalRow(progress: ordered[i], accent: accent),
              if (i < ordered.length - 1) SizedBox(height: spacing.md),
            ],
          ],
        ],
      ),
    );
  }

  /// Sort order: yearly(2) > monthly(1) > weekly(0) by ordinal descending.
  List<GoalProgress> _ordered(List<GoalProgress> src) {
    const order = {
      GoalPeriod.yearly: 0,
      GoalPeriod.monthly: 1,
      GoalPeriod.weekly: 2,
    };
    final copy = [...src];
    copy.sort(
      (a, b) =>
          (order[a.goal.period] ?? 9).compareTo(order[b.goal.period] ?? 9),
    );
    return copy;
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.progress, required this.accent});

  final GoalProgress progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final double ratio = progress.percent.clamp(0.0, 1.0);
    final bool achieved = ratio >= 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _periodLabel(progress.goal.period),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  '${_hoursFormatted(progress.secondsDone)}h / 목표 ${_hoursFormatted(progress.goal.targetSeconds)}h',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                if (achieved) ...<Widget>[
                  SizedBox(width: spacing.xs),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 16,
                  ),
                ],
              ],
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor:
                theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              achieved ? Colors.green : accent,
            ),
          ),
        ),
      ],
    );
  }

  String _periodLabel(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.yearly:
        return '올해';
      case GoalPeriod.monthly:
        return '이번 달';
      case GoalPeriod.weekly:
        return '이번 주';
    }
  }

  /// Converts seconds to hours, rounded to one decimal place.
  String _hoursFormatted(int seconds) {
    final double hours = seconds / 3600;
    // Show integer when evenly divisible; otherwise one decimal.
    if (hours == hours.truncateToDouble()) {
      return hours.toStringAsFixed(0);
    }
    return hours.toStringAsFixed(1);
  }
}
