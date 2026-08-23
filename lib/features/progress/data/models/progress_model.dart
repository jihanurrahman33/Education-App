import '../../domain/entities/progress_entity.dart';

class ProgressSummaryModel extends ProgressSummaryEntity {
  const ProgressSummaryModel({
    required super.totalEnrolledCourses,
    required super.completedCourses,
    required super.totalLessonsCompleted,
    required super.overallCompletionPercentage,
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProgressSummaryModel(
      totalEnrolledCourses: json['total_enrolled_courses'] is int
          ? json['total_enrolled_courses'] as int
          : int.tryParse(json['total_enrolled_courses']?.toString() ?? '0') ?? 0,
      completedCourses: json['completed_courses'] is int
          ? json['completed_courses'] as int
          : int.tryParse(json['completed_courses']?.toString() ?? '0') ?? 0,
      totalLessonsCompleted: json['total_lessons_completed'] is int
          ? json['total_lessons_completed'] as int
          : int.tryParse(json['total_lessons_completed']?.toString() ?? '0') ?? 0,
      overallCompletionPercentage: json['overall_completion_percentage'] != null
          ? double.tryParse(json['overall_completion_percentage'].toString()) ?? 0.0
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_enrolled_courses': totalEnrolledCourses,
      'completed_courses': completedCourses,
      'total_lessons_completed': totalLessonsCompleted,
      'overall_completion_percentage': overallCompletionPercentage,
    };
  }
}

class CourseProgressModel extends CourseProgressEntity {
  const CourseProgressModel({
    required super.courseId,
    required super.courseTitle,
    required super.totalLessons,
    required super.completedLessons,
    required super.percentage,
    required super.isEligibleForCertificate,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      courseId: json['course_id'] is int
          ? json['course_id'] as int
          : int.tryParse(json['course']?.toString() ?? '0') ?? 0,
      courseTitle: json['course_title'] as String? ?? json['title'] as String? ?? '',
      totalLessons: json['total_lessons'] is int
          ? json['total_lessons'] as int
          : int.tryParse(json['total_lessons']?.toString() ?? '0') ?? 0,
      completedLessons: json['completed_lessons'] is int
          ? json['completed_lessons'] as int
          : int.tryParse(json['completed_lessons']?.toString() ?? '0') ?? 0,
      percentage: json['percentage'] != null
          ? double.tryParse(json['percentage'].toString()) ?? 0.0
          : 0.0,
      isEligibleForCertificate: json['is_eligible_for_certificate'] as bool? ??
          json['eligible_for_certificate'] as bool? ??
          false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_title': courseTitle,
      'total_lessons': totalLessons,
      'completed_lessons': completedLessons,
      'percentage': percentage,
      'is_eligible_for_certificate': isEligibleForCertificate,
    };
  }
}
