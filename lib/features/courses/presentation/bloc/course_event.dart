import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoursesRequested extends CourseEvent {
  final String? category;
  final String? searchQuery;
  final int? page;

  const FetchCoursesRequested({this.category, this.searchQuery, this.page});

  @override
  List<Object?> get props => [category, searchQuery, page];
}

class FetchApprovedCoursesRequested extends CourseEvent {
  final int? page;

  const FetchApprovedCoursesRequested({this.page});

  @override
  List<Object?> get props => [page];
}

class FetchTeacherCoursesRequested extends CourseEvent {
  final int? page;

  const FetchTeacherCoursesRequested({this.page});

  @override
  List<Object?> get props => [page];
}

class FetchCourseDetailsRequested extends CourseEvent {
  final int courseId;

  const FetchCourseDetailsRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class CreateCourseRequested extends CourseEvent {
  final String title;
  final String description;
  final bool isPublished;

  const CreateCourseRequested({
    required this.title,
    required this.description,
    this.isPublished = false,
  });

  @override
  List<Object?> get props => [title, description, isPublished];
}

class UpdateCourseRequested extends CourseEvent {
  final int courseId;
  final String title;
  final String description;
  final bool isPublished;

  const UpdateCourseRequested({
    required this.courseId,
    required this.title,
    required this.description,
    required this.isPublished,
  });

  @override
  List<Object?> get props => [courseId, title, description, isPublished];
}

class TogglePublishCourseRequested extends CourseEvent {
  final int courseId;

  const TogglePublishCourseRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class DeleteCourseRequested extends CourseEvent {
  final int courseId;

  const DeleteCourseRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class CreateChapterRequested extends CourseEvent {
  final int courseId;
  final String title;
  final int order;

  const CreateChapterRequested({
    required this.courseId,
    required this.title,
    this.order = 1,
  });

  @override
  List<Object?> get props => [courseId, title, order];
}

class UpdateChapterRequested extends CourseEvent {
  final int chapterId;
  final int courseId;
  final String title;
  final int order;

  const UpdateChapterRequested({
    required this.chapterId,
    required this.courseId,
    required this.title,
    required this.order,
  });

  @override
  List<Object?> get props => [chapterId, courseId, title, order];
}

class DeleteChapterRequested extends CourseEvent {
  final int chapterId;
  final int courseId;

  const DeleteChapterRequested({required this.chapterId, required this.courseId});

  @override
  List<Object?> get props => [chapterId, courseId];
}

class CreateLessonRequested extends CourseEvent {
  final int chapterId;
  final String title;
  final String lessonType;
  final String? textContent;
  final int durationMinutes;
  final int order;
  final String? videoFilePath;
  final String? pdfFilePath;

  const CreateLessonRequested({
    required this.chapterId,
    required this.title,
    required this.lessonType,
    this.textContent,
    this.durationMinutes = 0,
    this.order = 1,
    this.videoFilePath,
    this.pdfFilePath,
  });

  @override
  List<Object?> get props => [
        chapterId,
        title,
        lessonType,
        textContent,
        durationMinutes,
        order,
        videoFilePath,
        pdfFilePath,
      ];
}

class DeleteLessonRequested extends CourseEvent {
  final int lessonId;
  final int courseId;

  const DeleteLessonRequested({required this.lessonId, required this.courseId});

  @override
  List<Object?> get props => [lessonId, courseId];
}

class EnrollCourseRequested extends CourseEvent {
  final int courseId;

  const EnrollCourseRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
