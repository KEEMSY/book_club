import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// "연속 N일 독서 중 🔥" card reused across the dashboard, grade screen,
/// and timer screen. When [streak] is zero we fall back to the longest-
/// ever streak copy so the user still sees a positive framing.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.streak,
    required this.longest,
    this.compact = false,
  });

  final int streak;
  final int longest;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    final String title;
    final String subtitle;
    if (streak > 0) {
      title = '연속 $streak일 독서 중';
      subtitle = '오늘도 읽으면 기록이 이어져요';
    } else if (longest > 0) {
      title = '최장 기록 $longest일';
      subtitle = '오늘 1분만 읽어도 스트릭 재시작';
    } else {
      title = '아직 연속 기록이 없어요';
      subtitle = '오늘부터 시작해보세요';
    }

    return Container(
      padding: EdgeInsets.all(compact ? spacing.md : spacing.lg),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.light.elevated,
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFE25822),
            size: 32,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
