import 'package:flutter/material.dart';

import 'app_theme.dart';

/// 5-grade reader tier (see design doc §5.2).
///
/// Grade seeds are intentionally re-interpreted within Claude's warm,
/// parchment-and-ink palette. The raw "light green → emerald → blue → purple
/// → gold" brief is preserved as a *progression feel* — saturation and depth
/// step up across tiers — but each hue is pulled toward the earthy, warm
/// register so the grades still feel like they live inside a Claude-themed
/// reading app instead of a neon dashboard.
enum ReaderGrade {
  sprout, // 1 · 새싹 독자     · sage seedling green
  explorer, // 2 · 탐독자       · forest emerald
  devoted, // 3 · 애독자        · ink teal-blue
  passionate, // 4 · 열혈 독자  · aubergine plum
  master, // 5 · 서재 마스터    · antique gold
}

/// Per-grade ColorScheme factory for the timer / heatmap / profile badge.
///
/// Each entry seeds a light (and dark) `ColorScheme` from a deliberately
/// muted brand-adjacent hue, then [apply] merges that scheme onto a caller-
/// supplied base `ThemeData` so the rest of the theme (typography, spacing
/// extensions, shadows) stays intact — only chromatic surfaces shift.
class GradeTheme {
  const GradeTheme._();

  // -- Seed colors -----------------------------------------------------------
  //
  // Rationale for each pick (all staying warm-biased per DESIGN.md §7 Don'ts):
  //   sprout      #8AA978 — dusty sage; reads as "new growth" without the
  //                         supermarket-green vibrancy of a pure lime.
  //   explorer    #4F7A5C — a deeper forest / emerald; still low-saturation,
  //                         one noticeable step darker/richer than sprout.
  //   devoted     #3C6780 — a slate teal-blue; cooler than the rest of the
  //                         palette but warmth-adjusted (olive tint added)
  //                         so it still belongs next to Terracotta Brand.
  //   passionate  #6B4771 — muted aubergine/plum; "purple" filtered through
  //                         a warm red undertone, avoiding electric violet.
  //   master      #B2873B — antique gold / bronze; not yellow — a deep,
  //                         parchment-friendly metallic that caps the scale.
  static const Color _sproutSeed = Color(0xFF8AA978);
  static const Color _explorerSeed = Color(0xFF4F7A5C);
  static const Color _devotedSeed = Color(0xFF3C6780);
  static const Color _passionateSeed = Color(0xFF6B4771);
  static const Color _masterSeed = Color(0xFFB2873B);

  /// Light-mode grade schemes. Paired with [darkSchemes] for dark-mode runs.
  static final Map<ReaderGrade, ColorScheme> schemes =
      <ReaderGrade, ColorScheme>{
    ReaderGrade.sprout: ColorScheme.fromSeed(
      seedColor: _sproutSeed,
      brightness: Brightness.light,
    ),
    ReaderGrade.explorer: ColorScheme.fromSeed(
      seedColor: _explorerSeed,
      brightness: Brightness.light,
    ),
    ReaderGrade.devoted: ColorScheme.fromSeed(
      seedColor: _devotedSeed,
      brightness: Brightness.light,
    ),
    ReaderGrade.passionate: ColorScheme.fromSeed(
      seedColor: _passionateSeed,
      brightness: Brightness.light,
    ),
    ReaderGrade.master: ColorScheme.fromSeed(
      seedColor: _masterSeed,
      brightness: Brightness.light,
    ),
  };

  /// Dark-mode variants — same seeds, `Brightness.dark`.
  static final Map<ReaderGrade, ColorScheme> darkSchemes =
      <ReaderGrade, ColorScheme>{
    ReaderGrade.sprout: ColorScheme.fromSeed(
      seedColor: _sproutSeed,
      brightness: Brightness.dark,
    ),
    ReaderGrade.explorer: ColorScheme.fromSeed(
      seedColor: _explorerSeed,
      brightness: Brightness.dark,
    ),
    ReaderGrade.devoted: ColorScheme.fromSeed(
      seedColor: _devotedSeed,
      brightness: Brightness.dark,
    ),
    ReaderGrade.passionate: ColorScheme.fromSeed(
      seedColor: _passionateSeed,
      brightness: Brightness.dark,
    ),
    ReaderGrade.master: ColorScheme.fromSeed(
      seedColor: _masterSeed,
      brightness: Brightness.dark,
    ),
  };

  /// Returns [base] with the given grade's `ColorScheme` swapped in.
  ///
  /// All non-color aspects of the base theme — `TextTheme`, `ThemeExtension`s
  /// (`AppSpacing`, `AppRadius`, `AppShadows`), `AppBarTheme`, buttons, etc.
  /// — are preserved so the grade color is purely a chromatic overlay on the
  /// Claude base theme. Used by the M3 timer screen; see `docs/plans/...§5.2`.
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
