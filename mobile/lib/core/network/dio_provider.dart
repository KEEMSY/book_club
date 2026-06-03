import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'refresh_interceptor.dart';

part 'dio_provider.g.dart';

/// Base URL for the Book Club API.
///
/// Priority:
/// 1. `--dart-define=API_BASE_URL=...` (CI, staging, production builds)
/// 2. Platform-specific localhost fallback so `flutter run` works out of the
///    box on iOS simulators (127.0.0.1) and the Android emulator (10.0.2.2,
///    which maps to the host machine's localhost).
String resolveApiBaseUrl() {
  const fromDefine = String.fromEnvironment('API_BASE_URL');
  if (fromDefine.isNotEmpty) {
    return fromDefine;
  }
  if (kIsWeb) {
    // Browser treats localhost and 127.0.0.1 as different origins; use
    // localhost so the backend CORS regex (http://localhost(:\d+)?) matches.
    return 'http://localhost:8000';
  }
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://127.0.0.1:8000';
}

/// Short human-readable label of the current API target. Handy for debug UI.
String currentEnvLabel() => resolveApiBaseUrl();

/// Callback invoked by [RefreshInterceptor] when the refresh itself fails.
///
/// We can't depend on `authNotifierProvider` here without pulling the auth
/// feature into core/, so the dio provider exposes a void-return hook and
/// the auth feature registers a listener in [attachAuthSessionBridge] (in
/// `application/auth_providers.dart` adjacent bridge) — but for M1 we keep
/// it simple: the RefreshInterceptor calls [sessionExpiredSignalProvider]'s
/// `notify()` method which toggles a counter that the `authNotifierProvider`
/// watches.
class SessionExpiredSignal {
  SessionExpiredSignal(this._onExpired);

  final void Function() _onExpired;

  void notify() => _onExpired();
}

/// Signal surface the RefreshInterceptor writes to when it drops tokens.
/// The auth feature reads this through a Provider and forces the notifier
/// to [AuthState.unauthenticated]. Kept here so core/network stays free of
/// direct auth-feature imports.
@riverpod
class SessionExpiredBroadcast extends _$SessionExpiredBroadcast {
  @override
  int build() => 0;

  void increment() => state += 1;
}

@riverpod
Dio dio(DioRef ref) {
  final instance = Dio(
    BaseOptions(
      baseUrl: resolveApiBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  final SecureStorage storage = ref.watch(secureStorageProvider);

  // Order matters:
  //   1. AuthInterceptor attaches the bearer on the outbound request.
  //   2. RefreshInterceptor catches 401s on the inbound response and retries.
  //   3. ErrorInterceptor maps leftover DioException -> AppException so the
  //      UI layer sees typed failures.
  instance.interceptors.add(AuthInterceptor(storage));
  instance.interceptors.add(
    RefreshInterceptor(
      dio: instance,
      storage: storage,
      onSessionExpired: () {
        // Bump the broadcast counter — listeners (auth_providers.dart)
        // react by forcing Unauthenticated state.
        ref.read(sessionExpiredBroadcastProvider.notifier).increment();
      },
    ),
  );
  instance.interceptors.add(ErrorInterceptor());
  return instance;
}
