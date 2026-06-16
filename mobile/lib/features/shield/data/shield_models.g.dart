// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shield_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShieldBalanceDto _$ShieldBalanceDtoFromJson(Map<String, dynamic> json) =>
    _ShieldBalanceDto(
      streakShields: (json['streak_shields'] as num).toInt(),
    );

Map<String, dynamic> _$ShieldBalanceDtoToJson(_ShieldBalanceDto instance) =>
    <String, dynamic>{
      'streak_shields': instance.streakShields,
    };

_PurchaseShieldRequestDto _$PurchaseShieldRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _PurchaseShieldRequestDto(
      productId: json['product_id'] as String,
      receiptData: json['receipt_data'] as String,
    );

Map<String, dynamic> _$PurchaseShieldRequestDtoToJson(
        _PurchaseShieldRequestDto instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'receipt_data': instance.receiptData,
    };

_ShieldPurchaseResultDto _$ShieldPurchaseResultDtoFromJson(
        Map<String, dynamic> json) =>
    _ShieldPurchaseResultDto(
      shieldsGranted: (json['shields_granted'] as num).toInt(),
      totalShields: (json['total_shields'] as num).toInt(),
    );

Map<String, dynamic> _$ShieldPurchaseResultDtoToJson(
        _ShieldPurchaseResultDto instance) =>
    <String, dynamic>{
      'shields_granted': instance.shieldsGranted,
      'total_shields': instance.totalShields,
    };
