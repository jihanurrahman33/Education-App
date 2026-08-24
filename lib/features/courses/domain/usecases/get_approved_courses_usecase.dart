import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetApprovedCoursesUseCase implements UseCase<List<CourseEntity>, int?> {
  final CourseRepository repository;

  const GetApprovedCoursesUseCase(this.repository);

  @override
  ResultFuture<List<CourseEntity>> call([int? page]) {
    return repository.getApprovedCourses(page: page);
  }
}
