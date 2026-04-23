import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper over [FlutterSecureStorage] so the rest of the app only sees
/// domain-shaped APIs (accessToken / refreshToken) instead of raw keys.
class SecureStorage {
  SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // -- Generic single-value surface (M3 · reading session persistence) -------
  //
  // The timer feature persists its active-session snapshot under an
  // arbitrary namespaced key (`reading.active_session`). Exposing a raw
  // read/write/delete trio here keeps the whole of `SecureStorage` as the
  // single gate onto FlutterSecureStorage — feature code never constructs
  // the platform plugin directly.
  Future<String?> readRaw(String key) => _storage.read(key: key);

  Future<void> writeRaw(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> deleteRaw(String key) => _storage.delete(key: key);
}

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage(const FlutterSecureStorage());
});
