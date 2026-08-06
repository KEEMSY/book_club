import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/session_agenda.dart';
import 'session_providers.dart';

/// Fetches the published agenda for (clubId, sessionId), if any.
///
/// `null` means the session has no published agenda yet — the detail screen
/// shows an empty state instead of the accordion in that case. Keyed by a
/// record (not a plain `@riverpod` family) because the real endpoint needs
/// both ids — see `ClubSessionRepository`'s doc comment.
final sessionAgendaProvider = FutureProvider.autoDispose
    .family<SessionAgenda?, ({String clubId, String sessionId})>((ref, key) {
  return ref
      .watch(clubSessionRepositoryProvider)
      .getAgenda(clubId: key.clubId, sessionId: key.sessionId);
});
