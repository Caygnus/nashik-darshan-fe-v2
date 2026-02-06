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

  /// Create CategoryModel from JSON.
  /// Missing or non-String values are replaced with empty string for robustness.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _readString(json, 'id'),
      name: _readString(json, 'name'),
      description: _readString(json, 'description'),
      iconPath: _readString(json, 'iconPath'),
      imagePath: _readString(json, 'imagePath'),
      significance: _readString(json, 'significance'),
    );
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
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

  /// Returns this as [Category]. No allocation; [CategoryModel] extends [Category].
  Category toEntity() => this;
}
