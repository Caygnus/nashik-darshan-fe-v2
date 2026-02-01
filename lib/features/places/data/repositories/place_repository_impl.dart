import '../../domain/entities/category.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/places_mock_data_source.dart';

/// Place repository implementation
/// 
/// Currently uses mock data from PlacesMockDataSource.
/// This will be replaced with actual API/database calls in the future.
/// 
/// The centralized data source (PlacesMockDataSource) makes it easy to:
/// - Maintain consistent data across the app
/// - Replace with database/API later
/// - Add new places in one location
class PlaceRepositoryImpl implements PlaceRepository {
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
    // Get place from centralized mock data source
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
