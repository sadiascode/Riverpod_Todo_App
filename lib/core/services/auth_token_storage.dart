import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists auth tokens and a JSON-encoded copy of the current user using
/// the platform keystore-backed secure storage.
///
/// Use [read] / [write] / [clear] through the methods that always return a
/// nullable `accessToken` / `refreshToken`. Callers should treat a missing
/// value as "logged out".
class AuthTokenStorage {
  static const _accessTokenKey = 'auth.access_token';
  static const _refreshTokenKey = 'auth.refresh_token';
  static const _userKey = 'auth.user';

  final FlutterSecureStorage _storage;

  AuthTokenStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  /// Reads all three slots in a single read pass.
  Future<
    ({String? accessToken, String? refreshToken, Map<String, dynamic>? user})
  >
  read() async {
    final results = await _storage.readAll();
    final rawUser = results[_userKey];
    Map<String, dynamic>? userJson;
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawUser);
        if (decoded is Map<String, dynamic>) userJson = decoded;
      } catch (_) {
        // Corrupt user blob — ignore; caller will fall back to "no session".
      }
    }
    return (
      accessToken: results[_accessTokenKey],
      refreshToken: results[_refreshTokenKey],
      user: userJson,
    );
  }

  Future<String?> readAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> readRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Persists both tokens together so they can never get out of sync.
  /// Optionally stores the [user] payload so we can rehydrate the session.
  Future<void> write({
    required String accessToken,
    required String refreshToken,
    Map<String, dynamic>? user,
  }) async {
    final writes = <Future<void>>[
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ];
    if (user != null) {
      writes.add(_storage.write(key: _userKey, value: jsonEncode(user)));
    }
    await Future.wait(writes);
  }

  /// Replaces just the tokens (used after a successful refresh where the
  /// user payload is unchanged).
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return write(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userKey),
    ]);
  }
}
