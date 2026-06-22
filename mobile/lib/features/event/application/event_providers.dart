import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/event_api.dart';
import '../data/event_repository.dart';
import '../data/location_service.dart';

final eventApiProvider = Provider<EventApi>((ref) {
  return EventApi(ref.watch(dioProvider));
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(eventApiProvider));
});

/// Device-location resolver for the nearby-events origin. Exposed as a provider
/// so tests can override it with a fake that returns fixed coordinates.
final locationServiceProvider = Provider<LocationService>((ref) {
  return const LocationService();
});
