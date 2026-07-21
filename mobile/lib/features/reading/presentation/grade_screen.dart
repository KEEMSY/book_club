import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/grade_theme.dart';
import '../../book/application/library_notifier.dart';
import '../../book/application/library_state.dart';
import '../../book/domain/book_status.dart';
import '../../book/domain/user_book.dart';
import '../../book/presentation/widgets/book_cover.dart';
import '../application/goal_notifier.dart';
import '../application/goal_state.dart';
import '../application/grade_notifier.dart';
import '../application/grade_state.dart';
import '../application/reading_providers.dart';
import '../domain/goal_period.dart';
import '../domain/grade_summary.dart';
import '../domain/reading_goal.dart';
import '../domain/reading_year_stats.dart';
import 'widgets/elapsed_formatter.dart';
import 'widgets/grade_badge.dart';
import 'widgets/grade_progress.dart';
import 'widgets/milestone_toast.dart';
import 'widgets/streak_card.dart';
import 'widgets/streak_shield_badge.dart';

String _gradeName(ReaderGrade g) {
  switch (g) {
    case ReaderGrade.sprout:
      return '새싹 독자';
    case ReaderGrade.explorer:
      return '탐독자';
    case ReaderGrade.devoted:
      return '애독자';
    case ReaderGrade.passionate:
      return '열혈 독자';
    case ReaderGrade.master:
      return '서재 마스터';
  }
}

/// Returns a grade title that includes the Roman tier suffix when applicable.
/// Grade 5 (마스터) has no sub-tier, so it never gets a suffix.
String _gradeTitleWithTier(GradeSummary summary) {
  final String name = _gradeName(summary.readerGrade);
  if (summary.grade < 5 && summary.tier > 1) {
    final String roman =
        const <int, String>{1: 'I', 2: 'II', 3: 'III'}[summary.tier] ?? 'I';
    return '$name $roman';
  }
  return name;
}

/// `/grade` — summary screen for the user's reader tier.
///
/// Top: 120dp circular GradeBadge in the grade's primary accent.
/// Middle: next-grade progress (two bars for books + hours).
/// Bottom: streak card, totals row, "등급 체계 알아보기" link.
class GradeScreen extends ConsumerStatefulWidget {
  const GradeScreen({super.key});

  @override
  ConsumerState<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends ConsumerState<GradeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradeNotifierProvider.notifier).load();
      ref
          .read(libraryNotifierProvider.notifier)
          .ensureLoaded(BookStatus.completed);
      // M28 — show toast for any unacknowledged milestones.
      if (mounted) checkAndShowMilestoneToasts(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);
    final GradeState state = ref.watch(gradeNotifierProvider);

    final String appBarTitle =
        state is GradeLoaded ? _gradeTitleWithTier(state.summary) : '나의 등급';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: theme.textTheme.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(gradeNotifierProvider.notifier).refresh(),
        color: accent,
        child: switch (state) {
          GradeInitial() ||
          GradeLoading() =>
            const Center(child: CircularProgressIndicator()),
          GradeError(:final String message) =>
            _ErrorBody(message: message, onRetry: () => _refresh()),
          GradeLoaded(:final GradeSummary summary) =>
            _GradeBody(summary: summary, accent: accent),
        },
      ),
    );
  }

  Future<void> _refresh() => ref.read(gradeNotifierProvider.notifier).refresh();
}

class _GradeBody extends StatelessWidget {
  const _GradeBody({required this.summary, required this.accent});

  final GradeSummary summary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.md,
        spacing.lg,
        spacing.xl,
      ),
      children: <Widget>[
        Center(
          child: GradeBadge(
            grade: summary.readerGrade,
            tier: summary.tier,
            size: 120,
          ),
        ),
        SizedBox(height: spacing.md),
        // "Lv.N · <name>" below the badge so the numeric tier is still
        // legible for users who care about exact level, while the plant
        // icon above carries the growth metaphor.
        Center(
          child: Column(
            children: <Widget>[
              Text(
                'Lv.${summary.grade}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _gradeTitleWithTier(summary),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        GradeProgress(summary: summary, accent: accent),
        SizedBox(height: spacing.md),
        _YearSummaryCard(accent: accent),
        SizedBox(height: spacing.md),
        StreakCard(streak: summary.streakDays, longest: summary.longestStreak),
        if (summary.streakShields > 0) ...<Widget>[
          SizedBox(height: spacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: StreakShieldBadge(
              streakShields: summary.streakShields,
              accent: accent,
            ),
          ),
        ],
        SizedBox(height: spacing.md),
        _TotalsCard(summary: summary),
        SizedBox(height: spacing.md),
        _RecentCompletedSection(accent: accent),
        SizedBox(height: spacing.md),
        _MonthlyRecapEntryButton(accent: accent),
        SizedBox(height: spacing.md),
        _StatsEntryButton(accent: accent),
        SizedBox(height: spacing.md),
        _InfoLink(),
      ],
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.summary});

  final GradeSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: shadows.elevated,
      ),
      child: Row(
        children: <Widget>[
          _TotalCell(
            label: '읽은 책',
            value: '${summary.totalBooks}권',
          ),
          Container(
            width: 1,
            height: 32,
            color: theme.colorScheme.outline,
          ),
          _TotalCell(
            label: '누적 시간',
            value: formatDurationKorean(summary.totalSeconds),
          ),
        ],
      ),
    );
  }
}

class _TotalCell extends StatelessWidget {
  const _TotalCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.headlineMedium),
        ],
      ),
    );
  }
}

