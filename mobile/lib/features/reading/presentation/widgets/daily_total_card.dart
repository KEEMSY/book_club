import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'elapsed_formatter.dart';

/// Dashboard "오늘 N분 읽음" card. [todaySeconds] is the sum of today's
/// timer sessions; [weeklyGoalSeconds] is optional so early-returning users
/// (no goal) still see the card without a misleading progress ring.
class DailyTotalCard extends StatelessWidget {
  const DailyTotalCard({
    super.key,
    required this.todaySeconds,
    required this.accent,
    this.weeklyGoalSeconds,
  });

  final int todaySeconds;
  final int? weeklyGoalSeconds;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    // Daily slice of the weekly goal (e.g. 7 hours/week → 1h/day target).
    final double progress = weeklyGoalSeconds == null || weeklyGoalSeconds == 0
        ? 0
        : (todaySeconds / (weeklyGoalSeconds! / 7)).clamp(0.0, 1.0);

    final AppShadows shadows = theme.extension<AppShadows>()!;
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        boxShadow: shadows.elevated,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '오늘의 독서',
                  // Secondary label — onSurface at 0.72 keeps the hierarchy
                  // (subdued vs the bold headline) legible on both canvases.
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDurationKorean(todaySeconds),
                  style: theme.textTheme.displaySmall
                      ?.copyWith(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 5,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
                Icon(
                  Icons.book_rounded,
                  color: accent,
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
