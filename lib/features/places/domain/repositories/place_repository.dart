import '../entities/category.dart';
import '../entities/place.dart';

/// Repository interface for places
/// Defines the contract for place-related data operations
abstract class PlaceRepository {
  /// Get all categories
  Future<List<Category>> getCategories();

  /// Get category by ID
  Future<Category?> getCategoryById(String categoryId);

  /// Get places by category
  Future<List<Place>> getPlacesByCategory(String categoryId);

  /// Get place details by ID
  Future<Place?> getPlaceById(String placeId);

  /// Search places by query
  Future<List<Place>> searchPlaces(String query);
}
