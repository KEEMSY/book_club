// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookDto _$BookDtoFromJson(Map<String, dynamic> json) => _BookDto(
      id: json['id'] as String,
      isbn13: json['isbn13'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      coverUrl: json['cover_url'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BookDtoToJson(_BookDto instance) => <String, dynamic>{
      'id': instance.id,
      'isbn13': instance.isbn13,
      'title': instance.title,
      'author': instance.author,
      'publisher': instance.publisher,
      'cover_url': instance.coverUrl,
      'description': instance.description,
    };

_UserBookDto _$UserBookDtoFromJson(Map<String, dynamic> json) => _UserBookDto(
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
      currentChapter: (json['current_chapter'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserBookDtoToJson(_UserBookDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'book': instance.book.toJson(),
      'status': instance.status,
      'started_at': instance.startedAt?.toIso8601String(),
      'finished_at': instance.finishedAt?.toIso8601String(),
      'rating': instance.rating,
      'one_line_review': instance.oneLineReview,
      'current_chapter': instance.currentChapter,
    };

_BookSearchResponse _$BookSearchResponseFromJson(Map<String, dynamic> json) =>
    _BookSearchResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => BookDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$BookSearchResponseToJson(_BookSearchResponse instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'page': instance.page,
      'size': instance.size,
      'has_more': instance.hasMore,
    };

_LibraryPageDto _$LibraryPageDtoFromJson(Map<String, dynamic> json) =>
    _LibraryPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => UserBookDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$LibraryPageDtoToJson(_LibraryPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_AddToLibraryRequest _$AddToLibraryRequestFromJson(Map<String, dynamic> json) =>
    _AddToLibraryRequest(
      bookId: json['book_id'] as String,
      status: json['status'] as String? ?? 'reading',
    );

Map<String, dynamic> _$AddToLibraryRequestToJson(
        _AddToLibraryRequest instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'status': instance.status,
    };

_UpdateStatusRequest _$UpdateStatusRequestFromJson(Map<String, dynamic> json) =>
    _UpdateStatusRequest(
      status: json['status'] as String,
    );

Map<String, dynamic> _$UpdateStatusRequestToJson(
        _UpdateStatusRequest instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

_DiscoverSectionDto _$DiscoverSectionDtoFromJson(Map<String, dynamic> json) =>
    _DiscoverSectionDto(
      id: json['id'] as String,
      title: json['title'] as String,
      books: (json['books'] as List<dynamic>)
          .map((e) => BookDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiscoverSectionDtoToJson(_DiscoverSectionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'books': instance.books.map((e) => e.toJson()).toList(),
    };

_DiscoverResponseDto _$DiscoverResponseDtoFromJson(Map<String, dynamic> json) =>
    _DiscoverResponseDto(
      sections: (json['sections'] as List<dynamic>)
          .map((e) => DiscoverSectionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiscoverResponseDtoToJson(
        _DiscoverResponseDto instance) =>
    <String, dynamic>{
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };
