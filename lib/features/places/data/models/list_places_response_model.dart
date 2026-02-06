import 'package:nashik/core/network/pagination_response.dart';

import 'place_response_model.dart';

/// Data model for dto.ListPlacesResponse.
class ListPlacesResponseModel {
  const ListPlacesResponseModel({
    required this.items,
    required this.pagination,
  });

  final List<PlaceResponseModel> items;
  final PaginationResponse pagination;

  factory ListPlacesResponseModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    final items = (itemsList ?? [])
        .map((e) {
          if (e is Map<String, dynamic>) {
            return PlaceResponseModel.fromJson(e);
          }
          return null;
        })
        .whereType<PlaceResponseModel>()
        .toList();
    final pagination = PaginationResponse.fromJson(
      json['pagination'] as Map<String, dynamic>?,
    );
    return ListPlacesResponseModel(
      items: items,
      pagination: pagination,
    );
  }
}
