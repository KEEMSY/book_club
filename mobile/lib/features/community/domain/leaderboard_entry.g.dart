// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    _LeaderboardEntry(
      rank: (json['rank'] as num).toInt(),
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      gradeTier: (json['grade_tier'] as num?)?.toInt(),
      weeklyMinutes: (json['weekly_minutes'] as num).toInt(),
      isMe: json['is_me'] as bool? ?? false,
    );

Map<String, dynamic> _$LeaderboardEntryToJson(_LeaderboardEntry instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'grade_tier': instance.gradeTier,
      'weekly_minutes': instance.weeklyMinutes,
      'is_me': instance.isMe,
    };
