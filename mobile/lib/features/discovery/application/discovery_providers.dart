import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/discovery_api.dart';
import '../data/discovery_repository.dart';
import '../domain/recommended_book.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepository(DiscoveryApi(ref.watch(dioProvider)));
});

final recommendationsProvider =
    FutureProvider.autoDispose<List<RecommendedBook>>((ref) {
  return ref.watch(discoveryRepositoryProvider).getRecommendations();
});
