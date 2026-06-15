import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/experiment_api.dart';
import '../data/experiment_repository.dart';
import '../domain/user_experiments.dart';

part 'experiment_providers.g.dart';

@riverpod
ExperimentRepository experimentRepository(ExperimentRepositoryRef ref) {
  return ExperimentRepository(ExperimentApi(ref.watch(dioProvider)));
}

/// Fetches the current user's A/B experiment assignments.
///
/// autoDispose so fresh assignments are fetched each time the relevant screen
/// is opened (ensures variant changes propagate without a stale cache).
@riverpod
Future<UserExperiments> userExperiments(UserExperimentsRef ref) {
  return ref.watch(experimentRepositoryProvider).getMyExperiments();
}
