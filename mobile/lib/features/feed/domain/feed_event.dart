import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_reaction.dart';

part 'feed_event.freezed.dart';

/// Domain projection of `FeedEventWithReactions` returned by `GET /feed` and
/// `GET /feed/following`.
///
/// [reactions] is the full list of reaction objects the event has received.
/// [commentCount] drives the comment-count chip on the event card without
/// loading the full thread.
@freezed
abstract class FeedEvent with _$FeedEvent {
  const factory FeedEvent({
    required String id,
    required String userId,
    required String eventType,
    required Map<String, dynamic> eventMetadata,
    required List<FeedReaction> reactions,
    required int commentCount,
    required DateTime createdAt,
  }) = _FeedEvent;
}

/// Cursor-paginated envelope returned by `GET /feed` and `GET /feed/following`.
@freezed
abstract class FeedEventPage with _$FeedEventPage {
  const factory FeedEventPage({
    required List<FeedEvent> items,
    String? cursor,
  }) = _FeedEventPage;
}

/// Result of `POST /feed/{event_id}/reactions`. [added] is true when the
/// emoji was added; false when it was removed (toggle semantics).
@freezed
abstract class FeedReactionToggleResult with _$FeedReactionToggleResult {
  const factory FeedReactionToggleResult({
    required bool added,
    required String emoji,
    required int reactionCount,
  }) = _FeedReactionToggleResult;
}
