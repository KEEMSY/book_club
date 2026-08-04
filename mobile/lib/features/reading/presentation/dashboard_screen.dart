import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/feature_flags.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../experiment/application/experiment_providers.dart';
import '../../experiment/domain/user_experiments.dart';
import '../../subscription/application/subscription_notifier.dart';
import '../../subscription/presentation/widgets/trial_banner.dart';
import '../../book/presentation/widgets/book_cover.dart';
import '../data/reading_models.dart'
    show DailySessionDto, DailySessionsResponseDto;
import '../../auth/domain/auth_state.dart';
import '../../book/application/book_providers.dart';
import '../../book/application/book_search_notifier.dart';
import '../../book/application/book_search_state.dart';
import '../../book/application/library_notifier.dart';
import '../../book/application/library_state.dart';
import '../../book/data/book_repository.dart';
import '../../book/domain/book.dart';
import '../../book/domain/book_status.dart';
import '../../book/domain/user_book.dart';
import '../application/dashboard_prefs_notifier.dart';
import '../application/goal_notifier.dart';
import '../application/goal_state.dart';
import '../application/grade_notifier.dart';
import '../application/grade_state.dart';
import '../application/heatmap_notifier.dart';
import '../application/heatmap_state.dart';
import '../application/reading_providers.dart';
import '../application/timer_notifier.dart';
import '../application/timer_state.dart';
import '../domain/dashboard_prefs.dart';
import '../domain/goal_period.dart';
import '../domain/grade_summary.dart';
import '../domain/heatmap_day.dart';
import '../domain/reading_goal.dart';
import '../domain/reading_year_stats.dart';
import '../../retention/application/retention_providers.dart';
import '../../retention/data/retention_repository.dart';
import 'dashboard_settings_sheet.dart';
import 'widgets/daily_total_card.dart';
import 'widgets/dashboard_goal_card.dart';
import 'widgets/grade_badge.dart';
import 'widgets/jan_dee_grid.dart';
import 'widgets/manual_log_modal.dart';
import 'widgets/recap_banner.dart';
import 'widgets/streak_card.dart';
import '../../notification/presentation/notification_screen.dart';

