import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/grade_summary.dart';
import 'elapsed_formatter.dart';

/// "다음 등급까지" card. Two progress bars: books (X/Y) + hours (X/Y).
/// When the user has reached the top tier we show the celebratory copy
/// instead.
class GradeProgress extends StatelessWidget {
  const GradeProgress({
    super.key,
    required this.summary,
    required this.accent,
  });

  final GradeSummary summary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final NextGradeThresholds? next = summary.nextGradeThresholds;

    if (next == null) {
      return Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: AppPalette.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
          boxShadow: AppShadows.light.elevated,
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.auto_awesome_rounded, color: accent, size: 28),
            SizedBox(width: spacing.md),
            Expanded(
              child: Text(
                '최고 등급에 도달했어요',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ],
        ),
      );
    }

    final int booksTarget = next.targetBooks;
    final int secondsTarget = next.targetSeconds;
    final int booksRemaining =
        (booksTarget - summary.totalBooks).clamp(0, booksTarget);
    final int secondsRemaining =
        (secondsTarget - summary.totalSeconds).clamp(0, secondsTarget);
    final double booksRatio = booksTarget == 0
        ? 1
        : (summary.totalBooks / booksTarget).clamp(0.0, 1.0);
    final double secondsRatio = secondsTarget == 0
        ? 1
        : (summary.totalSeconds / secondsTarget).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.light.elevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('다음 등급까지', style: theme.textTheme.titleMedium),
          SizedBox(height: spacing.sm),
          Text(
            '$booksRemaining권 · ${formatDurationKorean(secondsRemaining)} 남음',
            style: theme.textTheme.headlineMedium?.copyWith(color: accent),
          ),
          SizedBox(height: spacing.md),
          _ProgressRow(
            label: '권수',
            trailing: '${summary.totalBooks} / $booksTarget',
            ratio: booksRatio,
            color: accent,
          ),
          SizedBox(height: spacing.sm),
          _ProgressRow(
            label: '시간',
            trailing:
                '${formatDurationKorean(summary.totalSeconds)} / ${formatDurationKorean(secondsTarget)}',
            ratio: secondsRatio,
            color: accent,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.trailing,
    required this.ratio,
    required this.color,
  });

  final String label;
  final String trailing;
  final double ratio;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.focusedGray,
              ),
            ),
            Text(
              trailing,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.nearBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppPalette.lightSurface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
