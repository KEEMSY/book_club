import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../data/default_social_login_port.dart';
import '../data/social_login_port.dart';
import '../domain/auth_state.dart';
import 'auth_notifier.dart';

/// retrofit client — built once per Dio instance.
final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
});

/// Production social-login port. Tests override with a fake implementation
/// so Kakao/Apple SDKs are never linked into the test binary.
final socialLoginPortProvider = Provider<SocialLoginPort>((ref) {
  return const DefaultSocialLoginPort();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    api: ref.watch(authApiProvider),
    secureStorage: ref.watch(secureStorageProvider),
    socialLogin: ref.watch(socialLoginPortProvider),
  );
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final notifier = AuthNotifier(ref.watch(authRepositoryProvider));

  // Bridge the refresh-interceptor's session-expired broadcast into an
  // explicit logout on the notifier. This stays here (not in core/) so the
  // dio provider does not depend on feature code.
  ref.listen<int>(sessionExpiredBroadcastProvider, (previous, next) {
    if (previous != null && next > previous) {
      notifier.logout();
    }
  });

  // Kick off rehydration once the first listener subscribes. The router gate
  // is the first listener, so this happens on app start before any route
  // resolves against the gate's current-state snapshot.
  notifier.bootstrap();
  return notifier;
});
