import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/reading/domain/reading_goal.dart';
import 'package:book_club/features/reading/presentation/session_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  SessionCompletion completion({required bool gradeUp}) {
    final DateTime now = DateTime(2026, 4, 25, 21);
    return SessionCompletion(
      sessionId: 'sess-1',
      userBookId: 'ub-1',
      startedAt: now.subtract(const Duration(minutes: 30)),
      endedAt: now,
      durationSec: 1800,
      grade: 3,
      streakDays: 5,
      gradeUp: gradeUp,
    );
  }

  Widget wrap(Widget child, {bool reduceMotion = false}) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: child,
        ),
      ),
    );
  }

  group('SessionSummaryScreen — celebration', () {
    testWidgets(
      'grade_up=true plays celebration and ends with headline + badge visible',
      (tester) async {
        await tester.pumpWidget(
          wrap(SessionSummaryScreen(completion: completion(gradeUp: true))),
        );
        // Drive past the 1200ms celebration window plus a frame, but stop
        // short of pumpAndSettle (the badge's idle glow loops forever).
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1300));

        // Headline ends visible.
        expect(find.text('승급했어요!'), findsOneWidget);
        // The badge label sentence is rendered.
        expect(find.text('애독자(으)로 올라섰어요'), findsOneWidget);

        // Badge should be at scale 1.0 at rest. The internal GradeBadge
        // sizes its icon to 50% of the badge size (56dp → 28dp). The icon
        // is inside a Transform.rotate (±6° sway from the glow pulse), so
        // the measured bounding rect varies with the animation phase.
        final Finder iconFinder = find.byIcon(Icons.local_florist_rounded);
        expect(iconFinder, findsOneWidget);
        final Rect iconRect = tester.getRect(iconFinder);
        expect(iconRect.width, closeTo(28, 4));
      },
    );

    testWidgets(
      'grade_up=false skips celebration entirely',
      (tester) async {
        await tester.pumpWidget(
          wrap(SessionSummaryScreen(completion: completion(gradeUp: false))),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('승급했어요!'), findsNothing);
        expect(find.text('수고하셨어요'), findsOneWidget);
      },
    );

    testWidgets(
      'reduce-motion renders final celebration state without ticking',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            SessionSummaryScreen(completion: completion(gradeUp: true)),
            reduceMotion: true,
          ),
        );
        // No active animation controllers under reduce-motion → settle is
        // safe and confirms the static-state render.
        await tester.pumpAndSettle();

        expect(find.text('승급했어요!'), findsOneWidget);
        // Badge icon at rest.
        final Rect iconRect =
            tester.getRect(find.byIcon(Icons.local_florist_rounded));
        expect(iconRect.width, closeTo(28, 0.5));
      },
    );
  });
}
