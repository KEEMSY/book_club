import 'package:flutter/material.dart';

import 'app_theme.dart';

/// 5-grade reader tier (see `docs/plans/2026-04-20-book-club-design.md §5.2`).
///
/// Seeds are drawn from Airbnb's DESIGN.md palette — Rausch (§2 Primary),
/// Luxe Purple / Plus Magenta (§2 Premium Tiers), and derived warm neutrals
/// (§2 Text / Interactive). The progression moves peach → coral-lite → Rausch
/// → plum → deep teal so the five tiers read as a "warm editorial ladder"
/// rather than a rainbow — matching the magazine tone the target user
/// (한국 20–30대 여성) responds to.
///
///   1 · 새싹 독자     · Beach Peach  — entry, gentle
///   2 · 탐독자        · Rausch-lite  — one step warmer
///   3 · 애독자        · Rausch       — the brand "main citizen" grade
///   4 · 열혈 독자     · Hackberry    — richer, deeper plum
///   5 · 서재 마스터   · Babu         — deep teal-blue, cool mastery contrast
enum ReaderGrade {
  sprout,
  explorer,
  devoted,
  passionate,
  master,
}

/// Per-grade ColorScheme factory for the timer / heatmap / profile badge.
///
/// Each entry seeds a light (and dark) `ColorScheme.fromSeed`, then [apply]
/// merges that scheme onto a caller-supplied base `ThemeData` so the rest of
/// the theme (typography, spacing extensions, shadows) stays intact — only
/// chromatic surfaces shift.
class GradeTheme {
  const GradeTheme._();

  // -- Seed colors -----------------------------------------------------------
  //
  // Light + dark variants sourced directly from Airbnb tokens on [AppPalette]
  // so each grade inherits the brand's chromatic vocabulary.
  static const Color _sproutSeedLight = AppPalette.beachPeach;
  static const Color _sproutSeedDark = AppPalette.beachPeachDark;
  static const Color _explorerSeedLight = AppPalette.rauschLite;
  static const Color _explorerSeedDark = AppPalette.rauschLiteDark;
  static const Color _devotedSeedLight = AppPalette.rausch;
  static const Color _devotedSeedDark = AppPalette.rauschDark;
  static const Color _passionateSeedLight = AppPalette.hackberry;
  static const Color _passionateSeedDark = AppPalette.hackberryDark;
  static const Color _masterSeedLight = AppPalette.babu;
  static const Color _masterSeedDark = AppPalette.babuDark;

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

  /// Dark-mode variants — matching seeds at `Brightness.dark`.
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
  /// (`AppSpacing`, `AppRadius`, `AppShadows`), `AppBarTheme`, buttons — are
  /// preserved so the grade color is purely a chromatic overlay on the base.
  static ThemeData apply(ThemeData base, ReaderGrade grade) {
    final ColorScheme gradeScheme = base.brightness == Brightness.dark
        ? darkSchemes[grade]!
        : schemes[grade]!;
    return base.copyWith(colorScheme: gradeScheme);
  }

  /// Exposed so callers (badge chips, status rows) can match a grade's
  /// primary swatch without reconstructing the scheme.
  static Color primaryOf(ReaderGrade grade) => schemes[grade]!.primary;
}

/// Convenience extension so UI code can check whether a `ThemeData` still
/// carries the base brand primary (used by tests asserting that a grade
/// override actually took effect).
extension GradeThemeScheme on ThemeData {
  /// Whether this ThemeData's color scheme matches the base AppTheme primary.
  bool get isBaseBrand => colorScheme.primary == AppTheme.lightPrimary;
}
