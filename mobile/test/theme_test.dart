import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/core/theme/grade_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // `AppTheme.buildTextTheme` routes through google_fonts, which normally
  // downloads font files at first use. Tests run offline, so we disable
  // runtime fetching and drive every theme-touching assertion through a
  // widget tester — that way the rejected font-load future settles inside
  // the test's async zone instead of leaking past the test boundary.
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  /// Pumps an empty scaffold under the supplied theme to fully flush
  /// google_fonts' asynchronous font-load errors inside the test zone.
  Future<void> settleTheme(WidgetTester tester, ThemeData theme) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AppTheme', () {
    testWidgets(
      'light primary matches Airbnb Rausch Red (AppPalette.rausch)',
      (tester) async {
        final ThemeData theme = AppTheme.light;
        await settleTheme(tester, theme);
        // Airbnb DESIGN.md §2 Primary Brand — Rausch Red (#FF385C) is the
        // singular chromatic accent; brand alias points at the same swatch.
        expect(theme.colorScheme.primary, AppPalette.rausch);
        expect(theme.colorScheme.primary, AppPalette.brand);
        expect(theme.colorScheme.primary, AppTheme.lightPrimary);
      },
    );

    testWidgets(
      'exposes an AppSpacing extension with all five size fields',
      (tester) async {
        final ThemeData theme = AppTheme.light;
        await settleTheme(tester, theme);
        final AppSpacing? spacing = theme.extension<AppSpacing>();

        expect(spacing, isNotNull);
        expect(spacing!.xs, greaterThan(0));
        expect(spacing.sm, greaterThan(spacing.xs));
        expect(spacing.md, greaterThan(spacing.sm));
        expect(spacing.lg, greaterThan(spacing.md));
        expect(spacing.xl, greaterThan(spacing.lg));
      },
    );

    testWidgets('exposes AppRadius and AppShadows extensions', (tester) async {
      final ThemeData light = AppTheme.light;
      final ThemeData dark = AppTheme.dark;
      await settleTheme(tester, light);
      expect(light.extension<AppRadius>(), isNotNull);
      expect(light.extension<AppShadows>(), isNotNull);
      expect(dark.extension<AppShadows>(), isNotNull);
    });

    testWidgets(
        'scaffold background on light theme matches AppPalette.parchment '
        '(Airbnb Foggy warm off-white)', (tester) async {
      final ThemeData theme = AppTheme.light;
      await settleTheme(tester, theme);
      expect(theme.scaffoldBackgroundColor, AppPalette.parchment);
      expect(theme.scaffoldBackgroundColor, AppPalette.foggy);
    });
  });

  group('GradeTheme', () {
    test('schemes map covers every ReaderGrade exactly once', () {
      expect(GradeTheme.schemes.length, 5);
      for (final ReaderGrade grade in ReaderGrade.values) {
        expect(GradeTheme.schemes.containsKey(grade), isTrue);
        expect(GradeTheme.schemes[grade], isNotNull);
      }
    });

    test('darkSchemes map covers every ReaderGrade exactly once', () {
      expect(GradeTheme.darkSchemes.length, 5);
      for (final ReaderGrade grade in ReaderGrade.values) {
        expect(GradeTheme.darkSchemes.containsKey(grade), isTrue);
        expect(GradeTheme.darkSchemes[grade], isNotNull);
      }
    });

    testWidgets('apply swaps color scheme off the base AppTheme brand',
        (tester) async {
      final ThemeData base = AppTheme.light;
      final ThemeData themed = GradeTheme.apply(base, ReaderGrade.devoted);
      await settleTheme(tester, themed);

      // The "애독자" (devoted) grade seeds on Rausch itself — the same hue
      // as the base primary — so `.primary` can legitimately tonal-match
      // the base after `ColorScheme.fromSeed` runs. We therefore assert
      // that `primaryContainer` — a tonally-derived slot from the seed —
      // differs from the hand-crafted base container (Deep Rausch).
      expect(
        themed.colorScheme.primaryContainer,
        isNot(base.colorScheme.primaryContainer),
      );
      // Text theme + extensions must survive the merge.
      expect(themed.textTheme.headlineMedium, base.textTheme.headlineMedium);
      expect(themed.extension<AppSpacing>(), isNotNull);
    });

    testWidgets('apply on non-brand grade shifts primary too', (tester) async {
      final ThemeData base = AppTheme.light;
      final ThemeData themed = GradeTheme.apply(base, ReaderGrade.master);
      await settleTheme(tester, themed);

      // 서재 마스터 seeds on Babu (deep teal) — a different hue family
      // from Rausch, so primary must visibly move off the base brand.
      expect(themed.colorScheme.primary, isNot(base.colorScheme.primary));
      expect(themed.isBaseBrand, isFalse);
    });

    test('each grade produces a distinct primary color', () {
      final Set<Color> primaries = <Color>{
        for (final ReaderGrade g in ReaderGrade.values)
          GradeTheme.schemes[g]!.primary,
      };
      expect(primaries.length, ReaderGrade.values.length);
    });
  });
}
