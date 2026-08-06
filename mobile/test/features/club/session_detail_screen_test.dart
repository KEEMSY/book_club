import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/club/application/session_providers.dart';
import 'package:book_club/features/club/data/club_session_repository.dart';
import 'package:book_club/features/club/domain/club_session.dart';
import 'package:book_club/features/club/presentation/session_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // Matches FakeClubSessionRepository's seeded "open" session, which carries
  // a published agenda with three topics (the first has two replies).
  final openSession = ClubSession(
    id: FakeClubSessionRepository.sessionOpenId,
    clubId: 'club-1',
    bookId: 'book-1',
    bookTitle: '이기적 유전자',
    title: '1회차 · 1~3장',
    scope: '1~3장',
    presenterId: 'user-host',
    presenterName: '유진',
    scheduledAt: DateTime(2026, 8, 10, 20),
    status: ClubSessionStatus.open,
    createdAt: DateTime(2026, 8, 1),
  );

  final draftSession = ClubSession(
    id: FakeClubSessionRepository.sessionDraftId,
    clubId: 'club-1',
    bookId: 'book-1',
    bookTitle: '이기적 유전자',
    title: '2회차 · 4~6장',
    status: ClubSessionStatus.draft,
    createdAt: DateTime(2026, 8, 3),
  );

  Widget buildApp(ClubSession session) {
    return ProviderScope(
      overrides: <Override>[
        clubSessionRepositoryProvider
            .overrideWithValue(FakeClubSessionRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: SessionDetailScreen(session: session),
      ),
    );
  }

  testWidgets('renders the agenda body and one collapsed tile per topic',
      (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    expect(find.textContaining('이기적 유전자 1~3장을 중심으로'), findsOneWidget);
    expect(
      find.text('1. 저자가 말하는 "이기적 유전자"는 개체의 이기심과 어떻게 다른가요?'),
      findsOneWidget,
    );
    expect(find.text('답글 2개'), findsOneWidget);
    expect(find.text('답글 0개'), findsOneWidget);

    // Collapsed — the reply preview body is not in the tree yet.
    expect(
      find.text('맞아요, 그래서 개체의 이타적 행동도 유전자 전달에 유리하면 설명 가능하죠.'),
      findsNothing,
    );
  });

  testWidgets('expanding a topic accordion tile reveals the reply preview',
      (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('1. 저자가 말하는 "이기적 유전자"는 개체의 이기심과 어떻게 다른가요?'),
    );
    await tester.pumpAndSettle();

    // The preview shows the *last* reply (호성's), plus its author name.
    expect(find.text('호성'), findsOneWidget);
    expect(
      find.text('맞아요, 그래서 개체의 이타적 행동도 유전자 전달에 유리하면 설명 가능하죠.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'a topic with no replies shows the no-replies message when expanded',
      (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(find.text(
      '2. 이타적으로 보이는 행동 중 유전자 관점으로 설명되지 않는 사례가 있을까요?',
    ));
    await tester.pumpAndSettle();

    expect(find.text('아직 답글이 없어요'), findsOneWidget);
  });

  testWidgets('a session with no published agenda shows the empty state',
      (tester) async {
    await tester.pumpWidget(buildApp(draftSession));
    await tester.pumpAndSettle();

    expect(find.text('아직 발제문이 게시되지 않았어요'), findsOneWidget);
  });

  testWidgets(
      'the agenda-editor AppBar action only appears for the session\'s '
      'presenter (BC-50 entry seam)', (tester) async {
    // openSession's presenterId matches FakeClubSessionRepository's fake
    // "current user" (user-host); draftSession has no presenterId set.
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.edit_rounded), findsOneWidget);

    await tester.pumpWidget(buildApp(draftSession));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.edit_rounded), findsNothing);
  });
}
