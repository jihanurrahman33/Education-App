import '../../../../core/utils/typedefs.dart';
import '../entities/admin_stats_entity.dart';

abstract class AdminRepository {
  ResultFuture<AdminStatsEntity> getAdminStats();
  ResultVoid approveTeacher(int teacherId);
  ResultVoid approveCourse(int courseId);
  ResultVoid rejectCourse(int courseId);
}
