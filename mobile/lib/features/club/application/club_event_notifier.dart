import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'club_providers.dart';
import '../domain/club_event.dart';

part 'club_event_notifier.g.dart';

@riverpod
Future<List<ClubEvent>> clubEvents(ClubEventsRef ref, String clubId) {
  return ref.watch(clubRepositoryProvider).listEvents(clubId);
}
