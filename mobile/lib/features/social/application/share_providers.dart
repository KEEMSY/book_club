import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/share_api.dart';
import '../domain/share_card.dart';

final shareApiProvider = Provider<ShareApi>((ref) {
  return ShareApi(ref.watch(dioProvider));
});

/// Card metadata for a single template, keyed by `card_type`.
///
/// Auto-disposes when the share sheet closes so each open fetches fresh copy
/// (and a freshly minted referral code on the user's first ever share).
final shareCardMetaProvider =
    FutureProvider.autoDispose.family<ShareCardMeta, String>((ref, cardType) {
  return ref.watch(shareApiProvider).getShareCardMeta(cardType);
});
