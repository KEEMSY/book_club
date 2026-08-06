import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/session_agenda.dart';
import 'session_providers.dart';

/// Loads (or lazily creates) the agenda draft for (clubId, sessionId) to
/// prefill the BC-50 editor screen.
///
/// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
/// *published* agendas for the read-only detail screen — the editor also
/// needs to resume an unpublished draft, or start from a fresh empty one
/// when the session has no agenda at all yet. The editor invalidates this
/// provider after every mutation (draft save, publish, topic add/remove/
/// reorder) so its view always reflects what the repository holds.
final agendaForEditProvider = FutureProvider.autoDispose
    .family<SessionAgenda, ({String clubId, String sessionId})>((ref, key) {
  return ref
      .watch(clubSessionRepositoryProvider)
      .loadAgendaForEdit(clubId: key.clubId, sessionId: key.sessionId);
});
