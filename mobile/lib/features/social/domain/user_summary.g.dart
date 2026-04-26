// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSummaryImpl _$$UserSummaryImplFromJson(Map<String, dynamic> json) =>
    _$UserSummaryImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      isFollowing: json['is_following'] as bool,
    );

Map<String, dynamic> _$$UserSummaryImplToJson(_$UserSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'bio': instance.bio,
      'is_following': instance.isFollowing,
    };

_$UserSummaryPageImpl _$$UserSummaryPageImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSummaryPageImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$$UserSummaryPageImplToJson(
        _$UserSummaryPageImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      followerCount: (json['follower_count'] as num).toInt(),
      followingCount: (json['following_count'] as num).toInt(),
      isFollowing: json['is_following'] as bool,
      isMe: json['is_me'] as bool,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'bio': instance.bio,
      'follower_count': instance.followerCount,
      'following_count': instance.followingCount,
      'is_following': instance.isFollowing,
      'is_me': instance.isMe,
    };
