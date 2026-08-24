import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/course_repository.dart';

class DeleteCourseUseCase implements UseCase<void, int> {
  final CourseRepository repository;

  const DeleteCourseUseCase(this.repository);

  @override
  ResultVoid call(int courseId) {
    return repository.deleteCourse(courseId);
  }
}
