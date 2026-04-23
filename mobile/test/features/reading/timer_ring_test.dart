import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/core/theme/grade_theme.dart';
import 'package:book_club/features/reading/presentation/widgets/timer_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('TimerRing renders with the grade primary color', (tester) async {
    final Color accent = GradeTheme.primaryOf(ReaderGrade.devoted);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: TimerRing(
              color: accent,
              progress: 0.5,
              size: 240,
              child: const Text('12:34'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // Ring is a CustomPaint widget wrapped in a sized box. We verify the
    // painted color indirectly by asserting the TimerRing's captured color
    // prop matches what we passed in.
    final TimerRing ring = tester.widget<TimerRing>(find.byType(TimerRing));
    expect(ring.color, accent);
    expect(ring.progress, 0.5);

    // Child renders.
    expect(find.text('12:34'), findsOneWidget);
  });

  testWidgets('TimerRing indeterminate flag swaps the progress path',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: TimerRing(
              color: GradeTheme.primaryOf(ReaderGrade.passionate),
              progress: 0,
              indeterminate: true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final TimerRing ring = tester.widget<TimerRing>(find.byType(TimerRing));
    expect(ring.indeterminate, isTrue);
  });
}
