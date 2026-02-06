import 'package:nashik/core/error/exceptions/api_exception.dart';
import 'package:nashik/core/network/api_client.dart';
import 'package:nashik/core/network/api_endpoints.dart';

import '../models/category_response_model.dart';
import '../models/list_categories_response_model.dart';

abstract class CategoryRemoteDataSource {
  Future<ListCategoriesResponseModel> getCategories({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? name,
  });

  Future<CategoryResponseModel> getCategoryById(String id);
  Future<CategoryResponseModel> getCategoryBySlug(String slug);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<ListCategoriesResponseModel> getCategories({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? name,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (status != null) queryParams['status'] = status;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    if (slug != null && slug.isNotEmpty) queryParams['slug'] = slug;
    if (name != null && name.isNotEmpty) queryParams['name'] = name;

    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.categories,
      queryParameters: queryParams,
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
      throw const ApiException(message: 'Invalid categories response');
    }
    return ListCategoriesResponseModel.fromJson(data);
  }

  @override
  Future<CategoryResponseModel> getCategoryById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.categoryById(id),
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
      throw const ApiException(message: 'Invalid category response');
    }
    return CategoryResponseModel.fromJson(data);
  }

  @override
  Future<CategoryResponseModel> getCategoryBySlug(String slug) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.categoryBySlug(slug),
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
      throw const ApiException(message: 'Invalid category response');
    }
    return CategoryResponseModel.fromJson(data);
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
