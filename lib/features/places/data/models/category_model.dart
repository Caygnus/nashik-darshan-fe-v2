import '../../domain/entities/category.dart';

/// Category data model
/// Extends Category entity with JSON serialization
class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconPath,
    required super.imagePath,
    required super.significance,
  });

  /// Create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      imagePath: json['imagePath'] as String,
      significance: json['significance'] as String,
    );
  }

  /// Convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'imagePath': imagePath,
      'significance': significance,
    };
  }

  /// Convert CategoryModel to Category entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      iconPath: iconPath,
      imagePath: imagePath,
      significance: significance,
    );
  }
}
