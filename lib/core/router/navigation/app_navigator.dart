import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';

/// Navigation utility class for type-safe navigation
/// 
/// Provides helper methods for common navigation operations
/// using centralized route names and paths.
class AppNavigator {
  AppNavigator._();

  // ==================== Navigation Methods ====================

  /// Navigate to a route by name (replaces current route)
  static void goNamed(
    BuildContext context,
    String routeName, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    context.goNamed(
      routeName,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
      extra: extra,
    );
  }

  /// Navigate to a route by path (replaces current route)
  static void go(
    BuildContext context,
    String path, {
    Object? extra,
  }) {
    context.go(path, extra: extra);
  }

  /// Push a new route by name (adds to navigation stack)
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    return context.pushNamed<T>(
      routeName,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
      extra: extra,
    );
  }

  /// Push a new route by path (adds to navigation stack)
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String path, {
    Object? extra,
  }) {
    return context.push<T>(path, extra: extra);
  }

  /// Pop the current route
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    context.pop(result);
  }

  /// Check if we can pop the current route
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  // ==================== Auth Navigation ====================

  static void goToSplash(BuildContext context) {
    goNamed(context, AppRouteNames.splash);
  }

  static void goToLogin(BuildContext context) {
    goNamed(context, AppRouteNames.login);
  }

  static void goToSignup(BuildContext context) {
    goNamed(context, AppRouteNames.signup);
  }

  static void goToOAuthCallback(BuildContext context) {
    goNamed(context, AppRouteNames.oauthCallback);
  }

  // ==================== Main Tab Navigation ====================

  static void goToItinerary(BuildContext context) {
    goNamed(context, AppRouteNames.itinerary);
  }

  static void goToCategory(BuildContext context) {
    goNamed(context, AppRouteNames.category);
  }

  static void goToHome(BuildContext context) {
    goNamed(context, AppRouteNames.home);
  }

  static void goToEvents(BuildContext context) {
    goNamed(context, AppRouteNames.events);
  }

  static void goToProfile(BuildContext context) {
    goNamed(context, AppRouteNames.profile);
  }

  // ==================== Feature Navigation ====================

  static Future<void> pushToStreetFood(BuildContext context) {
    return pushNamed(context, AppRouteNames.streetFood);
  }

  static Future<void> pushToTransport(BuildContext context) {
    return pushNamed(context, AppRouteNames.transport);
  }

  static Future<void> pushToHotels(BuildContext context) {
    return pushNamed(context, AppRouteNames.hotels);
  }

  static Future<void> pushToEatery(BuildContext context) {
    return pushNamed(context, AppRouteNames.eatery);
  }

  // ==================== Utility Navigation ====================

  static void goToDeepLinkTest(BuildContext context) {
    goNamed(context, AppRouteNames.deepLinkTest);
  }
}
