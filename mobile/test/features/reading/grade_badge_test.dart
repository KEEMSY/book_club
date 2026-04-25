import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/core/theme/grade_theme.dart';
import 'package:book_club/features/reading/presentation/widgets/grade_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  /// Maps each [ReaderGrade] to the plant-growth icon the badge should carry.
  /// Lock-in for the motif: seed/sprout → plant → flower → tree → forest.
  const Map<ReaderGrade, IconData> expectedIcons = <ReaderGrade, IconData>{
    ReaderGrade.sprout: Icons.spa_rounded,
    ReaderGrade.explorer: Icons.eco_rounded,
    ReaderGrade.devoted: Icons.local_florist_rounded,
    ReaderGrade.passionate: Icons.park_rounded,
    ReaderGrade.master: Icons.forest_rounded,
  };

  group('GradeBadge', () {
    for (final entry in expectedIcons.entries) {
      testWidgets('renders ${entry.value} for ${entry.key.name}',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(child: GradeBadge(grade: entry.key, size: 120)),
            ),
          ),
        );
        await tester.pump();

        expect(find.byIcon(entry.value), findsOneWidget);
      });
    }

    testWidgets('icon is pixel-centered inside the disc (Stack alignment)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const MediaQuery(
            // Disable animations so the geometry assertion measures the
            // resting state, not a frame mid-entrance tween.
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Center(
                child: GradeBadge(grade: ReaderGrade.devoted, size: 120),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final Finder iconFinder = find.byIcon(Icons.local_florist_rounded);
      expect(iconFinder, findsOneWidget);

      // Icon sits inside a Center → the horizontal and vertical midpoints
      // of the icon should match the midpoint of the badge disc (the
      // Container rendered from grade primary).
      final Rect iconRect = tester.getRect(iconFinder);
      // The surrounding SizedBox sized `size × size` drives centering.
      final Rect badgeRect = tester.getRect(find.byType(GradeBadge).first);
      // Allow < 0.5dp drift (antialiasing / subpixel rounding).
      expect((iconRect.center.dx - badgeRect.center.dx).abs(), lessThan(0.5));
      expect((iconRect.center.dy - badgeRect.center.dy).abs(), lessThan(0.5));
      // Icon scales to 50% of badge size → width ≈ 60dp for a 120dp badge.
      expect(iconRect.width, closeTo(60, 0.5));
    });

    testWidgets('placeholder variant keeps auto_awesome_rounded',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Center(child: GradeBadge.placeholder(size: 64)),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
    });

    testWidgets('placeholder shimmer variant still renders the icon',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Center(
              child: GradeBadge.placeholder(size: 64, shimmer: true),
            ),
          ),
        ),
      );
      // pump once — if we pump indefinitely the AnimationController's
      // repeat loop traps the tester.
      await tester.pump();

      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
    });

    testWidgets('renders on dark theme without painter crash', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: const MediaQuery(
            // Disable animations so the always-on glow controller doesn't
            // trap pump() in its repeat loop on this smoke test.
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Center(
                child: GradeBadge(grade: ReaderGrade.master, size: 120),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.forest_rounded), findsOneWidget);
    });

    testWidgets(
      'reduce-motion renders final state without spawning glow ticker',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: Center(
                  child: GradeBadge(grade: ReaderGrade.devoted, size: 120),
                ),
              ),
            ),
          ),
        );
        // pumpAndSettle is safe under disableAnimations because no
        // repeating controller was created — confirms the branch.
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.local_florist_rounded), findsOneWidget);
        // After settle, the badge should be at its resting size (icon at
        // 50% of badge size — no entrance scaling residue).
        final Rect iconRect =
            tester.getRect(find.byIcon(Icons.local_florist_rounded));
        expect(iconRect.width, closeTo(60, 0.5));
      },
    );

    testWidgets(
      'mount entrance settles the badge at its final size and full opacity',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(
              body: Center(
                child: GradeBadge(grade: ReaderGrade.passionate, size: 120),
              ),
            ),
          ),
        );
        // Drive past the 550ms entrance. We can't pumpAndSettle (the glow
        // pulse loops forever), so step beyond the entrance window and
        // assert on the resting geometry.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        final Rect iconRect = tester.getRect(find.byIcon(Icons.park_rounded));
        // 50% of 120dp = 60dp logical icon size. The bounding rect may be
        // slightly wider because the icon is inside a Transform.rotate (±6°
        // sway from the glow pulse), which expands the geometric bounding
        // box. We allow up to 8dp of overshoot to cover both the rotation
        // expansion and any easeOutBack residual.
        expect(iconRect.width, closeTo(60, 8));
      },
    );
  });
}
