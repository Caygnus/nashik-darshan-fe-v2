import '../models/category_model.dart';
import '../models/place_model.dart';

/// Mock Data Source for Places
/// 
/// This is a temporary centralized data source that stores all place and category data.
/// It will be replaced with actual database/API calls in the future.
/// 
/// All place data should be defined here to maintain consistency across the app.
class PlacesMockDataSource {
  PlacesMockDataSource._();

  static final List<CategoryModel> _categories = List.unmodifiable([
    CategoryModel(
        id: 'spiritual',
        name: 'Spiritual',
        description: 'Discover the spiritual side of Nashik',
        iconPath: 'assets/svg/om.svg',
        imagePath: 'assets/png/trambak.png',
        significance: 'Nashik is home to many ancient temples and spiritual sites that attract pilgrims from all over India.',
      ),
      CategoryModel(
        id: 'adventure',
        name: 'Adventure',
        description: 'Thrilling adventures await you',
        iconPath: 'assets/svg/map.svg',
        imagePath: 'assets/png/trambak.png',
        significance: 'Experience the thrill of adventure activities in and around Nashik.',
      ),
      CategoryModel(
        id: 'culture',
        name: 'Culture',
        description: 'Immerse yourself in rich culture',
        iconPath: 'assets/svg/open-book.svg',
        imagePath: 'assets/png/trambak.png',
        significance: 'Explore the rich cultural heritage and traditions of Nashik.',
      ),
      CategoryModel(
        id: 'nature',
        name: 'Nature',
        description: 'Connect with nature',
        iconPath: 'assets/svg/map.svg',
        imagePath: 'assets/png/trambak.png',
        significance: 'Discover the natural beauty and scenic spots in Nashik.',
      ),
      CategoryModel(
        id: 'family',
        name: 'Family',
        description: 'Perfect places for family outings',
        iconPath: 'assets/svg/person.svg',
        imagePath: 'assets/png/trambak.png',
        significance: 'Family-friendly destinations and activities in Nashik.',
      ),
      CategoryModel(
        id: 'shopping',
        name: 'Shopping',
        description: 'Shop till you drop',
        iconPath: 'assets/svg/map.svg',
        imagePath: 'assets/png/trambak.png',
        significance: 'Explore shopping destinations and local markets in Nashik.',
      ),
  ]);

  /// Get all categories
  static List<CategoryModel> getCategories() => _categories;

