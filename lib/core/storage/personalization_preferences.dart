import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists personalization choices: preferred language and traveler type.
/// Used after signup on the personalize journey page so downstream UI can use them.
abstract class PersonalizationPreferences {
  Future<String?> getPreferredLanguage();
  Future<String?> getTravelerTypeId();
  Future<void> setPreferredLanguage(String language);
  Future<void> setTravelerTypeId(String? travelerTypeId);
  Future<void> clear();
}

class PersonalizationPreferencesImpl implements PersonalizationPreferences {
  PersonalizationPreferencesImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  static const String _keyLanguage = 'nashik_personalization_language';
  static const String _keyTravelerTypeId = 'nashik_personalization_traveler_type_id';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> getPreferredLanguage() async {
    try {
      return await _storage.read(key: _keyLanguage);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getTravelerTypeId() async {
    try {
      return await _storage.read(key: _keyTravelerTypeId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setPreferredLanguage(String language) async {
    try {
      await _storage.write(key: _keyLanguage, value: language);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> setTravelerTypeId(String? travelerTypeId) async {
    try {
      if (travelerTypeId == null || travelerTypeId.isEmpty) {
        await _storage.delete(key: _keyTravelerTypeId);
      } else {
        await _storage.write(key: _keyTravelerTypeId, value: travelerTypeId);
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _storage.delete(key: _keyLanguage);
      await _storage.delete(key: _keyTravelerTypeId);
    } catch (_) {
      rethrow;
    }
  }
}
