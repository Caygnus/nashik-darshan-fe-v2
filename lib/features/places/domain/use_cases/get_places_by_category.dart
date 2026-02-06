import '../entities/place.dart';
import '../repositories/place_repository.dart';

/// Use case to get places by category
class GetPlacesByCategory {
  final PlaceRepository repository;

  GetPlacesByCategory(this.repository);

  Future<List<Place>> call(String categoryId) {
    return repository.getPlacesByCategory(categoryId);
  }
}
