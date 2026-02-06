// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // Keys (constants)
  static const API_BASE_URL = 'API_BASE_URL';
  static const GOOGLE_WEB_CLIENT_ID = 'GOOGLE_WEB_CLIENT_ID';

  // Internal singleton fields
  static Future<Config>? _loader;
  static Config? _instance;

  Config._internal();

  // This allows: await Config.instance;
  static Future<Config> get instance {
    _loader ??= _load();
    return _loader!;
  }

  static Future<Config> _load() async {
    try {
      // Load .env from assets bundle
      // Note: After adding .env to pubspec.yaml, you must rebuild the app
      // Run: flutter clean && flutter pub get && flutter run
      await dotenv.load();
    } catch (e) {
      // Check if it's a FileNotFoundError
      if (e.toString().contains('FileNotFoundError') ||
          e.toString().contains('Unable to load asset')) {
        throw Exception(
          '❌ .env file not found in assets bundle!\n\n'
          '📋 To fix this, please:\n'
          '1. Stop the app completely\n'
          '2. Run: flutter clean\n'
          '3. Run: flutter pub get\n'
          '4. Run: flutter run (full rebuild required)\n\n'
          '⚠️  Hot reload/restart will NOT work - you need a full rebuild!\n\n'
          'Required variables: API_BASE_URL, SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY',
        );
      }
      throw Exception(
        'Failed to load .env file: $e\n'
        'Please ensure .env file exists in root directory and is listed in pubspec.yaml assets.',
      );
    }
    _instance = Config._internal();
    return _instance!;
  }

  // Sync accessor after initialization
  static Config get I {
    if (_instance == null) {
      throw Exception('Config not initialized. Await Config.instance first.');
    }
    return _instance!;
  }

  // Internal method to get values from dotenv
  String _get(String key) {
    return dotenv.get(key);
  }

  // Typed getters
  String get baseUrl => _get(API_BASE_URL);
  String get googleWebClientId => _get(GOOGLE_WEB_CLIENT_ID);
}
