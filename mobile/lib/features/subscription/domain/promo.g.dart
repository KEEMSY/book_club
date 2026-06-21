// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Promo _$PromoFromJson(Map<String, dynamic> json) => _Promo(
      promoCode: json['promo_code'] as String,
      discountPct: (json['discount_pct'] as num).toInt(),
      validUntil: DateTime.parse(json['valid_until'] as String),
    );

Map<String, dynamic> _$PromoToJson(_Promo instance) => <String, dynamic>{
      'promo_code': instance.promoCode,
      'discount_pct': instance.discountPct,
      'valid_until': instance.validUntil.toIso8601String(),
    };
