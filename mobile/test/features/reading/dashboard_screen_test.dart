import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/domain/auth_user.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/notification/data/notification_models.dart';
import 'package:book_club/features/notification/data/notification_repository.dart';
import 'package:book_club/features/reading/application/grade_notifier.dart';
import 'package:book_club/features/reading/application/grade_state.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:book_club/features/reading/data/reading_repository.dart';
import 'package:book_club/features/reading/presentation/dashboard_screen.dart';
import 'package:book_club/features/reading/presentation/widgets/grade_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' as auth_fakes;
import '../book/fakes.dart' show FakeBookRepository;
import 'fakes.dart';

/// No-op [NotificationRepository] stub — prevents DashboardScreen's
/// [NotificationBell] from spawning live HTTP requests inside widget tests.
class _FakeNotificationRepository implements NotificationRepository {
  const _FakeNotificationRepository();

  @override
  Future<NotificationListResponse> getNotifications({
    String? cursor,
    int limit = 20,
  }) async => const NotificationListResponse(items: [], unreadCount: 0);

  @override
  Future<void> markRead(String id) async {}

  @override
  Future<int> getUnreadCount() async => 0;

  @override
  Future<WeeklyReportResponse?> getWeeklyReport(String weekDate) async => null;
}

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
          notificationRepositoryProvider
              .overrideWithValue(const _FakeNotificationRepository()),
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

  // -- Placeholder coverage for non-Loaded grade states --------------------
  //
  // The grade card used to collapse into a blank 64dp SizedBox whenever the
  // state wasn't Loaded. These tests lock in the new behaviour: each of
  // Initial / Loading / Error renders a visible `GradeBadge.placeholder`
  // together with a user-friendly subtitle.

  testWidgets('_GradeRow renders placeholder + Initial copy', (tester) async {
    await _pumpDashboard(
      tester,
      gradeState: const GradeState.initial(),
    );
    await tester.pump();

    expect(find.byType(GradeBadge), findsOneWidget);
    expect(find.text('등급을 불러오고 있어요'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });

  testWidgets('_GradeRow renders placeholder + Loading copy', (tester) async {
    await _pumpDashboard(
      tester,
      gradeState: const GradeState.loading(),
    );
    await tester.pump();

    expect(find.byType(GradeBadge), findsOneWidget);
    expect(find.text('등급을 불러오고 있어요'), findsOneWidget);
  });

  testWidgets('_GradeRow renders placeholder + retry affordance on failure',
      (tester) async {
    await _pumpDashboard(
      tester,
      gradeState:
          const GradeState.error(code: 'INTERNAL_ERROR', message: 'boom'),
    );
    await tester.pump();

    expect(find.byType(GradeBadge), findsOneWidget);
    expect(
      find.textContaining('등급을 불러오지 못했어요'),
      findsOneWidget,
    );
    // Failure state swaps the chevron for a refresh affordance.
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
  });
}

Future<void> _pumpDashboard(
  WidgetTester tester, {
  required GradeState gradeState,
}) async {
  final readingRepo = FakeReadingRepository()
    ..goalsResult = <dynamic>[].cast()
    ..heatmapQueue = <dynamic>[].cast()
    ..gradeResult = buildGradeSummary();

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        readingRepositoryProvider
            .overrideWithValue(readingRepo as ReadingRepository),
        bookRepositoryProvider.overrideWithValue(FakeBookRepository()),
        authRepositoryProvider.overrideWithValue(auth_fakes.buildRepository()),
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
        gradeNotifierProvider.overrideWith(
          (ref) => _StubGradeNotifier(
            ref.watch(readingRepositoryProvider),
            gradeState,
          ),
        ),
        notificationRepositoryProvider
            .overrideWithValue(const _FakeNotificationRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const DashboardScreen(),
      ),
    ),
  );
}

/// Test-only GradeNotifier that pins the state and no-ops on load/refresh so
/// the post-frame `load()` call in `DashboardScreen.initState` cannot flip
/// the state back to Loading → Loaded.
class _StubGradeNotifier extends GradeNotifier {
  _StubGradeNotifier(super.repository, GradeState initial) {
    state = initial;
  }

  @override
  Future<void> load({bool force = false}) async {
    // no-op — the test pins state via the constructor.
  }

  @override
  Future<void> refresh() async {
    // no-op
  }
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
