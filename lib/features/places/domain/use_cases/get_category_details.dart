import 'package:nashik/features/places/domain/entities/category.dart';
import 'package:nashik/features/places/domain/repositories/place_repository.dart';

/// Use case to get category details by ID
class GetCategoryDetails {
  final PlaceRepository repository;

  GetCategoryDetails(this.repository);

  Future<Category?> call(String categoryId) {
    return repository.getCategoryById(categoryId);
  }
}
