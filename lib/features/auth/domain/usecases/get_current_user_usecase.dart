import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  @override
  ResultFuture<UserEntity> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
