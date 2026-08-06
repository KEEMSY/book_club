import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/session_agenda.dart';
import 'session_providers.dart';

part 'session_agenda_notifier.g.dart';

/// Fetches the published agenda for [sessionId], if any.
///
/// `null` means the session has no published agenda yet — the detail screen
/// shows an empty state instead of the accordion in that case.
@riverpod
Future<SessionAgenda?> sessionAgenda(SessionAgendaRef ref, String sessionId) {
  return ref.watch(clubSessionRepositoryProvider).getAgenda(sessionId);
}
