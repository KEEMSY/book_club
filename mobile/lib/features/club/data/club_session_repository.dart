import '../domain/agenda_topic.dart';
import '../domain/club_session.dart';
import '../domain/session_agenda.dart';
import '../domain/topic_comment.dart';

/// Read-side seam for the session/agenda/discussion domain (BC-42).
///
/// The backing REST endpoints (`club_sessions` / `session_agendas` /
/// `agenda_topics` / `topic_comments` — BC-44/45/46) don't exist yet, so this
/// interface currently has only one implementation, [FakeClubSessionRepository].
/// Presentation code depends solely on this abstraction (§3.4 — UI reaches
/// Repositories only through Riverpod providers), so landing the real backend
/// is a one-line swap in `session_providers.dart`'s
/// `clubSessionRepositoryProvider` — no screen/widget change needed.
abstract class ClubSessionRepository {
  /// All sessions for [clubId], newest-scheduled-first. The list screen
  /// groups these by [ClubSession.bookId] client-side.
  Future<List<ClubSession>> listSessions(String clubId);

  /// The published agenda for [sessionId], or `null` when the session has no
  /// published agenda yet (draft session, or the presenter hasn't published).
  Future<SessionAgenda?> getAgenda(String sessionId);

  /// Root + one-level replies for [topicId], oldest first. BC-49 only reads
  /// `.length` (reply count) and the last item (preview) from this; the full
  /// threaded reply UI is BC-51.
  Future<List<TopicComment>> listComments(String topicId);
}

/// In-memory stand-in for [ClubSessionRepository] until BC-44/45/46 land.
///
/// Seeded with a fixed demo dataset (two books, three sessions across
/// draft/open/closed) so the list/detail screens and their widget tests have
/// something realistic to render without a backend. [clubId] is echoed back
/// onto each seeded session so the fake behaves sensibly for whatever club
/// the caller passes in.
class FakeClubSessionRepository implements ClubSessionRepository {
  FakeClubSessionRepository();

  static const _bookOneId = 'book-1';
  static const _bookTwoId = 'book-2';

  static const sessionOpenId = 'session-1';
  static const sessionDraftId = 'session-2';
  static const sessionClosedId = 'session-3';

  static const _agendaForOpenId = 'agenda-1';
  static const _agendaForClosedId = 'agenda-2';

  List<ClubSession> _sessionsFor(String clubId) => [
        ClubSession(
          id: sessionOpenId,
          clubId: clubId,
          bookId: _bookOneId,
          bookTitle: '이기적 유전자',
          title: '1회차 · 1~3장',
          scope: '1~3장',
          presenterId: 'user-host',
          presenterName: '유진',
          scheduledAt: DateTime(2026, 8, 10, 20),
          status: ClubSessionStatus.open,
          createdAt: DateTime(2026, 8, 1),
        ),
        ClubSession(
          id: sessionDraftId,
          clubId: clubId,
          bookId: _bookOneId,
          bookTitle: '이기적 유전자',
          title: '2회차 · 4~6장',
          scope: '4~6장',
          presenterId: 'user-host',
          presenterName: '유진',
          scheduledAt: DateTime(2026, 8, 17, 20),
          status: ClubSessionStatus.draft,
          createdAt: DateTime(2026, 8, 3),
        ),
        ClubSession(
          id: sessionClosedId,
          clubId: clubId,
          bookId: _bookTwoId,
          bookTitle: '달러구트 꿈 백화점',
          title: '1회차 · 전권',
          scope: '전권',
          presenterId: 'user-presenter-2',
          presenterName: '다은',
          scheduledAt: DateTime(2026, 7, 20, 20),
          status: ClubSessionStatus.closed,
          createdAt: DateTime(2026, 7, 10),
        ),
      ];

