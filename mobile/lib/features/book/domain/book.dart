import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

/// Domain-layer projection of the backend `BookPublic` DTO.
///
/// Kept separate from [BookDto] (data layer) so UI widgets never depend on
/// raw wire types. [coverUrl] stays nullable — the `BookCover` widget falls
/// back to a Rausch-tinted placeholder when the upstream catalog returns no
/// cover (Naver/Kakao regularly omits it for indie publishers).
@freezed
class Book with _$Book {
  const factory Book({
    required String id,
    required String isbn13,
    required String title,
    required String author,
    required String publisher,
    String? coverUrl,
    String? description,
  }) = _Book;
}
