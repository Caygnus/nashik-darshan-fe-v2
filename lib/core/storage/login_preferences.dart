import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists "Remember me" and optional saved email for the login form.
/// Only the email is stored when "remember me" is true; password is never stored.
abstract class LoginPreferences {
  Future<bool> getRememberMe();
  Future<String?> getSavedEmail();
  Future<void> setRememberMe(bool value);
  Future<void> setSavedEmail(String? email);
  Future<void> clear();
}

class LoginPreferencesImpl implements LoginPreferences {
  LoginPreferencesImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  static const String _keyRememberMe = 'nashik_login_remember_me';
  static const String _keySavedEmail = 'nashik_login_saved_email';
  final FlutterSecureStorage _storage;

  @override
  Future<bool> getRememberMe() async {
    try {
      final value = await _storage.read(key: _keyRememberMe);
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> getSavedEmail() async {
    try {
      return await _storage.read(key: _keySavedEmail);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setRememberMe(bool value) async {
    try {
      await _storage.write(key: _keyRememberMe, value: value.toString());
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> setSavedEmail(String? email) async {
    try {
      if (email == null || email.isEmpty) {
        await _storage.delete(key: _keySavedEmail);
      } else {
        await _storage.write(key: _keySavedEmail, value: email);
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _storage.delete(key: _keyRememberMe);
      await _storage.delete(key: _keySavedEmail);
    } catch (_) {
      rethrow;
    }
  }
}
