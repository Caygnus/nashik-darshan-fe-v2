import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/auth/auth_guard.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/core/supabase/config.dart';

/// Route redirect handler for authentication and deep links
class RouteRedirect {
  RouteRedirect._();

  /// Routes that require authentication. Unauthenticated users are redirected to login
  /// with a return path so they can resume after signing in. All other routes are public (guest mode).
  /// Paths under profile (e.g. /profile/edit) are covered by path.startsWith(profile).
  static const List<String> protectedRoutes = [
    AppRoutePaths.profile,
  ];

  /// Auth routes: if user is already authenticated, redirect to home
  static const List<String> authRoutes = [
    AppRoutePaths.login,
    AppRoutePaths.signup,
  ];

  /// Handle route redirects
  ///
  /// Returns the route path to redirect to, or null if no redirect is needed.
  static String? handleRedirect(BuildContext context, GoRouterState state) {
    final uri = state.uri;
    final path = uri.path;
    final scheme = uri.scheme;

    // Log path/scheme only; do not log full URI (may contain OAuth codes/tokens in query)
    debugPrint(
      '🔍 Redirect check: path=$path, scheme="$scheme"',
    );

    // Handle deep links with custom scheme
    if (scheme.isNotEmpty && scheme == 'com.caygnus.nashikdarshan') {
      debugPrint('✅ Deep link detected, routing to deep link handler');
      return _handleDeepLink(uri);
    }

    // Supabase auth state (session persistence: valid session = authenticated)
    final user = SupabaseConfig.client.auth.currentUser;
    final isAuthenticated = user != null;

    // Protected routes: require authentication; pass path for redirect after login
    if (!isAuthenticated && protectedRoutes.any((r) => path.startsWith(r))) {
      debugPrint('🔒 Protected route without auth, redirecting to login (guest mode)');
      return loginPathWithRedirect(path);
    }

    // Auth routes (login/signup): if already authenticated, go to home
    if (isAuthenticated && authRoutes.any((r) => path.startsWith(r))) {
      debugPrint('✅ Already authenticated, redirecting to home');
      return AppRoutePaths.home;
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
