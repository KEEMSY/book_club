import '../domain/agenda_topic.dart';
import '../domain/club_session.dart';
import '../domain/session_agenda.dart';
import '../domain/topic_comment.dart';
import 'club_session_api.dart';
import 'club_session_repository.dart';

/// Production [ClubSessionRepository] — talks to the BC-44/45/46/53 REST
/// endpoints via [ClubSessionApi] (BC-60).
///
/// The backend's `ClubSessionPublic`/`SessionAgendaPublic`/`AgendaTopicPublic`
/// schemas map field-for-field onto the domain freezed models
/// ([ClubSession]/[SessionAgenda]/[AgendaTopic]), so most methods just parse
/// the raw JSON straight into the domain type via its generated `fromJson` —
/// no separate wire-DTO layer. The one shape mismatch is
/// `TopicCommentThreadListResponse` (root comments nested with their
/// replies), flattened here into the flat `List<TopicComment>` the UI reads.
class RestClubSessionRepository implements ClubSessionRepository {
  RestClubSessionRepository(this._api);

  final ClubSessionApi _api;

  @override
  Future<List<ClubSession>> listSessions(String clubId) async {
    final data = await _api.listSessions(clubId) as Map<String, dynamic>;
    final items = (data['items'] as List? ?? const []);
    return items
        .map((e) => ClubSession.fromJson(e as Map<String, dynamic>))
        .toList();
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
    final data = await _api.createSession(clubId, {
      'book_id': bookId,
      'title': title,
      if (scope != null) 'scope': scope,
      if (presenterId != null) 'presenter_id': presenterId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt.toIso8601String(),
    });
    return ClubSession.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ClubSession> getSession({
    required String clubId,
    required String sessionId,
  }) async {
    final data = await _api.getSession(clubId, sessionId);
    return ClubSession.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ClubSession> setSessionPresenter({
    required String clubId,
    required String sessionId,
    String? presenterId,
  }) async {
    final data = await _api.setSessionPresenter(clubId, sessionId, {
      'presenter_id': presenterId,
    });
    return ClubSession.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ClubSession> updateSessionStatus({
    required String clubId,
    required String sessionId,
    required ClubSessionStatus status,
  }) async {
    final data = await _api.updateSessionStatus(clubId, sessionId, {
      'status': _statusWire(status),
    });
    return ClubSession.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<SessionAgenda?> getAgenda({
    required String clubId,
    required String sessionId,
  }) async {
    final items = await _listAgendaJson(clubId, sessionId);
    for (final raw in items.reversed) {
      if (raw['status'] == 'published') {
        return SessionAgenda.fromJson(raw);
      }
    }
    return null;
  }

  @override
  Future<List<TopicComment>> listComments({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
  }) async {
    final data = await _api.listComments(clubId, sessionId, agendaId, topicId)
        as Map<String, dynamic>;
    final items = (data['items'] as List? ?? const []);
    return _flattenThreads(items);
  }

  @override
  Future<SessionAgenda> loadAgendaForEdit({
    required String clubId,
    required String sessionId,
  }) async {
    final items = await _listAgendaJson(clubId, sessionId);
    if (items.isNotEmpty) {
      // Prefer resuming an unfinished draft over re-opening a published
      // agenda — publishing has no "unpublish" step (design doc §4.1), so a
      // draft (if any) is the one the author is still actively writing.
      final draft = items.firstWhere(
        (e) => e['status'] == 'draft',
        orElse: () => items.first,
      );
      return SessionAgenda.fromJson(draft);
    }
    // No agenda row exists yet. `session_agendas.body` has a backend
    // min_length=1 constraint, so a single space materializes the row
    // without violating it; the editor should show an empty body, not that
    // placeholder, so it's masked back to '' on the object handed to the UI.
    final created = await _api.createAgenda(clubId, sessionId, {'body': ' '});
    final agenda = SessionAgenda.fromJson(created as Map<String, dynamic>);
    return agenda.copyWith(body: '');
  }

  @override
  Future<SessionAgenda> saveAgendaDraft({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String body,
  }) async {
    final data = await _api.updateAgenda(clubId, sessionId, agendaId, {
      'body': body,
    });
    return SessionAgenda.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<SessionAgenda> publishAgenda({
    required String clubId,
    required String sessionId,
    required String agendaId,
  }) async {
    final data = await _api.publishAgenda(clubId, sessionId, agendaId);
    return SessionAgenda.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<AgendaTopic> addAgendaTopic({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String prompt,
  }) async {
    final data = await _api.addTopic(clubId, sessionId, agendaId, {
      'prompt': prompt,
    });
    return AgendaTopic.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> removeAgendaTopic({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
  }) =>
      _api.deleteTopic(clubId, sessionId, agendaId, topicId);

  @override
  Future<void> reorderAgendaTopics({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required List<String> orderedTopicIds,
  }) =>
      _api.reorderTopics(clubId, sessionId, agendaId, {
        'topic_ids': orderedTopicIds,
      });

  @override
  Future<List<String>> recommendTopicDrafts({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String bookId,
    required String scope,
  }) async {
    final data = await _api.recommendTopicDrafts(clubId, sessionId, agendaId, {
      'book_id': bookId,
      'scope': scope,
    }) as Map<String, dynamic>;
    return (data['topics'] as List? ?? const []).cast<String>();
  }

  @override
  Future<TopicComment> addComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String body,
    String? parentCommentId,
  }) async {
    final data = await _api.addComment(clubId, sessionId, agendaId, topicId, {
      'body': body,
      if (parentCommentId != null) 'parent_comment_id': parentCommentId,
    });
    return TopicComment.fromJson(data as Map<String, dynamic>);
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
    final data = await _api.updateComment(
      clubId,
      sessionId,
      agendaId,
      topicId,
      commentId,
      {'body': body},
    );
    return TopicComment.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteComment({
    required String clubId,
    required String sessionId,
    required String agendaId,
    required String topicId,
    required String commentId,
  }) =>
      _api.deleteComment(clubId, sessionId, agendaId, topicId, commentId);

  Future<List<Map<String, dynamic>>> _listAgendaJson(
    String clubId,
    String sessionId,
  ) async {
    final data =
        await _api.listAgendas(clubId, sessionId) as Map<String, dynamic>;
    return (data['items'] as List? ?? const []).cast<Map<String, dynamic>>();
  }

  /// Flattens `TopicCommentThreadListResponse` (root comments nested with
  /// their single-level replies) into the flat list the UI reads, deriving
  /// `parentCommentId` from tree position (roots carry none in the wire
  /// shape) rather than from a JSON key.
  List<TopicComment> _flattenThreads(List<dynamic> items) {
    final result = <TopicComment>[];
    for (final raw in items) {
      final root = raw as Map<String, dynamic>;
      result.add(
        TopicComment(
          id: root['id'] as String,
          topicId: root['topic_id'] as String,
          authorId: root['author_id'] as String,
          body: root['body'] as String,
          createdAt: DateTime.parse(root['created_at'] as String),
          editedAt: root['edited_at'] != null
              ? DateTime.parse(root['edited_at'] as String)
              : null,
        ),
      );
      final replies = (root['replies'] as List? ?? const []);
      for (final reply in replies) {
        result.add(TopicComment.fromJson(reply as Map<String, dynamic>));
      }
    }
    return result;
  }

  String _statusWire(ClubSessionStatus status) => switch (status) {
        ClubSessionStatus.draft => 'draft',
        ClubSessionStatus.open => 'open',
        ClubSessionStatus.closed => 'closed',
      };
}
