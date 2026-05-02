import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'club_api.g.dart';

@RestApi()
abstract class ClubApi {
  factory ClubApi(Dio dio) = _ClubApi;

  @GET('/clubs/me')
  Future<Map<String, dynamic>> listMyClubs();

  @POST('/clubs')
  Future<Map<String, dynamic>> createClub(@Body() Map<String, dynamic> body);

  @GET('/clubs/{clubId}')
  Future<Map<String, dynamic>> getClub(@Path('clubId') String clubId);

  @POST('/clubs/join')
  Future<Map<String, dynamic>> joinClub(@Body() Map<String, dynamic> body);

  @DELETE('/clubs/{clubId}/leave')
  Future<void> leaveClub(@Path('clubId') String clubId);

  @GET('/clubs/{clubId}/events')
  Future<Map<String, dynamic>> listEvents(@Path('clubId') String clubId);

  @POST('/clubs/{clubId}/events')
  Future<Map<String, dynamic>> createEvent(
    @Path('clubId') String clubId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/clubs/{clubId}/events/{eventId}/rsvp')
  Future<void> rsvp(
    @Path('clubId') String clubId,
    @Path('eventId') String eventId,
    @Body() Map<String, dynamic> body,
  );
}
