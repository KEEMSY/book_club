import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Side navigation used on tablet/desktop widths in place of the mobile bottom
/// bar. The destinations mirror the four [AppShell] branches one-to-one — 홈,
/// 탐색, 서재, 커뮤니티 — so the selected index maps straight onto the shell's
/// branch index (커뮤니티 = branch 3).
class WebNavigationRail extends StatelessWidget {
  const WebNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.accent,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Reading-grade accent used to tint the active destination, kept in sync
  /// with the mobile bottom bar. Falls back to the theme primary when null.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color tint = accent ?? theme.colorScheme.primary;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      indicatorColor: tint.withValues(alpha: 0.12),
      selectedIconTheme: IconThemeData(color: tint),
      selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
        color: tint,
        fontWeight: FontWeight.w600,
      ),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(CupertinoIcons.house),
          selectedIcon: Icon(CupertinoIcons.house_fill),
          label: Text('홈'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore_rounded),
          label: Text('탐색'),
        ),
        NavigationRailDestination(
          icon: Icon(CupertinoIcons.book),
          selectedIcon: Icon(CupertinoIcons.book_fill),
          label: Text('서재'),
        ),
        NavigationRailDestination(
          icon: Icon(CupertinoIcons.person_2),
          selectedIcon: Icon(CupertinoIcons.person_2_fill),
          label: Text('커뮤니티'),
        ),
      ],
    );
  }
}
