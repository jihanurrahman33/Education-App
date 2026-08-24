import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  ResultFuture<List<CourseEntity>> getCourses({
    String? category,
    String? searchQuery,
    int? page,
  });

  ResultFuture<List<CourseEntity>> getApprovedCourses({int? page});

  ResultFuture<List<CourseEntity>> getTeacherCourses({int? page});

  ResultFuture<CourseEntity> getCourseDetails(int courseId);

  ResultFuture<List<ChapterEntity>> getCourseCurriculum(int courseId);

  ResultFuture<void> enrollInCourse(int courseId);

  ResultFuture<List<CourseEntity>> getMyEnrolledCourses();

  ResultFuture<CourseEntity> createCourse({
    required String title,
    required String description,
    bool isPublished = false,
    String? category,
    double? price,
  });

  ResultFuture<CourseEntity> updateCourse({
    required int id,
    required String title,
    String? description,
    bool? isPublished,
  });

  ResultFuture<CourseEntity> patchCourse({
    required int id,
    String? title,
    String? description,
    bool? isPublished,
  });

  ResultVoid deleteCourse(int id);

  ResultFuture<CourseEntity> togglePublish(int courseId);

  ResultFuture<List<ChapterEntity>> getChapters({int? page, int? courseId});

  ResultFuture<ChapterEntity> getChapterById(int chapterId);

  ResultFuture<ChapterEntity> createChapter({
    required int courseId,
    required String title,
    int order = 0,
  });

  ResultFuture<ChapterEntity> updateChapter({
    required int id,
    required int courseId,
    required String title,
    int order = 0,
  });

  ResultFuture<ChapterEntity> patchChapter({
    required int id,
    int? courseId,
    String? title,
    int? order,
  });

  ResultVoid deleteChapter(int id);

  ResultFuture<List<LessonEntity>> getLessons({int? chapterId, int? page});

  ResultFuture<LessonEntity> getLessonById(int lessonId);

  ResultFuture<LessonEntity> createLesson({
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int durationMinutes = 0,
    int order = 0,
  });

  ResultFuture<LessonEntity> updateLesson({
    required int id,
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    int durationMinutes = 0,
    int order = 0,
  });

  ResultFuture<LessonEntity> patchLesson({
    required int lessonId,
    int? chapterId,
    String? title,
    String? lessonType,
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int? durationMinutes,
    int? order,
  });

  ResultVoid deleteLesson(int lessonId);
}
