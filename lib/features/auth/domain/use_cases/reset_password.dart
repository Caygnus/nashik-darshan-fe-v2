import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case: send password reset email to [email].
class ResetPassword implements UseCase<Unit, String> {
  ResetPassword({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<Unit>> call(String email) async {
    if (email.isEmpty) {
      return Left(ValidationFailure.missingField('email'));
    }
    if (!email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }
    return repository.resetPassword(email);
  }
}
