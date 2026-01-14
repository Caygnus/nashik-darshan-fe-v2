import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case that orchestrates the complete signin flow:
/// 1. Sign in with Supabase to get access token
/// 2. Get current user from backend API
class SigninWithEmail implements UseCase<User, SigninWithEmailParams> {
  final AuthRepository repository;
  final AuthSupabaseDataSource supabaseDataSource;

  SigninWithEmail({required this.repository, required this.supabaseDataSource});

  @override
  Future<Result<User>> call(SigninWithEmailParams params) async {
    // Business logic validation
    if (params.email.isEmpty) {
      return Left(ValidationFailure.missingField('email'));
    }

    if (!params.email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }

    if (params.password.isEmpty) {
      return Left(ValidationFailure.missingField('password'));
    }

    // Step 1: Sign in with Supabase to get access token
    final supabaseResult = await executeWithErrorHandling<String>(() async {
      return await supabaseDataSource.signInWithEmail(
        email: params.email,
        password: params.password,
      );
    });

    return supabaseResult.fold((failure) => Left(failure), (_) async {
      // Step 2: Get current user from backend
      return await repository.getCurrentUser();
    });
  }
}

/// Parameters for SigninWithEmail use case
class SigninWithEmailParams {
  final String email;
  final String password;

  SigninWithEmailParams({required this.email, required this.password});
}
