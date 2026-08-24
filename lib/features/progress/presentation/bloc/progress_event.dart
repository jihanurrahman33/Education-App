import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgressSummaryEvent extends ProgressEvent {
  const LoadProgressSummaryEvent();
}

class LoadMyProgressEvent extends ProgressEvent {
  const LoadMyProgressEvent();
}

class LoadCourseProgressEvent extends ProgressEvent {
  final int courseId;

  const LoadCourseProgressEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class EnrollCourseProgressEvent extends ProgressEvent {
  final int courseId;

  const EnrollCourseProgressEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class CompleteLessonProgressEvent extends ProgressEvent {
  final int lessonId;
  final int? courseId;

  const CompleteLessonProgressEvent({required this.lessonId, this.courseId});

  @override
  List<Object?> get props => [lessonId, courseId];
}

class LoadCompletedLessonsEvent extends ProgressEvent {
  final int? page;

  const LoadCompletedLessonsEvent({this.page});

  @override
  List<Object?> get props => [page];
}

class LoadEnrollmentsEvent extends ProgressEvent {
  final int? page;

  const LoadEnrollmentsEvent({this.page});

  @override
  List<Object?> get props => [page];
}

class GenerateCertificateProgressEvent extends ProgressEvent {
  final int courseId;

  const GenerateCertificateProgressEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class LoadTeacherCourseStudentsProgressEvent extends ProgressEvent {
  final int courseId;

  const LoadTeacherCourseStudentsProgressEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
