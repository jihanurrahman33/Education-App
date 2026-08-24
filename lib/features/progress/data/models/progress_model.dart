import '../../domain/entities/progress_entity.dart';

class CourseProgressModel extends CourseProgressEntity {
  const CourseProgressModel({
    required super.courseId,
    required super.courseTitle,
    required super.totalLessons,
    required super.completedLessons,
    required super.percentage,
    super.isEnrolled = true,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    final rawPercent = json['progress_percent'] ?? json['percentage'] ?? 0.0;
    final percent = double.tryParse(rawPercent.toString()) ?? 0.0;

    return CourseProgressModel(
      courseId: json['course_id'] is int
          ? json['course_id'] as int
          : int.tryParse(json['course']?.toString() ?? json['id']?.toString() ?? '0') ?? 0,
      courseTitle: (json['course_title'] ?? json['title'] ?? '') as String,
      totalLessons: json['total_lessons'] is int
          ? json['total_lessons'] as int
          : int.tryParse(json['total_lessons']?.toString() ?? '0') ?? 0,
      completedLessons: json['completed_lessons'] is int
          ? json['completed_lessons'] as int
          : int.tryParse(json['completed_lessons']?.toString() ?? '0') ?? 0,
      percentage: percent,
      isEnrolled: json['is_enrolled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_title': courseTitle,
      'total_lessons': totalLessons,
      'completed_lessons': completedLessons,
      'progress_percent': percentage,
      'is_enrolled': isEnrolled,
    };
  }
}

class ProgressSummaryModel extends ProgressSummaryEntity {
  const ProgressSummaryModel({
    required super.totalEnrolledCourses,
    required super.completedCourses,
    required super.totalLessonsCompleted,
    required super.overallCompletionPercentage,
    super.courses = const [],
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    final coursesList = <CourseProgressEntity>[];
    if (json['courses'] is List) {
      coursesList.addAll(
        (json['courses'] as List)
            .whereType<Map<String, dynamic>>()
            .map((c) => CourseProgressModel.fromJson(c)),
      );
    }

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
      courses: coursesList,
    );
  }

  factory ProgressSummaryModel.fromCourseList(List<CourseProgressEntity> courses) {
    int totalEnrolled = courses.length;
    int completedCourses = 0;
    int totalLessonsCompleted = 0;
    double totalPercentage = 0.0;

    for (final c in courses) {
      totalLessonsCompleted += c.completedLessons;
      totalPercentage += c.percentage;
      if (c.percentage >= 100.0) {
        completedCourses++;
      }
    }

    final avgPercentage = totalEnrolled > 0 ? totalPercentage / totalEnrolled : 0.0;

    return ProgressSummaryModel(
      totalEnrolledCourses: totalEnrolled,
      completedCourses: completedCourses,
      totalLessonsCompleted: totalLessonsCompleted,
      overallCompletionPercentage: double.parse(avgPercentage.toStringAsFixed(1)),
      courses: courses,
    );
  }
}

class CompletedLessonModel extends CompletedLessonEntity {
  const CompletedLessonModel({
    required super.id,
    required super.student,
    required super.lesson,
    required super.lessonTitle,
    required super.courseId,
    required super.courseTitle,
    required super.completedAt,
  });

  factory CompletedLessonModel.fromJson(Map<String, dynamic> json) {
    return CompletedLessonModel(
      id: json['id'] as int? ?? 0,
      student: json['student'] as int? ?? 0,
      lesson: json['lesson'] as int? ?? 0,
      lessonTitle: json['lesson_title'] as String? ?? '',
      courseId: json['course_id'] as int? ?? 0,
      courseTitle: json['course_title'] as String? ?? '',
      completedAt: json['completed_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'lesson': lesson,
      'lesson_title': lessonTitle,
      'course_id': courseId,
      'course_title': courseTitle,
      'completed_at': completedAt,
    };
  }
}

class CourseEnrollmentModel extends CourseEnrollmentEntity {
  const CourseEnrollmentModel({
    required super.id,
    required super.student,
    required super.course,
    required super.courseTitle,
    required super.enrolledAt,
  });

  factory CourseEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return CourseEnrollmentModel(
      id: json['id'] as int? ?? 0,
      student: json['student'] as int? ?? 0,
      course: json['course'] as int? ?? 0,
      courseTitle: json['course_title'] as String? ?? '',
      enrolledAt: json['enrolled_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'course': course,
      'course_title': courseTitle,
      'enrolled_at': enrolledAt,
    };
  }
}

class StudentCourseProgressModel extends StudentCourseProgressEntity {
  const StudentCourseProgressModel({
    required super.studentId,
    required super.studentName,
    required super.enrolledAt,
    required super.completedLessons,
    required super.totalLessons,
    required super.progressPercent,
  });

  factory StudentCourseProgressModel.fromJson(Map<String, dynamic> json) {
    final rawPercent = json['progress_percent'] ?? 0.0;
    return StudentCourseProgressModel(
      studentId: json['student_id'] as int? ?? 0,
      studentName: json['student_name'] as String? ?? '',
      enrolledAt: json['enrolled_at'] as String? ?? '',
      completedLessons: json['completed_lessons'] as int? ?? 0,
      totalLessons: json['total_lessons'] as int? ?? 0,
      progressPercent: double.tryParse(rawPercent.toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'enrolled_at': enrolledAt,
      'completed_lessons': completedLessons,
      'total_lessons': totalLessons,
      'progress_percent': progressPercent,
    };
  }
}

class TeacherCourseProgressModel extends TeacherCourseProgressEntity {
  const TeacherCourseProgressModel({
    required super.courseId,
    required super.courseTitle,
    required super.totalLessons,
    required super.students,
  });

  factory TeacherCourseProgressModel.fromJson(Map<String, dynamic> json) {
    final studentsList = <StudentCourseProgressEntity>[];
    if (json['students'] is List) {
      studentsList.addAll(
        (json['students'] as List)
            .whereType<Map<String, dynamic>>()
            .map((s) => StudentCourseProgressModel.fromJson(s)),
      );
    }

    return TeacherCourseProgressModel(
      courseId: json['course_id'] as int? ?? 0,
      courseTitle: json['course_title'] as String? ?? '',
      totalLessons: json['total_lessons'] as int? ?? 0,
      students: studentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_title': courseTitle,
      'total_lessons': totalLessons,
      'students': students.map((s) => (s as StudentCourseProgressModel).toJson()).toList(),
    };
  }
}
