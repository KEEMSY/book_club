// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamSubscription _$TeamSubscriptionFromJson(Map<String, dynamic> json) =>
    _TeamSubscription(
      id: json['id'] as String,
      teamName: json['team_name'] as String,
      adminUserId: json['admin_user_id'] as String,
      seatCount: (json['seat_count'] as num).toInt(),
      planType: json['plan_type'] as String,
      validFrom: DateTime.parse(json['valid_from'] as String),
      validUntil: DateTime.parse(json['valid_until'] as String),
      usedSeats: (json['used_seats'] as num?)?.toInt() ?? 0,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TeamMember>[],
    );

Map<String, dynamic> _$TeamSubscriptionToJson(_TeamSubscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'team_name': instance.teamName,
      'admin_user_id': instance.adminUserId,
      'seat_count': instance.seatCount,
      'plan_type': instance.planType,
      'valid_from': instance.validFrom.toIso8601String(),
      'valid_until': instance.validUntil.toIso8601String(),
      'used_seats': instance.usedSeats,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };

_TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => _TeamMember(
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );

Map<String, dynamic> _$TeamMemberToJson(_TeamMember instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'joined_at': instance.joinedAt.toIso8601String(),
    };
