import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/admin_repository.dart';

class RejectCourseUseCase implements UseCase<void, int> {
  final AdminRepository _repository;

  const RejectCourseUseCase(this._repository);

  @override
  ResultVoid call(int courseId) {
    return _repository.rejectCourse(courseId);
  }
}