/// `/home` — the post-login landing.
///
/// Sections:
///   1. Greeting headline.
///   2. DailyTotalCard — "오늘 N분 읽음" + mini progress vs. weekly goal slice.
///   3. StreakCard.
///   4. Compact GradeBadge + "다음 등급까지" line.
///   5. 52×7 Jan-dee heatmap.
///   6. "지금 읽기 시작" pill FAB.
/// User's choice in the active-session confirmation dialog (BC-39).
enum _ActiveSessionAction { resume, endAndStart, cancel }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _loadsStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If auth is already settled (e.g. token rehydrated before first frame),
      // fire immediately; otherwise the ref.listen in build() will pick it up.
      _tryStartLoads();
    });
  }

  void _tryStartLoads() {
    if (_loadsStarted) return;
    final auth = ref.read(authNotifierProvider);
    if (auth is! Authenticated) return;
    _loadsStarted = true;
    ref.read(gradeNotifierProvider.notifier).load();
    ref.read(heatmapNotifierProvider(DateTime.now().year).notifier).load();
    ref.read(goalNotifierProvider.notifier).load();
    ref.read(libraryNotifierProvider.notifier).ensureLoaded(BookStatus.reading);
    // Restore any active session that survived an app restart.
    ref.read(timerNotifierProvider.notifier).restore();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);
    final GradeState gradeState = ref.watch(gradeNotifierProvider);
    final HeatmapState heatmapState = ref.watch(
      heatmapNotifierProvider(DateTime.now().year),
    );
    final GoalState goalState = ref.watch(goalNotifierProvider);
    final AuthState authState = ref.watch(authNotifierProvider);
    // Bootstrap completes asynchronously — fire loads once auth settles.
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next is Authenticated) _tryStartLoads();
    });
    final DashboardPrefs prefs = ref.watch(dashboardPrefsNotifierProvider);
    final String? nickname =
        authState is Authenticated ? authState.user.nickname : null;
    final String? userId =
        authState is Authenticated ? authState.user.id : null;
    final String? profileImageUrl =
        authState is Authenticated ? authState.user.profileImageUrl : null;

    final int? weeklyGoalSeconds =
        goalState is GoalLoaded ? _weeklyGoal(goalState) : null;
    final int todaySeconds = _todaySeconds(heatmapState);
    final List<GoalProgress> goalItems =
        goalState is GoalLoaded ? goalState.items : const <GoalProgress>[];

    // Bottom safe-area height so the floating read button sits above the home
    // indicator on iPhone or the nav bar on Android.
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            color: accent,
            onRefresh: () async {
              ref.invalidate(yearStatsProvider(DateTime.now().year));
              await Future.wait<void>(<Future<void>>[
                ref.read(gradeNotifierProvider.notifier).refresh(),
                ref
                    .read(heatmapNotifierProvider(DateTime.now().year).notifier)
                    .invalidate(),
                ref.read(goalNotifierProvider.notifier).refresh(),
              ]);
            },
            child: ListView(
              // Bottom padding = button height (56) + gap (16) + safe-area so
              // the last card is never hidden behind the floating button.
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.md,
                spacing.lg,
                56 + 16 + bottomInset + spacing.lg,
              ),
              children: <Widget>[
                _Header(
                  nickname: nickname,
                  userId: userId,
                  profileImageUrl: profileImageUrl,
                  onManual: _onManualLog,
                ),
                SizedBox(height: spacing.lg),
                // Pro free-trial nudge — renders nothing unless the user is
                // mid-trial, so it sits silently above the sections otherwise.
                // Deferred (BC-19): hidden entirely while subscription is off.
                if (FeatureFlags.subscription) const TrialBanner(),
                // RecapBanner returns SizedBox.shrink outside June / December,
                // so no extra spacing guard is needed.
                const RecapBanner(),
                const _RecapBannerSpacer(),
                DailyTotalCard(
                  todaySeconds: todaySeconds,
                  weeklyGoalSeconds: weeklyGoalSeconds,
                  accent: accent,
                ),
                SizedBox(height: spacing.md),
                _YearStatsCard(
                  accent: accent,
                  onTap: () => _onStatsTap(context),
                ),
                SizedBox(height: spacing.md),
                // Render toggleable sections in user-defined order.
                for (final String sectionId in prefs.sectionOrder) ...<Widget>[
                  if (sectionId == 'streak' && prefs.showStreak) ...<Widget>[
                    _StreakCardWithRecovery(
                      streak: _streak(gradeState),
                      longest: _longest(gradeState),
                    ),
                    SizedBox(height: spacing.md),
                  ],
                  if (sectionId == 'goal' && prefs.showGoal) ...<Widget>[
                    DashboardGoalCard(
                      items: goalItems,
                      accent: accent,
                      onAddGoal: () => GoRouter.of(context).push('/goals'),
                    ),
                    SizedBox(height: spacing.md),
                  ],
                  if (sectionId == 'grade' && prefs.showGrade) ...<Widget>[
                    _GradeRow(state: gradeState, accent: accent),
                    SizedBox(height: spacing.md),
                  ],
                  if (sectionId == 'heatmap' && prefs.showHeatmap) ...<Widget>[
                    _HeatmapCard(accent: accent),
                    SizedBox(height: spacing.md),
                  ],
                ],
              ],
            ),
          ),
          // Floating "지금 읽기 시작" button — always visible regardless of
          // scroll position. Positioned above the system home indicator.
          Positioned(
            left: spacing.lg,
            right: spacing.lg,
            bottom: bottomInset + spacing.md,
            child: _StartReadingButton(
              accent: accent,
              onPressed: () => _startReading(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the reading stats screen, gated by the paywall_entry_v1
  /// A/B experiment when the user is not yet Pro.
  ///
  /// stats_tab variant: non-Pro users are redirected to the paywall on tap.
  /// All other variants (or no assignment): stats screen opens directly.
  void _onStatsTap(BuildContext context) {
    // Deferred (BC-19): skip the A/B lookup when the experiment feature is off
    // so a null variant falls through to opening the stats screen directly.
    final variant = FeatureFlags.experiment
        ? ref
            .read(userExperimentsProvider)
            .valueOrNull
            ?.variantFor('paywall_entry_v1')
        : null;

    if (variant == 'stats_tab') {
      final subAsync = ref.read(subscriptionNotifierProvider);
      final isPro = subAsync.valueOrNull?.isPro ?? false;
      if (!isPro) {
        GoRouter.of(context).push(AppRoutes.paywall);
        return;
      }
    }
    GoRouter.of(context).push(AppRoutes.readingStats);
  }

  Future<void> _startReading(BuildContext context) async {
    if (!mounted) return;
    // Capture the router before the async gap to avoid BuildContext warnings.
    final GoRouter router = GoRouter.of(context);

    // Pre-check (BC-39): if a reading session is already in progress, confirm
    // before starting a new one. Otherwise the new start hits a backend 409
    // (ACTIVE_SESSION_EXISTS) and the user only learns after navigating in.
    final TimerState timerState = ref.read(timerNotifierProvider);
    final bool hasActiveSession = timerState is TimerRunning ||
        timerState is TimerPaused ||
        timerState is TimerEnding;
    if (hasActiveSession) {
      final _ActiveSessionAction? action = await _showActiveSessionDialog(
        context,
      );
      if (!mounted || action == null || action == _ActiveSessionAction.cancel) {
        return;
      }
      if (action == _ActiveSessionAction.resume) {
        // Resume: the timer screen renders the global running state, no params.
        router.push('/reading/timer');
        return;
      }
      // endAndStart: end the current session (elapsed time is still recorded),
      // then fall through to the normal new-session flow.
      final TimerNotifier notifier = ref.read(timerNotifierProvider.notifier);
      await notifier.end();
      if (!mounted) return;
      if (ref.read(timerNotifierProvider) is TimerFailure) {
        // End failed (e.g. network) — abort so we never open two sessions.
        return;
      }
      notifier.acknowledgeCompletion();
    }

    if (!context.mounted) return;
    // null → cancelled; ('', null) → free session, no limit; ('id', 1800) → book + countdown.
    final (String, int?)? result = await _StartReadingSheet.show(
      context,
      ref: ref,
    );
    if (result == null) return;
    if (!mounted) return;
    final (String targetId, int? targetSec) = result;
    final List<String> params = <String>['auto_start=true'];
    if (targetId.isNotEmpty) params.add('user_book_id=$targetId');
    if (targetSec != null) params.add('target_seconds=$targetSec');
    router.push('/reading/timer?${params.join('&')}');
  }

  /// Confirmation shown when "지금 읽기 시작" is tapped while a session is
  /// already in progress (BC-39). Lets the user resume it, end it and start a
  /// new one, or cancel.
  Future<_ActiveSessionAction?> _showActiveSessionDialog(BuildContext context) {
    return showDialog<_ActiveSessionAction>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('진행 중인 독서가 있어요'),
        content: const Text('지금 읽던 세션을 이어서 볼까요, 아니면 종료하고 새로 시작할까요?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(_ActiveSessionAction.cancel),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(_ActiveSessionAction.endAndStart),
            child: const Text('종료하고 새로 시작'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(_ActiveSessionAction.resume),
            child: const Text('이어서 보기'),
          ),
        ],
      ),
    );
  }

  Future<void> _onManualLog() async {
    final readingMap = ref.read(libraryNotifierProvider);
    final readingState = readingMap[BookStatus.reading];
    final List<UserBook> reading =
        readingState is LibraryListLoaded ? readingState.items : <UserBook>[];
    if (reading.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('서재에 읽는 중인 책이 없어요')));
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

/// Emits a spacing gap only when [RecapBanner] is visible (June / December).
/// Avoids an orphan gap during the other 10 months.
class _RecapBannerSpacer extends StatelessWidget {
  const _RecapBannerSpacer();

  @override
  Widget build(BuildContext context) {
    final int month = DateTime.now().month;
    if (month != 6 && month != 12) return const SizedBox.shrink();
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return SizedBox(height: spacing.md);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.nickname,
    required this.userId,
    required this.profileImageUrl,
    required this.onManual,
  });

  final String? nickname;
  final String? userId;
  final String? profileImageUrl;
  final VoidCallback onManual;

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
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
          ),
        ),
        const NotificationBell(),
        _TopActions(onManual: onManual),
        if (userId != null) ...<Widget>[
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => context.push(AppRoutes.userProfile(userId!)),
            child: _ProfileAvatar(
              profileImageUrl: profileImageUrl,
              nickname: nickname,
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.profileImageUrl, required this.nickname});

  final String? profileImageUrl;
  final String? nickname;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String initial =
        (nickname != null && nickname!.isNotEmpty) ? nickname![0] : '?';
    return CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundImage: profileImageUrl != null
          ? CachedNetworkImageProvider(profileImageUrl!)
          : null,
      child: Text(
        initial,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
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
          border: Border.all(color: theme.colorScheme.outlineVariant),
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
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.72,
                      ),
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
      GradeLoaded(:final summary) => GradeBadge(
          grade: summary.readerGrade,
          tier: summary.tier,
          size: 64,
        ),
      GradeLoading() => const GradeBadge.placeholder(size: 64, shimmer: true),
      GradeInitial() || GradeError() => const GradeBadge.placeholder(size: 64),
    };
  }

  String _title(GradeState state) {
    if (state is GradeLoaded) {
      final String name = switch (state.summary.grade) {
        1 => '새싹 독자',
        2 => '탐독자',
        3 => '애독자',
        4 => '열혈 독자',
        5 => '서재 마스터',
        _ => '나의 등급',
      };
      // 마스터 등급은 tier 표시 없음
      if (state.summary.grade < 5 && state.summary.tier > 1) {
        final String roman = const <int, String>{
              1: 'I',
              2: 'II',
              3: 'III',
            }[state.summary.tier] ??
            'I';
        return '$name $roman';
      }
      return name;
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
    final int bookDiff = (next.targetBooks - summary.totalBooks).clamp(
      0,
      next.targetBooks,
    );
    final int secDiff = (next.targetSeconds - summary.totalSeconds).clamp(
      0,
      next.targetSeconds,
    );
    final int hours = secDiff ~/ 3600;
    // tier가 1보다 크면 아직 같은 등급 내 구간을 이동 중
    final String label = summary.tier > 1 ? '다음 구간까지' : '다음 등급까지';
    return '$label $bookDiff권 · $hours시간 남음';
  }
}

