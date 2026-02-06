part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryListLoaded extends CategoryState {
  const CategoryListLoaded(this.items, this.total);
  final List<CategoryEntity> items;
  final int total;

  @override
  List<Object?> get props => [items, total];
}

class CategoryDetailLoaded extends CategoryState {
  const CategoryDetailLoaded(this.category);
  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

class CategoryError extends CategoryState {
  const CategoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
