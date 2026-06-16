// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedReaction _$FeedReactionFromJson(Map<String, dynamic> json) =>
    _FeedReaction(
      id: json['id'] as String,
      emoji: json['emoji'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FeedReactionToJson(_FeedReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emoji': instance.emoji,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
    };
