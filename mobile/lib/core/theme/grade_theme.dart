import 'package:flutter/material.dart';

import 'app_theme.dart';

/// 5-grade reader tier (see design doc §5.2).
///
/// Seeds are drawn directly from Apple's published iOS system colors so the
/// per-grade surfaces inherit the platform's chromatic vocabulary. The raw
/// "light green → emerald → blue → purple → gold" progression from the design
/// doc is preserved — each step moves through the iOS palette toward
/// deeper / warmer hues — while staying inside HIG's singular-accent rhythm
/// per DESIGN.md §7 Do / Don't ("no additional accent colors — the entire
/// chromatic budget is spent on blue").
enum ReaderGrade {
  sprout, // 1 · 새싹 독자     · systemGreen (entry / fresh growth)
  explorer, // 2 · 탐독자       · systemTeal (cooler, deeper engagement)
  devoted, // 3 · 애독자        · systemBlue (Apple's signature accent)
  passionate, // 4 · 열혈 독자  · systemIndigo (deeper dedication)
  master, // 5 · 서재 마스터    · systemOrange (Apple-palette "gold" analog)
}

/// Per-grade ColorScheme factory for the timer / heatmap / profile badge.
///
/// Each entry seeds a light (and dark) `ColorScheme` from an iOS system color,
/// then [apply] merges that scheme onto a caller-supplied base `ThemeData` so
/// the rest of the theme (typography, spacing extensions, shadows) stays
/// intact — only chromatic surfaces shift.
class GradeTheme {
  const GradeTheme._();

  // -- Seed colors -----------------------------------------------------------
  //
  // Light + dark variants come from Apple's HIG system-color pairs (already
  // declared on [AppPalette]). Using the platform pairs — rather than running
  // a single seed through Material's tonal generator — keeps each grade
  // aligned with the iOS rendering that users already recognise from the
  // rest of the OS.
  static const Color _sproutSeedLight = AppPalette.systemGreen;
  static const Color _sproutSeedDark = AppPalette.systemGreenDark;
  static const Color _explorerSeedLight = AppPalette.systemTeal;
  static const Color _explorerSeedDark = AppPalette.systemTealDark;
  static const Color _devotedSeedLight = AppPalette.systemBlue;
  static const Color _devotedSeedDark = AppPalette.systemBlueDark;
  static const Color _passionateSeedLight = AppPalette.systemIndigo;
  static const Color _passionateSeedDark = AppPalette.systemIndigoDark;
  static const Color _masterSeedLight = AppPalette.systemOrange;
  static const Color _masterSeedDark = AppPalette.systemOrangeDark;

  /// Light-mode grade schemes. Paired with [darkSchemes] for dark-mode runs.
  static final Map<ReaderGrade, ColorScheme> schemes =
      <ReaderGrade, ColorScheme>{
    ReaderGrade.sprout: ColorScheme.fromSeed(
      seedColor: _sproutSeedLight,
      brightness: Brightness.light,
    ),
    ReaderGrade.explorer: ColorScheme.fromSeed(
      seedColor: _explorerSeedLight,
      brightness: Brightness.light,
    ),
    ReaderGrade.devoted: ColorScheme.fromSeed(
      seedColor: _devotedSeedLight,
      brightness: Brightness.light,
    ),
    ReaderGrade.passionate: ColorScheme.fromSeed(
      seedColor: _passionateSeedLight,
      brightness: Brightness.light,
    ),
    ReaderGrade.master: ColorScheme.fromSeed(
      seedColor: _masterSeedLight,
      brightness: Brightness.light,
    ),
  };

  /// Dark-mode variants — same seeds, `Brightness.dark`.
  static final Map<ReaderGrade, ColorScheme> darkSchemes =
      <ReaderGrade, ColorScheme>{
    ReaderGrade.sprout: ColorScheme.fromSeed(
      seedColor: _sproutSeedDark,
      brightness: Brightness.dark,
    ),
    ReaderGrade.explorer: ColorScheme.fromSeed(
      seedColor: _explorerSeedDark,
      brightness: Brightness.dark,
    ),
    ReaderGrade.devoted: ColorScheme.fromSeed(
      seedColor: _devotedSeedDark,
      brightness: Brightness.dark,
    ),
    ReaderGrade.passionate: ColorScheme.fromSeed(
      seedColor: _passionateSeedDark,
      brightness: Brightness.dark,
    ),
    ReaderGrade.master: ColorScheme.fromSeed(
      seedColor: _masterSeedDark,
      brightness: Brightness.dark,
    ),
  };

  /// Returns [base] with the given grade's `ColorScheme` swapped in.
  ///
  /// All non-color aspects of the base theme — `TextTheme`, `ThemeExtension`s
  /// (`AppSpacing`, `AppRadius`, `AppShadows`), `AppBarTheme`, buttons, etc.
  /// — are preserved so the grade color is purely a chromatic overlay on the
  /// base theme. Used by the timer screen; see `docs/plans/...§5.2`.
  static ThemeData apply(ThemeData base, ReaderGrade grade) {
    final ColorScheme gradeScheme = base.brightness == Brightness.dark
        ? darkSchemes[grade]!
        : schemes[grade]!;
    return base.copyWith(colorScheme: gradeScheme);
  }

  /// Exposed so callers (badge chips, status rows) can match a grade's primary
  /// swatch without reconstructing the scheme.
  static Color primaryOf(ReaderGrade grade) => schemes[grade]!.primary;
}

/// Convenience extension so UI code can look up the active grade's accent
/// without an import juggle:
///
/// ```dart
/// final accent = Theme.of(context).colorScheme.primary; // grade-themed
/// ```
///
/// No runtime logic lives here — the extension is purely documentation of
/// the intended access pattern alongside `AppTheme.lightPrimary`.
extension GradeThemeScheme on ThemeData {
  /// Whether this ThemeData's color scheme matches the base AppTheme primary.
  /// Useful in tests that assert a grade override actually took effect.
  bool get isBaseBrand => colorScheme.primary == AppTheme.lightPrimary;
}
