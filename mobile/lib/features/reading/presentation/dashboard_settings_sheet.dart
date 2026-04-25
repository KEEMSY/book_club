import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/dashboard_prefs_notifier.dart';
import '../domain/dashboard_prefs.dart';

/// Bottom sheet that lets the user toggle which sections appear on the home
/// dashboard. Opened from [_TopActions] via [showModalBottomSheet].
class DashboardSettingsSheet extends ConsumerWidget {
  const DashboardSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final DashboardPrefs prefs = ref.watch(dashboardPrefsProvider);
    final notifier = ref.read(dashboardPrefsProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                '홈 섹션 설정',
                style: theme.textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('스트릭 카드'),
              subtitle: const Text('연속 독서 일수'),
              value: prefs.showStreak,
              onChanged: (v) =>
                  notifier.update(prefs.copyWith(showStreak: v)),
            ),
            SwitchListTile(
              title: const Text('목표 진행률'),
              subtitle: const Text('주간 · 월간 · 연간 목표'),
              value: prefs.showGoal,
              onChanged: (v) =>
                  notifier.update(prefs.copyWith(showGoal: v)),
            ),
            SwitchListTile(
              title: const Text('등급 카드'),
              subtitle: const Text('나의 독서 등급'),
              value: prefs.showGrade,
              onChanged: (v) =>
                  notifier.update(prefs.copyWith(showGrade: v)),
            ),
            SwitchListTile(
              title: const Text('독서 잔디'),
              subtitle: const Text('1년간 독서 캘린더'),
              value: prefs.showHeatmap,
              onChanged: (v) =>
                  notifier.update(prefs.copyWith(showHeatmap: v)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
