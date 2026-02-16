import '../entities/place.dart';
import '../repositories/place_repository.dart';

/// Use case to get place details by ID
class GetPlaceDetails {
  final PlaceRepository repository;

  GetPlaceDetails(this.repository);

  Future<Place?> call(String placeId) {
    return repository.getPlaceById(placeId);
  }
}
