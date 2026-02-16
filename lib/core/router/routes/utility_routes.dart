import 'package:go_router/go_router.dart';
import 'package:nashik/core/presentation/pages/deep_link_test_page.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/router/route_paths.dart';

/// Utility routes (debug, testing, etc.)
class UtilityRoutes {
  UtilityRoutes._();

  /// Get all utility routes
  static List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: AppRoutePaths.deepLinkTest,
        name: AppRouteNames.deepLinkTest,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const DeepLinkTestPage(),
          state: state,
        ),
      ),
    ];
  }
}
