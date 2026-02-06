import 'package:nashik/core/network/pagination_response.dart';

import 'category_response_model.dart';

/// Data model for dto.ListCategoriesResponse.
class ListCategoriesResponseModel {
  const ListCategoriesResponseModel({
    required this.items,
    required this.pagination,
  });

  final List<CategoryResponseModel> items;
  final PaginationResponse pagination;

  factory ListCategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    final items = (itemsList ?? [])
        .map((e) => CategoryResponseModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final pagination = PaginationResponse.fromJson(
      json['pagination'] as Map<String, dynamic>?,
    );
    return ListCategoriesResponseModel(
      items: items,
      pagination: pagination,
    );
  }
}
