import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/teacher_dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTeacherDashboardUseCase implements UseCase<TeacherDashboardEntity, NoParams> {
  final DashboardRepository repository;

  const GetTeacherDashboardUseCase(this.repository);

  @override
  ResultFuture<TeacherDashboardEntity> call([NoParams params = const NoParams()]) {
    return repository.getTeacherDashboard();
  }
}
