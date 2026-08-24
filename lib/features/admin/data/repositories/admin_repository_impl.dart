import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/admin_course_entity.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  const AdminRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<AdminStatsEntity> getAdminStats() async {
    try {
      final stats = await remoteDataSource.getAdminStats();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<AdminCourseEntity>> getPendingCourses({int? page}) async {
    try {
      final courses = await remoteDataSource.getPendingCourses(page: page);
      return Right(courses);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<AdminUserEntity>> getPendingTeachers({int? page}) async {
    try {
      final teachers = await remoteDataSource.getPendingTeachers(page: page);
      return Right(teachers);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid approveTeacher(int teacherId) async {
    try {
      await remoteDataSource.approveTeacher(teacherId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid approveCourse(int courseId) async {
    try {
      await remoteDataSource.approveCourse(courseId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid rejectCourse(int courseId) async {
    try {
      await remoteDataSource.rejectCourse(courseId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
