import 'package:nashik/core/supabase/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Google Sign-In with Supabase using OAuth redirect
///
/// This service uses Supabase's built-in OAuth flow which handles
/// the entire authentication process including token exchange.
///
/// Flow:
/// 1. User taps "Sign in with Google"
/// 2. App calls Supabase's signInWithOAuth() which opens browser/WebView
/// 3. User signs in with Google in the browser
/// 4. Google redirects back to app via deep link
/// 5. Supabase automatically handles the callback and creates session
/// 6. User is authenticated in the app via Supabase
///
/// Advantages:
/// - Simpler setup (no need for google_sign_in package)
/// - No need for Web OAuth Client ID in .env
/// - Supabase handles all token management
/// - Works consistently across platforms
///
/// Note: The OAuth Client IDs must be configured in:
/// - Google Cloud Console:
///   - Web OAuth Client ID (REQUIRED - used by Supabase)
///   - Android OAuth Client ID (optional, for better UX)
///   - iOS OAuth Client ID (optional, for better UX)
/// - Supabase Dashboard (Authentication → Providers → Google)
///   - Add Web OAuth Client ID and Client Secret
///   - Add Android/iOS Client IDs if created
class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  /// Deep link redirect URL for OAuth callback
  static const String _redirectUrl =
      'com.caygnus.nashikdarshan://login-callback/';

  /// Sign in with Google using Supabase's OAuth flow
  ///
  /// This opens a browser/WebView for Google sign-in and redirects back
  /// to the app via deep link. Supabase handles the session automatically.
  ///
  /// Returns true if the OAuth flow was initiated successfully
  /// The actual authentication is handled via the deep link callback
  ///
  /// Throws Exception if sign-in fails
  Future<bool> signInWithGoogle() async {
    try {
      // Initiate OAuth flow with Supabase
      // This will open a browser/WebView for Google sign-in
      await SupabaseConfig.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _redirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      // Return true to indicate OAuth flow was initiated
      // The actual session will be created when the deep link callback is handled
      return true;
    } catch (e) {
      throw Exception(
        'Failed to initiate Google Sign-In: $e\n'
        'Please ensure:\n'
        '1. Google provider is enabled in Supabase Dashboard\n'
        '2. Web OAuth Client ID and Secret are configured in Supabase\n'
        '3. Redirect URL is configured in Supabase: $_redirectUrl',
      );
    }
  }

  /// Sign out from Google and Supabase
  Future<void> signOut() async {
    try {
      // Sign out from Supabase (this also signs out from Google OAuth)
      await SupabaseConfig.client.auth.signOut();
    } catch (e) {
      // Ignore errors during sign out
    }
  }

  /// Check if user is signed in
  Future<bool> isSignedIn() async {
    final session = SupabaseConfig.client.auth.currentSession;
    return session != null;
  }
}
