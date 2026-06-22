import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_subscription.freezed.dart';
part 'team_subscription.g.dart';

/// A B2B team plan (M70), as returned by `GET /teams/{id}`.
///
/// [usedSeats] is the current roster size (admin included); the admin can seat
/// up to [seatCount] members. Each seat's Pro entitlement tracks [validUntil].
@freezed
abstract class TeamSubscription with _$TeamSubscription {
  const factory TeamSubscription({
    required String id,
    required String teamName,
    required String adminUserId,
    required int seatCount,
    required String planType,
    required DateTime validFrom,
    required DateTime validUntil,
    @Default(0) int usedSeats,
    @Default(<TeamMember>[]) List<TeamMember> members,
  }) = _TeamSubscription;

  factory TeamSubscription.fromJson(Map<String, dynamic> json) =>
      _$TeamSubscriptionFromJson(json);
}

/// A single occupied seat on a team plan.
@freezed
abstract class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String userId,
    required String nickname,
    String? profileImageUrl,
    required DateTime joinedAt,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);
}
