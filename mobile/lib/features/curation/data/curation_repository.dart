import 'package:dio/dio.dart';

import '../domain/curation_card.dart';
import 'curation_api.dart';

/// Typed domain failure surfaced by [CurationRepository].
class CurationRepositoryException implements Exception {
  const CurationRepositoryException({
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
      'CurationRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [CurationApi], converts raw JSON to [CurationCard] domain objects,
/// and maps Dio errors to typed [CurationRepositoryException] values.
class CurationRepository {
  CurationRepository(this._api);

  final CurationApi _api;

  /// Returns the first curation card for [bookId], or `null` when the book
  /// has no cards yet (404 is treated as an empty result, not an error).
  Future<CurationCard?> getFirstCard(String bookId) async {
    try {
      final dynamic raw = await _api.getFirstCard(bookId);
      if (raw == null) return null;
      return CurationCard.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      // 404 = no cards generated yet — surface as null rather than an error.
      if (e.response?.statusCode == 404) return null;
      throw _fromDio(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  CurationRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return CurationRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return CurationRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return CurationRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
