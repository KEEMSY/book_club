import 'package:dio/dio.dart';

import '../domain/team_subscription.dart';
import 'team_api.dart';

/// Typed domain failure surfaced by [TeamRepository].
class TeamRepositoryException implements Exception {
  const TeamRepositoryException({
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
      'TeamRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [TeamApi], converts raw JSON to [TeamSubscription], and maps Dio
/// errors into typed [TeamRepositoryException] values.
class TeamRepository {
  TeamRepository(this._api);

  final TeamApi _api;

  Future<TeamSubscription> createTeam({
    required String teamName,
    int seatCount = 10,
    int validMonths = 12,
  }) async {
    try {
      final dynamic raw = await _api.createTeam({
        'team_name': teamName,
        'seat_count': seatCount,
        'valid_months': validMonths,
      });
      return TeamSubscription.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<TeamSubscription> getTeam(String teamId) async {
    try {
      final dynamic raw = await _api.getTeam(teamId);
      return TeamSubscription.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<TeamSubscription> addMember({
    required String teamId,
    required String userId,
  }) async {
    try {
      final dynamic raw = await _api.addMember(teamId, {'user_id': userId});
      return TeamSubscription.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<TeamSubscription> removeMember({
    required String teamId,
    required String userId,
  }) async {
    try {
      final dynamic raw = await _api.removeMember(teamId, userId);
      return TeamSubscription.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  TeamRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return TeamRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return TeamRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return TeamRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
