import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/category/data/datasources/category_remote_datasource.dart';
import 'package:nashik/features/category/domain/entities/category_entity.dart';
import 'package:nashik/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends BaseRepository
    implements CategoryRepository {
  CategoryRepositoryImpl({
    required CategoryRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final CategoryRemoteDataSource _remote;

  @override
  Future<Result<CategoryListResult>> getCategories({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? name,
  }) async {
    return executeWithErrorHandling<CategoryListResult>(() async {
      final response = await _remote.getCategories(
        limit: limit,
        offset: offset,
        status: status,
        sort: sort,
        order: order,
        slug: slug,
        name: name,
      );
      final items = response.items.map((e) => e.toEntity()).toList();
      final total = response.pagination.total ?? items.length;
      return CategoryListResult(items, total);
    });
  }

  @override
  Future<Result<CategoryEntity>> getCategoryById(String id) async {
    return executeWithErrorHandling<CategoryEntity>(() async {
      final model = await _remote.getCategoryById(id);
      return model.toEntity();
    });
  }

  @override
  Future<Result<CategoryEntity>> getCategoryBySlug(String slug) async {
    return executeWithErrorHandling<CategoryEntity>(() async {
      final model = await _remote.getCategoryBySlug(slug);
      return model.toEntity();
    });
  }
}
