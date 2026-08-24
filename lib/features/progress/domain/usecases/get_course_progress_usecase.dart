import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetCourseProgressUseCase implements UseCase<CourseProgressEntity, int> {
  final ProgressRepository repository;

  const GetCourseProgressUseCase(this.repository);

  @override
  ResultFuture<CourseProgressEntity> call(int courseId) {
    return repository.getCourseProgress(courseId);
  }
}
