import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists and retrieves the API access token.
///
/// Implementations may throw (e.g. [PlatformException] on KeyStore/Keychain
/// failures). Callers of [setAccessToken] and [deleteAccessToken] should
/// handle exceptions; [getAccessToken] returns null on storage errors.
abstract class SecureTokenStorage {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String token);
  Future<void> deleteAccessToken();
}

class SecureTokenStorageImpl implements SecureTokenStorage {
  SecureTokenStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  static const String _keyAccessToken = 'nashik_api_access_token';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _keyAccessToken);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setAccessToken(String token) async {
    try {
      await _storage.write(key: _keyAccessToken, value: token);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: _keyAccessToken);
    } catch (_) {
      rethrow;
    }
  }
}
