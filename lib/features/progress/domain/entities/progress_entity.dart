import 'package:equatable/equatable.dart';

class CourseProgressEntity extends Equatable {
  final int courseId;
  final String courseTitle;
  final int totalLessons;
  final int completedLessons;
  final double percentage;
  final bool isEnrolled;

  const CourseProgressEntity({
    required this.courseId,
    required this.courseTitle,
    required this.totalLessons,
    required this.completedLessons,
    required this.percentage,
    this.isEnrolled = true,
  });

  bool get isEligibleForCertificate =>
      percentage >= 100.0 || (completedLessons >= totalLessons && totalLessons > 0);

  @override
  List<Object?> get props => [
        courseId,
        courseTitle,
        totalLessons,
        completedLessons,
        percentage,
        isEnrolled,
      ];
}

class ProgressSummaryEntity extends Equatable {
  final int totalEnrolledCourses;
  final int completedCourses;
  final int totalLessonsCompleted;
  final double overallCompletionPercentage;
  final List<CourseProgressEntity> courses;

  const ProgressSummaryEntity({
    required this.totalEnrolledCourses,
    required this.completedCourses,
    required this.totalLessonsCompleted,
    required this.overallCompletionPercentage,
    this.courses = const [],
  });

  @override
  List<Object?> get props => [
        totalEnrolledCourses,
        completedCourses,
        totalLessonsCompleted,
        overallCompletionPercentage,
        courses,
      ];
}

class CompletedLessonEntity extends Equatable {
  final int id;
  final int student;
  final int lesson;
  final String lessonTitle;
  final int courseId;
  final String courseTitle;
  final String completedAt;

  const CompletedLessonEntity({
    required this.id,
    required this.student,
    required this.lesson,
    required this.lessonTitle,
    required this.courseId,
    required this.courseTitle,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        student,
        lesson,
        lessonTitle,
        courseId,
        courseTitle,
        completedAt,
      ];
}

class CourseEnrollmentEntity extends Equatable {
  final int id;
  final int student;
  final int course;
  final String courseTitle;
  final String enrolledAt;

  const CourseEnrollmentEntity({
    required this.id,
    required this.student,
    required this.course,
    required this.courseTitle,
    required this.enrolledAt,
  });

  @override
  List<Object?> get props => [id, student, course, courseTitle, enrolledAt];
}

class StudentCourseProgressEntity extends Equatable {
  final int studentId;
  final String studentName;
  final String enrolledAt;
  final int completedLessons;
  final int totalLessons;
  final double progressPercent;

  const StudentCourseProgressEntity({
    required this.studentId,
    required this.studentName,
    required this.enrolledAt,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercent,
  });

  @override
  List<Object?> get props => [
        studentId,
        studentName,
        enrolledAt,
        completedLessons,
        totalLessons,
        progressPercent,
      ];
}

class TeacherCourseProgressEntity extends Equatable {
  final int courseId;
  final String courseTitle;
  final int totalLessons;
  final List<StudentCourseProgressEntity> students;

  const TeacherCourseProgressEntity({
    required this.courseId,
    required this.courseTitle,
    required this.totalLessons,
    required this.students,
  });

  @override
  List<Object?> get props => [courseId, courseTitle, totalLessons, students];
}
