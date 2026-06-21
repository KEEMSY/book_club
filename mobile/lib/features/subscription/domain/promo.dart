import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo.freezed.dart';
part 'promo.g.dart';

/// Active early-bird promotional offer, from `GET /subscriptions/promo`.
///
/// The endpoint returns `null` when no promo is live, so callers receive a
/// nullable [Promo] and only render the banner when one is present.
@freezed
abstract class Promo with _$Promo {
  const factory Promo({
    required String promoCode,
    required int discountPct,
    required DateTime validUntil,
  }) = _Promo;

  factory Promo.fromJson(Map<String, dynamic> json) => _$PromoFromJson(json);
}
