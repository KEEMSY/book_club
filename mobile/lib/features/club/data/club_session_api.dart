import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'club_session_api.g.dart';

/// retrofit client for the BC-42 session/agenda/discussion endpoints
/// (`backend/app/domains/club/router.py` — "sessions (BC-44)" /
/// "agendas (BC-45)" / "topics (BC-45)" / "topic comments (BC-46)" sections).
/// Every route nests under `/clubs/{clubId}/sessions/{sessionId}/...` — see
/// `ClubSessionRepository`'s doc comment for why every method threads the
/// full path context through.
@RestApi()
abstract class ClubSessionApi {
  factory ClubSessionApi(Dio dio) = _ClubSessionApi;

  // --- sessions (BC-44) ---

  @POST('/clubs/{clubId}/sessions')
  Future<dynamic> createSession(
    @Path('clubId') String clubId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/clubs/{clubId}/sessions')
  Future<dynamic> listSessions(@Path('clubId') String clubId);

  @GET('/clubs/{clubId}/sessions/{sessionId}')
  Future<dynamic> getSession(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
  );

  @PATCH('/clubs/{clubId}/sessions/{sessionId}/presenter')
  Future<dynamic> setSessionPresenter(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/clubs/{clubId}/sessions/{sessionId}/status')
  Future<dynamic> updateSessionStatus(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Body() Map<String, dynamic> body,
  );

  // --- agendas (BC-45) ---

  @POST('/clubs/{clubId}/sessions/{sessionId}/agendas')
  Future<dynamic> createAgenda(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/clubs/{clubId}/sessions/{sessionId}/agendas')
  Future<dynamic> listAgendas(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
  );

  @PATCH('/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}')
  Future<dynamic> updateAgenda(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/publish')
  Future<dynamic> publishAgenda(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
  );

  // --- topics (BC-45) ---

  @POST('/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics')
  Future<dynamic> addTopic(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Body() Map<String, dynamic> body,
  );

  // --- AI 논제 초안 추천 (BC-53) ---
  @POST(
    '/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics/recommendations',
  )
  Future<dynamic> recommendTopicDrafts(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Body() Map<String, dynamic> body,
  );

  // NOTE: matches the backend's own route registration order (router.py) —
  // reorder must be declared/matched before the {topicId} PATCH below so
  // retrofit/the server don't try (and fail) to parse "reorder" as a topicId.
  @PATCH(
    '/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics/reorder',
  )
  Future<dynamic> reorderTopics(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(
    '/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics/{topicId}',
  )
  Future<void> deleteTopic(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Path('topicId') String topicId,
  );

  // --- topic comments (BC-46) ---

  @POST(
    '/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics/{topicId}/comments',
  )
  Future<dynamic> addComment(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Path('topicId') String topicId,
    @Body() Map<String, dynamic> body,
  );

  @GET(
    '/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics/{topicId}/comments',
  )
  Future<dynamic> listComments(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Path('topicId') String topicId,
  );

  @PATCH(
    '/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics/{topicId}/comments/{commentId}',
  )
  Future<dynamic> updateComment(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Path('topicId') String topicId,
    @Path('commentId') String commentId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(
    '/clubs/{clubId}/sessions/{sessionId}/agendas/{agendaId}/topics/{topicId}/comments/{commentId}',
  )
  Future<void> deleteComment(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
    @Path('agendaId') String agendaId,
    @Path('topicId') String topicId,
    @Path('commentId') String commentId,
  );
}
