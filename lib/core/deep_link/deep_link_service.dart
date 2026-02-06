import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:nashik/core/deep_link/deep_link_type.dart';
import 'package:nashik/core/router/app_router.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  bool _hasProcessedInitialLink = false;

  void initialize() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (Object err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (uri.scheme != DeepLinkType.scheme) {
      return;
    }

    final deepLinkType = DeepLinkType.fromUri(uri);
    final routePath = deepLinkType.getRoutePath(uri);

    if (routePath != null) {
      if (deepLinkType == DeepLinkType.test) {
        debugPrint('✅ Test deep link received! Deep linking is working.');
      }
      AppRouter.router.go(routePath);
    }
  }

  Future<Uri?> getInitialLink() async {
    // Only process initial link once at app startup
    if (_hasProcessedInitialLink) {
      return null;
    }

    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _hasProcessedInitialLink = true;
        await _handleDeepLink(uri);
      }
      return uri;
    } catch (e) {
      debugPrint('Error getting initial link: $e');
      return null;
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
