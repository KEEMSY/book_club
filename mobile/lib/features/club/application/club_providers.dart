import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../feed/application/feed_providers.dart';
import '../../feed/data/image_uploader.dart';
import '../data/club_api.dart';
import '../data/club_repository.dart';
import '../domain/club.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ClubRepository(ClubApi(dio));
});

/// Re-exports the feed domain's uploader for use in the chat image flow.
/// The same presign endpoint (`POST /uploads/presign-image`) and R2 PUT
/// pipeline are shared — no separate upload path needed.
final chatImageUploaderProvider = Provider<ImageUploader>((ref) {
  return ref.watch(imageUploaderProvider);
});

final myClubsProvider = FutureProvider.autoDispose<List<Club>>((ref) {
  return ref.watch(clubRepositoryProvider).listMyClubs();
});

final publicClubsProvider = FutureProvider.autoDispose
    .family<List<Club>, ({String? search, String sort})>(
  (ref, params) => ref.read(clubRepositoryProvider).listPublicClubs(
        search: params.search,
        sort: params.sort,
      ),
);
