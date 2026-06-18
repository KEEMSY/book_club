import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'highlight_models.dart';

part 'highlight_api.g.dart';

/// Typed HTTP bindings for the M51 highlight social surface.
///
/// Bodies stay as `Map<String, dynamic>` and responses as `dynamic`/`List`
/// for the same freezed/retrofit_generator 9.7 introspection issue
/// documented in `feed_api.dart`; the repository converts at the boundary.
///
/// Endpoints (M51):
///   * `PATCH /me/highlights/{id}/visibility`
///   * `POST  /me/highlights/{id}/share`
///   * `GET   /highlights/explore?sort=&limit=`
///
/// `exploreHighlights` returns typed DTOs so retrofit deserializes each item
/// via `HighlightExploreDto.fromJson` (retrofit_generator can't introspect a
/// bare `List<dynamic>` element type).
@RestApi()
abstract class HighlightApi {
  factory HighlightApi(Dio dio, {String baseUrl}) = _HighlightApi;

  @PATCH('/me/highlights/{id}/visibility')
  Future<void> updateVisibility(
    @Path('id') String highlightId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/me/highlights/{id}/share')
  Future<void> shareToFeed(@Path('id') String highlightId);

  @GET('/highlights/explore')
  Future<List<HighlightExploreDto>> exploreHighlights({
    @Query('sort') String sort = 'recent',
    @Query('limit') int limit = 50,
  });
}
