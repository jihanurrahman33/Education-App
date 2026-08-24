import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/admin_repository.dart';

class ApproveTeacherUseCase implements UseCase<void, int> {
  final AdminRepository _repository;

  const ApproveTeacherUseCase(this._repository);

  @override
  ResultVoid call(int teacherId) {
    return _repository.approveTeacher(teacherId);
  }
}
