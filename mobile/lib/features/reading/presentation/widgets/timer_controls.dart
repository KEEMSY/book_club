import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/timer_state.dart';

/// State-dependent control bar rendered at the bottom of `TimerScreen`.
///
/// Idle     → single large "시작" pill.
/// Running  → circular Pause + "종료" pill.
/// Paused   → circular Resume + "종료" pill.
/// Ending   → disabled spinner on "종료".
class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.state,
    required this.accent,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onEnd,
  });

  final TimerState state;
  final Color accent;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return switch (state) {
      TimerIdle() || TimerFailure() || TimerCompleted() => SizedBox(
          width: double.infinity,
          child: FilledButton(
            key: const ValueKey('timer-start'),
            onPressed: onStart,
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: const StadiumBorder(),
              textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 17),
            ),
            child: const Text('시작'),
          ),
        ),
      TimerRunning() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _CircularControl(
              key: const ValueKey('timer-pause'),
              icon: Icons.pause_rounded,
              onPressed: onPause,
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: FilledButton(
                key: const ValueKey('timer-end'),
                onPressed: onEnd,
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: const StadiumBorder(),
                ),
                child: const Text('종료'),
              ),
            ),
          ],
        ),
      TimerPaused() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _CircularControl(
              key: const ValueKey('timer-resume'),
              icon: Icons.play_arrow_rounded,
              onPressed: onResume,
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: FilledButton(
                key: const ValueKey('timer-end'),
                onPressed: onEnd,
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: const StadiumBorder(),
                ),
                child: const Text('종료'),
              ),
            ),
          ],
        ),
      TimerEnding() => SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: null,
            style: FilledButton.styleFrom(
              backgroundColor: accent.withValues(alpha: 0.38),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: const StadiumBorder(),
            ),
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
    };
  }
}

class _CircularControl extends StatelessWidget {
  const _CircularControl({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, color: theme.colorScheme.onSurface, size: 28),
        ),
      ),
    );
  }
}
