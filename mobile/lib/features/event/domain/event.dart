import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// A location-based offline meetup ("번개 모임").
///
/// One model parses two backend shapes: `GET /events/nearby` items carry a
/// server-computed [distanceKm], while `POST /events` echoes the created event
/// without it. [distanceKm] defaults to `0` so both payloads deserialize.
@freezed
abstract class Event with _$Event {
  const factory Event({
    required String id,
    String? creatorId,
    required String title,
    String? description,
    String? address,
    double? lat,
    double? lng,
    required DateTime eventAt,
    int? maxAttendees,
    required bool isPublic,
    String? clubId,
    String? bookId,
    String? category,
    @Default(0) int joinedCount,
    @Default(0) double distanceKm,
    required DateTime createdAt,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

/// Result of joining a waitlist. [confirmed] is true when the join lands within
/// the event's capacity; otherwise the user holds [position] in the queue.
@freezed
abstract class EventWaitlistStatus with _$EventWaitlistStatus {
  const factory EventWaitlistStatus({
    required String eventId,
    required int position,
    required bool confirmed,
  }) = _EventWaitlistStatus;

  factory EventWaitlistStatus.fromJson(Map<String, dynamic> json) =>
      _$EventWaitlistStatusFromJson(json);
}

/// A post-event review left by an attendee.
@freezed
abstract class EventReview with _$EventReview {
  const factory EventReview({
    required String id,
    required String eventId,
    required String reviewerId,
    required double rating,
    String? body,
    required DateTime createdAt,
  }) = _EventReview;

  factory EventReview.fromJson(Map<String, dynamic> json) =>
      _$EventReviewFromJson(json);
}

/// Plain wrapper for a page of nearby events. Not JSON-serialized — the
/// repository maps the raw envelope into this and hydrates [items] itself.
class NearbyEventsResult {
  const NearbyEventsResult({
    required this.items,
    required this.page,
    required this.hasMore,
  });

  final List<Event> items;
  final int page;
  final bool hasMore;
}

/// Full event detail: the event plus its review summary, as returned by
/// `GET /events/{id}`. Not JSON-serialized — the repository hydrates it.
class EventDetail {
  const EventDetail({required this.event, required this.reviews});

  final Event event;
  final EventReviewsResult reviews;
}

/// Plain wrapper for an event's review list and aggregate rating.
class EventReviewsResult {
  const EventReviewsResult({
    required this.items,
    required this.count,
    this.averageRating,
  });

  final List<EventReview> items;
  final int count;
  final double? averageRating;
}

/// Plain (non-freezed) payload for `POST /events`. Holds only the create
/// fields and serializes to the snake_case body the backend expects.
class EventCreateInput {
  const EventCreateInput({
    required this.title,
    required this.eventAt,
    this.description,
    this.lat,
    this.lng,
    this.address,
    this.maxAttendees,
    this.isPublic = true,
    this.clubId,
    this.bookId,
    this.category,
  });

  final String title;
  final DateTime eventAt;
  final String? description;
  final double? lat;
  final double? lng;
  final String? address;
  final int? maxAttendees;
  final bool isPublic;
  final String? clubId;
  final String? bookId;
  final String? category;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'description': description,
        'lat': lat,
        'lng': lng,
        'address': address,
        'event_at': eventAt.toUtc().toIso8601String(),
        'max_attendees': maxAttendees,
        'is_public': isPublic,
        'club_id': clubId,
        'book_id': bookId,
        'category': category,
      };
}
