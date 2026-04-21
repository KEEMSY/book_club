import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:book_club/core/network/auth_interceptor.dart';
import 'package:book_club/core/network/refresh_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../features/auth/fakes.dart';

/// Deterministic [HttpClientAdapter] that answers from a programmable map.
/// We route responses by `method + path` to keep the API compact; tests can
/// re-bind an endpoint between steps (i.e. first 401, then refreshed 200).
class _FakeAdapter implements HttpClientAdapter {
  final Map<String, ResponseBody Function(RequestOptions options)> handlers =
      <String, ResponseBody Function(RequestOptions)>{};

  final List<RequestOptions> requests = <RequestOptions>[];

  void bind(
    String method,
    String path,
    ResponseBody Function(RequestOptions options) responder,
  ) {
    handlers['$method $path'] = responder;
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final responder = handlers['${options.method} ${options.path}'];
    if (responder == null) {
      return ResponseBody.fromString(
        jsonEncode(<String, dynamic>{
          'error': <String, String>{
            'code': 'UNHANDLED',
            'message': 'no binding',
          },
        }),
        500,
      );
    }
    return responder(options);
  }
}

ResponseBody _json(Object body, int status) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: <String, List<String>>{
      'content-type': <String>['application/json'],
    },
  );
}

void main() {
  group('AuthInterceptor', () {
    test('attaches Authorization for non-/auth paths', () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('stored-access');

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final adapter = _FakeAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(storage));

      adapter.bind('GET', '/me', (_) => _json({'ok': true}, 200));

      await dio.get<dynamic>('/me');

      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer stored-access',
      );
    });

    test('skips Authorization on /auth/* paths (login / refresh)', () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('stored-access');

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final adapter = _FakeAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(storage));

      adapter.bind('POST', '/auth/kakao', (_) => _json({'ok': true}, 200));

      await dio.post<dynamic>('/auth/kakao', data: <String, dynamic>{});

      expect(adapter.requests.single.headers['Authorization'], isNull);
    });

    test('attaches Authorization for /auth/device-tokens (it needs auth)',
        () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('stored-access');

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final adapter = _FakeAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(storage));

      adapter.bind(
        'POST',
        '/auth/device-tokens',
        (_) => _json({'ok': true}, 204),
      );

      await dio.post<dynamic>(
        '/auth/device-tokens',
        data: <String, dynamic>{},
      );

      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer stored-access',
      );
    });
  });

  group('RefreshInterceptor', () {
    test(
        'refreshes on 401 TOKEN_EXPIRED and retries the original request '
        'with the new access token', () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('old-access');
      await storage.saveRefreshToken('old-refresh');

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final adapter = _FakeAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(storage));
      bool expired = false;
      dio.interceptors.add(
        RefreshInterceptor(
          dio: dio,
          storage: storage,
          onSessionExpired: () => expired = true,
        ),
      );

      // First call to /me -> 401 TOKEN_EXPIRED; second call -> 200.
      int meCalls = 0;
      adapter.bind('GET', '/me', (options) {
        meCalls++;
        if (meCalls == 1) {
          return _json(
            <String, dynamic>{
              'error': <String, String>{
                'code': 'TOKEN_EXPIRED',
                'message': 'expired',
              },
            },
            401,
          );
        }
        return _json(<String, String>{'ok': 'retry'}, 200);
      });

      adapter.bind('POST', '/auth/refresh', (_) {
        return _json(
          <String, dynamic>{
            'access_token': 'fresh-access',
            'refresh_token': 'fresh-refresh',
            'token_type': 'Bearer',
            'expires_in': 3600,
          },
          200,
        );
      });

      final Response<dynamic> res = await dio.get<dynamic>('/me');

      expect(res.statusCode, 200);
      expect(await storage.readAccessToken(), 'fresh-access');
      expect(await storage.readRefreshToken(), 'fresh-refresh');
      expect(meCalls, 2, reason: 'original call should be retried once');
      expect(expired, isFalse);
    });

    test('clears tokens and flags session expired on refresh failure',
        () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('old-access');
      await storage.saveRefreshToken('old-refresh');

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final adapter = _FakeAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(storage));
      bool expired = false;
      dio.interceptors.add(
        RefreshInterceptor(
          dio: dio,
          storage: storage,
          onSessionExpired: () => expired = true,
        ),
      );

      adapter.bind('GET', '/me', (_) {
        return _json(
          <String, dynamic>{
            'error': <String, String>{
              'code': 'TOKEN_EXPIRED',
              'message': 'expired',
            },
          },
          401,
        );
      });
      adapter.bind('POST', '/auth/refresh', (_) {
        return _json(
          <String, dynamic>{
            'error': <String, String>{
              'code': 'TOKEN_INVALID',
              'message': 'refresh revoked',
            },
          },
          401,
        );
      });

      try {
        await dio.get<dynamic>('/me');
        fail('expected a DioException after refresh failure');
      } on DioException {
        // expected
      }

      expect(expired, isTrue);
      expect(await storage.readAccessToken(), isNull);
      expect(await storage.readRefreshToken(), isNull);
    });

    test('non-TOKEN_EXPIRED 401 codes short-circuit to session expired',
        () async {
      final storage = InMemorySecureStorage();
      await storage.saveAccessToken('old-access');
      await storage.saveRefreshToken('old-refresh');

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final adapter = _FakeAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(storage));
      bool expired = false;
      dio.interceptors.add(
        RefreshInterceptor(
          dio: dio,
          storage: storage,
          onSessionExpired: () => expired = true,
        ),
      );

      adapter.bind('GET', '/me', (_) {
        return _json(
          <String, dynamic>{
            'error': <String, String>{
              'code': 'USER_GONE',
              'message': 'deleted',
            },
          },
          401,
        );
      });

      try {
        await dio.get<dynamic>('/me');
        fail('expected a DioException');
      } on DioException {
        // expected
      }

      expect(expired, isTrue);
      expect(await storage.readAccessToken(), isNull);
    });
  });
}
