import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Exact token constants from Airbnb's DESIGN.md (`/awesome-design-md/
/// design-md/airbnb/DESIGN.md`).
///
/// Re-exported as a zero-instance class so other files can reference the
/// tokens by name (e.g. `AppPalette.rausch`) without rebuilding a [Color]
/// each time. The class name is brand-neutral on purpose — future
/// design-system swaps should only change this file's body, not every import
/// site.
///
/// Target user: Korean women in their 20s–30s. Airbnb's warm coral + editorial
/// serif palette reads "감성적 · 따뜻 · Instagram-friendly" for this audience
/// while keeping the "singular accent on a light canvas" discipline of the
/// reference brand.
class AppPalette {
  const AppPalette._();

  // -- Brand accent (Airbnb DESIGN.md §2 Primary Brand) ----------------------
  //
  // Rausch Red is Airbnb's singular chromatic accent; every primary CTA and
  // brand moment routes through this single hue. We expose Deep Rausch (the
  // pressed variant) so interaction states can darken without sliding off
  // the brand ladder.
  static const Color rausch = Color(0xFFFF385C); // §2 Rausch Red
  static const Color rauschDeep = Color(0xFFE00B41); // §2 Deep Rausch (pressed)
  static const Color errorRed = Color(0xFFC13515); // §2 Error Red
  static const Color errorRedDark = Color(0xFFB32505); // §2 Error hover

  // -- Premium tiers (DESIGN.md §2 Premium Tiers) ----------------------------
  //
  // Reused as grade seeds — Airbnb reserves these hues for Plus / Luxe, but
  // within Book Club's scope we borrow their editorial richness for the upper
  // reader tiers (열혈 독자 / 서재 마스터).
  static const Color luxePurple = Color(0xFF460479); // §2 Luxe Purple
  static const Color plusMagenta = Color(0xFF92174D); // §2 Plus Magenta

  // -- Text scale (DESIGN.md §2 Text Scale) ----------------------------------
  //
  // Near-black (`#222222`) is explicitly warm rather than pure black — the
  // "Do" rule in §7 forbids `#000000` for text on light surfaces.
  static const Color nearBlack = Color(0xFF222222); // §2 Near Black
  static const Color focusedGray = Color(0xFF3F3F3F); // §2 Focused Gray
  static const Color secondaryGray = Color(0xFF6A6A6A); // §2 Secondary text
  static const Color disabledText = Color(0x3D000000); // §2 rgba(0,0,0,0.24)
  static const Color disabledLink = Color(0xFF929292); // §2 Link Disabled

  // -- Interactive / surface (DESIGN.md §2 Interactive, Surface) -------------
  static const Color legalBlue = Color(0xFF428BFF); // §2 Legal Blue
  static const Color borderGray = Color(0xFFC1C1C1); // §2 Border Gray
  static const Color lightSurface = Color(0xFFF2F2F2); // §2 Light Surface
  static const Color pureWhite = Color(0xFFFFFFFF); // §2 Pure White

  // -- Warm off-white canvas ------------------------------------------------
  //
  // Airbnb's production site is pure white, but on a mobile Scaffold we warm
  // the canvas by 1 step so Rausch Red and warm serif headlines read cozy
  // rather than clinical. `#FAFAFA` is the idiomatic "Foggy" warm off-white
  // — sourced by reducing pure white just below perceptual threshold while
  // staying on the Airbnb neutral axis. Still inside §7's "near-white canvas"
  // rule (white dominates, Rausch is the only hue).
  static const Color foggy = Color(0xFFFAFAFA);

  // -- Grade seed hues (Airbnb §2 Rausch + §2 Premium Tiers) ----------------
  //
  // Each grade seed comes from the Airbnb palette. The progression moves
  // peach → coral → Rausch → plum → Babu-blue so the five reader tiers read
  // as a warm-to-deep editorial ladder rather than a rainbow.
  //
  // Peach / Beach: softened from Rausch so grade 1 feels gentle and inviting.
  // Babu: a deep teal-blue cool contrast at the top of the warm family, used
  // for "mastery" per the design brief.
  static const Color beachPeach = Color(0xFFFFB199); // grade 1 soft peach
  static const Color rauschLite = Color(0xFFFF7A8A); // grade 2 coral-lite
  static const Color hackberry = Color(0xFF8B1D41); // grade 4 deep plum
  static const Color babu = Color(0xFF00727A); // grade 5 deep teal