class _HeatmapCard extends ConsumerStatefulWidget {
  const _HeatmapCard({required this.accent});

  final Color accent;

  @override
  ConsumerState<_HeatmapCard> createState() => _HeatmapCardState();
}

class _HeatmapCardState extends ConsumerState<_HeatmapCard> {
  static final int _minYear = 2020;
  late int _year = DateTime.now().year;

  void _changeYear(int year) {
    setState(() => _year = year);
    // Trigger load for this year if it hasn't been fetched yet.
    ref.read(heatmapNotifierProvider(year).notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final HeatmapState state = ref.watch(heatmapNotifierProvider(_year));
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final int thisYear = DateTime.now().year;
    final Color mutedColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.72,
    );
    final Color disabledColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.24,
    );

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
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
              // Year navigation: ← 2025년 →
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      icon: Icon(
                        Icons.chevron_left,
                        color: _year > _minYear ? mutedColor : disabledColor,
                      ),
                      onPressed: _year > _minYear
                          ? () => _changeYear(_year - 1)
                          : null,
                      tooltip: '이전 연도',
                    ),
                  ),
                  Text(
                    '$_year년',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: mutedColor,
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      icon: Icon(
                        Icons.chevron_right,
                        color: _year < thisYear ? mutedColor : disabledColor,
                      ),
                      onPressed: _year < thisYear
                          ? () => _changeYear(_year + 1)
                          : null,
                      tooltip: '다음 연도',
                    ),
                  ),
                ],
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
                      color: mutedColor,
                    ),
                  ),
                ),
              ),
            HeatmapLoaded(:final days) => JanDeeGrid(
                days: days,
                year: _year,
                primaryColor: widget.accent,
                onDayTap: (HeatmapDay day) => _showDaySheet(context, day),
              ),
          },
        ],
      ),
    );
  }

  void _showDaySheet(BuildContext context, HeatmapDay day) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _DayDetailSheet(day: day),
    );
  }
}

