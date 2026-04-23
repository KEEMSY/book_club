import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/auth_state.dart';
import '../../book/application/library_notifier.dart';
import '../../book/application/library_state.dart';
import '../../book/domain/book_status.dart';
import '../../book/domain/user_book.dart';
import '../application/goal_notifier.dart';
import '../application/goal_state.dart';
import '../application/grade_notifier.dart';
import '../application/grade_state.dart';
import '../application/heatmap_notifier.dart';
import '../application/heatmap_state.dart';
import '../application/reading_providers.dart';
import '../domain/goal_period.dart';
import '../domain/grade_summary.dart';
import '../domain/heatmap_day.dart';
import 'widgets/daily_total_card.dart';
import 'widgets/grade_badge.dart';
import 'widgets/jan_dee_grid.dart';
import 'widgets/manual_log_modal.dart';
import 'widgets/streak_card.dart';

/// `/home` — the post-login landing.
///
/// Sections:
///   1. Greeting headline.
///   2. DailyTotalCard — "오늘 N분 읽음" + mini progress vs. weekly goal slice.
///   3. StreakCard.
///   4. Compact GradeBadge + "다음 등급까지" line.
///   5. 52×7 Jan-dee heatmap.
///   6. "지금 읽기 시작" pill FAB.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradeNotifierProvider.notifier).load();
      ref.read(heatmapNotifierProvider.notifier).load();
      ref.read(goalNotifierProvider.notifier).load();
      // Warm the "읽는 중" library tab so the start-reading CTA has a book
      // context to jump straight into.
      ref
          .read(libraryNotifierProvider.notifier)
          .ensureLoaded(BookStatus.reading);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);
    final GradeState gradeState = ref.watch(gradeNotifierProvider);
    final HeatmapState heatmapState = ref.watch(heatmapNotifierProvider);
    final GoalState goalState = ref.watch(goalNotifierProvider);
    final AuthState authState = ref.watch(authNotifierProvider);
    final String? nickname =
        authState is Authenticated ? authState.user.nickname : null;

    final int? weeklyGoalSeconds =
        goalState is GoalLoaded ? _weeklyGoal(goalState) : null;
    final int todaySeconds = _todaySeconds(heatmapState);

    return Scaffold(
      body: RefreshIndicator(
        color: accent,
        onRefresh: () async {
          await Future.wait<void>(<Future<void>>[
            ref.read(gradeNotifierProvider.notifier).refresh(),
            ref.read(heatmapNotifierProvider.notifier).invalidate(),
            ref.read(goalNotifierProvider.notifier).refresh(),
          ]);
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.md,
            spacing.lg,
            100,
          ),
          children: <Widget>[
            _Header(nickname: nickname),
            SizedBox(height: spacing.lg),
            DailyTotalCard(
              todaySeconds: todaySeconds,
              weeklyGoalSeconds: weeklyGoalSeconds,
              accent: accent,
            ),
            SizedBox(height: spacing.md),
            StreakCard(
              streak: _streak(gradeState),
              longest: _longest(gradeState),
            ),
            SizedBox(height: spacing.md),
            _GradeRow(state: gradeState, accent: accent),
            SizedBox(height: spacing.md),
            _HeatmapCard(state: heatmapState, accent: accent),
            SizedBox(height: spacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _startReading(context),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('지금 읽기 시작'),
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: const StadiumBorder(),
                  textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _TopActions(onManual: _onManualLog),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  void _startReading(BuildContext context) {
    final readingMap = ref.read(libraryNotifierProvider);
    final readingState = readingMap[BookStatus.reading];
    final List<UserBook> reading =
        readingState is LibraryListLoaded ? readingState.items : <UserBook>[];
    if (reading.isNotEmpty) {
      final UserBook first = reading.first;
      context.push('/reading/timer?user_book_id=${first.id}');
      return;
    }
    // No reading book yet — send the user to the library / search.
    context.go('/library');
  }

  Future<void> _onManualLog() async {
    final readingMap = ref.read(libraryNotifierProvider);
    final readingState = readingMap[BookStatus.reading];
    final List<UserBook> reading =
        readingState is LibraryListLoaded ? readingState.items : <UserBook>[];
    if (reading.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('서재에 읽는 중인 책이 없어요'),
        ),
      );
      return;
    }
    final UserBook target = reading.first;
    if (!mounted) return;
    await ManualLogModal.show(context, userBookId: target.id);
  }

  int _todaySeconds(HeatmapState state) {
    if (state is! HeatmapLoaded) return 0;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    for (final HeatmapDay d in state.days) {
      final DateTime dd = DateTime(d.date.year, d.date.month, d.date.day);
      if (dd == today) return d.totalSeconds;
    }
    return 0;
  }

  int _streak(GradeState state) =>
      state is GradeLoaded ? state.summary.streakDays : 0;

  int _longest(GradeState state) =>
      state is GradeLoaded ? state.summary.longestStreak : 0;

  int? _weeklyGoal(GoalLoaded state) {
    for (final goal in state.items) {
      if (goal.goal.period == GoalPeriod.weekly) {
        return goal.goal.targetSeconds;
      }
    }
    return null;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.nickname});

  final String? nickname;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int hour = DateTime.now().hour;
    final String greeting;
    if (hour < 12) {
      greeting = '좋은 아침이에요';
    } else if (hour < 18) {
      greeting = '오늘도 독서 좋아요';
    } else {
      greeting = '오늘의 독서, 편안한 저녁';
    }
    final String name = nickname ?? '독자';
    // Greeting sits as the landing headline in Playfair `displaySmall` (22/600)
    // with nearBlack ink, so it reads as the editorial entry point rather than
    // a muted line. Nickname follows in `titleMedium` (16/500) sans — a clear
    // supporting sub-line per §3 hierarchy.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          greeting,
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$name님',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}

class _GradeRow extends ConsumerWidget {
  const _GradeRow({required this.state, required this.accent});

  final GradeState state;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bool isError = state is GradeError;
    return GestureDetector(
      onTap: () {
        if (isError) {
          // Failure state turns the whole card into a retry affordance so
          // the user isn't stranded on the grade screen with another error.
          ref.read(gradeNotifierProvider.notifier).load(force: true);
          return;
        }
        GoRouter.of(context).push('/grade');
      },
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
          boxShadow: theme.extension<AppShadows>()!.elevated,
        ),
        child: Row(
          children: <Widget>[
            _buildBadge(state),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _title(state),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subtitle(state),
                    // Secondary reading copy — onSurface at 0.72 keeps AA on
                    // both the warm light card and the #1F1F1F dark card.
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isError ? Icons.refresh_rounded : Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(GradeState state) {
    return switch (state) {
      GradeLoaded(:final summary) =>
        GradeBadge(grade: summary.readerGrade, size: 64),
      GradeLoading() => const GradeBadge.placeholder(size: 64, shimmer: true),
      GradeInitial() || GradeError() => const GradeBadge.placeholder(size: 64),
    };
  }

  String _title(GradeState state) {
    if (state is GradeLoaded) {
      switch (state.summary.grade) {
        case 1:
          return '새싹 독자';
        case 2:
          return '탐독자';
        case 3:
          return '애독자';
        case 4:
          return '열혈 독자';
        case 5:
          return '서재 마스터';
      }
    }
    return '나의 등급';
  }

  String _subtitle(GradeState state) {
    return switch (state) {
      GradeLoaded(:final summary) => _loadedSubtitle(summary),
      GradeLoading() || GradeInitial() => '등급을 불러오고 있어요',
      GradeError() => '등급을 불러오지 못했어요. 다시 시도하려면 눌러주세요',
    };
  }

  String _loadedSubtitle(GradeSummary summary) {
    final next = summary.nextGradeThresholds;
    if (next == null) return '최고 등급에 도달했어요';
    final int bookDiff =
        (next.targetBooks - summary.totalBooks).clamp(0, next.targetBooks);
    final int secDiff = (next.targetSeconds - summary.totalSeconds)
        .clamp(0, next.targetSeconds);
    final int hours = secDiff ~/ 3600;
    return '다음 등급까지 $bookDiff권 · $hours시간 남음';
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.state, required this.accent});

  final HeatmapState state;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        boxShadow: theme.extension<AppShadows>()!.elevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '독서 캘린더',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                semanticsLabel: '독서 캘린더',
              ),
              Text(
                '최근 1년',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          switch (state) {
            HeatmapInitial() || HeatmapLoading() => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
            HeatmapError() => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.md),
                  child: Text(
                    '독서 캘린더를 불러오지 못했어요',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ),
            HeatmapLoaded(:final days) => JanDeeGrid(
                days: days,
                primaryColor: accent,
                onDayTap: (HeatmapDay day) => _showDaySheet(context, day),
              ),
          },
        ],
      ),
    );
  }

  void _showDaySheet(BuildContext context, HeatmapDay day) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${day.date.year}.${day.date.month.toString().padLeft(2, '0')}.${day.date.day.toString().padLeft(2, '0')}',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              day.totalSeconds == 0
                  ? '이 날은 기록이 없어요'
                  : '총 ${(day.totalSeconds ~/ 60)}분 · ${day.sessionCount}세션',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopActions extends StatelessWidget {
  const _TopActions({required this.onManual});

  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 4),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert_rounded),
        onSelected: (String value) {
          switch (value) {
            case 'manual':
              onManual();
              break;
            case 'goals':
              GoRouter.of(context).push('/goals');
              break;
          }
        },
        itemBuilder: (_) => const <PopupMenuEntry<String>>[
          PopupMenuItem<String>(value: 'manual', child: Text('수동 기록')),
          PopupMenuItem<String>(value: 'goals', child: Text('독서 목표')),
        ],
      ),
    );
  }
}
