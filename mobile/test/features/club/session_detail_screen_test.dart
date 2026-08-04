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

  testWidgets(
      'expanding a topic accordion tile reveals the full thread, root and '
      'reply alike (BC-51)', (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('1. 저자가 말하는 "이기적 유전자"는 개체의 이기심과 어떻게 다른가요?'),
    );
    await tester.pumpAndSettle();

    // Both the root comment (민지) and its 1-depth reply (호성) render, not
    // just the last one — this is the full-thread view BC-51 replaces the
    // BC-49 single-preview block with.
    expect(find.text('민지'), findsOneWidget);
    expect(
      find.text('이기적 유전자는 개체 수준이 아니라 유전자 수준의 자기복제 경향을 말하는 것 같아요.'),
      findsOneWidget,
    );
    expect(find.text('호성'), findsOneWidget);
    expect(
      find.text('맞아요, 그래서 개체의 이타적 행동도 유전자 전달에 유리하면 설명 가능하죠.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'a topic with no replies shows the no-replies message and a composer '
      'when expanded', (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(find.text(
      '2. 이타적으로 보이는 행동 중 유전자 관점으로 설명되지 않는 사례가 있을까요?',
    ));
    await tester.pumpAndSettle();

    expect(find.text('아직 답글이 없어요'), findsOneWidget);
    expect(
      find.byKey(const PageStorageKey('reply-composer-topic-2')),
      findsOneWidget,
    );
  });

  testWidgets(
      'posting a new top-level reply adds it to the thread and bumps '
      'the reply count', (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(find.text(
      '2. 이타적으로 보이는 행동 중 유전자 관점으로 설명되지 않는 사례가 있을까요?',
    ));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const PageStorageKey('reply-composer-topic-2')),
      '저도 같은 생각이에요',
    );
    await tester.ensureVisible(find.byTooltip('등록'));
    await tester.tap(find.byTooltip('등록'));
    await tester.pumpAndSettle();

    expect(find.text('저도 같은 생각이에요'), findsOneWidget);
    expect(find.text('아직 답글이 없어요'), findsNothing);
    // Scoped to this tile — topic-3 also seeds exactly one comment, so an
    // unscoped `find.text('답글 1개')` would match both tiles.
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('topic-tile-topic-2')),
        matching: find.text('답글 1개'),
      ),
      findsOneWidget,
    );
    // The composer stamps the fake "current user" as author, and only the
    // author sees moderation actions on their own reply.
    expect(find.text(fakeCurrentUserName), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
  });

  testWidgets(
      'replying to a root comment nests the reply and does not itself offer '
      'a reply action (1-depth cap)', (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(find.text(
      '3. 이 논의가 오늘날 사회 현상을 설명하는 데 얼마나 유효하다고 생각하나요?',
    ));
    await tester.pumpAndSettle();

    // topic-3 seeds exactly one root comment (다은), so exactly one "답글"
    // action exists before replying.
    expect(find.text('답글'), findsOneWidget);

    await tester.ensureVisible(find.text('답글'));
    await tester.tap(find.text('답글'));
    await tester.pumpAndSettle();
    expect(find.textContaining('님에게 답글 작성 중'), findsOneWidget);

    await tester.enterText(
      find.byKey(const PageStorageKey('reply-composer-topic-3')),
      '동의해요, SNS 사례가 딱 맞네요',
    );
    await tester.ensureVisible(find.byTooltip('등록'));
    await tester.tap(find.byTooltip('등록'));
    await tester.pumpAndSettle();

    expect(find.text('동의해요, SNS 사례가 딱 맞네요'), findsOneWidget);
    // Still exactly one "답글" action — the newly-added reply is 1-depth and
    // does not grow its own reply action.
    expect(find.text('답글'), findsOneWidget);
  });

  testWidgets(
      "another member's replies never show edit/delete actions to the "
      'current user', (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('1. 저자가 말하는 "이기적 유전자"는 개체의 이기심과 어떻게 다른가요?'),
    );
    await tester.pumpAndSettle();

    // Both seeded comments here (민지's root, 호성's reply) are authored by
    // someone other than the fake "current user" — neither should offer
    // moderation actions.
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
    expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
  });

  testWidgets('editing own reply updates its body and marks it (수정됨)',
      (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(find.text(
      '2. 이타적으로 보이는 행동 중 유전자 관점으로 설명되지 않는 사례가 있을까요?',
    ));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const PageStorageKey('reply-composer-topic-2')),
      '원래 답글',
    );
    await tester.ensureVisible(find.byTooltip('등록'));
    await tester.tap(find.byTooltip('등록'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byIcon(Icons.edit_outlined));
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const PageStorageKey('reply-edit-comment-fake-100')),
      '수정한 답글',
    );
    await tester.ensureVisible(find.text('저장'));
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(find.text('수정한 답글'), findsOneWidget);
    expect(find.text('원래 답글'), findsNothing);
    expect(find.text('(수정됨)'), findsOneWidget);
  });

  testWidgets('deleting own reply removes it from the thread', (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    await tester.tap(find.text(
      '2. 이타적으로 보이는 행동 중 유전자 관점으로 설명되지 않는 사례가 있을까요?',
    ));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const PageStorageKey('reply-composer-topic-2')),
      '지울 답글',
    );
    await tester.ensureVisible(find.byTooltip('등록'));
    await tester.tap(find.byTooltip('등록'));
    await tester.pumpAndSettle();
    expect(find.text('지울 답글'), findsOneWidget);

    await tester.ensureVisible(find.byIcon(Icons.delete_outline_rounded));
    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pumpAndSettle();

    expect(find.text('지울 답글'), findsNothing);
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