  final Map<String, SessionAgenda?> _agendasBySessionId = {
    sessionOpenId: SessionAgenda(
      id: _agendaForOpenId,
      sessionId: sessionOpenId,
      authorId: 'user-host',
      authorName: '유진',
      body: '이번 회차는 이기적 유전자 1~3장을 중심으로, "이타성은 유전자 관점에서 '
          '설명 가능한가"를 다룹니다. 아래 논제를 미리 읽고 답변을 준비해 주세요.',
      status: AgendaStatus.published,
      publishedAt: DateTime(2026, 8, 8, 9),
      createdAt: DateTime(2026, 8, 5),
      topics: [
        AgendaTopic(
          id: 'topic-1',
          agendaId: _agendaForOpenId,
          position: 1,
          prompt: '저자가 말하는 "이기적 유전자"는 개체의 이기심과 어떻게 다른가요?',
          createdAt: DateTime(2026, 8, 5),
        ),
        AgendaTopic(
          id: 'topic-2',
          agendaId: _agendaForOpenId,
          position: 2,
          prompt: '이타적으로 보이는 행동 중 유전자 관점으로 설명되지 않는 사례가 있을까요?',
          createdAt: DateTime(2026, 8, 5),
        ),
        AgendaTopic(
          id: 'topic-3',
          agendaId: _agendaForOpenId,
          position: 3,
          prompt: '이 논의가 오늘날 사회 현상을 설명하는 데 얼마나 유효하다고 생각하나요?',
          createdAt: DateTime(2026, 8, 5),
        ),
      ],
    ),
    sessionDraftId: null,
    sessionClosedId: SessionAgenda(
      id: _agendaForClosedId,
      sessionId: sessionClosedId,
      authorId: 'user-presenter-2',
      authorName: '다은',
      body: '달러구트 꿈 백화점을 완독한 소감과, 가장 인상 깊었던 손님의 사연을 나눠 봅시다.',
      status: AgendaStatus.published,
      publishedAt: DateTime(2026, 7, 18, 9),
      createdAt: DateTime(2026, 7, 12),
      topics: [
        AgendaTopic(
          id: 'topic-4',
          agendaId: _agendaForClosedId,
          position: 1,
          prompt: '가장 기억에 남는 손님의 에피소드는 무엇인가요?',
          createdAt: DateTime(2026, 7, 12),
        ),
      ],
    ),
  };

  final Map<String, List<TopicComment>> _commentsByTopicId = {
    'topic-1': [
      TopicComment(
        id: 'comment-1',
        topicId: 'topic-1',
        authorId: 'user-minji',
        authorName: '민지',
        body: '이기적 유전자는 개체 수준이 아니라 유전자 수준의 자기복제 경향을 말하는 것 같아요.',
        createdAt: DateTime(2026, 8, 9, 21, 10),
      ),
      TopicComment(
        id: 'comment-2',
        topicId: 'topic-1',
        parentCommentId: 'comment-1',
        authorId: 'user-hoseong',
        authorName: '호성',
        body: '맞아요, 그래서 개체의 이타적 행동도 유전자 전달에 유리하면 설명 가능하죠.',
        createdAt: DateTime(2026, 8, 9, 21, 40),
      ),
    ],
    'topic-2': const [],
    'topic-3': [
      TopicComment(
        id: 'comment-3',
        topicId: 'topic-3',
        authorId: 'user-daeun',
        authorName: '다은',
        body: '요즘 SNS의 "선한 영향력" 담론과 엮어 보면 흥미로울 것 같아요.',
        createdAt: DateTime(2026, 8, 9, 22, 5),
      ),
    ],
    'topic-4': const [],
  };

  @override
  Future<List<ClubSession>> listSessions(String clubId) async {
    return _sessionsFor(clubId);
  }

  @override
  Future<SessionAgenda?> getAgenda(String sessionId) async {
    return _agendasBySessionId[sessionId];
  }

  @override
  Future<List<TopicComment>> listComments(String topicId) async {
    return _commentsByTopicId[topicId] ?? const [];
  }
}
