import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_repository.dart';

class GetUserByIdUseCase implements UseCase<AdminUserEntity, int> {
  final AdminRepository repository;

  const GetUserByIdUseCase(this.repository);

  @override
  ResultFuture<AdminUserEntity> call(int userId) {
    return repository.getUserById(userId);
  }
}
