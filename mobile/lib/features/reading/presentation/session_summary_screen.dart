import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/grade_theme.dart';
import '../application/reading_providers.dart';
import '../domain/reading_goal.dart';
import 'widgets/elapsed_formatter.dart';
import 'widgets/grade_badge.dart';

/// Post-end celebration screen surfaced after a timer session completes.
///
/// Shows the total duration, streak, and a grade-up banner if the session
/// pushed the user into the next tier. Tapping "계속" pops back to `/home`.
class SessionSummaryScreen extends ConsumerWidget {
  const SessionSummaryScreen({super.key, required this.completion});

  final SessionCompletion completion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);
    final ReaderGrade currentGrade = _readerGradeFor(completion.grade);
    final Duration elapsed = Duration(seconds: completion.durationSec);

    return Scaffold(
      // Inherit the theme canvas — Foggy on light, darkCanvas on dark.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text('닫기'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.md,
          ),
          child: Column(
            children: <Widget>[
              const Spacer(),
              if (completion.gradeUp)
                _GradeUpBanner(accent: accent, grade: currentGrade),
              SizedBox(height: spacing.md),
              Text('수고하셨어요', style: theme.textTheme.headlineLarge),
              SizedBox(height: spacing.sm),
              Text(
                formatElapsed(elapsed),
                style: theme.textTheme.displayLarge?.copyWith(color: accent),
              ),
              SizedBox(height: spacing.sm),
              Text(
                '오늘의 독서 기록이 저장되었어요',
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: spacing.xl),
              _StreakRow(streak: completion.streakDays),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('계속'),
                ),
              ),
              SizedBox(height: spacing.md),
            ],
          ),
        ),
      ),
    );
  }

  ReaderGrade _readerGradeFor(int grade) {
    switch (grade) {
      case 2:
        return ReaderGrade.explorer;
      case 3:
        return ReaderGrade.devoted;
      case 4:
        return ReaderGrade.passionate;
      case 5:
        return ReaderGrade.master;
      case 1:
      default:
        return ReaderGrade.sprout;
    }
  }
}

class _GradeUpBanner extends StatelessWidget {
  const _GradeUpBanner({required this.accent, required this.grade});

  final Color accent;
  final ReaderGrade grade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GradeBadge(grade: grade, size: 40),
          const SizedBox(width: 12),
          Text(
            '${_gradeLabel(grade)}(으)로 승급했어요',
            style: theme.textTheme.titleMedium?.copyWith(color: accent),
          ),
        ],
      ),
    );
  }

  String _gradeLabel(ReaderGrade g) {
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
}

class _StreakRow extends StatelessWidget {
  const _StreakRow({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (streak <= 0) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.local_fire_department_rounded, size: 24),
        const SizedBox(width: 6),
        Text(
          '연속 $streak일 독서 중',
          style: theme.textTheme.titleLarge,
        ),
      ],
    );
  }
}
