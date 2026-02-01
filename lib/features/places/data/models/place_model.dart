import '../../domain/entities/place.dart';

/// Place data model
/// Extends Place entity with JSON serialization
class PlaceModel extends Place {
  const PlaceModel({
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

  /// Create PlaceModel from JSON
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      address: json['address'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      openingHours: json['openingHours'] as String?,
      contactInfo: json['contactInfo'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
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

  /// Convert PlaceModel to Place entity
  Place toEntity() {
    return Place(
      id: id,
      name: name,
      description: description,
      categoryId: categoryId,
      imageUrls: imageUrls,
      address: address,
      latitude: latitude,
      longitude: longitude,
      openingHours: openingHours,
      contactInfo: contactInfo,
      additionalInfo: additionalInfo,
    );
  }
}
