import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Exact brand color constants from the active design system.
///
/// Re-exported as a zero-instance class so other files can reference the tokens
/// by name (e.g. `AppPalette.brand`) without rebuilding a [Color] each time.
/// Values are kept in lock-step with the design-system markdown under
/// `/awesome-design-md/design-md/<system>/DESIGN.md`. The class name is kept
/// brand-neutral so future design-system swaps don't cascade through the
/// codebase.
class AppPalette {
  const AppPalette._();

  // Primary
  static const Color nearBlack = Color(0xFF141413); // Anthropic Near Black
  static const Color brand = Color(0xFFC96442); // Terracotta Brand
  static const Color coral = Color(0xFFD97757); // Coral Accent

  // Semantic
  static const Color errorCrimson = Color(0xFFB53333);
  static const Color focusBlue = Color(0xFF3898EC);

  // Surface & background
  static const Color parchment = Color(0xFFF5F4ED); // primary light bg
  static const Color ivory = Color(0xFFFAF9F5); // card / elevated light
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color warmSand = Color(0xFFE8E6DC); // secondary button bg
  static const Color darkSurface = Color(0xFF30302E); // dark containers
  static const Color deepDark = Color(0xFF141413); // dark page bg

  // Neutrals & text
  static const Color charcoalWarm = Color(0xFF4D4C48);
  static const Color oliveGray = Color(0xFF5E5D59);
  static const Color stoneGray = Color(0xFF87867F);
  static const Color darkWarm = Color(0xFF3D3D3A);
  static const Color warmSilver = Color(0xFFB0AEA5);

  // Borders & rings
  static const Color borderCream = Color(0xFFF0EEE6);
  static const Color borderWarm = Color(0xFFE8E6DC);
  static const Color borderDark = Color(0xFF30302E);
  static const Color ringWarm = Color(0xFFD1CFC5);
  static const Color ringDeep = Color(0xFFC2C0B6);
}

/// Spacing scale from DESIGN.md §5 ("Base unit: 8px; scale: 3,4,6,8,10,12,16,20,24,30").
///
/// Only the five roles explicitly listed in the task brief are exposed — we
/// intentionally do not surface every raw step to keep call sites disciplined.
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

/// Border-radius scale from DESIGN.md §5 ("Border Radius Scale").
///
/// Exposes the four specific values the task brief requires.
@immutable
class AppRadius extends ThemeExtension<AppRadius> {
  const AppRadius({
    required this.sm,
    required this.md,
    required this.lg,
    required this.pill,
  });

  final double sm;
  final double md;
  final double lg;
  final double pill;

  // sm  = subtly rounded (6-8 band → 8 standard cards/buttons)
  // md  = generously rounded (12) — primary buttons, inputs, nav
  // lg  = very rounded (16) — featured containers
  // pill = maximum rounded (32) — hero containers, embedded media
  static const AppRadius standard = AppRadius(
    sm: 8,
    md: 12,
    lg: 16,
    pill: 32,
  );

