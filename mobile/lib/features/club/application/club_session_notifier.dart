import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/club_session.dart';
import 'session_providers.dart';

part 'club_session_notifier.g.dart';

/// Fetches all sessions ("회차") for [clubId].
///
/// Auto-disposed and family-keyed by club ID, same convention as
/// `clubRoomsProvider`. The list screen groups the result by
/// [ClubSession.bookId] client-side.
@riverpod
Future<List<ClubSession>> clubSessions(ClubSessionsRef ref, String clubId) {
  return ref.watch(clubSessionRepositoryProvider).listSessions(clubId);
}
