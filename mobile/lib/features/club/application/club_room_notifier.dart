import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../application/club_providers.dart';
import '../domain/club_room.dart';

part 'club_room_notifier.g.dart';

/// Fetches the list of chapter-gated chat rooms for [clubId].
///
/// Auto-disposed and family-keyed by club ID so multiple club detail screens
/// can be open simultaneously without sharing state.
@riverpod
Future<List<ClubRoom>> clubRooms(ClubRoomsRef ref, String clubId) {
  return ref.watch(clubRepositoryProvider).listRooms(clubId);
}
