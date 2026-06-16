import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_reaction.freezed.dart';
part 'feed_reaction.g.dart';

/// A single emoji reaction left on a [FeedEvent].
///
/// Distinct from [ReactionType] (the book-post reaction enum): feed-event
/// reactions are free-form emoji strings (`❤️`, `🔥`, etc.) rather than a
/// closed server-side enum. The server returns the emoji codepoint as-is.
@freezed
abstract class FeedReaction with _$FeedReaction {
  const factory FeedReaction({
    required String id,
    required String emoji,
    required String userId,
    required DateTime createdAt,
  }) = _FeedReaction;

  factory FeedReaction.fromJson(Map<String, dynamic> json) =>
      _$FeedReactionFromJson(json);
}
