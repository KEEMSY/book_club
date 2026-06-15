import 'package:dio/dio.dart';

import '../domain/experiment_assignment.dart';
import '../domain/user_experiments.dart';
import 'experiment_api.dart';

/// Typed domain failure surfaced by [ExperimentRepository].
class ExperimentRepositoryException implements Exception {
  const ExperimentRepositoryException({
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
      'ExperimentRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [ExperimentApi], converts raw JSON to domain objects, and maps
/// Dio errors to typed [ExperimentRepositoryException] values.
class ExperimentRepository {
  ExperimentRepository(this._api);

  final ExperimentApi _api;

  Future<UserExperiments> getMyExperiments() async {
    try {
      final dynamic raw = await _api.getMyExperiments();
      final Map<String, dynamic> envelope = raw as Map<String, dynamic>;
      final List<dynamic> items = envelope['assignments'] as List<dynamic>;
      final assignments = items
          .cast<Map<String, dynamic>>()
          .map(_assignmentFromJson)
          .toList();
      return UserExperiments(assignments: assignments);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<void> recordConversion(String experimentKey) async {
    try {
      await _api.recordConversion({'experiment_key': experimentKey});
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  ExperimentAssignment _assignmentFromJson(Map<String, dynamic> json) {
    return ExperimentAssignment(
      experimentKey: json['experiment_key'] as String,
      variant: json['variant'] as String,
      assignedAt: DateTime.parse(json['assigned_at'] as String),
    );
  }

  ExperimentRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return ExperimentRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return ExperimentRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return ExperimentRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
