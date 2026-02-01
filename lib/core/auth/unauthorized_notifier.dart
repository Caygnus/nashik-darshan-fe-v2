/// Notifier for 401 Unauthorized. ApiClient's interceptor calls [trigger]
/// so the app can sign out. AuthCubit registers its [signOut] via [setCallback].
/// Core layer: uses void Function() to avoid Flutter dependency.
class UnauthorizedNotifier {
  void Function()? _onUnauthorized;

  void setCallback(void Function() callback) {
    _onUnauthorized = callback;
  }

  void trigger() {
    _onUnauthorized?.call();
  }
}
