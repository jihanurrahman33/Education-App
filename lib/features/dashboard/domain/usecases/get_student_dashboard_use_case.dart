import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/student_dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetStudentDashboardUseCase implements UseCase<StudentDashboardEntity, NoParams> {
  final DashboardRepository repository;

  const GetStudentDashboardUseCase(this.repository);

  @override
  ResultFuture<StudentDashboardEntity> call([NoParams params = const NoParams()]) {
    return repository.getStudentDashboard();
  }
}
