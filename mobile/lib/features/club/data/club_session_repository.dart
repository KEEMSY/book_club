import '../domain/agenda_topic.dart';
import '../domain/club_session.dart';
import '../domain/session_agenda.dart';
import '../domain/topic_comment.dart';

/// Stand-in "current user" id — kept for [FakeClubSessionRepository] (seeded
/// author of two of its three demo sessions) and existing widget tests that
/// assert against it. Permission gating in `session_providers.dart` now reads
/// the real `authNotifierProvider` instead of comparing against this.
const fakeCurrentUserId = 'user-host';

/// Display name for [fakeCurrentUserId] — stamps newly-created comments in
/// [FakeClubSessionRepository] so they match the seeded persona's name shown
/// elsewhere in the fixtures (session-1/2's presenter).
const fakeCurrentUserName = '유진';

/// Read/write seam for the session/agenda/discussion domain (BC-42).
///
/// Every method beyond [listSessions] takes the full path context
/// (`clubId`/`sessionId`/`agendaId`/`topicId`) a caller already has in scope,
/// because the real REST routes (BC-44/45/46, `club/router.py`) nest all the
/// way down: `/clubs/{club_id}/sessions/{session_id}/agendas/{agenda_id}/
/// topics/{topic_id}/comments/{comment_id}`. There is no id-only shortcut
/// endpoint on the backend, so every call site must thread these ids through.
///
/// [RestClubSessionRepository] (`club_session_repository_impl.dart`) is the
/// production implementation (BC-60); [FakeClubSessionRepository] below
/// remains for widget/unit tests that don't need a live backend.
abstract class ClubSessionRepository {
  /// All sessions for [clubId], newest-scheduled-first. The list screen
  /// groups these by [ClubSession.bookId] client-side.
  Future<List<ClubSession>> listSessions(String clubId);

  /// Creates a new session under [clubId] (host-only — design doc §5).
  ///
  /// Wired for completeness (BC-60 scope); no mobile screen calls this yet —
  /// session creation has no host-management UI in BC-49~52. A future ticket
  /// building that UI can call straight through this method.
  Future<ClubSession> createSession({
    required String clubId,
    required String bookId,
    required String title,
    String? scope,
    String? presenterId,
    DateTime? scheduledAt,
  });

  /// Resolves a single [ClubSession] by [clubId] + [sessionId].
  ///
  /// The deep-link seam BC-52 wires for feed-card taps and push-notification
  /// routing carries both ids (`{club_id, session_id, ...}` in the BC-47
  /// feed-event/notification payload) — `SessionLoader`/the router thread
  /// both through.
  Future<ClubSession> getSession({
    required String clubId,
    required String sessionId,
  });

  /// Reassigns [sessionId]'s presenter (host-only — design doc §5).
  ///
  /// Wired for completeness (BC-60 scope); no mobile screen calls this yet,
  /// same as [createSession].
  Future<ClubSession> setSessionPresenter({
    required String clubId,
    required String sessionId,
    String? presenterId,
  });

  /// Transitions [sessionId] to [status] (host-only — design doc §5,
  /// forward-only draft → open → closed).
  ///
  /// Wired for completeness (BC-60 scope); no mobile screen calls this yet,
  /// same as [createSession].
  Future<ClubSession> updateSessionStatus({
    required String clubId,
    required String sessionId,
    required ClubSessionStatus status,
  });

  /// The published agenda for [sessionId], or `null` when the session has no
  /// published agenda yet (draft session, or the presenter hasn't published).
  Future<SessionAgenda?> getAgenda({
    required String clubId,
    required String sessionId,
  });

  /// Root + one-level replies for [topicId], oldest first. BC-49 only reads
  /// `.length` (reply count) and the last item (preview) from this; the full
  /// threaded reply UI is BC-51.
  Future<List<TopicComment>> listComments({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
  });

