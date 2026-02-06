import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/health/data/datasources/health_remote_datasource.dart';
import 'package:nashik/features/health/domain/repositories/health_repository.dart';

class HealthRepositoryImpl extends BaseRepository implements HealthRepository {
  HealthRepositoryImpl({required HealthRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final HealthRemoteDataSource _remote;

  @override
  Future<Result<HealthResult>> check() async {
    return executeWithErrorHandling<HealthResult>(() async {
      final raw = await _remote.check();
      final isOk = raw.statusCode == 200;
      return HealthResult(raw.body, isOk);
    });
  }
}
