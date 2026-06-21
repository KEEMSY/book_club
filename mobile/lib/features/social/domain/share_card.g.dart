// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShareCardMeta _$ShareCardMetaFromJson(Map<String, dynamic> json) =>
    _ShareCardMeta(
      cardType: json['card_type'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      referralCode: json['referral_code'] as String,
      joinUrl: json['join_url'] as String,
      headline: json['headline'] as String,
      caption: json['caption'] as String,
    );

Map<String, dynamic> _$ShareCardMetaToJson(_ShareCardMeta instance) =>
    <String, dynamic>{
      'card_type': instance.cardType,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'referral_code': instance.referralCode,
      'join_url': instance.joinUrl,
      'headline': instance.headline,
      'caption': instance.caption,
    };
