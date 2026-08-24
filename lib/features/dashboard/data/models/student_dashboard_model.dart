import '../../domain/entities/student_dashboard_entity.dart';

class StudentDashboardModel extends StudentDashboardEntity {
  const StudentDashboardModel({
    super.enrolledCoursesCount = 0,
    super.completedLessonsCount = 0,
    super.certificatesEarnedCount = 0,
    super.completedCoursesCount = 0,
    super.lastCourseTitle = 'Explore New Courses',
    super.lastLessonSubtitle = 'Start your learning journey today',
    super.progressRatio = 0.0,
    super.lastCourseId,
  });

  factory StudentDashboardModel.fromJson(Map<String, dynamic> json) {
    return StudentDashboardModel(
      enrolledCoursesCount: json['enrolled_courses_count'] as int? ??
          json['enrolledCoursesCount'] as int? ??
          0,
      completedLessonsCount: json['completed_lessons_count'] as int? ??
          json['completedLessonsCount'] as int? ??
          0,
      certificatesEarnedCount: json['certificates_earned_count'] as int? ??
          json['certificatesEarnedCount'] as int? ??
          0,
      completedCoursesCount: json['completed_courses_count'] as int? ??
          json['completedCoursesCount'] as int? ??
          0,
      lastCourseTitle: json['last_course_title'] as String? ??
          json['lastCourseTitle'] as String? ??
          'Explore New Courses',
      lastLessonSubtitle: json['last_lesson_subtitle'] as String? ??
          json['lastLessonSubtitle'] as String? ??
          'Start your learning journey today',
      progressRatio: (json['progress_ratio'] as num?)?.toDouble() ??
          (json['progressRatio'] as num?)?.toDouble() ??
          0.0,
      lastCourseId: json['last_course_id'] as int? ??
          json['lastCourseId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrolled_courses_count': enrolledCoursesCount,
      'completed_lessons_count': completedLessonsCount,
      'certificates_earned_count': certificatesEarnedCount,
      'completed_courses_count': completedCoursesCount,
      'last_course_title': lastCourseTitle,
      'last_lesson_subtitle': lastLessonSubtitle,
      'progress_ratio': progressRatio,
      'last_course_id': lastCourseId,
    };
  }
}
