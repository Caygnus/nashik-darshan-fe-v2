import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/core/supabase/supabase_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Supabase Postgres access via the client.
/// Use only after [SupabaseConfig.initialize()]. All tables must have RLS enabled
/// and policies that allow authenticated users / user-owned data as needed.
class SupabaseDatabaseService {
  SupabaseDatabaseService._();

  static SupabaseClient get _client => SupabaseConfig.client;

  /// Select from [table]. Returns all rows (use [column]/[value] for filter).
  /// Fails if RLS policies deny access.
  static Future<List<Map<String, dynamic>>> from(
    String table, {
    String? column,
    Object? value,
  }) async {
    try {
      SupabaseLogger.db('Select from $table');
      dynamic builder = _client.from(table).select();
      if (column != null && value != null) {
        builder = builder.eq(column, value);
      }
      final data = await builder;
      final list = List<Map<String, dynamic>>.from((data as List).map((e) => Map<String, dynamic>.from(e as Map)));
      SupabaseLogger.db('Select from $table: ${list.length} rows');
      return list;
    } catch (e) {
      SupabaseLogger.error('DB select $table failed', e);
      rethrow;
    }
  }

  /// Select a single row by [column] = [value] from [table].
  static Future<Map<String, dynamic>?> fromSingle(
    String table, {
    required String column,
    required Object value,
  }) async {
    try {
      SupabaseLogger.db('Select single from $table by $column');
      final result = await _client.from(table).select().eq(column, value).limit(1).maybeSingle();
      if (result == null) return null;
      return Map<String, dynamic>.from(result as Map);
    } catch (e) {
      SupabaseLogger.error('DB select single $table failed', e);
      rethrow;
    }
  }

  /// Insert [data] into [table]. Returns inserted row(s) if [returning] is true.
  static Future<List<Map<String, dynamic>>> insert(
    String table,
    Map<String, dynamic> data, {
    bool returning = true,
  }) async {
    try {
      SupabaseLogger.db('Insert into $table');
      if (!returning) {
        await _client.from(table).insert(data);
        SupabaseLogger.db('Insert into $table success');
        return [];
      }
      final res = await _client.from(table).insert(data).select();
      final list = List<Map<String, dynamic>>.from((res as List).map((e) => Map<String, dynamic>.from(e as Map)));
      SupabaseLogger.db('Insert into $table success');
      return list;
    } catch (e) {
      SupabaseLogger.error('DB insert $table failed', e);
      rethrow;
    }
  }

  /// Update [table] where [column] = [value] with [data].
  static Future<void> update(
    String table, {
    required String column,
    required Object value,
    required Map<String, dynamic> data,
  }) async {
    try {
      SupabaseLogger.db('Update $table where $column');
      await _client.from(table).update(data).eq(column, value);
      SupabaseLogger.db('Update $table success');
    } catch (e) {
      SupabaseLogger.error('DB update $table failed', e);
      rethrow;
    }
  }

  /// Delete from [table] where [column] = [value].
  static Future<void> delete(
    String table, {
    required String column,
    required Object value,
  }) async {
    try {
      SupabaseLogger.db('Delete from $table where $column');
      await _client.from(table).delete().eq(column, value);
      SupabaseLogger.db('Delete from $table success');
    } catch (e) {
      SupabaseLogger.error('DB delete $table failed', e);
      rethrow;
    }
  }

  /// Raw table access for advanced queries. Prefer [from], [insert], [update], [delete].
  static dynamic fromTable(String table) {
    return _client.from(table);
  }
}
