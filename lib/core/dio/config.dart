import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nashik/core/env/config.dart';
import 'package:nashik/core/error/exceptions/app_exception.dart';
import 'package:nashik/core/error/exceptions/network_exception.dart';
import 'package:nashik/core/error/exceptions/server_exception.dart';
import 'package:nashik/core/supabase/config.dart';

/// Optimized DioClient with comprehensive error handling and interceptors
class DioClient {
  DioClient({
    final String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? defaultHeaders,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl ?? Config.I.baseUrl,
           connectTimeout: connectTimeout ?? const Duration(seconds: 30),
           receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
           sendTimeout: sendTimeout ?? const Duration(seconds: 30),
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
             ...?defaultHeaders,
           },
           validateStatus: (status) {
             return status != null && status >= 200 && status < 300;
           },
         ),
       ) {
    _setupInterceptors();
  }
  final Dio _dio;

  /// Setup all interceptors
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _AuthInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// Get the underlying Dio instance
  Dio get dio => _dio;

  /// GET request
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      log('Unexpected error in GET request: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String endpoint, {
    final data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      log('Unexpected error in POST request: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      log('Unexpected error in PUT request: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      log('Unexpected error in PATCH request: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      log('Unexpected error in DELETE request: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  /// Handle DioException and convert to appropriate AppException
  AppException _handleDioException(DioException e) {
    int? statusCode;
    dynamic responseData;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();
      case DioExceptionType.badResponse:
        statusCode = e.response?.statusCode;
        responseData = e.response?.data;
        String message;
        if (responseData is Map) {
          final errorObj = responseData['error'];
          if (errorObj is Map) {
            message =
                errorObj['message'] as String? ??
                errorObj['errorMsg'] as String? ??
                responseData['errorMsg'] as String? ??
                responseData['message'] as String? ??
                'Server error occurred';
          } else {
            message =
                responseData['errorMsg'] as String? ??
                responseData['message'] as String? ??
                errorObj?.toString() ??
                'Server error occurred';
          }
        } else if (responseData is String) {
          message = responseData;
        } else {
          message =
              'Server error: ${e.response?.statusMessage ?? 'Unknown error'}';
        }
        log('DioException: $message (Status: $statusCode, Type: ${e.type})');
        return ServerException(
          message: message,
          statusCode: statusCode,
          data: responseData,
          code: statusCode?.toString(),
        );
      case DioExceptionType.cancel:
        return const ServerException(
          message: 'Request was cancelled',
          code: 'REQUEST_CANCELLED',
        );
      case DioExceptionType.connectionError:
        return NetworkException.noInternet();
      case DioExceptionType.badCertificate:
        return const ServerException(
          message: 'Certificate error. Please contact support.',
          code: 'BAD_CERTIFICATE',
        );
      case DioExceptionType.unknown:
        final message = e.message ?? 'An unknown error occurred';
        log('DioException: $message (Type: ${e.type})');
        if (e.error != null) {
          return NetworkException.connectionError();
        }
        return ServerException(message: message, code: 'UNKNOWN_ERROR');
    }
  }

  /// Update default headers
  void updateHeaders(final Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Clear default headers
  void clearHeaders() {
    _dio.options.headers.clear();
  }

  /// Set authentication token manually
  void setAuthToken(final String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

/// Logging interceptor for request/response logging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    log('┌─────────────────────────────────────────────────────────────');
    log('│ REQUEST: ${options.method} ${options.uri}');
    log('│ Headers: ${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      log('│ Query Parameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      log('│ Body: ${options.data}');
    }
    log('└─────────────────────────────────────────────────────────────');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    final Response response,
    final ResponseInterceptorHandler handler,
  ) {
    log('┌─────────────────────────────────────────────────────────────');
    log('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    log('│ Data: ${response.data}');
    log('└─────────────────────────────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, final ErrorInterceptorHandler handler) {
    log('┌─────────────────────────────────────────────────────────────');
    log('│ ERROR: ${err.type}');
    log('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
    log('│ Status: ${err.response?.statusCode}');
    log('│ Message: ${err.message}');
    if (err.response?.data != null) {
      log('│ Response Data: ${err.response?.data}');
    }
    log('└─────────────────────────────────────────────────────────────');
    super.onError(err, handler);
  }
}

/// Authentication interceptor for adding Supabase access tokens
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor();

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    try {
      // Get Supabase client instance from global config
      final supabase = SupabaseConfig.client;

      // Get current session and access token
      final session = supabase.auth.currentSession;

      if (session != null && session.accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
    } catch (e) {
      log('Error getting Supabase auth token: $e');
    }
    super.onRequest(options, handler);
  }
}

/// Error interceptor for handling common error scenarios
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, final ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token might be expired
    if (err.response?.statusCode == 401) {
      log('Unauthorized access - token may be expired or invalid');
      // Sign out asynchronously without blocking error handling
      SupabaseConfig.client.auth.signOut().catchError((final e) {
        log('Error signing out from Supabase: $e');
      });
    }

    // Handle 403 Forbidden
    if (err.response?.statusCode == 403) {
      log('Forbidden - insufficient permissions');
    }

    // Handle 404 Not Found
    if (err.response?.statusCode == 404) {
      log('Resource not found');
    }

    // Handle 500+ Server Errors
    if (err.response?.statusCode != null && err.response!.statusCode! >= 500) {
      log('Server error - ${err.response?.statusCode}');
    }

    super.onError(err, handler);
  }
}
