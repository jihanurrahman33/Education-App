import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams extends Equatable {
  final String usernameOrEmail;
  final String password;

  const LoginParams({
    required this.usernameOrEmail,
    required this.password,
  });

  @override
  List<Object?> get props => [usernameOrEmail, password];
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  ResultFuture<UserEntity> call(LoginParams params) {
    return _repository.login(
      usernameOrEmail: params.usernameOrEmail,
      password: params.password,
    );
  }
}