/// Bottom sheet that fetches and displays session + book detail for a heatmap day.
class _DayDetailSheet extends ConsumerWidget {
  const _DayDetailSheet({required this.day});

  final HeatmapDay day;

  String get _dateKey => '${day.date.year}-'
      '${day.date.month.toString().padLeft(2, '0')}-'
      '${day.date.day.toString().padLeft(2, '0')}';

  String get _dateLabel =>
      '${day.date.year}.${day.date.month.toString().padLeft(2, '0')}.${day.date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(dailySessionsProvider(_dateKey));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(_dateLabel, style: theme.textTheme.titleLarge),
              ),
            ),
            switch (async) {
              AsyncLoading() => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              AsyncError(:final error) => SliverFillRemaining(
                  child: Center(
                    child: Text(
                      '불러오지 못했어요\n$error',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
              AsyncData(:final value) => value.sessions.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          '이 날은 기록이 없어요',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : SliverList.separated(
                      itemCount: value.sessions.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return _SummaryRow(data: value, theme: theme);
                        }
                        return _SessionRow(
                          session: value.sessions[i - 1],
                          theme: theme,
                        );
                      },
                    ),
              _ => const SliverToBoxAdapter(child: SizedBox.shrink()),
            },
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.data, required this.theme});

  final DailySessionsResponseDto data;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final int minutes = data.totalSeconds ~/ 60;
    final String label = minutes >= 60
        ? '총 ${minutes ~/ 60}시간 ${minutes % 60}분 · ${data.sessions.length}세션'
        : '총 $minutes분 · ${data.sessions.length}세션';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: theme.textTheme.bodyLarge),
        const Divider(height: 24),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session, required this.theme});

  final DailySessionDto session;
  final ThemeData theme;

  String _durationLabel() {
    final int m = session.durationSec ~/ 60;
    if (m >= 60) return '${m ~/ 60}시간 ${m % 60}분';
    return '$m분';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        BookCover(coverUrl: session.bookCoverUrl, width: 40, height: 56),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                session.bookTitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                session.bookAuthor,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _durationLabel(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Wraps [StreakCard] with streak recovery awareness.
///
/// Watches [streakRecoveryStatusProvider] and, when [streak] is 0 and the
/// user still has recovery tokens, exposes a "스트릭 복구하기" button. On
/// confirmation it calls `POST /me/streak/recover` and invalidates the grade
/// and recovery-status providers so the dashboard refreshes automatically.
class _StreakCardWithRecovery extends ConsumerWidget {
  const _StreakCardWithRecovery({required this.streak, required this.longest});

  final int streak;
  final int longest;

  Future<void> _recover(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(retentionRepositoryProvider).recoverStreak();
      // Refresh grade (streak count) and recovery status.
      ref.invalidate(gradeNotifierProvider);
      ref.invalidate(streakRecoveryStatusProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('스트릭이 복구되었어요!')));
      }
    } on RetentionRepositoryException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only fetch recovery status when the streak is broken — avoids
    // unnecessary network requests for users actively maintaining their streak.
    bool canRecover = false;
    int remaining = 0;

    // Deferred (BC-19): the streak-recovery entry point is hidden while the
    // retention feature is off, so no recovery status is fetched.
    if (streak == 0 && FeatureFlags.retention) {
      final recoveryAsync = ref.watch(streakRecoveryStatusProvider);
      canRecover = recoveryAsync.valueOrNull?.canRecover ?? false;
      remaining = recoveryAsync.valueOrNull?.recoveriesRemaining ?? 0;
    }

    return StreakCard(
      streak: streak,
      longest: longest,
      canRecover: canRecover,
      recoveriesRemaining: remaining,
      onRecover: canRecover ? () => _recover(context, ref) : null,
    );
  }
}

