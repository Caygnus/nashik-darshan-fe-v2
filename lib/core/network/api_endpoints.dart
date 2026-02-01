/// API path constants for Nashik Darshan API.
/// Do not add query params here; pass them at call site.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://5p9ubi66hh.execute-api.ap-south-1.amazonaws.com/v1';

  // Auth
  static const String authSignup = '/auth/signup';

  // Categories
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';
  static String categoryBySlug(String slug) => '/categories/slug/$slug';

  // Places
  static const String places = '/places';
  static String placeById(String id) => '/places/$id';
  static String placeBySlug(String slug) => '/places/slug/$slug';

  // User
  static const String userMe = '/user/me';
  static const String user = '/user';

  // Health
  static const String health = '/health';
}
