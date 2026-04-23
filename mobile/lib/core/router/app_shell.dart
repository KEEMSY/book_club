import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/reading/application/reading_providers.dart';

/// Bottom-nav shell for the three M3 destinations (홈 · 검색 · 서재).
///
/// Selected-state tint follows `gradePrimaryProvider` so grade-up events
/// shift the active-tab icon/label in lockstep with the rest of the
/// reading surfaces (timer ring, jan-dee, grade badge).
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: accent.withValues(alpha: 0.12),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(CupertinoIcons.house),
            selectedIcon: Icon(CupertinoIcons.house_fill, color: accent),
            label: '홈',
          ),
          NavigationDestination(
            icon: const Icon(CupertinoIcons.search),
            selectedIcon: Icon(CupertinoIcons.search, color: accent),
            label: '검색',
          ),
          NavigationDestination(
            icon: const Icon(CupertinoIcons.book),
            selectedIcon: Icon(CupertinoIcons.book_fill, color: accent),
            label: '서재',
          ),
        ],
      ),
    );
  }
}

/// Exposed for tests that need to simulate the bottom-nav host without
/// spinning up the full go_router graph.
@visibleForTesting
class AppShellForTesting extends StatelessWidget {
  const AppShellForTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
