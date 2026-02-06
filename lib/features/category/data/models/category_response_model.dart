import '../../domain/entities/category_entity.dart';

/// Data model for dto.CategoryResponse.
class CategoryResponseModel {
  const CategoryResponseModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.metadata,
  });

  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final Map<String, String>? metadata;

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v?.toString() ?? ''),
      ),
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      slug: slug,
      description: description,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
