import 'dart:convert';

import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/reading/application/reading_journey_inputs.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:book_club/features/reading/domain/goal_period.dart';
import 'package:book_club/features/reading/presentation/widgets/goal_journey_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' show InMemorySecureStorage;
import 'fakes.dart';

/// Unit-level coverage for the unified "독서 여정" setup modal. Defaults
/// (24권 · 30분 · 7일) drive every assertion so a regression in the derive
/// formula gets caught at the chip level — the same defaults flow into the
/// notifier's createGoal payload via createJourney.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
      'live summary panel surfaces yearly · monthly · weekly derivations'
      ' (defaults: 24권 · 30분 · 주 7일)', (tester) async {
    final repo = FakeReadingRepository()..createGoalResult = buildGoal();
    await _pumpModal(tester, repo);

    // Defaults: yearlyBooks=24, dailyMinutes=30, weeklyDays=7.
    //   weekly  = ceil(24/52)=1 권 · 30·60·7        = 12600s = 3h30m → '3시간 30분'
    //   monthly = ceil(24/12)=2 권 · round(12600·52/12)=54600s = 15h
    //   yearly  = 24 권 · 12600·52 = 655200s = 182h
    expect(find.textContaining('24권'), findsOneWidget);
    expect(find.textContaining('연 182시간'), findsOneWidget);
    expect(find.textContaining('2권'), findsOneWidget); // monthly
    expect(find.textContaining('15시간'), findsOneWidget);
    expect(find.textContaining('1권'), findsOneWidget); // weekly
    expect(find.textContaining('3시간 30분'), findsOneWidget);
  });

  testWidgets('saving the modal posts three goals + persists the preset',
      (tester) async {
    final storage = InMemorySecureStorage();
    final repo = FakeReadingRepository()..createGoalResult = buildGoal();
    await _pumpModal(tester, repo, storage: storage);

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

    // Yearly call carries the inputs verbatim.
    final yearly =
        repo.createGoalCalls.firstWhere((c) => c.period == GoalPeriod.yearly);
    expect(yearly.targetBooks, 24);
    expect(yearly.targetSeconds, 30 * 60 * 7 * 52);

    // Preset is persisted under the agreed key so the next open prefills.
    final raw = await storage.readRaw('goal.journey.preset');
    expect(raw, isNotNull);
    final parsed = jsonDecode(raw!) as Map<String, dynamic>;
    expect(parsed['yearlyBooks'], 24);
    expect(parsed['dailyMinutes'], 30);
    expect(parsed['weeklyDays'], 7);
  });

  testWidgets('hydrates inputs from a previously saved preset', (tester) async {
    final storage = InMemorySecureStorage();
    await storage.writeRaw(
      'goal.journey.preset',
      jsonEncode(<String, dynamic>{
        'yearlyBooks': 60,
        'dailyMinutes': 60,
        'weeklyDays': 5,
      }),
    );

    final repo = FakeReadingRepository()..createGoalResult = buildGoal();
    await _pumpModal(tester, repo, storage: storage);

    expect(find.text('60 권'), findsOneWidget);
    // 60 minutes formats as "1시간".
    expect(find.text('1시간'), findsWidgets);
    // 주 5일 chip is selected; we can at least verify the chip label exists.
    expect(find.text('주 5일'), findsOneWidget);
  });

  test('ReadingJourneyTargets.derive math matches the brief', () {
    final t = ReadingJourneyTargets.derive(
      yearlyBooks: 52,
      dailyMinutes: 30,
      weeklyDays: 7,
    );
    expect(t.weeklyBooks, 1);
    expect(t.weeklySeconds, 12600);
    expect(t.monthlyBooks, 5);
    expect(t.monthlySeconds, 54600);
    expect(t.yearlyBooks, 52);
    expect(t.yearlySeconds, 655200);
  });
}

// -- helpers --------------------------------------------------------------

Future<void> _pumpModal(
  WidgetTester tester,
  FakeReadingRepository repo, {
  SecureStorage? storage,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        readingRepositoryProvider.overrideWithValue(repo as ReadingRepository),
        secureStorageProvider
            .overrideWithValue(storage ?? InMemorySecureStorage()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => GoalJourneyModal.show(context),
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  // Pump enough for the bottom-sheet animation + async _hydrate() to land.
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pumpAndSettle();
}
