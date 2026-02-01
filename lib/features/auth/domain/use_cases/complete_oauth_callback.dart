import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

/// Use case: complete OAuth callback from deep link. Creates session, ensures user in backend, returns user.
class CompleteOAuthCallback implements UseCase<User, Uri> {
  CompleteOAuthCallback({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<User>> call(Uri deepLinkUri) async {
    return repository.completeOAuthCallback(deepLinkUri);
  }
}
