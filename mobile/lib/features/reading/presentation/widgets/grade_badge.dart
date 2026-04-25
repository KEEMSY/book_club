import 'package:flutter/material.dart';

import '../../../../core/theme/grade_theme.dart';

/// Circular badge that renders the user's reader grade. Rausch is reserved
/// for grade 3 (애독자); other grades use their assigned Airbnb hue per
/// `GradeTheme`.
///
/// Each tier carries a plant-growth Material icon instead of a plain numeral
/// (sprout → growing plant → flower → tree → forest) so the badge *shows*
/// the "reading as growth" metaphor that the 새싹/탐/애/열혈/마스터 naming
/// already implies. Icons land pixel-centered via an explicit `Center`
/// wrapper — a `Text` in a circle used to sit a hair off because baseline
/// + descender metrics shift the glyph off-axis.
///
/// Use the default constructor once a [ReaderGrade] is available. While the
/// grade call is Initial / Loading / Failure, prefer [GradeBadge.placeholder]
/// so the dashboard card keeps its circular affordance and doesn't collapse
/// into a blank 64dp hole.
///
/// Motion: real (non-placeholder) badges play a subtle mount entrance
/// (scale 0.85 → 1.0, opacity 0 → 1, easeOutBack 420ms) keyed off [grade] so
/// 승급 re-keys it, plus an always-on idle glow pulse (drop shadow opacity
/// 0.18 ↔ 0.32 over 2200ms easeInOut). Both gate on
/// `MediaQuery.disableAnimations` — when reduced motion is on, the badge
/// renders its final state with no controllers active.
class GradeBadge extends StatelessWidget {
  const GradeBadge({
    super.key,
    required this.grade,
    this.size = 120,
    this.showLabel = false,
  })  : _isPlaceholder = false,
        _shimmer = false;

  /// Neutral placeholder variant. Renders a circle with the same [size]
  /// semantics as the real badge so row layouts stay stable across states.
  ///
  /// * Initial / Failure → [shimmer] = false (static icon).
  /// * Loading           → [shimmer] = true  (opacity pulse 0.5 ↔ 1.0 / 1400ms).
  const GradeBadge.placeholder({
    super.key,
    this.size = 64,
    bool shimmer = false,
  })  : grade = ReaderGrade.sprout, // unused in placeholder branch
        showLabel = false,
        _isPlaceholder = true,
        _shimmer = shimmer;

  final ReaderGrade grade;
  final double size;
  final bool showLabel;
  final bool _isPlaceholder;
  final bool _shimmer;

  @override
  Widget build(BuildContext context) {
    if (_isPlaceholder) {
      return _buildPlaceholder(context);
    }
    return _buildBadge(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          size: size * 0.5,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );

    if (!_shimmer) {
      return circle;
    }
    return _OpacityPulse(
      minOpacity: 0.5,
      maxOpacity: 1.0,
      duration: const Duration(milliseconds: 1400),
      child: circle,
    );
  }

