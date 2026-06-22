import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/dio_provider.dart';
import '../data/team_api.dart';
import '../data/team_repository.dart';
import '../domain/team_subscription.dart';

part 'team_providers.g.dart';

/// SharedPreferences key under which the user's team id is cached so [myTeam]
/// can resolve it without a dedicated "my teams" backend endpoint.
const String kTeamIdPrefKey = 'team_id';

final teamApiProvider = Provider<TeamApi>((ref) {
  return TeamApi(ref.watch(dioProvider));
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(ref.watch(teamApiProvider));
});

/// Team plan details + roster by id (`GET /teams/{id}`).
///
/// autoDispose: the admin screen only needs it while visible. Invalidate after
/// add/remove to refresh the roster and seat usage.
@riverpod
Future<TeamSubscription> team(TeamRef ref, String teamId) {
  return ref.watch(teamRepositoryProvider).getTeam(teamId);
}

/// The current user's team, or `null` when they belong to none.
///
/// The team id is read from local prefs (no "my teams" endpoint in the MVP);
/// returns `null` when unset so callers can hide team UI.
@riverpod
Future<TeamSubscription?> myTeam(MyTeamRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final teamId = prefs.getString(kTeamIdPrefKey);
  if (teamId == null || teamId.isEmpty) return null;
  return ref.watch(teamRepositoryProvider).getTeam(teamId);
}
