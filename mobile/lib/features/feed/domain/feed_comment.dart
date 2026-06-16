import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_comment.freezed.dart';
part 'feed_comment.g.dart';

/// A comment thread entry attached to a [FeedEvent].
///
/// The backend returns a 2-level tree: root comments carry a non-empty
/// [replies] list; replies have an empty [replies] and carry a [parentId].
/// The UI renders roots flush-left and replies with a 28 dp indent.
@freezed
abstract class FeedComment with _$FeedComment {
  const factory FeedComment({
    required String id,
    required String body,
    required String userId,
    required String eventId,
    String? parentId,
    required DateTime createdAt,
    @Default(<FeedComment>[]) List<FeedComment> replies,
  }) = _FeedComment;

  factory FeedComment.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentFromJson(json);
}

/// Domain container for the full comment list of one event.
@freezed
abstract class FeedCommentList with _$FeedCommentList {
  const factory FeedCommentList({
    required List<FeedComment> comments,
  }) = _FeedCommentList;
}
