import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../domain/goal_period.dart';
import '../domain/grade_summary.dart';
import '../domain/heatmap_day.dart';
import '../domain/reading_goal.dart';
import '../domain/reading_session.dart';
import 'reading_api.dart';
import 'reading_models.dart';

/// Typed domain failure surfaced by [ReadingRepository] — mirrors the
/// error-envelope shape used by the book feature so notifiers can stay
/// framework-agnostic.
///
/// Known [code] values from the M3 backend contract:
///   * `ACTIVE_SESSION_EXISTS` (409)
///   * `USER_BOOK_NOT_FOUND` (404)
///   * `SESSION_NOT_FOUND` (404)
///   * `SESSION_ALREADY_ENDED` (409)
///   * `SESSION_TOO_SHORT` (409)
///   * `MANUAL_SESSION_OUT_OF_RANGE` (409)
class ReadingRepositoryException implements Exception {
  const ReadingRepositoryException({
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
      'ReadingRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

final DateFormat _dateWire = DateFormat('yyyy-MM-dd');

/// Thin wrapper around [ReadingApi] that:
///   * converts freezed request DTOs into JSON maps at the boundary,
///   * flattens response DTOs into pure domain types,
///   * translates dio errors into [ReadingRepositoryException].
class ReadingRepository {
  ReadingRepository(this._api);

  final ReadingApi _api;

  Future<ReadingSession> startSession({
    required String userBookId,
    required String device,
  }) async {
    final ReadingSessionDto dto = await _call(
      () => _api.startSession(
        StartSessionRequest(userBookId: userBookId, device: device).toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<SessionCompletion> endSession({
    required String sessionId,
    required DateTime endedAt,
    required int pausedMs,
  }) async {
    final SessionCompletionDto dto = await _call(
      () => _api.endSession(
        sessionId,
        EndSessionRequest(endedAt: endedAt.toUtc(), pausedMs: pausedMs)
            .toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<ReadingSession> logManualSession({
    required String userBookId,
    required DateTime startedAt,
    required DateTime endedAt,
    String? note,
  }) async {
    final ReadingSessionDto dto = await _call(
      () => _api.logManualSession(
        ManualSessionRequest(
          userBookId: userBookId,
          startedAt: startedAt.toUtc(),
          endedAt: endedAt.toUtc(),
          note: note,
        ).toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<List<HeatmapDay>> getHeatmap({
    required DateTime from,
    required DateTime to,
  }) async {
    final HeatmapResponseDto resp = await _call(
      () => _api.getHeatmap(
        from: _dateWire.format(from),
        to: _dateWire.format(to),
      ),
    );
    return resp.items.map((d) => d.toDomain()).toList(growable: false);
  }

  Future<GradeSummary> getGrade() async {
    final GradeSummaryDto dto = await _call(() => _api.getGrade());
    return dto.toDomain();
  }

  Future<ReadingGoal> createGoal({
    required GoalPeriod period,
    required int targetBooks,
    required int targetSeconds,
  }) async {
    final GoalDto dto = await _call(
      () => _api.createGoal(
        CreateGoalRequest(
          period: period.wire,
          targetBooks: targetBooks,
          targetSeconds: targetSeconds,
        ).toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<List<GoalProgress>> getCurrentGoals() async {
    final List<GoalProgressDto> resp =
        await _call(() => _api.getCurrentGoals());
    return resp.map((d) => d.toDomain()).toList(growable: false);
  }

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  ReadingRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return ReadingRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return ReadingRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return ReadingRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
