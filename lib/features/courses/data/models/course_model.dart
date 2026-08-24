import '../../domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    super.teacher,
    super.teacherName,
    super.thumbnail,
    super.status = 'approved',
    super.isPublished = true,
    super.chaptersCount = 0,
    super.lessonsCount = 0,
    super.createdAt,
    super.updatedAt,
    super.category,
    super.price = 0.0,
    super.isApproved = true,
    super.isEnrolled = false,
    super.progressPercentage,
    super.chapters = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    var rawChapters = json['chapters'] as List<dynamic>? ?? [];
    List<ChapterModel> chapters = rawChapters
        .whereType<Map<String, dynamic>>()
        .map((c) => ChapterModel.fromJson(c))
        .toList();

    int parseLessonsCount(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return CourseModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      teacher: json['teacher'] is int
          ? json['teacher'] as int
          : int.tryParse(json['teacher']?.toString() ?? json['instructor_id']?.toString() ?? ''),
      teacherName: json['teacher_name'] as String? ?? json['instructor_name'] as String?,
      thumbnail: json['thumbnail'] as String? ?? json['image'] as String?,
      status: json['status'] as String? ?? 'approved',
      isPublished: json['is_published'] as bool? ?? true,
      chaptersCount: json['chapters_count'] is int
          ? json['chapters_count'] as int
          : int.tryParse(json['chapters_count']?.toString() ?? '0') ?? 0,
      lessonsCount: parseLessonsCount(json['lessons_count'] ?? json['total_lessons']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      category: json['category'] as String? ?? json['category_name'] as String?,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      isApproved: json['is_approved'] as bool? ?? (json['status'] == 'approved'),
      isEnrolled: json['is_enrolled'] as bool? ?? false,
      progressPercentage: json['progress_percentage'] != null
          ? double.tryParse(json['progress_percentage'].toString())
          : null,
      chapters: chapters,
    );
  }

  @override
  CourseModel copyWith({
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
    return CourseModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teacher': teacher,
      'teacher_name': teacherName,
      'thumbnail': thumbnail,
      'status': status,
      'is_published': isPublished,
      'chapters_count': chaptersCount,
      'lessons_count': lessonsCount.toString(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category,
      'price': price,
      'is_enrolled': isEnrolled,
      'chapters': chapters.map((c) => (c as ChapterModel).toJson()).toList(),
    };
  }
}

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required super.id,
    required super.course,
    required super.title,
    required super.order,
    super.createdAt,
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
      course: json['course'] is int
          ? json['course'] as int
          : int.tryParse(json['course']?.toString() ?? json['course_id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      order: json['order'] is int ? json['order'] as int : int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] as String?,
      lessons: lessons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'title': title,
      'order': order,
      'created_at': createdAt,
      'lessons': lessons.map((l) => (l as LessonModel).toJson()).toList(),
    };
  }
}

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.chapter,
    required super.title,
    super.lessonType = 'video',
    super.videoFile,
    super.pdfFile,
    super.textContent,
    super.durationMinutes = 0,
    required super.order,
    super.createdAt,
    super.isCompleted = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      chapter: json['chapter'] is int
          ? json['chapter'] as int
          : int.tryParse(json['chapter']?.toString() ?? json['chapter_id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      lessonType: json['lesson_type'] as String? ?? 'video',
      videoFile: json['video_file'] as String? ?? json['video_url'] as String?,
      pdfFile: json['pdf_file'] as String? ?? json['file_url'] as String? ?? json['file'] as String?,
      textContent: json['text_content'] as String? ?? json['content'] as String?,
      durationMinutes: json['duration_minutes'] is int
          ? json['duration_minutes'] as int
          : int.tryParse(json['duration_minutes']?.toString() ?? '0') ?? 0,
      order: json['order'] is int ? json['order'] as int : int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter': chapter,
      'title': title,
      'lesson_type': lessonType,
      'video_file': videoFile,
      'pdf_file': pdfFile,
      'text_content': textContent,
      'duration_minutes': durationMinutes,
      'order': order,
      'created_at': createdAt,
      'is_completed': isCompleted,
    };
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
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      student: json['student'] is int
          ? json['student'] as int
          : int.tryParse(json['student']?.toString() ?? '0') ?? 0,
      lesson: json['lesson'] is int
          ? json['lesson'] as int
          : int.tryParse(json['lesson']?.toString() ?? '0') ?? 0,
      lessonTitle: json['lesson_title'] as String? ?? '',
      courseId: json['course_id'] is int
          ? json['course_id'] as int
          : int.tryParse(json['course_id']?.toString() ?? '0') ?? 0,
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
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      student: json['student'] is int
          ? json['student'] as int
          : int.tryParse(json['student']?.toString() ?? '0') ?? 0,
      course: json['course'] is int
          ? json['course'] as int
          : int.tryParse(json['course']?.toString() ?? '0') ?? 0,
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
