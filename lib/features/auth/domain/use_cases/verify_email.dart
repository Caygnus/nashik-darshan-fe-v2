import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/params/verify_email_params.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case: verify email OTP. Returns the authenticated user.
class VerifyEmail implements UseCase<User, VerifyEmailParams> {
  VerifyEmail({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<User>> call(VerifyEmailParams params) async {
    if (params.token.isEmpty) {
      return Left(ValidationFailure.missingField('token'));
    }
    if (params.email.isEmpty) {
      return Left(ValidationFailure.missingField('email'));
    }
    if (!params.email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }
    return repository.verifyEmail(params.token, params.email);
  }
}
