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
  final CourseEntity? selectedCourse;
  final List<ChapterEntity> curriculum;
  final String? errorMessage;
  final bool isEnrolling;

  const CourseState({
    this.status = CourseStatus.initial,
    this.courses = const [],
    this.selectedCourse,
    this.curriculum = const [],
    this.errorMessage,
    this.isEnrolling = false,
  });

  CourseState copyWith({
    CourseStatus? status,
    List<CourseEntity>? courses,
    CourseEntity? selectedCourse,
    List<ChapterEntity>? curriculum,
    String? errorMessage,
    bool? isEnrolling,
  }) {
    return CourseState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      curriculum: curriculum ?? this.curriculum,
      errorMessage: errorMessage,
      isEnrolling: isEnrolling ?? this.isEnrolling,
    );
  }

  @override
  List<Object?> get props => [
        status,
        courses,
        selectedCourse,
        curriculum,
        errorMessage,
        isEnrolling,
      ];
}
