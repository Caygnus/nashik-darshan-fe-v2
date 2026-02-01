/// Centralized route names for the application
/// 
/// All route names should be defined here to maintain consistency
/// and avoid hardcoded strings throughout the app.
/// Route names are used with GoRouter's `goNamed()` and `pushNamed()` methods.
class AppRouteNames {
  // Private constructor to prevent instantiation
  AppRouteNames._();

  // ==================== Auth Routes ====================
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String oauthCallback = 'oauth-callback';

  // ==================== Main Tab Routes ====================
  static const String itinerary = 'itinerary';
  static const String category = 'category';
  static const String home = 'home';
  static const String events = 'events';
  static const String profile = 'profile';

  // ==================== Feature Routes ====================
  static const String myItineraries = 'my-itineraries';
  static const String discoverNashik = 'discover-nashik';
  static const String streetFood = 'street-food';
  static const String transport = 'transport';
  static const String hotels = 'hotels';
  static const String eatery = 'eatery';
  static const String templeDarshan = 'temple-darshan';
  static const String aartiTiming = 'aarti-timing';
  
  // ==================== Places Routes ====================
  static const String categoryDetail = 'category-detail';
  static const String placeDetail = 'place-detail';
  
  // ==================== Itinerary Routes ====================
  static const String itineraryDetail = 'itinerary-detail';
  static const String addStops = 'add-stops';
  static const String customizeTrip = 'customize-trip';
  static const String savedItinerary = 'saved-itinerary';

  // ==================== Events Routes ====================
  static const String eventDetail = 'event-detail';
  static const String upcomingEvents = 'upcoming-events';
  static const String savedEvents = 'saved-events';

  // ==================== Utility Routes ====================
  static const String deepLinkTest = 'deep-link-test';
}