  /// The agenda for [sessionId] to prefill the BC-50 editor — draft or
  /// published, whichever exists — or a freshly-created draft (real backend
  /// row, empty body) if [sessionId] has no agenda at all yet.
  ///
  /// Unlike [getAgenda] (read-only detail screen: published-only, `null`
  /// otherwise), the editor must be able to resume unpublished work. Always
  /// returns a [SessionAgenda] with a real, persisted id — every other
  /// agenda-scoped method requires one, since `agenda_topics`/`session_
  /// agendas` rows are FK-linked on the backend.
  Future<SessionAgenda> loadAgendaForEdit({
    required String clubId,
    required String sessionId,
  });

  /// Persists [body] onto the existing [agendaId] (always real — obtained via
  /// [loadAgendaForEdit] first). Does not touch [SessionAgenda.status] —
  /// publishing is a separate, explicit call.
  Future<SessionAgenda> saveAgendaDraft({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String body,
  });

  /// Marks [agendaId] as published, stamping `publishedAt`. The design doc
  /// (§4.1) has no unpublish action.
  Future<SessionAgenda> publishAgenda({
    required String clubId,
    required String sessionId,
    required String agendaId,
  });

  /// Appends a new topic with [prompt] to the end of [agendaId]'s topic list.
  Future<AgendaTopic> addAgendaTopic({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String prompt,
  });

  /// Removes [topicId] from [agendaId] and re-numbers the remaining topics'
  /// [AgendaTopic.position] to stay contiguous.
  Future<void> removeAgendaTopic({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
  });

  /// Reorders [agendaId]'s topics to match [orderedTopicIds] (the full
  /// front-to-back id order after a drag) and re-numbers
  /// [AgendaTopic.position] to match.
  Future<void> reorderAgendaTopics({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required List<String> orderedTopicIds,
  });

  /// AI-drafted topic-prompt candidates (3~5) for [bookId] + [scope] (BC-53).
  /// Not persisted server-side — the editor fills a candidate into the "논제
  /// 추가" dialog and the author still confirms via [addAgendaTopic].
  Future<List<String>> recommendTopicDrafts({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String bookId,
    required String scope,
  });

  /// Posts a new reply in [topicId]'s thread, authored by the current user.
  ///
  /// When [parentCommentId] is given it must reference a *root* comment
  /// (one whose own [TopicComment.parentCommentId] is `null`) — the design
  /// doc caps threads at one level of nesting (§2 비목표). The backend
  /// service rejects a [parentCommentId] that itself has a parent.
  Future<TopicComment> addComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String body,
    String? parentCommentId,
  });

  /// Updates [commentId]'s body and stamps [TopicComment.editedAt].
  ///
  /// Callers are expected to have already checked authorship/host permission
  /// (design doc §5) via `canModerateCommentProvider` — this method itself
  /// does not re-validate who is asking (the backend does).
  Future<TopicComment> editComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String commentId,
    required String body,
  });

  /// Removes [commentId] from [topicId]'s thread. Deleting a root comment
  /// also removes its replies (backend FK cascade).
  Future<void> deleteComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String commentId,
  });
}

/// In-memory stand-in for [ClubSessionRepository] — used by widget/unit tests
/// that don't need a live backend. Seeded with a fixed demo dataset (two
/// books, three sessions across draft/open/closed) so the list/detail
/// screens and their widget tests have something realistic to render.
/// [clubId] is echoed back onto each seeded session so the fake behaves
/// sensibly for whatever club the caller passes in; the extra `clubId`
/// parameters the real interface now requires are accepted but not
/// otherwise used (this fake only ever models a single club).
class FakeClubSessionRepository implements ClubSessionRepository {
  FakeClubSessionRepository();

  static const _bookOneId = 'book-1';
  static const _bookTwoId = 'book-2';

  static const sessionOpenId = 'session-1';
  static const sessionDraftId = 'session-2';
  static const sessionClosedId = 'session-3';

  static const _agendaForOpenId = 'agenda-1';
  static const _agendaForClosedId = 'agenda-2';

  /// Cache of sessions keyed by id, backing [getSession] — the id-only
  /// lookup BC-52 wires for feed-card taps and push-notification deep
  /// links. Seeded eagerly with a placeholder clubId so a cold deep link
  /// resolves even before [listSessions] has run for the caller's real
  /// clubId; [listSessions] refreshes each entry with the caller's actual
  /// clubId afterwards.
  final Map<String, ClubSession> _sessionsById = {
    for (final session in _sessionsFor('club-1')) session.id: session,
  };

