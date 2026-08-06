import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/club_session_repository.dart';
import '../domain/club_session.dart';

/// Binds the session/agenda/discussion read/write seam (BC-42) to its
/// current implementation.
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

/// Whether the current user may write [session]'s agenda (BC-50 editor
/// entry gate — design doc §5: authorship = host OR presenter).
///
/// TODO(BC-44/45): replace with a real permission check driven by
/// `ClubMember.role` + `session.presenterId` from the club-session API,
/// computed server-side per the design doc. Until then this only recognizes
/// [fakeCurrentUserId] as an author, which is enough to exercise both the
/// allowed and blocked UI paths against [FakeClubSessionRepository]'s seeded
/// data (two of its three demo sessions are "presented" by that id, one by
/// someone else).
final canAuthorAgendaProvider = Provider.family<bool, ClubSession>(
  (ref, session) => session.presenterId == fakeCurrentUserId,
);
