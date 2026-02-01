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

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.statusCode == 401) {
      _tokenStorage.deleteAccessToken();
      _onUnauthorized?.call();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _tokenStorage.deleteAccessToken();
      _onUnauthorized?.call();
    }
    handler.next(err);
  }
}
