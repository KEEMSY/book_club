import 'dart:math' as math;

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
                _GradeUpCelebration(accent: accent, grade: currentGrade),
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

/// Stronger 등급업 moment — drives the GradeBadge through a second-stage
/// bounce, fades sparkle dots in/out around it on staggered delays, and
/// slides the headline up from below. All choreographed by a single
/// 1200ms controller via `Interval`-based curved animations so the
/// progress is reproducible and gating on `disableAnimations` is a single
/// branch.
class _GradeUpCelebration extends StatefulWidget {
  const _GradeUpCelebration({required this.accent, required this.grade});

  final Color accent;
  final ReaderGrade grade;

  @override
  State<_GradeUpCelebration> createState() => _GradeUpCelebrationState();
}

class _GradeUpCelebrationState extends State<_GradeUpCelebration>
    with SingleTickerProviderStateMixin {
  static const Duration _total = Duration(milliseconds: 1200);
  // Sparkle stagger schedule — each dot starts at its delay and fades in/out
  // over a fixed window. Five dots covers the badge perimeter without
  // crowding (every 72°).
  static const List<int> _sparkleDelaysMs = <int>[0, 120, 240, 360, 480];
  static const int _sparkleWindowMs = 600;
  static const double _badgeSize = 56.0;
  // Sparkle radius is 1.4× badge size so dots sit just outside the badge
  // ring without colliding with the headline above.
  static const double _sparkleRadius = _badgeSize * 1.4;
  static const double _sparkleDotSize = 8.0;

  AnimationController? _controller;
  bool _reduceMotion = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // MediaQuery is available here, not in initState. Read once and cache;
    // a system-level toggle mid-celebration is rare enough that we don't
    // try to re-choreograph mid-flight.
    final bool nowReduce = MediaQuery.of(context).disableAnimations;
    if (!_initialized) {
      _reduceMotion = nowReduce;
      if (!_reduceMotion) {
        _controller = AnimationController(vsync: this, duration: _total)
          ..forward();
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion || _controller == null) {
      // Final-state render: headline visible at rest, badge at scale 1.0,
      // no sparkles (they're transient embellishment, not state).
      return _buildLayout(
        bounceScale: 1.0,
        headlineOffset: 0.0,
        headlineOpacity: 1.0,
        sparkleAlphas: const <double>[0, 0, 0, 0, 0],
      );
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (BuildContext _, Widget? __) {
        final double t = _controller!.value;
        final double tMs = t * _total.inMilliseconds;

        // 0–600ms bounce: easeOutBack out to 1.18, then easeInOutCubic
        // back to 1.0. Approximates a soft elastic without overshoot
        // tail on the way down.
        final double bounceScale = _bounceScaleAt(tMs);

        // 0–1200ms headline: slide up 12dp + fade in. Curved over the
        // first half so the slide finishes well before the badge settles
        // and the eye lands on the title text.
        final double headlineT = _intervalT(tMs, 0, 700, Curves.easeOutCubic);
        final double headlineOffset = (1.0 - headlineT) * 12.0;
        final double headlineOpacity = headlineT;

        // Sparkles 0–900ms: 5 dots, each fades 0 → 0.7 → 0 across its
        // 600ms window with the staggered delays above.
        final List<double> sparkleAlphas = <double>[
          for (final int delay in _sparkleDelaysMs)
            _sparkleAlpha(tMs, delay.toDouble(), _sparkleWindowMs.toDouble()),
        ];

        return _buildLayout(
          bounceScale: bounceScale,
          headlineOffset: headlineOffset,
          headlineOpacity: headlineOpacity,
          sparkleAlphas: sparkleAlphas,
        );
      },
    );
  }

  /// Bounce envelope: 0→0.5 of the 600ms window goes 1.0 → 1.18 with
  /// easeOutBack feel, 0.5→1 returns 1.18 → 1.0 with easeInOutCubic.
  /// Outside the 600ms window, scale is locked at 1.0.
  double _bounceScaleAt(double tMs) {
    const double window = 600.0;
    const double peak = 1.18;
    if (tMs >= window) return 1.0;
    final double half = window / 2;
    if (tMs <= half) {
      final double u = (tMs / half).clamp(0.0, 1.0);
      // easeOutBack-ish ramp up to peak.
      final double curved = Curves.easeOutBack.transform(u);
      return 1.0 + (peak - 1.0) * curved;
    }
    final double u = ((tMs - half) / half).clamp(0.0, 1.0);
    final double curved = Curves.easeInOutCubic.transform(u);
    return peak - (peak - 1.0) * curved;
  }

  double _intervalT(double tMs, double startMs, double endMs, Curve curve) {
    if (tMs <= startMs) return 0.0;
    if (tMs >= endMs) return 1.0;
    final double u = (tMs - startMs) / (endMs - startMs);
    return curve.transform(u.clamp(0.0, 1.0));
  }

  /// Triangular fade for each sparkle: 0 → peak (0.7) → 0 across [windowMs]
  /// starting at [startMs]. Matches a single soft pulse per dot rather
  /// than a hard flash.
  double _sparkleAlpha(double tMs, double startMs, double windowMs) {
    final double endMs = startMs + windowMs;
    if (tMs <= startMs || tMs >= endMs) return 0.0;
    final double u = (tMs - startMs) / windowMs;
    // 0 at u=0, 0.7 at u=0.5, 0 at u=1.
    final double tri = 1.0 - (u - 0.5).abs() * 2.0;
    return Curves.easeInOut.transform(tri.clamp(0.0, 1.0)) * 0.7;
  }

  Widget _buildLayout({
    required double bounceScale,
    required double headlineOffset,
    required double headlineOpacity,
    required List<double> sparkleAlphas,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Headline above the badge — slides up from +12dp / fades in.
        Opacity(
          opacity: headlineOpacity,
          child: Transform.translate(
            offset: Offset(0, headlineOffset),
            child: Text(
              '승급했어요!',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: widget.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: _sparkleRadius * 2 + _sparkleDotSize,
          height: _sparkleRadius * 2 + _sparkleDotSize,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Sparkle layer — placed first so it paints behind the
              // badge. Each dot at its angle + per-dot alpha.
              for (int i = 0; i < sparkleAlphas.length; i++)
                _SparkleDot(
                  angleRad: (2 * math.pi * i) / sparkleAlphas.length,
                  radius: _sparkleRadius,
                  size: _sparkleDotSize,
                  color: widget.accent,
                  alpha: sparkleAlphas[i],
                ),
              // Bouncing badge.
              Transform.scale(
                scale: bounceScale,
                child: GradeBadge(grade: widget.grade, size: _badgeSize),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_gradeLabel(widget.grade)}(으)로 올라섰어요',
          style: theme.textTheme.titleMedium?.copyWith(color: widget.accent),
        ),
      ],
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

/// Single sparkle dot positioned on a circle around the badge. Stays mounted
/// throughout the celebration so we can cheaply animate its alpha each
/// frame without remounting; the controller's value drives [alpha].
class _SparkleDot extends StatelessWidget {
  const _SparkleDot({
    required this.angleRad,
    required this.radius,
    required this.size,
    required this.color,
    required this.alpha,
  });

  final double angleRad;
  final double radius;
  final double size;
  final Color color;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    if (alpha <= 0) {
      // Skip painting entirely when invisible — keeps the layer tree
      // tight during the stagger gaps.
      return const SizedBox.shrink();
    }
    final double dx = math.cos(angleRad) * radius;
    final double dy = math.sin(angleRad) * radius;
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: alpha),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: alpha * 0.6),
              blurRadius: size * 1.2,
            ),
          ],
        ),
      ),
    );
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
