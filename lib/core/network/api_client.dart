import 'package:dio/dio.dart';
import 'package:nashik/core/error/exceptions/api_exception.dart';
import 'package:nashik/core/network/api_endpoints.dart';
import 'package:nashik/core/network/auth_interceptor.dart';
import 'package:nashik/core/storage/secure_token_storage.dart';

/// Dio-based client for Nashik Darshan API.
/// Base URL configurable via [baseUrl]. Attaches Bearer token via [AuthInterceptor].
/// Maps Dio errors to [ApiException].
class ApiClient {
  ApiClient({
    String? baseUrl,
    SecureTokenStorage? tokenStorage,
    void Function()? onUnauthorized,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  })  : _baseUrl = baseUrl ?? ApiEndpoints.baseUrl,
        _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
            connectTimeout: connectTimeout ?? const Duration(seconds: 30),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
            sendTimeout: sendTimeout ?? const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            validateStatus: (status) => status != null && status >= 200 && status < 300,
          ),
        ) {
    _dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage ?? SecureTokenStorageImpl(),
        onUnauthorized: onUnauthorized,
      ),
    );
  }

  final String _baseUrl;
  final Dio _dio;

  String get baseUrl => _baseUrl;
  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _mapToApiException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapToApiException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapToApiException(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapToApiException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapToApiException(e);
    }
  }

  ApiException _mapToApiException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String message = 'An error occurred';

    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        message = error['message'] as String? ?? message;
      } else if (data['message'] != null) {
        message = data['message'].toString();
      }
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Request timed out. Please try again.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          message = 'Session expired. Please sign in again.';
        } else if (statusCode == 404) {
          message = 'Resource not found.';
        } else if (statusCode == 400) {
          message = message;
        } else if (statusCode != null && statusCode >= 500) {
          message = 'Server error. Please try again later.';
        }
        break;
      default:
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      code: statusCode?.toString(),
      data: data,
    );
  }
}
