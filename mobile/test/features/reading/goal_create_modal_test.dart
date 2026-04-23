import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:book_club/features/reading/domain/goal_period.dart';
import 'package:book_club/features/reading/presentation/goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

/// Widget-level coverage for the goal creation modal. We mount the full
/// `GoalScreen`, tap into the correct period tab, open the create sheet,
/// interact with preset chips / mode toggle, then press "저장" and assert
/// the repository received the expected `target_seconds` payload — locking
/// in the hours-per-period math documented in the task brief.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Weekly — 하루 1시간 chip → target_seconds = 25200', (tester) async {
    final repo = _buildRepo();

    await _pumpGoalScreen(tester, repo);
    // Weekly tab is the initial tab — "목표 만들기" opens the sheet.
    await _tapCreateButton(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, '하루 1시간'));
    await tester.pump();
    await _tapSave(tester);

    expect(repo.createGoalCalls, hasLength(1));
    final call = repo.createGoalCalls.single;
    expect(call.period, GoalPeriod.weekly);
    // 60 minutes × 7 days × 60 sec
    expect(call.targetSeconds, 60 * 7 * 60);
    expect(call.targetSeconds, 25200);
  });

  testWidgets('Monthly — 일수 기준 · 15일 × 하루 30분 → target_seconds = 27000',
      (tester) async {
    final repo = _buildRepo();

    await _pumpGoalScreen(tester, repo);
    await tester.tap(find.text('월간'));
    await tester.pumpAndSettle();
    await _tapCreateButton(tester);

    // Toggle to "일수 기준". SegmentedButton surfaces both labels as text.
    await tester.tap(find.text('일수 기준'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ChoiceChip, '15일'));
    await tester.pump();
    // Slider defaults to 30 minutes, so no extra interaction required.
    await _tapSave(tester);

    expect(repo.createGoalCalls, hasLength(1));
    final call = repo.createGoalCalls.single;
    expect(call.period, GoalPeriod.monthly);
    // 15 days × 30 minutes × 60 sec
    expect(call.targetSeconds, 15 * 30 * 60);
    expect(call.targetSeconds, 27000);
  });

  testWidgets(
      'Yearly — 하루 30분 chip (default mode) → target_seconds = 30 × 60 × 365',
      (tester) async {
    final repo = _buildRepo();

    await _pumpGoalScreen(tester, repo);
    await tester.tap(find.text('연간'));
    await tester.pumpAndSettle();
    await _tapCreateButton(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, '하루 30분'));
    await tester.pump();
    await _tapSave(tester);

    expect(repo.createGoalCalls, hasLength(1));
    final call = repo.createGoalCalls.single;
    expect(call.period, GoalPeriod.yearly);
    expect(call.targetSeconds, 30 * 60 * 365);
    expect(call.targetSeconds, 657000);
  });

  testWidgets('Toggling modes preserves target_books', (tester) async {
    final repo = _buildRepo();

    await _pumpGoalScreen(tester, repo);
    await tester.tap(find.text('월간'));
    await tester.pumpAndSettle();
    await _tapCreateButton(tester);

    // Default targetBooks for monthly = 4. Step it up twice to 6.
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(find.text('6 권'), findsOneWidget);

    // Toggle mode to byDays — targetBooks should stay at 6.
    await tester.tap(find.text('일수 기준'));
    await tester.pump();
    expect(find.text('6 권'), findsOneWidget);

    // And back to daily.
    await tester.tap(find.text('하루 기준'));
    await tester.pump();
    expect(find.text('6 권'), findsOneWidget);

    // Save with a preset to confirm targetBooks survives to the repository.
    await tester.tap(find.widgetWithText(ChoiceChip, '하루 1시간'));
    await tester.pump();
    await _tapSave(tester);

    expect(repo.createGoalCalls.single.targetBooks, 6);
  });
}

// -- helpers --------------------------------------------------------------

FakeReadingRepository _buildRepo() {
  return FakeReadingRepository()
    ..goalsResult = <dynamic>[].cast()
    ..createGoalResult = buildGoal();
}

Future<void> _pumpGoalScreen(
  WidgetTester tester,
  FakeReadingRepository repo,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        readingRepositoryProvider.overrideWithValue(repo as ReadingRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const GoalScreen(),
      ),
    ),
  );
  // Let the post-frame `load()` land.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 20));
}

Future<void> _tapCreateButton(WidgetTester tester) async {
  await tester.tap(find.text('목표 만들기'));
  await tester.pumpAndSettle();
}

Future<void> _tapSave(WidgetTester tester) async {
  await tester.tap(find.text('저장'));
  // Let the notifier's createGoal() land and the sheet dismiss.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
