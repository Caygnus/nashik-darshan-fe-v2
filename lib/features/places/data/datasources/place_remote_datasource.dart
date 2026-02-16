import 'package:nashik/core/error/exceptions/api_exception.dart';
import 'package:nashik/core/network/api_client.dart';
import 'package:nashik/core/network/api_endpoints.dart';

import '../models/list_places_response_model.dart';
import '../models/place_response_model.dart';

abstract class PlaceRemoteDataSource {
  Future<ListPlacesResponseModel> getPlaces({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? placeTypes,
    String? categoryId,
    String? searchQuery,
    double? minRatingAvg,
    int? minRatingCount,
    double? radiusM,
    String? startTime,
    String? endTime,
    String? expand,
  });

  Future<PlaceResponseModel> getPlaceById(String id);
  Future<PlaceResponseModel> getPlaceBySlug(String slug);
}

class PlaceRemoteDataSourceImpl implements PlaceRemoteDataSource {
  PlaceRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<ListPlacesResponseModel> getPlaces({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? placeTypes,
    String? categoryId,
    String? searchQuery,
    double? minRatingAvg,
    int? minRatingCount,
    double? radiusM,
    String? startTime,
    String? endTime,
    String? expand,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (status != null) queryParams['status'] = status;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    if (slug != null && slug.isNotEmpty) queryParams['slug'] = slug;
    if (placeTypes != null && placeTypes.isNotEmpty) {
      queryParams['place_types'] = placeTypes;
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (searchQuery != null) queryParams['search_query'] = searchQuery;
    if (minRatingAvg != null) queryParams['min_rating_avg'] = minRatingAvg;
    if (minRatingCount != null) {
      queryParams['min_rating_count'] = minRatingCount;
    }
    if (radiusM != null) queryParams['radius_m'] = radiusM;
    if (startTime != null) queryParams['start_time'] = startTime;
    if (endTime != null) queryParams['end_time'] = endTime;
    if (expand != null) queryParams['expand'] = expand;

    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.places,
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
      throw const ApiException(message: 'Invalid places response');
    }
    return ListPlacesResponseModel.fromJson(data);
  }

  @override
  Future<PlaceResponseModel> getPlaceById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.placeById(id),
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
      throw const ApiException(message: 'Invalid place response');
    }
    return PlaceResponseModel.fromJson(data);
  }

  @override
  Future<PlaceResponseModel> getPlaceBySlug(String slug) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.placeBySlug(slug),
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
      throw const ApiException(message: 'Invalid place response');
    }
    return PlaceResponseModel.fromJson(data);
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
