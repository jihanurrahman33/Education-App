import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_repository.dart';

class CreateUserParams extends Equatable {
  final String username;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final bool isActive;
  final bool isApprovedTeacher;

  const CreateUserParams({
    required this.username,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.isActive = true,
    this.isApprovedTeacher = false,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        role,
        firstName,
        lastName,
        phone,
        isActive,
        isApprovedTeacher,
      ];
}

class CreateUserUseCase implements UseCase<AdminUserEntity, CreateUserParams> {
  final AdminRepository repository;

  const CreateUserUseCase(this.repository);

  @override
  ResultFuture<AdminUserEntity> call(CreateUserParams params) {
    return repository.createUser(
      username: params.username,
      email: params.email,
      role: params.role,
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
      isActive: params.isActive,
      isApprovedTeacher: params.isApprovedTeacher,
    );
  }
}
