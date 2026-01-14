import 'package:go_router/go_router.dart';
import 'package:nashik/core/presentation/pages/bottom_bar_page.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/features/category/presentation/pages/category_page.dart';
import 'package:nashik/features/events/presentation/pages/events_page.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';
import 'package:nashik/features/iternary/presentation/pages/iternary_page.dart';
import 'package:nashik/features/profile/presentation/pages/profile_page.dart';

/// Main tab routes (bottom navigation bar)
class MainTabRoutes {
  MainTabRoutes._();

  /// Get the main tab shell route with all branches
  static StatefulShellRoute getMainTabRoute() {
    return StatefulShellRoute.indexedStack(
      parentNavigatorKey: AppRouter.parentNavigatorKey,
      pageBuilder: (context, state, navigationShell) => AppRouter.getPage(
        child: BottomBarPage(shell: navigationShell),
        state: state,
      ),
      branches: [
        // Itinerary Tab (Index 0)
        StatefulShellBranch(
          navigatorKey: AppRouter.itineraryTabNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutePaths.itinerary,
              name: AppRouteNames.itinerary,
              pageBuilder: (context, state) => AppRouter.getPage(
                child: const IternaryPage(),
                state: state,
              ),
            ),
          ],
        ),
        // Category Tab (Index 1)
        StatefulShellBranch(
          navigatorKey: AppRouter.categoryTabNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutePaths.category,
              name: AppRouteNames.category,
              pageBuilder: (context, state) => AppRouter.getPage(
                child: const CategoryPage(),
                state: state,
              ),
            ),
          ],
        ),
        // Home Tab (Index 2) - Center position, main screen
        StatefulShellBranch(
          navigatorKey: AppRouter.homeTabNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutePaths.home,
              name: AppRouteNames.home,
              pageBuilder: (context, state) => AppRouter.getPage(
                child: const HomeScreen(),
                state: state,
              ),
            ),
          ],
        ),
        // Events Tab (Index 3)
        StatefulShellBranch(
          navigatorKey: AppRouter.eventsTabNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutePaths.events,
              name: AppRouteNames.events,
              pageBuilder: (context, state) => AppRouter.getPage(
                child: const EventsPage(),
                state: state,
              ),
            ),
          ],
        ),
        // Profile Tab (Index 4)
        StatefulShellBranch(
          navigatorKey: AppRouter.profileTabNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutePaths.profile,
              name: AppRouteNames.profile,
              pageBuilder: (context, state) => AppRouter.getPage(
                child: const ProfilePage(),
                state: state,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
