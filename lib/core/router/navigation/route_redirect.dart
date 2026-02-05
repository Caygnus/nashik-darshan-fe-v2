import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/core/supabase/config.dart';

/// Route redirect handler for authentication and deep links
class RouteRedirect {
  RouteRedirect._();

  /// List of protected routes that require authentication
  static const List<String> protectedRoutes = [
    AppRoutePaths.profile,
  ];

  /// Handle route redirects
  ///
  /// Returns the route path to redirect to, or null if no redirect is needed.
  static String? handleRedirect(BuildContext context, GoRouterState state) {
    final uri = state.uri;
    final path = uri.path;
    final scheme = uri.scheme;

    debugPrint(
      '🔍 Redirect check: path=$path, scheme="$scheme", fullUri=${uri.toString()}',
    );

    // Handle deep links with custom scheme
    if (scheme.isNotEmpty && scheme == 'com.caygnus.nashikdarshan') {
      debugPrint('✅ Deep link detected, routing to deep link handler');
      return _handleDeepLink(uri);
    }

    // Protected routes: require Supabase auth (Supabase is initialized before router)
    final user = SupabaseConfig.client.auth.currentUser;
    if (user == null && protectedRoutes.any((r) => path.startsWith(r))) {
      debugPrint('🔒 Protected route without auth, redirecting to login');
      return AppRoutePaths.login;
    }

    debugPrint('✅ No redirect needed');
    return null;
  }

  /// Handle deep link routing
  static String? _handleDeepLink(Uri uri) {
    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    // OAuth callback deep links
    if (host == 'login-callback' ||
        host == 'auth-callback' ||
        path == '/login-callback' ||
        path == '/auth-callback') {
      // For OAuth, pass the full deep link URI as a query parameter
      return Uri(
        path: AppRoutePaths.oauthCallback,
        queryParameters: {'deep_link': uri.toString()},
      ).toString();
    }

    // Test deep link
    if (host == 'test' || path == '/test') {
      // For test page, pass all query parameters from the deep link
      return Uri(
        path: AppRoutePaths.deepLinkTest,
        queryParameters: uri.queryParameters,
      ).toString();
    }

    // Unknown deep link, redirect to home
    return AppRoutePaths.home;
  }
}
