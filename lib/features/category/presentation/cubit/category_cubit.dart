import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_category_by_id.dart';
import '../../domain/usecases/get_category_by_slug.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required GetCategories getCategories,
    required GetCategoryById getCategoryById,
    required GetCategoryBySlug getCategoryBySlug,
  })  : _getCategories = getCategories,
        _getCategoryById = getCategoryById,
        _getCategoryBySlug = getCategoryBySlug,
        super(CategoryInitial());

  final GetCategories _getCategories;
  final GetCategoryById _getCategoryById;
  final GetCategoryBySlug _getCategoryBySlug;

  Future<void> loadCategories({
    int? limit,
    int? offset,
    String? status,
    String? sort,
    String? order,
    List<String>? slug,
    List<String>? name,
  }) async {
    emit(CategoryLoading());
    final result = await _getCategories(GetCategoriesParams(
      limit: limit,
      offset: offset,
      status: status,
      sort: sort,
      order: order,
      slug: slug,
      name: name,
    ));
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (data) => emit(CategoryListLoaded(data.items, data.total)),
    );
  }

  Future<void> loadCategoryById(String id) async {
    emit(CategoryLoading());
    final result = await _getCategoryById(id);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (category) => emit(CategoryDetailLoaded(category)),
    );
  }

  Future<void> loadCategoryBySlug(String slug) async {
    emit(CategoryLoading());
    final result = await _getCategoryBySlug(slug);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (category) => emit(CategoryDetailLoaded(category)),
    );
  }
}
