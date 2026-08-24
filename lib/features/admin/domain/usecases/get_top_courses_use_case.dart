import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_top_course_entity.dart';
import '../repositories/admin_repository.dart';

class GetTopCoursesUseCase implements UseCase<List<AdminTopCourseEntity>, NoParams> {
  final AdminRepository repository;

  const GetTopCoursesUseCase(this.repository);

  @override
  ResultFuture<List<AdminTopCourseEntity>> call([NoParams params = const NoParams()]) {
    return repository.getTopCourses();
  }
}
