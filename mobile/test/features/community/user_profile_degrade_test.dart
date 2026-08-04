import 'package:book_club/core/config/feature_flags.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/domain/auth_user.dart';
import 'package:book_club/features/community/application/community_providers.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../reading/fakes.dart';

class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);

  final AuthUser _user;

  @override
  AuthState build() => AuthState.authenticated(_user);

  @override
  Future<void> bootstrap() async {}
}

void main() {
  // Guards BC-40: with community deferred, userProfileProvider must build the
  // current user's profile from /me + grade instead of hitting the unmounted
  // /community/users/{id}/profile endpoint (which 404s).
  test(
    'community off: userProfileProvider builds own profile from /me + grade',
    () async {
      // The degrade branch only runs while community is deferred.
      expect(FeatureFlags.community, isFalse);

      final repo = FakeReadingRepository()
        ..gradeResult = buildGradeSummary(
          grade: 2,
          totalBooks: 5,
          totalSeconds: 3600,
          streakDays: 4,
        );
      final user = AuthUser(
        id: 'u1',
        nickname: '테스터',
        provider: AuthProvider.kakao,
        createdAt: DateTime(2026, 1, 1),
      );

      final container = ProviderContainer(
        overrides: <Override>[
          authNotifierProvider.overrideWith(() => _StubAuth(user)),
          readingRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final profile = await container.read(userProfileProvider('u1').future);

      expect(profile.isMe, isTrue);
      expect(profile.nickname, '테스터');
      expect(profile.followerCount, 0);
      expect(profile.followingCount, 0);
      expect(profile.gradeStats, isNotNull);
      expect(profile.gradeStats!.grade, 2);
      expect(profile.gradeStats!.totalBooks, 5);
      expect(profile.badges, isEmpty);
    },
  );
}
