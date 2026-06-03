// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GradeStats _$GradeStatsFromJson(Map<String, dynamic> json) => _GradeStats(
      grade: (json['grade'] as num).toInt(),
      tier: (json['tier'] as num).toInt(),
      totalBooks: (json['total_books'] as num).toInt(),
      totalSeconds: (json['total_seconds'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
    );

Map<String, dynamic> _$GradeStatsToJson(_GradeStats instance) =>
    <String, dynamic>{
      'grade': instance.grade,
      'tier': instance.tier,
      'total_books': instance.totalBooks,
      'total_seconds': instance.totalSeconds,
      'streak_days': instance.streakDays,
    };

_BadgeSummary _$BadgeSummaryFromJson(Map<String, dynamic> json) =>
    _BadgeSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String,
      category: json['category'] as String,
      earnedAt: DateTime.parse(json['earned_at'] as String),
    );

Map<String, dynamic> _$BadgeSummaryToJson(_BadgeSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'category': instance.category,
      'earned_at': instance.earnedAt.toIso8601String(),
    };

_HighlightSummary _$HighlightSummaryFromJson(Map<String, dynamic> json) =>
    _HighlightSummary(
      id: json['id'] as String,
      quoteText: json['quote_text'] as String,
      bookTitle: json['book_title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HighlightSummaryToJson(_HighlightSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quote_text': instance.quoteText,
      'book_title': instance.bookTitle,
      'created_at': instance.createdAt.toIso8601String(),
    };

_UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) => _UserSummary(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      isFollowing: json['is_following'] as bool,
    );

Map<String, dynamic> _$UserSummaryToJson(_UserSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'bio': instance.bio,
      'is_following': instance.isFollowing,
    };

_UserSummaryPage _$UserSummaryPageFromJson(Map<String, dynamic> json) =>
    _UserSummaryPage(
      items: (json['items'] as List<dynamic>)
          .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$UserSummaryPageToJson(_UserSummaryPage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      followerCount: (json['follower_count'] as num).toInt(),
      followingCount: (json['following_count'] as num).toInt(),
      isFollowing: json['is_following'] as bool,
      isMe: json['is_me'] as bool,
      gradeStats: json['grade_stats'] == null
          ? null
          : GradeStats.fromJson(json['grade_stats'] as Map<String, dynamic>),
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => BadgeSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentHighlights: (json['recent_highlights'] as List<dynamic>?)
              ?.map((e) => HighlightSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'bio': instance.bio,
      'follower_count': instance.followerCount,
      'following_count': instance.followingCount,
      'is_following': instance.isFollowing,
      'is_me': instance.isMe,
      'grade_stats': instance.gradeStats?.toJson(),
      'badges': instance.badges.map((e) => e.toJson()).toList(),
      'recent_highlights':
          instance.recentHighlights.map((e) => e.toJson()).toList(),
    };
