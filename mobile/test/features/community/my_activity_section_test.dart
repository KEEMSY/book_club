import 'package:book_club/core/router/app_router.dart';
import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/community/application/community_providers.dart';
import 'package:book_club/features/community/domain/my_activity.dart';
import 'package:book_club/features/community/presentation/widgets/my_activity_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// BC-83 — "내 활동" profile section: summary render, 더보기 entry points, and
/// per-item deep links. Each destination is a placeholder screen registered
/// on a real [GoRouter] (mirrors the pattern in
/// `test/features/reading/dashboard_active_session_test.dart`) so navigation
/// assertions exercise the actual `AppRoutes` paths rather than mocking
/// `context.push` itself.
DateTime _t(int day) => DateTime.utc(2026, 8, day);

MyActivitySummary _fixture() => MyActivitySummary(
      counts: const ActivityCounts(
        reviews: 3,
        highlights: 5,
        agendas: 2,
        clubs: 1,
        readingBooks: 4,
      ),
      reviews: [
        ActivityReviewItem(
          id: 'r1',
          bookId: 'book-1',
          bookTitle: '리뷰책',
          rating: 4,
          body: '좋았어요',
          createdAt: _t(1),
        ),
      ],
      highlights: [
        ActivityHighlightItem(
          id: 'h1',
          bookId: 'book-2',
          bookTitle: '하이라이트책',
          quoteText: '인상 깊은 문장',
          createdAt: _t(2),
        ),
      ],
      agendas: [
        ActivityAgendaItem(
          id: 'a1',
          clubId: 'club-1',
          clubName: '독서모임',
          sessionId: 'session-1',
          sessionTitle: '1회차',
          status: 'published',
          createdAt: _t(3),
        ),
      ],
      clubs: [
        ActivityClubItem(id: 'club-2', name: '다른모임', createdAt: _t(4)),
      ],
      readingBooks: [
        ActivityBookItem(
          userBookId: 'ub1',
          bookId: 'book-3',
          title: '읽는중책',
          currentChapter: 2,
          startedAt: _t(5),
        ),
      ],
    );