  // -- Dark-mode variants ---------------------------------------------------
  //
  // Airbnb's dark palette isn't enumerated token-by-token in §2, so we derive
  // from the same hues tuned one step lighter/desaturated for legibility on
  // a near-black canvas (`#1C1C1E`). Rausch itself stays visually close to
  // the brand on dark — Airbnb's in-app dark mode keeps the coral saturated
  // rather than graying it out, which preserves brand recognition.
  static const Color rauschDark = Color(0xFFFF5A7A); // dark-canvas Rausch
  static const Color beachPeachDark = Color(0xFFFFC4AF);
  static const Color rauschLiteDark = Color(0xFFFF96A4);
  static const Color hackberryDark = Color(0xFFC25478);
  static const Color babuDark = Color(0xFF2FA3AA);

  // Dark surfaces — warm-neutral variant of iOS dark greys, aligned with the
  // Airbnb "near-black, not cold black" principle (§7 Do rule).
  static const Color darkCanvas = Color(0xFF161616); // page background
  static const Color darkSurface1 = Color(0xFF1F1F1F); // elevated card
  static const Color darkSurface2 = Color(0xFF262626);
  static const Color darkSurface3 = Color(0xFF2E2E2E);
  static const Color darkDivider = Color(0xFF3A3A3A);
  static const Color darkTextPrimary = Color(0xFFF2F2F2);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);

  // -- Back-compat aliases ---------------------------------------------------
  //
  // Tests / older call sites still reference `AppPalette.brand` and
  // `AppPalette.parchment`; we keep the names stable and re-point them to
  // the Airbnb equivalents. `brand` = Rausch (singular accent), `parchment`
  // = Foggy warm canvas.
  static const Color brand = rausch;
  static const Color parchment = foggy;
}

