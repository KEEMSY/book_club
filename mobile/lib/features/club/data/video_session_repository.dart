import 'package:dio/dio.dart';

import '../domain/video_session.dart';
import 'video_session_api.dart';

/// Typed domain failure surfaced by [VideoSessionRepository].
class VideoSessionException implements Exception {
  const VideoSessionException({
    required this.code,
    required this.message,
    this.statusCode,
  });

  final String code;
  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'VideoSessionException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [VideoSessionApi], converts raw JSON to [VideoSession], and maps Dio
/// errors into typed [VideoSessionException] values.
class VideoSessionRepository {
  VideoSessionRepository(this._api);

  final VideoSessionApi _api;

  /// Starts (or re-joins) the club's video call and returns join credentials.
  Future<VideoSession> startSession(String clubId) async {
    try {
      final dynamic raw = await _api.startSession(clubId);
      return VideoSession.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Returns the club's active session, or throws on 404 when none is live.
  Future<VideoSession> getActiveSession(String clubId) async {
    try {
      final dynamic raw = await _api.getActiveSession(clubId);
      return VideoSession.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Ends [sessionId] for [clubId]; the backend enforces host-only.
  Future<void> endSession({
    required String clubId,
    required String sessionId,
  }) async {
    try {
      await _api.endSession(clubId, sessionId);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  VideoSessionException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return VideoSessionException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
        );
      }
    }
    return VideoSessionException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
    );
  }
}
