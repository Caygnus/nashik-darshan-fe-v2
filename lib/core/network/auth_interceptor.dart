import 'package:dio/dio.dart';
import 'package:nashik/core/storage/secure_token_storage.dart';

/// Attaches Bearer token from [SecureTokenStorage].
/// Skips header if token is null. On 401 calls [onUnauthorized] and clears token.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureTokenStorage tokenStorage,
    void Function()? onUnauthorized,
  })  : _tokenStorage = tokenStorage,
        _onUnauthorized = onUnauthorized;

  final SecureTokenStorage _tokenStorage;
  final void Function()? _onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  /// Handles 401 when it is delivered as a response (e.g. if validateStatus
  /// accepts 401). When 401 is treated as an error, [onError] runs instead.
  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      await _tokenStorage.deleteAccessToken();
      _onUnauthorized?.call();
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _tokenStorage.deleteAccessToken();
      _onUnauthorized?.call();
    }
    handler.next(err);
  }
}
