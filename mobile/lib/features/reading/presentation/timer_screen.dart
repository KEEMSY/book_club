import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/feature_flags.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../ai_assistant/application/ai_audio_intro_service.dart';
import '../../ai_assistant/data/ai_repository.dart';
import '../../ai_assistant/presentation/ai_prep_card_sheet.dart';
import '../../curation/application/curation_providers.dart';
import '../../curation/domain/curation_card.dart';
import '../../feed/presentation/widgets/add_highlight_sheet.dart';
import '../application/grade_notifier.dart';
import '../application/grade_state.dart';
import '../application/heatmap_notifier.dart';
import '../application/reading_providers.dart';
import '../application/timer_notifier.dart';
import '../application/timer_state.dart';
import '../domain/bookmark.dart';
import 'session_summary_screen.dart';
import 'widgets/elapsed_formatter.dart';
import 'widgets/timer_controls.dart';
import 'widgets/timer_ring.dart';

/// `/reading/timer?user_book_id=<uuid>`.
///
/// Consumes the TimerNotifier state machine and renders a grade-accented
/// ring with elapsed-time readout. Lifecycle hooks wire the notifier's
/// `appBackgrounded`/`appResumed` path so the iOS 30-minute auto-end rule
/// triggers when the user closes the app mid-session.
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({
    super.key,
    required this.userBookId,
    this.bookId = '',
    this.autoStart = false,
    this.targetSeconds,
  });

  final String userBookId;

  /// Catalog book id (distinct from [userBookId]). Optional — when present the
  /// "읽기 전 AI 준비" entry point is shown. Threaded via the `book_id` query
  /// param so the AI prep card can call `/books/{bookId}/ai-prep-card`.
  final String bookId;
  final bool autoStart;

  /// When set the ring counts down from this duration and auto-ends at zero.
  final int? targetSeconds;

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with WidgetsBindingObserver {
  /// True while the AI audio intro is being fetched/started, so the 🔊 button
  /// shows a spinner and ignores repeat taps.
  bool _audioIntroLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Ensure the grade summary is available so the ring color matches the
    // user's current tier on first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradeNotifierProvider.notifier).load();
      if (widget.autoStart) {
        _startWithCurationCard();
      }
    });
  }

  /// Checks for a curation card and shows the sheet before starting the timer.
  /// When no card is available (or autoStart is false from a manual tap),
  /// this is also called from [TimerControls]'s onStart via [_handleStartTap].
  Future<void> _startWithCurationCard() async {
    if (!mounted) return;
    // The curation card API keys off the catalog book id, not the UserBook id.
    // Without a catalog id there is nothing to pre-fetch, so fall through to a
    // direct timer start instead of showing a card.
    final CurationCard? card = widget.bookId.isEmpty
        ? null
        // Read the already-cached result (pre-fetched in build).
        : ref
            .read(firstCurationCardProvider(bookId: widget.bookId))
            .valueOrNull;
    if (card != null && mounted) {
      final container = ProviderScope.containerOf(context);
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => UncontrolledProviderScope(
          container: container,
          child: _CurationCardSheet(
            card: card,
            onStart: () {
              Navigator.of(context).pop();
              ref.read(timerNotifierProvider.notifier).start(widget.userBookId);
            },
          ),
        ),
      );
      // If the sheet was dismissed without tapping "독서 시작하기" (e.g. drag
      // down), do not auto-start — leave the timer in idle state.
    } else {
      ref.read(timerNotifierProvider.notifier).start(widget.userBookId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Don't let an in-progress intro keep speaking after the screen is gone.
    ref.read(aiAudioIntroServiceProvider).stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final notifier = ref.read(timerNotifierProvider.notifier);
    if (lifecycle == AppLifecycleState.paused) {
      notifier.appBackgrounded();
    } else if (lifecycle == AppLifecycleState.resumed) {
      // Fire-and-forget; the state transition surfaces the summary modal when
      // an auto-end lands.
      notifier.appResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final state = ref.watch(timerNotifierProvider);
    final Color accent = ref.watch(gradePrimaryProvider);
    final Bookmark? bookmark = widget.userBookId.isNotEmpty
        ? ref.watch(latestBookmarkProvider(widget.userBookId)).valueOrNull
        : null;

    // Pre-fetch the curation card while the user is on the idle screen so it
    // is already in the provider cache when they tap "시작". Keyed by the
    // catalog book id (distinct from userBookId) — skip when it is absent.
    if (widget.bookId.isNotEmpty) {
      ref.watch(firstCurationCardProvider(bookId: widget.bookId));
    }

    // Auto-end when the countdown hits zero.
    if (widget.targetSeconds != null) {
      ref.listen<AsyncValue<DateTime>>(timerTickProvider, (_, tick) {
        final DateTime now = tick.valueOrNull ?? DateTime.now();
        final notifier = ref.read(timerNotifierProvider.notifier);
        final Duration elapsed = notifier.elapsedAt(now);
        final timerState = ref.read(timerNotifierProvider);
        if (timerState is TimerRunning &&
            elapsed.inSeconds >= widget.targetSeconds!) {
          notifier.end();
        }
      });
    }

    ref.listen<TimerState>(timerNotifierProvider, (prev, next) async {
      if (next is TimerCompleted) {
        final GoRouter router = GoRouter.of(context);

        // Free session (no book) — skip grade refresh, bookmark, and summary.
        if (next.completion.sessionId.isEmpty) {
          ref.read(timerNotifierProvider.notifier).acknowledgeCompletion();
          if (mounted) router.go('/home');
          return;
        }

        // Capture shields before the session completion is applied so the
        // summary screen can detect whether a shield was consumed.
        final GradeState gradeStateBefore = ref.read(gradeNotifierProvider);
        final int shieldsBefore = switch (gradeStateBefore) {
          GradeLoaded(:final summary) => summary.streakShields,
          _ => 0,
        };

        final gradeNotifier = ref.read(gradeNotifierProvider.notifier);
        gradeNotifier.applySessionCompletion(next.completion);
        ref
            .read(heatmapNotifierProvider(DateTime.now().year).notifier)
            .invalidate();

        final NavigatorState nav = Navigator.of(context);

        // Prompt the user to save a bookmark before showing the summary.
        final String userBookId = widget.userBookId;
        if (userBookId.isNotEmpty && mounted) {
          await _BookmarkSaveModal.show(
            context,
            ref: ref,
            userBookId: userBookId,
          );
        }

        if (!mounted) return;
        nav
            .push(
          MaterialPageRoute<void>(
            builder: (_) => SessionSummaryScreen(
              completion: next.completion,
              shieldsBefore: shieldsBefore,
            ),
          ),
        )
            .then((_) {
          ref.read(timerNotifierProvider.notifier).acknowledgeCompletion();
          if (mounted) {
            router.go('/home');
          }
          // Ask for an app-store review once the session is fully wrapped up
          // (summary dismissed). Fire-and-forget: the service decides whether
          // this session actually crosses the prompt threshold.
          _maybeRequestReview();
        });
      } else if (next is TimerFailure) {
        _showFailure(next);
      }
    });

    // canPop is true only while the timer is idle (not yet started).
    // Running/Paused → dialog; Ending → silently blocked until the API returns.
    final bool canPop = state is TimerIdle;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        if (state is TimerRunning || state is TimerPaused) {
          _showExitDialog(context);
        }
        // TimerEnding: block silently — let the in-flight API call finish.
      },
      child: Scaffold(
        // Let Scaffold inherit the theme's canvas so dark mode lands on #161616
        // instead of the pinned warm light Foggy.
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text('독서 타이머', style: theme.textTheme.titleMedium),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            child: Column(
              children: <Widget>[
                const Spacer(),
                _TimerReadout(
                  accent: accent,
                  state: state,
                  targetSeconds: widget.targetSeconds,
                ),
                const Spacer(),
                if (bookmark != null) ...<Widget>[
                  _BookmarkChip(bookmark: bookmark),
                  SizedBox(height: spacing.md),
                ],
                _StreakBadge(),
                if (widget.userBookId.isNotEmpty &&
                    (state is TimerRunning ||
                        state is TimerPaused)) ...<Widget>[
                  SizedBox(height: spacing.sm),
                  TextButton.icon(
                    icon: const Icon(Icons.format_quote_rounded, size: 18),
                    label: const Text('하이라이트 추가'),
                    onPressed: () => _showHighlightSheet(context),
                  ),
                ],
                if (FeatureFlags.aiAssistant &&
                    widget.bookId.isNotEmpty &&
                    state is! TimerRunning &&
                    state is! TimerPaused &&
                    state is! TimerEnding) ...<Widget>[
                  SizedBox(height: spacing.sm),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text('읽기 전 AI 준비'),
                        onPressed: () => AiPrepCardSheet.show(
                          context,
                          ref,
                          bookId: widget.bookId,
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      IconButton.filledTonal(
                        tooltip: '오디오로 듣기',
                        onPressed: _audioIntroLoading ? null : _playAudioIntro,
                        icon: _audioIntroLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('🔊', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: spacing.md),
                TimerControls(
                  state: state,
                  accent: accent,
                  onStart: _startWithCurationCard,
                  onPause: () =>
                      ref.read(timerNotifierProvider.notifier).pause(),
                  onResume: () =>
                      ref.read(timerNotifierProvider.notifier).resume(),
                  onEnd: () => _showExitDialog(context),
                ),
                SizedBox(height: spacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('독서를 중단할까요?'),
        content: const Text('종료하면 지금까지의 독서 시간이 기록돼요.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('계속 읽기'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('종료하기'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      ref.read(timerNotifierProvider.notifier).end();
    }
  }

  void _showHighlightSheet(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => UncontrolledProviderScope(
        container: container,
        child: AddHighlightSheet(userBookId: widget.userBookId),
      ),
    );
  }

  /// Fetches the AI audio intro for the catalog book and plays it via on-device
  /// TTS. Shows a spinner while the request is in flight; surfaces a snackbar on
  /// failure (rate limit / no AI key / network).
  Future<void> _playAudioIntro() async {
    setState(() => _audioIntroLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(aiAudioIntroServiceProvider).playIntro(widget.bookId);
    } on AiRepositoryException catch (e) {
      final String message = e.isRateLimited
          ? '오늘의 오디오 인트로를 모두 사용했어요. 내일 다시 만나요!'
          : e.isUnavailable
              ? 'AI 연결 안 됨\n잠시 후 다시 시도해주세요.'
              : e.message;
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _audioIntroLoading = false);
    }
  }

  /// Records the completed session with the review gate and lets it decide
  /// whether to surface the OS review sheet. Captured before any await so a
  /// disposed widget doesn't block the bookkeeping.
  Future<void> _maybeRequestReview() async {
    final service = ref.read(inAppReviewServiceProvider);
    final prefs = await SharedPreferences.getInstance();
    await service.onSessionCompleted(prefs);
  }

  void _showFailure(TimerFailure fail) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    // Tracks whether the user tapped "이어서 보기" so the auto-clear below
    // does not clobber the in-flight restoreFromServer() call.
    var restoreTriggered = false;
    messenger.showSnackBar(
      SnackBar(
        content: Text(_friendlyFailure(fail)),
        action: fail.code == 'ACTIVE_SESSION_EXISTS'
            ? SnackBarAction(
                label: '이어서 보기',
                onPressed: () async {
                  restoreTriggered = true;
                  await ref
                      .read(timerNotifierProvider.notifier)
                      .restoreFromServer();
                  if (!mounted) return;
                  final timerState = ref.read(timerNotifierProvider);
                  if (timerState is TimerRunning) {
                    context.pushReplacement(
                      AppRoutes.timer(timerState.userBookId),
                    );
                  }
                },
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
    Future<void>.delayed(const Duration(milliseconds: 400)).then((_) async {
      if (!mounted || restoreTriggered) return;
      await ref.read(timerNotifierProvider.notifier).clearFailure();
    });
  }

  String _friendlyFailure(TimerFailure fail) {
    switch (fail.code) {
      case 'ACTIVE_SESSION_EXISTS':
        return '이미 진행 중인 세션이 있어요';
      case 'SESSION_TOO_SHORT':
        return '세션이 너무 짧아요 (1초 이상 필요)';
      case 'USER_BOOK_NOT_FOUND':
        return '서재에 없는 책이에요';
      case 'UPSTREAM_UNAVAILABLE':
      case 'NETWORK_ERROR':
        return '잠시 후 다시 시도해주세요';
      default:
        return fail.message;
    }
  }
}

class _TimerReadout extends ConsumerWidget {
  const _TimerReadout({
    required this.accent,
    required this.state,
    this.targetSeconds,
  });

  final Color accent;
  final TimerState state;
  final int? targetSeconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final DateTime now =
        ref.watch(timerTickProvider).valueOrNull ?? DateTime.now();
    final notifier = ref.read(timerNotifierProvider.notifier);
    final Duration elapsed = notifier.elapsedAt(now);
    final bool indeterminate = state is TimerEnding;
    final bool paused = state is TimerPaused;

    // Countdown mode: ring fills elapsed/target, center shows remaining time.
    if (targetSeconds != null) {
      final int target = targetSeconds!;
      final double progress = (elapsed.inSeconds / target).clamp(0.0, 1.0);
      final Duration remaining =
          Duration(seconds: (target - elapsed.inSeconds).clamp(0, target));
      final bool done = elapsed.inSeconds >= target;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TimerRing(
            color: accent,
            progress: progress,
            indeterminate: indeterminate,
            paused: paused,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (paused)
                  Icon(
                    Icons.pause_rounded,
                    size: 28,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                Text(
                  formatElapsed(remaining),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: paused
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                        : theme.colorScheme.onSurface,
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
                Text(
                  paused ? '일시정지' : '남음',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (done) ...<Widget>[
            const SizedBox(height: 12),
            Chip(
              avatar: Icon(Icons.check_circle_rounded, size: 16, color: accent),
              label: const Text('목표 달성! 마무리해볼까요?'),
              labelStyle: theme.textTheme.labelMedium,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
            ),
          ],
        ],
      );
    }

    // Free mode: ring fills proportionally to daily goal.
    final int goalSeconds =
        ref.watch(dailyGoalSecondsProvider).valueOrNull ?? 1800;
    final double progress = (elapsed.inSeconds / goalSeconds).clamp(0.0, 1.0);
    final bool goalReached = elapsed.inSeconds >= goalSeconds;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TimerRing(
          color: accent,
          progress: progress,
          indeterminate: indeterminate,
          paused: paused,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (paused)
                Icon(
                  Icons.pause_rounded,
                  size: 28,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              Text(
                formatElapsed(elapsed),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: paused
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                      : theme.colorScheme.onSurface,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
              if (paused)
                Text(
                  '일시정지',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (goalReached && !paused) ...<Widget>[
          const SizedBox(height: 12),
          Chip(
            avatar: Icon(Icons.check_circle_rounded, size: 16, color: accent),
            label: const Text('오늘 목표 달성!'),
            labelStyle: theme.textTheme.labelMedium,
            backgroundColor: theme.colorScheme.surfaceContainerHigh,
          ),
        ],
      ],
    );
  }
}

class _StreakBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final grade = ref.watch(gradeNotifierProvider);
    final Color accent = ref.watch(gradePrimaryProvider);
    final int streak = switch (grade) {
      GradeLoaded(:final summary) => summary.streakDays,
      _ => 0,
    };
    if (streak <= 0) {
      return const SizedBox.shrink();
    }
    return Chip(
      avatar: Icon(
        Icons.local_fire_department_rounded,
        size: 18,
        color: accent,
      ),
      label: Text(
        '연속 $streak일 독서 중',
        style: theme.textTheme.labelMedium?.copyWith(color: accent),
      ),
      backgroundColor: accent.withValues(alpha: 0.1),
      side: BorderSide(color: accent.withValues(alpha: 0.25)),
    );
  }
}

/// Subtle chip shown on the idle timer screen when a previous bookmark exists.
class _BookmarkChip extends StatelessWidget {
  const _BookmarkChip({required this.bookmark});

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;

    final String label = bookmark.note != null && bookmark.note!.isNotEmpty
        ? '${bookmark.page}페이지 — "${bookmark.note}"'
        : '${bookmark.page}페이지에서 멈췄어요';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.bookmark_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet shown after a reading session ends. Lets the user record the
/// page they reached so the next session can resume from the right spot.
class _BookmarkSaveModal extends ConsumerStatefulWidget {
  const _BookmarkSaveModal({
    required this.userBookId,
    required this.messenger,
  });
  final String userBookId;
  final ScaffoldMessengerState messenger;

  static Future<void> show(
    BuildContext context, {
    required WidgetRef ref,
    required String userBookId,
  }) {
    final container = ProviderScope.containerOf(context);
    // Capture the ScaffoldMessenger from the caller's context so error
    // snackbars can be shown even after the sheet's own context is gone.
    final messenger = ScaffoldMessenger.of(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => UncontrolledProviderScope(
        container: container,
        child: _BookmarkSaveModal(
          userBookId: userBookId,
          messenger: messenger,
        ),
      ),
    );
  }

  @override
  ConsumerState<_BookmarkSaveModal> createState() => _BookmarkSaveModalState();
}

class _BookmarkSaveModalState extends ConsumerState<_BookmarkSaveModal> {
  final _pageCtrl = TextEditingController();
  bool _saving = false;
  String? _pageError;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final double bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.xl + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('책갈피 저장', style: theme.textTheme.titleLarge),
          SizedBox(height: spacing.xs),
          Text(
            '몇 페이지까지 읽었나요?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: spacing.md),
          TextField(
            controller: _pageCtrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '페이지 번호',
              suffixText: '페이지',
              border: const OutlineInputBorder(),
              errorText: _pageError,
            ),
            onChanged: (_) {
              if (_pageError != null) setState(() => _pageError = null);
            },
          ),
          SizedBox(height: spacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('건너뛰기'),
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('저장'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final int? page = int.tryParse(_pageCtrl.text.trim());
    if (page == null || page < 1) {
      setState(() => _pageError = '1 이상의 페이지 번호를 입력해주세요');
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(readingRepositoryProvider).createBookmark(
            userBookId: widget.userBookId,
            page: page,
          );
      // Invalidate so SessionSummaryScreen reads the freshly saved bookmark,
      // not the stale cached value from before this save.
      ref.invalidate(latestBookmarkProvider(widget.userBookId));
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      widget.messenger.showSnackBar(
        const SnackBar(content: Text('저장에 실패했습니다')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Curation card sheet
// ---------------------------------------------------------------------------

/// Maps a [CurationCard.cardType] string to a human-readable label and icon.
({IconData icon, String label}) _cardTypeMeta(String type) {
  return switch (type) {
    'intro' => (icon: Icons.person_rounded, label: '작가 소개'),
    'guide' => (icon: Icons.map_rounded, label: '독서 가이드'),
    'context' => (icon: Icons.history_edu_rounded, label: '배경 지식'),
    'quote' => (icon: Icons.format_quote_rounded, label: '인상적인 구절'),
    _ => (icon: Icons.auto_stories_rounded, label: '큐레이션'),
  };
}

/// Bottom sheet shown on timer screen entry when a curation card exists.
///
/// Displays the card content with a "독서 시작하기" CTA and a feedback row
/// ("도움이 됐어요 👍" / "건너뛰기", M67). Helpful keeps the sheet open with a
/// thanks state; skip records the reaction and dismisses the sheet. The reaction
/// feeds the backend deprioritization loop.
class _CurationCardSheet extends ConsumerStatefulWidget {
  const _CurationCardSheet({
    required this.card,
    required this.onStart,
  });

  final CurationCard card;

  /// Called when the user taps "독서 시작하기". The caller is responsible for
  /// closing the sheet (via [Navigator.pop]) before starting the timer.
  final VoidCallback onStart;

  @override
  ConsumerState<_CurationCardSheet> createState() => _CurationCardSheetState();
}

class _CurationCardSheetState extends ConsumerState<_CurationCardSheet> {
  bool _helpfulSent = false;

  Future<void> _sendFeedback(String action) {
    // Fire-and-forget: the repository swallows 404s, and a failed feedback
    // write must never block the reader from starting their session.
    return ref
        .read(curationRepositoryProvider)
        .postFeedback(widget.card.id, action);
  }

  void _onHelpful() {
    setState(() => _helpfulSent = true);
    _sendFeedback('helpful');
  }

  void _onSkip() {
    _sendFeedback('skip');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final double bottom = MediaQuery.viewInsetsOf(context).bottom;
    final meta = _cardTypeMeta(widget.card.cardType);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.xl + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Card type label row
          Row(
            children: <Widget>[
              Icon(
                meta.icon,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                meta.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          // Title
          Text(widget.card.title, style: theme.textTheme.titleLarge),
          SizedBox(height: spacing.sm),
          // Body
          Text(
            widget.card.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: spacing.sm),
          // Feedback row (M67)
          Row(
            children: <Widget>[
              TextButton.icon(
                icon: Icon(
                  _helpfulSent
                      ? Icons.check_circle_rounded
                      : Icons.thumb_up_alt_outlined,
                  size: 16,
                ),
                label: Text(_helpfulSent ? '고마워요!' : '도움이 됐어요 👍'),
                onPressed: _helpfulSent ? null : _onHelpful,
              ),
              const Spacer(),
              TextButton(
                onPressed: _onSkip,
                child: const Text('건너뛰기'),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          // CTA
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.menu_book_rounded, size: 18),
              label: const Text('독서 시작하기'),
              onPressed: widget.onStart,
            ),
          ),
        ],
      ),
    );
  }
}
