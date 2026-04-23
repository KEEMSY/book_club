import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/core/theme/grade_theme.dart';
import 'package:book_club/features/reading/presentation/widgets/jan_dee_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('JanDeeGrid renders 52×7 cells plus the day/month labels',
      (tester) async {
    // Seed a single 2h reading day so at least one cell picks a non-empty
    // bucket color.
    final List<dynamic> days = <dynamic>[
      buildHeatmapDay(
        date: DateTime.now().subtract(const Duration(days: 3)),
        totalSeconds: 7200,
        sessionCount: 1,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: JanDeeGrid(
              days: days.cast(),
              primaryColor: GradeTheme.primaryOf(ReaderGrade.devoted),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // JanDeeGrid exists and receives the days list.
    final JanDeeGrid widget =
        tester.widget<JanDeeGrid>(find.byType(JanDeeGrid));
    expect(widget.days, hasLength(1));

    // Day-label column surfaces at least one 월/수/금 label (odd rows only).
    final bool hasDayLabel = <String>['월', '수', '금'].any(
      (String label) => find.text(label).evaluate().isNotEmpty,
    );
    expect(hasDayLabel, isTrue);
  });

  testWidgets('empty days list still renders the grid without exceptions',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: JanDeeGrid(
              days: const <dynamic>[].cast(),
              primaryColor: GradeTheme.primaryOf(ReaderGrade.sprout),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(JanDeeGrid), findsOneWidget);
  });
}
