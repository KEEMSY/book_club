import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import 'notification_api.dart';
import 'notification_models.dart';

/// Typed domain failure from [NotificationRepository].
///
/// Mirrors the [FeedRepositoryException] shape — notifiers stay
/// framework-agnostic by catching this concrete type only.
class NotificationRepositoryException implements Exception {
  const NotificationRepositoryException({
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
      'NotificationRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Thin wrapper around [NotificationApi] that translates Dio errors into
/// typed [NotificationRepositoryException] values.
class NotificationRepository {
  NotificationRepository(this._api);

  final NotificationApi _api;

  Future<NotificationListResponse> getNotifications({
    String? cursor,
    int limit = 20,
  }) =>
      _call(
        () => _api.getNotifications(cursor: cursor, limit: limit),
      );

  /// Marks a notification as read. No-ops silently on 404 so stale items
  /// in the local list don't surface errors to the user.
  Future<void> markRead(String id) => _call(() => _api.markRead(id));

  Future<int> getUnreadCount() async {
    final resp = await _call(() => _api.getUnreadCount());
    return resp.unreadCount;
  }

  /// Returns `null` when the backend returns 404 (no report for that week).
  Future<WeeklyReportResponse?> getWeeklyReport(String weekDate) async {
    try {
      return await _api.getWeeklyReport(weekDate);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _fromDio(e);
    }
  }

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  NotificationRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return NotificationRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return NotificationRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return NotificationRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}

final notificationApiProvider = Provider<NotificationApi>((ref) {
  return NotificationApi(ref.watch(dioProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(notificationApiProvider));
});
