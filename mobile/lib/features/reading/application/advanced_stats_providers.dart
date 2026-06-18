import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/advanced_stats_api.dart';
import '../data/advanced_stats_models.dart';
import '../data/advanced_stats_repository.dart';

part 'advanced_stats_providers.g.dart';

@riverpod
AdvancedStatsApi advancedStatsApi(AdvancedStatsApiRef ref) {
  return AdvancedStatsApi(ref.watch(dioProvider));
}

@riverpod
AdvancedStatsRepository advancedStatsRepository(
  AdvancedStatsRepositoryRef ref,
) {
  return AdvancedStatsRepository(ref.watch(advancedStatsApiProvider));
}

/// Fetches the Pro-only advanced stats payload.
///
/// autoDispose (default) — an occasional-visit screen; releasing the cache on
/// exit keeps idle memory low and re-checks Pro entitlement on each visit.
@riverpod
class AdvancedStats extends _$AdvancedStats {
  @override
  Future<AdvancedStatsDto> build() async {
    return ref.read(advancedStatsRepositoryProvider).fetchAdvancedStats();
  }
}
