import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/event_api.dart';
import '../data/event_repository.dart';
import '../data/location_service.dart';
import '../domain/event.dart';

final eventApiProvider = Provider<EventApi>((ref) {
  return EventApi(ref.watch(dioProvider));
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(eventApiProvider));
});

/// Full detail (event + review summary) for a single event, keyed by id.
/// Invalidate to refresh after a join/leave changes the attendee count.
final eventDetailProvider =
    FutureProvider.autoDispose.family<EventDetail, String>((ref, eventId) {
  return ref.watch(eventRepositoryProvider).getEventDetail(eventId);
});

/// Device-location resolver for the nearby-events origin. Exposed as a provider
/// so tests can override it with a fake that returns fixed coordinates.
final locationServiceProvider = Provider<LocationService>((ref) {
  return const LocationService();
});
