import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_interceptor.dart';

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
    return 'http://localhost:8000';
  }
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://localhost:8000';
}

/// Short human-readable label of the current API target. Handy for debug UI.
String currentEnvLabel() => resolveApiBaseUrl();

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
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
  dio.interceptors.add(ErrorInterceptor());
  return dio;
});
