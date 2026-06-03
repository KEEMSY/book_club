import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../data/default_social_login_port.dart';
import '../data/social_login_port.dart';


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
