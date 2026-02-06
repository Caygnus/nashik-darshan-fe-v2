import 'package:nashik/core/error/exceptions/api_exception.dart';
import 'package:nashik/core/network/api_client.dart';
import 'package:nashik/core/network/api_endpoints.dart';
import 'package:nashik/core/storage/secure_token_storage.dart';
import 'package:nashik/features/auth/data/models/signup_request_model.dart';
import 'package:nashik/features/auth/data/models/signup_response_model.dart';
import 'package:nashik/features/auth/data/models/update_user_request_model.dart';
import 'package:nashik/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignupResponseModel> signup(SignupRequestModel request);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(UpdateUserRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
    required SecureTokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  final ApiClient _apiClient;
  final SecureTokenStorage _tokenStorage;

  @override
  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.authSignup,
      data: request.toJson(),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw ApiException(
        message: _parseError(response.data),
        statusCode: response.statusCode,
        data: response.data,
      );
    }
    final data = response.data as Map<String, dynamic>?;
    if (data == null) {
      throw const ApiException(message: 'Invalid signup response');
    }
    final model = SignupResponseModel.fromJson(data);
    await _tokenStorage.setAccessToken(model.accessToken);
    return model;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.userMe,
    );
    if (response.statusCode != 200) {
      throw ApiException(
        message: _parseError(response.data),
        statusCode: response.statusCode,
        data: response.data,
      );
    }
    final data = response.data as Map<String, dynamic>?;
    if (data == null) {
      throw const ApiException(message: 'Invalid user response');
    }
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateUser(UpdateUserRequestModel request) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      ApiEndpoints.user,
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw ApiException(
        message: _parseError(response.data),
        statusCode: response.statusCode,
        data: response.data,
      );
    }
    final data = response.data as Map<String, dynamic>?;
    if (data == null) {
      throw const ApiException(message: 'Invalid user response');
    }
    return UserModel.fromJson(data);
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
