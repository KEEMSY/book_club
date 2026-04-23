import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/grade_notifier.dart';
import '../application/grade_state.dart';
import '../application/heatmap_notifier.dart';
import '../application/reading_providers.dart';
import '../application/timer_notifier.dart';
import '../application/timer_state.dart';
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
  const TimerScreen({super.key, required this.userBookId});

  final String userBookId;

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Ensure the grade summary is available so the ring color matches the
    // user's current tier on first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradeNotifierProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

    ref.listen<TimerState>(timerNotifierProvider, (prev, next) {
      if (next is TimerCompleted) {
        final gradeNotifier = ref.read(gradeNotifierProvider.notifier);
        gradeNotifier.applySessionCompletion(next.completion);
        ref.read(heatmapNotifierProvider.notifier).invalidate();
        // Push the summary screen, then pop back to the dashboard once the
        // user acknowledges.
        final NavigatorState nav = Navigator.of(context);
        final GoRouter router = GoRouter.of(context);
        nav
            .push(
          MaterialPageRoute<void>(
            builder: (_) => SessionSummaryScreen(completion: next.completion),
          ),
        )
            .then((_) {
          ref.read(timerNotifierProvider.notifier).acknowledgeCompletion();
          if (mounted) {
            router.go('/home');
          }
        });
      } else if (next is TimerFailure) {
        _showFailure(next);
      }
    });

    return Scaffold(
      backgroundColor: AppPalette.foggy,
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
              _TimerReadout(accent: accent, state: state),
              const Spacer(),
              _StreakBadge(),
              SizedBox(height: spacing.xl),
              TimerControls(
                state: state,
                accent: accent,
                onStart: () => ref
                    .read(timerNotifierProvider.notifier)
                    .start(widget.userBookId),
                onPause: () => ref.read(timerNotifierProvider.notifier).pause(),
                onResume: () =>
                    ref.read(timerNotifierProvider.notifier).resume(),
                onEnd: () => ref.read(timerNotifierProvider.notifier).end(),
              ),
              SizedBox(height: spacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  void _showFailure(TimerFailure fail) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(_friendlyFailure(fail)),
        action: fail.code == 'ACTIVE_SESSION_EXISTS'
            ? SnackBarAction(
                label: '이어서 보기',
                onPressed: () {
                  ref.read(timerNotifierProvider.notifier).clearFailure();
                },
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
    // Clear the failure after showing so the UI returns to Idle state.
    Future<void>.delayed(const Duration(milliseconds: 400)).then((_) {
      if (!mounted) return;
      ref.read(timerNotifierProvider.notifier).clearFailure();
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
  const _TimerReadout({required this.accent, required this.state});

  final Color accent;
  final TimerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final DateTime now =
        ref.watch(timerTickProvider).valueOrNull ?? DateTime.now();
    final notifier = ref.read(timerNotifierProvider.notifier);
    final Duration elapsed = notifier.elapsedAt(now);

    // Progress is visually symbolic: 0..1 wraps once per hour so short
    // sessions still fill the ring. (Progress is not tied to a goal.)
    final double progress = (elapsed.inSeconds % 3600) / 3600.0;

    final bool indeterminate = state is TimerEnding;

    return TimerRing(
      color: accent,
      progress: progress,
      indeterminate: indeterminate,
      child: Text(
        formatElapsed(elapsed),
        style: theme.textTheme.displayLarge?.copyWith(
          color: AppPalette.nearBlack,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _StreakBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final grade = ref.watch(gradeNotifierProvider);
    final int streak = switch (grade) {
      GradeLoaded(:final summary) => summary.streakDays,
      _ => 0,
    };
    if (streak <= 0) {
      return const SizedBox.shrink();
    }
    return Chip(
      avatar: const Icon(Icons.local_fire_department_rounded, size: 18),
      label: Text('연속 $streak일 독서 중'),
      labelStyle: theme.textTheme.labelMedium,
      backgroundColor: AppPalette.lightSurface,
    );
  }
}
