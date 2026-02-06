import 'package:nashik/core/error/exceptions/api_exception.dart';
import 'package:nashik/core/network/api_client.dart';
import 'package:nashik/core/network/api_endpoints.dart';

/// Raw result from POST /health (body + status).
class HealthCheckRaw {
  const HealthCheckRaw(this.body, this.statusCode);
  final Map<String, dynamic> body;
  final int? statusCode;
}

abstract class HealthRemoteDataSource {
  /// POST /health - validates token; returns 200 OK or 401 Unauthorized.
  Future<HealthCheckRaw> check();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  HealthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<HealthCheckRaw> check() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.health,
    );
    if (response.statusCode != null &&
        response.statusCode != 200 &&
        response.statusCode != 401) {
      throw ApiException(
        message: _parseError(response.data),
        statusCode: response.statusCode,
        data: response.data,
      );
    }
    final data = response.data as Map<String, dynamic>?;
    final body = data != null ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    return HealthCheckRaw(body, response.statusCode);
  }

  String _parseError(dynamic data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return error['message'] as String? ?? 'Request failed';
      }
    }
    return 'Request failed';
  }
}
