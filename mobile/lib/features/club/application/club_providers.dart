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

/// Resolves a single [Club] by id. Used by deeplink/notification routes that
/// only carry a club id, not the full object the detail/chat screens require.
final clubByIdProvider =
    FutureProvider.autoDispose.family<Club, String>((ref, clubId) {
  return ref.watch(clubRepositoryProvider).getClub(clubId);
});

final publicClubsProvider = FutureProvider.autoDispose
    .family<List<Club>, ({String? search, String sort})>(
  (ref, params) => ref.read(clubRepositoryProvider).listPublicClubs(
        search: params.search,
        sort: params.sort,
      ),
);

/// M48: filtered public clubs with category/tag/sort support.
final filteredPublicClubsProvider = FutureProvider.autoDispose
    .family<List<Club>, ({String? category, String? tag, String sort})>(
  (ref, params) => ref.read(clubRepositoryProvider).listPublicClubs(
        category: params.category,
        tag: params.tag,
        sort: params.sort,
      ),
);

/// M48: AI-recommended clubs for the current user.
final recommendedClubsProvider =
    FutureProvider.autoDispose<List<Club>>((ref) {
  return ref.read(clubRepositoryProvider).getRecommendedClubs();
});
