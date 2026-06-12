import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'reminder_api.g.dart';

/// Typed HTTP bindings for the reading reminder endpoints.
///
/// All response methods return [dynamic] to avoid the freezed/retrofit_generator
/// introspection issue that breaks codegen when a typed freezed class is used
/// directly as the return type (same pattern as referral_api.dart).
@RestApi()
abstract class ReminderApi {
  factory ReminderApi(Dio dio, {String baseUrl}) = _ReminderApi;

  @GET('/me/reminders')
  Future<dynamic> listReminders();

  @POST('/me/reminders')
  Future<dynamic> createReminder(@Body() Map<String, dynamic> body);

  @PUT('/me/reminders/{id}')
  Future<dynamic> updateReminder(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/me/reminders/{id}')
  Future<void> deleteReminder(@Path('id') String id);
}
