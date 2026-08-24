import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/admin_course_entity.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/admin_top_course_entity.dart';
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
  ResultFuture<List<AdminTopCourseEntity>> getTopCourses() async {
    try {
      final courses = await remoteDataSource.getTopCourses();
      return Right(courses);
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
  ResultFuture<List<AdminUserEntity>> getUsers({int? page, String? search}) async {
    try {
      final users = await remoteDataSource.getUsers(page: page, search: search);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<AdminUserEntity> getUserById(int userId) async {
    try {
      final user = await remoteDataSource.getUserById(userId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<AdminUserEntity> createUser({
    required String username,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
    bool isActive = true,
    bool isApprovedTeacher = false,
  }) async {
    try {
      final createdUser = await remoteDataSource.createUser(
        username: username,
        email: email,
        role: role,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        isActive: isActive,
        isApprovedTeacher: isApprovedTeacher,
      );
      return Right(createdUser);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<AdminUserEntity> updateUser({
    required int id,
    required String username,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
    bool isActive = true,
    bool isApprovedTeacher = false,
  }) async {
    try {
      final updatedUser = await remoteDataSource.updateUser(
        id: id,
        username: username,
        email: email,
        role: role,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        isActive: isActive,
        isApprovedTeacher: isApprovedTeacher,
      );
      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<AdminUserEntity> patchUser({
    required int id,
    String? username,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? phone,
    bool? isActive,
    bool? isApprovedTeacher,
  }) async {
    try {
      final patchedUser = await remoteDataSource.patchUser(
        id: id,
        username: username,
        email: email,
        role: role,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        isActive: isActive,
        isApprovedTeacher: isApprovedTeacher,
      );
      return Right(patchedUser);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteUser(int userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
      return const Right(null);
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
