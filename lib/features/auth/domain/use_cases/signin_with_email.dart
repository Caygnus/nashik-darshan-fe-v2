import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/params/signin_with_email_params.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case: sign in with email. Delegates to [AuthRepository] (Supabase + backend orchestration in data layer).
class SigninWithEmail implements UseCase<User, SigninWithEmailParams> {
  SigninWithEmail({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<User>> call(SigninWithEmailParams params) async {
    final email = params.email.trim();
    final password = params.password.trim();
    if (email.isEmpty) {
      return Left(ValidationFailure.missingField('email'));
    }
    if (!email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }
    if (password.isEmpty) {
      return Left(ValidationFailure.missingField('password'));
    }
    return repository.signInWithEmail(
      SigninWithEmailParams(email: email, password: password),
    );
  }
}
