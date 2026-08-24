import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../certificates/domain/entities/certificate_entity.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  const ProgressRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<ProgressSummaryEntity> getProgressSummary() async {
    try {
      final summary = await remoteDataSource.getProgressSummary();
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CourseProgressEntity>> getMyProgress() async {
    try {
      final progressList = await remoteDataSource.getMyProgress();
      return Right(progressList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<CourseProgressEntity> getCourseProgress(int courseId) async {
    try {
      final progress = await remoteDataSource.getCourseProgress(courseId);
      return Right(progress);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid enrollInCourse(int courseId) async {
    try {
      await remoteDataSource.enrollInCourse(courseId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CourseEnrollmentEntity>> getEnrollments({int? page}) async {
    try {
      final enrollments = await remoteDataSource.getEnrollments(page: page);
      return Right(enrollments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<CompletedLessonEntity> markLessonCompleted(int lessonId) async {
    try {
      final completed = await remoteDataSource.markLessonCompleted(lessonId);
      return Right(completed);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CompletedLessonEntity>> getCompletedLessons({int? page}) async {
    try {
      final lessons = await remoteDataSource.getCompletedLessons(page: page);
      return Right(lessons);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<CertificateEntity> generateCertificate(int courseId) async {
    try {
      final cert = await remoteDataSource.generateCertificate(courseId);
      return Right(cert);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CertificateEntity>> getCertificates({int? page}) async {
    try {
      final certs = await remoteDataSource.getCertificates(page: page);
      return Right(certs);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<TeacherCourseProgressEntity> getTeacherCourseStudentsProgress(int courseId) async {
    try {
      final progress = await remoteDataSource.getTeacherCourseStudentsProgress(courseId);
      return Right(progress);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
