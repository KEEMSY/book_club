import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../data/club_session_api.dart';
import '../data/club_session_repository.dart';
import '../data/club_session_repository_impl.dart';
import '../domain/club_session.dart';
import '../domain/topic_comment.dart';
import 'club_providers.dart';

/// Binds the session/agenda/discussion read/write seam (BC-42) to its
/// current implementation — [RestClubSessionRepository] against the real
/// BC-44/45/46/53 REST endpoints (BC-60). Every notifier/screen depends on
/// the [ClubSessionRepository] abstraction, never on this concrete class
/// (§3.4 — UI reaches Repositories only through Riverpod providers); widget
/// tests override this provider with [FakeClubSessionRepository] instead.
final clubSessionRepositoryProvider = Provider<ClubSessionRepository>((ref) {
  return RestClubSessionRepository(ClubSessionApi(ref.watch(dioProvider)));
});

/// Resolves a single [ClubSession] by (clubId, sessionId) — the deep-link
/// seam BC-52 wires for feed-card taps and push-notification routing, where
/// only ids are known (no [ClubSession] object to pass via router `extra`).
/// Both ids are required because the real endpoint
/// (`GET /clubs/{club_id}/sessions/{session_id}`) nests under club — there is
/// no id-only lookup on the backend.
final sessionByIdProvider = FutureProvider.autoDispose
    .family<ClubSession, ({String clubId, String sessionId})>((ref, key) {
  return ref
      .watch(clubSessionRepositoryProvider)
      .getSession(clubId: key.clubId, sessionId: key.sessionId);
});

String? _currentUserId(Ref ref) {
  final auth = ref.watch(authNotifierProvider);
  return switch (auth) {
    Authenticated(:final user) => user.id,
    _ => null,
  };
}

/// Whether the current user may write [session]'s agenda (BC-50 editor
/// entry gate — design doc §5: authorship = host OR presenter).
///
/// Real permission check (BC-60): host = the club's `owner_id`
/// ([clubByIdProvider]), presenter = [ClubSession.presenterId]. Resolves to
/// `false` while the club is still loading/unresolved rather than blocking
/// the build on a `FutureProvider` — the dependent screens rebuild
/// automatically once [clubByIdProvider] settles.
final canAuthorAgendaProvider = Provider.family<bool, ClubSession>(
  (ref, session) {
    final currentUserId = _currentUserId(ref);
    if (currentUserId == null) return false;
    if (session.presenterId == currentUserId) return true;
    final club = ref.watch(clubByIdProvider(session.clubId)).valueOrNull;
    return club?.ownerId == currentUserId;
  },
);

/// Whether the current user may post a reply anywhere in [clubId]'s
/// discussion threads (BC-51 composer gate — design doc §5: club members).
///
/// Real permission check (BC-60): membership is derived from
/// [myClubsProvider] (the same "clubs I've joined" list the home tab uses)
/// rather than a dedicated membership-lookup endpoint, since one doesn't
/// exist for a single club+user pair.
final canReplyToTopicProvider = Provider.family<bool, String>((ref, clubId) {
  if (_currentUserId(ref) == null) return false;
  final clubs = ref.watch(myClubsProvider).valueOrNull;
  return clubs?.any((c) => c.id == clubId) ?? false;
});

/// Whether the current user may edit/delete [comment] inside [clubId] (BC-51
/// — design doc §5: own reply OR host).
final canModerateCommentProvider =
    Provider.family<bool, ({TopicComment comment, String clubId})>((ref, args) {
  final currentUserId = _currentUserId(ref);
  if (currentUserId == null) return false;
  if (args.comment.authorId == currentUserId) return true;
  final club = ref.watch(clubByIdProvider(args.clubId)).valueOrNull;
  return club?.ownerId == currentUserId;
});
