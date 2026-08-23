import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoursesRequested extends CourseEvent {
  final String? category;
  final String? searchQuery;

  const FetchCoursesRequested({this.category, this.searchQuery});

  @override
  List<Object?> get props => [category, searchQuery];
}

class FetchCourseDetailsRequested extends CourseEvent {
  final int courseId;

  const FetchCourseDetailsRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class EnrollCourseRequested extends CourseEvent {
  final int courseId;

  const EnrollCourseRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
