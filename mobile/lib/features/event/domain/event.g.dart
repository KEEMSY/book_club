// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      eventAt: DateTime.parse(json['event_at'] as String),
      maxAttendees: (json['max_attendees'] as num?)?.toInt(),
      isPublic: json['is_public'] as bool,
      clubId: json['club_id'] as String?,
      bookId: json['book_id'] as String?,
      category: json['category'] as String?,
      joinedCount: (json['joined_count'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creatorId,
      'title': instance.title,
      'description': instance.description,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'event_at': instance.eventAt.toIso8601String(),
      'max_attendees': instance.maxAttendees,
      'is_public': instance.isPublic,
      'club_id': instance.clubId,
      'book_id': instance.bookId,
      'category': instance.category,
      'joined_count': instance.joinedCount,
      'distance_km': instance.distanceKm,
      'created_at': instance.createdAt.toIso8601String(),
    };

_EventWaitlistStatus _$EventWaitlistStatusFromJson(Map<String, dynamic> json) =>
    _EventWaitlistStatus(
      eventId: json['event_id'] as String,
      position: (json['position'] as num).toInt(),
      confirmed: json['confirmed'] as bool,
    );

Map<String, dynamic> _$EventWaitlistStatusToJson(
        _EventWaitlistStatus instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'position': instance.position,
      'confirmed': instance.confirmed,
    };

_EventReview _$EventReviewFromJson(Map<String, dynamic> json) => _EventReview(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      body: json['body'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EventReviewToJson(_EventReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event_id': instance.eventId,
      'reviewer_id': instance.reviewerId,
      'rating': instance.rating,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
    };
