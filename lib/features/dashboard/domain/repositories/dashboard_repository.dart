import '../../../../core/utils/typedefs.dart';
import '../entities/student_dashboard_entity.dart';
import '../entities/teacher_dashboard_entity.dart';

abstract class DashboardRepository {
  ResultFuture<StudentDashboardEntity> getStudentDashboard();
  ResultFuture<TeacherDashboardEntity> getTeacherDashboard();
}
