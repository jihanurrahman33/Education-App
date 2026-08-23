import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remoteDataSource;

  const CourseRepositoryImpl({required CourseRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<CourseEntity>> getCourses({
    String? category,
    String? searchQuery,
  }) async {
    try {
      final courses = await _remoteDataSource.getCourses(
        category: category,
        searchQuery: searchQuery,
      );
      return Right(courses);
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
  ResultFuture<CourseEntity> getCourseDetails(int courseId) async {
    try {
      final course = await _remoteDataSource.getCourseDetails(courseId);
      return Right(course);
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
  ResultFuture<List<ChapterEntity>> getCourseCurriculum(int courseId) async {
    try {
      final chapters = await _remoteDataSource.getCourseCurriculum(courseId);
      return Right(chapters);
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
  ResultVoid enrollInCourse(int courseId) async {
    try {
      await _remoteDataSource.enrollInCourse(courseId);
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

  @override
  ResultFuture<List<CourseEntity>> getMyEnrolledCourses() async {
    try {
      final courses = await _remoteDataSource.getMyEnrolledCourses();
      return Right(courses);
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