  Widget _buildBadge(BuildContext context) {
    final theme = Theme.of(context);
    final Color primary = GradeTheme.primaryOf(grade);
    final Color onPrimary = theme.colorScheme.onPrimary;
    final String label = _label(grade);
    final IconData icon = _iconFor(grade);
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    final Widget badgeStack = SizedBox(
      width: size,
      height: size,
      // Re-key on grade so 승급 plays the entrance animation again — a fresh
      // _AnimatedBadge re-runs its mount tween, and disposes the old glow
      // controller cleanly.
      child: _AnimatedBadge(
        key: ValueKey<ReaderGrade>(grade),
        size: size,
        primary: primary,
        onPrimary: onPrimary,
        icon: icon,
        reduceMotion: reduceMotion,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        badgeStack,
        if (showLabel) ...<Widget>[
          SizedBox(height: size * 0.1),
          Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ],
    );
  }

  /// Plant-growth motif: seed/sprout → growing plant → flower → tree →
  /// forest. Each glyph is a built-in Material rounded icon — no extra
  /// dependency, guaranteed availability.
  static IconData _iconFor(ReaderGrade g) {
    switch (g) {
      case ReaderGrade.sprout:
        return Icons.spa_rounded;
      case ReaderGrade.explorer:
        return Icons.eco_rounded;
      case ReaderGrade.devoted:
        return Icons.local_florist_rounded;
      case ReaderGrade.passionate:
        return Icons.park_rounded;
      case ReaderGrade.master:
        return Icons.forest_rounded;
    }
  }

  String _label(ReaderGrade g) {
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

/// Internal painter for the real (non-placeholder) badge. Hosts both the
/// one-shot mount entrance (scale + opacity) and the always-on glow pulse.
///
/// Two controllers because the lifecycles differ: the entrance fires once
/// on first frame (or on grade change via re-keying), while the glow loops
/// for the lifetime of the widget. A single controller would either trap
/// the entrance into the loop or force us to overload `value` semantics.
class _AnimatedBadge extends StatefulWidget {
  const _AnimatedBadge({
    super.key,
    required this.size,
    required this.primary,
    required this.onPrimary,
    required this.icon,
    required this.reduceMotion,
  });

  final double size;
  final Color primary;
  final Color onPrimary;
  final IconData icon;
  final bool reduceMotion;

  @override
  State<_AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<_AnimatedBadge>
    with TickerProviderStateMixin {
  // Always-on glow pulse. Allocated lazily so reduce-motion builds never
  // spin a controller — keeps the test path tickerless and the device
  // honest about the accessibility setting.
  AnimationController? _glow;

  @override
  void initState() {
    super.initState();
    if (!widget.reduceMotion) {
      _glow = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      )..repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // disableAnimations can flip mid-session (a user toggles the system
    // setting). Mirror it here: stop the loop in either direction.
    if (widget.reduceMotion && _glow != null) {
      _glow!.dispose();
      _glow = null;
    } else if (!widget.reduceMotion && _glow == null) {
      _glow = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glow?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget core = _buildCore(animatedGlowAlpha: null);

    if (widget.reduceMotion) {
      // Reduce-motion: render the resting state. Final scale, full opacity,
      // baseline glow — no controllers, no implicit animation.
      return core;
    }

    // Glow pulse — wraps the core and re-renders only the outer drop
    // shadow's alpha each tick. Disc fill, ring, and icon are unchanged.
    final Widget pulsing = AnimatedBuilder(
      animation: _glow!,
      builder: (BuildContext _, Widget? child) {
        // CurvedAnimation per-frame is cheap; avoids holding a separate
        // CurvedAnimation reference whose disposal would shadow the
        // controller's lifecycle.
        final double t = Curves.easeInOut.transform(_glow!.value);
        // 0.18 → 0.32 → 0.18 (controller is reverse-repeated, so t already
        // ping-pongs 0 → 1 → 0).
        final double alpha = 0.18 + (0.32 - 0.18) * t;
        return _buildCore(animatedGlowAlpha: alpha);
      },
    );

    // Mount entrance: implicit one-shot tween 0 → 1 driven by
    // TweenAnimationBuilder. Re-keying _AnimatedBadge on grade change
    // remounts this and replays the entrance.
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (BuildContext _, double t, Widget? child) {
        // Curves.easeOutBack overshoots ~10% by default; that's the
        // "subtle pop" called for. Scale starts at 0.85.
        final double scale = 0.85 + (1.0 - 0.85) * t;
        final double opacity = t.clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: pulsing,
    );
  }

  /// Renders the disc + ring + icon with an optionally-overridden glow
  /// alpha. When [animatedGlowAlpha] is null the static baseline (0.35) is
  /// used — that path is reduce-motion only.
  Widget _buildCore({required double? animatedGlowAlpha}) {
    final double size = widget.size;
    final Color primary = widget.primary;
    final Color onPrimary = widget.onPrimary;
    final double glowAlpha = animatedGlowAlpha ?? 0.35;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Filled disc — grade primary with a soft ambient glow matching
        // the grade's tone.
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: primary.withValues(alpha: glowAlpha),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        // Soft inner ring — subtle medallion treatment that adds depth
        // without introducing extra chroma. Scales with size so the
        // 64dp compact badge and the 120dp hero badge both read.
        Container(
          width: size - size * 0.12,
          height: size - size * 0.12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: onPrimary.withValues(alpha: 0.24),
              width: 1.5,
            ),
          ),
        ),
        // Plant-growth glyph, explicit Center so the icon lands on the
        // visual axis of the disc regardless of glyph metrics.
        Center(
          child: Icon(
            widget.icon,
            size: size * 0.5,
            color: onPrimary,
          ),
        ),
      ],
    );
  }
}

/// Drives a looping opacity pulse for [GradeBadge.placeholder] in its Loading
/// variant. Runs entirely on vsync via a single [AnimationController] so it
/// stays inexpensive and auto-disposes when the placeholder is unmounted.
class _OpacityPulse extends StatefulWidget {
  const _OpacityPulse({
    required this.child,
    required this.minOpacity,
    required this.maxOpacity,
    required this.duration,
  });

  final Widget child;
  final double minOpacity;
  final double maxOpacity;
  final Duration duration;

  @override
  State<_OpacityPulse> createState() => _OpacityPulseState();
}

class _OpacityPulseState extends State<_OpacityPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> curved =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    return AnimatedBuilder(
      animation: curved,
      builder: (BuildContext _, Widget? child) {
        final double t = curved.value;
        final double opacity =
            widget.minOpacity + (widget.maxOpacity - widget.minOpacity) * t;
        return Opacity(opacity: opacity, child: child);
      },
      child: widget.child,
    );
  }
}
