// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedComment _$FeedCommentFromJson(Map<String, dynamic> json) => _FeedComment(
      id: json['id'] as String,
      body: json['body'] as String,
      userId: json['user_id'] as String,
      eventId: json['event_id'] as String,
      parentId: json['parent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => FeedComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FeedComment>[],
    );

Map<String, dynamic> _$FeedCommentToJson(_FeedComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'user_id': instance.userId,
      'event_id': instance.eventId,
      'parent_id': instance.parentId,
      'created_at': instance.createdAt.toIso8601String(),
      'replies': instance.replies.map((e) => e.toJson()).toList(),
    };
