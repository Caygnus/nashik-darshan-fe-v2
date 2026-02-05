import 'package:nashik/core/error/exceptions/app_exception.dart';

/// Thrown when the Nashik API returns an error (4xx/5xx or network).
class ApiException extends AppException {
  const ApiException({
    required super.message,
    super.code,
    this.statusCode,
    this.data,
  });

  final int? statusCode;
  final dynamic data;

  @override
  String toString() => 'ApiException: $message (statusCode: $statusCode)';

  bool get isBadRequest => statusCode == 400;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isServerError => statusCode != null && statusCode! >= 500;
}
