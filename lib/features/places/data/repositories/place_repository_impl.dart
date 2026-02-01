import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/error/failures/server_failure.dart';
import 'package:nashik/core/utils/result.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_remote_datasource.dart';
import '../datasources/places_mock_data_source.dart';

/// Place repository implementation.
/// API methods use [PlaceRemoteDataSource]; legacy methods use mock.
class PlaceRepositoryImpl extends BaseRepository implements PlaceRepository {
  PlaceRepositoryImpl({
    PlaceRemoteDataSource? remoteDataSource,
  }) : _remote = remoteDataSource;

  final PlaceRemoteDataSource? _remote;

  @override
  Future<Result<PlaceListResult>> getPlaces({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? placeTypes,
    String? searchQuery,
    double? minRatingAvg,
    int? minRatingCount,
    double? radiusM,
    String? startTime,
    String? endTime,
    String? expand,
  }) async {
    if (_remote == null) {
      return Left(
        ServerFailure(
          message: 'Place API not configured',
          code: 'NOT_CONFIGURED',
        ),
      );
    }
    return executeWithErrorHandling<PlaceListResult>(() async {
      final response = await _remote.getPlaces(
        limit: limit,
        offset: offset,
        status: status,
        sort: sort,
        order: order,
        slug: slug,
        placeTypes: placeTypes,
        searchQuery: searchQuery,
        minRatingAvg: minRatingAvg,
        minRatingCount: minRatingCount,
        radiusM: radiusM,
        startTime: startTime,
        endTime: endTime,
        expand: expand,
      );
      final items = response.items.map((e) => e.toEntity()).toList();
      final total = response.pagination.total ?? items.length;
      return PlaceListResult(items, total);
    });
  }

  @override
  Future<Result<Place>> getPlaceByIdFromApi(String placeId) async {
    if (_remote == null) {
      return Left(
        ServerFailure(
          message: 'Place API not configured',
          code: 'NOT_CONFIGURED',
        ),
      );
    }
    return executeWithErrorHandling<Place>(() async {
      final model = await _remote.getPlaceById(placeId);
      return model.toEntity();
    });
  }

  @override
  Future<Result<Place>> getPlaceBySlug(String slug) async {
    if (_remote == null) {
      return Left(
        ServerFailure(
          message: 'Place API not configured',
          code: 'NOT_CONFIGURED',
        ),
      );
    }
    return executeWithErrorHandling<Place>(() async {
      final model = await _remote.getPlaceBySlug(slug);
      return model.toEntity();
    });
  }

  @override
  Future<List<Category>> getCategories() async {
    // Get categories from centralized mock data source
    return PlacesMockDataSource.getCategories()
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Category?> getCategoryById(String categoryId) async {
    // Get category from centralized mock data source
    final category = PlacesMockDataSource.getCategoryById(categoryId);
    return category?.toEntity();
  }

  @override
  Future<List<Place>> getPlacesByCategory(String categoryId) async {
    // Get places from centralized mock data source
    return PlacesMockDataSource.getPlacesByCategory(categoryId)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Place?> getPlaceById(String placeId) async {
    final place = PlacesMockDataSource.getPlaceById(placeId);
    return place?.toEntity();
  }

  @override
  Future<List<Place>> searchPlaces(String query) async {
    // Search places from centralized mock data source
    return PlacesMockDataSource.searchPlaces(query)
        .map((model) => model.toEntity())
        .toList();
  }
}
