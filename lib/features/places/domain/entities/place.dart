/// Place entity
/// Represents a place/attraction in Nashik
class Place {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final List<String> imageUrls;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? openingHours;
  final String? contactInfo;
  final Map<String, dynamic>? additionalInfo;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required List<String> imageUrls,
    this.address,
    this.latitude,
    this.longitude,
    this.openingHours,
    this.contactInfo,
    this.additionalInfo,
  }) : imageUrls = List.unmodifiable(List.from(imageUrls));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Place &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
