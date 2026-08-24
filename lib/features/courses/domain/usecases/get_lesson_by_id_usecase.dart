import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetLessonByIdUseCase implements UseCase<LessonEntity, int> {
  final CourseRepository repository;

  const GetLessonByIdUseCase(this.repository);

  @override
  ResultFuture<LessonEntity> call(int lessonId) {
    return repository.getLessonById(lessonId);
  }
}
