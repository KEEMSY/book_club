import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/highlight_api.dart';
import '../data/highlight_repository.dart';
import '../domain/highlight_explore.dart';

part 'highlight_providers.g.dart';

/// retrofit client for the M51 highlight social endpoints.
@riverpod
HighlightApi highlightApi(HighlightApiRef ref) {
  return HighlightApi(ref.watch(dioProvider));
}

/// Repository for visibility toggles, feed sharing, and explore listing.
@riverpod
HighlightRepository highlightRepository(HighlightRepositoryRef ref) {
  return HighlightRepository(api: ref.watch(highlightApiProvider));
}

/// Public highlight explore feed.
///
/// autoDispose (the codegen default) releases the list when the explore
/// screen is popped; [sort] keys separate cached variants ("recent" / "top").
@riverpod
Future<List<HighlightExplore>> exploreHighlights(
  ExploreHighlightsRef ref, {
  String sort = 'recent',
}) {
  return ref.watch(highlightRepositoryProvider).exploreHighlights(sort: sort);
}
