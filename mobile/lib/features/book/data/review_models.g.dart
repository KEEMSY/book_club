// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) => _ReviewDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookId: json['book_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      body: json['body'] as String?,
      reportCount: (json['report_count'] as num?)?.toInt() ?? 0,
      authorNickname: json['author_nickname'] as String?,
      authorProfileImageUrl: json['author_profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ReviewDtoToJson(_ReviewDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'book_id': instance.bookId,
      'rating': instance.rating,
      'body': instance.body,
      'report_count': instance.reportCount,
      'author_nickname': instance.authorNickname,
      'author_profile_image_url': instance.authorProfileImageUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_BookReviewSummaryDto _$BookReviewSummaryDtoFromJson(
        Map<String, dynamic> json) =>
    _BookReviewSummaryDto(
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
      distribution: (json['distribution'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReviewDto>[],
    );

Map<String, dynamic> _$BookReviewSummaryDtoToJson(
        _BookReviewSummaryDto instance) =>
    <String, dynamic>{
      'average_rating': instance.averageRating,
      'rating_count': instance.ratingCount,
      'distribution': instance.distribution,
      'reviews': instance.reviews.map((e) => e.toJson()).toList(),
    };

_CreateReviewRequest _$CreateReviewRequestFromJson(Map<String, dynamic> json) =>
    _CreateReviewRequest(
      rating: (json['rating'] as num).toDouble(),
      body: json['body'] as String?,
    );

Map<String, dynamic> _$CreateReviewRequestToJson(
        _CreateReviewRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'body': instance.body,
    };

_UpdateReviewRequest _$UpdateReviewRequestFromJson(Map<String, dynamic> json) =>
    _UpdateReviewRequest(
      rating: (json['rating'] as num?)?.toDouble(),
      body: json['body'] as String?,
    );

Map<String, dynamic> _$UpdateReviewRequestToJson(
        _UpdateReviewRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'body': instance.body,
    };
