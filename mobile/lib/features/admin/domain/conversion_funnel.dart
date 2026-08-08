import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversion_funnel.freezed.dart';

/// Paywall conversion funnel — views → clicks → subscriptions.
///
/// Mirrors the backend `ConversionFunnelResponse`
/// (`GET /admin/conversion-funnel`).
@freezed
abstract class ConversionFunnel with _$ConversionFunnel {
  const factory ConversionFunnel({
    required int paywallViews,
    required int paywallClicks,
    required int subscriptions,
    required double conversionRate,
  }) = _ConversionFunnel;
}
