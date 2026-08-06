import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/notification/application/notification_notifier.dart';
import '../../features/reading/application/reading_providers.dart';
import '../config/feature_flags.dart';
import '../layout/adaptive_layout.dart';
import '../layout/web_navigation_rail.dart';
import 'app_mode_provider.dart';

/// Root shell that renders the two-mode bottom chrome.
///
/// 개인 모드:
///   • NavigationBar-style 3-tab row  (홈 · 검색 · 서재)
///   • Full-width SegmentedButton mode toggle
///
/// 커뮤니티 모드:
///   • 3-tab row is gone — community screen's own TabBar drives sub-nav
///   • Full-width SegmentedButton mode toggle (still pinned at the bottom)
///
/// The complete replacement of the bottom chrome is what gives the "theme
/// switching" feel the user asked for.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _lastPersonalIndex = 0;

  void _switchToCommunity() {
    _lastPersonalIndex = widget.navigationShell.currentIndex.clamp(0, 2);
    ref.read(appModeNotifierProvider.notifier).setMode(AppMode.community);
    widget.navigationShell.goBranch(3, initialLocation: false);
  }

  void _switchToPersonal() {
    ref.read(appModeNotifierProvider.notifier).setMode(AppMode.personal);
    widget.navigationShell.goBranch(_lastPersonalIndex, initialLocation: false);
  }

  void _onTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  /// Wide-layout NavigationRail handler. The rail flattens the personal tabs
  /// (0–2) and the community branch (3) into one list, so selecting 커뮤니티
  /// flips into community mode while the personal tabs flip back out of it.
  void _onRailSelected(int index) {
    if (index == 3) {
      _switchToCommunity();
      return;
    }
    if (ref.read(appModeNotifierProvider) == AppMode.community) {
      // Flip the mode flag only — navigation is handled by the goBranch below,
      // so we avoid the extra hop _switchToPersonal would make to its last tab.
      ref.read(appModeNotifierProvider.notifier).setMode(AppMode.personal);
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);
    final AppMode mode = ref.watch(appModeNotifierProvider);
    final int tabIndex = widget.navigationShell.currentIndex.clamp(0, 2);

    final Widget mobileLayout = Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: _AppBottomBar(
        mode: mode,
        tabIndex: tabIndex,
        accent: accent,
        theme: theme,
        onTabSelected: _onTabSelected,
        onModeSwitch: (m) =>
            m == AppMode.community ? _switchToCommunity() : _switchToPersonal(),
      ),
    );

    // Tablet/desktop (web) replaces the bottom chrome with a left rail showing
    // all four branches at once; the mode toggle is implicit in the selection.
    final int railIndex = mode == AppMode.community ? 3 : tabIndex;
    final int unreadCount = ref.watch(
      notificationNotifierProvider.select((s) => s.unreadCount),
    );
    final Widget wideLayout = Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            WebNavigationRail(
              selectedIndex: railIndex,
              accent: accent,
              badgeCount: unreadCount,
              onDestinationSelected: _onRailSelected,
            ),
            VerticalDivider(
              width: 1,
              thickness: 0.5,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            Expanded(child: widget.navigationShell),
          ],
        ),
      ),
    );

    return AdaptiveLayout(
      mobile: mobileLayout,
      tablet: wideLayout,
      desktop: wideLayout,
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar container
// ---------------------------------------------------------------------------

class _AppBottomBar extends StatelessWidget {
  const _AppBottomBar({
    required this.mode,
    required this.tabIndex,
    required this.accent,
    required this.theme,
    required this.onTabSelected,
    required this.onModeSwitch,
  });

  final AppMode mode;
  final int tabIndex;
  final Color accent;
  final ThemeData theme;
  final void Function(int) onTabSelected;
  final void Function(AppMode) onModeSwitch;

  @override
  Widget build(BuildContext context) {
    final double bottomPad = MediaQuery.of(context).padding.bottom;

    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            height: 1,
            thickness: 0.5,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          // With community deferred (BC-23) the app only has personal mode, so
          // the tab row is always shown and the mode toggle is dropped.
          if (mode == AppMode.personal || !FeatureFlags.community)
            _PersonalNavRow(
              tabIndex: tabIndex,
              accent: accent,
              theme: theme,
              onTabSelected: onTabSelected,
            ),
          if (FeatureFlags.community)
            _ModeToggle(
              mode: mode,
              accent: accent,
              theme: theme,
              bottomPad: bottomPad,
              onModeSwitch: onModeSwitch,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Personal mode: 3-tab row
// ---------------------------------------------------------------------------

class _PersonalNavRow extends ConsumerWidget {
  const _PersonalNavRow({
    required this.tabIndex,
    required this.accent,
    required this.theme,
    required this.onTabSelected,
  });

  final int tabIndex;
  final Color accent;
  final ThemeData theme;
  final void Function(int) onTabSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observe unread count so the home tab icon shows a live badge dot.
    final int unreadCount = ref.watch(
      notificationNotifierProvider.select((s) => s.unreadCount),
    );

    return Row(
      children: <Widget>[
        _NavItem(
          icon: CupertinoIcons.house,
          selectedIcon: CupertinoIcons.house_fill,
          label: '홈',
          selected: tabIndex == 0,
          accent: accent,
          theme: theme,
          badgeCount: unreadCount,
          onTap: () => onTabSelected(0),
        ),
        // BC-79: 검색 is MVP core (book domain) — always shown, independent of
        // the deferred discovery flag. Branch index 1 hosts SearchScreen.
        _NavItem(
          icon: CupertinoIcons.search,
          selectedIcon: CupertinoIcons.search,
          label: '검색',
          selected: tabIndex == 1,
          accent: accent,
          theme: theme,
          onTap: () => onTabSelected(1),
        ),
        _NavItem(
          icon: CupertinoIcons.book,
          selectedIcon: CupertinoIcons.book_fill,
          label: '서재',
          selected: tabIndex == 2,
          accent: accent,
          theme: theme,
          onTap: () => onTabSelected(2),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.accent,
    required this.theme,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final Color accent;
  final ThemeData theme;
  final VoidCallback onTap;

  /// When > 0, a red dot badge is shown on the icon. Capped at 99.
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected
        ? accent
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                height: 32,
                decoration: selected
                    ? BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      )
                    : null,
                child: Badge(
                  isLabelVisible: badgeCount > 0,
                  label: Text(badgeCount > 99 ? '99+' : '$badgeCount'),
                  backgroundColor: theme.colorScheme.error,
                  textStyle: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontSize: 9,
                  ),
                  child: Icon(
                    selected ? selectedIcon : icon,
                    color: fg,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: fg,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mode toggle — full-width SegmentedButton, always visible
// ---------------------------------------------------------------------------

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.mode,
    required this.accent,
    required this.theme,
    required this.bottomPad,
    required this.onModeSwitch,
  });

  final AppMode mode;
  final Color accent;
  final ThemeData theme;
  final double bottomPad;
  final void Function(AppMode) onModeSwitch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 10 + bottomPad),
      child: SegmentedButton<AppMode>(
        expandedInsets: EdgeInsets.zero,
        showSelectedIcon: false,
        selected: {mode},
        onSelectionChanged: (Set<AppMode> s) => onModeSwitch(s.first),
        style: SegmentedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          selectedBackgroundColor: accent.withValues(alpha: 0.15),
          selectedForegroundColor: accent,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        segments: const <ButtonSegment<AppMode>>[
          ButtonSegment<AppMode>(
            value: AppMode.personal,
            icon: Icon(CupertinoIcons.person, size: 15),
            label: Text('개인'),
          ),
          ButtonSegment<AppMode>(
            value: AppMode.community,
            icon: Icon(CupertinoIcons.person_2, size: 15),
            label: Text('커뮤니티'),
          ),
        ],
      ),
    );
  }
}

/// Exposed for tests.
@visibleForTesting
class AppShellForTesting extends StatelessWidget {
  const AppShellForTesting({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}
