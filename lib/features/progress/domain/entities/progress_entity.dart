import 'package:equatable/equatable.dart';

class ProgressSummaryEntity extends Equatable {
  final int totalEnrolledCourses;
  final int completedCourses;
  final int totalLessonsCompleted;
  final double overallCompletionPercentage;

  const ProgressSummaryEntity({
    required this.totalEnrolledCourses,
    required this.completedCourses,
    required this.totalLessonsCompleted,
    required this.overallCompletionPercentage,
  });

  @override
  List<Object?> get props => [
        totalEnrolledCourses,
        completedCourses,
        totalLessonsCompleted,
        overallCompletionPercentage,
      ];
}

class CourseProgressEntity extends Equatable {
  final int courseId;
  final String courseTitle;
  final int totalLessons;
  final int completedLessons;
  final double percentage;
  final bool isEligibleForCertificate;

  const CourseProgressEntity({
    required this.courseId,
    required this.courseTitle,
    required this.totalLessons,
    required this.completedLessons,
    required this.percentage,
    required this.isEligibleForCertificate,
  });

  @override
  List<Object?> get props => [
        courseId,
        courseTitle,
        totalLessons,
        completedLessons,
        percentage,
        isEligibleForCertificate,
      ];
}
