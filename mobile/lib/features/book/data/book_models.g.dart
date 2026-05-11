// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookDtoImpl _$$BookDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookDtoImpl(
      id: json['id'] as String,
      isbn13: json['isbn13'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: (json['publisher'] as String?) ?? '',
      coverUrl: json['cover_url'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$BookDtoImplToJson(_$BookDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isbn13': instance.isbn13,
      'title': instance.title,
      'author': instance.author,
      'publisher': instance.publisher,
      'cover_url': instance.coverUrl,
      'description': instance.description,
    };

_$UserBookDtoImpl _$$UserBookDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserBookDtoImpl(
      id: json['id'] as String,
      book: BookDto.fromJson(json['book'] as Map<String, dynamic>),
      status: json['status'] as String,
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      finishedAt: json['finished_at'] == null
          ? null
          : DateTime.parse(json['finished_at'] as String),
      rating: (json['rating'] as num?)?.toInt(),
      oneLineReview: json['one_line_review'] as String?,
    );

Map<String, dynamic> _$$UserBookDtoImplToJson(_$UserBookDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'book': instance.book.toJson(),
      'status': instance.status,
      'started_at': instance.startedAt?.toIso8601String(),
      'finished_at': instance.finishedAt?.toIso8601String(),
      'rating': instance.rating,
      'one_line_review': instance.oneLineReview,
    };

_$BookSearchResponseImpl _$$BookSearchResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BookSearchResponseImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => BookDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$$BookSearchResponseImplToJson(
        _$BookSearchResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'page': instance.page,
      'size': instance.size,
      'has_more': instance.hasMore,
    };

_$LibraryPageDtoImpl _$$LibraryPageDtoImplFromJson(Map<String, dynamic> json) =>
    _$LibraryPageDtoImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => UserBookDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$$LibraryPageDtoImplToJson(
        _$LibraryPageDtoImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_$AddToLibraryRequestImpl _$$AddToLibraryRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AddToLibraryRequestImpl(
      bookId: json['book_id'] as String,
      status: json['status'] as String? ?? 'reading',
    );

Map<String, dynamic> _$$AddToLibraryRequestImplToJson(
        _$AddToLibraryRequestImpl instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'status': instance.status,
    };

_$UpdateStatusRequestImpl _$$UpdateStatusRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateStatusRequestImpl(
      status: json['status'] as String,
    );

Map<String, dynamic> _$$UpdateStatusRequestImplToJson(
        _$UpdateStatusRequestImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

_$DiscoverSectionDtoImpl _$$DiscoverSectionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DiscoverSectionDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      books: (json['books'] as List<dynamic>)
          .map((e) => BookDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DiscoverSectionDtoImplToJson(
        _$DiscoverSectionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'books': instance.books.map((e) => e.toJson()).toList(),
    };

_$DiscoverResponseDtoImpl _$$DiscoverResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DiscoverResponseDtoImpl(
      sections: (json['sections'] as List<dynamic>)
          .map((e) => DiscoverSectionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DiscoverResponseDtoImplToJson(
        _$DiscoverResponseDtoImpl instance) =>
    <String, dynamic>{
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };

_$SubmitReviewRequestImpl _$$SubmitReviewRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SubmitReviewRequestImpl(
      rating: (json['rating'] as num).toInt(),
      oneLineReview: json['one_line_review'] as String?,
    );

Map<String, dynamic> _$$SubmitReviewRequestImplToJson(
        _$SubmitReviewRequestImpl instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'one_line_review': instance.oneLineReview,
    };
