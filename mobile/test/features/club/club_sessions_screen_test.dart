import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/club/application/session_providers.dart';
import 'package:book_club/features/club/data/club_session_repository.dart';
import 'package:book_club/features/club/domain/agenda_topic.dart';
import 'package:book_club/features/club/domain/club.dart';
import 'package:book_club/features/club/domain/club_session.dart';
import 'package:book_club/features/club/domain/session_agenda.dart';
import 'package:book_club/features/club/domain/topic_comment.dart';
import 'package:book_club/features/club/presentation/club_sessions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  final club = Club(
    id: 'club-1',
    name: '테스트 독서모임',
    ownerId: 'user-host',
    inviteCode: 'ABC123',
    maxMembers: 10,
    memberCount: 3,
    createdAt: DateTime(2026, 1, 1),
  );

  Widget buildApp() {
    return ProviderScope(
      overrides: <Override>[
        clubSessionRepositoryProvider
            .overrideWithValue(FakeClubSessionRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: ClubSessionsScreen(club: club),
      ),
    );
  }

  testWidgets('groups sessions by book and shows a status badge per session',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Two book group headers — one per book the fake dataset seeds.
    expect(find.text('이기적 유전자'), findsOneWidget);
    expect(find.text('달러구트 꿈 백화점'), findsOneWidget);

    // Both sessions under the first book render as separate cards.
    expect(find.text('1회차 · 1~3장'), findsOneWidget);
    expect(find.text('2회차 · 4~6장'), findsOneWidget);
    expect(find.text('1회차 · 전권'), findsOneWidget);

    // Status badges reflect each seeded session's lifecycle state.
    expect(find.text('진행 중'), findsOneWidget);
    expect(find.text('작성 중'), findsOneWidget);
    expect(find.text('종료'), findsOneWidget);
  });

  testWidgets('empty session list shows the empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          clubSessionRepositoryProvider
              .overrideWithValue(_EmptyClubSessionRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: ClubSessionsScreen(club: club),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('아직 등록된 회차가 없어요'), findsOneWidget);
  });
}

/// Minimal repository stub returning no sessions, for the empty-state case —
/// [FakeClubSessionRepository] always seeds demo data, so this test needs its
/// own bare implementation instead.
class _EmptyClubSessionRepository implements ClubSessionRepository {
  @override
  Future<List<ClubSession>> listSessions(String clubId) async =>
      const <ClubSession>[];

  @override
  Future<ClubSession> getSession(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<SessionAgenda?> getAgenda(String sessionId) async => null;

  @override
  Future<List<TopicComment>> listComments(String topicId) async =>
      const <TopicComment>[];

  @override
  Future<SessionAgenda> loadAgendaForEdit(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<SessionAgenda> saveAgendaDraft({
    required String sessionId,
    required String body,
  }) =>
      throw UnimplementedError();

  @override
  Future<SessionAgenda> publishAgenda(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<AgendaTopic> addAgendaTopic({
    required String agendaId,
    required String prompt,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> removeAgendaTopic({
    required String agendaId,
    required String topicId,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> reorderAgendaTopics({
    required String agendaId,
    required List<String> orderedTopicIds,
  }) =>
      throw UnimplementedError();

  @override
  Future<TopicComment> addComment({
    required String topicId,
    required String body,
    String? parentCommentId,
  }) =>
      throw UnimplementedError();

  @override
  Future<TopicComment> editComment({
    required String topicId,
    required String commentId,
    required String body,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deleteComment({
    required String topicId,
    required String commentId,
  }) =>
      throw UnimplementedError();
}
