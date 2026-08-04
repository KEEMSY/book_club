import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/topic_comment.dart';
import 'session_providers.dart';

part 'topic_comments_notifier.g.dart';

/// Fetches replies for [topicId].
///
/// BC-49 only uses this to derive a reply count and last-reply preview for
/// the collapsed agenda-topic accordion tile. The full threaded reply UI
/// (composer, nested rendering) is BC-51 — it reuses this same provider.
@riverpod
Future<List<TopicComment>> topicComments(TopicCommentsRef ref, String topicId) {
  return ref.watch(clubSessionRepositoryProvider).listComments(topicId);
}
