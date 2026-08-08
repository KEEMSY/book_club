import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/admin_api.dart';
import '../data/admin_repository.dart';
import '../domain/admin_overview.dart';

part 'admin_providers.g.dart';

/// retrofit client — built once per Dio instance.
final adminApiProvider = Provider<AdminApi>((ref) {
  return AdminApi(ref.watch(dioProvider));
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(adminApiProvider));
});

/// Combined stats + funnel + revenue payload for the console's metrics
/// section. autoDispose: only fetched while the console is visible; the
/// screen's pull-to-refresh / retry action calls `ref.invalidate`.
@riverpod
Future<AdminOverview> adminOverview(AdminOverviewRef ref) {
  return ref.watch(adminRepositoryProvider).getOverview();
}
