import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/error/failures/server_failure.dart';
import 'package:nashik/core/storage/secure_token_storage.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nashik/features/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:nashik/features/auth/data/models/signup_request_model.dart';
import 'package:nashik/features/auth/data/models/update_user_request_model.dart';
import 'package:nashik/features/auth/data/models/user_model.dart';
import 'package:nashik/features/auth/domain/dtos/signup_request.dart';
import 'package:nashik/features/auth/domain/dtos/signup_response.dart';
import 'package:nashik/features/auth/domain/dtos/update_user_request.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/params/signin_with_email_params.dart';
import 'package:nashik/features/auth/domain/params/signup_with_email_params.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthSupabaseDataSource supabaseDataSource;
  final SecureTokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.supabaseDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Result<SignupResponse>> signUpWithEmail(SignupWithEmailParams params) async {
    final supabaseResult = await executeWithErrorHandling<String>(() async {
      return await supabaseDataSource.signUpWithEmail(
        email: params.email,
        password: params.password,
        redirectTo: 'com.caygnus.nashikdarshan://verify-email/',
      );
    });
    return supabaseResult.fold(
      (failure) async => Left(failure),
      (accessToken) async => signup(SignupRequest(
        email: params.email,
        phone: params.phone,
        name: params.name,
        accessToken: accessToken,
      )),
    );
  }

  @override
  Future<Result<User>> signInWithEmail(SigninWithEmailParams params) async {
    final supabaseResult = await executeWithErrorHandling<String>(() async {
      final token = await supabaseDataSource.signInWithEmail(
        email: params.email,
        password: params.password,
      );
      await tokenStorage.setAccessToken(token);
      return token;
    });
    return supabaseResult.fold(
      (failure) => Left(failure),
      (_) async => getCurrentUser(),
    );
  }

  @override
  Future<Result<SignupResponse>> signup(SignupRequest request) async {
    return executeWithErrorHandling<SignupResponse>(() async {
      // Convert domain DTO to data model for API call
      final requestModel = SignupRequestModel(
        email: request.email,
        phone: request.phone,
        name: request.name,
        accessToken: request.accessToken,
      );

      // Call backend API with Supabase access token
      final responseModel = await remoteDataSource.signup(requestModel);

      // Convert data model to domain DTO
      return SignupResponse(
        id: responseModel.id,
        accessToken: responseModel.accessToken,
      );
    });
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    return executeWithErrorHandling<User>(() async {
      final userModel = await remoteDataSource.getCurrentUser();
      return userModel.toEntity();
    });
  }

  @override
  Future<Result<User>> updateUser(UpdateUserRequest request) async {
    return executeWithErrorHandling<User>(() async {
      // Convert domain DTO to data model for API call
      final requestModel = UpdateUserRequestModel(
        name: request.name,
        phone: request.phone,
      );

      final userModel = await remoteDataSource.updateUser(requestModel);
      return userModel.toEntity();
    });
  }

  @override
  Future<Result<Unit>> signOut() async {
    return executeWithErrorHandling<Unit>(() async {
      await tokenStorage.deleteAccessToken();
      await supabaseDataSource.signOut();
      return unit;
    });
  }

  @override
  Future<Result<bool>> signInWithGoogle() async {
    return executeWithErrorHandling<bool>(() async {
      return await supabaseDataSource.signInWithGoogle();
    });
  }

  @override
  Future<Result<Unit>> resetPassword(String email) async {
    const redirectTo = 'com.caygnus.nashikdarshan://reset-password/';
    return executeWithErrorHandling<Unit>(() async {
      await supabaseDataSource.resetPasswordForEmail(email, redirectTo);
      return unit;
    });
  }

  @override
  Future<Result<User>> verifyEmail(String token, String email) async {
    final tokenResult = await executeWithErrorHandling<String>(() async {
      final accessToken = await supabaseDataSource.verifyOTP(token, email);
      await tokenStorage.setAccessToken(accessToken);
      return accessToken;
    });
    return tokenResult.fold(
      (failure) => Left(failure),
      (_) async => getCurrentUser(),
    );
  }

  @override
  Future<Result<User>> completeOAuthCallback(Uri deepLinkUri) async {
    final tokenResult = await executeWithErrorHandling<String>(() async {
      final accessToken = await supabaseDataSource.getSessionFromUrl(deepLinkUri);
      await tokenStorage.setAccessToken(accessToken);
      return accessToken;
    });
    return tokenResult.fold(
      (failure) => Left(failure),
      (_) async => _ensureCurrentUserInBackendThenGetUser(),
    );
  }

  /// After OAuth we may have a Supabase session but no backend user; create one if needed then return user.
  Future<Result<User>> _ensureCurrentUserInBackendThenGetUser() async {
    final getUserResult = await getCurrentUser();
    return getUserResult.fold(
      (failure) async {
        final message = failure.message.toLowerCase();
        final isNotFound = message.contains('not found') ||
            (message.contains('user') && message.contains('not found'));
        if (!isNotFound) return Left(failure);
        return await _signupOAuthUserThenGetUser();
      },
      (user) async => Right(user),
    );
  }

  Future<Result<User>> _signupOAuthUserThenGetUser() async {
    final token = await tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      return Left(
        ServerFailure(
          message: 'No access token after OAuth callback',
          code: 'OAUTH_TOKEN_MISSING',
        ),
      );
    }
    final supabaseDataSource = this.supabaseDataSource;
    final accessToken = supabaseDataSource.getCurrentAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return Left(
        ServerFailure(
          message: 'No Supabase session after OAuth callback',
          code: 'OAUTH_SESSION_MISSING',
        ),
      );
    }
    final userInfo = await _getOAuthUserInfo();
    if (userInfo == null) {
      return Left(
        ServerFailure(
          message: 'Missing email for OAuth user signup',
          code: 'OAUTH_EMAIL_MISSING',
        ),
      );
    }
    final signupResult = await signup(SignupRequest(
      email: userInfo.email,
      name: userInfo.name,
      phone: userInfo.phone,
      accessToken: accessToken,
    ));
    return signupResult.fold(
      (failure) => Left(failure),
      (_) async => getCurrentUser(),
    );
  }

  Future<({String email, String name, String? phone})?> _getOAuthUserInfo() async {
    // We need Supabase user metadata from the current session.
    // AuthSupabaseDataSource doesn't expose user metadata; we'd need to add a method
    // that returns email/name/phone from current Supabase user, or we pass it from
    // the callback. The OAuth callback page currently reads SupabaseConfig.client.auth.currentUser.
    // To keep Supabase only in data layer, add to AuthSupabaseDataSource:
    // Map<String, dynamic>? getCurrentUserMetadata() => email, full_name, phone
    // and implement it in AuthSupabaseDataSourceImpl using SupabaseConfig.client.auth.currentUser.
    // For now I'll add getCurrentUserMetadata() to the datasource.
    final metadata = await supabaseDataSource.getCurrentUserMetadata();
    if (metadata == null) return null;
    final email = metadata['email'] as String?;
    if (email == null || email.isEmpty) return null;
    final name = (metadata['full_name'] as String?) ??
        (metadata['name'] as String?) ??
        (metadata['display_name'] as String?) ??
        email.split('@').first;
    final phone = metadata['phone'] as String?;
    return (email: email, name: name, phone: phone);
  }
}
