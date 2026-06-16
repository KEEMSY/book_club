import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/retention_api.dart';
import '../data/retention_repository.dart';
import '../domain/streak_recovery_status.dart';

part 'retention_providers.g.dart';

/// Retrofit client for the retention endpoints — built once per Dio instance.
final retentionApiProvider = Provider<RetentionApi>((ref) {
  return RetentionApi(ref.watch(dioProvider));
});

/// Domain repository consumed by retention providers and notifiers.
final retentionRepositoryProvider = Provider<RetentionRepository>((ref) {
  return RetentionRepository(ref.watch(retentionApiProvider));
});

/// Fetches the current user's streak recovery eligibility.
///
/// autoDispose so the status is re-fetched each time it becomes relevant
/// (e.g. after a recovery action or a fresh dashboard load).
@riverpod
Future<StreakRecoveryStatus> streakRecoveryStatus(Ref ref) async {
  final repo = ref.read(retentionRepositoryProvider);
  return repo.getRecoveryStatus();
}
