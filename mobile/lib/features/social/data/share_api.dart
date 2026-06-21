import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../domain/share_card.dart';

part 'share_api.g.dart';

/// Typed HTTP bindings for the M62 share-card endpoints.
///
/// All paths are covered by [AuthInterceptor]. Bodies are passed as plain maps
/// (matching the social_api.dart convention) to sidestep the freezed/retrofit
/// generator introspection issue, and so the snake_case keys the backend
/// expects (`card_type`, `referral_code`) are written explicitly.
///
/// Endpoints:
///   * `GET  /me/share-cards/{cardType}`
///   * `POST /me/share-events`
@RestApi()
abstract class ShareApi {
  factory ShareApi(Dio dio, {String baseUrl}) = _ShareApi;

  @GET('/me/share-cards/{cardType}')
  Future<ShareCardMeta> getShareCardMeta(@Path('cardType') String cardType);

  @POST('/me/share-events')
  Future<void> recordShareEvent(@Body() Map<String, dynamic> body);
}