  static final List<PlaceModel> _allPlaces = List.unmodifiable([
    // ==================== SPIRITUAL PLACES ====================
      PlaceModel(
        id: 'trimbakeshwar',
        name: 'Trimbakeshwar',
        description: 'Trimbakeshwar is one of the twelve sacred Jyotirlingas, where Lord Shiva manifests as Brahma, Vishnu, and Mahesh in a unique three-faced lingam. Located at the source of river Godavari, this ancient temple holds immense spiritual significance.',
        categoryId: 'spiritual',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Trimbak, Nashik, Maharashtra',
        latitude: 19.9327,
        longitude: 73.5306,
        openingHours: '5:30 AM - 9:00 PM',
        contactInfo: '+91 2534 234567',
        additionalInfo: {
          'devanagari': 'त्र्यंबकेश्वर ज्योतिर्लिंग',
          'english': 'Trimbakeshwar Jyotirlinga',
          'subtitle': 'One of the 12 Jyotirlingas • Nashik, Maharashtra',
          'factOfDay': 'The sacred Kushavarta Kund near the temple is believed to be the origin point of river Godavari, making it one of India\'s holiest water sources.',
          'sacredSignificance': 'The only Jyotirlinga where Brahma, Vishnu & Shiva reside together',
          'pujaRituals': 'Ancient Vedic puja rituals at Trimbakeshwar Jyotirlinga',
          'specialInfo': 'Trimbakeshwar Temple has an average elevation of 720 metres (2362 feet).',
          'aartiTimings': [
            {'type': 'Morning Aarti', 'startTime': '5:30 AM', 'endTime': '7:00 AM', 'frequency': 'Daily'},
            {'type': 'Abhishek Pooja', 'startTime': '6:00 AM', 'endTime': '12:00 PM', 'frequency': 'Special slots'},
            {'type': 'Evening Aarti', 'startTime': '7:00 PM', 'endTime': '8:00 PM', 'frequency': 'Daily'},
            {'type': 'Temple Closing', 'startTime': '9:00 PM', 'endTime': '9:00 PM', 'frequency': 'Daily'},
          ],
        },
      ),
      PlaceModel(
        id: 'shree-gajanan-maharaj',
        name: 'Shree Gajanan Maharaj',
        description: 'Shree Gajanan Maharaj Temple is a famous spiritual destination in Nashik, dedicated to the saint Gajanan Maharaj.',
        categoryId: 'spiritual',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Nashik, Maharashtra',
        latitude: 19.9975,
        longitude: 73.7898,
        openingHours: '6:00 AM - 8:00 PM',
        contactInfo: '+91 253 2345678',
        additionalInfo: {
          'devanagari': 'श्री गजानन महाराज',
          'english': 'Shree Gajanan Maharaj',
          'subtitle': 'Spiritual Temple • Nashik, Maharashtra',
        },
      ),
      PlaceModel(
        id: 'kalaram-temple',
        name: 'Kalaram Temple',
        description: 'Kalaram Temple is a famous Ram temple in Nashik, known for its black stone idol of Lord Rama.',
        categoryId: 'spiritual',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Panchavati, Nashik, Maharashtra',
        latitude: 19.9500,
        longitude: 73.7833,
        openingHours: '6:00 AM - 9:00 PM',
        contactInfo: '+91 253 2345679',
        additionalInfo: {
          'devanagari': 'कालाराम मंदिर',
          'english': 'Kalaram Temple',
          'subtitle': 'Famous Ram Temple • Nashik, Maharashtra',
        },
      ),
      PlaceModel(
        id: 'saptashrungi-temple',
        name: 'Saptashrungi Temple',
        description: 'Saptashrungi Temple is a famous temple dedicated to Goddess Saptashrungi, located on a hilltop near Nashik.',
        categoryId: 'spiritual',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Vani, Nashik, Maharashtra',
        latitude: 20.0500,
        longitude: 73.8500,
        openingHours: '5:00 AM - 9:00 PM',
        contactInfo: '+91 2534 234568',
        additionalInfo: {
          'devanagari': 'सप्तश्रृंगी मंदिर',
          'english': 'Saptashrungi Temple',
          'subtitle': 'Goddess Saptashrungi • Nashik, Maharashtra',
        },
      ),

      // ==================== ADVENTURE PLACES ====================
      PlaceModel(
        id: 'anjaneri-fort',
        name: 'Anjaneri Fort',
        description: 'Anjaneri Fort is a popular trekking destination near Nashik, offering breathtaking views and adventure activities.',
        categoryId: 'adventure',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Anjaneri, Nashik, Maharashtra',
        latitude: 19.9000,
        longitude: 73.7000,
        openingHours: '6:00 AM - 6:00 PM',
      ),
      PlaceModel(
        id: 'brahmagiri-hill',
        name: 'Brahmagiri Hill',
        description: 'Brahmagiri Hill offers challenging trekking routes and panoramic views of the surrounding landscape.',
        categoryId: 'adventure',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Trimbak, Nashik, Maharashtra',
        latitude: 19.9500,
        longitude: 73.5500,
        openingHours: '5:00 AM - 7:00 PM',
      ),

      // ==================== CULTURE PLACES ====================
      PlaceModel(
        id: 'coin-museum',
        name: 'Coin Museum',
        description: 'The Coin Museum in Nashik displays a fascinating collection of ancient and modern coins, showcasing the cultural history of the region.',
        categoryId: 'culture',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Nashik, Maharashtra',
        latitude: 19.9975,
        longitude: 73.7898,
        openingHours: '10:00 AM - 5:00 PM',
        contactInfo: '+91 253 2345690',
      ),
      PlaceModel(
        id: 'pandavleni-caves',
        name: 'Pandavleni Caves',
        description: 'Pandavleni Caves are ancient Buddhist caves dating back to the 3rd century BC, showcasing rich cultural heritage.',
        categoryId: 'culture',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Nashik, Maharashtra',
        latitude: 19.9500,
        longitude: 73.7500,
        openingHours: '9:00 AM - 5:30 PM',
      ),

      // ==================== NATURE PLACES ====================
      PlaceModel(
        id: 'pahine-waterfall',
        name: 'Pahine Waterfall',
        description: 'Pahine Waterfall is a scenic nature spot near Nashik, offering serene views and peaceful trails. A popular destination for nature lovers and trekkers.',
        categoryId: 'nature',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Pahine, Nashik, Maharashtra',
        latitude: 19.9500,
        longitude: 73.7000,
        openingHours: '6:00 AM - 6:00 PM',
      ),
      PlaceModel(
        id: 'gangapur-dam',
        name: 'Gangapur Dam',
        description: 'Gangapur Dam is a scenic spot perfect for nature lovers, offering beautiful views and peaceful surroundings.',
        categoryId: 'nature',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Gangapur, Nashik, Maharashtra',
        latitude: 19.9833,
        longitude: 73.8167,
        openingHours: '6:00 AM - 7:00 PM',
      ),
      PlaceModel(
        id: 'sula-vineyards',
        name: 'Sula Vineyards',
        description: 'Sula Vineyards is a beautiful wine estate offering wine tours, tastings, and stunning views of the vineyards.',
        categoryId: 'nature',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Gangapur, Nashik, Maharashtra',
        latitude: 19.9833,
        longitude: 73.8167,
        openingHours: '11:00 AM - 10:00 PM',
        contactInfo: '+91 253 2345691',
      ),

      // ==================== FAMILY PLACES ====================
      PlaceModel(
        id: 'nashik-darshan-park',
        name: 'Nashik Darshan Park',
        description: 'A family-friendly park with recreational activities and beautiful gardens, perfect for a day out with family.',
        categoryId: 'family',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Nashik, Maharashtra',
        latitude: 19.9975,
        longitude: 73.7898,
        openingHours: '6:00 AM - 9:00 PM',
      ),

      // ==================== SHOPPING PLACES ====================
      PlaceModel(
        id: 'nashik-city-center',
        name: 'Nashik City Center',
        description: 'A modern shopping mall with various retail stores, restaurants, and entertainment options.',
        categoryId: 'shopping',
        imageUrls: ['assets/png/trambak.png'],
        address: 'Nashik, Maharashtra',
        latitude: 19.9975,
        longitude: 73.7898,
        openingHours: '10:00 AM - 10:00 PM',
        contactInfo: '+91 253 2345692',
      ),
  ]);

  /// Get all places
  /// This is the centralized place database
  static List<PlaceModel> getAllPlaces() => _allPlaces;

  /// Get place by ID
  static PlaceModel? getPlaceById(String placeId) {
    final matches = getAllPlaces().where((place) => place.id == placeId).toList();
    return matches.isEmpty ? null : matches.first;
  }

  /// Get places by category ID
  static List<PlaceModel> getPlacesByCategory(String categoryId) {
    return getAllPlaces().where(
      (place) => place.categoryId == categoryId,
    ).toList();
  }

  /// Search places by query
  static List<PlaceModel> searchPlaces(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllPlaces().where((place) {
      return place.name.toLowerCase().contains(lowerQuery) ||
          place.description.toLowerCase().contains(lowerQuery) ||
          (place.address?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get category by ID
  static CategoryModel? getCategoryById(String categoryId) {
    final matches = getCategories().where((c) => c.id == categoryId).toList();
    return matches.isEmpty ? null : matches.first;
  }
}
