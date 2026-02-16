/// Notifier for 401 Unauthorized. ApiClient's interceptor calls [trigger]
/// so the app can sign out. AuthCubit registers its [signOut] via [setCallback].
/// Call [clearCallback] when the listener is disposed to avoid stale references.
/// Core layer: uses void Function() to avoid Flutter dependency.
class UnauthorizedNotifier {
  void Function()? _onUnauthorized;

  void setCallback(void Function() callback) {
    _onUnauthorized = callback;
  }

  /// Removes the current callback. Call when the listener (e.g. AuthCubit) is disposed.
  void clearCallback() {
    _onUnauthorized = null;
  }

  void trigger() {
    _onUnauthorized?.call();
  }
}
