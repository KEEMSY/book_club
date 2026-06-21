import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_card.freezed.dart';
part 'share_card.g.dart';

/// Metadata the backend supplies for one SNS certification card template (M62).
///
/// The triggering screen contributes the numeric specifics (streak count, book
/// title, ...) it already holds; the backend owns identity, the referral deep
/// link encoded into the card QR, and the suggested Korean caption.
@freezed
abstract class ShareCardMeta with _$ShareCardMeta {
  const factory ShareCardMeta({
    required String cardType,
    required String nickname,
    String? profileImageUrl,
    required String referralCode,
    required String joinUrl,
    required String headline,
    required String caption,
  }) = _ShareCardMeta;

  factory ShareCardMeta.fromJson(Map<String, dynamic> json) =>
      _$ShareCardMetaFromJson(json);
}
