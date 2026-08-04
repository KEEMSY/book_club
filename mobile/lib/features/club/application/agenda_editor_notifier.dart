import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/session_agenda.dart';
import 'session_providers.dart';

part 'agenda_editor_notifier.g.dart';

/// Loads (or lazily creates) the agenda draft for [sessionId] to prefill the
/// BC-50 editor screen.
///
/// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
/// *published* agendas for the read-only detail screen — the editor also
/// needs to resume an unpublished draft, or start from a fresh empty one
/// when the session has no agenda at all yet. The editor invalidates this
/// provider after every mutation (draft save, publish, topic add/remove/
/// reorder) so its view always reflects what the repository holds.
@riverpod
Future<SessionAgenda> agendaForEdit(AgendaForEditRef ref, String sessionId) {
  return ref.watch(clubSessionRepositoryProvider).loadAgendaForEdit(sessionId);
}
