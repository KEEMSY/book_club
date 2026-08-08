import 'package:dio/dio.dart';

import '../domain/admin_overview.dart';
import '../domain/admin_user.dart';
import 'admin_api.dart';
import 'admin_models.dart';

/// Typed domain failure surfaced by [AdminRepository].
///
/// Every `/admin/*` endpoint requires `is_admin=True`; a non-admin session
/// (or one whose admin flag was revoked mid-session) gets a 403 here, which
/// the console surfaces as this exception's [message] rather than a raw
/// [DioException]. Mirrors `TeamRepositoryException` (subscription feature).
class AdminRepositoryException implements Exception {
  const AdminRepositoryException({
    required this.code,
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() =>
      'AdminRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// One page of the admin user list, plus enough metadata for the console to
/// decide whether "더 보기" pagination should keep going.
class AdminUserPage {
  const AdminUserPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<AdminUser> items;
  final int total;
  final int page;
  final int pageSize;
}

/// Wraps [AdminApi], converts DTOs to domain types, and maps Dio errors into
/// typed [AdminRepositoryException] values — same shape as
/// `TeamRepository`/`AuthRepository` so the console's error handling stays
/// consistent with the rest of the app.
class AdminRepository {
  AdminRepository(this._api);

  final AdminApi _api;

  /// Fetches the three dashboard metrics endpoints together so the console
  /// shows one loading/error state for the whole stats section.
  Future<AdminOverview> getOverview() async {
    try {
      final List<dynamic> results =
          await Future.wait<dynamic>(<Future<dynamic>>[
        _api.getStats(),
        _api.getConversionFunnel(),
        _api.getRevenueMetrics(),
      ]);
      return AdminOverview(
        stats: (results[0] as AdminStatsDto).toDomain(),
        funnel: (results[1] as ConversionFunnelDto).toDomain(),
        revenue: (results[2] as RevenueMetricsDto).toDomain(),
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Paginated, optionally-filtered user list. `search` is trimmed and
  /// omitted from the query when empty so the backend returns the
  /// unfiltered page (see `AdminApi.listUsers`).
  Future<AdminUserPage> listUsers({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      final String? trimmed = search?.trim();
      final AdminUserPageDto dto = await _api.listUsers(
        page: page,
        pageSize: pageSize,
        search: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      );
      return AdminUserPage(
        items: dto.items.map((d) => d.toDomain()).toList(growable: false),
        total: dto.total,
        page: dto.page,
        pageSize: dto.pageSize,
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Partial update of `is_active` / `is_admin`. Omit a field to leave it
  /// unchanged — mirrors the backend's `PatchUserRequest` semantics.
  Future<AdminUser> patchUser(
    String userId, {
    bool? isActive,
    bool? isAdmin,
  }) async {
    try {
      final AdminUserDto dto = await _api.patchUser(userId, {
        if (isActive != null) 'is_active': isActive,
        if (isAdmin != null) 'is_admin': isAdmin,
      });
      return dto.toDomain();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  AdminRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return AdminRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status == 403) {
      return AdminRepositoryException(
        code: 'FORBIDDEN',
        message: '관리자 권한이 없습니다.',
        statusCode: status,
        cause: err,
      );
    }
    if (status != null && status >= 500) {
      return AdminRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return AdminRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
