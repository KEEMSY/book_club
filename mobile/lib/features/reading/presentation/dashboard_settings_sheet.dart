import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/dashboard_prefs_notifier.dart';
import '../domain/dashboard_prefs.dart';

/// Bottom sheet that lets the user toggle visibility and drag-reorder the
/// dashboard sections. Opened from the home screen's top action button.
///
/// Uses [ReorderableListView] so each row carries a drag handle on the right.
/// Toggle and order are independent — a hidden section keeps its position in
/// the order so it reappears where the user left it when re-enabled.
class DashboardSettingsSheet extends ConsumerWidget {
  const DashboardSettingsSheet({super.key});

  static const Map<String, ({String title, String subtitle})> _meta =
      <String, ({String title, String subtitle})>{
    'streak': (title: '스트릭 카드', subtitle: '연속 독서 일수'),
    'goal': (title: '목표 진행률', subtitle: '주간 · 월간 · 연간 목표'),
    'grade': (title: '등급 카드', subtitle: '나의 독서 등급'),
    'heatmap': (title: '독서 잔디', subtitle: '1년간 독서 캘린더'),
  };

  bool _isVisible(DashboardPrefs prefs, String id) => switch (id) {
        'streak' => prefs.showStreak,
        'goal' => prefs.showGoal,
        'grade' => prefs.showGrade,
        'heatmap' => prefs.showHeatmap,
        _ => false,
      };

  DashboardPrefs _toggle(DashboardPrefs prefs, String id, bool value) =>
      switch (id) {
        'streak' => prefs.copyWith(showStreak: value),
        'goal' => prefs.copyWith(showGoal: value),
        'grade' => prefs.copyWith(showGrade: value),
        'heatmap' => prefs.copyWith(showHeatmap: value),
        _ => prefs,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final DashboardPrefs prefs = ref.watch(dashboardPrefsNotifierProvider);
    final DashboardPrefsNotifier notifier =
        ref.read(dashboardPrefsNotifierProvider.notifier);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('홈 섹션 설정', style: theme.textTheme.titleLarge),
                ),
                Icon(
                  Icons.drag_indicator,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  '길게 눌러 순서 변경',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // ReorderableListView requires a bounded height when used inside a
          // Column. 4 items × ~72px each is well within typical sheet height.
          SizedBox(
            height: prefs.sectionOrder.length * 72.0,
            child: ReorderableListView(
              shrinkWrap: true,
              onReorder: notifier.reorder,
              children: <Widget>[
                for (final String id in prefs.sectionOrder)
                  _SectionTile(
                    key: ValueKey<String>(id),
                    id: id,
                    meta: _meta[id]!,
                    isVisible: _isVisible(prefs, id),
                    onChanged: (bool v) =>
                        notifier.update(_toggle(prefs, id, v)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    super.key,
    required this.id,
    required this.meta,
    required this.isVisible,
    required this.onChanged,
  });

  final String id;
  final ({String title, String subtitle}) meta;
  final bool isVisible;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(meta.title),
      subtitle: Text(meta.subtitle),
      value: isVisible,
      onChanged: onChanged,
      // ReorderableListView injects a drag handle automatically on the
      // trailing edge via buildDefaultDragHandles — no custom trailing needed.
    );
  }
}
