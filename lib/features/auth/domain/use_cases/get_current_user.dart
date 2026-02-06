import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UseCaseNoParams<User> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Result<User>> call() async {
    return await repository.getCurrentUser();
  }
}