  @override
  AppRadius copyWith({
    double? sm,
    double? md,
    double? lg,
    double? pill,
  }) {
    return AppRadius(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
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
      pill: _lerp(pill, other.pill, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

/// Shadow tokens from DESIGN.md §6 ("Depth & Elevation").
///
/// Claude's signature is ring-based shadows (`0px 0px 0px 1px`) — Flutter has
/// no direct equivalent to CSS ring shadows, so we approximate with a 1px
/// BoxShadow at spreadRadius 0 / blurRadius 0 that sits flush against the
/// element like a halo. `overlay` uses the "whisper" drop-shadow instead.
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    required this.ambient,
    required this.elevated,
    required this.overlay,
  });

  /// Level 2 — ring halo for interactive surfaces (buttons, cards on hover).
  final List<BoxShadow> ambient;

  /// Level 3 — "whisper" soft drop shadow for elevated feature cards.
  /// `rgba(0,0,0,0.05) 0px 4px 24px` in the source spec.
  final List<BoxShadow> elevated;

  /// Elevated + ring — for modal-style surfaces floating over the page.
  final List<BoxShadow> overlay;

  static const AppShadows light = AppShadows(
    ambient: <BoxShadow>[
      BoxShadow(
        color: AppPalette.ringWarm,
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: 1,
      ),
    ],
    elevated: <BoxShadow>[
      BoxShadow(
        color: Color(0x0D000000), // rgba(0,0,0,0.05)
        offset: Offset(0, 4),
        blurRadius: 24,
      ),
    ],
    overlay: <BoxShadow>[
      BoxShadow(
        color: Color(0x0D000000),
        offset: Offset(0, 4),
        blurRadius: 24,
      ),
      BoxShadow(
        color: AppPalette.ringWarm,
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: 1,
      ),
    ],
  );

  static const AppShadows dark = AppShadows(
    ambient: <BoxShadow>[
      BoxShadow(
        color: AppPalette.borderDark,
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: 1,
      ),
    ],
    elevated: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000), // slightly heavier on dark canvas
        offset: Offset(0, 4),
        blurRadius: 24,
      ),
    ],
    overlay: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 4),
        blurRadius: 24,
      ),
      BoxShadow(
        color: AppPalette.borderDark,
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: 1,
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

/// Book Club light/dark themes wired to Claude's design tokens.
///
/// The light theme uses Parchment as its page canvas and Terracotta as the
/// primary chromatic accent. The dark theme mirrors Claude's dark mode with
/// Near Black surfaces and Warm Silver text.
class AppTheme {
  const AppTheme._();

  /// Matches the light ColorScheme's primary — exposed so tests/clients can
  /// verify the M3 default purple has actually been replaced.
  static const Color lightPrimary = AppPalette.brand;

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

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.brand,
    onPrimary: AppPalette.ivory,
    primaryContainer: AppPalette.coral,
    onPrimaryContainer: AppPalette.ivory,
    secondary: AppPalette.warmSand,
    onSecondary: AppPalette.charcoalWarm,
    secondaryContainer: AppPalette.borderWarm,
    onSecondaryContainer: AppPalette.charcoalWarm,
    tertiary: AppPalette.darkSurface,
    onTertiary: AppPalette.ivory,
    error: AppPalette.errorCrimson,
    onError: AppPalette.ivory,
    surface: AppPalette.parchment,
    onSurface: AppPalette.nearBlack,
    surfaceContainerLowest: AppPalette.pureWhite,
    surfaceContainerLow: AppPalette.ivory,
    surfaceContainer: AppPalette.ivory,
    surfaceContainerHigh: AppPalette.warmSand,
    surfaceContainerHighest: AppPalette.borderWarm,
    onSurfaceVariant: AppPalette.oliveGray,
    outline: AppPalette.borderWarm,
    outlineVariant: AppPalette.borderCream,
    inverseSurface: AppPalette.nearBlack,
    onInverseSurface: AppPalette.ivory,
    inversePrimary: AppPalette.coral,
    shadow: Color(0x0D000000),
    scrim: Color(0x66000000),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.coral,
    onPrimary: AppPalette.nearBlack,
    primaryContainer: AppPalette.brand,
    onPrimaryContainer: AppPalette.ivory,
    secondary: AppPalette.darkSurface,
    onSecondary: AppPalette.warmSilver,
    secondaryContainer: AppPalette.darkWarm,
    onSecondaryContainer: AppPalette.warmSilver,
    tertiary: AppPalette.warmSand,
    onTertiary: AppPalette.charcoalWarm,
    error: AppPalette.errorCrimson,
    onError: AppPalette.ivory,
    surface: AppPalette.deepDark,
    onSurface: AppPalette.warmSilver,
    surfaceContainerLowest: AppPalette.nearBlack,
    surfaceContainerLow: AppPalette.deepDark,
    surfaceContainer: AppPalette.darkSurface,
    surfaceContainerHigh: AppPalette.darkWarm,
    surfaceContainerHighest: AppPalette.charcoalWarm,
    onSurfaceVariant: AppPalette.warmSilver,
    outline: AppPalette.darkSurface,
    outlineVariant: AppPalette.darkWarm,
    inverseSurface: AppPalette.parchment,
    onInverseSurface: AppPalette.nearBlack,
    inversePrimary: AppPalette.brand,
    shadow: Color(0x33000000),
    scrim: Color(0x99000000),
  );

  // -- Typography ------------------------------------------------------------

  /// Builds the app's [TextTheme].
  ///
  /// Font substitution note: Claude's proprietary "Anthropic Serif / Sans /
  /// Mono" families are not publicly licensed. We use the nearest Google Fonts
  /// equivalents that preserve the warm, editorial feel:
  ///   - Fraunces     ↔ Anthropic Serif  (medium weight 500, book-title voice)
  ///   - Inter        ↔ Anthropic Sans   (neutral, high-legibility UI sans)
  ///   - JetBrains Mono ↔ Anthropic Mono (code / metadata)
  ///
  /// All sizes/weights/line-heights mirror DESIGN.md §3 hierarchy table.
  /// Mapping to Material 3 roles (CLAUDE role → M3 role):
  ///   Display / Hero (64/500/1.10)       → displayLarge
  ///   Section Heading (52/500/1.20)      → displayMedium
  ///   Sub-heading Large (36/500/1.30)    → displaySmall
  ///   Sub-heading (32/500/1.10)          → headlineLarge
  ///   Sub-heading Small (25/500/1.20)    → headlineMedium
  ///   Feature Title (20.8/500/1.20)      → headlineSmall
  ///   Body Serif (17/400/1.60)           → titleLarge (serif emphasis)
  ///   Body Large (20/400/1.60, sans)     → bodyLarge
  ///   Body Standard (16/400/1.50, sans)  → bodyMedium
  ///   Body Small (15/400/1.50, sans)     → bodySmall
  ///   Caption (14/400/1.43, sans)        → labelLarge (inline badges/UI labels)
  ///   Label (12/500/1.25, 0.12 tracking) → labelMedium
  ///   Overline (10/400/1.60, 0.5)        → labelSmall
  static TextTheme buildTextTheme(Color onSurface, Color mutedOnSurface) {
    final TextStyle serif = GoogleFonts.fraunces(color: onSurface);
    final TextStyle sans = GoogleFonts.inter(color: onSurface);

    return TextTheme(
      // Display / headline roles use the serif — the signature voice.
      displayLarge: serif.copyWith(
        fontSize: 64,
        fontWeight: FontWeight.w500,
        height: 1.10,
      ),
      displayMedium: serif.copyWith(
        fontSize: 52,
        fontWeight: FontWeight.w500,
        height: 1.20,
      ),
      displaySmall: serif.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        height: 1.30,
      ),
      headlineLarge: serif.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 1.10,
      ),
      headlineMedium: serif.copyWith(
        fontSize: 25,
        fontWeight: FontWeight.w500,
        height: 1.20,
      ),
      headlineSmall: serif.copyWith(
        fontSize: 20.8,
        fontWeight: FontWeight.w500,
        height: 1.20,
      ),

      // titleLarge keeps the serif tone for editorial passages (Body Serif).
      titleLarge: serif.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.60,
      ),
      // titleMedium/Small switch to sans for compact UI headers.
      titleMedium: sans.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      titleSmall: sans.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),

      // Body roles — sans-serif, generous line-height for a literary cadence.
      bodyLarge: sans.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.60,
        color: mutedOnSurface,
      ),
      bodyMedium: sans.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
      bodySmall: sans.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.50,
        color: mutedOnSurface,
      ),

      // Labels — tight sans with the spec's letter-spacing quirks.
      labelLarge: sans.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
      ),
      labelMedium: sans.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.25,
        letterSpacing: 0.12,
      ),
      labelSmall: sans.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.60,
        letterSpacing: 0.5,
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
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isLight ? AppPalette.warmSand : AppPalette.darkSurface,
          foregroundColor:
              isLight ? AppPalette.charcoalWarm : AppPalette.warmSilver,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(
            color: isLight ? AppPalette.borderWarm : AppPalette.borderDark,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        color: isLight ? AppPalette.ivory : AppPalette.darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(
            color: isLight ? AppPalette.borderCream : AppPalette.borderDark,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppPalette.ivory : AppPalette.darkSurface,
        // DESIGN.md §4 Inputs — vertical padding ≈ 1.6px is too tight for
        // touch targets on mobile; adapt upward to the mobile-minimum 12px.
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: isLight ? AppPalette.borderWarm : AppPalette.borderDark,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: isLight ? AppPalette.borderWarm : AppPalette.borderDark,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppPalette.focusBlue, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppPalette.stoneGray,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isLight ? AppPalette.borderCream : AppPalette.borderDark,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(
        color: isLight ? AppPalette.charcoalWarm : AppPalette.warmSilver,
      ),
    );
  }
}
