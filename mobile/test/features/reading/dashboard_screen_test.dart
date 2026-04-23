import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/domain/auth_user.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:book_club/features/reading/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' as auth_fakes;
import '../book/fakes.dart' show FakeBookRepository;
import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
      'DashboardScreen renders greeting, daily card, streak, grade, heatmap',
      (tester) async {
    final readingRepo = FakeReadingRepository()
      ..gradeResult = buildGradeSummary(
        grade: 2,
        totalBooks: 5,
        totalSeconds: 36000,
        streakDays: 3,
      )
      ..goalsResult = <dynamic>[].cast()
      ..heatmapQueue = <dynamic>[
        buildHeatmapDay(
          date: DateTime.now(),
          totalSeconds: 1800,
          sessionCount: 1,
        ),
      ].cast();

    final bookRepo = FakeBookRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          readingRepositoryProvider
              .overrideWithValue(readingRepo as ReadingRepository),
          bookRepositoryProvider.overrideWithValue(bookRepo),
          // Force the auth state to Authenticated so the greeting can render
          // the user's nickname without actually running the auth bootstrap.
          authRepositoryProvider
              .overrideWithValue(auth_fakes.buildRepository()),
          authNotifierProvider.overrideWith(
            (ref) => _StubAuthNotifier(
              AuthState.authenticated(
                AuthUser(
                  id: 'u1',
                  nickname: '수민',
                  provider: AuthProvider.kakao,
                  createdAt: DateTime(2026, 4, 20),
                ),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const DashboardScreen(),
        ),
      ),
    );

    // Let post-frame callbacks land (grade / heatmap fetch).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump();

    // Greeting nickname and today's total.
    expect(find.textContaining('수민'), findsOneWidget);
    expect(find.text('오늘의 독서'), findsOneWidget);

    // Streak card surfaces "연속 3일 독서 중" when streakDays == 3.
    expect(find.textContaining('연속 3일'), findsOneWidget);

    // Grade row shows the tier label.
    expect(find.text('탐독자'), findsOneWidget);

    // Heatmap card header — uses "독서 캘린더" (renamed from the earlier
    // slangy "독서 잔디") to match the editorial tone for 20-30대 readers.
    expect(find.text('독서 캘린더'), findsOneWidget);

    // Primary CTA — scroll the ListView until it becomes visible.
    await tester.scrollUntilVisible(
      find.text('지금 읽기 시작'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('지금 읽기 시작'), findsOneWidget);
  });
}

/// Test-only AuthNotifier that skips the rehydrate RPC — tests pin the
/// state directly so the DashboardScreen can read nickname without a real
/// login flow.
class _StubAuthNotifier extends AuthNotifier {
  _StubAuthNotifier(AuthState initial) : super(auth_fakes.buildRepository()) {
    state = initial;
  }

  @override
  Future<void> bootstrap() async {
    // no-op
  }
}
