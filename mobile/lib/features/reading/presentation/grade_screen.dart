import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/grade_notifier.dart';
import '../application/grade_state.dart';
import '../application/reading_providers.dart';
import '../domain/grade_summary.dart';
import 'widgets/elapsed_formatter.dart';
import 'widgets/grade_badge.dart';
import 'widgets/grade_progress.dart';
import 'widgets/streak_card.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);
    final GradeState state = ref.watch(gradeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('나의 등급', style: theme.textTheme.titleLarge),
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
            size: 120,
            showLabel: true,
          ),
        ),
        SizedBox(height: spacing.lg),
        GradeProgress(summary: summary, accent: accent),
        SizedBox(height: spacing.md),
        StreakCard(streak: summary.streakDays, longest: summary.longestStreak),
        SizedBox(height: spacing.md),
        _TotalsCard(summary: summary),
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
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.light.elevated,
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
            color: AppPalette.borderGray,
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
      backgroundColor: AppPalette.pureWhite,
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
