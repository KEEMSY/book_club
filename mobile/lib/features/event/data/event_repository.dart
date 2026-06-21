import 'package:dio/dio.dart';

import '../domain/event.dart';
import 'event_api.dart';

/// Typed domain failure surfaced by [EventRepository].
class EventRepositoryException implements Exception {
  const EventRepositoryException({
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
      'EventRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [EventApi], converts raw JSON to domain objects, and maps Dio errors
/// into typed [EventRepositoryException] values.
class EventRepository {
  EventRepository(this._api);

  final EventApi _api;

  /// Fetches a page of public events near [lat]/[lng] within [radiusKm].
  Future<NearbyEventsResult> getNearbyEvents({
    required double lat,
    required double lng,
    required double radiusKm,
    int page = 1,
  }) async {
    try {
      final dynamic raw = await _api.getNearbyEvents(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
        page: page,
      );
      final Map<String, dynamic> data = raw as Map<String, dynamic>;
      final List<dynamic> items = (data['items'] as List<dynamic>?) ?? const [];
      return NearbyEventsResult(
        items: items
            .map((dynamic e) => Event.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        page: (data['page'] as int?) ?? page,
        hasMore: (data['has_more'] as bool?) ?? false,
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Creates a new meetup and returns the persisted [Event].
  Future<Event> createEvent(EventCreateInput input) async {
    try {
      final dynamic raw = await _api.createEvent(input.toJson());
      return Event.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Joins the waitlist for [eventId]. [EventWaitlistStatus.confirmed] reflects
  /// whether the join fit within capacity.
  Future<EventWaitlistStatus> joinWaitlist(String eventId) async {
    try {
      final dynamic raw = await _api.joinWaitlist(eventId);
      return EventWaitlistStatus.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Removes the current user from [eventId]'s waitlist.
  Future<void> leaveWaitlist(String eventId) async {
    try {
      await _api.leaveWaitlist(eventId);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Posts a [rating] (and optional [body]) review for [eventId].
  Future<EventReview> createReview(
    String eventId, {
    required double rating,
    String? body,
  }) async {
    try {
      final dynamic raw = await _api.createReview(
        eventId,
        <String, dynamic>{'rating': rating, 'body': body},
      );
      return EventReview.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Fetches reviews and the aggregate rating for [eventId].
  Future<EventReviewsResult> getReviews(String eventId) async {
    try {
      final dynamic raw = await _api.getReviews(eventId);
      final Map<String, dynamic> data = raw as Map<String, dynamic>;
      final List<dynamic> items = (data['items'] as List<dynamic>?) ?? const [];
      return EventReviewsResult(
        items: items
            .map((dynamic e) => EventReview.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        averageRating: (data['average_rating'] as num?)?.toDouble(),
        count: (data['count'] as int?) ?? items.length,
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  EventRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return EventRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return EventRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return EventRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
