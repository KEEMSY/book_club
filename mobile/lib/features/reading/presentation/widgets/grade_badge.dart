import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/grade_theme.dart';

/// Circular badge that renders the user's reader grade. Rausch is reserved
/// for grade 3 (애독자); other grades use their assigned Airbnb hue per
/// `GradeTheme`.
class GradeBadge extends StatelessWidget {
  const GradeBadge({
    super.key,
    required this.grade,
    this.size = 120,
    this.showLabel = false,
  });

  final ReaderGrade grade;
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
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
