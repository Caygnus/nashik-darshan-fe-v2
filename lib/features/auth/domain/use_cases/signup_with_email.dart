import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/dtos/signup_response.dart';
import 'package:nashik/features/auth/domain/params/signup_with_email_params.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case: sign up with email. Delegates to [AuthRepository] (Supabase + backend orchestration in data layer).
class SignupWithEmail
    implements UseCase<SignupResponse, SignupWithEmailParams> {
  SignupWithEmail({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<SignupResponse>> call(SignupWithEmailParams params) async {
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
    return repository.signUpWithEmail(params);
  }
}
