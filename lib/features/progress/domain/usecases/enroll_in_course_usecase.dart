import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/progress_repository.dart';

class EnrollInCourseUseCase implements UseCase<void, int> {
  final ProgressRepository repository;

  const EnrollInCourseUseCase(this.repository);

  @override
  ResultVoid call(int courseId) {
    return repository.enrollInCourse(courseId);
  }
}