/// Banner button that navigates to the monthly recap card screen.
class _MonthlyRecapEntryButton extends StatelessWidget {
  const _MonthlyRecapEntryButton({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppSpacing spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;
    return InkWell(
      onTap: () => context.push(AppRoutes.monthlyRecap),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.3)),
          boxShadow: shadows.elevated,
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_month_rounded, color: accent, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '이번 달 회고',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: accent, size: 16),
          ],
        ),
      ),
    );
  }
}

/// Banner button that navigates to the full reading statistics screen.
class _StatsEntryButton extends StatelessWidget {
  const _StatsEntryButton({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;
    return InkWell(
      onTap: () => context.push(AppRoutes.readingStats),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.3)),
          boxShadow: shadows.elevated,
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.bar_chart_rounded, color: accent, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '독서 통계 보기',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: accent, size: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: TextButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const _GradeInfoDialog(),
        ),
        child: Text(
          '등급 체계 알아보기',
          style: theme.textTheme.bodyMedium?.copyWith(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class _GradeInfoDialog extends StatelessWidget {
  const _GradeInfoDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const List<(String, String, String)> rows = <(String, String, String)>[
      ('1 · 새싹 독자', '입문', '기본'),
      ('2 · 탐독자', '3권', '10시간'),
      ('3 · 애독자', '10권', '50시간'),
      ('4 · 열혈 독자', '30권', '150시간'),
      ('5 · 서재 마스터', '100권', '500시간'),
    ];
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: const Text('등급 체계'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '두 조건을 모두 충족해야 승급해요 (권수 AND 시간)',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final (String name, String books, String hours)
              in rows) ...<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(name, style: theme.textTheme.titleSmall),
                  Text(
                    '$books · $hours',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.all(spacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, size: 40),
            SizedBox(height: spacing.md),
            Text(message, style: theme.textTheme.titleLarge),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: () => onRetry(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 올해 독서 현황 — 완독 수, 읽은 시간, 연간 목표 진행률
// ---------------------------------------------------------------------------

class _YearSummaryCard extends ConsumerWidget {
  const _YearSummaryCard({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int year = DateTime.now().year;
    final AsyncValue<ReadingYearStats> statsAsync =
        ref.watch(yearStatsProvider(year));
    final GoalState goalState = ref.watch(goalNotifierProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    GoalProgress? yearlyGoal;
    if (goalState is GoalLoaded) {
      for (final GoalProgress g in goalState.items) {
        if (g.goal.period == GoalPeriod.yearly) {
          yearlyGoal = g;
          break;
        }
      }
    }

    return statsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (ReadingYearStats stats) {
        final int yearBooks = stats.yearBooks;
        final double? progress = yearlyGoal != null
            ? (yearBooks / yearlyGoal.goal.targetBooks).clamp(0.0, 1.0)
            : null;

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
              Text(
                '$year년 독서 현황',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: spacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SummaryCell(
                      label: '완독한 책',
                      value: '$yearBooks권',
                      accent: accent,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: theme.colorScheme.outline,
                  ),
                  Expanded(
                    child: _SummaryCell(
                      label: '읽은 시간',
                      value: formatDurationKorean(stats.yearSeconds),
                      accent: accent,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: theme.colorScheme.outline,
                  ),
                  Expanded(
                    child: _SummaryCell(
                      label: '최장 연속',
                      value: '${stats.longestStreak}일',
                      accent: accent,
                    ),
                  ),
                ],
              ),
              if (progress != null) ...<Widget>[
                SizedBox(height: spacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(radii.pill)),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: accent.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$yearBooks/${yearlyGoal!.goal.targetBooks}권',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.xs),
                Text(
                  _goalSubtitle(yearBooks, yearlyGoal.goal.targetBooks),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ] else ...<Widget>[
                SizedBox(height: spacing.sm),
                GestureDetector(
                  onTap: () => context.push('/goals'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '연간 독서 목표 설정하기',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: accent,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _goalSubtitle(int done, int target) {
    final int remaining = target - done;
    if (remaining <= 0) return '🎉 연간 목표를 달성했어요!';
    return '목표까지 $remaining권 남았어요';
  }
}

class _SummaryCell extends StatelessWidget {
  const _SummaryCell({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 최근 완독 — 가로 스크롤 책 표지 최대 6권
// ---------------------------------------------------------------------------

class _RecentCompletedSection extends ConsumerWidget {
  const _RecentCompletedSection({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    final Map<BookStatus, LibraryListState> libraryMap =
        ref.watch(libraryNotifierProvider);
    final LibraryListState? completedState = libraryMap[BookStatus.completed];
    if (completedState is! LibraryListLoaded) return const SizedBox.shrink();
    final List<UserBook> recent = completedState.items.take(6).toList();
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '최근 완독한 책',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing.sm),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recent.length,
            separatorBuilder: (_, __) => SizedBox(width: spacing.sm),
            itemBuilder: (BuildContext ctx, int index) {
              final UserBook ub = recent[index];
              return GestureDetector(
                onTap: () => ctx.push(
                  AppRoutes.bookDetail(ub.book.id),
                  extra: ub.id,
                ),
                child: SizedBox(
                  width: 92,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BookCover(
                        coverUrl: ub.book.coverUrl,
                        width: 92,
                        height: 130,
                        borderRadius:
                            BorderRadius.all(Radius.circular(radii.md)),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        ub.book.title,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (ub.rating != null && ub.rating! > 0) ...<Widget>[
                        const SizedBox(height: 2),
                        Row(
                          children: List<Widget>.generate(
                            ub.rating!.clamp(0, 5),
                            (_) => Icon(
                              Icons.star_rounded,
                              size: 10,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
