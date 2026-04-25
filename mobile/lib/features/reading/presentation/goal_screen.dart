import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../application/goal_notifier.dart';
import '../application/goal_state.dart';
import '../application/reading_providers.dart';
import '../domain/goal_period.dart';
import '../domain/reading_goal.dart';
import 'widgets/elapsed_formatter.dart';
import 'widgets/goal_journey_modal.dart';

/// `/goals` — single continuous "독서 여정" view.
///
/// Yearly → monthly → weekly cards stack vertically with vertical connectors
/// between them so the user reads the three periods as nested resolutions of
/// the same journey rather than three independent goals.
class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);
    final GoalState state = ref.watch(goalNotifierProvider);
    final spacing = theme.extension<AppSpacing>()!;
    final bool loading = state is GoalLoading || state is GoalInitial;

    final GoalProgress? yearly =
        ref.read(goalNotifierProvider.notifier).progressFor(GoalPeriod.yearly);
    final GoalProgress? monthly =
        ref.read(goalNotifierProvider.notifier).progressFor(GoalPeriod.monthly);
    final GoalProgress? weekly =
        ref.read(goalNotifierProvider.notifier).progressFor(GoalPeriod.weekly);

    return Scaffold(
      appBar: AppBar(
        title: Text('독서 여정', style: theme.textTheme.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(goalNotifierProvider.notifier).refresh(),
        color: accent,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.md,
            spacing.lg,
            spacing.xl,
          ),
          children: <Widget>[
            const _JourneyHeader(),
            SizedBox(height: spacing.lg),
            if (loading && yearly == null && monthly == null && weekly == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...<Widget>[
              _YearlyHeroCard(progress: yearly, accent: accent),
              const _Connector(),
              _PeriodCard(
                period: GoalPeriod.monthly,
                progress: monthly,
                accent: accent,
              ),
              const _Connector(),
              _PeriodCard(
                period: GoalPeriod.weekly,
                progress: weekly,
                accent: accent,
              ),
              SizedBox(height: spacing.xl),
              _ActionRow(accent: accent),
            ],
          ],
        ),
      ),
    );
  }
}

class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('올해의 독서 여정', style: theme.textTheme.displaySmall),
        SizedBox(height: spacing.xs),
        Text(
          '당신이 향하는 곳, 지금 이 주의 걸음까지',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Vertical "여정의 흐름" connector. Renders a 24dp gradient line into a
/// chevron-down so the eye threads from yearly → monthly → weekly.
class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Total height = line (16) + chevron (16) + 4 padding = 36. Sized
    // explicitly so the column never overflows its parent SizedBox.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 2,
              height: 16,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    theme.colorScheme.outlineVariant,
                    theme.colorScheme.primary.withValues(alpha: 0.30),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: theme.colorScheme.primary.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yearly hero — the "destination" anchor of the journey.
///
/// Empty state inlines the same setup CTA as the smaller period cards so the
/// user can kickstart the journey from the most prominent surface on screen.
class _YearlyHeroCard extends ConsumerWidget {
  const _YearlyHeroCard({required this.progress, required this.accent});

  final GoalProgress? progress;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final shadows = theme.extension<AppShadows>()!;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: shadows.elevated,
      ),
      child: progress == null
          ? _InlineEmpty(
              title: '올해 어디까지 가고 싶나요?',
              accent: accent,
              onTap: () => GoalJourneyModal.show(context),
            )
          : _YearlyContent(progress: progress!, accent: accent),
    );
  }
}

class _YearlyContent extends StatelessWidget {
  const _YearlyContent({required this.progress, required this.accent});

  final GoalProgress progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final ReadingGoal goal = progress.goal;
    final double clamped = progress.percent.clamp(0.0, 1.0).toDouble();
    final int daysRemaining = _daysRemaining(goal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '올해 (${goal.startDate.year}년)',
              style: theme.textTheme.titleMedium,
            ),
            _DCountChip(days: daysRemaining, accent: accent),
          ],
        ),
        SizedBox(height: spacing.md),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: clamped),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (BuildContext context, double value, Widget? child) {
            return SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 12,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${(value * 100).round()}%',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: accent,
                        ),
                      ),
                      Text(
                        '연간 달성',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: spacing.md),
        Text(
          '${progress.booksDone} / ${goal.targetBooks} 권 · '
          '${formatDurationKorean(progress.secondsDone)} / '
          '${formatDurationKorean(goal.targetSeconds)}',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Smaller "이번 달" / "이번 주" card. Shares the same surface treatment as
/// the yearly hero but renders the progress as two slim segmented bars so the
/// three cards read as the same family.
class _PeriodCard extends ConsumerWidget {
  const _PeriodCard({
    required this.period,
    required this.progress,
    required this.accent,
  });

  final GoalPeriod period;
  final GoalProgress? progress;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final shadows = theme.extension<AppShadows>()!;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: shadows.elevated,
      ),
      child: progress == null
          ? _InlineEmpty(
              title: '이 기간 목표가 아직 없어요',
              accent: accent,
              onTap: () => GoalJourneyModal.show(context),
            )
          : _PeriodContent(
              period: period,
              progress: progress!,
              accent: accent,
            ),
    );
  }
}

