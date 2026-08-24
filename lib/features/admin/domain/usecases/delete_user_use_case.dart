import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/admin_repository.dart';

class DeleteUserUseCase implements UseCase<void, int> {
  final AdminRepository repository;

  const DeleteUserUseCase(this.repository);

  @override
  ResultVoid call(int userId) {
    return repository.deleteUser(userId);
  }
}
