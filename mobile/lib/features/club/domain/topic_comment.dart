import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_comment.freezed.dart';
part 'topic_comment.g.dart';

/// A reply in a topic's discussion thread.
///
/// Mirrors `topic_comments` from the BC-42 design doc §4.1. [parentCommentId]
/// is non-null only for one level of nesting (design doc: "1단계 대댓글") —
/// deeper nesting is out of scope for this epic.
///
/// The full reply-tree UI (composer, nested rendering, edit/delete) is BC-51.
/// BC-49 only consumes this model to derive a reply count and a preview
/// string for the collapsed agenda-topic accordion.
@freezed
abstract class TopicComment with _$TopicComment {
  const factory TopicComment({
    required String id,
    required String topicId,
    required String authorId,
    String? authorName,
    String? parentCommentId,
    required String body,
    required DateTime createdAt,
    DateTime? editedAt,
  }) = _TopicComment;

  factory TopicComment.fromJson(Map<String, dynamic> json) =>
      _$TopicCommentFromJson(json);
}
