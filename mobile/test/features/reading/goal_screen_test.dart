import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:book_club/features/reading/domain/goal_period.dart';
import 'package:book_club/features/reading/presentation/goal_screen.dart';
import 'package:book_club/features/reading/presentation/widgets/goal_journey_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' show InMemorySecureStorage;
import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
      'renders 올해의 독서 여정 header followed by yearly · monthly · weekly cards'
      ' without a TabBar', (tester) async {
    final repo = FakeReadingRepository()
      ..goalsResult = <dynamic>[
        buildGoalProgress(
          goal: buildGoal(period: GoalPeriod.weekly),
          booksDone: 1,
          secondsDone: 7200,
          percent: 0.5,
        ),
        buildGoalProgress(
          goal: buildGoal(period: GoalPeriod.monthly, targetBooks: 4),
          booksDone: 2,
          secondsDone: 14400,
          percent: 0.5,
        ),
        buildGoalProgress(
          goal: buildGoal(period: GoalPeriod.yearly, targetBooks: 24),
          booksDone: 4,
          secondsDone: 36000,
          percent: 0.16,
        ),
      ].cast();

    await _pumpScreen(tester, repo);

    expect(find.byType(TabBar), findsNothing);
    expect(find.text('올해의 독서 여정'), findsOneWidget);
    expect(find.text('당신이 향하는 곳, 지금 이 주의 걸음까지'), findsOneWidget);
    expect(find.textContaining('연간 달성'), findsOneWidget);

    // Scroll the long list so monthly + weekly cards both enter the viewport.
    await tester.scrollUntilVisible(
      find.text('목표 재설정'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('이번 달'), findsOneWidget);
    expect(find.textContaining('이번 주'), findsOneWidget);
    expect(find.text('지금 만들기'), findsNothing);
  });

  testWidgets('empty state renders inline 지금 만들기 CTA per missing period',
      (tester) async {
    final repo = FakeReadingRepository()..goalsResult = <dynamic>[].cast();

    await _pumpScreen(tester, repo);

    // Three cards (yearly hero + monthly + weekly) are all empty.
    expect(find.text('지금 만들기'), findsNWidgets(3));
  });

  testWidgets('tapping 목표 재설정 opens the GoalJourneyModal with all 3 inputs',
      (tester) async {
    final repo = _seededRepo();

    await _pumpScreen(tester, repo);

    await _tapResetButton(tester);

    expect(find.byType(GoalJourneyModal), findsOneWidget);
    expect(find.text('올해 읽고 싶은 권수'), findsOneWidget);
    expect(find.text('하루 평균 독서 시간'), findsOneWidget);
    expect(find.text('독서하는 요일'), findsOneWidget);
    expect(find.text('여정 저장하기'), findsOneWidget);
  });

  testWidgets('saving the modal calls createGoal three times via createJourney',
      (tester) async {
    final repo = _seededRepo();

    await _pumpScreen(tester, repo);

    await _tapResetButton(tester);

    // Defaults: yearlyBooks=24, dailyMinutes=30, weeklyDays=7.
    await tester.tap(find.text('여정 저장하기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(repo.createGoalCalls, hasLength(3));
    final periods = repo.createGoalCalls.map((c) => c.period).toSet();
    expect(periods, <GoalPeriod>{
      GoalPeriod.weekly,
      GoalPeriod.monthly,
      GoalPeriod.yearly,
    });
  });
}

// -- helpers --------------------------------------------------------------

FakeReadingRepository _seededRepo() {
  return FakeReadingRepository()
    ..goalsResult = <dynamic>[
      buildGoalProgress(goal: buildGoal(period: GoalPeriod.weekly)),
      buildGoalProgress(goal: buildGoal(period: GoalPeriod.monthly)),
      buildGoalProgress(goal: buildGoal(period: GoalPeriod.yearly)),
    ].cast()
    ..createGoalResult = buildGoal();
}

Future<void> _tapResetButton(WidgetTester tester) async {
  // The action row sits below the fold on small test surfaces — scroll the
  // list to bring "목표 재설정" into view before tapping it.
  final Finder reset = find.text('목표 재설정');
  await tester.scrollUntilVisible(
    reset,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(reset);
  await tester.pumpAndSettle();
}

Future<void> _pumpScreen(
  WidgetTester tester,
  FakeReadingRepository repo,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        readingRepositoryProvider.overrideWithValue(repo as ReadingRepository),
        secureStorageProvider.overrideWithValue(InMemorySecureStorage()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const GoalScreen(),
      ),
    ),
  );
  // Let the post-frame load() land + the TweenAnimationBuilders settle.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}
