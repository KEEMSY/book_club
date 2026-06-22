// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoSession _$VideoSessionFromJson(Map<String, dynamic> json) =>
    _VideoSession(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      hostId: json['host_id'] as String,
      agoraChannel: json['agora_channel'] as String,
      maxParticipants: (json['max_participants'] as num).toInt(),
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      agoraToken: json['agora_token'] as String?,
      channel: json['channel'] as String?,
    );

Map<String, dynamic> _$VideoSessionToJson(_VideoSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'club_id': instance.clubId,
      'host_id': instance.hostId,
      'agora_channel': instance.agoraChannel,
      'max_participants': instance.maxParticipants,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'agora_token': instance.agoraToken,
      'channel': instance.channel,
    };
