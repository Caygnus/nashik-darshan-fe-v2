import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';

/// Result of health check: body + whether auth was valid (200 = valid).
class HealthResult {
  const HealthResult(this.body, this.isOk);
  final Map<String, dynamic> body;
  final bool isOk;
}

abstract class HealthRepository extends BaseRepository {
  Future<Result<HealthResult>> check();
}
