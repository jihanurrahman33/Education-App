import 'package:equatable/equatable.dart';
import '../../domain/entities/course_entity.dart';

enum CourseStatus {
  initial,
  loading,
  loaded,
  error;

  bool get isInitial => this == CourseStatus.initial;
  bool get isLoading => this == CourseStatus.loading;
  bool get isLoaded => this == CourseStatus.loaded;
  bool get isError => this == CourseStatus.error;
}

class CourseState extends Equatable {
  final CourseStatus status;
  final List<CourseEntity> courses;
  final List<CourseEntity> approvedCourses;
  final List<CourseEntity> teacherCourses;
  final CourseEntity? selectedCourse;
  final List<ChapterEntity> curriculum;
  final String? errorMessage;
  final String? successMessage;
  final bool isEnrolling;

  const CourseState({
    this.status = CourseStatus.initial,
    this.courses = const [],
    this.approvedCourses = const [],
    this.teacherCourses = const [],
    this.selectedCourse,
    this.curriculum = const [],
    this.errorMessage,
    this.successMessage,
    this.isEnrolling = false,
  });

  CourseState copyWith({
    CourseStatus? status,
    List<CourseEntity>? courses,
    List<CourseEntity>? approvedCourses,
    List<CourseEntity>? teacherCourses,
    CourseEntity? selectedCourse,
    List<ChapterEntity>? curriculum,
    String? errorMessage,
    String? successMessage,
    bool? isEnrolling,
    bool clearMessages = false,
  }) {
    return CourseState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      approvedCourses: approvedCourses ?? this.approvedCourses,
      teacherCourses: teacherCourses ?? this.teacherCourses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      curriculum: curriculum ?? this.curriculum,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      isEnrolling: isEnrolling ?? this.isEnrolling,
    );
  }

  @override
  List<Object?> get props => [
        status,
        courses,
        approvedCourses,
        teacherCourses,
        selectedCourse,
        curriculum,
        errorMessage,
        successMessage,
        isEnrolling,
      ];
}
