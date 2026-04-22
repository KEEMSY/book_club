import 'package:dio/dio.dart';

import '../domain/book.dart';
import '../domain/book_status.dart';
import '../domain/user_book.dart';
import 'book_api.dart';
import 'book_models.dart';

/// Typed domain failure surfaced to notifiers.
///
/// Mirrors the backend error envelope: a machine [code] (e.g.
/// `BOOK_ALREADY_IN_LIBRARY`) plus a Korean [message] suitable for UI copy.
/// Tests assert on [code] only; user-visible copy is free to change with
/// translations. [statusCode] surfaces the HTTP status for notifiers that
/// need to differentiate 502 (upstream failure) from 5xx other.
class BookRepositoryException implements Exception {
  const BookRepositoryException({
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
      'BookRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Thin wrapper around [BookApi] that:
///   * converts `Map<String, dynamic>` bodies through freezed DTOs,
///   * flattens DTOs into domain entities,
///   * translates dio errors into [BookRepositoryException].
///
/// The repository owns error translation so notifiers can switch on code
/// without depending on dio.
class BookRepository {
  BookRepository(this._api);

  final BookApi _api;

  /// Search books via the backend's Naver/Kakao composite adapter.
  /// Returns the page plus a `hasMore` flag so the caller can paginate.
  Future<BookSearchResult> search({
    required String query,
    int page = 1,
    int size = 20,
  }) async {
    final BookSearchResponse resp = await _call(
      () => _api.search(q: query, page: page, size: size),
    );
    return BookSearchResult(
      items: resp.items.map((dto) => dto.toDomain()).toList(growable: false),
      page: resp.page,
      size: resp.size,
      hasMore: resp.hasMore,
    );
  }

  Future<Book> getById(String id) async {
    final BookDto dto = await _call(() => _api.getById(id));
    return dto.toDomain();
  }

  Future<UserBook> addToLibrary(String bookId) async {
    final UserBookDto dto = await _call(
      () => _api.addToLibrary(AddToLibraryRequest(bookId: bookId).toJson()),
    );
    return dto.toDomain();
  }

  Future<UserBook> updateStatus({
    required String userBookId,
    required BookStatus status,
  }) async {
    final UserBookDto dto = await _call(
      () => _api.updateStatus(
        userBookId,
        UpdateStatusRequest(status: status.wire).toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<UserBook> submitReview({
    required String userBookId,
    required int rating,
    String? oneLineReview,
  }) async {
    final UserBookDto dto = await _call(
      () => _api.submitReview(
        userBookId,
        SubmitReviewRequest(
          rating: rating,
          oneLineReview: oneLineReview,
        ).toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<LibraryPage> listLibrary({
    BookStatus? status,
    String? cursor,
    int limit = 20,
  }) async {
    final LibraryPageDto resp = await _call(
      () => _api.listLibrary(
        status: status?.wire,
        cursor: cursor,
        limit: limit,
      ),
    );
    return LibraryPage(
      items: resp.items.map((dto) => dto.toDomain()).toList(growable: false),
      nextCursor: resp.nextCursor,
    );
  }

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  BookRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return BookRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    // Backend 502 surfaces upstream (Naver/Kakao) failure; the search screen
    // shows a retry prompt instead of the generic network error copy.
    if (status == 502) {
      return BookRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return BookRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}

/// Domain-shaped search result. Kept separate from [BookSearchResponse] so
/// notifiers never reach into the data layer.
class BookSearchResult {
  const BookSearchResult({
    required this.items,
    required this.page,
    required this.size,
    required this.hasMore,
  });

  final List<Book> items;
  final int page;
  final int size;
  final bool hasMore;
}

/// Domain-shaped paginated library page.
class LibraryPage {
  const LibraryPage({required this.items, this.nextCursor});

  final List<UserBook> items;
  final String? nextCursor;
}
