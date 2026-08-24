import 'package:equatable/equatable.dart';

class StudentDashboardEntity extends Equatable {
  final int enrolledCoursesCount;
  final int completedLessonsCount;
  final int certificatesEarnedCount;
  final int completedCoursesCount;
  final String lastCourseTitle;
  final String lastLessonSubtitle;
  final double progressRatio;
  final int? lastCourseId;

  const StudentDashboardEntity({
    this.enrolledCoursesCount = 0,
    this.completedLessonsCount = 0,
    this.certificatesEarnedCount = 0,
    this.completedCoursesCount = 0,
    this.lastCourseTitle = 'Explore New Courses',
    this.lastLessonSubtitle = 'Start your learning journey today',
    this.progressRatio = 0.0,
    this.lastCourseId,
  });

  @override
  List<Object?> get props => [
        enrolledCoursesCount,
        completedLessonsCount,
        certificatesEarnedCount,
        completedCoursesCount,
        lastCourseTitle,
        lastLessonSubtitle,
        progressRatio,
        lastCourseId,
      ];
}
