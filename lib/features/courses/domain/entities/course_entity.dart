import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final int? teacher;
  final String? teacherName;
  final String? thumbnail;
  final String status;
  final bool isPublished;
  final int chaptersCount;
  final int lessonsCount;
  final String? createdAt;
  final String? updatedAt;
  final String? category;
  final double price;
  final bool isApproved;
  final bool isEnrolled;
  final double? progressPercentage;
  final List<ChapterEntity> chapters;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    this.teacher,
    this.teacherName,
    this.thumbnail,
    this.status = 'approved',
    this.isPublished = true,
    this.chaptersCount = 0,
    this.lessonsCount = 0,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.price = 0.0,
    this.isApproved = true,
    this.isEnrolled = false,
    this.progressPercentage,
    this.chapters = const [],
  });

  // Backward-compatible alias helpers
  String? get instructorName => teacherName;
  int? get instructorId => teacher;
  int get totalLessons => lessonsCount;

  CourseEntity copyWith({
    int? id,
    String? title,
    String? description,
    int? teacher,
    String? teacherName,
    String? thumbnail,
    String? status,
    bool? isPublished,
    int? chaptersCount,
    int? lessonsCount,
    String? createdAt,
    String? updatedAt,
    String? category,
    double? price,
    bool? isApproved,
    bool? isEnrolled,
    double? progressPercentage,
    List<ChapterEntity>? chapters,
  }) {
    return CourseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      teacher: teacher ?? this.teacher,
      teacherName: teacherName ?? this.teacherName,
      thumbnail: thumbnail ?? this.thumbnail,
      status: status ?? this.status,
      isPublished: isPublished ?? this.isPublished,
      chaptersCount: chaptersCount ?? this.chaptersCount,
      lessonsCount: lessonsCount ?? this.lessonsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      price: price ?? this.price,
      isApproved: isApproved ?? this.isApproved,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      chapters: chapters ?? this.chapters,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        teacher,
        teacherName,
        thumbnail,
        status,
        isPublished,
        chaptersCount,
        lessonsCount,
        createdAt,
        updatedAt,
        category,
        price,
        isApproved,
        isEnrolled,
        progressPercentage,
        chapters,
      ];
}

class ChapterEntity extends Equatable {
  final int id;
  final int course;
  final String title;
  final int order;
  final String? createdAt;
  final List<LessonEntity> lessons;

  const ChapterEntity({
    required this.id,
    required this.course,
    required this.title,
    required this.order,
    this.createdAt,
    this.lessons = const [],
  });

  int get courseId => course;

  @override
  List<Object?> get props => [id, course, title, order, createdAt, lessons];
}

class LessonEntity extends Equatable {
  final int id;
  final int chapter;
  final String title;
  final String lessonType;
  final String? videoFile;
  final String? pdfFile;
  final String? textContent;
  final int durationMinutes;
  final int order;
  final String? createdAt;
  final bool isCompleted;

  const LessonEntity({
    required this.id,
    required this.chapter,
    required this.title,
    this.lessonType = 'video',
    this.videoFile,
    this.pdfFile,
    this.textContent,
    this.durationMinutes = 0,
    required this.order,
    this.createdAt,
    this.isCompleted = false,
  });

  // Backward-compatible alias helpers
  int get chapterId => chapter;
  String? get videoUrl => videoFile;
  String? get fileUrl => pdfFile;
  String? get content => textContent;

  @override
  List<Object?> get props => [
        id,
        chapter,
        title,
        lessonType,
        videoFile,
        pdfFile,
        textContent,
        durationMinutes,
        order,
        createdAt,
        isCompleted,
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
