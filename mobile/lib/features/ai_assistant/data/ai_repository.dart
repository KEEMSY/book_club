import 'package:dio/dio.dart';

import '../domain/ai_models.dart';
import 'ai_api.dart';

/// Typed domain failure surfaced by [AiRepository].
///
/// [code] mirrors the backend error code so the UI can branch — most notably
/// `PRO_REQUIRED` (show the upgrade CTA) and `PREP_DAILY_LIMIT` (rate limited).
/// `NOT_CONFIGURED` means the server has no Claude key wired ("AI 연결 안 됨").
class AiRepositoryException implements Exception {
  const AiRepositoryException({
    required this.code,
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Object? cause;

  bool get isProRequired => code == 'PRO_REQUIRED';
  bool get isRateLimited => code == 'PREP_DAILY_LIMIT' || statusCode == 429;
  bool get isUnavailable => code == 'NOT_CONFIGURED' || (statusCode ?? 0) >= 500;

  @override
  String toString() =>
      'AiRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [AiApi], converts raw JSON to domain objects, and maps Dio errors to
/// typed [AiRepositoryException] values.
class AiRepository {
  AiRepository(this._api);

  final AiApi _api;

  Future<AiPrepCard> getPrepCard(String bookId) async {
    try {
      final dynamic raw = await _api.createPrepCard(bookId);
      return AiPrepCard.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<AiReflection> createReflection(String userBookId) async {
    try {
      final dynamic raw = await _api.createReflection(userBookId);
      return AiReflection.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<List<String>> getClubTopics(
    String clubId, {
    required int pageStart,
    required int pageEnd,
  }) async {
    try {
      final dynamic raw = await _api.createClubTopics(
        clubId,
        {'page_start': pageStart, 'page_end': pageEnd},
      );
      final map = raw as Map<String, dynamic>;
      return (map['topics'] as List<dynamic>).cast<String>();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<AiUsage> getUsage() async {
    try {
      final dynamic raw = await _api.getUsage();
      return AiUsage.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<AiPreferences> getPreferences() async {
    try {
      final dynamic raw = await _api.getPreferences();
      return AiPreferences.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<AiPreferences> updatePreferences(String cardStyle) async {
    try {
      final dynamic raw = await _api.updatePreferences(
        <String, dynamic>{'card_style': cardStyle},
      );
      return AiPreferences.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<AiAudioIntro> getAudioIntro(String bookId) async {
    try {
      final dynamic raw = await _api.createAudioIntro(bookId);
      return AiAudioIntro.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  AiRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return AiRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return AiRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: 'AI 서버에 연결할 수 없어요. 잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return AiRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했어요. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
