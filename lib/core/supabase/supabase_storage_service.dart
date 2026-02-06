import 'dart:io';
import 'dart:typed_data';

import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/core/supabase/supabase_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bucket names (create these in Supabase Dashboard → Storage and set policies).
class SupabaseStorageBuckets {
  SupabaseStorageBuckets._();

  /// Public bucket: e.g. avatars, place images (read by anyone).
  static const String public = 'public';

  /// Private bucket: e.g. user uploads (read/write by owner only).
  static const String private = 'private';
}

/// Service for Supabase Storage (upload/download).
/// Use only after [SupabaseConfig.initialize()]. Create buckets and policies
/// in Dashboard (see docs/SUPABASE_STORAGE.md).
class SupabaseStorageService {
  SupabaseStorageService._();

  static SupabaseClient get _client => SupabaseConfig.client;

  /// Upload [file] to [bucket] at [path].
  /// Returns the storage [path]. For public buckets use [getPublicUrl] to get a
  /// URL; for private buckets use [createSignedUrl].
  static Future<String> uploadFile({
    required String bucket,
    required String path,
    required File file,
    FileOptions? options,
  }) async {
    try {
      SupabaseLogger.storage('Upload to $bucket/$path', bucket: bucket);
      await _client.storage.from(bucket).upload(
            path,
            file,
            fileOptions: options ?? const FileOptions(upsert: true),
          );
      SupabaseLogger.storage('Upload success: $path', bucket: bucket);
      return path;
    } catch (e) {
      SupabaseLogger.error('Storage upload $bucket/$path failed', e);
      rethrow;
    }
  }

  /// Upload bytes to [bucket] at [path].
  /// Returns the storage [path]. For public buckets use [getPublicUrl] to get a
  /// URL; for private buckets use [createSignedUrl].
  static Future<String> uploadBytes({
    required String bucket,
    required String path,
    required List<int> bytes,
    FileOptions? options,
  }) async {
    try {
      SupabaseLogger.storage('Upload bytes to $bucket/$path', bucket: bucket);
      await _client.storage.from(bucket).uploadBinary(
            path,
            Uint8List.fromList(bytes),
            fileOptions: options ?? const FileOptions(upsert: true),
          );
      SupabaseLogger.storage('Upload bytes success: $path', bucket: bucket);
      return path;
    } catch (e) {
      SupabaseLogger.error('Storage upload bytes $bucket/$path failed', e);
      rethrow;
    }
  }

  /// Get public URL for [path] in [bucket]. Only valid for public buckets.
  static String getPublicUrl(String bucket, String path) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  /// Download file from [bucket] at [path] (for private bucket use signed URL or auth).
  static Future<List<int>> downloadBytes({
    required String bucket,
    required String path,
  }) async {
    try {
      SupabaseLogger.storage('Download $bucket/$path', bucket: bucket);
      final bytes = await _client.storage.from(bucket).download(path);
      SupabaseLogger.storage('Download success: $path', bucket: bucket);
      return bytes;
    } catch (e) {
      SupabaseLogger.error('Storage download $bucket/$path failed', e);
      rethrow;
    }
  }

  /// Create a signed URL for [path] in [bucket], valid for [expiresIn] seconds.
  static Future<String> createSignedUrl({
    required String bucket,
    required String path,
    int expiresIn = 3600,
  }) async {
    try {
      final result = await _client.storage.from(bucket).createSignedUrl(path, expiresIn);
      return result;
    } catch (e) {
      SupabaseLogger.error('Storage signed URL $bucket/$path failed', e);
      rethrow;
    }
  }

  /// Remove file at [path] in [bucket].
  static Future<void> remove({
    required String bucket,
    required String path,
  }) async {
    try {
      SupabaseLogger.storage('Remove $bucket/$path', bucket: bucket);
      await _client.storage.from(bucket).remove([path]);
      SupabaseLogger.storage('Remove success: $path', bucket: bucket);
    } catch (e) {
      SupabaseLogger.error('Storage remove $bucket/$path failed', e);
      rethrow;
    }
  }
}
