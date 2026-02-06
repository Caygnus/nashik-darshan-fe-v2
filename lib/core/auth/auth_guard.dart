import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_paths.dart';

/// Central place for guest-mode and feature gating.
/// Unauthenticated users can browse; protected routes/actions require login.

/// Query param added to login (and signup) to redirect after successful auth.
const String kRedirectAfterLoginParam = 'redirect';

/// Builds login path with optional return path for redirect after login.
String loginPathWithRedirect([String? returnPath]) {
  if (returnPath == null || returnPath.isEmpty) return AppRoutePaths.login;
  return '${AppRoutePaths.login}?$kRedirectAfterLoginParam=${Uri.encodeComponent(returnPath)}';
}

/// Returns the path to redirect to after login from [uri] query params, or null if missing/invalid.
/// Only allows relative app paths (starts with /) to avoid open redirects.
String? redirectPathFromUri(Uri uri) {
  final value = uri.queryParameters[kRedirectAfterLoginParam];
  if (value == null || value.isEmpty) return null;
  final decoded = Uri.decodeComponent(value);
  if (!decoded.startsWith('/')) return null;
  return decoded;
}

/// Shows a polite login-required dialog. On "Log in to continue", navigates to login
/// with [returnPath] so the user is sent back after successful auth.
/// Use before executing a protected action (e.g. save, add to wishlist, comment).
/// For full-screen protected routes, use [RouteRedirect.protectedRoutes] instead.
void showLoginRequiredDialog(
  BuildContext context, {
  String? message,
  String? returnPath,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Login required'),
      content: Text(
        message ??
            'Please sign in to use this feature. You can continue browsing without an account.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.go(loginPathWithRedirect(returnPath));
          },
          child: const Text('Log in to continue'),
        ),
      ],
    ),
  );
}
