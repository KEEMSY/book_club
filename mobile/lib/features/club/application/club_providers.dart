import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/club_api.dart';
import '../data/club_repository.dart';
import '../domain/club.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ClubRepository(ClubApi(dio));
});

final myClubsProvider = FutureProvider.autoDispose<List<Club>>((ref) {
  return ref.watch(clubRepositoryProvider).listMyClubs();
});
