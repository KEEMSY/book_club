import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'video_session_api.g.dart';

/// Typed HTTP bindings for the reading-club video-call endpoints (M68).
///
/// Returns `Future<dynamic>` (except [endSession]) so the repository converts
/// raw JSON to domain objects — same pattern as [EventApi] — avoiding the
/// freezed/retrofit codegen issue with typed return types.
@RestApi()
abstract class VideoSessionApi {
  factory VideoSessionApi(Dio dio) = _VideoSessionApi;

  @POST('/clubs/{clubId}/video-sessions')
  Future<dynamic> startSession(@Path('clubId') String clubId);

  @GET('/clubs/{clubId}/video-sessions/active')
  Future<dynamic> getActiveSession(@Path('clubId') String clubId);

  @DELETE('/clubs/{clubId}/video-sessions/{sessionId}')
  Future<void> endSession(
    @Path('clubId') String clubId,
    @Path('sessionId') String sessionId,
  );
}
