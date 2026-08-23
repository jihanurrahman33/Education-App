import '../../../../core/utils/typedefs.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> login({
    required String usernameOrEmail,
    required String password,
  });

  ResultFuture<UserEntity> register({
    required String username,
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  });

  ResultFuture<UserEntity> getCurrentUser();

  ResultVoid logout();
}
