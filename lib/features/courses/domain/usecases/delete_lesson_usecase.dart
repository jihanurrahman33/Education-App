import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/course_repository.dart';

class DeleteLessonUseCase implements UseCase<void, int> {
  final CourseRepository repository;

  const DeleteLessonUseCase(this.repository);

  @override
  ResultVoid call(int lessonId) {
    return repository.deleteLesson(lessonId);
  }
}
