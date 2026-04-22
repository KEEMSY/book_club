import 'package:book_club/features/book/data/book_repository.dart';
import 'package:book_club/features/book/domain/book.dart';
import 'package:book_club/features/book/domain/book_status.dart';
import 'package:book_club/features/book/domain/user_book.dart';

/// Fake [BookRepository] that lets tests queue deterministic responses.
///
/// Each call is logged so assertions can check sequencing / pagination
/// behaviour. Queues pop one result per call; when empty we fall back to
/// [defaultSearchResult] / [defaultLibraryPage] so tests that only care
/// about "any 2nd page" can skip the setup.
class FakeBookRepository implements BookRepository {
  FakeBookRepository();

  // -- Search --
  final List<BookSearchResult> searchQueue = <BookSearchResult>[];
  final List<Object> searchErrors = <Object>[];
  final List<({String query, int page, int size})> searchCalls =
      <({String query, int page, int size})>[];
  BookSearchResult defaultSearchResult = const BookSearchResult(
    items: <Book>[],
    page: 1,
    size: 20,
    hasMore: false,
  );

  // -- Detail --
  Book? getByIdResult;
  Object? getByIdError;
  final List<String> getByIdCalls = <String>[];

  // -- Add --
  UserBook? addToLibraryResult;
  Object? addToLibraryError;
  final List<String> addToLibraryCalls = <String>[];

  // -- Review --
  UserBook? submitReviewResult;
  Object? submitReviewError;
  final List<({String userBookId, int rating, String? review})>
      submitReviewCalls = <({String userBookId, int rating, String? review})>[];

  // -- Update status --
  UserBook? updateStatusResult;
  final List<({String userBookId, BookStatus status})> updateStatusCalls =
      <({String userBookId, BookStatus status})>[];

  // -- Library --
  final List<LibraryPage> libraryQueue = <LibraryPage>[];
  final List<Object> libraryErrors = <Object>[];
  final List<({BookStatus? status, String? cursor, int limit})> libraryCalls =
      <({BookStatus? status, String? cursor, int limit})>[];
  LibraryPage defaultLibraryPage =
      const LibraryPage(items: <UserBook>[], nextCursor: null);

  @override
  Future<BookSearchResult> search({
    required String query,
    int page = 1,
    int size = 20,
  }) async {
    searchCalls.add((query: query, page: page, size: size));
    if (searchErrors.isNotEmpty) {
      throw searchErrors.removeAt(0);
    }
    if (searchQueue.isNotEmpty) {
      return searchQueue.removeAt(0);
    }
    return defaultSearchResult;
  }

  @override
  Future<Book> getById(String id) async {
    getByIdCalls.add(id);
    if (getByIdError != null) {
      throw getByIdError!;
    }
    if (getByIdResult == null) {
      throw const BookRepositoryException(
        code: 'NOT_SET',
        message: 'FakeBookRepository.getByIdResult is unset',
      );
    }
    return getByIdResult!;
  }

  @override
  Future<UserBook> addToLibrary(String bookId) async {
    addToLibraryCalls.add(bookId);
    if (addToLibraryError != null) {
      throw addToLibraryError!;
    }
    if (addToLibraryResult == null) {
      throw const BookRepositoryException(
        code: 'NOT_SET',
        message: 'FakeBookRepository.addToLibraryResult is unset',
      );
    }
    return addToLibraryResult!;
  }

  @override
  Future<UserBook> updateStatus({
    required String userBookId,
    required BookStatus status,
  }) async {
    updateStatusCalls.add((userBookId: userBookId, status: status));
    return updateStatusResult!;
  }

  @override
  Future<UserBook> submitReview({
    required String userBookId,
    required int rating,
    String? oneLineReview,
  }) async {
    submitReviewCalls
        .add((userBookId: userBookId, rating: rating, review: oneLineReview));
    if (submitReviewError != null) {
      throw submitReviewError!;
    }
    return submitReviewResult!;
  }

  @override
  Future<LibraryPage> listLibrary({
    BookStatus? status,
    String? cursor,
    int limit = 20,
  }) async {
    libraryCalls.add((status: status, cursor: cursor, limit: limit));
    if (libraryErrors.isNotEmpty) {
      throw libraryErrors.removeAt(0);
    }
    if (libraryQueue.isNotEmpty) {
      return libraryQueue.removeAt(0);
    }
    return defaultLibraryPage;
  }
}

Book buildBook({
  String id = 'book-1',
  String title = '달러구트 꿈 백화점',
  String author = '이미예',
  String publisher = '팩토리나인',
  String isbn13 = '9791195731305',
  String? coverUrl,
  String? description,
}) {
  return Book(
    id: id,
    isbn13: isbn13,
    title: title,
    author: author,
    publisher: publisher,
    coverUrl: coverUrl,
    description: description,
  );
}

UserBook buildUserBook({
  String id = 'user-book-1',
  Book? book,
  BookStatus status = BookStatus.reading,
  DateTime? startedAt,
  int? rating,
  String? oneLineReview,
}) {
  return UserBook(
    id: id,
    book: book ?? buildBook(),
    status: status,
    startedAt: startedAt ?? DateTime.utc(2026, 4, 20, 12),
    rating: rating,
    oneLineReview: oneLineReview,
  );
}

BookSearchResult buildSearchResult({
  List<Book>? items,
  int page = 1,
  int size = 20,
  bool hasMore = false,
}) {
  return BookSearchResult(
    items: items ?? <Book>[buildBook()],
    page: page,
    size: size,
    hasMore: hasMore,
  );
}
