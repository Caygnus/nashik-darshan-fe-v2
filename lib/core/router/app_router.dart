import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/presentation/pages/bottom_bar_page.dart';
import 'package:nashik/core/presentation/pages/deep_link_test_page.dart';
import 'package:nashik/features/auth/presentation/pages/login_page.dart';
import 'package:nashik/features/auth/presentation/pages/oauth_callback_page.dart';
import 'package:nashik/features/auth/presentation/pages/signup_page.dart';
import 'package:nashik/features/auth/presentation/pages/splash_screen.dart';
import 'package:nashik/features/category/presentation/pages/category_page.dart';
import 'package:nashik/features/eatery/presentation/pages/eatery_screen.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';
import 'package:nashik/features/hotels/presentation/pages/hotels_screen.dart';
import 'package:nashik/features/iternary/presentation/pages/iternary_page.dart';
import 'package:nashik/features/profile/presentation/pages/profile_page.dart';
import 'package:nashik/features/street_food/presentation/pages/street_food_screen.dart';
import 'package:nashik/features/transport/presentation/pages/transport_screen.dart';

class RouteObserver extends NavigatorObserver {}

class Approuter {
  static final Approuter _instance = Approuter.init();

  static final instance = _instance;
  static late final GoRouter router;
  static final RouteObserver _routeObserver = RouteObserver();

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> categoryTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> itineraryTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileTabNavigatorKey =
      GlobalKey<NavigatorState>();

  Approuter.init() {
    final List<RouteBase> routes = <RouteBase>[
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        pageBuilder: (context, state, navigationShell) => getPage(
          child: BottomBarPage(shell: navigationShell),
          state: state,
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: homeTabNavigatorKey,
            routes: [
              GoRoute(
                path: HomeScreen.routePath,
                name: HomeScreen.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const HomeScreen(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: categoryTabNavigatorKey,
            routes: [
              GoRoute(
                path: CategoryPage.routePath,
                name: CategoryPage.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const CategoryPage(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: itineraryTabNavigatorKey,
            routes: [
              GoRoute(
                path: IternaryPage.routePath,
                name: IternaryPage.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const IternaryPage(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileTabNavigatorKey,
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                name: ProfilePage.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const ProfilePage(), state: state),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: StreetFoodScreen.routePath,
        name: StreetFoodScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const StreetFoodScreen(), state: state),
      ),
      GoRoute(
        path: TransportScreen.routePath,
        name: TransportScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const TransportScreen(), state: state),
      ),
      GoRoute(
        path: HotelsScreen.routePath,
        name: HotelsScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const HotelsScreen(), state: state),
      ),
      GoRoute(
        path: EateryScreen.routePath,
        name: EateryScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const EateryScreen(), state: state),
      ),
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const SplashScreen(), state: state),
      ),
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const LoginPage(), state: state),
      ),
      GoRoute(
        path: SignupPage.routePath,
        name: SignupPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const SignupPage(), state: state),
      ),
      GoRoute(
        path: OAuthCallbackPage.routePath,
        name: OAuthCallbackPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const OAuthCallbackPage(), state: state),
      ),
      GoRoute(
        path: DeepLinkTestPage.routePath,
        name: DeepLinkTestPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const DeepLinkTestPage(), state: state),
      ),
      GoRoute(
        path: '/:path(.*)',
        pageBuilder: (context, state) {
          return getPage(child: const HomeScreen(), state: state);
        },
      ),
    ];
    router = GoRouter(
      initialLocation: HomeScreen.routePath,
      navigatorKey: parentNavigatorKey,
      routes: routes,
      redirect: handleRedirect,
      observers: [_routeObserver],
      debugLogDiagnostics: false,
    );
  }

  static Page getPage({required Widget child, required GoRouterState state}) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
      name: state.uri.toString(),
      arguments: {'uri': state.uri},
    );
  }
}

extension GoRouterExtension on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  Stream<String> get locationStream =>
      Stream<String>.periodic(const Duration(seconds: 1), (computationCount) {
        return Approuter.router.location;
      });
}

final List<String> protectedRoutes = [ProfilePage.routePath];

enum DeepLinkType {
  oauthCallback,
  test,
  unknown;

  static DeepLinkType fromUri(Uri uri) {
    if (uri.scheme != 'com.caygnus.nashikdarshan') {
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

  String? getRoutePath(Uri originalUri) {
    switch (this) {
      case DeepLinkType.oauthCallback:
        // For OAuth, pass the full deep link URI as a query parameter
        // This preserves all query params from the original deep link
        return Uri(
          path: OAuthCallbackPage.routePath,
          queryParameters: {'deep_link': originalUri.toString()},
        ).toString();
      case DeepLinkType.test:
        // For test page, pass all query parameters from the deep link
        return Uri(
          path: DeepLinkTestPage.routePath,
          queryParameters: originalUri.queryParameters,
        ).toString();
      case DeepLinkType.unknown:
        return HomeScreen.routePath;
    }
  }
}

String? handleRedirect(BuildContext context, GoRouterState state) {
  final uri = state.uri;
  final path = uri.path;
  final scheme = uri.scheme;

  debugPrint(
    '🔍 Redirect check: path=$path, scheme="$scheme", fullUri=${uri.toString()}',
  );

  // Only handle deep links with our custom scheme
  // For normal navigation, scheme will be empty or 'http'/'https', not our custom scheme
  if (scheme.isNotEmpty && scheme == 'com.caygnus.nashikdarshan') {
    debugPrint('✅ Deep link detected, routing to deep link handler');
    final deepLinkType = DeepLinkType.fromUri(uri);
    return deepLinkType.getRoutePath(uri);
  }

  // TODO: Uncomment when Supabase is initialized
  // Handle protected routes (only for normal app navigation, not deep links)
  // final user = SupabaseConfig.client.auth.currentUser;
  // if (user == null && protectedRoutes.contains(path)) {
  //   debugPrint('🔒 Protected route without auth, redirecting to login');
  //   return LoginPage.routePath;
  // }

  debugPrint('✅ No redirect needed');
  return null;
}
