import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists and retrieves the API access token.
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
  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  @override
  Future<void> setAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  @override
  Future<void> deleteAccessToken() => _storage.delete(key: _keyAccessToken);
}
