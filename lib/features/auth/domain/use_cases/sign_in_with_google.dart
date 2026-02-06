import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case: initiate Google sign-in via OAuth. Returns true if flow started.
class SignInWithGoogle implements UseCaseNoParams<bool> {
  SignInWithGoogle({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<bool>> call() async {
    return repository.signInWithGoogle();
  }
}
