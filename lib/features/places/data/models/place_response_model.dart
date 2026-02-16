import '../../domain/entities/place.dart';

/// Safe parsing helpers for API place response.
class PlaceImageModel {
  const PlaceImageModel({this.id, this.url, this.alt, this.pos});
  final String? id;
  final String? url;
  final String? alt;
  final int? pos;

  static PlaceImageModel? fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    return PlaceImageModel(
      id: json['id'] as String?,
      url: json['url'] as String?,
      alt: json['alt'] as String?,
      pos: json['pos'] as int?,
    );
  }
}

class GeoPointModel {
  const GeoPointModel({this.latitude, this.longitude});
  final double? latitude;
  final double? longitude;

  static GeoPointModel? fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    final lat = json['latitude'];
    final lng = json['longitude'];
    return GeoPointModel(
      latitude: lat is num ? lat.toDouble() : null,
      longitude: lng is num ? lng.toDouble() : null,
    );
  }
}

/// Minimal category ref for place (id, name, slug).
class CategoryRefModel {
  const CategoryRefModel({this.id, this.name, this.slug});
  final String? id;
  final String? name;
  final String? slug;

  static CategoryRefModel? fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    return CategoryRefModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );
  }
}

/// Preferred key order for address string (predictable output across API responses).
const List<String> _addressKeyOrder = [
  'street',
  'street2',
  'line1',
  'line2',
  'city',
  'state',
  'region',
  'postal_code',
  'zip',
  'country',
];

/// Data model for dto.PlaceResponse with safe parsing of categories, images, location.
class PlaceResponseModel {
  PlaceResponseModel({
    required this.id,
    this.title,
    this.slug,
    this.shortDescription,
    this.longDescription,
    this.location,
    this.categories = const [],
    this.images = const [],
    this.placeType,
    this.status,
    this.primaryImageUrl,
    this.thumbnailUrl,
    this.ratingAvg,
    this.ratingCount,
    this.address,
    this.subtitle,
    this.createdAt,
    this.updatedAt,
    this.popularityScore,
    this.viewCount,
  });

  final String id;
  final String? title;
  final String? slug;
  final String? shortDescription;
  final String? longDescription;
  final GeoPointModel? location;
  final List<CategoryRefModel> categories;
  final List<PlaceImageModel> images;
  final String? placeType;
  final String? status;
  final String? primaryImageUrl;
  final String? thumbnailUrl;
  final double? ratingAvg;
  final int? ratingCount;
  final Map<String, dynamic>? address;
  final String? subtitle;
  final String? createdAt;
  final String? updatedAt;
  final double? popularityScore;
  final int? viewCount;

  factory PlaceResponseModel.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];
    final geo = loc != null ? GeoPointModel.fromJson(loc) : null;

    final categoriesRaw = json['categories'];
    final categories = categoriesRaw is List
        ? categoriesRaw
            .map((e) => CategoryRefModel.fromJson(e))
            .whereType<CategoryRefModel>()
            .toList()
        : const <CategoryRefModel>[];

    final imagesRaw = json['images'];
    final images = imagesRaw is List
        ? imagesRaw
            .map((e) => PlaceImageModel.fromJson(e))
            .whereType<PlaceImageModel>()
            .toList()
        : const <PlaceImageModel>[];

    final addressRaw = json['address'];
    Map<String, dynamic>? address;
    if (addressRaw is Map<String, dynamic>) {
      address = addressRaw;
    }

    final ratingAvg = json['rating_avg'];
    final ratingCount = json['rating_count'];

    return PlaceResponseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      shortDescription: json['short_description'] as String?,
      longDescription: json['long_description'] as String?,
      location: geo,
      categories: categories,
      images: images,
      placeType: json['place_type'] as String?,
      status: json['status'] as String?,
      primaryImageUrl: json['primary_image_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      ratingAvg: ratingAvg is num ? ratingAvg.toDouble() : null,
      ratingCount: ratingCount is int ? ratingCount : null,
      address: address,
      subtitle: json['subtitle'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      popularityScore: json['popularity_score'] is num
          ? (json['popularity_score'] as num).toDouble()
          : null,
      viewCount: json['view_count'] as int?,
    );
  }

  static String _addressMapToOrderedString(Map<String, dynamic> address) {
    final parts = <String>[];
    for (final key in _addressKeyOrder) {
      if (address.containsKey(key)) {
        final v = address[key];
        if (v != null) {
          final s = v.toString().trim();
          if (s.isNotEmpty) parts.add(s);
        }
      }
    }
    final remaining = address.keys.where((k) => !_addressKeyOrder.contains(k)).toList()..sort();
    for (final key in remaining) {
      final v = address[key];
      if (v != null) {
        final s = v.toString().trim();
        if (s.isNotEmpty) parts.add(s);
      }
    }
    return parts.join(', ');
  }

  /// Map to existing Place entity for UI compatibility.
  Place toEntity() {
    final name = title ?? id;
    final desc = shortDescription ?? longDescription ?? '';
    final categoryId =
        categories.isNotEmpty ? (categories.first.id ?? '') : '';
    final urls = <String>[];
    if (primaryImageUrl != null && primaryImageUrl!.isNotEmpty) {
      urls.add(primaryImageUrl!);
    }
    for (final img in images) {
      if (img.url != null && img.url!.isNotEmpty && !urls.contains(img.url)) {
        urls.add(img.url!);
      }
    }
    if (urls.isEmpty && thumbnailUrl != null && thumbnailUrl!.isNotEmpty) {
      urls.add(thumbnailUrl!);
    }
    String? addressStr;
    if (address != null && address!.isNotEmpty) {
      addressStr = _addressMapToOrderedString(address!);
    }
    return Place(
      id: id,
      name: name,
      description: desc,
      categoryId: categoryId,
      imageUrls: urls,
      subtitle: subtitle,
      placeType: placeType,
      address: addressStr,
      latitude: location?.latitude,
      longitude: location?.longitude,
      openingHours: null,
      contactInfo: null,
      additionalInfo: address,
    );
  }
}
