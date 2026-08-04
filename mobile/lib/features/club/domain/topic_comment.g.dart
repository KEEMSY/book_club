// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopicComment _$TopicCommentFromJson(Map<String, dynamic> json) =>
    _TopicComment(
      id: json['id'] as String,
      topicId: json['topic_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String?,
      parentCommentId: json['parent_comment_id'] as String?,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: json['edited_at'] == null
          ? null
          : DateTime.parse(json['edited_at'] as String),
    );

Map<String, dynamic> _$TopicCommentToJson(_TopicComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic_id': instance.topicId,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'parent_comment_id': instance.parentCommentId,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'edited_at': instance.editedAt?.toIso8601String(),
    };
