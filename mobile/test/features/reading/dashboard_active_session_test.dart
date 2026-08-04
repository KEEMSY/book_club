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
import 'package:book_club/features/reading/application/timer_notifier.dart';
import 'package:book_club/features/reading/application/timer_state.dart';
import 'package:book_club/features/reading/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/fakes.dart' as auth_fakes;
import '../book/fakes.dart' show FakeBookRepository;
import 'fakes.dart';

/// Pins auth to Authenticated, skipping the bootstrap RPC (BC-39 test).
class _StubAuthNotifier extends AuthNotifier {
  _StubAuthNotifier(this._initial);

  final AuthState _initial;

  @override
  AuthState build() {
    Future.microtask(() => state = _initial);
    return _initial;
  }

  @override
  Future<void> bootstrap() async {}
}

/// Pins grade so the dashboard renders deterministically.
class _StubGradeNotifier extends GradeNotifier {
  _StubGradeNotifier(this._initial);

  final GradeState _initial;

  @override
  GradeState build() => _initial;

  @override
  Future<void> load({bool force = false}) async {}

  @override
  Future<void> refresh() async {}
}

/// Pins the timer to a fixed state so the active-session pre-check is
/// deterministic. `restore()` is a no-op so the post-frame call in
/// DashboardScreen cannot flip the pinned state.
class _StubTimerNotifier extends TimerNotifier {
  _StubTimerNotifier(this._initial);

  final TimerState _initial;

  @override
  TimerState build() => _initial;

  @override
  Future<void> restore() async {}
}

class _FakeNotificationRepository implements NotificationRepository {
  const _FakeNotificationRepository();

  @override
  Future<NotificationListResponse> getNotifications({
    String? cursor,
    int limit = 20,
  }) async =>
      const NotificationListResponse(items: [], unreadCount: 0);

  @override
  Future<void> markRead(String id) async {}

  @override
  Future<void> markAllRead() async {}

  @override
  Future<int> getUnreadCount() async => 0;

  @override
  Future<WeeklyReportResponse?> getWeeklyReport(String weekDate) async => null;
}

TimerState _running() => TimerState.running(
      sessionId: 's1',
      userBookId: 'ub1',
      startedAt: DateTime(2026, 8, 4, 10),
      pausedMs: 0,
    );

Future<void> _pump(WidgetTester tester, {required TimerState timer}) async {
  final pinnedUser = AuthUser(
    id: 'u1',
    nickname: '수민',
    provider: AuthProvider.kakao,
    createdAt: DateTime(2026, 4, 20),
  );

  final router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(path: '/home', builder: (_, __) => const DashboardScreen()),
      GoRoute(
        path: '/reading/timer',
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('TIMER_PLACEHOLDER'))),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        readingRepositoryProvider.overrideWithValue(FakeReadingRepository()),
        bookRepositoryProvider.overrideWithValue(FakeBookRepository()),
        authRepositoryProvider.overrideWithValue(auth_fakes.buildRepository()),
        authNotifierProvider.overrideWith(
          () => _StubAuthNotifier(AuthState.authenticated(pinnedUser)),
        ),
        gradeNotifierProvider.overrideWith(
          () => _StubGradeNotifier(
            GradeState.loaded(
              summary: buildGradeSummary(grade: 2, streakDays: 3),
            ),
          ),
        ),
        timerNotifierProvider.overrideWith(() => _StubTimerNotifier(timer)),
        notificationRepositoryProvider.overrideWithValue(
          const _FakeNotificationRepository(),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
      ),
    ),
  );

  await tester.pump();
  await tester.pump(const Duration(milliseconds: 20));
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets(
    '진행 중 세션이 있으면 지금 읽기 시작 탭 시 확인 다이얼로그를 띄운다',
    (tester) async {
      await _pump(tester, timer: _running());

      await tester.tap(find.text('지금 읽기 시작'));
      // Bounded pumps instead of pumpAndSettle — the dashboard has continuous
      // animations (shimmer/ring) that never let the frame scheduler settle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('진행 중인 독서가 있어요'), findsOneWidget);
      expect(find.text('이어서 보기'), findsOneWidget);
      expect(find.text('종료하고 새로 시작'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
    },
  );

  testWidgets('다이얼로그에서 이어서 보기를 누르면 타이머 화면으로 이동한다', (tester) async {
    await _pump(tester, timer: _running());

    await tester.tap(find.text('지금 읽기 시작'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('이어서 보기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('TIMER_PLACEHOLDER'), findsOneWidget);
  });
}
