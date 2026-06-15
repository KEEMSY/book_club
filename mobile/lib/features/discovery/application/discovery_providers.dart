import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/discovery_api.dart';
import '../data/discovery_repository.dart';
import '../domain/recommended_book.dart';

part 'discovery_providers.g.dart';

@riverpod
DiscoveryRepository discoveryRepository(DiscoveryRepositoryRef ref) {
  return DiscoveryRepository(DiscoveryApi(ref.watch(dioProvider)));
}

/// M44 — fetches ML recommendations for the given [strategy].
///
/// [strategy] must be one of "collaborative", "similar_readers", or
/// "taste_match". Defaults to "collaborative" when omitted.
@riverpod
Future<List<RecommendedBook>> recommendations(
  RecommendationsRef ref, {
  String strategy = 'collaborative',
}) {
  return ref
      .watch(discoveryRepositoryProvider)
      .getRecommendations(strategy: strategy, limit: 10);
}
