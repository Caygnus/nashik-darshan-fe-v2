/// Category entity
/// Represents a category of places (Spiritual, Adventure, Culture, etc.)
class Category {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final String imagePath;
  final String significance;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.imagePath,
    required this.significance,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Category types enum
enum CategoryType {
  spiritual,
  adventure,
  culture,
  nature,
  family,
  shopping,
}

extension CategoryTypeExtension on CategoryType {
  String get name {
    switch (this) {
      case CategoryType.spiritual:
        return 'Spiritual';
      case CategoryType.adventure:
        return 'Adventure';
      case CategoryType.culture:
        return 'Culture';
      case CategoryType.nature:
        return 'Nature';
      case CategoryType.family:
        return 'Family';
      case CategoryType.shopping:
        return 'Shopping';
    }
  }

  String get id {
    return name.toLowerCase();
  }
}
