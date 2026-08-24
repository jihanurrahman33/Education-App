import '../../../../core/utils/typedefs.dart';
import '../entities/admin_stats_entity.dart';
import '../repositories/admin_repository.dart';

class GetAdminStatsUseCase {
  final AdminRepository repository;

  const GetAdminStatsUseCase(this.repository);

  ResultFuture<AdminStatsEntity> call() {
    return repository.getAdminStats();
  }
}
