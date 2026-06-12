import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_status.freezed.dart';

/// Current Pro subscription state for the authenticated user.
///
/// Populated from `GET /me/subscription`.
@freezed
abstract class SubscriptionStatus with _$SubscriptionStatus {
  const factory SubscriptionStatus({
    @Default(false) bool isPro,
    DateTime? proExpiresAt,
    String? proProductId,
  }) = _SubscriptionStatus;
}
