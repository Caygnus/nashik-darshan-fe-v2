import 'package:nashik/core/utils/result.dart';

import '../entities/category.dart';
import '../entities/place.dart';

/// Result for paginated place list.
class PlaceListResult {
  const PlaceListResult(this.items, this.total);
  final List<Place> items;
  final int total;
}

/// Repository interface for places
/// Defines the contract for place-related data operations
abstract class PlaceRepository {
  /// API: Get paginated places with filters
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
  });

  /// API: Get place by ID
  Future<Result<Place>> getPlaceByIdFromApi(String placeId);

  /// API: Get place by slug
  Future<Result<Place>> getPlaceBySlug(String slug);

  /// Get all categories (legacy mock)
  Future<List<Category>> getCategories();

  /// Get category by ID (legacy mock)
  Future<Category?> getCategoryById(String categoryId);

  /// Get places by category (legacy mock)
  Future<List<Place>> getPlacesByCategory(String categoryId);

  /// Get place details by ID (legacy mock)
  Future<Place?> getPlaceById(String placeId);

  /// Search places by query (legacy mock)
  Future<List<Place>> searchPlaces(String query);
}
