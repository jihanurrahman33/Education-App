import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_repository.dart';

class UpdateUserParams extends Equatable {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final bool isActive;
  final bool isApprovedTeacher;

  const UpdateUserParams({
    required this.id,
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
        id,
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

class UpdateUserUseCase implements UseCase<AdminUserEntity, UpdateUserParams> {
  final AdminRepository repository;

  const UpdateUserUseCase(this.repository);

  @override
  ResultFuture<AdminUserEntity> call(UpdateUserParams params) {
    return repository.updateUser(
      id: params.id,
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
