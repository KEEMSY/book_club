import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'auth_models.dart';

part 'auth_api.g.dart';

/// Typed HTTP bindings for the auth router.
///
/// Endpoints / shapes come from the backend contract documented in
/// `backend/app/domains/auth/schemas.py` (M1 authoritative). `/auth/*` paths
/// are deliberately listed without a leading base URL — the dio instance
/// injects `baseUrl` at construction time via [dioProvider].
///
/// Device-token and `/me` endpoints require an Authorization header which
/// `AuthInterceptor` (core/network) attaches automatically for any path
/// that is **not** under `/auth/*`.
///
/// **Body typing note:** retrofit_generator 9.7 cannot currently detect the
/// `toJson` that freezed generates behind a factory (it inspects raw source,
/// not post-build AST). If we annotate bodies as `KakaoLoginRequest` the
/// generated client passes the object to dio directly, which then stringifies
/// it via `toString()`. Typing the bodies as `Map<String, dynamic>` and
/// calling `.toJson()` at the repository boundary dodges that bug and keeps
/// the DTOs source-of-truth for shape. Revisit when retrofit_generator ships
/// freezed-aware introspection.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/kakao')
  Future<LoginResponse> loginKakao(@Body() Map<String, dynamic> body);

  @POST('/auth/apple')
  Future<LoginResponse> loginApple(@Body() Map<String, dynamic> body);

  /// Dev-only login. Backend returns 404 when `settings.env != "dev"`, so
  /// calling this against a non-dev environment surfaces a normal
  /// [AuthRepositoryException] with NETWORK_ERROR / UNKNOWN code.
  @POST('/auth/dev-login')
  Future<LoginResponse> loginDev(@Body() Map<String, dynamic> body);

  @POST('/auth/refresh')
  Future<RefreshResponse> refresh(@Body() Map<String, dynamic> body);

  /// Registers the device's push token. Backend returns 204 so we model it
  /// as `Future<void>` — retrofit maps 2xx with empty body cleanly.
  @POST('/auth/device-tokens')
  Future<void> registerDeviceToken(@Body() Map<String, dynamic> body);

  @GET('/me')
  Future<AuthUserDto> getMe();

  /// Soft-deletes the current user (backend returns 204).
  @DELETE('/me')
  Future<void> deleteMe();
}