  static List<ClubSession> _sessionsFor(String clubId) => [
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

  /// Counter for synthetic ids handed out by [addAgendaTopic] — starts well
  /// past the seeded `topic-1`..`topic-4` ids so new topics never collide
  /// with them.
  int _topicIdSeq = 100;

  /// Counter for synthetic ids handed out by [addComment] — starts well past
  /// the seeded `comment-1`..`comment-3` ids so new comments never collide
  /// with them.
  int _commentIdSeq = 100;

  /// Counter for synthetic ids handed out by [createSession].
  int _sessionIdSeq = 100;

  @override
  Future<List<ClubSession>> listSessions(String clubId) async {
    final sessions = _sessionsFor(clubId);
    for (final session in sessions) {
      _sessionsById[session.id] = session;
    }
    return sessions;
  }

  @override
  Future<ClubSession> createSession({
    required String clubId,
    required String bookId,
    required String title,
    String? scope,
    String? presenterId,
    DateTime? scheduledAt,
  }) async {
    final session = ClubSession(
      id: 'session-fake-${_sessionIdSeq++}',
      clubId: clubId,
      bookId: bookId,
      title: title,
      scope: scope,
      presenterId: presenterId,
      scheduledAt: scheduledAt,
      status: ClubSessionStatus.draft,
      createdAt: DateTime.now(),
    );
    _sessionsById[session.id] = session;
    return session;
  }

  @override
  Future<ClubSession> getSession({
    required String clubId,
    required String sessionId,
  }) async {
    final session = _sessionsById[sessionId];
    if (session == null) {
      throw ArgumentError('알 수 없는 회차입니다: $sessionId');
    }
    return session;
  }

  @override
  Future<ClubSession> setSessionPresenter({
    required String clubId,
    required String sessionId,
    String? presenterId,
  }) async {
    final current = await getSession(clubId: clubId, sessionId: sessionId);
    final updated = current.copyWith(presenterId: presenterId);
    _sessionsById[sessionId] = updated;
    return updated;
  }

  @override
  Future<ClubSession> updateSessionStatus({
    required String clubId,
    required String sessionId,
    required ClubSessionStatus status,
  }) async {
    final current = await getSession(clubId: clubId, sessionId: sessionId);
    final updated = current.copyWith(status: status);
    _sessionsById[sessionId] = updated;
    return updated;
  }

  @override
  Future<SessionAgenda?> getAgenda({
    required String clubId,
    required String sessionId,
  }) async {
    final agenda = _agendasBySessionId[sessionId];
    // Guards the documented contract now that saveAgendaDraft/loadAgendaForEdit
    // can actually create non-published entries — the seeded fixtures above
    // happened to be published already, which used to mask this gap.
    return agenda?.status == AgendaStatus.published ? agenda : null;
  }

  @override
  Future<List<TopicComment>> listComments({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
  }) async {
    return _commentsByTopicId[topicId] ?? const [];
  }

  @override
  Future<SessionAgenda> loadAgendaForEdit({
    required String clubId,
    required String sessionId,
  }) async {
    final existing = _agendasBySessionId[sessionId];
    if (existing != null) return existing;
    final draft = SessionAgenda(
      id: 'agenda-draft-$sessionId',
      sessionId: sessionId,
      authorId: fakeCurrentUserId,
      body: '',
      status: AgendaStatus.draft,
      createdAt: DateTime.now(),
    );
    _agendasBySessionId[sessionId] = draft;
    return draft;
  }

  @override
  Future<SessionAgenda> saveAgendaDraft({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String body,
  }) async {
    final current =
        await loadAgendaForEdit(clubId: clubId, sessionId: sessionId);
    final saved = current.copyWith(body: body);
    _agendasBySessionId[sessionId] = saved;
    return saved;
  }

  @override
  Future<SessionAgenda> publishAgenda({
    required String clubId,
    required String sessionId,
    required String agendaId,
  }) async {
    final current =
        await loadAgendaForEdit(clubId: clubId, sessionId: sessionId);
    final published = current.copyWith(
      status: AgendaStatus.published,
      publishedAt: DateTime.now(),
    );
    _agendasBySessionId[sessionId] = published;
    return published;
  }

  @override
  Future<AgendaTopic> addAgendaTopic({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String prompt,
  }) async {
    final agenda = _agendasBySessionId[sessionId]!;
    final topic = AgendaTopic(
      id: 'topic-fake-${_topicIdSeq++}',
      agendaId: agendaId,
      position: agenda.topics.length + 1,
      prompt: prompt,
      createdAt: DateTime.now(),
    );
    _agendasBySessionId[sessionId] = agenda.copyWith(
      topics: [...agenda.topics, topic],
    );
    return topic;
  }

  @override
  Future<void> removeAgendaTopic({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
  }) async {
    final agenda = _agendasBySessionId[sessionId]!;
    final remaining =
        agenda.topics.where((topic) => topic.id != topicId).toList();
    _agendasBySessionId[sessionId] = agenda.copyWith(
      topics: _renumbered(remaining),
    );
  }

  @override
  Future<void> reorderAgendaTopics({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required List<String> orderedTopicIds,
  }) async {
    final agenda = _agendasBySessionId[sessionId]!;
    final byId = {for (final topic in agenda.topics) topic.id: topic};
    final reordered = orderedTopicIds.map((id) => byId[id]!).toList();
    _agendasBySessionId[sessionId] = agenda.copyWith(
      topics: _renumbered(reordered),
    );
  }

  @override
  Future<List<String>> recommendTopicDrafts({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String bookId,
    required String scope,
  }) async =>
      const [
        '이 챕터에서 저자가 가장 강조하는 주장은 무엇인가요?',
        '본문의 사례를 오늘날 상황에 대입하면 어떤 점이 달라질까요?',
        '가장 동의하기 어려웠던 부분은 어디였고, 그 이유는 무엇인가요?',
      ];

  @override
  Future<TopicComment> addComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String body,
    String? parentCommentId,
  }) async {
    final existing = _commentsByTopicId[topicId] ?? const [];
    if (parentCommentId != null) {
      TopicComment? parent;
      for (final candidate in existing) {
        if (candidate.id == parentCommentId) {
          parent = candidate;
          break;
        }
      }
      if (parent == null) {
        throw ArgumentError('알 수 없는 답글입니다: $parentCommentId');
      }
      if (parent.parentCommentId != null) {
        throw ArgumentError('대댓글에는 답글을 달 수 없어요 (1단계까지만 지원돼요)');
      }
    }
    final comment = TopicComment(
      id: 'comment-fake-${_commentIdSeq++}',
      topicId: topicId,
      authorId: fakeCurrentUserId,
      authorName: fakeCurrentUserName,
      parentCommentId: parentCommentId,
      body: body,
      createdAt: DateTime.now(),
    );
    _commentsByTopicId[topicId] = [...existing, comment];
    return comment;
  }

  @override
  Future<TopicComment> editComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String commentId,
    required String body,
  }) async {
    final existing = _commentsByTopicId[topicId] ?? const [];
    final index = existing.indexWhere((c) => c.id == commentId);
    if (index == -1) {
      throw ArgumentError('알 수 없는 답글입니다: $commentId');
    }
    final updated = existing[index].copyWith(
      body: body,
      editedAt: DateTime.now(),
    );
    _commentsByTopicId[topicId] = [
      for (var i = 0; i < existing.length; i++)
        i == index ? updated : existing[i],
    ];
    return updated;
  }

  @override
  Future<void> deleteComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String commentId,
  }) async {
    final existing = _commentsByTopicId[topicId] ?? const [];
    _commentsByTopicId[topicId] = existing
        .where((c) => c.id != commentId && c.parentCommentId != commentId)
        .toList();
  }

  List<AgendaTopic> _renumbered(List<AgendaTopic> topics) => [
        for (var i = 0; i < topics.length; i++)
          topics[i].copyWith(position: i + 1),
      ];
}
