import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/club/application/session_providers.dart';
import 'package:book_club/features/club/data/club_session_repository.dart';
import 'package:book_club/features/club/domain/club_session.dart';
import 'package:book_club/features/club/presentation/agenda_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // Matches FakeClubSessionRepository's seeded "open" session/agenda —
  // three topics (topic-1..3), presented by fakeCurrentUserId.
  final openSession = ClubSession(
    id: FakeClubSessionRepository.sessionOpenId,
    clubId: 'club-1',
    bookId: 'book-1',
    bookTitle: '이기적 유전자',
    title: '1회차 · 1~3장',
    scope: '1~3장',
    presenterId: fakeCurrentUserId,
    presenterName: '유진',
    scheduledAt: DateTime(2026, 8, 10, 20),
    status: ClubSessionStatus.open,
    createdAt: DateTime(2026, 8, 1),
  );

  // No seeded agenda for this id — exercises the fresh-empty-draft path.
  final sessionWithNoAgenda = ClubSession(
    id: 'session-no-agenda',
    clubId: 'club-1',
    bookId: 'book-1',
    bookTitle: '이기적 유전자',
    title: '3회차 · 7~9장',
    presenterId: fakeCurrentUserId,
    status: ClubSessionStatus.draft,
    createdAt: DateTime(2026, 8, 20),
  );

  // Presented by someone else — the fake current user must be blocked.
  final nonPresenterSession = ClubSession(
    id: FakeClubSessionRepository.sessionClosedId,
    clubId: 'club-1',
    bookId: 'book-2',
    bookTitle: '달러구트 꿈 백화점',
    title: '1회차 · 전권',
    presenterId: 'user-presenter-2',
    status: ClubSessionStatus.closed,
    createdAt: DateTime(2026, 7, 10),
  );

  Widget buildApp(ClubSession session, {ClubSessionRepository? repository}) {
    return ProviderScope(
      overrides: <Override>[
        clubSessionRepositoryProvider
            .overrideWithValue(repository ?? FakeClubSessionRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: AgendaEditorScreen(session: session),
      ),
    );
  }

  testWidgets('a non-presenter is blocked with an access-denied message',
      (tester) async {
    await tester.pumpWidget(buildApp(nonPresenterSession));
    await tester.pumpAndSettle();

    expect(find.text('호스트 또는 발제자만 발제문을 작성할 수 있어요'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('adding a topic appends it with the next position',
      (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    expect(find.textContaining('1. 저자가 말하는'), findsOneWidget);

    await tester.tap(find.text('논제 추가'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '새로운 논제입니다');
    await tester.tap(find.widgetWithText(FilledButton, '추가'));
    await tester.pumpAndSettle();

    expect(find.textContaining('4. 새로운 논제입니다'), findsOneWidget);
  });

  testWidgets('removing a topic deletes it and renumbers the rest',
      (tester) async {
    await tester.pumpWidget(buildApp(openSession));
    await tester.pumpAndSettle();

    // Delete the first seeded topic; the second should renumber 2 -> 1.
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('저자가 말하는'), findsNothing);
    expect(find.textContaining('1. 이타적으로 보이는 행동'), findsOneWidget);
  });

  testWidgets('dragging a topic handle changes the persisted topic order',
      (tester) async {
    final repo = FakeClubSessionRepository();
    await tester.pumpWidget(buildApp(openSession, repository: repo));
    await tester.pumpAndSettle();

    final originalAgenda = await repo.getAgenda(openSession.id);
    final originalOrder = originalAgenda!.topics.map((t) => t.id).toList();

    await tester.drag(
      find.byIcon(Icons.drag_handle_rounded).first,
      const Offset(0, 220),
    );
    await tester.pumpAndSettle();

    final updatedAgenda = await repo.getAgenda(openSession.id);
    final updatedOrder = updatedAgenda!.topics.map((t) => t.id).toList();

    expect(updatedOrder, isNot(orderedEquals(originalOrder)));
    expect(updatedOrder.toSet(), originalOrder.toSet());
    // Positions stay contiguous 1..N after the reorder re-numbers them.
    expect(
      updatedAgenda.topics.map((t) => t.position).toList(),
      List.generate(updatedAgenda.topics.length, (i) => i + 1),
    );
  });

  testWidgets(
      'the publish button stays disabled until body and topics are both '
      'non-empty', (tester) async {
    await tester.pumpWidget(buildApp(sessionWithNoAgenda));
    await tester.pumpAndSettle();

    FilledButton publishButton() =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, '게시'));

    expect(publishButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField).first, '이번 회차 발제문입니다');
    await tester.pump();
    expect(publishButton().onPressed, isNull, reason: '논제가 없으면 아직 게시 불가');

    await tester.tap(find.text('논제 추가'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '논제 하나');
    await tester.tap(find.widgetWithText(FilledButton, '추가'));
    await tester.pumpAndSettle();

    expect(publishButton().onPressed, isNotNull);
  });
}