class _TopActions extends StatelessWidget {
  const _TopActions({required this.onManual});

  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (String value) {
        switch (value) {
          case 'manual':
            onManual();
          case 'goals':
            GoRouter.of(context).push('/goals');
          case 'settings':
            showModalBottomSheet<void>(
              context: context,
              builder: (_) => const DashboardSettingsSheet(),
              isScrollControlled: true,
              useSafeArea: true,
            );
        }
      },
      itemBuilder: (_) => const <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: 'manual', child: Text('수동 기록')),
        PopupMenuItem<String>(value: 'goals', child: Text('독서 목표')),
        PopupMenuItem<String>(value: 'settings', child: Text('홈 설정')),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 연간 독서 통계 카드
// ---------------------------------------------------------------------------

class _YearStatsCard extends ConsumerWidget {
  const _YearStatsCard({required this.accent, this.onTap});

  final Color accent;

  /// Optional tap handler — used by paywall_entry_v1 A/B gate.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final int year = DateTime.now().year;
    final AsyncValue<ReadingYearStats> async = ref.watch(
      yearStatsProvider(year),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.all(Radius.circular(radii.lg)),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: theme.extension<AppShadows>()!.elevated,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$year년 독서 여정',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacing.md),
            async.when(
              loading: () => const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (_, __) => Row(
                children: <Widget>[
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '통계를 불러오지 못했어요',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(yearStatsProvider(year)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
              data: (ReadingYearStats stats) => Row(
                children: <Widget>[
                  Expanded(
                    child: _YearStatItem(
                      label: '완독한 책',
                      value: '${stats.yearBooks}권',
                      accent: accent,
                    ),
                  ),
                  Expanded(
                    child: _YearStatItem(
                      label: '읽은 시간',
                      value: _fmtHours(stats.yearSeconds),
                      accent: accent,
                    ),
                  ),
                  Expanded(
                    child: _YearStatItem(
                      label: '최장 연속',
                      value: '${stats.longestStreak}일',
                      accent: accent,
                    ),
                  ),
                  if (stats.yearBestDaySeconds != null)
                    Expanded(
                      child: _YearStatItem(
                        label: '하루 최고',
                        value: _fmtMinutes(stats.yearBestDaySeconds!),
                        accent: accent,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtHours(int sec) {
    final double h = sec / 3600;
    if (h >= 1) return '${h.toStringAsFixed(1)}h';
    return '${sec ~/ 60}분';
  }

  String _fmtMinutes(int sec) {
    final int m = sec ~/ 60;
    if (m >= 60) return '${m ~/ 60}h ${m % 60}m';
    return '$m분';
  }
}

class _YearStatItem extends StatelessWidget {
  const _YearStatItem({
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Pill-shaped "지금 읽기 시작" button pinned at the bottom of the dashboard.
///
/// Lives outside the scroll view so it stays visible at all scroll positions.
/// The blur + semi-transparent backdrop prevents the button from visually
/// clashing with list content that scrolls beneath it.
class _StartReadingButton extends StatelessWidget {
  const _StartReadingButton({required this.accent, required this.onPressed});

  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.play_arrow_rounded, size: 22),
        label: const Text('지금 읽기 시작'),
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 4,
          shadowColor: accent.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

/// Bottom sheet shown when the user taps "지금 읽기 시작". Lets the user pick
/// a book (or free session) and an optional countdown duration.
///
/// Watches [libraryNotifierProvider] directly so books appear even when the
/// initial load races with the user tapping the button.
class _StartReadingSheet extends ConsumerStatefulWidget {
  const _StartReadingSheet();

  static Future<(String, int?)?> show(
    BuildContext context, {
    required WidgetRef ref,
  }) {
    final container = ProviderScope.containerOf(context);
    return showModalBottomSheet<(String, int?)>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => UncontrolledProviderScope(
        container: container,
        child: const _StartReadingSheet(),
      ),
    );
  }

  @override
  ConsumerState<_StartReadingSheet> createState() => _StartReadingSheetState();
}

class _StartReadingSheetState extends ConsumerState<_StartReadingSheet> {
  // null = 자유롭게 (no limit)
  int? _targetSec;
  bool _customMode = false;
  final TextEditingController _customCtrl = TextEditingController();
  String? _customError;

  bool _showSearch = false;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _addingBookId;

  @override
  void initState() {
    super.initState();
    // Kick off loading if not yet started. The build method watches the state
    // reactively, so books appear as soon as the fetch completes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(libraryNotifierProvider.notifier)
          .ensureLoaded(BookStatus.reading);
    });
  }

  static const List<(String label, int? seconds)> _presets = <(String, int?)>[
    ('자유롭게', null),
    ('15분', 15 * 60),
    ('30분', 30 * 60),
    ('45분', 45 * 60),
    ('1시간', 60 * 60),
  ];

  @override
  void dispose() {
    _customCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectSearchBook(Book book) async {
    if (_addingBookId != null) return;
    setState(() => _addingBookId = book.id);
    try {
      final repo = ref.read(bookRepositoryProvider);
      final UserBook added = await repo.addToLibrary(
        book.id,
        status: BookStatus.reading,
      );
      ref.read(libraryNotifierProvider.notifier).refresh(BookStatus.reading);
      if (mounted) Navigator.of(context).pop((added.id, _targetSec));
    } on BookRepositoryException catch (e) {
      if (e.code == 'BOOK_ALREADY_IN_LIBRARY') {
        final UserBook? existing = _findInLibrary(book.id);
        if (existing != null && mounted) {
          Navigator.of(context).pop((existing.id, _targetSec));
          return;
        }
      }
      if (mounted) setState(() => _addingBookId = null);
    }
  }

  UserBook? _findInLibrary(String bookId) {
    for (final state in ref.read(libraryNotifierProvider).values) {
      if (state is LibraryListLoaded) {
        for (final ub in state.items) {
          if (ub.book.id == bookId) return ub;
        }
      }
    }
    return null;
  }

  Widget _buildSearchResults(ThemeData theme, AppSpacing spacing) {
    final searchState = ref.watch(bookSearchNotifierProvider);
    return switch (searchState) {
      BookSearchIdle() => const SizedBox.shrink(),
      BookSearchLoading() => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      BookSearchError(:final message) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      BookSearchLoaded(:final items) => ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 260),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length > 5 ? 5 : items.length,
            itemBuilder: (_, i) {
              final Book book = items[i];
              final bool isAdding = _addingBookId == book.id;
              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: spacing.xs),
                leading: BookCover(
                  coverUrl: book.coverUrl,
                  width: 36,
                  borderRadius: BorderRadius.circular(4),
                ),
                title: Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                trailing: isAdding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : FilledButton.tonal(
                        onPressed: _addingBookId == null
                            ? () => _selectSearchBook(book)
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('시작'),
                      ),
                onTap: _addingBookId == null
                    ? () => _selectSearchBook(book)
                    : null,
              );
            },
          ),
        ),
    };
  }

  void _selectPreset(int? sec) {
    setState(() {
      _targetSec = sec;
      _customMode = false;
      _customError = null;
    });
  }

  void _enableCustomMode() {
    setState(() {
      _customMode = true;
      _targetSec = null;
      _customError = null;
    });
  }

  void _onCustomChanged(String value) {
    final int? minutes = int.tryParse(value.trim());
    setState(() {
      if (value.trim().isEmpty) {
        _targetSec = null;
        _customError = null;
      } else if (minutes == null || minutes < 1) {
        _targetSec = null;
        _customError = '1분 이상 입력해주세요';
      } else if (minutes > 480) {
        _targetSec = null;
        _customError = '480분(8시간) 이하로 입력해주세요';
      } else {
        _targetSec = minutes * 60;
        _customError = null;
      }
    });
  }

  void _start(String bookId) => Navigator.of(context).pop((bookId, _targetSec));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);
    // keyboard inset so the sheet lifts above the keyboard
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    final libraryMap = ref.watch(libraryNotifierProvider);
    final readingState = libraryMap[BookStatus.reading];
    final bool isLoading = readingState is LibraryListLoading ||
        readingState is LibraryListInitial;
    final List<UserBook> books =
        readingState is LibraryListLoaded ? readingState.items : <UserBook>[];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.xl + keyboardInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            books.isEmpty && !isLoading ? '읽기를 시작할게요' : '어떤 책을 읽을까요?',
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: spacing.md),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (books.isEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: Text(
                '서재에 읽는 중인 책이 없어요.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            )
          else ...<Widget>[
            ...books.map(
              (book) => _BookTile(book: book, onTap: () => _start(book.id)),
            ),
          ],
          // ── Book search ──────────────────────────────────────────────────
          if (!_showSearch) ...<Widget>[
            TextButton.icon(
              onPressed: () => setState(() => _showSearch = true),
              icon: const Icon(Icons.search_rounded, size: 18),
              label: const Text('다른 책 찾기'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ] else ...<Widget>[
            SizedBox(height: spacing.sm),
            TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '책 제목, 저자 검색',
                prefixIcon: Icon(Icons.search_rounded, size: 20),
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onChanged: (v) =>
                  ref.read(bookSearchNotifierProvider.notifier).queryChanged(v),
            ),
            _buildSearchResults(theme, spacing),
            SizedBox(height: spacing.xs),
          ],
          Divider(height: spacing.lg),
          // ---------- Duration picker ----------
          Text('얼마나 읽을까요?', style: theme.textTheme.titleSmall),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.xs,
            children: <Widget>[
              ..._presets.map((preset) {
                final (String label, int? sec) = preset;
                final bool selected = !_customMode && _targetSec == sec;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  selectedColor: accent,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (_) => _selectPreset(sec),
                );
              }),
              ChoiceChip(
                label: const Text('직접 입력'),
                selected: _customMode,
                selectedColor: accent,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: _customMode
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: _customMode ? FontWeight.w600 : FontWeight.normal,
                ),
                onSelected: (_) => _enableCustomMode(),
              ),
            ],
          ),
          if (_customMode) ...<Widget>[
            SizedBox(height: spacing.sm),
            TextField(
              controller: _customCtrl,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '분 단위로 입력',
                suffixText: '분',
                isDense: true,
                border: const OutlineInputBorder(),
                errorText: _customError,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onChanged: _onCustomChanged,
            ),
          ],
          SizedBox(height: spacing.lg),
          // ---------- Free-session button ----------
          // Primary when there are no books (only action); outlined/secondary otherwise.
          SizedBox(
            width: double.infinity,
            child: books.isEmpty
                ? FilledButton.icon(
                    onPressed: () => _start(''),
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    label: const Text('바로 시작하기'),
                  )
                : OutlinedButton.icon(
                    onPressed: () => _start(''),
                    icon: const Icon(
                      Icons.play_circle_outline_rounded,
                      size: 18,
                    ),
                    label: const Text('책 없이 시작하기'),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BookTile extends ConsumerWidget {
  const _BookTile({required this.book, required this.onTap});
  final UserBook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bookmarkAsync = ref.watch(latestBookmarkProvider(book.id));
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: spacing.xs),
      title: Text(book.book.title, style: theme.textTheme.bodyLarge),
      subtitle: bookmarkAsync.when(
        data: (bm) => bm != null
            ? Text(
                '${bm.page}페이지에서 멈췄어요',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              )
            : null,
        loading: () => null,
        error: (_, __) => null,
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
