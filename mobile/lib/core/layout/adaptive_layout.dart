import 'package:flutter/material.dart';

/// Coarse device buckets derived from the available width. Breakpoints follow
/// the Material 3 window-size-class guidance closely enough for our needs:
/// phones below 600, tablets/foldables up to 1024, and desktop/web above that.
enum ScreenSize { mobile, tablet, desktop }

/// Width thresholds shared by [ScreenSizeExt] and [AdaptiveLayout] so the two
/// agree on where one bucket ends and the next begins.
const double kTabletBreakpoint = 600;
const double kDesktopBreakpoint = 1024;

extension ScreenSizeExt on BuildContext {
  ScreenSize get screenSize {
    final width = MediaQuery.of(this).size.width;
    if (width < kTabletBreakpoint) return ScreenSize.mobile;
    if (width < kDesktopBreakpoint) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  bool get isMobile => screenSize == ScreenSize.mobile;
  bool get isTablet => screenSize == ScreenSize.tablet;
  bool get isDesktop => screenSize == ScreenSize.desktop;
}

/// Renders a different subtree per width bucket. [tablet] and [desktop] are
/// optional — when omitted the next-smaller layout is reused, so a caller can
/// supply only [mobile] and a single wide layout without branching every call
/// site.
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kDesktopBreakpoint && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= kTabletBreakpoint) {
          return tablet ?? desktop ?? mobile;
        }
        return mobile;
      },
    );
  }
}
