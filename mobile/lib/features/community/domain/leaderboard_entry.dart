import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

/// A single row in the weekly social leaderboard.
///
/// [weeklyMinutes] represents total reading time in the past 7 days.
/// [gradeTier] is null when the user has no grade data yet.
/// [isMe] lets the UI highlight the authenticated user's own row.
@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required int rank,
    required String userId,
    required String nickname,
    String? profileImageUrl,
    int? gradeTier,
    required int weeklyMinutes,
    @Default(false) bool isMe,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}
