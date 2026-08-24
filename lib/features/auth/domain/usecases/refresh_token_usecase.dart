import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/token_refresh_entity.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase implements UseCase<TokenRefreshEntity, NoParams> {
  final AuthRepository _repository;

  const RefreshTokenUseCase(this._repository);

  @override
  ResultFuture<TokenRefreshEntity> call(NoParams params) {
    return _repository.refreshToken();
  }
}
