# Routing Guide - GoRouter Setup

This document describes the routing architecture and navigation setup for the Nashik Darshan app using GoRouter.

## Folder Structure

```
lib/core/router/
├── app_router.dart              # Main router configuration
├── route_names.dart              # Centralized route names
├── route_paths.dart             # Centralized route paths
├── routes/                       # Route definitions by feature
│   ├── auth_routes.dart         # Authentication routes
│   ├── main_tab_routes.dart     # Bottom navigation tab routes
│   ├── feature_routes.dart      # Standalone feature routes
│   └── utility_routes.dart      # Utility/debug routes
└── navigation/                   # Navigation utilities
    ├── app_navigator.dart       # Navigation helper methods
    └── route_redirect.dart      # Route redirect handler
```

## Route Constants

### Route Paths (`route_paths.dart`)

All route paths are defined as constants in `AppRoutePaths`:

```dart
AppRoutePaths.home          // '/home'
AppRoutePaths.login         // '/login'
AppRoutePaths.profile       // '/profile'
// etc.
```

### Route Names (`route_names.dart`)

All route names are defined as constants in `AppRouteNames`:

```dart
AppRouteNames.home          // 'home'
AppRouteNames.login         // 'login'
AppRouteNames.profile       // 'profile'
// etc.
```

## Navigation

### Using AppNavigator (Recommended)

The `AppNavigator` class provides type-safe navigation methods:

```dart
import 'package:nashik/core/router/navigation/app_navigator.dart';

// Navigate to a route (replaces current)
AppNavigator.goToHome(context);
AppNavigator.goToLogin(context);

// Push a new route (adds to stack)
AppNavigator.pushToStreetFood(context);
AppNavigator.pushToTransport(context);

// Pop current route
AppNavigator.pop(context);
```

### Using GoRouter Directly

You can also use GoRouter's context extensions:

```dart
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';

// Navigate by name
context.goNamed(AppRouteNames.home);
context.pushNamed(AppRouteNames.streetFood);

// Navigate by path
context.go(AppRoutePaths.home);
context.push(AppRoutePaths.streetFood);
```

## Route Organization

### Main Tab Routes

Routes that appear in the bottom navigation bar:

- **Home** (`/home`) - Main home screen
- **Category** (`/category`) - Category browsing
- **Itinerary** (`/itinerary`) - Trip planning
- **Profile** (`/profile`) - User profile

These routes use `StatefulShellRoute` to maintain separate navigation stacks for each tab.

### Auth Routes

Authentication-related routes:

- **Splash** (`/splash`) - Splash screen
- **Login** (`/login`) - Login page
- **Signup** (`/signup`) - Signup page
- **OAuth Callback** (`/oauth-callback`) - OAuth callback handler

### Feature Routes

Standalone feature screens (pushed onto navigation stack):

- **Street Food** (`/street-food`) - Street food listings
- **Transport** (`/transport`) - Transportation options
- **Hotels** (`/hotels`) - Hotel listings
- **Eatery** (`/eatery`) - Restaurant listings

### Utility Routes

Debug and utility routes:

- **Deep Link Test** (`/deep-link-test`) - Deep link testing page

## Route Protection

Protected routes are defined in `route_redirect.dart`:

```dart
static const List<String> protectedRoutes = [
  AppRoutePaths.profile,
];
```

When Supabase is initialized, unauthenticated users will be redirected to the login page when accessing protected routes.

## Deep Linking

Deep links are handled in `RouteRedirect.handleRedirect()`:

- **OAuth Callbacks**: `com.caygnus.nashikdarshan://login-callback`
- **Test Links**: `com.caygnus.nashikdarshan://test`

## Adding New Routes

### Step 1: Add Route Constants

Add the route path and name to the constants files:

```dart
// In route_paths.dart
static const String newFeature = '/new-feature';

// In route_names.dart
static const String newFeature = 'new-feature';
```

### Step 2: Create Route Definition

Add the route to the appropriate routes file:

```dart
// In feature_routes.dart (or appropriate file)
GoRoute(
  path: AppRoutePaths.newFeature,
  name: AppRouteNames.newFeature,
  pageBuilder: (context, state) => AppRouter.getPage(
    child: const NewFeatureScreen(),
    state: state,
  ),
),
```

### Step 3: Add Navigation Helper (Optional)

Add a helper method to `AppNavigator`:

```dart
static Future<void> pushToNewFeature(BuildContext context) {
  return pushNamed(context, AppRouteNames.newFeature);
}
```

## Best Practices

1. **Always use route constants** - Never hardcode route paths or names
2. **Use AppNavigator** - Prefer `AppNavigator` methods over direct GoRouter calls
3. **Organize by feature** - Keep routes organized in feature-specific files
4. **Type safety** - Use route names with `goNamed()` and `pushNamed()`
5. **Protected routes** - Add authentication-required routes to `protectedRoutes` list

## Migration from Old Structure

If you're updating existing code:

1. Replace `HomeScreen.routePath` with `AppRoutePaths.home`
2. Replace `HomeScreen.routeName` with `AppRouteNames.home`
3. Replace `context.goNamed(HomeScreen.routeName)` with `AppNavigator.goToHome(context)`
4. Remove `routePath` and `routeName` constants from page classes (optional, for consistency)

## Example Usage

```dart
// In a widget
import 'package:nashik/core/router/navigation/app_navigator.dart';

ElevatedButton(
  onPressed: () => AppNavigator.pushToStreetFood(context),
  child: Text('View Street Food'),
)

// With parameters
AppNavigator.pushNamed(
  context,
  AppRouteNames.hotels,
  queryParameters: {'category': 'luxury'},
);

// Navigation with result
final result = await AppNavigator.pushNamed<String>(
  context,
  AppRouteNames.profile,
);
if (result != null) {
  // Handle result
}
```
