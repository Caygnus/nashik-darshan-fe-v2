/// Category entity (API-aligned). Framework-independent.
class CategoryEntity {
  final String id;
  final String name;
  final String slug;
  final String? subtitle;
  final String? shortDescription;
  final String? description;
  final String? imageUrl;
  final String? icon;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.subtitle,
    this.shortDescription,
    this.description,
    this.imageUrl,
    this.icon,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          status == other.status;

  @override
  int get hashCode => Object.hash(id, name, description, status);
}
