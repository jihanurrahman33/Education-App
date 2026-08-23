import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource _remoteDataSource;

  const ProgressRepositoryImpl({required ProgressRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<ProgressSummaryEntity> getProgressSummary() async {
    try {
      final summary = await _remoteDataSource.getProgressSummary();
      return Right(summary);
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
  ResultFuture<CourseProgressEntity> getCourseProgress(int courseId) async {
    try {
      final progress = await _remoteDataSource.getCourseProgress(courseId);
      return Right(progress);
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
  ResultVoid markLessonCompleted(int lessonId) async {
    try {
      await _remoteDataSource.markLessonCompleted(lessonId);
      return const Right(null);
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
}
