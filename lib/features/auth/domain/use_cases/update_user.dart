import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/dtos/update_user_request.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

class UpdateUser implements UseCase<User, UpdateUserRequest> {
  final AuthRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Result<User>> call(UpdateUserRequest request) async {
    // Business logic validation
    if (request.name != null && request.name!.isEmpty) {
      return Left(ValidationFailure.invalidInput('name'));
    }

    if (request.phone != null && request.phone!.isEmpty) {
      return Left(ValidationFailure.invalidInput('phone'));
    }

    return await repository.updateUser(request);
  }
}
