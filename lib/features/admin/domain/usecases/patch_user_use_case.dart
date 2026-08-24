import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_repository.dart';

class PatchUserParams extends Equatable {
  final int id;
  final String? username;
  final String? email;
  final String? role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final bool? isActive;
  final bool? isApprovedTeacher;

  const PatchUserParams({
    required this.id,
    this.username,
    this.email,
    this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.isActive,
    this.isApprovedTeacher,
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

class PatchUserUseCase implements UseCase<AdminUserEntity, PatchUserParams> {
  final AdminRepository repository;

  const PatchUserUseCase(this.repository);

  @override
  ResultFuture<AdminUserEntity> call(PatchUserParams params) {
    return repository.patchUser(
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
