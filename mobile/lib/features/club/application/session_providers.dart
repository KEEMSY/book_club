import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/club_session_repository.dart';
import '../domain/club_session.dart';
import '../domain/topic_comment.dart';

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

/// Whether the current user may post a reply anywhere in a topic's
/// discussion thread (BC-51 composer gate — design doc §5: club members).
///
/// TODO(BC-46): replace with a real `ClubMember` membership check driven by
/// the club-membership API. Always `true` in the fake — there is no
/// non-member viewer to model yet in [FakeClubSessionRepository], so there's
/// no "blocked" UI path this gate can currently exercise.
final canReplyToTopicProvider = Provider<bool>((ref) => true);

/// Whether the current user may edit/delete [comment] (BC-51 — design doc
/// §5: own reply OR host).
///
/// TODO(BC-46): replace with a real permission check combining
/// `comment.authorId == currentUserId` OR `ClubMember.role == owner`,
/// computed server-side. Until then this fake only recognizes authorship —
/// host-moderation of someone else's reply isn't modeled — which is enough
/// to exercise both the shown and hidden action paths against
/// [FakeClubSessionRepository]'s seeded comments (authored by several
/// different fake users).
final canModerateCommentProvider = Provider.family<bool, TopicComment>(
  (ref, comment) => comment.authorId == fakeCurrentUserId,
);
