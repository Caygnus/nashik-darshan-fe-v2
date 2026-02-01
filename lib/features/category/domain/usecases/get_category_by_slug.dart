import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/category/domain/entities/category_entity.dart';
import 'package:nashik/features/category/domain/repositories/category_repository.dart';

class GetCategoryBySlug implements UseCase<CategoryEntity, String> {
  GetCategoryBySlug(this._repository);
  final CategoryRepository _repository;

  @override
  Future<Result<CategoryEntity>> call(String slug) {
    return _repository.getCategoryBySlug(slug);
  }
}
