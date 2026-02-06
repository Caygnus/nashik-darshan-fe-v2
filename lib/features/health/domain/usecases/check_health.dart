import 'package:nashik/core/domain/use_cases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/health/domain/repositories/health_repository.dart';

class CheckHealth implements UseCaseNoParams<HealthResult> {
  CheckHealth(this._repository);
  final HealthRepository _repository;

  @override
  Future<Result<HealthResult>> call() => _repository.check();
}
