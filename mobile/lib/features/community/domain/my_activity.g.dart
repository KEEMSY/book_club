// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityCounts _$ActivityCountsFromJson(Map<String, dynamic> json) =>
    _ActivityCounts(
      reviews: (json['reviews'] as num).toInt(),
      highlights: (json['highlights'] as num).toInt(),
      agendas: (json['agendas'] as num).toInt(),
      clubs: (json['clubs'] as num).toInt(),
      readingBooks: (json['reading_books'] as num).toInt(),
    );

Map<String, dynamic> _$ActivityCountsToJson(_ActivityCounts instance) =>
    <String, dynamic>{
      'reviews': instance.reviews,
      'highlights': instance.highlights,
      'agendas': instance.agendas,
      'clubs': instance.clubs,
      'reading_books': instance.readingBooks,
    };

_ActivityReviewItem _$ActivityReviewItemFromJson(Map<String, dynamic> json) =>
    _ActivityReviewItem(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String?,
      bookCoverUrl: json['book_cover_url'] as String?,
      rating: (json['rating'] as num).toDouble(),
      body: json['body'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ActivityReviewItemToJson(_ActivityReviewItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'book_cover_url': instance.bookCoverUrl,
      'rating': instance.rating,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
    };

_ActivityHighlightItem _$ActivityHighlightItemFromJson(
        Map<String, dynamic> json) =>
    _ActivityHighlightItem(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String?,
      bookCoverUrl: json['book_cover_url'] as String?,
      quoteText: json['quote_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ActivityHighlightItemToJson(
        _ActivityHighlightItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'book_cover_url': instance.bookCoverUrl,
      'quote_text': instance.quoteText,
      'created_at': instance.createdAt.toIso8601String(),
    };

_ActivityAgendaItem _$ActivityAgendaItemFromJson(Map<String, dynamic> json) =>
    _ActivityAgendaItem(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      clubName: json['club_name'] as String,
      sessionId: json['session_id'] as String,
      sessionTitle: json['session_title'] as String,
      status: json['status'] as String,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ActivityAgendaItemToJson(_ActivityAgendaItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'club_id': instance.clubId,
      'club_name': instance.clubName,
      'session_id': instance.sessionId,
      'session_title': instance.sessionTitle,
      'status': instance.status,
      'published_at': instance.publishedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

_ActivityClubItem _$ActivityClubItemFromJson(Map<String, dynamic> json) =>
    _ActivityClubItem(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ActivityClubItemToJson(_ActivityClubItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
    };

_ActivityBookItem _$ActivityBookItemFromJson(Map<String, dynamic> json) =>
    _ActivityBookItem(
      userBookId: json['user_book_id'] as String,
      bookId: json['book_id'] as String,
      title: json['title'] as String,
      coverUrl: json['cover_url'] as String?,
      currentChapter: (json['current_chapter'] as num).toInt(),
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
    );

Map<String, dynamic> _$ActivityBookItemToJson(_ActivityBookItem instance) =>
    <String, dynamic>{
      'user_book_id': instance.userBookId,
      'book_id': instance.bookId,
      'title': instance.title,
      'cover_url': instance.coverUrl,
      'current_chapter': instance.currentChapter,
      'started_at': instance.startedAt?.toIso8601String(),
    };

_MyActivitySummary _$MyActivitySummaryFromJson(Map<String, dynamic> json) =>
    _MyActivitySummary(
      counts: ActivityCounts.fromJson(json['counts'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map(
                  (e) => ActivityReviewItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActivityReviewItem>[],
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) =>
                  ActivityHighlightItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActivityHighlightItem>[],
      agendas: (json['agendas'] as List<dynamic>?)
              ?.map(
                  (e) => ActivityAgendaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActivityAgendaItem>[],
      clubs: (json['clubs'] as List<dynamic>?)
              ?.map((e) => ActivityClubItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActivityClubItem>[],
      readingBooks: (json['reading_books'] as List<dynamic>?)
              ?.map((e) => ActivityBookItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActivityBookItem>[],
    );

Map<String, dynamic> _$MyActivitySummaryToJson(_MyActivitySummary instance) =>
    <String, dynamic>{
      'counts': instance.counts.toJson(),
      'reviews': instance.reviews.map((e) => e.toJson()).toList(),
      'highlights': instance.highlights.map((e) => e.toJson()).toList(),
      'agendas': instance.agendas.map((e) => e.toJson()).toList(),
      'clubs': instance.clubs.map((e) => e.toJson()).toList(),
      'reading_books': instance.readingBooks.map((e) => e.toJson()).toList(),
    };
