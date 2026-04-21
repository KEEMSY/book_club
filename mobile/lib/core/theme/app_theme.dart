import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Exact token constants from Apple's HIG / apple.com DESIGN.md.
///
/// Re-exported as a zero-instance class so other files can reference the tokens
/// by name (e.g. `AppPalette.systemBlue`) without rebuilding a [Color] each
/// time. The class name is brand-neutral on purpose — future design-system
/// swaps should only change this file's body, not every import site.
///
/// Values are kept in lock-step with
/// `/awesome-design-md/design-md/apple/DESIGN.md`. iOS system colors that the
/// markdown doesn't enumerate verbatim are pulled straight from Apple's
/// published HIG light/dark system palette so the brand intent stays on-spec.
class AppPalette {
  const AppPalette._();

  // -- Chromatic accent (iOS system colors) ----------------------------------
  //
  // Apple Blue is the ONLY chromatic accent on apple.com (DESIGN.md §2
  // "Interactive"). The HIG publishes per-hue light/dark pairs; we expose both
  // so grade-themed surfaces can pull from the exact system palette.
  static const Color systemBlue = Color(0xFF0071E3); // DESIGN.md §2 Interactive
  static const Color systemBlueDark = Color(0xFF0A84FF); // HIG iOS dark
  static const Color linkBlue = Color(0xFF0066CC); // DESIGN.md §2 body links
  static const Color brightBlue = Color(0xFF2997FF); // DESIGN.md §2 dark links

  // Grade seeds sourced from Apple's published system colors (HIG).
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemGreenDark = Color(0xFF30D158);
  static const Color systemTeal = Color(0xFF30B0C7);
  static const Color systemTealDark = Color(0xFF40C8E0);
  static const Color systemIndigo = Color(0xFF5856D6);
  static const Color systemIndigoDark = Color(0xFF5E5CE6);
  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemOrangeDark = Color(0xFFFF9F0A);
  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemRedDark = Color(0xFFFF453A);

  // -- Canonical background / text tones -------------------------------------
  //
  // DESIGN.md §2 Primary — pure black + "not-white" light gray with its slight
  // blue-gray tint, plus near-black for text on the light canvas.
  static const Color pureBlack = Color(0xFF000000);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F7); // systemBackground (light)
  static const Color nearBlack = Color(0xFF1D1D1F); // primary text on light

  // -- iOS system gray scale (HIG, light) ------------------------------------
  static const Color systemGray = Color(0xFF8E8E93); // Gray 1
  static const Color systemGray2 = Color(0xFFAEAEB2);
  static const Color systemGray3 = Color(0xFFC7C7CC);
  static const Color systemGray4 = Color(0xFFD1D1D6);
  static const Color systemGray5 = Color(0xFFE5E5EA);
  static const Color systemGray6 = Color(0xFFF2F2F7); // iOS secondarySystemBg

  // iOS system gray scale (HIG, dark)
  static const Color systemGrayDark = Color(0xFF8E8E93);
  static const Color systemGray2Dark = Color(0xFF636366);
  static const Color systemGray3Dark = Color(0xFF48484A);
  static const Color systemGray4Dark = Color(0xFF3A3A3C);
  static const Color systemGray5Dark = Color(0xFF2C2C2E);
  static const Color systemGray6Dark = Color(0xFF1C1C1E);

  // -- Dark surface ramp (DESIGN.md §2 Surface & Dark Variants) --------------
  static const Color darkSurface1 = Color(0xFF272729);
  static const Color darkSurface2 = Color(0xFF262628);
  static const Color darkSurface3 = Color(0xFF28282A);
  static const Color darkSurface4 = Color(0xFF2A2A2D);
  static const Color darkSurface5 = Color(0xFF242426);

  // -- Labels (HIG iOS semantic label colors) --------------------------------
  //
  // DESIGN.md §2 Text documents the rgba breakdown we translate to label /
  // secondaryLabel / tertiaryLabel.
  static const Color label = nearBlack;
  static const Color labelDark = pureWhite;
  static const Color secondaryLabel = Color(0xCC000000); // rgba(0,0,0,0.8)
  static const Color secondaryLabelDark =
      Color(0xCCFFFFFF); // rgba(255,.,.,0.8)
  static const Color tertiaryLabel = Color(0x7A000000); // rgba(0,0,0,0.48)
  static const Color tertiaryLabelDark = Color(0x7AFFFFFF);

  // Separator / fill (HIG).
  static const Color separator = Color(0x4D3C3C43); // rgba(60,60,67,0.30)
  static const Color separatorDark = Color(0x99545458); // rgba(84,84,88,0.60)
  static const Color fill = Color(0x33787880); // rgba(120,120,128,0.20)
  static const Color fillDark = Color(0x5C787880); // rgba(120,120,128,0.36)

  // -- Back-compat aliases ---------------------------------------------------
  //
  // These names survive from earlier revisions so the grade theme / tests can
  // continue asserting `AppPalette.brand` / `AppPalette.parchment`. Keep them
  // pointed at the Apple-system equivalents so "brand = primary accent" stays
  // true on the new design system.
  static const Color brand = systemBlue;
  static const Color parchment = lightGray;
}

/// iOS 8-pt spacing grid (DESIGN.md §5 "Spacing System").
///
/// The five roles the app uses are exposed directly; we intentionally do not
/// surface every raw step from the Apple scale (2/4/5/6/7/8/9/10/11/14/15/17)
/// to keep call sites disciplined.
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

  /// iOS 8-pt standard: 4 / 8 / 16 / 24 / 32.
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

/// Border-radius scale from DESIGN.md §5 "Border Radius Scale", remapped to
/// Apple's rectangular-element conventions (8 / 12 / 16 / 20).
///
/// DESIGN.md also defines a 980px pill radius for CTA links — we represent it
/// via [pill] but use it sparingly (HIG "Don'ts": rounded corners > 12px on
/// rectangular elements are avoided; 980px is for pill chips only).
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

  /// Apple rectangular radius ramp.
  /// - sm     =  8 (buttons, product cards, image containers — DESIGN.md §4)
  /// - md     = 12 (large feature panels, lifestyle image containers)
  /// - lg     = 16 (hero modules)
  /// - xLarge = 20 (modal sheets, rare large surfaces)
  /// - pill   = 980 (CTA pills — "Learn more", "Shop")
  static const AppRadius standard = AppRadius(
    sm: 8,
    md: 12,
    lg: 16,
    xLarge: 20,
    pill: 980,
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

/// Apple's elevation system is deliberately sparse (DESIGN.md §6). Instead of
/// Material's punchy drop shadows we layer a tight near-shadow with a wider,
/// low-opacity ambient shadow — together they approximate the soft diffused
/// studio-light look the HIG describes.
///
/// * [ambient] — subtle separation for stacked surfaces (nav strip, tab bar).
/// * [elevated] — the signature "product card" shadow
///   (`rgba(0,0,0,0.22) 3px 5px 30px 0px` — DESIGN.md §6 Subtle Lift).
/// * [overlay] — modal / floating sheet, pairing the card shadow with an
///   extra soft ambient to read clearly above photographic backgrounds.
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
        color: Color(0x0F000000), // rgba(0,0,0,0.06)
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
    elevated: <BoxShadow>[
      BoxShadow(
        color: Color(0x0A000000), // tight near-shadow, rgba(0,0,0,0.04)
        offset: Offset(0, 1),
        blurRadius: 3,
      ),
      BoxShadow(
        color: Color(0x38000000), // rgba(0,0,0,0.22) — DESIGN.md §6
        offset: Offset(3, 5),
        blurRadius: 30,
      ),
    ],
    overlay: <BoxShadow>[
      BoxShadow(
        color: Color(0x14000000), // rgba(0,0,0,0.08)
        offset: Offset(0, 2),
        blurRadius: 8,
      ),
      BoxShadow(
        color: Color(0x38000000),
        offset: Offset(0, 12),
        blurRadius: 40,
      ),
    ],
  );

  static const AppShadows dark = AppShadows(
    ambient: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000), // rgba(0,0,0,0.20)
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
    elevated: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 1),
        blurRadius: 3,
      ),
      BoxShadow(
        color: Color(0x66000000), // deeper cast on black canvas
        offset: Offset(3, 5),
        blurRadius: 30,
      ),
    ],
    overlay: <BoxShadow>[
      BoxShadow(
        color: Color(0x4D000000),
        offset: Offset(0, 2),
        blurRadius: 8,
      ),
      BoxShadow(
        color: Color(0x80000000),
        offset: Offset(0, 12),
        blurRadius: 40,
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
    // Shadow lists don't interpolate cleanly across themes; snap at midpoint.
    if (other is! AppShadows) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}

/// Book Club light/dark themes wired to Apple's HIG + apple.com tokens.
///
/// Light uses iOS systemBackground (`#f5f5f7`) as the page canvas with near-
/// black labels. Dark mirrors iOS dark mode with pure black backgrounds and
/// the darkened iOS accent blue. Apple Blue is the singular chromatic accent.
class AppTheme {
  const AppTheme._();

  /// Exposed so tests / clients can verify the Material-default purple has
  /// actually been replaced by Apple's singular accent.
  static const Color lightPrimary = AppPalette.systemBlue;

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
  // Apple's visual system reserves its entire chromatic budget for Apple Blue
  // (DESIGN.md §7 Do / Don't). We therefore avoid mapping secondary / tertiary
  // slots onto additional hues and instead use the iOS gray ramp so the UI
  // retains the "singular accent against neutrals" rhythm.

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.systemBlue,
    onPrimary: AppPalette.pureWhite,
    primaryContainer: AppPalette.linkBlue,
    onPrimaryContainer: AppPalette.pureWhite,
    secondary: AppPalette.systemGray6,
    onSecondary: AppPalette.label,
    secondaryContainer: AppPalette.systemGray5,
    onSecondaryContainer: AppPalette.label,
    tertiary: AppPalette.nearBlack,
    onTertiary: AppPalette.pureWhite,
    error: AppPalette.systemRed,
    onError: AppPalette.pureWhite,
    surface: AppPalette.lightGray, // iOS systemBackground (light)
    onSurface: AppPalette.label,
    surfaceContainerLowest: AppPalette.pureWhite,
    surfaceContainerLow: AppPalette.systemGray6,
    surfaceContainer: AppPalette.systemGray6,
    surfaceContainerHigh: AppPalette.systemGray5,
    surfaceContainerHighest: AppPalette.systemGray4,
    onSurfaceVariant: AppPalette.secondaryLabel,
    outline: AppPalette.separator,
    outlineVariant: AppPalette.systemGray5,
    inverseSurface: AppPalette.nearBlack,
    onInverseSurface: AppPalette.pureWhite,
    inversePrimary: AppPalette.brightBlue,
    shadow: Color(0x38000000),
    scrim: Color(0x66000000),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.systemBlueDark,
    onPrimary: AppPalette.pureWhite,
    primaryContainer: AppPalette.systemBlue,
    onPrimaryContainer: AppPalette.pureWhite,
    secondary: AppPalette.systemGray5Dark,
    onSecondary: AppPalette.labelDark,
    secondaryContainer: AppPalette.systemGray4Dark,
    onSecondaryContainer: AppPalette.labelDark,
    tertiary: AppPalette.darkSurface1,
    onTertiary: AppPalette.labelDark,
    error: AppPalette.systemRedDark,
    onError: AppPalette.pureWhite,
    surface: AppPalette.pureBlack, // iOS systemBackground (dark)
    onSurface: AppPalette.labelDark,
    surfaceContainerLowest: AppPalette.pureBlack,
    surfaceContainerLow: AppPalette.systemGray6Dark,
    surfaceContainer: AppPalette.darkSurface1,
    surfaceContainerHigh: AppPalette.darkSurface3,
    surfaceContainerHighest: AppPalette.darkSurface4,
    onSurfaceVariant: AppPalette.secondaryLabelDark,
    outline: AppPalette.separatorDark,
    outlineVariant: AppPalette.systemGray4Dark,
    inverseSurface: AppPalette.lightGray,
    onInverseSurface: AppPalette.label,
    inversePrimary: AppPalette.systemBlue,
    shadow: Color(0x66000000),
    scrim: Color(0x99000000),
  );

  // -- Typography ------------------------------------------------------------

  /// Builds the app's [TextTheme] from Apple's HIG type scale.
  ///
  /// Font substitution note: Apple's proprietary "SF Pro Display / SF Pro
  /// Text" families are not redistributable through google_fonts. We fall back
  /// to **Inter** — the closest SF-adjacent free face on google_fonts — which
  /// shares SF's humanist, high-x-height, optical-sizing philosophy more than
  /// any other Google-hosted family. The Display/Text optical split is
  /// approximated by keeping weight 400 for body sizes (< 20px) and preferring
  /// weight 600 at 17px for emphasized-body / headline roles, matching HIG.
  ///
  /// HIG → Material 3 mapping:
  ///   Large Title (34/bold)      → displayLarge
  ///   Title 1     (28/regular)   → displayMedium
  ///   Title 2     (22/regular)   → displaySmall
  ///   Title 3     (20/regular)   → headlineLarge
  ///   Headline    (17/semibold)  → headlineMedium / titleMedium
  ///   Body        (17/regular)   → bodyLarge
  ///   Callout     (16/regular)   → bodyMedium
  ///   Subheadline (15/regular)   → titleSmall
  ///   Footnote    (13/regular)   → bodySmall
  ///   Caption 1   (12/regular)   → labelMedium
  ///   Caption 2   (11/regular)   → labelSmall
  ///
  /// Negative letter-spacing is applied at every size per DESIGN.md §3
  /// ("Negative tracking at all sizes").
  static TextTheme buildTextTheme(Color onSurface, Color mutedOnSurface) {
    final TextStyle base = GoogleFonts.inter(color: onSurface);

    return TextTheme(
      // Large Title — 34 / bold / 1.21 / -0.374
      displayLarge: base.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.21,
        letterSpacing: -0.374,
      ),
      // Title 1 — 28 / regular / 1.21 / -0.364
      displayMedium: base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.21,
        letterSpacing: -0.364,
      ),
      // Title 2 — 22 / regular / 1.27 / -0.26
      displaySmall: base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.27,
        letterSpacing: -0.26,
      ),
      // Title 3 — 20 / regular / 1.25 / -0.2
      headlineLarge: base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      // Headline — 17 / semibold / 1.29 / -0.374
      headlineMedium: base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.374,
      ),
      // Alt Headline slot (kept separate so callers that lean on
      // headlineSmall also land on a HIG-legal style).
      headlineSmall: base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.374,
      ),

      // Title-family — Apple Headline repeats as titleLarge / titleMedium so
      // Material widgets that default to these roles pick up HIG Headline.
      titleLarge: base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.374,
      ),
      titleMedium: base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.374,
      ),
      // Subheadline — 15 / regular / 1.33 / -0.24
      titleSmall: base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: -0.24,
      ),

      // Body — 17 / regular / 1.29 / -0.374
      bodyLarge: base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.29,
        letterSpacing: -0.374,
        color: mutedOnSurface,
      ),
      // Callout — 16 / regular / 1.31 / -0.31
      bodyMedium: base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.31,
        letterSpacing: -0.31,
      ),
      // Footnote — 13 / regular / 1.38 / -0.08
      bodySmall: base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.38,
        letterSpacing: -0.08,
        color: mutedOnSurface,
      ),

      // Label family — HIG Callout / Caption variants.
      labelLarge: base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.31,
        letterSpacing: -0.31,
      ),
      // Caption 1 — 12 / regular / 1.33 / 0
      labelMedium: base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
      // Caption 2 — 11 / regular / 1.36 / 0.07
      labelSmall: base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.36,
        letterSpacing: 0.07,
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

    // HIG minimum touch target (44×44 logical px) feeds button padding below.
    const Size iosMinimumTouch = Size(44, 44);

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
        titleTextStyle: textTheme.headlineMedium,
      ),
      // FilledButton is the app's iOS-tinted filled button: Apple Blue fill,
      // white label, 8px radius per DESIGN.md §4 Primary Blue CTA.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: iosMinimumTouch,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: textTheme.headlineMedium,
        ),
      ),
      // ElevatedButton is repurposed as the iOS "tinted" button: a soft
      // systemBlue tint on a blue-tinted background (not Material's raised
      // surface). Gives Flutter's raised-button call sites an HIG-compliant
      // default without requiring every feature to switch to FilledButton.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight
              ? AppPalette.systemBlue.withValues(alpha: 0.12)
              : AppPalette.systemBlueDark.withValues(alpha: 0.22),
          foregroundColor:
              isLight ? AppPalette.systemBlue : AppPalette.systemBlueDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: iosMinimumTouch,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: textTheme.headlineMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          minimumSize: iosMinimumTouch,
          // The signature Apple inline "Learn more / Shop" pill uses 980px
          // radius per DESIGN.md §4 Pill Link; we expose it through the
          // outlined variant so feature code can opt in without reinventing.
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(980)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: textTheme.headlineMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: iosMinimumTouch,
          textStyle: textTheme.headlineMedium,
        ),
      ),
      cardTheme: CardThemeData(
        color: isLight ? AppPalette.pureWhite : AppPalette.darkSurface1,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppPalette.pureWhite : AppPalette.systemGray6Dark,
        // HIG recommends 11px radius on search / filter controls (DESIGN.md
        // §4 Filter / Search Button); 12px content padding meets the 44px
        // touch-target minimum once line-height is factored in.
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(
            color: isLight ? AppPalette.separator : AppPalette.separatorDark,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(
            color: isLight ? AppPalette.separator : AppPalette.separatorDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2, // DESIGN.md §4 focus ring — `2px solid #0071E3`
          ),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color:
              isLight ? AppPalette.tertiaryLabel : AppPalette.tertiaryLabelDark,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isLight ? AppPalette.separator : AppPalette.separatorDark,
        thickness: 0.5, // iOS hairline
        space: 0.5,
      ),
      iconTheme: IconThemeData(
        color:
            isLight ? AppPalette.secondaryLabel : AppPalette.secondaryLabelDark,
      ),
    );
  }
}
