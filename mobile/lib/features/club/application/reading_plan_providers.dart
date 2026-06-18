import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/reading_plan_api.dart';
import '../data/reading_plan_repository.dart';
import '../domain/reading_plan.dart';

part 'reading_plan_providers.g.dart';

@riverpod
ReadingPlanRepository readingPlanRepository(ReadingPlanRepositoryRef ref) {
  return ReadingPlanRepository(ReadingPlanApi(ref.watch(dioProvider)));
}

/// The club's current reading plan, or null when none exists yet.
@riverpod
Future<ReadingPlan?> clubReadingPlan(
  ClubReadingPlanRef ref,
  String clubId,
) {
  return ref.watch(readingPlanRepositoryProvider).getPlan(clubId);
}

/// Aggregate member progress for the club plan.
@riverpod
Future<ClubProgress> clubProgress(
  ClubProgressRef ref,
  String clubId,
) {
  return ref.watch(readingPlanRepositoryProvider).getProgress(clubId);
}
