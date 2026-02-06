import '../../domain/entities/place.dart';

/// Place data model
/// Extends Place entity with JSON serialization
class PlaceModel extends Place {
  PlaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.categoryId,
    required super.imageUrls,
    super.address,
    super.latitude,
    super.longitude,
    super.openingHours,
    super.contactInfo,
    super.additionalInfo,
  });

  /// Create PlaceModel from JSON.
  /// Missing or wrong-typed values use defaults (empty string, empty list, null) for robustness.
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: _readString(json, 'id'),
      name: _readString(json, 'name'),
      description: _readString(json, 'description'),
      categoryId: _readString(json, 'categoryId'),
      imageUrls: _readStringList(json, 'imageUrls'),
      address: _readStringOrNull(json, 'address'),
      latitude: _readDoubleOrNull(json, 'latitude'),
      longitude: _readDoubleOrNull(json, 'longitude'),
      openingHours: _readStringOrNull(json, 'openingHours'),
      contactInfo: _readStringOrNull(json, 'contactInfo'),
      additionalInfo: _readMapOrNull(json, 'additionalInfo'),
    );
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static String? _readStringOrNull(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static List<String> _readStringList(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null || value is! List) return [];
    return value.map((e) => e is String ? e : e.toString()).toList();
  }

  static double? _readDoubleOrNull(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return null;
  }

  static Map<String, dynamic>? _readMapOrNull(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  /// Convert PlaceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'imageUrls': imageUrls,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'openingHours': openingHours,
      'contactInfo': contactInfo,
      'additionalInfo': additionalInfo,
    };
  }

  /// Returns this as [Place]. No allocation; [PlaceModel] extends [Place].
  Place toEntity() => this;
}
