import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/book.dart';
import '../domain/book_status.dart';
import '../domain/user_book.dart';

part 'book_models.freezed.dart';
part 'book_models.g.dart';

/// Data-layer mirror of the backend `BookPublic` payload. [provider] stays
/// as strings here; conversion to domain enums happens at the repository
/// boundary via [BookDto.toDomain].
@freezed
class BookDto with _$BookDto {
  const BookDto._();

  const factory BookDto({
    required String id,
    required String isbn13,
    required String title,
    required String author,
    required String publisher,
    String? coverUrl,
    String? description,
  }) = _BookDto;

  factory BookDto.fromJson(Map<String, dynamic> json) =>
      _$BookDtoFromJson(json);

  Book toDomain() {
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
}

/// Data-layer mirror of `UserBookPublic`. Backend keeps [status] as a
/// snake_case string (`reading`, `completed`, etc.); we parse into the Dart
/// enum on the domain-side via [UserBookDto.toDomain].
@freezed
class UserBookDto with _$UserBookDto {
  const UserBookDto._();

  const factory UserBookDto({
    required String id,
    required BookDto book,
    required String status,
    required DateTime startedAt,
    DateTime? finishedAt,
    int? rating,
    String? oneLineReview,
  }) = _UserBookDto;

  factory UserBookDto.fromJson(Map<String, dynamic> json) =>
      _$UserBookDtoFromJson(json);

  UserBook toDomain() {
    return UserBook(
      id: id,
      book: book.toDomain(),
      status: BookStatus.fromWire(status),
      startedAt: startedAt,
      finishedAt: finishedAt,
      rating: rating,
      oneLineReview: oneLineReview,
    );
  }
}

/// `GET /books/search` response envelope.
@freezed
class BookSearchResponse with _$BookSearchResponse {
  const factory BookSearchResponse({
    required List<BookDto> items,
    required int page,
    required int size,
    required bool hasMore,
  }) = _BookSearchResponse;

  factory BookSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$BookSearchResponseFromJson(json);
}

/// `GET /me/library` cursor-paginated envelope. [nextCursor] is null when
/// the server has no more rows — the client stops requesting at that point.
@freezed
class LibraryPageDto with _$LibraryPageDto {
  const factory LibraryPageDto({
    required List<UserBookDto> items,
    String? nextCursor,
  }) = _LibraryPageDto;

  factory LibraryPageDto.fromJson(Map<String, dynamic> json) =>
      _$LibraryPageDtoFromJson(json);
}

/// Request body for `POST /me/library`.
@freezed
class AddToLibraryRequest with _$AddToLibraryRequest {
  const factory AddToLibraryRequest({
    required String bookId,
  }) = _AddToLibraryRequest;

  factory AddToLibraryRequest.fromJson(Map<String, dynamic> json) =>
      _$AddToLibraryRequestFromJson(json);
}

/// Request body for `PATCH /me/library/{user_book_id}`. Status is serialised
/// as a raw string here so we can continue to default `field_rename: snake`
/// without a custom converter.
@freezed
class UpdateStatusRequest with _$UpdateStatusRequest {
  const factory UpdateStatusRequest({
    required String status,
  }) = _UpdateStatusRequest;

  factory UpdateStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateStatusRequestFromJson(json);
}

/// Request body for `POST /me/library/{user_book_id}/review`.
/// Backend validates rating (1..5) and review length (<=200). [oneLineReview]
/// stays nullable because the review field is optional — the backend accepts
/// a rating-only submission and auto-transitions status to completed.
@freezed
class SubmitReviewRequest with _$SubmitReviewRequest {
  const factory SubmitReviewRequest({
    required int rating,
    String? oneLineReview,
  }) = _SubmitReviewRequest;

  factory SubmitReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitReviewRequestFromJson(json);
}
