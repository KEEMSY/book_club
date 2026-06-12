import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/referral_api.dart';
import '../data/referral_repository.dart';

final referralApiProvider = Provider<ReferralApi>((ref) {
  return ReferralApi(ref.watch(dioProvider));
});

final referralRepositoryProvider = Provider<ReferralRepository>((ref) {
  return ReferralRepository(ref.watch(referralApiProvider));
});
