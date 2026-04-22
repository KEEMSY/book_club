import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Bottom-nav shell for the two M2 destinations (검색 · 서재).
///
/// Until M3 wires the timer dashboard we expose only two tabs. A simple
/// index-synced NavigationBar is enough — no tab-state preservation across
/// top-level navigation pushes, because each tab's notifier already keeps
/// its own cache.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppPalette.rausch.withValues(alpha: 0.12),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(CupertinoIcons.search),
            selectedIcon: Icon(
              CupertinoIcons.search,
              color: AppPalette.rausch,
            ),
            label: '검색',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.book),
            selectedIcon: Icon(
              CupertinoIcons.book_fill,
              color: AppPalette.rausch,
            ),
            label: '서재',
          ),
        ],
      ),
    );
  }
}
