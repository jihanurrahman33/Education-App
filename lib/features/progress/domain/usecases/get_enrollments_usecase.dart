import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetEnrollmentsUseCase implements UseCase<List<CourseEnrollmentEntity>, int?> {
  final ProgressRepository repository;

  const GetEnrollmentsUseCase(this.repository);

  @override
  ResultFuture<List<CourseEnrollmentEntity>> call([int? page]) {
    return repository.getEnrollments(page: page);
  }
}
