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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: size,
          height: size,
          child: Stack(
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
                      color: primary.withValues(alpha: 0.35),
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
                  icon,
                  size: size * 0.5,
                  color: onPrimary,
                ),
              ),
            ],
          ),
        ),
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
