import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/dtos/signup_request.dart';
import 'package:nashik/features/auth/domain/dtos/signup_response.dart';
import 'package:nashik/features/auth/domain/dtos/update_user_request.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/params/signin_with_email_params.dart';
import 'package:nashik/features/auth/domain/params/signup_with_email_params.dart';

abstract class AuthRepository extends BaseRepository {
  /// Sign up with email: obtains token via Supabase, then registers with backend.
  Future<Result<SignupResponse>> signUpWithEmail(SignupWithEmailParams params);

  /// Sign in with email: obtains token via Supabase, then fetches current user.
  Future<Result<User>> signInWithEmail(SigninWithEmailParams params);

  /// Sign up (backend only, with existing token). Used internally.
  Future<Result<SignupResponse>> signup(SignupRequest request);

  /// Get current authenticated user
  Future<Result<User>> getCurrentUser();

  /// Update current user information
  Future<Result<User>> updateUser(UpdateUserRequest request);

  /// Sign out (clear token and Supabase session).
  Future<Result<Unit>> signOut();

  /// Initiate Google sign-in via OAuth. Returns true if flow started.
  Future<Result<bool>> signInWithGoogle();

  /// Send password reset email to [email].
  Future<Result<Unit>> resetPassword(String email);

  /// Verify email OTP. Returns the authenticated user.
  Future<Result<User>> verifyEmail(String token, String email);

  /// Complete OAuth callback: create session from [deepLinkUri], ensure user in backend, return user.
  Future<Result<User>> completeOAuthCallback(Uri deepLinkUri);
}
