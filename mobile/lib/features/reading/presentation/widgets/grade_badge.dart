import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/grade_theme.dart';

/// Circular badge that renders the user's reader grade. Rausch is reserved
/// for grade 3 (애독자); other grades use their assigned Airbnb hue per
/// `GradeTheme`.
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
      return _buildPlaceholder();
    }
    return _buildBadge(context);
  }

  Widget _buildPlaceholder() {
    // borderCream / stoneGray are not present in AppPalette. We map the
    // requested semantic tokens to the closest existing Airbnb values:
    //   borderCream  → AppPalette.foggy  (warm off-white, §2 Foggy)
    //   borderGray   → AppPalette.borderGray at 60% alpha
    //   stoneGray    → AppPalette.secondaryGray
    final Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppPalette.foggy,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppPalette.borderGray.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          size: size * 0.5,
          color: AppPalette.secondaryGray,
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
    final String label = _label(grade);
    final int number = _number(grade);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
          child: Center(
            child: Text(
              '$number',
              // White-on-grade-fill is already AAA, but some of the lighter
              // grade hues (beachPeach, rauschLite) get close to 4.5:1 at
              // thin weights. A soft inner shadow keeps the numeral readable
              // across every grade without adding chroma.
              style: theme.textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontSize: size * 0.38,
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showLabel) ...<Widget>[
          SizedBox(height: size * 0.1),
          Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppPalette.nearBlack,
            ),
          ),
        ],
      ],
    );
  }

  int _number(ReaderGrade g) {
    switch (g) {
      case ReaderGrade.sprout:
        return 1;
      case ReaderGrade.explorer:
        return 2;
      case ReaderGrade.devoted:
        return 3;
      case ReaderGrade.passionate:
        return 4;
      case ReaderGrade.master:
        return 5;
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
