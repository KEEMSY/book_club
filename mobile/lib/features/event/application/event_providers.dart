import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/event_api.dart';
import '../data/event_repository.dart';

final eventApiProvider = Provider<EventApi>((ref) {
  return EventApi(ref.watch(dioProvider));
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(eventApiProvider));
});
