import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/features/eatery/presentation/pages/eatery_screen.dart';
import 'package:nashik/features/hotels/presentation/pages/hotels_screen.dart';
import 'package:nashik/features/street_food/presentation/pages/street_food_screen.dart';
import 'package:nashik/features/transport/presentation/pages/transport_screen.dart';

/// Feature routes (standalone screens)
class FeatureRoutes {
  FeatureRoutes._();

  /// Get all feature routes
  static List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: AppRoutePaths.streetFood,
        name: AppRouteNames.streetFood,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const StreetFoodScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.transport,
        name: AppRouteNames.transport,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const TransportScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.hotels,
        name: AppRouteNames.hotels,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const HotelsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.eatery,
        name: AppRouteNames.eatery,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const EateryScreen(),
          state: state,
        ),
      ),
    ];
  }
}
