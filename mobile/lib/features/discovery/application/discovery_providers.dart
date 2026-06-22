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

/// M69 — fetches a single curation channel's books.
///
/// [channel] must be one of "taste_match", "trending", "club_picks", or
/// "ai_picks".
@riverpod
Future<List<RecommendedBook>> bookRecommendations(
  BookRecommendationsRef ref, {
  required String channel,
}) {
  return ref
      .watch(discoveryRepositoryProvider)
      .getBookRecommendations(channel: channel, limit: 10);
}
