import 'dart:async';

import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

/// Signature for the callback the refresh interceptor invokes when tokens
/// have been unrecoverably cleared (i.e. refresh itself failed). The caller
/// is expected to flip the `AuthState` to `Unauthenticated` so the router
/// gate can redirect to `/login`.
typedef OnSessionExpired = void Function();

/// Queues concurrent 401s and performs a single `/auth/refresh` call per
/// expiry. On success every queued request is retried with the new bearer;
/// on failure all are completed with the original error and the session is
/// cleared so the UI can react via [OnSessionExpired].
///
/// Only 401 responses whose JSON error envelope carries
/// `error.code == "TOKEN_EXPIRED"` trigger the refresh. Anything else
/// (e.g. `TOKEN_INVALID`, `USER_GONE`) short-circuits to session-expired.
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({
    required Dio dio,
    required SecureStorage storage,
    required OnSessionExpired onSessionExpired,
  })  : _dio = dio,
        _storage = storage,
        _onSessionExpired = onSessionExpired;

  final Dio _dio;
  final SecureStorage _storage;
  final OnSessionExpired _onSessionExpired;

  Completer<String?>? _inflightRefresh;

  /// Marker written into `RequestOptions.extra` when we fire our own
  /// `/auth/refresh` call — prevents the interceptor from re-entering itself.
  static const String _skipRefreshKey = '__book_club_skip_refresh__';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final int? status = response?.statusCode;
    if (status != 401) {
      handler.next(err);
      return;
    }

    final bool fromRefresh =
        err.requestOptions.extra[_skipRefreshKey] == true ||
            err.requestOptions.path.startsWith('/auth/refresh');
    // Don't try to refresh if the failing call **is** the refresh itself.
    // That path should fall straight through to session-expired.
    if (fromRefresh) {
      await _expireSession();
      handler.next(err);
      return;
    }

    final String? code = _readErrorCode(response?.data);
    if (code != 'TOKEN_EXPIRED') {
      // Any other 401 is unrecoverable — drop the session so the router
      // kicks the user back to `/login`.
      await _expireSession();
      handler.next(err);
      return;
    }

    try {
      final String? newAccess = await _refreshOnce();
      if (newAccess == null) {
        handler.next(err);
        return;
      }
      // Retry with the refreshed token.
      final retried = await _retry(err.requestOptions, newAccess);
      handler.resolve(retried);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Shares a single in-flight `/auth/refresh` across concurrent 401s.
  /// Returns the new access token, or null on hard failure.
  Future<String?> _refreshOnce() async {
    final existing = _inflightRefresh;
    if (existing != null) {
      return existing.future;
    }
    final Completer<String?> completer = Completer<String?>();
    _inflightRefresh = completer;

    try {
      final String? refresh = await _storage.readRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        await _expireSession();
        completer.complete(null);
        return null;
      }

      // Fire a refresh request back through the same dio so tests and callers
      // share a single HTTP adapter. `_skipRefresh` in `extra` tells our own
      // [onError] hook below to pass the error straight through instead of
      // attempting another refresh (no recursion).
      final Response<Map<String, dynamic>> resp =
          await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: <String, dynamic>{'refresh_token': refresh},
        options: Options(extra: <String, dynamic>{_skipRefreshKey: true}),
      );
      final data = resp.data;
      if (data == null) {
        await _expireSession();
        completer.complete(null);
        return null;
      }
      final String newAccess = data['access_token'] as String;
      final String newRefresh = data['refresh_token'] as String;
      await _storage.saveAccessToken(newAccess);
      await _storage.saveRefreshToken(newRefresh);
      completer.complete(newAccess);
      return newAccess;
    } catch (e) {
      await _expireSession();
      completer.complete(null);
      return null;
    } finally {
      _inflightRefresh = null;
    }
  }

  Future<Response<dynamic>> _retry(
    RequestOptions original,
    String newAccess,
  ) async {
    final Options options = Options(
      method: original.method,
      headers: <String, dynamic>{
        ...original.headers,
        'Authorization': 'Bearer $newAccess',
      },
      responseType: original.responseType,
      contentType: original.contentType,
      followRedirects: original.followRedirects,
      receiveDataWhenStatusError: original.receiveDataWhenStatusError,
      extra: original.extra,
    );
    return _dio.request<dynamic>(
      original.path,
      data: original.data,
      queryParameters: original.queryParameters,
      cancelToken: original.cancelToken,
      options: options,
      onReceiveProgress: original.onReceiveProgress,
      onSendProgress: original.onSendProgress,
    );
  }

  Future<void> _expireSession() async {
    await _storage.clearTokens();
    _onSessionExpired();
  }

  String? _readErrorCode(Object? data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final code = error['code'];
        if (code is String) {
          return code;
        }
      }
    }
    return null;
  }
}
