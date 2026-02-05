import 'package:nashik/core/error/exceptions/server_exception.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/core/supabase/supabase_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// OAuth redirect URL for Google sign-in callback
const String authOAuthRedirectUrl = 'com.caygnus.nashikdarshan://login-callback/';

/// Data source for Supabase authentication operations
/// This handles the Supabase-specific authentication logic
abstract class AuthSupabaseDataSource {
  /// Sign up with email and password in Supabase
  /// Returns the access token from Supabase
  /// If email confirmation is required, redirectTo is used for email verification link
  Future<String> signUpWithEmail({
    required String email,
    required String password,
    String? redirectTo,
  });

  /// Sign in with email and password in Supabase
  /// Returns the access token from Supabase
  Future<String> signInWithEmail({
    required String email,
    required String password,
  });

  /// Get current Supabase session access token
  String? getCurrentAccessToken();

  /// Initiate Google sign-in via Supabase OAuth. Returns true if flow started.
  Future<bool> signInWithGoogle();

  /// Sign out from Supabase (and any OAuth provider).
  Future<void> signOut();

  /// Send password reset email. [redirectTo] is the deep link for reset callback.
  Future<void> resetPasswordForEmail(String email, String redirectTo);

  /// Verify OTP (e.g. email verification). Returns the session access token.
  Future<String> verifyOTP(String token, String email);

  /// Create session from OAuth callback URL. Returns the access token.
  Future<String> getSessionFromUrl(Uri uri);

  /// Metadata of current Supabase user (email, full_name, name, display_name, phone). Null if no session.
  Future<Map<String, dynamic>?> getCurrentUserMetadata();
}

class AuthSupabaseDataSourceImpl implements AuthSupabaseDataSource {
  @override
  Future<String> signUpWithEmail({
    required String email,
    required String password,
    String? redirectTo,
  }) async {
    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: redirectTo,
      );

      // If email confirmation is required, session might be null
      // In that case, we still return success (user needs to verify email)
      if (response.session == null) {
        // Email confirmation required - user will verify via email link
        // The access token will be available after email verification
        // For now, we throw an exception to indicate email verification is needed
        throw ServerException(
          message:
              'Please check your email to verify your account. A verification link has been sent.',
          code: 'EMAIL_CONFIRMATION_REQUIRED',
        );
      }

      SupabaseLogger.auth('Sign up success', action: 'email');
      return response.session!.accessToken;
    } on ServerException {
      rethrow;
    } on AuthException catch (e) {
      SupabaseLogger.auth('Sign up failed: ${e.message}', action: 'email');
      throw ServerException(message: e.message, code: 'SUPABASE_AUTH_ERROR');
    } catch (e) {
      SupabaseLogger.error('Sign up failed', e);
      throw ServerException(
        message: 'Failed to sign up with Supabase: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<String> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw ServerException(
          message: 'Sign in failed: No session returned',
          code: 'SUPABASE_SIGNIN_FAILED',
        );
      }

      SupabaseLogger.auth('Sign in success', action: 'email');
      return response.session!.accessToken;
    } on AuthException catch (e) {
      SupabaseLogger.auth('Sign in failed: ${e.message}', action: 'email');
      throw ServerException(message: e.message, code: 'SUPABASE_AUTH_ERROR');
    } catch (e) {
      SupabaseLogger.error('Sign in failed', e);
      throw ServerException(
        message: 'Failed to sign in with Supabase: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  String? getCurrentAccessToken() {
    try {
      final session = SupabaseConfig.client.auth.currentSession;
      return session?.accessToken;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      SupabaseLogger.oauth('Initiating Google OAuth, redirectTo: $authOAuthRedirectUrl');
      await SupabaseConfig.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: authOAuthRedirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      SupabaseLogger.oauth('Google OAuth flow started');
      return true;
    } catch (e) {
      SupabaseLogger.oauth('Google OAuth failed: $e', error: true);
      throw ServerException(
        message:
            'Failed to initiate Google Sign-In: $e\n'
            'Please ensure Google provider is enabled and redirect URL is configured: $authOAuthRedirectUrl',
        code: 'OAUTH_ERROR',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
      SupabaseLogger.auth('Sign out success');
    } catch (e) {
      SupabaseLogger.auth('Sign out (non-fatal): $e');
      // Ignore errors during sign out
    }
  }

  @override
  Future<void> resetPasswordForEmail(String email, String redirectTo) async {
    try {
      await SupabaseConfig.client.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
    } on AuthException catch (e) {
      throw ServerException(message: e.message, code: 'SUPABASE_AUTH_ERROR');
    } catch (e) {
      throw ServerException(
        message: 'Failed to send password reset: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<String> verifyOTP(String token, String email) async {
    try {
      final response = await SupabaseConfig.client.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: email,
      );
      if (response.session == null) {
        throw ServerException(
          message: 'Email verification did not return a session',
          code: 'VERIFY_OTP_FAILED',
        );
      }
      return response.session!.accessToken;
    } on AuthException catch (e) {
      throw ServerException(message: e.message, code: 'SUPABASE_AUTH_ERROR');
    } catch (e) {
      throw ServerException(
        message: 'Failed to verify email: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<String> getSessionFromUrl(Uri uri) async {
    try {
      SupabaseLogger.oauth('Processing OAuth callback from URL');
      await SupabaseConfig.client.auth.getSessionFromUrl(uri);
      final session = SupabaseConfig.client.auth.currentSession;
      if (session == null || session.accessToken.isEmpty) {
        SupabaseLogger.oauth('OAuth callback: no session after getSessionFromUrl', error: true);
        throw ServerException(
          message: 'Failed to create or retrieve session from OAuth callback',
          code: 'OAUTH_CALLBACK_FAILED',
        );
      }
      SupabaseLogger.oauth('OAuth callback success, session created');
      return session.accessToken;
    } on AuthException catch (e) {
      SupabaseLogger.oauth('OAuth callback auth error: ${e.message}', error: true);
      throw ServerException(message: e.message, code: 'SUPABASE_AUTH_ERROR');
    } catch (e) {
      SupabaseLogger.error('OAuth callback failed', e);
      throw ServerException(
        message: 'OAuth callback failed: ${e.toString()}',
        code: 'OAUTH_CALLBACK_FAILED',
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUserMetadata() async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user == null) return null;
    return {
      'email': user.email,
      'full_name': user.userMetadata?['full_name'],
      'name': user.userMetadata?['name'],
      'display_name': user.userMetadata?['display_name'],
      'phone': user.phone,
    };
  }
}
