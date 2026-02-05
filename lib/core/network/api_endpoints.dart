/// API path constants for Nashik Darshan API.
/// Do not add query params here; pass them at call site.
///
/// [baseUrl] is configurable at build time via:
///   flutter run --dart-define=API_BASE_URL=https://your-api.example.com/v1
/// For runtime config (e.g. .env), pass [baseUrl] when constructing the API client
/// (e.g. from [Config.I.baseUrl] after Config is initialized).
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://5p9ubi66hh.execute-api.ap-south-1.amazonaws.com/v1',
  );

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