Future<void> _pump(
  WidgetTester tester, {
  required Future<MyActivitySummary> Function() load,
}) async {
  // Five preview rows don't fit the default 800×600 test surface; grow it so
  // every "더보기" button and card is on-screen and tappable without an
  // explicit scroll-into-view step.
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/profile',
    routes: <RouteBase>[
      GoRoute(
        path: '/profile',
        // Wrapped in a scroll view: in the real profile screen this section
        // is one sliver among several inside a CustomScrollView, so it never
        // needs to fit unbounded height on its own.
        builder: (_, __) => const Scaffold(
          body: SingleChildScrollView(child: MyActivitySection()),
        ),
      ),
      GoRoute(
        path: AppRoutes.myActivityReviews,
        builder: (_, __) => const Scaffold(body: Text('REVIEWS_SCREEN')),
      ),
      GoRoute(
        path: AppRoutes.myActivityHighlights,
        builder: (_, __) => const Scaffold(body: Text('HIGHLIGHTS_SCREEN')),
      ),
      GoRoute(
        path: AppRoutes.myActivityAgendas,
        builder: (_, __) => const Scaffold(body: Text('AGENDAS_SCREEN')),
      ),
      GoRoute(
        path: AppRoutes.myActivityClubs,
        builder: (_, __) => const Scaffold(body: Text('CLUBS_SCREEN')),
      ),
      GoRoute(
        path: '/library',
        builder: (_, __) => const Scaffold(body: Text('LIBRARY_SCREEN')),
      ),
      GoRoute(
        path: '/books/:id',
        builder: (context, state) => Scaffold(
          body: Text('BOOK_DETAIL_${state.pathParameters['id']}'),
        ),
      ),
      GoRoute(
        path: '/clubs/:clubId',
        builder: (context, state) => Scaffold(
          body: Text('CLUB_DETAIL_${state.pathParameters['clubId']}'),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'sessions/:sessionId',
            builder: (context, state) => Scaffold(
              body: Text(
                'SESSION_DETAIL_${state.pathParameters['sessionId']}',
              ),
            ),
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        myActivityProvider.overrideWith((ref) => load()),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );

  await tester.pump();
  await tester.pump();
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('요약 렌더: 카테고리별 라벨·카운트를 표시한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    expect(find.text('내 활동'), findsOneWidget);
    expect(find.text('리뷰 3'), findsOneWidget);
    expect(find.text('하이라이트 5'), findsOneWidget);
    expect(find.text('발제문 2'), findsOneWidget);
    expect(find.text('참여 모임 1'), findsOneWidget);
    expect(find.text('읽는 중 4'), findsOneWidget);

    // Preview cards render the denormalized book/club titles from the
    // summary payload without an extra fetch.
    expect(find.text('리뷰책'), findsOneWidget);
    expect(find.text('인상 깊은 문장'), findsOneWidget);
    expect(find.text('독서모임'), findsOneWidget);
    expect(find.text('1회차'), findsOneWidget);
    expect(find.text('다른모임'), findsOneWidget);
    expect(find.text('읽는중책'), findsOneWidget);
  });

  testWidgets('에러 시 조용히 숨긴다 (프로필 나머지 렌더를 막지 않음)', (tester) async {
    await _pump(
      tester,
      load: () async => throw Exception('boom'),
    );

    expect(find.text('내 활동'), findsNothing);
    expect(find.byType(MyActivitySection), findsOneWidget);
  });

  testWidgets('리뷰 더보기 → GET /me/reviews 화면으로 이동한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('더보기').first);
    await tester.pumpAndSettle();

    expect(find.text('REVIEWS_SCREEN'), findsOneWidget);
  });

  testWidgets('발제문 더보기 → GET /clubs/me/agendas 화면으로 이동한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    // Row order: 리뷰, 하이라이트, 발제문, 참여 모임, 읽는 중.
    await tester.tap(find.text('더보기').at(2));
    await tester.pumpAndSettle();

    expect(find.text('AGENDAS_SCREEN'), findsOneWidget);
  });

  testWidgets('참여 모임 더보기 → GET /clubs/me 화면으로 이동한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('더보기').at(3));
    await tester.pumpAndSettle();

    expect(find.text('CLUBS_SCREEN'), findsOneWidget);
  });

  testWidgets('읽는 중 더보기 → 서재 화면(읽는 중 탭)으로 이동한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('더보기').at(4));
    await tester.pumpAndSettle();

    expect(find.text('LIBRARY_SCREEN'), findsOneWidget);
  });

  testWidgets('리뷰 카드 탭 → 책 상세로 딥링크한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('리뷰책'));
    await tester.pumpAndSettle();

    expect(find.text('BOOK_DETAIL_book-1'), findsOneWidget);
  });

  testWidgets('하이라이트 카드 탭 → 책 상세로 딥링크한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('인상 깊은 문장'));
    await tester.pumpAndSettle();

    expect(find.text('BOOK_DETAIL_book-2'), findsOneWidget);
  });

  testWidgets('발제문 카드 탭 → 회차 상세로 딥링크한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('독서모임'));
    await tester.pumpAndSettle();

    expect(find.text('SESSION_DETAIL_session-1'), findsOneWidget);
  });

  testWidgets('참여 모임 카드 탭 → 클럽 상세로 딥링크한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('다른모임'));
    await tester.pumpAndSettle();

    expect(find.text('CLUB_DETAIL_club-2'), findsOneWidget);
  });

  testWidgets('읽는 중 책 카드 탭 → 책 상세로 딥링크한다', (tester) async {
    await _pump(tester, load: () async => _fixture());

    await tester.tap(find.text('읽는중책'));
    await tester.pumpAndSettle();

    expect(find.text('BOOK_DETAIL_book-3'), findsOneWidget);
  });
}
