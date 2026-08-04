import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/club_session_repository.dart';

/// Binds the session/agenda/discussion read seam (BC-42) to its current
/// implementation.
///
/// TODO(BC-44/45): replace [FakeClubSessionRepository] with a retrofit-backed
/// repository once the `club_sessions` / `session_agendas` / `agenda_topics`
/// REST endpoints exist. This provider override is the only place that needs
/// to change — every notifier/screen below depends on the
/// [ClubSessionRepository] abstraction, never on this concrete class
/// (§3.4 — UI reaches Repositories only through Riverpod providers).
final clubSessionRepositoryProvider = Provider<ClubSessionRepository>((ref) {
  return FakeClubSessionRepository();
});
