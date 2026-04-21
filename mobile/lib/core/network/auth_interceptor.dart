import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

/// Attaches `Authorization: Bearer <access_token>` to every outbound request
/// except those under `/auth/*` (which are by definition unauthenticated —
/// login / refresh / device-token registration uses its own bearer injection
/// logic below).
///
/// Device-token registration (`POST /auth/device-tokens`) intentionally sits
/// under `/auth/*` path-wise but **does** require a bearer — the backend uses
/// `Depends(get_current_user)` on that route. We special-case it here so the
/// interceptor stays a simple allow-list.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorage _storage;

  static bool needsAuth(String path) {
    if (path.startsWith('/auth/device-tokens')) {
      return true;
    }
    if (path.startsWith('/auth/')) {
      return false;
    }
    return true;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!needsAuth(options.path)) {
      handler.next(options);
      return;
    }
    final String? token = await _storage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
