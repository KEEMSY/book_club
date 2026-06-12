import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/subscription_api.dart';
import '../data/subscription_repository.dart';

final subscriptionApiProvider = Provider<SubscriptionApi>((ref) {
  return SubscriptionApi(ref.watch(dioProvider));
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(subscriptionApiProvider));
});
