import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';

import '../entities/category_entity.dart';

/// Result for paginated list: (items, total).
class CategoryListResult {
  const CategoryListResult(this.items, this.total);
  final List<CategoryEntity> items;
  final int total;
}

abstract class CategoryRepository extends BaseRepository {
  Future<Result<CategoryListResult>> getCategories({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? name,
  });

  Future<Result<CategoryEntity>> getCategoryById(String id);
  Future<Result<CategoryEntity>> getCategoryBySlug(String slug);
}
