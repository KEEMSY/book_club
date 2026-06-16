import 'package:freezed_annotation/freezed_annotation.dart';

part 'shield_models.freezed.dart';
part 'shield_models.g.dart';

/// Mirror of `GET /me/shields` response body.
///
/// `streakShields` maps to the JSON key `streak_shields` via the global
/// `field_rename: snake` rule in `build.yaml`.
@freezed
abstract class ShieldBalanceDto with _$ShieldBalanceDto {
  const factory ShieldBalanceDto({
    required int streakShields,
  }) = _ShieldBalanceDto;

  factory ShieldBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$ShieldBalanceDtoFromJson(json);
}

/// Body sent to `POST /me/shields/purchase`.
@freezed
abstract class PurchaseShieldRequestDto with _$PurchaseShieldRequestDto {
  const factory PurchaseShieldRequestDto({
    required String productId,
    required String receiptData,
  }) = _PurchaseShieldRequestDto;

  factory PurchaseShieldRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseShieldRequestDtoFromJson(json);
}

/// Mirror of `POST /me/shields/purchase` response body.
@freezed
abstract class ShieldPurchaseResultDto with _$ShieldPurchaseResultDto {
  const factory ShieldPurchaseResultDto({
    required int shieldsGranted,
    required int totalShields,
  }) = _ShieldPurchaseResultDto;

  factory ShieldPurchaseResultDto.fromJson(Map<String, dynamic> json) =>
      _$ShieldPurchaseResultDtoFromJson(json);
}
