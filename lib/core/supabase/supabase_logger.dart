import 'dart:developer' as developer;

/// Central logging for Supabase (init, auth, OAuth, errors).
/// Use this instead of print so logs can be filtered and are consistent.
class SupabaseLogger {
  SupabaseLogger._();

  static const String _tag = 'Supabase';

  static void init(String message) {
    developer.log(message, name: _tag);
  }

  static void auth(String message, {String? action}) {
    developer.log('[Auth]${action != null ? ' $action: ' : ' '}$message', name: _tag);
  }

  static void oauth(String message, {bool error = false}) {
    developer.log('${error ? '[OAuth Error] ' : '[OAuth] '}$message', name: _tag);
  }

  static void storage(String message, {String? bucket}) {
    developer.log('[Storage]${bucket != null ? ' $bucket: ' : ' '}$message', name: _tag);
  }

  static void db(String message, {String? table}) {
    developer.log('[DB]${table != null ? ' $table: ' : ' '}$message', name: _tag);
  }

  static void error(String message, [Object? error, StackTrace? st]) {
    developer.log('Error: $message', name: _tag, error: error, stackTrace: st);
  }
}
