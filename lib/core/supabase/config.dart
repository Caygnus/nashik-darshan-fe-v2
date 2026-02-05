// ignore_for_file: constant_identifier_names

import 'dart:developer' as developer;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

/// Supabase configuration and global instance manager.
/// Uses anon (publishable) key only; service_role must never be used in client code.
class SupabaseConfig {
  // Environment variable keys (client-safe anon key only)
  static const String SUPABASE_URL_KEY = 'SUPABASE_URL';
  static const String SUPABASE_PUBLISHABLE_KEY = 'SUPABASE_PUBLISHABLE_KEY';

  /// Reject any key that looks like service_role (security: never in client)
  static const String _serviceRoleHint = 'service_role';

  // Singleton instance
  static SupabaseConfig? _instance;
  static SupabaseClient? _client;

  SupabaseConfig._internal();

  /// Get singleton instance
  static SupabaseConfig get instance {
    if (_instance == null) {
      throw Exception(
        'SupabaseConfig not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initialize Supabase exactly once, before runApp.
  /// Env must be loaded first (Config.instance) so dotenv is available.
  static Future<SupabaseConfig> initialize() async {
    if (_instance != null) {
      developer.log('Supabase already initialized, reusing instance');
      return _instance!;
    }

    try {
      final supabaseUrl = dotenv.get(SUPABASE_URL_KEY).trim();
      final supabaseAnonKey = dotenv.get(SUPABASE_PUBLISHABLE_KEY).trim();

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception(
          'Supabase URL or Anon Key is missing in .env. '
          'Required: SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY (use anon key, never service_role).',
        );
      }

      if (supabaseAnonKey.toLowerCase().contains(_serviceRoleHint)) {
        throw Exception(
          'SUPABASE_PUBLISHABLE_KEY must be the anon (public) key. '
          'Never use service_role in client apps.',
        );
      }

      developer.log('Supabase: initializing with PKCE auth flow');
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );

      _client = Supabase.instance.client;
      _instance = SupabaseConfig._internal();
      developer.log('Supabase: initialized successfully');
      return _instance!;
    } catch (e) {
      developer.log('Supabase initialization failed', error: e);
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  /// Global Supabase client (exposed via Supabase.instance.client).
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase client not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _client!;
  }
}
