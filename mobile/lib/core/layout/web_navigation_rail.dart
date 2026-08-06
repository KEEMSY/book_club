import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/feature_flags.dart';
import 'adaptive_layout.dart';

/// Side navigation for tablet/desktop widths.
///
/// Two visual modes, selected automatically by window width:
///   - Compact  (tablet  600–1023px): 72 px wide, icon centred + label below
///   - Extended (desktop ≥ 1024 px): 220 px wide, icon + label in a row
///
/// The four destinations map 1-to-1 onto AppShell branch indices:
///   0 홈 · 1 검색 · 2 서재 · 3 커뮤니티
///
/// A section separator is rendered between 서재 (index 2) and 커뮤니티 (index 3)
/// so the two usage contexts are visually distinct — matching the mobile
/// SegmentedButton mode toggle.
class WebNavigationRail extends StatelessWidget {
  const WebNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.accent,
    this.badgeCount = 0,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Reading-grade accent tint for the active destination. Falls back to the
  /// theme primary when null.
  final Color? accent;

  /// Unread notification count shown as a badge on the 홈 destination.
  final int badgeCount;

  static const double _compactWidth = 72.0;
  static const double _extendedWidth = 220.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color tint = accent ?? theme.colorScheme.primary;
    final bool extended =
        MediaQuery.of(context).size.width >= kDesktopBreakpoint;
    final double width = extended ? _extendedWidth : _compactWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: width,
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _RailHeader(extended: extended, theme: theme, tint: tint),
          const SizedBox(height: 4),
          _RailItem(
            index: 0,
            selectedIndex: selectedIndex,
            icon: CupertinoIcons.house,
            selectedIcon: CupertinoIcons.house_fill,
            label: '홈',
            extended: extended,
            tint: tint,
            theme: theme,
            badgeCount: badgeCount,
            onTap: () => onDestinationSelected(0),
          ),
          // BC-79: 검색 is MVP core (book domain) — always shown, independent
          // of the deferred discovery flag. Branch index 1 hosts SearchScreen.
          _RailItem(
            index: 1,
            selectedIndex: selectedIndex,
            icon: CupertinoIcons.search,
            selectedIcon: CupertinoIcons.search,
            label: '검색',
            extended: extended,
            tint: tint,
            theme: theme,
            onTap: () => onDestinationSelected(1),
          ),
          _RailItem(
            index: 2,
            selectedIndex: selectedIndex,
            icon: CupertinoIcons.book,
            selectedIcon: CupertinoIcons.book_fill,
            label: '서재',
            extended: extended,
            tint: tint,
            theme: theme,
            onTap: () => onDestinationSelected(2),
          ),
          // Deferred (BC-23): 커뮤니티/community section is gated together with
          // its separator.
          if (FeatureFlags.community) ...<Widget>[
            _SectionSeparator(extended: extended, theme: theme),
            _RailItem(
              index: 3,
              selectedIndex: selectedIndex,
              icon: CupertinoIcons.person_2,
              selectedIcon: CupertinoIcons.person_2_fill,
              label: '커뮤니티',
              extended: extended,
              tint: tint,
              theme: theme,
              onTap: () => onDestinationSelected(3),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _RailHeader extends StatelessWidget {
  const _RailHeader({
    required this.extended,
    required this.theme,
    required this.tint,
  });

  final bool extended;
  final ThemeData theme;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    if (extended) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Row(
          children: <Widget>[
            Icon(CupertinoIcons.book_fill, color: tint, size: 20),
            const SizedBox(width: 10),
            Text(
              '골방',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Icon(CupertinoIcons.book_fill, color: tint, size: 22),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Destination item
// ---------------------------------------------------------------------------

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.extended,
    required this.tint,
    required this.theme,
    required this.onTap,
    this.badgeCount = 0,
  });

  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool extended;
  final Color tint;
  final ThemeData theme;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final bool selected = index == selectedIndex;
    final Color fg = selected
        ? tint
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    final Widget iconWidget = Badge(
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
        size: extended ? 20 : 22,
      ),
    );

    if (extended) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected
                  ? tint.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: <Widget>[
                iconWidget,
                const SizedBox(width: 12),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
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

    // Compact: pill-shaped indicator centred over the icon, label below.
    // Matches the mobile bottom bar's indicator shape exactly.
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 32,
              decoration: selected
                  ? BoxDecoration(
                      color: tint.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: fg,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section separator between 서재 (index 2) and 커뮤니티 (index 3)
// ---------------------------------------------------------------------------

class _SectionSeparator extends StatelessWidget {
  const _SectionSeparator({required this.extended, required this.theme});

  final bool extended;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    if (extended) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '커뮤니티',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 10,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
