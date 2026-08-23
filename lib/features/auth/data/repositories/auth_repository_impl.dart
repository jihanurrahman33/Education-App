import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  ResultFuture<UserEntity> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      if (userModel.token != null) {
        await _localDataSource.cacheAuthToken(userModel.token!);
      }
      if (userModel.refreshToken != null) {
        await _localDataSource.cacheRefreshToken(userModel.refreshToken!);
      }
      await _localDataSource.cacheUser(userModel);

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
      final userModel = await _remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
      );

      return Right(userModel);
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
      final cachedUser = await _localDataSource.getCachedUser();
      final token = await _localDataSource.getAuthToken();

      if (token == null || token.isEmpty) {
        return const Left(AuthenticationFailure(message: 'No active session found'));
      }

      try {
        final remoteUser = await _remoteDataSource.getCurrentUser();
        await _localDataSource.cacheUser(remoteUser);
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
      await _localDataSource.clearSession();
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid logout() async {
    try {
      await _localDataSource.clearSession();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
