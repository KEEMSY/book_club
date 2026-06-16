import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/shield_api.dart';
import '../data/shield_repository.dart';

part 'shield_providers.g.dart';

/// Retrofit client for the shield endpoints — built once per Dio instance.
final shieldApiProvider = Provider<ShieldApi>((ref) {
  return ShieldApi(ref.watch(dioProvider));
});

/// Domain repository consumed by shield providers and notifiers.
final shieldRepositoryProvider = Provider<ShieldRepository>((ref) {
  return ShieldRepository(ref.watch(shieldApiProvider));
});

/// Fetches the current user's streak shield balance.
///
/// autoDispose ensures the balance is re-fetched each time the sheet is
/// opened, keeping the display consistent with the server state.
@riverpod
Future<int> shieldBalance(Ref ref) async {
  final repo = ref.read(shieldRepositoryProvider);
  return repo.getBalance();
}
