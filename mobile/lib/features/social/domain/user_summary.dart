import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_summary.freezed.dart';
part 'user_summary.g.dart';

/// Reading statistics and grade info bundled with a user profile.
@freezed
abstract class GradeStats with _$GradeStats {
  const factory GradeStats({
    required int grade,
    required int tier,
    required int totalBooks,
    required int totalSeconds,
    required int streakDays,
  }) = _GradeStats;

  factory GradeStats.fromJson(Map<String, dynamic> json) =>
      _$GradeStatsFromJson(json);
}

/// Minimal badge entry for profile showcase.
@freezed
abstract class BadgeSummary with _$BadgeSummary {
  const factory BadgeSummary({
    required String id,
    required String name,
    required String iconUrl,
    required String category,
    required DateTime earnedAt,
  }) = _BadgeSummary;

  factory BadgeSummary.fromJson(Map<String, dynamic> json) =>
      _$BadgeSummaryFromJson(json);
}

/// Single highlight shown on a user's profile (recent highlights section).
@freezed
abstract class HighlightSummary with _$HighlightSummary {
  const factory HighlightSummary({
    required String id,
    required String quoteText,
    String? bookTitle,
    required DateTime createdAt,
  }) = _HighlightSummary;

  factory HighlightSummary.fromJson(Map<String, dynamic> json) =>
      _$HighlightSummaryFromJson(json);
}

/// A lightweight user representation returned by social list endpoints.
///
/// Used in follower/following lists so the UI can render avatar + follow chip
/// without fetching the full [UserProfile].
@freezed
abstract class UserSummary with _$UserSummary {
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
abstract class UserSummaryPage with _$UserSummaryPage {
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
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String nickname,
    String? profileImageUrl,
    String? bio,
    required int followerCount,
    required int followingCount,
    required bool isFollowing,
    required bool isMe,
    GradeStats? gradeStats,
    @Default([]) List<BadgeSummary> badges,
    @Default([]) List<HighlightSummary> recentHighlights,
    // Profile expressiveness (backend BC-81, mobile UI BC-84). Kept as raw
    // wire values here (not the `ProfileTheme` enum) so this DTO's
    // json_serializable codegen stays trivial — [ProfileTheme.fromWire]
    // converts `theme` at the presentation layer. [featuredBookId] is a bare
    // id; the profile header fetches title/cover via the existing
    // `GET /books/{id}` (see `featuredBookProvider`).
    String? coverImageUrl,
    String? theme,
    String? featuredBookId,
    String? featuredQuote,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
