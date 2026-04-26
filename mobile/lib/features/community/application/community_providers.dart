import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../social/domain/user_summary.dart';
import '../data/community_api.dart';
import '../data/community_repository.dart';

final communityApiProvider = Provider<CommunityApi>((ref) {
  return CommunityApi(ref.watch(dioProvider));
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(ref.watch(communityApiProvider));
});

/// Fetches and caches a user's full profile.
///
/// Auto-disposes so the network cache is released when no profile screen is
/// mounted. Callers invalidate this provider after follow/unfollow mutations
/// so the follower count and button state stay consistent.
final userProfileProvider =
    AutoDisposeFutureProvider.family<UserProfile, String>((ref, userId) {
  return ref.watch(communityRepositoryProvider).getUserProfile(userId);
});
