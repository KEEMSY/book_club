import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'admin_models.dart';

part 'admin_api.g.dart';

/// Typed HTTP bindings for the admin domain router.
///
/// Endpoint shapes come from `backend/app/domains/admin/router.py` (BC-88
/// contract, authoritative): every path requires an authenticated session
/// **and** `is_admin=True` — the backend returns 403 otherwise, which
/// [AdminRepository] maps to a typed `AdminRepositoryException`.
///
/// Bearer attachment is handled globally by `AuthInterceptor`.
///
/// **Body typing note:** `PATCH /admin/users/{id}` keeps its body as
/// `Map<String, dynamic>` and converts at the repository boundary — same
/// retrofit_generator/freezed workaround used across the app (see
/// `auth_api.dart`).
@RestApi()
abstract class AdminApi {
  factory AdminApi(Dio dio, {String baseUrl}) = _AdminApi;

  @GET('/admin/stats')
  Future<AdminStatsDto> getStats();

  @GET('/admin/conversion-funnel')
  Future<ConversionFunnelDto> getConversionFunnel();

  @GET('/admin/revenue-metrics')
  Future<RevenueMetricsDto> getRevenueMetrics();

  /// Paginated user list. `search` filters by nickname/email
  /// (case-insensitive); omit for the unfiltered page.
  @GET('/admin/users')
  Future<AdminUserPageDto> listUsers({
    @Query('page') int page = 1,
    @Query('page_size') int pageSize = 20,
    @Query('search') String? search,
  });

  /// Partial update of `is_active` / `is_admin`. Omit a field in [body] to
  /// leave it unchanged.
  @PATCH('/admin/users/{user_id}')
  Future<AdminUserDto> patchUser(
    @Path('user_id') String userId,
    @Body() Map<String, dynamic> body,
  );
}
