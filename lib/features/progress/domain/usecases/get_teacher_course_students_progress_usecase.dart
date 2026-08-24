import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetTeacherCourseStudentsProgressUseCase
    implements UseCase<TeacherCourseProgressEntity, int> {
  final ProgressRepository repository;

  const GetTeacherCourseStudentsProgressUseCase(this.repository);

  @override
  ResultFuture<TeacherCourseProgressEntity> call(int courseId) {
    return repository.getTeacherCourseStudentsProgress(courseId);
  }
}
