import '../../domain/entities/teacher_dashboard_entity.dart';

class TeacherDashboardModel extends TeacherDashboardEntity {
  const TeacherDashboardModel({
    super.authoredCoursesCount = 0,
    super.totalStudentsEnrolled = 0,
    super.activeQuizzesCount = 0,
  });

  factory TeacherDashboardModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardModel(
      authoredCoursesCount: json['authored_courses_count'] as int? ?? json['authoredCoursesCount'] as int? ?? 0,
      totalStudentsEnrolled: json['total_students_enrolled'] as int? ?? json['totalStudentsEnrolled'] as int? ?? 0,
      activeQuizzesCount: json['active_quizzes_count'] as int? ?? json['activeQuizzesCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authored_courses_count': authoredCoursesCount,
      'total_students_enrolled': totalStudentsEnrolled,
      'active_quizzes_count': activeQuizzesCount,
    };
  }
}
