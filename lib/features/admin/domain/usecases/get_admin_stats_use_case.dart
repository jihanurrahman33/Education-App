import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_stats_entity.dart';
import '../repositories/admin_repository.dart';

class GetAdminStatsUseCase implements UseCase<AdminStatsEntity, NoParams> {
  final AdminRepository repository;

  const GetAdminStatsUseCase(this.repository);

  @override
  ResultFuture<AdminStatsEntity> call([NoParams params = const NoParams()]) {
    return repository.getAdminStats();
  }
}
