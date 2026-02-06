import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/navigation/route_redirect.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/core/router/routes/auth_routes.dart';
import 'package:nashik/core/router/routes/feature_routes.dart';
import 'package:nashik/core/router/routes/main_tab_routes.dart';
import 'package:nashik/core/router/routes/utility_routes.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';

/// App-level route observer for navigation tracking.
/// Named to avoid shadowing Flutter's [RouteObserver] from material.dart.
class AppRouteObserver extends NavigatorObserver {}

/// Main application router configuration
/// 
/// This class manages all routing configuration for the app using GoRouter.
/// Routes are organized by feature in separate files for better maintainability.
class AppRouter {
  // Singleton instance
  static final AppRouter _instance = AppRouter._internal();
  factory AppRouter() => _instance;
  AppRouter._internal();

  // Router instance
  static late final GoRouter router;

  // Route observer
  static final AppRouteObserver _routeObserver = AppRouteObserver();

  // Navigator keys for different navigation contexts
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> itineraryTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> categoryTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> eventsTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileTabNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Initialize the router
  /// 
  /// This should be called once during app initialization in main.dart
  static void init() {
    final List<RouteBase> routes = <RouteBase>[
      // Main tab navigation (bottom bar)
      MainTabRoutes.getMainTabRoute(),
      // Auth routes
      ...AuthRoutes.getRoutes(),
      // Feature routes
      ...FeatureRoutes.getRoutes(),
      // Utility routes
      ...UtilityRoutes.getRoutes(),
      // Wildcard route (404 handler)
      GoRoute(
        path: AppRoutePaths.notFound,
        pageBuilder: (context, state) {
          return getPage(child: const HomeScreen(), state: state);
        },
      ),
    ];

    router = GoRouter(
      initialLocation: AppRoutePaths.home,
      navigatorKey: parentNavigatorKey,
      routes: routes,
      redirect: RouteRedirect.handleRedirect,
      observers: [_routeObserver],
      debugLogDiagnostics: kDebugMode,
    );
  }

  /// Create a MaterialPage for route configuration
  /// 
  /// This is a helper method to create consistent page configurations
  /// across all routes.
  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
      name: state.uri.toString(),
      arguments: {'uri': state.uri},
    );
  }
}

/// Extension on GoRouter for additional utility methods
extension GoRouterExtension on GoRouter {
  /// Get the current location
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}
