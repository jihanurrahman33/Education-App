import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? instructorName;
  final int? instructorId;
  final String? category;
  final String? thumbnail;
  final double price;
  final bool isPublished;
  final bool isApproved;
  final int totalLessons;
  final int totalDurationMinutes;
  final double? progressPercentage;
  final bool isEnrolled;
  final List<ChapterEntity> chapters;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    this.instructorName,
    this.instructorId,
    this.category,
    this.thumbnail,
    this.price = 0.0,
    this.isPublished = false,
    this.isApproved = false,
    this.totalLessons = 0,
    this.totalDurationMinutes = 0,
    this.progressPercentage,
    this.isEnrolled = false,
    this.chapters = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructorName,
        instructorId,
        category,
        thumbnail,
        price,
        isPublished,
        isApproved,
        totalLessons,
        totalDurationMinutes,
        progressPercentage,
        isEnrolled,
        chapters,
      ];
}

class ChapterEntity extends Equatable {
  final int id;
  final int courseId;
  final String title;
  final int order;
  final List<LessonEntity> lessons;

  const ChapterEntity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.order,
    this.lessons = const [],
  });

  @override
  List<Object?> get props => [id, courseId, title, order, lessons];
}

class LessonEntity extends Equatable {
  final int id;
  final int chapterId;
  final String title;
  final String? content;
  final String? videoUrl;
  final String? fileUrl;
  final int durationMinutes;
  final int order;
  final bool isCompleted;

  const LessonEntity({
    required this.id,
    required this.chapterId,
    required this.title,
    this.content,
    this.videoUrl,
    this.fileUrl,
    this.durationMinutes = 0,
    required this.order,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        chapterId,
        title,
        content,
        videoUrl,
        fileUrl,
        durationMinutes,
        order,
        isCompleted,
      ];
}
