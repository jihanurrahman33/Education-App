import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  @override
  ResultVoid call(NoParams params) {
    return _repository.logout();
  }
}
