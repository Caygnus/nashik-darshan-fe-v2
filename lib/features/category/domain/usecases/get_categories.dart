import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/category/domain/repositories/category_repository.dart';

class GetCategories
    implements UseCase<CategoryListResult, GetCategoriesParams> {
  GetCategories(this._repository);
  final CategoryRepository _repository;

  @override
  Future<Result<CategoryListResult>> call(GetCategoriesParams params) {
    return _repository.getCategories(
      limit: params.limit,
      offset: params.offset,
      status: params.status,
      sort: params.sort,
      order: params.order,
      slug: params.slug,
      name: params.name,
    );
  }
}

class GetCategoriesParams {
  const GetCategoriesParams({
    this.limit,
    this.offset,
    this.status,
    this.sort,
    this.order,
    this.slug,
    this.name,
  });
  final int? limit;
  final int? offset;
  final String? status;
  final String? sort;
  final String? order;
  final List<String>? slug;
  final List<String>? name;
}
