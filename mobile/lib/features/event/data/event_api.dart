import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'event_api.g.dart';

/// Typed HTTP bindings for the location-based meetup endpoints (M64).
///
/// Methods return `Future<dynamic>` (except [leaveWaitlist]) to avoid the
/// freezed/retrofit_generator introspection issue that breaks codegen when a
/// typed freezed class is used as the return type directly — the repository
/// converts the raw JSON into domain objects (same pattern as referral_api).
@RestApi()
abstract class EventApi {
  factory EventApi(Dio dio) = _EventApi;

  @GET('/events/nearby')
  Future<dynamic> getNearbyEvents({
    @Query('lat') required double lat,
    @Query('lng') required double lng,
    @Query('radius_km') required double radiusKm,
    @Query('page') int page = 1,
  });

  @POST('/events')
  Future<dynamic> createEvent(@Body() Map<String, dynamic> body);

  @POST('/events/{eventId}/waitlist')
  Future<dynamic> joinWaitlist(@Path('eventId') String eventId);

  @DELETE('/events/{eventId}/waitlist')
  Future<void> leaveWaitlist(@Path('eventId') String eventId);

  @POST('/events/{eventId}/reviews')
  Future<dynamic> createReview(
    @Path('eventId') String eventId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/events/{eventId}/reviews')
  Future<dynamic> getReviews(@Path('eventId') String eventId);
}