/// 8-pt spacing grid (Airbnb DESIGN.md §5 "Spacing System").
///
/// Airbnb's scale is 2 / 3 / 4 / 6 / 8 / 10 / 11 / 12 / 15 / 16 / 22 / 24 / 32
/// — generous, travel-magazine-style. We surface the 5 disciplined steps the
/// app uses; calling code pulls raw numbers only when documenting an Airbnb
/// native value (e.g. 12px listing-card gutter) out of the extension.
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  /// Airbnb 8-pt travel-magazine scale: 4 / 8 / 16 / 24 / 32.
  /// 12 and 48 are intentionally not surfaced — use md/lg with inline tweaks
  /// only if the DESIGN.md reference demands it (keeps call sites disciplined).
  static const AppSpacing standard = AppSpacing(
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  );

  @override
  AppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) {
      return this;
    }
    return AppSpacing(
      xs: _lerp(xs, other.xs, t),
      sm: _lerp(sm, other.sm, t),
      md: _lerp(md, other.md, t),
      lg: _lerp(lg, other.lg, t),
      xl: _lerp(xl, other.xl, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

/// Border-radius scale from DESIGN.md §5 "Border Radius Scale".
///
/// Airbnb's radius ladder is:
///   4   (subtle — small links)
///   8   (buttons, search elements, tabs)
///   14  (status badges, labels)
///   20  (listing cards, feature buttons)
///   32  (large containers, hero elements)
///   50% (circular — nav controls, avatars)
///
/// We remap to a 5-step rectangular ramp plus a `pill` sentinel (1000) for
/// outlined pill CTAs that substitute for circle-percent-radius rectangles.
@immutable
class AppRadius extends ThemeExtension<AppRadius> {
  const AppRadius({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xLarge,
    required this.pill,
  });

  final double sm;
  final double md;
  final double lg;
  final double xLarge;
  final double pill;

  /// Airbnb rectangular radius ramp.
  /// - sm     =  8 (primary buttons, search controls — §4 Buttons)
  /// - md     = 12 (cards — canonical Airbnb listing card rounding)
  /// - lg     = 16 (elevated feature panels)
  /// - xLarge = 20 (hero modules, modal sheets — §5 Card)
  /// - pill   = 1000 (outlined pill CTAs substituting the 50% circle radius)
  static const AppRadius standard = AppRadius(
    sm: 8,
    md: 12,
    lg: 16,
    xLarge: 20,
    pill: 1000,
  );

  @override
  AppRadius copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xLarge,
    double? pill,
  }) {
    return AppRadius(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xLarge: xLarge ?? this.xLarge,
      pill: pill ?? this.pill,
    );
  }

  @override
  AppRadius lerp(ThemeExtension<AppRadius>? other, double t) {
    if (other is! AppRadius) {
      return this;
    }
    return AppRadius(
      sm: _lerp(sm, other.sm, t),
      md: _lerp(md, other.md, t),
      lg: _lerp(lg, other.lg, t),
      xLarge: _lerp(xLarge, other.xLarge, t),
      pill: _lerp(pill, other.pill, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

/// Airbnb's signature three-layer card shadow system (DESIGN.md §6).
///
/// Airbnb layers three translucent casts to create a warm, natural lift:
///   Layer 1 (`0px 0px 0px 1px` at 0.02) — ultra-subtle border ring.
///   Layer 2 (`0px 2px 6px`    at 0.04) — soft ambient halo.
///   Layer 3 (`0px 4px 8px`    at 0.10) — primary lift.
///
/// Flutter's [BoxShadow] can't reproduce the `0 0 0 1px` inset-border layer
/// directly (that's a spread shadow with zero blur), so we express it as a
/// zero-offset shadow with `spreadRadius: 1` — this renders as a faint ring
/// at the card edge, matching Airbnb's first layer.
///
/// * [ambient] — hairline separation for stacked surfaces (nav strip).
/// * [elevated] — the full three-layer listing-card shadow.
/// * [overlay] — modal / sheet on top of photographic backgrounds (Layer 2
///   and Layer 3 boosted for contrast against imagery).
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    required this.ambient,
    required this.elevated,
    required this.overlay,
  });

  final List<BoxShadow> ambient;
  final List<BoxShadow> elevated;
  final List<BoxShadow> overlay;

  static const AppShadows light = AppShadows(
    ambient: <BoxShadow>[
      BoxShadow(
        color: Color(0x14000000), // rgba(0,0,0,0.08) — §6 Hover halo
        offset: Offset(0, 4),
        blurRadius: 12,
      ),
    ],
    elevated: <BoxShadow>[
      // Layer 1 — border ring (0 0 0 1px at 0.02)
      BoxShadow(
        color: Color(0x05000000), // rgba(0,0,0,0.02)
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // Layer 2 — soft ambient (0 2px 6px at 0.04)
      BoxShadow(
        color: Color(0x0A000000), // rgba(0,0,0,0.04)
        offset: Offset(0, 2),
        blurRadius: 6,
      ),
      // Layer 3 — primary lift (0 4px 8px at 0.10)
      BoxShadow(
        color: Color(0x1A000000), // rgba(0,0,0,0.10)
        offset: Offset(0, 4),
        blurRadius: 8,
      ),
    ],
    overlay: <BoxShadow>[
      BoxShadow(
        color: Color(0x14000000),
        offset: Offset(0, 4),
        blurRadius: 12,
      ),
      BoxShadow(
        color: Color(0x33000000), // rgba(0,0,0,0.20) for modal/photo backs
        offset: Offset(0, 16),
        blurRadius: 48,
      ),
    ],
  );

  static const AppShadows dark = AppShadows(
    ambient: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 2),
        blurRadius: 8,
      ),
    ],
    elevated: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: Color(0x4D000000),
        offset: Offset(0, 2),
        blurRadius: 6,
      ),
      BoxShadow(
        color: Color(0x66000000),
        offset: Offset(0, 4),
        blurRadius: 12,
      ),
    ],
    overlay: <BoxShadow>[
      BoxShadow(
        color: Color(0x4D000000),
        offset: Offset(0, 4),
        blurRadius: 12,
      ),
      BoxShadow(
        color: Color(0x99000000),
        offset: Offset(0, 16),
        blurRadius: 48,
      ),
    ],
  );

  @override
  AppShadows copyWith({
    List<BoxShadow>? ambient,
    List<BoxShadow>? elevated,
    List<BoxShadow>? overlay,
  }) {
    return AppShadows(
      ambient: ambient ?? this.ambient,
      elevated: elevated ?? this.elevated,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}

/// Book Club light/dark themes wired to Airbnb's DESIGN.md tokens.
///
/// Light uses Foggy warm off-white (`#FAFAFA`) as the Scaffold canvas with
/// Near-Black (`#222222`) labels. Dark mirrors Airbnb's in-app dark mode with
/// a warm-neutral dark canvas (`#161616`) and a slightly lightened Rausch so
/// the coral stays recognisable against a dark background. Rausch Red is
/// the singular chromatic accent across both modes.
class AppTheme {
  const AppTheme._();

  /// Exposed so tests / clients can verify the Material-default purple has
  /// actually been replaced by Airbnb's Rausch Red.
  static const Color lightPrimary = AppPalette.rausch;

  static ThemeData get light => _build(
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        shadows: AppShadows.light,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        shadows: AppShadows.dark,
      );

  // -- Color schemes ---------------------------------------------------------
  //
  // Airbnb reserves chromatic budget for Rausch (primary CTA / brand) with
  // Luxe Purple + Plus Magenta as premium-tier accents. We map:
  //   primary              → Rausch Red (brand CTA)
  //   primaryContainer     → Deep Rausch (pressed / container shift)
  //   secondary            → Light Surface (neutral chip background)
  //   tertiary             → Plus Magenta (premium editorial accent)
  //   error                → Error Red
  //   surface              → Foggy (warm off-white canvas)

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.rausch,
    onPrimary: AppPalette.pureWhite,
    primaryContainer: AppPalette.rauschDeep,
    onPrimaryContainer: AppPalette.pureWhite,
    secondary: AppPalette.lightSurface,
    onSecondary: AppPalette.nearBlack,
    secondaryContainer: AppPalette.lightSurface,
    onSecondaryContainer: AppPalette.nearBlack,
    tertiary: AppPalette.plusMagenta,
    onTertiary: AppPalette.pureWhite,
    error: AppPalette.errorRed,
    onError: AppPalette.pureWhite,
    surface: AppPalette.foggy,
    onSurface: AppPalette.nearBlack,
    surfaceContainerLowest: AppPalette.pureWhite,
    surfaceContainerLow: AppPalette.foggy,
    surfaceContainer: AppPalette.lightSurface,
    surfaceContainerHigh: AppPalette.lightSurface,
    surfaceContainerHighest: Color(0xFFEBEBEB),
    onSurfaceVariant: AppPalette.secondaryGray,
    outline: AppPalette.borderGray,
    outlineVariant: Color(0xFFE4E4E4),
    inverseSurface: AppPalette.nearBlack,
    onInverseSurface: AppPalette.pureWhite,
    inversePrimary: AppPalette.rauschLite,
    shadow: Color(0x1A000000),
    scrim: Color(0x66000000),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.rauschDark,
    onPrimary: AppPalette.pureWhite,
    primaryContainer: AppPalette.rausch,
    onPrimaryContainer: AppPalette.pureWhite,
    secondary: AppPalette.darkSurface2,
    onSecondary: AppPalette.darkTextPrimary,
    secondaryContainer: AppPalette.darkSurface3,
    onSecondaryContainer: AppPalette.darkTextPrimary,
    tertiary: AppPalette.plusMagenta,
    onTertiary: AppPalette.pureWhite,
    error: AppPalette.errorRedDark,
    onError: AppPalette.pureWhite,
    surface: AppPalette.darkCanvas,
    onSurface: AppPalette.darkTextPrimary,
    surfaceContainerLowest: Color(0xFF0F0F0F),
    surfaceContainerLow: AppPalette.darkCanvas,
    surfaceContainer: AppPalette.darkSurface1,
    surfaceContainerHigh: AppPalette.darkSurface2,
    surfaceContainerHighest: AppPalette.darkSurface3,
    onSurfaceVariant: AppPalette.darkTextSecondary,
    outline: AppPalette.darkDivider,
    outlineVariant: AppPalette.darkSurface3,
    inverseSurface: AppPalette.foggy,
    onInverseSurface: AppPalette.nearBlack,
    inversePrimary: AppPalette.rausch,
    shadow: Color(0x66000000),
    scrim: Color(0x99000000),
  );

  // -- Typography ------------------------------------------------------------

  /// Builds the app's [TextTheme] from Airbnb's DESIGN.md §3 hierarchy.
  ///
  /// Font substitution note:
  /// Airbnb's proprietary **Cereal VF** family is not redistributable through
  /// `google_fonts`. We substitute with two families chosen specifically for
  /// a Korean 20–30대 여성 reading-app audience (감성적, 따뜻, 매거진 감성):
  ///
  ///  * Display / headings → **Playfair Display** (google_fonts).
  ///    Picked over DM Serif Display because Playfair keeps a warmer editorial
  ///    serif at medium weight (w500), closer to Cereal Medium's approachable
  ///    warmth than DM Serif's higher contrast bracketed serifs. Matches the
  ///    magazine-style headline voice the design brief calls for.
  ///
  ///  * Body / UI → **Inter** (google_fonts).
  ///    Picked over Plus Jakarta Sans because Inter has better Korean-glyph
  ///    fallback rendering in Flutter's default text layout and its humanist
  ///    x-height better approximates Cereal Book's UI clarity at 14–17px.
  ///
  /// Weight / tracking / line-height are preserved from DESIGN.md §3:
  ///   Section Heading    → 28 / 700 / 1.43 / normal
  ///   Card Heading       → 22 / 600 / 1.18 / -0.44
  ///   Sub-heading        → 21 / 700 / 1.43 / normal
  ///   Feature Title      → 20 / 600 / 1.20 / -0.18
  ///   UI Medium          → 16 / 500 / 1.25 / normal
  ///   Button             → 16 / 500 / 1.25 / normal
  ///   Body               → 14 / 400 / 1.43 / normal
  ///   Body Medium        → 14 / 500 / 1.29 / normal
  ///   Small              → 13 / 400 / 1.23 / normal
  ///   Tag                → 12 / 400–700 / 1.33 / normal
  ///   Badge              → 11 / 600 / 1.18 / normal
  ///
  /// Flutter M3 TextTheme mapping:
  ///   Display serif      → displayLarge / displayMedium / displaySmall
  ///                        (Playfair Display — hero & section headlines)
  ///   Title / UI sans    → headlineLarge / headlineMedium / titleLarge ...
  ///                        (Inter — screens, cards, buttons)
  ///   Body / caption     → bodyLarge / bodyMedium / bodySmall / label*
  ///                        (Inter — reading content)
  ///
  /// We also upsize the display scale by one step beyond Airbnb's web scale:
  /// mobile hero headlines read intimate at ~40px / w500 (the HomeScreen
  /// "Book Club" headline) rather than the web's 28px Section Heading.
  static TextTheme buildTextTheme(Color onSurface, Color mutedOnSurface) {
    final TextStyle serifBase = GoogleFonts.playfairDisplay(color: onSurface);
    final TextStyle sansBase = GoogleFonts.inter(color: onSurface);

    return TextTheme(
      // Mobile hero serif — 40 / 500 / 1.15 / -0.44 (upsized from DESIGN.md
      // §3 Card Heading Medium; mobile hero title requires the extra scale).
      displayLarge: serifBase.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        height: 1.15,
        letterSpacing: -0.44,
      ),
      // §3 Section Heading — 28 / 700 / 1.43 / normal. Editorial serif.
      displayMedium: serifBase.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.28,
        letterSpacing: -0.36,
      ),
      // §3 Card Heading — 22 / 600 / 1.18 / -0.44. Editorial serif.
      displaySmall: serifBase.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.18,
        letterSpacing: -0.44,
      ),

      // §3 Sub-heading — 21 / 700 / 1.43. Serif for editorial continuity.
      headlineLarge: serifBase.copyWith(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        height: 1.28,
        letterSpacing: -0.2,
      ),
      // §3 Feature Title — 20 / 600 / 1.20 / -0.18. Serif.
      headlineMedium: serifBase.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.20,
        letterSpacing: -0.18,
      ),
      // §3 UI Semibold — 16 / 600 / 1.25. Sans for UI metadata rows.
      headlineSmall: sansBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),

      // Title-family → UI sans (Inter). App bars / card titles / form labels.
      // §3 UI Semibold — 16 / 600 / 1.25.
      titleLarge: sansBase.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.22,
        letterSpacing: -0.18,
      ),
      // §3 UI Medium — 16 / 500 / 1.25.
      titleMedium: sansBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      // §3 Body Medium — 14 / 500 / 1.29.
      titleSmall: sansBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.29,
      ),

      // §3 Body — 14 / 400 / 1.43. Mobile bumps to 17 so Korean text stays
      // comfortable on the HomeScreen hero block (Airbnb's own mobile app
      // uses a similar 16–17 baseline rather than the web's 14).
      bodyLarge: sansBase.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.47,
        color: mutedOnSurface,
      ),
      // §3 Body — 14 / 400 / 1.43. Standard body copy.
      bodyMedium: sansBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
      ),
      // §3 Small — 13 / 400 / 1.23.
      bodySmall: sansBase.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.38,
        color: mutedOnSurface,
      ),

      // §3 Button — 16 / 500 / 1.25.
      labelLarge: sansBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      // §3 Tag — 12 / 500 / 1.33.
      labelMedium: sansBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
      ),
      // §3 Badge — 11 / 600 / 1.18.
      labelSmall: sansBase.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.18,
      ),
    );
  }

  // -- Theme assembly --------------------------------------------------------

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required AppShadows shadows,
  }) {
    final Color onSurface = colorScheme.onSurface;
    final Color muted = colorScheme.onSurfaceVariant;
    final TextTheme textTheme = buildTextTheme(onSurface, muted);
    final bool isLight = brightness == Brightness.light;

    // 44×44 is the WCAG / mobile accessibility baseline for touch targets,
    // which Airbnb also respects in their pill CTAs.
    const Size minimumTouch = Size(44, 44);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[
        AppSpacing.standard,
        AppRadius.standard,
        shadows,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      // Primary FilledButton — Rausch Red fill, white label, 12px radius.
      // DESIGN.md §4 Buttons uses 8px for the web-scale dark button; for
      // mobile we step up to 12px to match the listing-card corner language
      // the rest of the app inherits (§5 Card: 20px large, 12px mobile CTA).
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.primary.withValues(alpha: 0.38);
            }
            if (states.contains(WidgetState.pressed)) {
              return AppPalette.rauschDeep; // §2 Deep Rausch on press
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
          minimumSize: const WidgetStatePropertyAll<Size>(minimumTouch),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          elevation: const WidgetStatePropertyAll<double>(0),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppPalette.rauschDeep.withValues(alpha: 0.12);
            }
            return null;
          }),
        ),
      ),
      // ElevatedButton repurposed as a Rausch-tinted soft button — light
      // coral wash background, Rausch text. Keeps Flutter widgets that
      // default to ElevatedButton on a brand-compliant style without forcing
      // each feature to switch to FilledButton.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight
              ? AppPalette.rausch.withValues(alpha: 0.10)
              : AppPalette.rauschDark.withValues(alpha: 0.22),
          foregroundColor: isLight ? AppPalette.rausch : AppPalette.rauschDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: minimumTouch,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      // OutlinedButton → pill CTA (radius 1000). Neutral border, Rausch text,
      // matching Airbnb's "Become a host" / category-pill treatment.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppPalette.rauschDeep;
            }
            return colorScheme.primary;
          }),
          side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
            final Color border =
                isLight ? AppPalette.borderGray : AppPalette.darkDivider;
            if (states.contains(WidgetState.pressed)) {
              return BorderSide(color: colorScheme.primary, width: 1.5);
            }
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: colorScheme.primary, width: 2);
            }
            return BorderSide(color: border);
          }),
          minimumSize: const WidgetStatePropertyAll<Size>(minimumTouch),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(1000)),
            ),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppPalette.rausch.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: minimumTouch,
          textStyle: textTheme.labelLarge,
        ),
      ),
      // Card — Airbnb's canonical listing card. 12px radius, 3-layer shadow
      // lives on the container that wraps the card; CardTheme itself stays
      // shadow-free to avoid double-shadowing when AppShadows.elevated is
      // applied at the usage site.
      cardTheme: CardThemeData(
        color: isLight ? AppPalette.pureWhite : AppPalette.darkSurface1,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppPalette.pureWhite : AppPalette.darkSurface2,
        // §4 Inputs — search bar uses pill-like rounding. 12px here is a
        // compromise between Airbnb's 8px button and 32px pill so text fields
        // read as "card" elements within a form.
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: isLight ? AppPalette.borderGray : AppPalette.darkDivider,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: isLight ? AppPalette.borderGray : AppPalette.darkDivider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2, // §4 Inputs focus ring
          ),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color:
              isLight ? AppPalette.disabledLink : AppPalette.darkTextSecondary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isLight ? AppPalette.borderGray : AppPalette.darkDivider,
        thickness: 0.5, // keep divider hairline; warm neutral
        space: 0.5,
      ),
      iconTheme: IconThemeData(
        color:
            isLight ? AppPalette.secondaryGray : AppPalette.darkTextSecondary,
      ),
    );
  }
}
