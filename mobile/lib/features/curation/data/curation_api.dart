import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'curation_api.g.dart';

/// Typed HTTP bindings for the curation-card endpoints.
///
/// Returns [dynamic] to avoid the freezed/retrofit_generator introspection
/// issue documented in `reading_api.dart` / `reminder_api.dart`.
@RestApi()
abstract class CurationApi {
  factory CurationApi(Dio dio, {String baseUrl}) = _CurationApi;

  /// `GET /books/{bookId}/curation-cards/first`
  ///
  /// Returns the first ordered curation card for the book, or null when
  /// no cards have been generated yet.
  @GET('/books/{bookId}/curation-cards/first')
  Future<dynamic> getFirstCard(@Path('bookId') String bookId);

  /// `POST /me/curation-cards/{cardId}/feedback`
  ///
  /// Records the reader's reaction (helpful / skip / dismiss). 204 No Content.
  @POST('/me/curation-cards/{cardId}/feedback')
  Future<void> postFeedback(
    @Path('cardId') String cardId,
    @Body() Map<String, dynamic> body,
  );
}
