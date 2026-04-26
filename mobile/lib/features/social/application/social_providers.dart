import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/social_api.dart';
import '../data/social_repository.dart';

final socialApiProvider = Provider<SocialApi>((ref) {
  return SocialApi(ref.watch(dioProvider));
});

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(ref.watch(socialApiProvider));
});

/// Tracks the in-flight follow/unfollow state for a single user.
///
/// Auto-disposes when the calling widget unmounts so stale mutation states
/// don't linger across profile navigations.
class FollowNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Calls follow and updates the local [AsyncValue] for loading feedback.
  ///
  /// The caller is responsible for invalidating [userProfileProvider] after
  /// success so the follower count and button state refresh.
  Future<void> follow(String targetUserId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(socialRepositoryProvider).follow(targetUserId),
    );
  }

  Future<void> unfollow(String targetUserId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(socialRepositoryProvider).unfollow(targetUserId),
    );
  }
}

final followNotifierProvider =
    AutoDisposeNotifierProvider<FollowNotifier, AsyncValue<void>>(
  FollowNotifier.new,
);
