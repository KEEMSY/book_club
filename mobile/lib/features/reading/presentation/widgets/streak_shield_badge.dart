import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Small pill-shaped badge showing the number of streak shields the user
/// holds. Only rendered when [streakShields] is greater than zero.
///
/// A streak shield allows the user to miss one day without breaking their
/// streak. The tooltip explains this to users who are unfamiliar with the
/// feature.
class StreakShieldBadge extends StatelessWidget {
  const StreakShieldBadge({
    super.key,
    required this.streakShields,
    required this.accent,
  });

  final int streakShields;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (streakShields <= 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    return Tooltip(
      message:
          '스트릭 쉴드 $streakShields개 보유 중 — 하루를 건너뛰어도 스트릭이 유지돼요',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.shield_rounded, size: 14, color: accent),
            const SizedBox(width: 4),
            Text(
              '$streakShields',
              style: theme.textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
