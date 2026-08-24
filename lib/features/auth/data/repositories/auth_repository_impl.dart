import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  ResultFuture<UserEntity> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      if (userModel.token != null) {
        await localDataSource.cacheAuthToken(userModel.token!);
      }
      if (userModel.refreshToken != null) {
        await localDataSource.cacheRefreshToken(userModel.refreshToken!);
      }
      await localDataSource.cacheUser(userModel);

      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> register({
    required String username,
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final registeredUser = await remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
      );

      // Automatically login right after registration to acquire JWT tokens
      try {
        final loggedInUser = await remoteDataSource.login(
          usernameOrEmail: username,
          password: password,
        );

        if (loggedInUser.token != null) {
          await localDataSource.cacheAuthToken(loggedInUser.token!);
        }
        if (loggedInUser.refreshToken != null) {
          await localDataSource.cacheRefreshToken(loggedInUser.refreshToken!);
        }
        await localDataSource.cacheUser(loggedInUser);

        return Right(loggedInUser);
      } catch (_) {
        // If auto-login fails (e.g., teacher pending admin approval)
        return Right(registeredUser);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      final token = await localDataSource.getAuthToken();

      if (token == null || token.isEmpty) {
        return const Left(AuthenticationFailure(message: 'No active session found'));
      }

      try {
        final remoteUser = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } catch (_) {
        if (cachedUser != null) {
          return Right(cachedUser);
        }
        rethrow;
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      await localDataSource.clearSession();
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid logout() async {
    try {
      await localDataSource.clearSession();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
