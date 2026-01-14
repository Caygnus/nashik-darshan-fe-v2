import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/features/auth/presentation/pages/login_page.dart';
import 'package:nashik/features/auth/presentation/pages/oauth_callback_page.dart';
import 'package:nashik/features/auth/presentation/pages/signup_page.dart';
import 'package:nashik/features/auth/presentation/pages/splash_screen.dart';

/// Auth feature routes
class AuthRoutes {
  AuthRoutes._();

  /// Get all auth routes
  static List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: AppRoutePaths.splash,
        name: AppRouteNames.splash,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const SplashScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.login,
        name: AppRouteNames.login,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const LoginPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.signup,
        name: AppRouteNames.signup,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const SignupPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.oauthCallback,
        name: AppRouteNames.oauthCallback,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const OAuthCallbackPage(),
          state: state,
        ),
      ),
    ];
  }
}
