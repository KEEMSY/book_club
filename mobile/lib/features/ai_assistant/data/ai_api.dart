import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'ai_api.g.dart';

/// Typed HTTP bindings for the AI reading assistant endpoints (M63).
///
/// Methods return `dynamic` and the repository converts to domain objects, to
/// avoid the freezed/retrofit_generator introspection issue documented across
/// the codebase (see `curation_api.dart`).
@RestApi()
abstract class AiApi {
  factory AiApi(Dio dio, {String baseUrl}) = _AiApi;

  /// `POST /books/{bookId}/ai-prep-card` — generate/return the prep card.
  @POST('/books/{bookId}/ai-prep-card')
  Future<dynamic> createPrepCard(@Path('bookId') String bookId);

  /// `POST /me/library/{userBookId}/ai-reflection` — Pro reflection guide.
  @POST('/me/library/{userBookId}/ai-reflection')
  Future<dynamic> createReflection(@Path('userBookId') String userBookId);

  /// `POST /clubs/{clubId}/ai-discussion-topics` — Pro club-owner topics.
  @POST('/clubs/{clubId}/ai-discussion-topics')
  Future<dynamic> createClubTopics(
    @Path('clubId') String clubId,
    @Body() Map<String, dynamic> body,
  );

  /// `GET /me/ai-usage` — this-month usage counts.
  @GET('/me/ai-usage')
  Future<dynamic> getUsage();

  /// `GET /me/ai-preferences` — the reader's prep-card persona style.
  @GET('/me/ai-preferences')
  Future<dynamic> getPreferences();

  /// `PATCH /me/ai-preferences` — set the prep-card persona style.
  @PATCH('/me/ai-preferences')
  Future<dynamic> updatePreferences(@Body() Map<String, dynamic> body);

  /// `POST /books/{bookId}/ai-audio-intro` — generate a spoken intro script.
  @POST('/books/{bookId}/ai-audio-intro')
  Future<dynamic> createAudioIntro(@Path('bookId') String bookId);
}
