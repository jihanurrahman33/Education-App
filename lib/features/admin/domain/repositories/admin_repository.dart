import '../../../../core/utils/typedefs.dart';
import '../entities/admin_course_entity.dart';
import '../entities/admin_stats_entity.dart';
import '../entities/admin_top_course_entity.dart';
import '../entities/admin_user_entity.dart';

abstract class AdminRepository {
  ResultFuture<AdminStatsEntity> getAdminStats();
  ResultFuture<List<AdminTopCourseEntity>> getTopCourses();
  ResultFuture<List<AdminCourseEntity>> getPendingCourses({int? page});
  ResultFuture<List<AdminUserEntity>> getPendingTeachers({int? page});
  ResultFuture<List<AdminUserEntity>> getUsers({int? page, String? search});
  ResultFuture<AdminUserEntity> createUser({
    required String username,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
    bool isActive = true,
    bool isApprovedTeacher = false,
  });
  ResultVoid approveTeacher(int teacherId);
  ResultVoid approveCourse(int courseId);
  ResultVoid rejectCourse(int courseId);
}
