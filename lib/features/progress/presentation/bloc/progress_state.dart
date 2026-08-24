import 'package:equatable/equatable.dart';
import '../../../certificates/domain/entities/certificate_entity.dart';
import '../../domain/entities/progress_entity.dart';

enum ProgressStatus { initial, loading, success, failure }

class ProgressState extends Equatable {
  final ProgressStatus status;
  final ProgressSummaryEntity? summary;
  final List<CourseProgressEntity> myProgress;
  final Map<int, CourseProgressEntity> courseProgressMap;
  final List<CourseEnrollmentEntity> enrollments;
  final List<CompletedLessonEntity> completedLessons;
  final List<CertificateEntity> certificates;
  final TeacherCourseProgressEntity? teacherCourseProgress;
  final String? errorMessage;
  final String? successMessage;

  const ProgressState({
    this.status = ProgressStatus.initial,
    this.summary,
    this.myProgress = const [],
    this.courseProgressMap = const {},
    this.enrollments = const [],
    this.completedLessons = const [],
    this.certificates = const [],
    this.teacherCourseProgress,
    this.errorMessage,
    this.successMessage,
  });

  ProgressState copyWith({
    ProgressStatus? status,
    ProgressSummaryEntity? summary,
    List<CourseProgressEntity>? myProgress,
    Map<int, CourseProgressEntity>? courseProgressMap,
    List<CourseEnrollmentEntity>? enrollments,
    List<CompletedLessonEntity>? completedLessons,
    List<CertificateEntity>? certificates,
    TeacherCourseProgressEntity? teacherCourseProgress,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return ProgressState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      myProgress: myProgress ?? this.myProgress,
      courseProgressMap: courseProgressMap ?? this.courseProgressMap,
      enrollments: enrollments ?? this.enrollments,
      completedLessons: completedLessons ?? this.completedLessons,
      certificates: certificates ?? this.certificates,
      teacherCourseProgress: teacherCourseProgress ?? this.teacherCourseProgress,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        summary,
        myProgress,
        courseProgressMap,
        enrollments,
        completedLessons,
        certificates,
        teacherCourseProgress,
        errorMessage,
        successMessage,
      ];
}
