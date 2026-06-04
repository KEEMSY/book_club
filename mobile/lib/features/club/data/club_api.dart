import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'club_api.g.dart';

@RestApi()
abstract class ClubApi {
  factory ClubApi(Dio dio) = _ClubApi;

  @GET('/clubs/me')
  Future<dynamic> listMyClubs();

  @POST('/clubs')
  Future<dynamic> createClub(@Body() Map<String, dynamic> body);

  @GET('/clubs/{clubId}')
  Future<dynamic> getClub(@Path('clubId') String clubId);

  @POST('/clubs/join')
  Future<dynamic> joinClub(@Body() Map<String, dynamic> body);

  @DELETE('/clubs/{clubId}/leave')
  Future<void> leaveClub(@Path('clubId') String clubId);

  @GET('/clubs/{clubId}/events')
  Future<dynamic> listEvents(@Path('clubId') String clubId);

  @POST('/clubs/{clubId}/events')
  Future<dynamic> createEvent(
    @Path('clubId') String clubId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/clubs/{clubId}/events/{eventId}/rsvp')
  Future<void> rsvp(
    @Path('clubId') String clubId,
    @Path('eventId') String eventId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/clubs/{clubId}/messages')
  Future<dynamic> listMessages(
    @Path('clubId') String clubId, {
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 40,
  });

  @DELETE('/clubs/{clubId}/messages/{messageId}')
  Future<void> deleteMessage(
    @Path('clubId') String clubId,
    @Path('messageId') String messageId,
  );
}
