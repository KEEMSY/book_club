import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_summary.freezed.dart';
part 'user_summary.g.dart';

/// A lightweight user representation returned by social list endpoints.
///
/// Used in follower/following lists so the UI can render avatar + follow chip
/// without fetching the full [UserProfile].
@freezed
class UserSummary with _$UserSummary {
  const factory UserSummary({
    required String id,
    required String nickname,
    String? profileImageUrl,
    String? bio,
    required bool isFollowing,
  }) = _UserSummary;

  factory UserSummary.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryFromJson(json);
}

/// Cursor-paged envelope for social list endpoints.
@freezed
class UserSummaryPage with _$UserSummaryPage {
  const factory UserSummaryPage({
    required List<UserSummary> items,
    String? nextCursor,
  }) = _UserSummaryPage;

  factory UserSummaryPage.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryPageFromJson(json);
}

/// Full user profile returned by `GET /community/users/{userId}/profile`.
///
/// [isMe] lets the profile screen swap the follow button for "프로필 편집"
/// without an extra auth check in the UI layer.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String nickname,
    String? profileImageUrl,
    String? bio,
    required int followerCount,
    required int followingCount,
    required bool isFollowing,
    required bool isMe,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
