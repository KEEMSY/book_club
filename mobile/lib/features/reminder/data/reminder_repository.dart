import 'package:dio/dio.dart';

import '../domain/reading_reminder.dart';
import 'reminder_api.dart';

/// Typed domain failure surfaced by [ReminderRepository].
class ReminderRepositoryException implements Exception {
  const ReminderRepositoryException({
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
      'ReminderRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [ReminderApi], converts raw JSON to [ReadingReminder] domain objects,
/// and maps Dio errors to typed [ReminderRepositoryException] values.
class ReminderRepository {
  ReminderRepository(this._api);

  final ReminderApi _api;

  Future<List<ReadingReminder>> listReminders() async {
    try {
      final dynamic raw = await _api.listReminders();
      final Map<String, dynamic> envelope = raw as Map<String, dynamic>;
      final List<dynamic> items = envelope['items'] as List<dynamic>;
      return items
          .cast<Map<String, dynamic>>()
          .map(_fromJson)
          .toList();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<ReadingReminder> createReminder({
    required List<int> daysOfWeek,
    required String remindAt,
  }) async {
    try {
      final dynamic raw = await _api.createReminder({
        'days_of_week': daysOfWeek,
        'remind_at': remindAt,
        'is_active': true,
      });
      return _fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<ReadingReminder> updateReminder({
    required String id,
    required List<int> daysOfWeek,
    required String remindAt,
    required bool isActive,
  }) async {
    try {
      final dynamic raw = await _api.updateReminder(id, {
        'days_of_week': daysOfWeek,
        'remind_at': remindAt,
        'is_active': isActive,
      });
      return _fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      await _api.deleteReminder(id);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  ReadingReminder _fromJson(Map<String, dynamic> json) {
    return ReadingReminder(
      id: json['id'] as String,
      daysOfWeek: (json['days_of_week'] as List<dynamic>).cast<int>(),
      remindAt: json['remind_at'] as String,
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  ReminderRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return ReminderRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return ReminderRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return ReminderRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
