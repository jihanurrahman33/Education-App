import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class TogglePublishCourseUseCase implements UseCase<CourseEntity, int> {
  final CourseRepository repository;

  const TogglePublishCourseUseCase(this.repository);

  @override
  ResultFuture<CourseEntity> call(int courseId) {
    return repository.togglePublish(courseId);
  }
}