class _PeriodContent extends StatelessWidget {
  const _PeriodContent({
    required this.period,
    required this.progress,
    required this.accent,
  });

  final GoalPeriod period;
  final GoalProgress progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final ReadingGoal goal = progress.goal;
    final double bookPercent = goal.targetBooks == 0
        ? 0
        : (progress.booksDone / goal.targetBooks).clamp(0.0, 1.0).toDouble();
    final double timePercent = goal.targetSeconds == 0
        ? 0
        : (progress.secondsDone / goal.targetSeconds)
            .clamp(0.0, 1.0)
            .toDouble();
    final int daysRemaining = _daysRemaining(goal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                _periodHeadline(period, goal),
                style: theme.textTheme.titleMedium,
              ),
            ),
            _DCountChip(days: daysRemaining, accent: accent),
          ],
        ),
        SizedBox(height: spacing.md),
        _SegmentedBar(
          label: '권수',
          progressLabel: '${progress.booksDone} / ${goal.targetBooks} 권',
          percent: bookPercent,
          accent: accent,
        ),
        SizedBox(height: spacing.sm),
        _SegmentedBar(
          label: '독서 시간',
          progressLabel: '${formatDurationKorean(progress.secondsDone)}'
              ' / ${formatDurationKorean(goal.targetSeconds)}',
          percent: timePercent,
          accent: accent,
        ),
        SizedBox(height: spacing.sm),
        Text(
          '${((bookPercent + timePercent) / 2 * 100).round()}% 진행 중',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _periodHeadline(GoalPeriod period, ReadingGoal goal) {
    final fmt = DateFormat('M/d');
    switch (period) {
      case GoalPeriod.weekly:
        return '이번 주 (${fmt.format(goal.startDate)}'
            '–${fmt.format(goal.endDate)})';
      case GoalPeriod.monthly:
        return '이번 달 (${goal.startDate.month}월)';
      case GoalPeriod.yearly:
        return '올해 (${goal.startDate.year}년)';
    }
  }
}

/// Two-line slim bar used by both monthly & weekly cards. Animated from 0 →
/// percent so newly-loaded cards don't pop.
class _SegmentedBar extends StatelessWidget {
  const _SegmentedBar({
    required this.label,
    required this.progressLabel,
    required this.percent,
    required this.accent,
  });

  final String label;
  final String progressLabel;
  final double percent;
  final Color accent;

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
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              progressLabel,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: percent),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (BuildContext context, double value, Widget? child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DCountChip extends StatelessWidget {
  const _DCountChip({required this.days, required this.accent});

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

/// Inline empty state used by every card. Single CTA opens the unified
/// "여정 설정" modal — no per-period creation flow exists anymore.
class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({
    required this.title,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.flag_outlined, size: 36, color: accent),
        SizedBox(height: spacing.sm),
        Text(
          title,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing.sm),
        FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
          ),
          child: const Text('지금 만들기'),
        ),
      ],
    );
  }
}

/// "목표 재설정" + "수동 기록" pair anchored under the weekly card. The manual
/// log entry navigates to the dashboard because the modal needs the active
/// reading book in scope — owning that picker on the goal screen would
/// duplicate dashboard state.
class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton(
            onPressed: () => GoalJourneyModal.show(context),
            child: const Text('목표 재설정'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () => GoRouter.of(context).go('/home'),
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('수동 기록'),
          ),
        ),
      ],
    );
  }
}

int _daysRemaining(ReadingGoal goal) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime end = DateTime(
    goal.endDate.year,
    goal.endDate.month,
    goal.endDate.day,
  );
  return end.difference(today).inDays;
}
