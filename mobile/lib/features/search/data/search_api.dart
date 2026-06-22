import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api.g.dart';

/// Typed HTTP bindings for `GET /search`.
///
/// The endpoint returns a unified result containing books, users, and clubs.
/// Authentication is injected globally by [AuthInterceptor].
@RestApi()
abstract class SearchApi {
  factory SearchApi(Dio dio) = _SearchApi;

  @GET('/search')
  Future<dynamic> search(
    @Query('q') String query, {
    @Query('type') String type = 'all',
    @Query('limit') int limit = 10,
  });

  /// M69 — book title/author autocomplete suggestions (pg_trgm).
  /// Returns a `{suggestions: [...]}` envelope parsed in the repository.
  @GET('/search/autocomplete')
  Future<dynamic> autocomplete(
    @Query('q') String query, {
    @Query('limit') int limit = 10,
  });
}
