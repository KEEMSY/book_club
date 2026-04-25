import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/reading/domain/grade_summary.dart';
import 'package:book_club/features/reading/presentation/widgets/grade_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  GradeSummary buildSummary({
    int totalBooks = 5,
    int totalSeconds = 18000,
    int targetBooks = 10,
    int targetSeconds = 36000,
  }) {
    return GradeSummary(
      grade: 2,
      totalBooks: totalBooks,
      totalSeconds: totalSeconds,
      streakDays: 3,
      longestStreak: 7,
      nextGradeThresholds: NextGradeThresholds(
        targetBooks: targetBooks,
        targetSeconds: targetSeconds,
      ),
    );
  }

  Widget pumpHost(Widget child, {bool reduceMotion = false}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: Scaffold(body: child),
      ),
    );
  }

  group('GradeProgress', () {
    testWidgets('bars settle at the target ratio after the entrance tween',
        (tester) async {
      // 5/10 = 0.5 books, 18000/36000 = 0.5 hours.
      await tester.pumpWidget(
        pumpHost(
          GradeProgress(summary: buildSummary(), accent: Colors.red),
        ),
      );
      // Drive past the 800ms tween. Stop short of pumpAndSettle in case
      // a parent ever introduces an idle loop; explicit pump is robust.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));

      final List<LinearProgressIndicator> bars = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .toList();
      expect(bars.length, 2);
      expect(bars[0].value, closeTo(0.5, 0.001));
      expect(bars[1].value, closeTo(0.5, 0.001));
    });

    testWidgets('mid-tween value is below the final ratio (animation runs)',
        (tester) async {
      await tester.pumpWidget(
        pumpHost(
          GradeProgress(summary: buildSummary(), accent: Colors.red),
        ),
      );
      // After ~50ms of the 800ms easeOutCubic tween, the value should be
      // strictly between 0 and the target — proving the bar is not
      // jumping straight to its end value.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final LinearProgressIndicator firstBar = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .first;
      final double v = firstBar.value!;
      expect(v, greaterThan(0.0));
      expect(v, lessThan(0.5));
    });

    testWidgets('reduce-motion paints final ratio on the first frame',
        (tester) async {
      await tester.pumpWidget(
        pumpHost(
          GradeProgress(summary: buildSummary(), accent: Colors.red),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      final List<LinearProgressIndicator> bars = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .toList();
      expect(bars[0].value, closeTo(0.5, 0.001));
      expect(bars[1].value, closeTo(0.5, 0.001));
    });
  });
}
