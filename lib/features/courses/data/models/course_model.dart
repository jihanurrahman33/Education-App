import '../../domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    super.instructorName,
    super.instructorId,
    super.category,
    super.thumbnail,
    super.price = 0.0,
    super.isPublished = false,
    super.isApproved = false,
    super.totalLessons = 0,
    super.totalDurationMinutes = 0,
    super.progressPercentage,
    super.isEnrolled = false,
    super.chapters = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    var rawChapters = json['chapters'] as List<dynamic>? ?? [];
    List<ChapterModel> chapters = rawChapters
        .whereType<Map<String, dynamic>>()
        .map((c) => ChapterModel.fromJson(c))
        .toList();

    return CourseModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instructorName: json['instructor_name'] as String? ?? json['teacher_name'] as String?,
      instructorId: json['instructor_id'] is int
          ? json['instructor_id'] as int
          : int.tryParse(json['instructor_id']?.toString() ?? ''),
      category: json['category'] as String? ?? json['category_name'] as String?,
      thumbnail: json['thumbnail'] as String? ?? json['image'] as String?,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      isPublished: json['is_published'] as bool? ?? false,
      isApproved: json['is_approved'] as bool? ?? false,
      totalLessons: json['total_lessons'] is int
          ? json['total_lessons'] as int
          : int.tryParse(json['total_lessons']?.toString() ?? '0') ?? 0,
      totalDurationMinutes: json['total_duration_minutes'] is int
          ? json['total_duration_minutes'] as int
          : int.tryParse(json['total_duration_minutes']?.toString() ?? '0') ?? 0,
      progressPercentage: json['progress_percentage'] != null
          ? double.tryParse(json['progress_percentage'].toString())
          : null,
      isEnrolled: json['is_enrolled'] as bool? ?? false,
      chapters: chapters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor_name': instructorName,
      'instructor_id': instructorId,
      'category': category,
      'thumbnail': thumbnail,
      'price': price,
      'is_published': isPublished,
      'is_approved': isApproved,
      'total_lessons': totalLessons,
      'total_duration_minutes': totalDurationMinutes,
      'progress_percentage': progressPercentage,
      'is_enrolled': isEnrolled,
      'chapters': chapters.map((c) => (c as ChapterModel).toJson()).toList(),
    };
  }
}

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.order,
    super.lessons = const [],
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    var rawLessons = json['lessons'] as List<dynamic>? ?? [];
    List<LessonModel> lessons = rawLessons
        .whereType<Map<String, dynamic>>()
        .map((l) => LessonModel.fromJson(l))
        .toList();

    return ChapterModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      courseId: json['course_id'] is int
          ? json['course_id'] as int
          : int.tryParse(json['course']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      order: json['order'] is int ? json['order'] as int : int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      lessons: lessons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'order': order,
      'lessons': lessons.map((l) => (l as LessonModel).toJson()).toList(),
    };
  }
}

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.chapterId,
    required super.title,
    super.content,
    super.videoUrl,
    super.fileUrl,
    super.durationMinutes = 0,
    required super.order,
    super.isCompleted = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      chapterId: json['chapter_id'] is int
          ? json['chapter_id'] as int
          : int.tryParse(json['chapter']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String?,
      videoUrl: json['video_url'] as String?,
      fileUrl: json['file_url'] as String? ?? json['file'] as String?,
      durationMinutes: json['duration_minutes'] is int
          ? json['duration_minutes'] as int
          : int.tryParse(json['duration_minutes']?.toString() ?? '0') ?? 0,
      order: json['order'] is int ? json['order'] as int : int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'title': title,
      'content': content,
      'video_url': videoUrl,
      'file_url': fileUrl,
      'duration_minutes': durationMinutes,
      'order': order,
      'is_completed': isCompleted,
    };
  }
}
