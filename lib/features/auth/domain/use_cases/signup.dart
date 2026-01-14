import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/dtos/signup_request.dart';
import 'package:nashik/features/auth/domain/dtos/signup_response.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

class Signup implements UseCase<SignupResponse, SignupRequest> {
  final AuthRepository repository;

  Signup(this.repository);

  @override
  Future<Result<SignupResponse>> call(SignupRequest request) async {
    // Business logic validation
    if (request.email.isEmpty) {
      return Left(ValidationFailure.missingField('email'));
    }

    if (!request.email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }

    if (request.name.isEmpty) {
      return Left(ValidationFailure.missingField('name'));
    }

    if (request.accessToken.isEmpty) {
      return Left(ValidationFailure.missingField('accessToken'));
    }

    return await repository.signup(request);
  }
}
