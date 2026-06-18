import 'package:dio/dio.dart';

import '../domain/highlight_explore.dart';
import 'highlight_api.dart';
import 'highlight_models.dart';

/// Typed domain failure surfaced by [HighlightRepository].
///
/// Mirrors `FeedRepositoryException` so notifiers stay framework-agnostic.
class HighlightRepositoryException implements Exception {
  const HighlightRepositoryException({
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
      'HighlightRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Thin wrapper around [HighlightApi] that converts request DTOs to JSON,
/// flattens responses into pure domain types, and maps dio errors into
/// [HighlightRepositoryException].
class HighlightRepository {
  HighlightRepository({required HighlightApi api}) : _api = api;

  final HighlightApi _api;

  Future<void> updateVisibility(
    String highlightId,
    HighlightVisibility visibility,
  ) async {
    await _call(
      () => _api.updateVisibility(
        highlightId,
        UpdateHighlightVisibilityRequest(visibility: visibility).toJson(),
      ),
    );
  }

  Future<void> shareToFeed(String highlightId) async {
    await _call(() => _api.shareToFeed(highlightId));
  }

  Future<List<HighlightExplore>> exploreHighlights({
    String sort = 'recent',
    int limit = 50,
  }) async {
    final List<HighlightExploreDto> dtos = await _call(
      () => _api.exploreHighlights(sort: sort, limit: limit),
    );
    return dtos
        .map((HighlightExploreDto dto) => dto.toDomain())
        .toList(growable: false);
  }

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  HighlightRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return HighlightRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return HighlightRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return HighlightRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
