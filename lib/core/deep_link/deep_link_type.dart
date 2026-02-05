import 'package:nashik/core/router/route_paths.dart';

/// Deep link types for handling different deep link scenarios
enum DeepLinkType {
  oauthCallback,
  test,
  unknown;

  /// Deep link URL scheme for the app.
  static const String scheme = 'com.caygnus.nashikdarshan';

  /// Determine deep link type from URI
  static DeepLinkType fromUri(Uri uri) {
    if (uri.scheme != scheme) {
      return DeepLinkType.unknown;
    }

    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    // OAuth callback deep links
    if (host == 'login-callback' ||
        host == 'auth-callback' ||
        path == '/login-callback' ||
        path == '/auth-callback') {
      return DeepLinkType.oauthCallback;
    }

    // Test deep link
    if (host == 'test' || path == '/test') {
      return DeepLinkType.test;
    }

    return DeepLinkType.unknown;
  }

  /// Get route path for the deep link type
  String? getRoutePath(Uri originalUri) {
    switch (this) {
      case DeepLinkType.oauthCallback:
        // For OAuth, pass the full deep link URI as a query parameter
        // This preserves all query params from the original deep link
        return Uri(
          path: AppRoutePaths.oauthCallback,
          queryParameters: {'deep_link': originalUri.toString()},
        ).toString();
      case DeepLinkType.test:
        // For test page, pass all query parameters from the deep link
        return Uri(
          path: AppRoutePaths.deepLinkTest,
          queryParameters: originalUri.queryParameters,
        ).toString();
      case DeepLinkType.unknown:
        return AppRoutePaths.home;
    }
  }
}
