import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:nashik/features/auth/domain/dtos/signup_request.dart';
import 'package:nashik/features/auth/domain/dtos/signup_response.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case that orchestrates the complete signup flow:
/// 1. Sign up with Supabase to get access token
/// 2. Call backend API with access token to store user in database
class SignupWithEmail
    implements UseCase<SignupResponse, SignupWithEmailParams> {
  final AuthRepository repository;
  final AuthSupabaseDataSource supabaseDataSource;

  SignupWithEmail({required this.repository, required this.supabaseDataSource});

  @override
  Future<Result<SignupResponse>> call(SignupWithEmailParams params) async {
    // Business logic validation
    if (params.email.isEmpty) {
      return Left(ValidationFailure.missingField('email'));
    }

    if (!params.email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }

    if (params.name.isEmpty) {
      return Left(ValidationFailure.missingField('name'));
    }

    if (params.password.isEmpty) {
      return Left(ValidationFailure.missingField('password'));
    }

    if (params.password.length < 6) {
      return Left(ValidationFailure.invalidInput('password'));
    }

    // Step 1: Sign up with Supabase to get access token
    // Include redirect URL for email verification deep linking
    final supabaseResult = await executeWithErrorHandling<String>(() async {
      return await supabaseDataSource.signUpWithEmail(
        email: params.email,
        password: params.password,
        redirectTo: 'com.caygnus.nashikdarshan://verify-email/',
      );
    });

    return await supabaseResult.fold((failure) async => Left(failure), (
      accessToken,
    ) async {
      // Step 2: Call backend API with access token
      final signupRequest = SignupRequest(
        email: params.email,
        phone: params.phone,
        name: params.name,
        accessToken: accessToken,
      );

      return await repository.signup(signupRequest);
    });
  }
}

/// Parameters for SignupWithEmail use case
class SignupWithEmailParams {
  final String email;
  final String password;
  final String name;
  final String? phone;

  SignupWithEmailParams({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });
}
