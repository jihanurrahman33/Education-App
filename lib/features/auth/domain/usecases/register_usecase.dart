import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final UserRole role;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
  });

  @override
  List<Object?> get props => [username, email, password, role, firstName, lastName, phone];
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  @override
  ResultFuture<UserEntity> call(RegisterParams params) {
    return _repository.register(
      username: params.username,
      email: params.email,
      password: params.password,
      role: params.role,
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
    );
  }
}
