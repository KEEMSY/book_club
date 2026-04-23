import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Large circular progress ring rendered in the centre of the timer screen.
///
/// Draws two concentric arcs: a 30%-alpha background ring routed through the
/// theme's `outlineVariant` and a foreground arc in [color] (grade accent via
/// `gradePrimaryProvider`).
///
/// The arc sweeps clockwise, starting at 12 o'clock, proportional to
/// [progress] (0..1). When [indeterminate] is true the ring renders a full
/// 360° low-alpha background and a small spinning sweep so the ending state
/// can show waiting feedback without swapping widgets.
class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.color,
    required this.progress,
    this.size = 280,
    this.strokeWidth = 10,
    this.child,
    this.indeterminate = false,
  });

  final Color color;
  final double progress;
  final double size;
  final double strokeWidth;
  final Widget? child;
  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TimerRingPainter(
          color: color,
          // outlineVariant is already tuned per-theme (warm near-white on light,
          // #2E2E2E on dark) so the track stays visible without the low-alpha
          // borderGray hack that used to vanish on the dark canvas.
          backgroundColor: theme.colorScheme.outlineVariant,
          progress: progress.clamp(0.0, 1.0),
          strokeWidth: strokeWidth,
          indeterminate: indeterminate,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  const _TimerRingPainter({
    required this.color,
    required this.backgroundColor,
    required this.progress,
    required this.strokeWidth,
    required this.indeterminate,
  });

  final Color color;
  final Color backgroundColor;
  final double progress;
  final double strokeWidth;
  final bool indeterminate;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final double radius = math.min(size.width, size.height) / 2 - strokeWidth;
    final Offset center = rect.center;

    final Paint bg = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bg);

    if (indeterminate) {
      // Small sweeping arc when we're waiting for the backend; the widget
      // tree feeds an AnimatedBuilder above this painter when used live.
      final Paint ind = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi / 2,
        false,
        ind,
      );
      return;
    }

    if (progress <= 0) {
      return;
    }

    final Paint fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter old) {
    return old.color != color ||
        old.backgroundColor != backgroundColor ||
        old.progress != progress ||
        old.strokeWidth != strokeWidth ||
        old.indeterminate != indeterminate;
  }
}
