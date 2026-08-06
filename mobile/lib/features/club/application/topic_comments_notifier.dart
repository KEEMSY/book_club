import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/topic_comment.dart';
import 'session_providers.dart';

/// Key identifying one topic's comment thread — the real endpoint
/// (`GET .../agendas/{agendaId}/topics/{topicId}/comments`) needs the full
/// path context, not just a topic id.
typedef TopicCommentsKey = ({
  String clubId,
  String sessionId,
  String agendaId,
  String topicId,
});

/// Fetches replies for [TopicCommentsKey.topicId].
///
/// BC-49 only uses this to derive a reply count and last-reply preview for
/// the collapsed agenda-topic accordion tile. The full threaded reply UI
/// (composer, nested rendering) is BC-51 — it reuses this same provider.
final topicCommentsProvider = FutureProvider.autoDispose
    .family<List<TopicComment>, TopicCommentsKey>((ref, key) {
  return ref.watch(clubSessionRepositoryProvider).listComments(
        clubId: key.clubId,
        sessionId: key.sessionId,
        agendaId: key.agendaId,
        topicId: key.topicId,
      );
});
