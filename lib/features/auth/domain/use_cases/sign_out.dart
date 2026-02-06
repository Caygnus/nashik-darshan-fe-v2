import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case: sign out (clear token and Supabase session).
class SignOut implements UseCaseNoParams<Unit> {
  SignOut({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<Unit>> call() async {
    return repository.signOut();
  }
}
